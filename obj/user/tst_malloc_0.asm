
obj/user/tst_malloc_0:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 a3 01 00 00       	call   8001d9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800049:	eb 29                	jmp    800074 <_main+0x3c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004b:	a1 20 40 80 00       	mov    0x804020,%eax
  800050:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800056:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800059:	89 d0                	mov    %edx,%eax
  80005b:	01 c0                	add    %eax,%eax
  80005d:	01 d0                	add    %edx,%eax
  80005f:	c1 e0 03             	shl    $0x3,%eax
  800062:	01 c8                	add    %ecx,%eax
  800064:	8a 40 04             	mov    0x4(%eax),%al
  800067:	84 c0                	test   %al,%al
  800069:	74 06                	je     800071 <_main+0x39>
			{
				fullWS = 0;
  80006b:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006f:	eb 12                	jmp    800083 <_main+0x4b>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800071:	ff 45 f0             	incl   -0x10(%ebp)
  800074:	a1 20 40 80 00       	mov    0x804020,%eax
  800079:	8b 50 74             	mov    0x74(%eax),%edx
  80007c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007f:	39 c2                	cmp    %eax,%edx
  800081:	77 c8                	ja     80004b <_main+0x13>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800083:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800087:	74 14                	je     80009d <_main+0x65>
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	68 60 31 80 00       	push   $0x803160
  800091:	6a 14                	push   $0x14
  800093:	68 7c 31 80 00       	push   $0x80317c
  800098:	e8 78 02 00 00       	call   800315 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	if(STATIC_MEMBLOCK_ALLOC != 0)
		panic("STATIC_MEMBLOCK_ALLOC = 1 & it shall be 0. Go to 'inc/dynamic_allocator.h' and set STATIC_MEMBLOCK_ALLOC by 0. Then, repeat the test again.");

	int freeFrames_before = sys_calculate_free_frames() ;
  80009d:	e8 c5 18 00 00       	call   801967 <sys_calculate_free_frames>
  8000a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeDiskFrames_before = sys_pf_calculate_allocated_pages() ;
  8000a5:	e8 5d 19 00 00       	call   801a07 <sys_pf_calculate_allocated_pages>
  8000aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
	malloc(0);
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	e8 a4 14 00 00       	call   80155b <malloc>
  8000b7:	83 c4 10             	add    $0x10,%esp
	int freeFrames_after = sys_calculate_free_frames() ;
  8000ba:	e8 a8 18 00 00       	call   801967 <sys_calculate_free_frames>
  8000bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int freeDiskFrames_after = sys_pf_calculate_allocated_pages() ;
  8000c2:	e8 40 19 00 00       	call   801a07 <sys_pf_calculate_allocated_pages>
  8000c7:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Check MAX_MEM_BLOCK_CNT
	if(MAX_MEM_BLOCK_CNT != ((0xA0000000-0x80000000)/4096))
  8000ca:	a1 20 41 80 00       	mov    0x804120,%eax
  8000cf:	3d 00 00 02 00       	cmp    $0x20000,%eax
  8000d4:	74 14                	je     8000ea <_main+0xb2>
	{
		panic("Wrong initialize: MAX_MEM_BLOCK_CNT is not set with the correct size of the array");
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 90 31 80 00       	push   $0x803190
  8000de:	6a 23                	push   $0x23
  8000e0:	68 7c 31 80 00       	push   $0x80317c
  8000e5:	e8 2b 02 00 00       	call   800315 <_panic>
	}

	//Check number of nodes in AvailableMemBlocksList
	if (LIST_SIZE(&(AvailableMemBlocksList)) != MAX_MEM_BLOCK_CNT-1)
  8000ea:	a1 54 41 80 00       	mov    0x804154,%eax
  8000ef:	8b 15 20 41 80 00    	mov    0x804120,%edx
  8000f5:	4a                   	dec    %edx
  8000f6:	39 d0                	cmp    %edx,%eax
  8000f8:	74 14                	je     80010e <_main+0xd6>
	{
		panic("Wrong initialize: Wrong size for the AvailableMemBlocksList");
  8000fa:	83 ec 04             	sub    $0x4,%esp
  8000fd:	68 e4 31 80 00       	push   $0x8031e4
  800102:	6a 29                	push   $0x29
  800104:	68 7c 31 80 00       	push   $0x80317c
  800109:	e8 07 02 00 00       	call   800315 <_panic>
	}

	//Check number of nodes in AllocMemBlocksList
	if (LIST_SIZE(&(AllocMemBlocksList)) != 0)
  80010e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  800113:	85 c0                	test   %eax,%eax
  800115:	74 14                	je     80012b <_main+0xf3>
	{
		panic("Wrong initialize: Wrong size for the AllocMemBlocksList");
  800117:	83 ec 04             	sub    $0x4,%esp
  80011a:	68 20 32 80 00       	push   $0x803220
  80011f:	6a 2f                	push   $0x2f
  800121:	68 7c 31 80 00       	push   $0x80317c
  800126:	e8 ea 01 00 00       	call   800315 <_panic>
	}

	//Check number of nodes in FreeMemBlocksList
	if (LIST_SIZE(&(FreeMemBlocksList)) != 1)
  80012b:	a1 44 41 80 00       	mov    0x804144,%eax
  800130:	83 f8 01             	cmp    $0x1,%eax
  800133:	74 14                	je     800149 <_main+0x111>
	{
		panic("Wrong initialize: Wrong size for the FreeMemBlocksList");
  800135:	83 ec 04             	sub    $0x4,%esp
  800138:	68 58 32 80 00       	push   $0x803258
  80013d:	6a 35                	push   $0x35
  80013f:	68 7c 31 80 00       	push   $0x80317c
  800144:	e8 cc 01 00 00       	call   800315 <_panic>
	}

	//Check content of FreeMemBlocksList
	struct MemBlock* block = LIST_FIRST(&FreeMemBlocksList);
  800149:	a1 38 41 80 00       	mov    0x804138,%eax
  80014e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(block == NULL || block->size != (0xA0000000-0x80000000) || block->sva != 0x80000000)
  800151:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800155:	74 1a                	je     800171 <_main+0x139>
  800157:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80015a:	8b 40 0c             	mov    0xc(%eax),%eax
  80015d:	3d 00 00 00 20       	cmp    $0x20000000,%eax
  800162:	75 0d                	jne    800171 <_main+0x139>
  800164:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800167:	8b 40 08             	mov    0x8(%eax),%eax
  80016a:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80016f:	74 14                	je     800185 <_main+0x14d>
	{
		panic("Wrong initialize: Wrong content for the FreeMemBlocksList.");
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	68 90 32 80 00       	push   $0x803290
  800179:	6a 3c                	push   $0x3c
  80017b:	68 7c 31 80 00       	push   $0x80317c
  800180:	e8 90 01 00 00       	call   800315 <_panic>
	}

	//Check number of disk and memory frames
	if ((freeDiskFrames_after - freeDiskFrames_before) != 0) panic("Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)");
  800185:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800188:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80018b:	74 14                	je     8001a1 <_main+0x169>
  80018d:	83 ec 04             	sub    $0x4,%esp
  800190:	68 cc 32 80 00       	push   $0x8032cc
  800195:	6a 40                	push   $0x40
  800197:	68 7c 31 80 00       	push   $0x80317c
  80019c:	e8 74 01 00 00       	call   800315 <_panic>
	if ((freeFrames_before - freeFrames_after) != 512 + 1) panic("Wrong allocation: pages are not loaded successfully into memory %d", (freeFrames_before - freeFrames_after));
  8001a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001a4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001a7:	3d 01 02 00 00       	cmp    $0x201,%eax
  8001ac:	74 18                	je     8001c6 <_main+0x18e>
  8001ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001b1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001b4:	50                   	push   %eax
  8001b5:	68 34 33 80 00       	push   $0x803334
  8001ba:	6a 41                	push   $0x41
  8001bc:	68 7c 31 80 00       	push   $0x80317c
  8001c1:	e8 4f 01 00 00       	call   800315 <_panic>

	/*=================================================*/

	cprintf("Congratulations!! test initialize_dyn_block_system of UHEAP completed successfully.\n");
  8001c6:	83 ec 0c             	sub    $0xc,%esp
  8001c9:	68 78 33 80 00       	push   $0x803378
  8001ce:	e8 f6 03 00 00       	call   8005c9 <cprintf>
  8001d3:	83 c4 10             	add    $0x10,%esp

	return;
  8001d6:	90                   	nop
}
  8001d7:	c9                   	leave  
  8001d8:	c3                   	ret    

008001d9 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001d9:	55                   	push   %ebp
  8001da:	89 e5                	mov    %esp,%ebp
  8001dc:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001df:	e8 63 1a 00 00       	call   801c47 <sys_getenvindex>
  8001e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001ea:	89 d0                	mov    %edx,%eax
  8001ec:	c1 e0 03             	shl    $0x3,%eax
  8001ef:	01 d0                	add    %edx,%eax
  8001f1:	01 c0                	add    %eax,%eax
  8001f3:	01 d0                	add    %edx,%eax
  8001f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001fc:	01 d0                	add    %edx,%eax
  8001fe:	c1 e0 04             	shl    $0x4,%eax
  800201:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800206:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80020b:	a1 20 40 80 00       	mov    0x804020,%eax
  800210:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800216:	84 c0                	test   %al,%al
  800218:	74 0f                	je     800229 <libmain+0x50>
		binaryname = myEnv->prog_name;
  80021a:	a1 20 40 80 00       	mov    0x804020,%eax
  80021f:	05 5c 05 00 00       	add    $0x55c,%eax
  800224:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800229:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80022d:	7e 0a                	jle    800239 <libmain+0x60>
		binaryname = argv[0];
  80022f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800232:	8b 00                	mov    (%eax),%eax
  800234:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800239:	83 ec 08             	sub    $0x8,%esp
  80023c:	ff 75 0c             	pushl  0xc(%ebp)
  80023f:	ff 75 08             	pushl  0x8(%ebp)
  800242:	e8 f1 fd ff ff       	call   800038 <_main>
  800247:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80024a:	e8 05 18 00 00       	call   801a54 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	68 e8 33 80 00       	push   $0x8033e8
  800257:	e8 6d 03 00 00       	call   8005c9 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80025f:	a1 20 40 80 00       	mov    0x804020,%eax
  800264:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80026a:	a1 20 40 80 00       	mov    0x804020,%eax
  80026f:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800275:	83 ec 04             	sub    $0x4,%esp
  800278:	52                   	push   %edx
  800279:	50                   	push   %eax
  80027a:	68 10 34 80 00       	push   $0x803410
  80027f:	e8 45 03 00 00       	call   8005c9 <cprintf>
  800284:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800287:	a1 20 40 80 00       	mov    0x804020,%eax
  80028c:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800292:	a1 20 40 80 00       	mov    0x804020,%eax
  800297:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80029d:	a1 20 40 80 00       	mov    0x804020,%eax
  8002a2:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002a8:	51                   	push   %ecx
  8002a9:	52                   	push   %edx
  8002aa:	50                   	push   %eax
  8002ab:	68 38 34 80 00       	push   $0x803438
  8002b0:	e8 14 03 00 00       	call   8005c9 <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002b8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002bd:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	50                   	push   %eax
  8002c7:	68 90 34 80 00       	push   $0x803490
  8002cc:	e8 f8 02 00 00       	call   8005c9 <cprintf>
  8002d1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002d4:	83 ec 0c             	sub    $0xc,%esp
  8002d7:	68 e8 33 80 00       	push   $0x8033e8
  8002dc:	e8 e8 02 00 00       	call   8005c9 <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002e4:	e8 85 17 00 00       	call   801a6e <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002e9:	e8 19 00 00 00       	call   800307 <exit>
}
  8002ee:	90                   	nop
  8002ef:	c9                   	leave  
  8002f0:	c3                   	ret    

008002f1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	6a 00                	push   $0x0
  8002fc:	e8 12 19 00 00       	call   801c13 <sys_destroy_env>
  800301:	83 c4 10             	add    $0x10,%esp
}
  800304:	90                   	nop
  800305:	c9                   	leave  
  800306:	c3                   	ret    

00800307 <exit>:

void
exit(void)
{
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80030d:	e8 67 19 00 00       	call   801c79 <sys_exit_env>
}
  800312:	90                   	nop
  800313:	c9                   	leave  
  800314:	c3                   	ret    

00800315 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80031b:	8d 45 10             	lea    0x10(%ebp),%eax
  80031e:	83 c0 04             	add    $0x4,%eax
  800321:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800324:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800329:	85 c0                	test   %eax,%eax
  80032b:	74 16                	je     800343 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80032d:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800332:	83 ec 08             	sub    $0x8,%esp
  800335:	50                   	push   %eax
  800336:	68 a4 34 80 00       	push   $0x8034a4
  80033b:	e8 89 02 00 00       	call   8005c9 <cprintf>
  800340:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800343:	a1 00 40 80 00       	mov    0x804000,%eax
  800348:	ff 75 0c             	pushl  0xc(%ebp)
  80034b:	ff 75 08             	pushl  0x8(%ebp)
  80034e:	50                   	push   %eax
  80034f:	68 a9 34 80 00       	push   $0x8034a9
  800354:	e8 70 02 00 00       	call   8005c9 <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80035c:	8b 45 10             	mov    0x10(%ebp),%eax
  80035f:	83 ec 08             	sub    $0x8,%esp
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	50                   	push   %eax
  800366:	e8 f3 01 00 00       	call   80055e <vcprintf>
  80036b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80036e:	83 ec 08             	sub    $0x8,%esp
  800371:	6a 00                	push   $0x0
  800373:	68 c5 34 80 00       	push   $0x8034c5
  800378:	e8 e1 01 00 00       	call   80055e <vcprintf>
  80037d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800380:	e8 82 ff ff ff       	call   800307 <exit>

	// should not return here
	while (1) ;
  800385:	eb fe                	jmp    800385 <_panic+0x70>

00800387 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800387:	55                   	push   %ebp
  800388:	89 e5                	mov    %esp,%ebp
  80038a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80038d:	a1 20 40 80 00       	mov    0x804020,%eax
  800392:	8b 50 74             	mov    0x74(%eax),%edx
  800395:	8b 45 0c             	mov    0xc(%ebp),%eax
  800398:	39 c2                	cmp    %eax,%edx
  80039a:	74 14                	je     8003b0 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80039c:	83 ec 04             	sub    $0x4,%esp
  80039f:	68 c8 34 80 00       	push   $0x8034c8
  8003a4:	6a 26                	push   $0x26
  8003a6:	68 14 35 80 00       	push   $0x803514
  8003ab:	e8 65 ff ff ff       	call   800315 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003be:	e9 c2 00 00 00       	jmp    800485 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d0:	01 d0                	add    %edx,%eax
  8003d2:	8b 00                	mov    (%eax),%eax
  8003d4:	85 c0                	test   %eax,%eax
  8003d6:	75 08                	jne    8003e0 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003d8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003db:	e9 a2 00 00 00       	jmp    800482 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003ee:	eb 69                	jmp    800459 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003f0:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003fe:	89 d0                	mov    %edx,%eax
  800400:	01 c0                	add    %eax,%eax
  800402:	01 d0                	add    %edx,%eax
  800404:	c1 e0 03             	shl    $0x3,%eax
  800407:	01 c8                	add    %ecx,%eax
  800409:	8a 40 04             	mov    0x4(%eax),%al
  80040c:	84 c0                	test   %al,%al
  80040e:	75 46                	jne    800456 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800410:	a1 20 40 80 00       	mov    0x804020,%eax
  800415:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80041b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80041e:	89 d0                	mov    %edx,%eax
  800420:	01 c0                	add    %eax,%eax
  800422:	01 d0                	add    %edx,%eax
  800424:	c1 e0 03             	shl    $0x3,%eax
  800427:	01 c8                	add    %ecx,%eax
  800429:	8b 00                	mov    (%eax),%eax
  80042b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80042e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800431:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800436:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80043b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800442:	8b 45 08             	mov    0x8(%ebp),%eax
  800445:	01 c8                	add    %ecx,%eax
  800447:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800449:	39 c2                	cmp    %eax,%edx
  80044b:	75 09                	jne    800456 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80044d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800454:	eb 12                	jmp    800468 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800456:	ff 45 e8             	incl   -0x18(%ebp)
  800459:	a1 20 40 80 00       	mov    0x804020,%eax
  80045e:	8b 50 74             	mov    0x74(%eax),%edx
  800461:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800464:	39 c2                	cmp    %eax,%edx
  800466:	77 88                	ja     8003f0 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800468:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80046c:	75 14                	jne    800482 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80046e:	83 ec 04             	sub    $0x4,%esp
  800471:	68 20 35 80 00       	push   $0x803520
  800476:	6a 3a                	push   $0x3a
  800478:	68 14 35 80 00       	push   $0x803514
  80047d:	e8 93 fe ff ff       	call   800315 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800482:	ff 45 f0             	incl   -0x10(%ebp)
  800485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800488:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80048b:	0f 8c 32 ff ff ff    	jl     8003c3 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800491:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800498:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80049f:	eb 26                	jmp    8004c7 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004a1:	a1 20 40 80 00       	mov    0x804020,%eax
  8004a6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004af:	89 d0                	mov    %edx,%eax
  8004b1:	01 c0                	add    %eax,%eax
  8004b3:	01 d0                	add    %edx,%eax
  8004b5:	c1 e0 03             	shl    $0x3,%eax
  8004b8:	01 c8                	add    %ecx,%eax
  8004ba:	8a 40 04             	mov    0x4(%eax),%al
  8004bd:	3c 01                	cmp    $0x1,%al
  8004bf:	75 03                	jne    8004c4 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004c1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c4:	ff 45 e0             	incl   -0x20(%ebp)
  8004c7:	a1 20 40 80 00       	mov    0x804020,%eax
  8004cc:	8b 50 74             	mov    0x74(%eax),%edx
  8004cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d2:	39 c2                	cmp    %eax,%edx
  8004d4:	77 cb                	ja     8004a1 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004d9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004dc:	74 14                	je     8004f2 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004de:	83 ec 04             	sub    $0x4,%esp
  8004e1:	68 74 35 80 00       	push   $0x803574
  8004e6:	6a 44                	push   $0x44
  8004e8:	68 14 35 80 00       	push   $0x803514
  8004ed:	e8 23 fe ff ff       	call   800315 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004f2:	90                   	nop
  8004f3:	c9                   	leave  
  8004f4:	c3                   	ret    

008004f5 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004f5:	55                   	push   %ebp
  8004f6:	89 e5                	mov    %esp,%ebp
  8004f8:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	8d 48 01             	lea    0x1(%eax),%ecx
  800503:	8b 55 0c             	mov    0xc(%ebp),%edx
  800506:	89 0a                	mov    %ecx,(%edx)
  800508:	8b 55 08             	mov    0x8(%ebp),%edx
  80050b:	88 d1                	mov    %dl,%cl
  80050d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800510:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800514:	8b 45 0c             	mov    0xc(%ebp),%eax
  800517:	8b 00                	mov    (%eax),%eax
  800519:	3d ff 00 00 00       	cmp    $0xff,%eax
  80051e:	75 2c                	jne    80054c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800520:	a0 24 40 80 00       	mov    0x804024,%al
  800525:	0f b6 c0             	movzbl %al,%eax
  800528:	8b 55 0c             	mov    0xc(%ebp),%edx
  80052b:	8b 12                	mov    (%edx),%edx
  80052d:	89 d1                	mov    %edx,%ecx
  80052f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800532:	83 c2 08             	add    $0x8,%edx
  800535:	83 ec 04             	sub    $0x4,%esp
  800538:	50                   	push   %eax
  800539:	51                   	push   %ecx
  80053a:	52                   	push   %edx
  80053b:	e8 66 13 00 00       	call   8018a6 <sys_cputs>
  800540:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800543:	8b 45 0c             	mov    0xc(%ebp),%eax
  800546:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054f:	8b 40 04             	mov    0x4(%eax),%eax
  800552:	8d 50 01             	lea    0x1(%eax),%edx
  800555:	8b 45 0c             	mov    0xc(%ebp),%eax
  800558:	89 50 04             	mov    %edx,0x4(%eax)
}
  80055b:	90                   	nop
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    

0080055e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800567:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80056e:	00 00 00 
	b.cnt = 0;
  800571:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800578:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80057b:	ff 75 0c             	pushl  0xc(%ebp)
  80057e:	ff 75 08             	pushl  0x8(%ebp)
  800581:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800587:	50                   	push   %eax
  800588:	68 f5 04 80 00       	push   $0x8004f5
  80058d:	e8 11 02 00 00       	call   8007a3 <vprintfmt>
  800592:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800595:	a0 24 40 80 00       	mov    0x804024,%al
  80059a:	0f b6 c0             	movzbl %al,%eax
  80059d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005a3:	83 ec 04             	sub    $0x4,%esp
  8005a6:	50                   	push   %eax
  8005a7:	52                   	push   %edx
  8005a8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005ae:	83 c0 08             	add    $0x8,%eax
  8005b1:	50                   	push   %eax
  8005b2:	e8 ef 12 00 00       	call   8018a6 <sys_cputs>
  8005b7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005ba:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8005c1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005c7:	c9                   	leave  
  8005c8:	c3                   	ret    

008005c9 <cprintf>:

int cprintf(const char *fmt, ...) {
  8005c9:	55                   	push   %ebp
  8005ca:	89 e5                	mov    %esp,%ebp
  8005cc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005cf:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8005d6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005df:	83 ec 08             	sub    $0x8,%esp
  8005e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e5:	50                   	push   %eax
  8005e6:	e8 73 ff ff ff       	call   80055e <vcprintf>
  8005eb:	83 c4 10             	add    $0x10,%esp
  8005ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f4:	c9                   	leave  
  8005f5:	c3                   	ret    

008005f6 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005f6:	55                   	push   %ebp
  8005f7:	89 e5                	mov    %esp,%ebp
  8005f9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005fc:	e8 53 14 00 00       	call   801a54 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800601:	8d 45 0c             	lea    0xc(%ebp),%eax
  800604:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800607:	8b 45 08             	mov    0x8(%ebp),%eax
  80060a:	83 ec 08             	sub    $0x8,%esp
  80060d:	ff 75 f4             	pushl  -0xc(%ebp)
  800610:	50                   	push   %eax
  800611:	e8 48 ff ff ff       	call   80055e <vcprintf>
  800616:	83 c4 10             	add    $0x10,%esp
  800619:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80061c:	e8 4d 14 00 00       	call   801a6e <sys_enable_interrupt>
	return cnt;
  800621:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800624:	c9                   	leave  
  800625:	c3                   	ret    

00800626 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800626:	55                   	push   %ebp
  800627:	89 e5                	mov    %esp,%ebp
  800629:	53                   	push   %ebx
  80062a:	83 ec 14             	sub    $0x14,%esp
  80062d:	8b 45 10             	mov    0x10(%ebp),%eax
  800630:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800639:	8b 45 18             	mov    0x18(%ebp),%eax
  80063c:	ba 00 00 00 00       	mov    $0x0,%edx
  800641:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800644:	77 55                	ja     80069b <printnum+0x75>
  800646:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800649:	72 05                	jb     800650 <printnum+0x2a>
  80064b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80064e:	77 4b                	ja     80069b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800650:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800653:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800656:	8b 45 18             	mov    0x18(%ebp),%eax
  800659:	ba 00 00 00 00       	mov    $0x0,%edx
  80065e:	52                   	push   %edx
  80065f:	50                   	push   %eax
  800660:	ff 75 f4             	pushl  -0xc(%ebp)
  800663:	ff 75 f0             	pushl  -0x10(%ebp)
  800666:	e8 85 28 00 00       	call   802ef0 <__udivdi3>
  80066b:	83 c4 10             	add    $0x10,%esp
  80066e:	83 ec 04             	sub    $0x4,%esp
  800671:	ff 75 20             	pushl  0x20(%ebp)
  800674:	53                   	push   %ebx
  800675:	ff 75 18             	pushl  0x18(%ebp)
  800678:	52                   	push   %edx
  800679:	50                   	push   %eax
  80067a:	ff 75 0c             	pushl  0xc(%ebp)
  80067d:	ff 75 08             	pushl  0x8(%ebp)
  800680:	e8 a1 ff ff ff       	call   800626 <printnum>
  800685:	83 c4 20             	add    $0x20,%esp
  800688:	eb 1a                	jmp    8006a4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80068a:	83 ec 08             	sub    $0x8,%esp
  80068d:	ff 75 0c             	pushl  0xc(%ebp)
  800690:	ff 75 20             	pushl  0x20(%ebp)
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	ff d0                	call   *%eax
  800698:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80069b:	ff 4d 1c             	decl   0x1c(%ebp)
  80069e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006a2:	7f e6                	jg     80068a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006a4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006b2:	53                   	push   %ebx
  8006b3:	51                   	push   %ecx
  8006b4:	52                   	push   %edx
  8006b5:	50                   	push   %eax
  8006b6:	e8 45 29 00 00       	call   803000 <__umoddi3>
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	05 d4 37 80 00       	add    $0x8037d4,%eax
  8006c3:	8a 00                	mov    (%eax),%al
  8006c5:	0f be c0             	movsbl %al,%eax
  8006c8:	83 ec 08             	sub    $0x8,%esp
  8006cb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ce:	50                   	push   %eax
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	ff d0                	call   *%eax
  8006d4:	83 c4 10             	add    $0x10,%esp
}
  8006d7:	90                   	nop
  8006d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006db:	c9                   	leave  
  8006dc:	c3                   	ret    

008006dd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006dd:	55                   	push   %ebp
  8006de:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006e4:	7e 1c                	jle    800702 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	8d 50 08             	lea    0x8(%eax),%edx
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	89 10                	mov    %edx,(%eax)
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	83 e8 08             	sub    $0x8,%eax
  8006fb:	8b 50 04             	mov    0x4(%eax),%edx
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	eb 40                	jmp    800742 <getuint+0x65>
	else if (lflag)
  800702:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800706:	74 1e                	je     800726 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	8d 50 04             	lea    0x4(%eax),%edx
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	89 10                	mov    %edx,(%eax)
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	83 e8 04             	sub    $0x4,%eax
  80071d:	8b 00                	mov    (%eax),%eax
  80071f:	ba 00 00 00 00       	mov    $0x0,%edx
  800724:	eb 1c                	jmp    800742 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	8d 50 04             	lea    0x4(%eax),%edx
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	89 10                	mov    %edx,(%eax)
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	83 e8 04             	sub    $0x4,%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800742:	5d                   	pop    %ebp
  800743:	c3                   	ret    

00800744 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800747:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80074b:	7e 1c                	jle    800769 <getint+0x25>
		return va_arg(*ap, long long);
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	8b 00                	mov    (%eax),%eax
  800752:	8d 50 08             	lea    0x8(%eax),%edx
  800755:	8b 45 08             	mov    0x8(%ebp),%eax
  800758:	89 10                	mov    %edx,(%eax)
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	8b 00                	mov    (%eax),%eax
  80075f:	83 e8 08             	sub    $0x8,%eax
  800762:	8b 50 04             	mov    0x4(%eax),%edx
  800765:	8b 00                	mov    (%eax),%eax
  800767:	eb 38                	jmp    8007a1 <getint+0x5d>
	else if (lflag)
  800769:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80076d:	74 1a                	je     800789 <getint+0x45>
		return va_arg(*ap, long);
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	8d 50 04             	lea    0x4(%eax),%edx
  800777:	8b 45 08             	mov    0x8(%ebp),%eax
  80077a:	89 10                	mov    %edx,(%eax)
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	8b 00                	mov    (%eax),%eax
  800781:	83 e8 04             	sub    $0x4,%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	99                   	cltd   
  800787:	eb 18                	jmp    8007a1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800789:	8b 45 08             	mov    0x8(%ebp),%eax
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	8d 50 04             	lea    0x4(%eax),%edx
  800791:	8b 45 08             	mov    0x8(%ebp),%eax
  800794:	89 10                	mov    %edx,(%eax)
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	8b 00                	mov    (%eax),%eax
  80079b:	83 e8 04             	sub    $0x4,%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	99                   	cltd   
}
  8007a1:	5d                   	pop    %ebp
  8007a2:	c3                   	ret    

008007a3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007a3:	55                   	push   %ebp
  8007a4:	89 e5                	mov    %esp,%ebp
  8007a6:	56                   	push   %esi
  8007a7:	53                   	push   %ebx
  8007a8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ab:	eb 17                	jmp    8007c4 <vprintfmt+0x21>
			if (ch == '\0')
  8007ad:	85 db                	test   %ebx,%ebx
  8007af:	0f 84 af 03 00 00    	je     800b64 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	ff 75 0c             	pushl  0xc(%ebp)
  8007bb:	53                   	push   %ebx
  8007bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bf:	ff d0                	call   *%eax
  8007c1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c7:	8d 50 01             	lea    0x1(%eax),%edx
  8007ca:	89 55 10             	mov    %edx,0x10(%ebp)
  8007cd:	8a 00                	mov    (%eax),%al
  8007cf:	0f b6 d8             	movzbl %al,%ebx
  8007d2:	83 fb 25             	cmp    $0x25,%ebx
  8007d5:	75 d6                	jne    8007ad <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007d7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007db:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007e2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007e9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007f0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fa:	8d 50 01             	lea    0x1(%eax),%edx
  8007fd:	89 55 10             	mov    %edx,0x10(%ebp)
  800800:	8a 00                	mov    (%eax),%al
  800802:	0f b6 d8             	movzbl %al,%ebx
  800805:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800808:	83 f8 55             	cmp    $0x55,%eax
  80080b:	0f 87 2b 03 00 00    	ja     800b3c <vprintfmt+0x399>
  800811:	8b 04 85 f8 37 80 00 	mov    0x8037f8(,%eax,4),%eax
  800818:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80081a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80081e:	eb d7                	jmp    8007f7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800820:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800824:	eb d1                	jmp    8007f7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800826:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80082d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800830:	89 d0                	mov    %edx,%eax
  800832:	c1 e0 02             	shl    $0x2,%eax
  800835:	01 d0                	add    %edx,%eax
  800837:	01 c0                	add    %eax,%eax
  800839:	01 d8                	add    %ebx,%eax
  80083b:	83 e8 30             	sub    $0x30,%eax
  80083e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800841:	8b 45 10             	mov    0x10(%ebp),%eax
  800844:	8a 00                	mov    (%eax),%al
  800846:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800849:	83 fb 2f             	cmp    $0x2f,%ebx
  80084c:	7e 3e                	jle    80088c <vprintfmt+0xe9>
  80084e:	83 fb 39             	cmp    $0x39,%ebx
  800851:	7f 39                	jg     80088c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800853:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800856:	eb d5                	jmp    80082d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	83 c0 04             	add    $0x4,%eax
  80085e:	89 45 14             	mov    %eax,0x14(%ebp)
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	83 e8 04             	sub    $0x4,%eax
  800867:	8b 00                	mov    (%eax),%eax
  800869:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80086c:	eb 1f                	jmp    80088d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80086e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800872:	79 83                	jns    8007f7 <vprintfmt+0x54>
				width = 0;
  800874:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80087b:	e9 77 ff ff ff       	jmp    8007f7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800880:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800887:	e9 6b ff ff ff       	jmp    8007f7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80088c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80088d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800891:	0f 89 60 ff ff ff    	jns    8007f7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800897:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80089d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008a4:	e9 4e ff ff ff       	jmp    8007f7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008a9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008ac:	e9 46 ff ff ff       	jmp    8007f7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	83 c0 04             	add    $0x4,%eax
  8008b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	83 e8 04             	sub    $0x4,%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	ff 75 0c             	pushl  0xc(%ebp)
  8008c8:	50                   	push   %eax
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	ff d0                	call   *%eax
  8008ce:	83 c4 10             	add    $0x10,%esp
			break;
  8008d1:	e9 89 02 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d9:	83 c0 04             	add    $0x4,%eax
  8008dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8008df:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e2:	83 e8 04             	sub    $0x4,%eax
  8008e5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008e7:	85 db                	test   %ebx,%ebx
  8008e9:	79 02                	jns    8008ed <vprintfmt+0x14a>
				err = -err;
  8008eb:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008ed:	83 fb 64             	cmp    $0x64,%ebx
  8008f0:	7f 0b                	jg     8008fd <vprintfmt+0x15a>
  8008f2:	8b 34 9d 40 36 80 00 	mov    0x803640(,%ebx,4),%esi
  8008f9:	85 f6                	test   %esi,%esi
  8008fb:	75 19                	jne    800916 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008fd:	53                   	push   %ebx
  8008fe:	68 e5 37 80 00       	push   $0x8037e5
  800903:	ff 75 0c             	pushl  0xc(%ebp)
  800906:	ff 75 08             	pushl  0x8(%ebp)
  800909:	e8 5e 02 00 00       	call   800b6c <printfmt>
  80090e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800911:	e9 49 02 00 00       	jmp    800b5f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800916:	56                   	push   %esi
  800917:	68 ee 37 80 00       	push   $0x8037ee
  80091c:	ff 75 0c             	pushl  0xc(%ebp)
  80091f:	ff 75 08             	pushl  0x8(%ebp)
  800922:	e8 45 02 00 00       	call   800b6c <printfmt>
  800927:	83 c4 10             	add    $0x10,%esp
			break;
  80092a:	e9 30 02 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	83 c0 04             	add    $0x4,%eax
  800935:	89 45 14             	mov    %eax,0x14(%ebp)
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	83 e8 04             	sub    $0x4,%eax
  80093e:	8b 30                	mov    (%eax),%esi
  800940:	85 f6                	test   %esi,%esi
  800942:	75 05                	jne    800949 <vprintfmt+0x1a6>
				p = "(null)";
  800944:	be f1 37 80 00       	mov    $0x8037f1,%esi
			if (width > 0 && padc != '-')
  800949:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094d:	7e 6d                	jle    8009bc <vprintfmt+0x219>
  80094f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800953:	74 67                	je     8009bc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800955:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800958:	83 ec 08             	sub    $0x8,%esp
  80095b:	50                   	push   %eax
  80095c:	56                   	push   %esi
  80095d:	e8 0c 03 00 00       	call   800c6e <strnlen>
  800962:	83 c4 10             	add    $0x10,%esp
  800965:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800968:	eb 16                	jmp    800980 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80096a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80096e:	83 ec 08             	sub    $0x8,%esp
  800971:	ff 75 0c             	pushl  0xc(%ebp)
  800974:	50                   	push   %eax
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	ff d0                	call   *%eax
  80097a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80097d:	ff 4d e4             	decl   -0x1c(%ebp)
  800980:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800984:	7f e4                	jg     80096a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800986:	eb 34                	jmp    8009bc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800988:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80098c:	74 1c                	je     8009aa <vprintfmt+0x207>
  80098e:	83 fb 1f             	cmp    $0x1f,%ebx
  800991:	7e 05                	jle    800998 <vprintfmt+0x1f5>
  800993:	83 fb 7e             	cmp    $0x7e,%ebx
  800996:	7e 12                	jle    8009aa <vprintfmt+0x207>
					putch('?', putdat);
  800998:	83 ec 08             	sub    $0x8,%esp
  80099b:	ff 75 0c             	pushl  0xc(%ebp)
  80099e:	6a 3f                	push   $0x3f
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	ff d0                	call   *%eax
  8009a5:	83 c4 10             	add    $0x10,%esp
  8009a8:	eb 0f                	jmp    8009b9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009aa:	83 ec 08             	sub    $0x8,%esp
  8009ad:	ff 75 0c             	pushl  0xc(%ebp)
  8009b0:	53                   	push   %ebx
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	ff d0                	call   *%eax
  8009b6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b9:	ff 4d e4             	decl   -0x1c(%ebp)
  8009bc:	89 f0                	mov    %esi,%eax
  8009be:	8d 70 01             	lea    0x1(%eax),%esi
  8009c1:	8a 00                	mov    (%eax),%al
  8009c3:	0f be d8             	movsbl %al,%ebx
  8009c6:	85 db                	test   %ebx,%ebx
  8009c8:	74 24                	je     8009ee <vprintfmt+0x24b>
  8009ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ce:	78 b8                	js     800988 <vprintfmt+0x1e5>
  8009d0:	ff 4d e0             	decl   -0x20(%ebp)
  8009d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009d7:	79 af                	jns    800988 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009d9:	eb 13                	jmp    8009ee <vprintfmt+0x24b>
				putch(' ', putdat);
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	ff 75 0c             	pushl  0xc(%ebp)
  8009e1:	6a 20                	push   $0x20
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	ff d0                	call   *%eax
  8009e8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009eb:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f2:	7f e7                	jg     8009db <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009f4:	e9 66 01 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ff:	8d 45 14             	lea    0x14(%ebp),%eax
  800a02:	50                   	push   %eax
  800a03:	e8 3c fd ff ff       	call   800744 <getint>
  800a08:	83 c4 10             	add    $0x10,%esp
  800a0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a17:	85 d2                	test   %edx,%edx
  800a19:	79 23                	jns    800a3e <vprintfmt+0x29b>
				putch('-', putdat);
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 0c             	pushl  0xc(%ebp)
  800a21:	6a 2d                	push   $0x2d
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	ff d0                	call   *%eax
  800a28:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a31:	f7 d8                	neg    %eax
  800a33:	83 d2 00             	adc    $0x0,%edx
  800a36:	f7 da                	neg    %edx
  800a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a3e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a45:	e9 bc 00 00 00       	jmp    800b06 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a50:	8d 45 14             	lea    0x14(%ebp),%eax
  800a53:	50                   	push   %eax
  800a54:	e8 84 fc ff ff       	call   8006dd <getuint>
  800a59:	83 c4 10             	add    $0x10,%esp
  800a5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a62:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a69:	e9 98 00 00 00       	jmp    800b06 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a6e:	83 ec 08             	sub    $0x8,%esp
  800a71:	ff 75 0c             	pushl  0xc(%ebp)
  800a74:	6a 58                	push   $0x58
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	ff d0                	call   *%eax
  800a7b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a7e:	83 ec 08             	sub    $0x8,%esp
  800a81:	ff 75 0c             	pushl  0xc(%ebp)
  800a84:	6a 58                	push   $0x58
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	ff d0                	call   *%eax
  800a8b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	6a 58                	push   $0x58
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	ff d0                	call   *%eax
  800a9b:	83 c4 10             	add    $0x10,%esp
			break;
  800a9e:	e9 bc 00 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 0c             	pushl  0xc(%ebp)
  800aa9:	6a 30                	push   $0x30
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	ff d0                	call   *%eax
  800ab0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 0c             	pushl  0xc(%ebp)
  800ab9:	6a 78                	push   $0x78
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	ff d0                	call   *%eax
  800ac0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ac3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac6:	83 c0 04             	add    $0x4,%eax
  800ac9:	89 45 14             	mov    %eax,0x14(%ebp)
  800acc:	8b 45 14             	mov    0x14(%ebp),%eax
  800acf:	83 e8 04             	sub    $0x4,%eax
  800ad2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ade:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ae5:	eb 1f                	jmp    800b06 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 e8             	pushl  -0x18(%ebp)
  800aed:	8d 45 14             	lea    0x14(%ebp),%eax
  800af0:	50                   	push   %eax
  800af1:	e8 e7 fb ff ff       	call   8006dd <getuint>
  800af6:	83 c4 10             	add    $0x10,%esp
  800af9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800afc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aff:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b06:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b0d:	83 ec 04             	sub    $0x4,%esp
  800b10:	52                   	push   %edx
  800b11:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b14:	50                   	push   %eax
  800b15:	ff 75 f4             	pushl  -0xc(%ebp)
  800b18:	ff 75 f0             	pushl  -0x10(%ebp)
  800b1b:	ff 75 0c             	pushl  0xc(%ebp)
  800b1e:	ff 75 08             	pushl  0x8(%ebp)
  800b21:	e8 00 fb ff ff       	call   800626 <printnum>
  800b26:	83 c4 20             	add    $0x20,%esp
			break;
  800b29:	eb 34                	jmp    800b5f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b2b:	83 ec 08             	sub    $0x8,%esp
  800b2e:	ff 75 0c             	pushl  0xc(%ebp)
  800b31:	53                   	push   %ebx
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	ff d0                	call   *%eax
  800b37:	83 c4 10             	add    $0x10,%esp
			break;
  800b3a:	eb 23                	jmp    800b5f <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	6a 25                	push   $0x25
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	ff d0                	call   *%eax
  800b49:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b4c:	ff 4d 10             	decl   0x10(%ebp)
  800b4f:	eb 03                	jmp    800b54 <vprintfmt+0x3b1>
  800b51:	ff 4d 10             	decl   0x10(%ebp)
  800b54:	8b 45 10             	mov    0x10(%ebp),%eax
  800b57:	48                   	dec    %eax
  800b58:	8a 00                	mov    (%eax),%al
  800b5a:	3c 25                	cmp    $0x25,%al
  800b5c:	75 f3                	jne    800b51 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b5e:	90                   	nop
		}
	}
  800b5f:	e9 47 fc ff ff       	jmp    8007ab <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b64:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b65:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b68:	5b                   	pop    %ebx
  800b69:	5e                   	pop    %esi
  800b6a:	5d                   	pop    %ebp
  800b6b:	c3                   	ret    

00800b6c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b72:	8d 45 10             	lea    0x10(%ebp),%eax
  800b75:	83 c0 04             	add    $0x4,%eax
  800b78:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b81:	50                   	push   %eax
  800b82:	ff 75 0c             	pushl  0xc(%ebp)
  800b85:	ff 75 08             	pushl  0x8(%ebp)
  800b88:	e8 16 fc ff ff       	call   8007a3 <vprintfmt>
  800b8d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b90:	90                   	nop
  800b91:	c9                   	leave  
  800b92:	c3                   	ret    

00800b93 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b99:	8b 40 08             	mov    0x8(%eax),%eax
  800b9c:	8d 50 01             	lea    0x1(%eax),%edx
  800b9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ba5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba8:	8b 10                	mov    (%eax),%edx
  800baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bad:	8b 40 04             	mov    0x4(%eax),%eax
  800bb0:	39 c2                	cmp    %eax,%edx
  800bb2:	73 12                	jae    800bc6 <sprintputch+0x33>
		*b->buf++ = ch;
  800bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb7:	8b 00                	mov    (%eax),%eax
  800bb9:	8d 48 01             	lea    0x1(%eax),%ecx
  800bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbf:	89 0a                	mov    %ecx,(%edx)
  800bc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc4:	88 10                	mov    %dl,(%eax)
}
  800bc6:	90                   	nop
  800bc7:	5d                   	pop    %ebp
  800bc8:	c3                   	ret    

00800bc9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	01 d0                	add    %edx,%eax
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bee:	74 06                	je     800bf6 <vsnprintf+0x2d>
  800bf0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf4:	7f 07                	jg     800bfd <vsnprintf+0x34>
		return -E_INVAL;
  800bf6:	b8 03 00 00 00       	mov    $0x3,%eax
  800bfb:	eb 20                	jmp    800c1d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bfd:	ff 75 14             	pushl  0x14(%ebp)
  800c00:	ff 75 10             	pushl  0x10(%ebp)
  800c03:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c06:	50                   	push   %eax
  800c07:	68 93 0b 80 00       	push   $0x800b93
  800c0c:	e8 92 fb ff ff       	call   8007a3 <vprintfmt>
  800c11:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c17:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c25:	8d 45 10             	lea    0x10(%ebp),%eax
  800c28:	83 c0 04             	add    $0x4,%eax
  800c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c31:	ff 75 f4             	pushl  -0xc(%ebp)
  800c34:	50                   	push   %eax
  800c35:	ff 75 0c             	pushl  0xc(%ebp)
  800c38:	ff 75 08             	pushl  0x8(%ebp)
  800c3b:	e8 89 ff ff ff       	call   800bc9 <vsnprintf>
  800c40:	83 c4 10             	add    $0x10,%esp
  800c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c49:	c9                   	leave  
  800c4a:	c3                   	ret    

00800c4b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c58:	eb 06                	jmp    800c60 <strlen+0x15>
		n++;
  800c5a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c5d:	ff 45 08             	incl   0x8(%ebp)
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	84 c0                	test   %al,%al
  800c67:	75 f1                	jne    800c5a <strlen+0xf>
		n++;
	return n;
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7b:	eb 09                	jmp    800c86 <strnlen+0x18>
		n++;
  800c7d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c80:	ff 45 08             	incl   0x8(%ebp)
  800c83:	ff 4d 0c             	decl   0xc(%ebp)
  800c86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8a:	74 09                	je     800c95 <strnlen+0x27>
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	8a 00                	mov    (%eax),%al
  800c91:	84 c0                	test   %al,%al
  800c93:	75 e8                	jne    800c7d <strnlen+0xf>
		n++;
	return n;
  800c95:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c98:	c9                   	leave  
  800c99:	c3                   	ret    

00800c9a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ca6:	90                   	nop
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	8d 50 01             	lea    0x1(%eax),%edx
  800cad:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cb6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cb9:	8a 12                	mov    (%edx),%dl
  800cbb:	88 10                	mov    %dl,(%eax)
  800cbd:	8a 00                	mov    (%eax),%al
  800cbf:	84 c0                	test   %al,%al
  800cc1:	75 e4                	jne    800ca7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc6:	c9                   	leave  
  800cc7:	c3                   	ret    

00800cc8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cc8:	55                   	push   %ebp
  800cc9:	89 e5                	mov    %esp,%ebp
  800ccb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cd4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cdb:	eb 1f                	jmp    800cfc <strncpy+0x34>
		*dst++ = *src;
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8d 50 01             	lea    0x1(%eax),%edx
  800ce3:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce9:	8a 12                	mov    (%edx),%dl
  800ceb:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf0:	8a 00                	mov    (%eax),%al
  800cf2:	84 c0                	test   %al,%al
  800cf4:	74 03                	je     800cf9 <strncpy+0x31>
			src++;
  800cf6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cf9:	ff 45 fc             	incl   -0x4(%ebp)
  800cfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cff:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d02:	72 d9                	jb     800cdd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d04:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d07:	c9                   	leave  
  800d08:	c3                   	ret    

00800d09 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d19:	74 30                	je     800d4b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d1b:	eb 16                	jmp    800d33 <strlcpy+0x2a>
			*dst++ = *src++;
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8d 50 01             	lea    0x1(%eax),%edx
  800d23:	89 55 08             	mov    %edx,0x8(%ebp)
  800d26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d29:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d2c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d2f:	8a 12                	mov    (%edx),%dl
  800d31:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d33:	ff 4d 10             	decl   0x10(%ebp)
  800d36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3a:	74 09                	je     800d45 <strlcpy+0x3c>
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	84 c0                	test   %al,%al
  800d43:	75 d8                	jne    800d1d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d51:	29 c2                	sub    %eax,%edx
  800d53:	89 d0                	mov    %edx,%eax
}
  800d55:	c9                   	leave  
  800d56:	c3                   	ret    

00800d57 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d5a:	eb 06                	jmp    800d62 <strcmp+0xb>
		p++, q++;
  800d5c:	ff 45 08             	incl   0x8(%ebp)
  800d5f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	84 c0                	test   %al,%al
  800d69:	74 0e                	je     800d79 <strcmp+0x22>
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8a 10                	mov    (%eax),%dl
  800d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	38 c2                	cmp    %al,%dl
  800d77:	74 e3                	je     800d5c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8a 00                	mov    (%eax),%al
  800d7e:	0f b6 d0             	movzbl %al,%edx
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	0f b6 c0             	movzbl %al,%eax
  800d89:	29 c2                	sub    %eax,%edx
  800d8b:	89 d0                	mov    %edx,%eax
}
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d92:	eb 09                	jmp    800d9d <strncmp+0xe>
		n--, p++, q++;
  800d94:	ff 4d 10             	decl   0x10(%ebp)
  800d97:	ff 45 08             	incl   0x8(%ebp)
  800d9a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da1:	74 17                	je     800dba <strncmp+0x2b>
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	84 c0                	test   %al,%al
  800daa:	74 0e                	je     800dba <strncmp+0x2b>
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	8a 10                	mov    (%eax),%dl
  800db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db4:	8a 00                	mov    (%eax),%al
  800db6:	38 c2                	cmp    %al,%dl
  800db8:	74 da                	je     800d94 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbe:	75 07                	jne    800dc7 <strncmp+0x38>
		return 0;
  800dc0:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc5:	eb 14                	jmp    800ddb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	8a 00                	mov    (%eax),%al
  800dcc:	0f b6 d0             	movzbl %al,%edx
  800dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	0f b6 c0             	movzbl %al,%eax
  800dd7:	29 c2                	sub    %eax,%edx
  800dd9:	89 d0                	mov    %edx,%eax
}
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 04             	sub    $0x4,%esp
  800de3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800de9:	eb 12                	jmp    800dfd <strchr+0x20>
		if (*s == c)
  800deb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dee:	8a 00                	mov    (%eax),%al
  800df0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df3:	75 05                	jne    800dfa <strchr+0x1d>
			return (char *) s;
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	eb 11                	jmp    800e0b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dfa:	ff 45 08             	incl   0x8(%ebp)
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8a 00                	mov    (%eax),%al
  800e02:	84 c0                	test   %al,%al
  800e04:	75 e5                	jne    800deb <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 04             	sub    $0x4,%esp
  800e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e16:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e19:	eb 0d                	jmp    800e28 <strfind+0x1b>
		if (*s == c)
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e23:	74 0e                	je     800e33 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e25:	ff 45 08             	incl   0x8(%ebp)
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	84 c0                	test   %al,%al
  800e2f:	75 ea                	jne    800e1b <strfind+0xe>
  800e31:	eb 01                	jmp    800e34 <strfind+0x27>
		if (*s == c)
			break;
  800e33:	90                   	nop
	return (char *) s;
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e37:	c9                   	leave  
  800e38:	c3                   	ret    

00800e39 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e45:	8b 45 10             	mov    0x10(%ebp),%eax
  800e48:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e4b:	eb 0e                	jmp    800e5b <memset+0x22>
		*p++ = c;
  800e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e50:	8d 50 01             	lea    0x1(%eax),%edx
  800e53:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e59:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e5b:	ff 4d f8             	decl   -0x8(%ebp)
  800e5e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e62:	79 e9                	jns    800e4d <memset+0x14>
		*p++ = c;

	return v;
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e67:	c9                   	leave  
  800e68:	c3                   	ret    

00800e69 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e7b:	eb 16                	jmp    800e93 <memcpy+0x2a>
		*d++ = *s++;
  800e7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e80:	8d 50 01             	lea    0x1(%eax),%edx
  800e83:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e86:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e89:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e8c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e8f:	8a 12                	mov    (%edx),%dl
  800e91:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e93:	8b 45 10             	mov    0x10(%ebp),%eax
  800e96:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e99:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9c:	85 c0                	test   %eax,%eax
  800e9e:	75 dd                	jne    800e7d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800eb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ebd:	73 50                	jae    800f0f <memmove+0x6a>
  800ebf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec5:	01 d0                	add    %edx,%eax
  800ec7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eca:	76 43                	jbe    800f0f <memmove+0x6a>
		s += n;
  800ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecf:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ed2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ed8:	eb 10                	jmp    800eea <memmove+0x45>
			*--d = *--s;
  800eda:	ff 4d f8             	decl   -0x8(%ebp)
  800edd:	ff 4d fc             	decl   -0x4(%ebp)
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	8a 10                	mov    (%eax),%dl
  800ee5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee8:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800eea:	8b 45 10             	mov    0x10(%ebp),%eax
  800eed:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef3:	85 c0                	test   %eax,%eax
  800ef5:	75 e3                	jne    800eda <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ef7:	eb 23                	jmp    800f1c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ef9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efc:	8d 50 01             	lea    0x1(%eax),%edx
  800eff:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f02:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f05:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f08:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f0b:	8a 12                	mov    (%edx),%dl
  800f0d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f12:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f15:	89 55 10             	mov    %edx,0x10(%ebp)
  800f18:	85 c0                	test   %eax,%eax
  800f1a:	75 dd                	jne    800ef9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1f:	c9                   	leave  
  800f20:	c3                   	ret    

00800f21 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
  800f24:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f30:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f33:	eb 2a                	jmp    800f5f <memcmp+0x3e>
		if (*s1 != *s2)
  800f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f38:	8a 10                	mov    (%eax),%dl
  800f3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	38 c2                	cmp    %al,%dl
  800f41:	74 16                	je     800f59 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	0f b6 d0             	movzbl %al,%edx
  800f4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	0f b6 c0             	movzbl %al,%eax
  800f53:	29 c2                	sub    %eax,%edx
  800f55:	89 d0                	mov    %edx,%eax
  800f57:	eb 18                	jmp    800f71 <memcmp+0x50>
		s1++, s2++;
  800f59:	ff 45 fc             	incl   -0x4(%ebp)
  800f5c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f62:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f65:	89 55 10             	mov    %edx,0x10(%ebp)
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	75 c9                	jne    800f35 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f71:	c9                   	leave  
  800f72:	c3                   	ret    

00800f73 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f79:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7f:	01 d0                	add    %edx,%eax
  800f81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f84:	eb 15                	jmp    800f9b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	0f b6 d0             	movzbl %al,%edx
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	0f b6 c0             	movzbl %al,%eax
  800f94:	39 c2                	cmp    %eax,%edx
  800f96:	74 0d                	je     800fa5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f98:	ff 45 08             	incl   0x8(%ebp)
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fa1:	72 e3                	jb     800f86 <memfind+0x13>
  800fa3:	eb 01                	jmp    800fa6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fa5:	90                   	nop
	return (void *) s;
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa9:	c9                   	leave  
  800faa:	c3                   	ret    

00800fab <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
  800fae:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fb8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fbf:	eb 03                	jmp    800fc4 <strtol+0x19>
		s++;
  800fc1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	8a 00                	mov    (%eax),%al
  800fc9:	3c 20                	cmp    $0x20,%al
  800fcb:	74 f4                	je     800fc1 <strtol+0x16>
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd0:	8a 00                	mov    (%eax),%al
  800fd2:	3c 09                	cmp    $0x9,%al
  800fd4:	74 eb                	je     800fc1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	3c 2b                	cmp    $0x2b,%al
  800fdd:	75 05                	jne    800fe4 <strtol+0x39>
		s++;
  800fdf:	ff 45 08             	incl   0x8(%ebp)
  800fe2:	eb 13                	jmp    800ff7 <strtol+0x4c>
	else if (*s == '-')
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	3c 2d                	cmp    $0x2d,%al
  800feb:	75 0a                	jne    800ff7 <strtol+0x4c>
		s++, neg = 1;
  800fed:	ff 45 08             	incl   0x8(%ebp)
  800ff0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffb:	74 06                	je     801003 <strtol+0x58>
  800ffd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801001:	75 20                	jne    801023 <strtol+0x78>
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	3c 30                	cmp    $0x30,%al
  80100a:	75 17                	jne    801023 <strtol+0x78>
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	40                   	inc    %eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	3c 78                	cmp    $0x78,%al
  801014:	75 0d                	jne    801023 <strtol+0x78>
		s += 2, base = 16;
  801016:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80101a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801021:	eb 28                	jmp    80104b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801023:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801027:	75 15                	jne    80103e <strtol+0x93>
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	3c 30                	cmp    $0x30,%al
  801030:	75 0c                	jne    80103e <strtol+0x93>
		s++, base = 8;
  801032:	ff 45 08             	incl   0x8(%ebp)
  801035:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80103c:	eb 0d                	jmp    80104b <strtol+0xa0>
	else if (base == 0)
  80103e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801042:	75 07                	jne    80104b <strtol+0xa0>
		base = 10;
  801044:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	3c 2f                	cmp    $0x2f,%al
  801052:	7e 19                	jle    80106d <strtol+0xc2>
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	3c 39                	cmp    $0x39,%al
  80105b:	7f 10                	jg     80106d <strtol+0xc2>
			dig = *s - '0';
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	0f be c0             	movsbl %al,%eax
  801065:	83 e8 30             	sub    $0x30,%eax
  801068:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80106b:	eb 42                	jmp    8010af <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	3c 60                	cmp    $0x60,%al
  801074:	7e 19                	jle    80108f <strtol+0xe4>
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	3c 7a                	cmp    $0x7a,%al
  80107d:	7f 10                	jg     80108f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	8a 00                	mov    (%eax),%al
  801084:	0f be c0             	movsbl %al,%eax
  801087:	83 e8 57             	sub    $0x57,%eax
  80108a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80108d:	eb 20                	jmp    8010af <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	8a 00                	mov    (%eax),%al
  801094:	3c 40                	cmp    $0x40,%al
  801096:	7e 39                	jle    8010d1 <strtol+0x126>
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	3c 5a                	cmp    $0x5a,%al
  80109f:	7f 30                	jg     8010d1 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	8a 00                	mov    (%eax),%al
  8010a6:	0f be c0             	movsbl %al,%eax
  8010a9:	83 e8 37             	sub    $0x37,%eax
  8010ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010b2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010b5:	7d 19                	jge    8010d0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010b7:	ff 45 08             	incl   0x8(%ebp)
  8010ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bd:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010c1:	89 c2                	mov    %eax,%edx
  8010c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c6:	01 d0                	add    %edx,%eax
  8010c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010cb:	e9 7b ff ff ff       	jmp    80104b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010d0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010d5:	74 08                	je     8010df <strtol+0x134>
		*endptr = (char *) s;
  8010d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010da:	8b 55 08             	mov    0x8(%ebp),%edx
  8010dd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010df:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010e3:	74 07                	je     8010ec <strtol+0x141>
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e8:	f7 d8                	neg    %eax
  8010ea:	eb 03                	jmp    8010ef <strtol+0x144>
  8010ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010ef:	c9                   	leave  
  8010f0:	c3                   	ret    

008010f1 <ltostr>:

void
ltostr(long value, char *str)
{
  8010f1:	55                   	push   %ebp
  8010f2:	89 e5                	mov    %esp,%ebp
  8010f4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010fe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801105:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801109:	79 13                	jns    80111e <ltostr+0x2d>
	{
		neg = 1;
  80110b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801112:	8b 45 0c             	mov    0xc(%ebp),%eax
  801115:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801118:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80111b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801126:	99                   	cltd   
  801127:	f7 f9                	idiv   %ecx
  801129:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80112c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112f:	8d 50 01             	lea    0x1(%eax),%edx
  801132:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801135:	89 c2                	mov    %eax,%edx
  801137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113a:	01 d0                	add    %edx,%eax
  80113c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80113f:	83 c2 30             	add    $0x30,%edx
  801142:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801144:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801147:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80114c:	f7 e9                	imul   %ecx
  80114e:	c1 fa 02             	sar    $0x2,%edx
  801151:	89 c8                	mov    %ecx,%eax
  801153:	c1 f8 1f             	sar    $0x1f,%eax
  801156:	29 c2                	sub    %eax,%edx
  801158:	89 d0                	mov    %edx,%eax
  80115a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80115d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801160:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801165:	f7 e9                	imul   %ecx
  801167:	c1 fa 02             	sar    $0x2,%edx
  80116a:	89 c8                	mov    %ecx,%eax
  80116c:	c1 f8 1f             	sar    $0x1f,%eax
  80116f:	29 c2                	sub    %eax,%edx
  801171:	89 d0                	mov    %edx,%eax
  801173:	c1 e0 02             	shl    $0x2,%eax
  801176:	01 d0                	add    %edx,%eax
  801178:	01 c0                	add    %eax,%eax
  80117a:	29 c1                	sub    %eax,%ecx
  80117c:	89 ca                	mov    %ecx,%edx
  80117e:	85 d2                	test   %edx,%edx
  801180:	75 9c                	jne    80111e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801182:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801189:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118c:	48                   	dec    %eax
  80118d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801190:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801194:	74 3d                	je     8011d3 <ltostr+0xe2>
		start = 1 ;
  801196:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80119d:	eb 34                	jmp    8011d3 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80119f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	8a 00                	mov    (%eax),%al
  8011a9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b2:	01 c2                	add    %eax,%edx
  8011b4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ba:	01 c8                	add    %ecx,%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c6:	01 c2                	add    %eax,%edx
  8011c8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011cb:	88 02                	mov    %al,(%edx)
		start++ ;
  8011cd:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011d0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d9:	7c c4                	jl     80119f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011db:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e1:	01 d0                	add    %edx,%eax
  8011e3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011e6:	90                   	nop
  8011e7:	c9                   	leave  
  8011e8:	c3                   	ret    

008011e9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011ef:	ff 75 08             	pushl  0x8(%ebp)
  8011f2:	e8 54 fa ff ff       	call   800c4b <strlen>
  8011f7:	83 c4 04             	add    $0x4,%esp
  8011fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011fd:	ff 75 0c             	pushl  0xc(%ebp)
  801200:	e8 46 fa ff ff       	call   800c4b <strlen>
  801205:	83 c4 04             	add    $0x4,%esp
  801208:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80120b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801212:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801219:	eb 17                	jmp    801232 <strcconcat+0x49>
		final[s] = str1[s] ;
  80121b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80121e:	8b 45 10             	mov    0x10(%ebp),%eax
  801221:	01 c2                	add    %eax,%edx
  801223:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	01 c8                	add    %ecx,%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80122f:	ff 45 fc             	incl   -0x4(%ebp)
  801232:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801235:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801238:	7c e1                	jl     80121b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80123a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801241:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801248:	eb 1f                	jmp    801269 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80124a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80124d:	8d 50 01             	lea    0x1(%eax),%edx
  801250:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801253:	89 c2                	mov    %eax,%edx
  801255:	8b 45 10             	mov    0x10(%ebp),%eax
  801258:	01 c2                	add    %eax,%edx
  80125a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80125d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801260:	01 c8                	add    %ecx,%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801266:	ff 45 f8             	incl   -0x8(%ebp)
  801269:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80126f:	7c d9                	jl     80124a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801271:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801274:	8b 45 10             	mov    0x10(%ebp),%eax
  801277:	01 d0                	add    %edx,%eax
  801279:	c6 00 00             	movb   $0x0,(%eax)
}
  80127c:	90                   	nop
  80127d:	c9                   	leave  
  80127e:	c3                   	ret    

0080127f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801282:	8b 45 14             	mov    0x14(%ebp),%eax
  801285:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80128b:	8b 45 14             	mov    0x14(%ebp),%eax
  80128e:	8b 00                	mov    (%eax),%eax
  801290:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801297:	8b 45 10             	mov    0x10(%ebp),%eax
  80129a:	01 d0                	add    %edx,%eax
  80129c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012a2:	eb 0c                	jmp    8012b0 <strsplit+0x31>
			*string++ = 0;
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	8d 50 01             	lea    0x1(%eax),%edx
  8012aa:	89 55 08             	mov    %edx,0x8(%ebp)
  8012ad:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	84 c0                	test   %al,%al
  8012b7:	74 18                	je     8012d1 <strsplit+0x52>
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	8a 00                	mov    (%eax),%al
  8012be:	0f be c0             	movsbl %al,%eax
  8012c1:	50                   	push   %eax
  8012c2:	ff 75 0c             	pushl  0xc(%ebp)
  8012c5:	e8 13 fb ff ff       	call   800ddd <strchr>
  8012ca:	83 c4 08             	add    $0x8,%esp
  8012cd:	85 c0                	test   %eax,%eax
  8012cf:	75 d3                	jne    8012a4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	74 5a                	je     801334 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012da:	8b 45 14             	mov    0x14(%ebp),%eax
  8012dd:	8b 00                	mov    (%eax),%eax
  8012df:	83 f8 0f             	cmp    $0xf,%eax
  8012e2:	75 07                	jne    8012eb <strsplit+0x6c>
		{
			return 0;
  8012e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e9:	eb 66                	jmp    801351 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ee:	8b 00                	mov    (%eax),%eax
  8012f0:	8d 48 01             	lea    0x1(%eax),%ecx
  8012f3:	8b 55 14             	mov    0x14(%ebp),%edx
  8012f6:	89 0a                	mov    %ecx,(%edx)
  8012f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801302:	01 c2                	add    %eax,%edx
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801309:	eb 03                	jmp    80130e <strsplit+0x8f>
			string++;
  80130b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	84 c0                	test   %al,%al
  801315:	74 8b                	je     8012a2 <strsplit+0x23>
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	0f be c0             	movsbl %al,%eax
  80131f:	50                   	push   %eax
  801320:	ff 75 0c             	pushl  0xc(%ebp)
  801323:	e8 b5 fa ff ff       	call   800ddd <strchr>
  801328:	83 c4 08             	add    $0x8,%esp
  80132b:	85 c0                	test   %eax,%eax
  80132d:	74 dc                	je     80130b <strsplit+0x8c>
			string++;
	}
  80132f:	e9 6e ff ff ff       	jmp    8012a2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801334:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801335:	8b 45 14             	mov    0x14(%ebp),%eax
  801338:	8b 00                	mov    (%eax),%eax
  80133a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801341:	8b 45 10             	mov    0x10(%ebp),%eax
  801344:	01 d0                	add    %edx,%eax
  801346:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80134c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801351:	c9                   	leave  
  801352:	c3                   	ret    

00801353 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
  801356:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801359:	a1 04 40 80 00       	mov    0x804004,%eax
  80135e:	85 c0                	test   %eax,%eax
  801360:	74 1f                	je     801381 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801362:	e8 1d 00 00 00       	call   801384 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801367:	83 ec 0c             	sub    $0xc,%esp
  80136a:	68 50 39 80 00       	push   $0x803950
  80136f:	e8 55 f2 ff ff       	call   8005c9 <cprintf>
  801374:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801377:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80137e:	00 00 00 
	}
}
  801381:	90                   	nop
  801382:	c9                   	leave  
  801383:	c3                   	ret    

00801384 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
  801387:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  80138a:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801391:	00 00 00 
  801394:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80139b:	00 00 00 
  80139e:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8013a5:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8013a8:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8013af:	00 00 00 
  8013b2:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8013b9:	00 00 00 
  8013bc:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8013c3:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8013c6:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8013cd:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  8013d0:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8013d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013df:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013e4:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  8013e9:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  8013f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013f3:	a1 20 41 80 00       	mov    0x804120,%eax
  8013f8:	0f af c2             	imul   %edx,%eax
  8013fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  8013fe:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801405:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801408:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80140b:	01 d0                	add    %edx,%eax
  80140d:	48                   	dec    %eax
  80140e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801411:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801414:	ba 00 00 00 00       	mov    $0x0,%edx
  801419:	f7 75 e8             	divl   -0x18(%ebp)
  80141c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80141f:	29 d0                	sub    %edx,%eax
  801421:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801424:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801427:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  80142e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801431:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801437:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  80143d:	83 ec 04             	sub    $0x4,%esp
  801440:	6a 06                	push   $0x6
  801442:	50                   	push   %eax
  801443:	52                   	push   %edx
  801444:	e8 a1 05 00 00       	call   8019ea <sys_allocate_chunk>
  801449:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80144c:	a1 20 41 80 00       	mov    0x804120,%eax
  801451:	83 ec 0c             	sub    $0xc,%esp
  801454:	50                   	push   %eax
  801455:	e8 16 0c 00 00       	call   802070 <initialize_MemBlocksList>
  80145a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  80145d:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801462:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801465:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801469:	75 14                	jne    80147f <initialize_dyn_block_system+0xfb>
  80146b:	83 ec 04             	sub    $0x4,%esp
  80146e:	68 75 39 80 00       	push   $0x803975
  801473:	6a 2d                	push   $0x2d
  801475:	68 93 39 80 00       	push   $0x803993
  80147a:	e8 96 ee ff ff       	call   800315 <_panic>
  80147f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801482:	8b 00                	mov    (%eax),%eax
  801484:	85 c0                	test   %eax,%eax
  801486:	74 10                	je     801498 <initialize_dyn_block_system+0x114>
  801488:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80148b:	8b 00                	mov    (%eax),%eax
  80148d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801490:	8b 52 04             	mov    0x4(%edx),%edx
  801493:	89 50 04             	mov    %edx,0x4(%eax)
  801496:	eb 0b                	jmp    8014a3 <initialize_dyn_block_system+0x11f>
  801498:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80149b:	8b 40 04             	mov    0x4(%eax),%eax
  80149e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8014a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014a6:	8b 40 04             	mov    0x4(%eax),%eax
  8014a9:	85 c0                	test   %eax,%eax
  8014ab:	74 0f                	je     8014bc <initialize_dyn_block_system+0x138>
  8014ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014b0:	8b 40 04             	mov    0x4(%eax),%eax
  8014b3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014b6:	8b 12                	mov    (%edx),%edx
  8014b8:	89 10                	mov    %edx,(%eax)
  8014ba:	eb 0a                	jmp    8014c6 <initialize_dyn_block_system+0x142>
  8014bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014bf:	8b 00                	mov    (%eax),%eax
  8014c1:	a3 48 41 80 00       	mov    %eax,0x804148
  8014c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014d9:	a1 54 41 80 00       	mov    0x804154,%eax
  8014de:	48                   	dec    %eax
  8014df:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  8014e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014e7:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  8014ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014f1:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  8014f8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8014fc:	75 14                	jne    801512 <initialize_dyn_block_system+0x18e>
  8014fe:	83 ec 04             	sub    $0x4,%esp
  801501:	68 a0 39 80 00       	push   $0x8039a0
  801506:	6a 30                	push   $0x30
  801508:	68 93 39 80 00       	push   $0x803993
  80150d:	e8 03 ee ff ff       	call   800315 <_panic>
  801512:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  801518:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80151b:	89 50 04             	mov    %edx,0x4(%eax)
  80151e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801521:	8b 40 04             	mov    0x4(%eax),%eax
  801524:	85 c0                	test   %eax,%eax
  801526:	74 0c                	je     801534 <initialize_dyn_block_system+0x1b0>
  801528:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80152d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801530:	89 10                	mov    %edx,(%eax)
  801532:	eb 08                	jmp    80153c <initialize_dyn_block_system+0x1b8>
  801534:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801537:	a3 38 41 80 00       	mov    %eax,0x804138
  80153c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80153f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801544:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801547:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80154d:	a1 44 41 80 00       	mov    0x804144,%eax
  801552:	40                   	inc    %eax
  801553:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801558:	90                   	nop
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
  80155e:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801561:	e8 ed fd ff ff       	call   801353 <InitializeUHeap>
	if (size == 0) return NULL ;
  801566:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80156a:	75 07                	jne    801573 <malloc+0x18>
  80156c:	b8 00 00 00 00       	mov    $0x0,%eax
  801571:	eb 67                	jmp    8015da <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801573:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80157a:	8b 55 08             	mov    0x8(%ebp),%edx
  80157d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801580:	01 d0                	add    %edx,%eax
  801582:	48                   	dec    %eax
  801583:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801586:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801589:	ba 00 00 00 00       	mov    $0x0,%edx
  80158e:	f7 75 f4             	divl   -0xc(%ebp)
  801591:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801594:	29 d0                	sub    %edx,%eax
  801596:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801599:	e8 1a 08 00 00       	call   801db8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80159e:	85 c0                	test   %eax,%eax
  8015a0:	74 33                	je     8015d5 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  8015a2:	83 ec 0c             	sub    $0xc,%esp
  8015a5:	ff 75 08             	pushl  0x8(%ebp)
  8015a8:	e8 0c 0e 00 00       	call   8023b9 <alloc_block_FF>
  8015ad:	83 c4 10             	add    $0x10,%esp
  8015b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  8015b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015b7:	74 1c                	je     8015d5 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  8015b9:	83 ec 0c             	sub    $0xc,%esp
  8015bc:	ff 75 ec             	pushl  -0x14(%ebp)
  8015bf:	e8 07 0c 00 00       	call   8021cb <insert_sorted_allocList>
  8015c4:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  8015c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ca:	8b 40 08             	mov    0x8(%eax),%eax
  8015cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  8015d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015d3:	eb 05                	jmp    8015da <malloc+0x7f>
		}
	}
	return NULL;
  8015d5:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  8015e8:	83 ec 08             	sub    $0x8,%esp
  8015eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8015ee:	68 40 40 80 00       	push   $0x804040
  8015f3:	e8 5b 0b 00 00       	call   802153 <find_block>
  8015f8:	83 c4 10             	add    $0x10,%esp
  8015fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  8015fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801601:	8b 40 0c             	mov    0xc(%eax),%eax
  801604:	83 ec 08             	sub    $0x8,%esp
  801607:	50                   	push   %eax
  801608:	ff 75 f4             	pushl  -0xc(%ebp)
  80160b:	e8 a2 03 00 00       	call   8019b2 <sys_free_user_mem>
  801610:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801613:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801617:	75 14                	jne    80162d <free+0x51>
  801619:	83 ec 04             	sub    $0x4,%esp
  80161c:	68 75 39 80 00       	push   $0x803975
  801621:	6a 76                	push   $0x76
  801623:	68 93 39 80 00       	push   $0x803993
  801628:	e8 e8 ec ff ff       	call   800315 <_panic>
  80162d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801630:	8b 00                	mov    (%eax),%eax
  801632:	85 c0                	test   %eax,%eax
  801634:	74 10                	je     801646 <free+0x6a>
  801636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801639:	8b 00                	mov    (%eax),%eax
  80163b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80163e:	8b 52 04             	mov    0x4(%edx),%edx
  801641:	89 50 04             	mov    %edx,0x4(%eax)
  801644:	eb 0b                	jmp    801651 <free+0x75>
  801646:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801649:	8b 40 04             	mov    0x4(%eax),%eax
  80164c:	a3 44 40 80 00       	mov    %eax,0x804044
  801651:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801654:	8b 40 04             	mov    0x4(%eax),%eax
  801657:	85 c0                	test   %eax,%eax
  801659:	74 0f                	je     80166a <free+0x8e>
  80165b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165e:	8b 40 04             	mov    0x4(%eax),%eax
  801661:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801664:	8b 12                	mov    (%edx),%edx
  801666:	89 10                	mov    %edx,(%eax)
  801668:	eb 0a                	jmp    801674 <free+0x98>
  80166a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166d:	8b 00                	mov    (%eax),%eax
  80166f:	a3 40 40 80 00       	mov    %eax,0x804040
  801674:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801677:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80167d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801680:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801687:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80168c:	48                   	dec    %eax
  80168d:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  801692:	83 ec 0c             	sub    $0xc,%esp
  801695:	ff 75 f0             	pushl  -0x10(%ebp)
  801698:	e8 0b 14 00 00       	call   802aa8 <insert_sorted_with_merge_freeList>
  80169d:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8016a0:	90                   	nop
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	83 ec 28             	sub    $0x28,%esp
  8016a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ac:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016af:	e8 9f fc ff ff       	call   801353 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016b8:	75 0a                	jne    8016c4 <smalloc+0x21>
  8016ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8016bf:	e9 8d 00 00 00       	jmp    801751 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  8016c4:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d1:	01 d0                	add    %edx,%eax
  8016d3:	48                   	dec    %eax
  8016d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016da:	ba 00 00 00 00       	mov    $0x0,%edx
  8016df:	f7 75 f4             	divl   -0xc(%ebp)
  8016e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e5:	29 d0                	sub    %edx,%eax
  8016e7:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016ea:	e8 c9 06 00 00       	call   801db8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016ef:	85 c0                	test   %eax,%eax
  8016f1:	74 59                	je     80174c <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  8016f3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  8016fa:	83 ec 0c             	sub    $0xc,%esp
  8016fd:	ff 75 0c             	pushl  0xc(%ebp)
  801700:	e8 b4 0c 00 00       	call   8023b9 <alloc_block_FF>
  801705:	83 c4 10             	add    $0x10,%esp
  801708:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  80170b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80170f:	75 07                	jne    801718 <smalloc+0x75>
			{
				return NULL;
  801711:	b8 00 00 00 00       	mov    $0x0,%eax
  801716:	eb 39                	jmp    801751 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801718:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80171b:	8b 40 08             	mov    0x8(%eax),%eax
  80171e:	89 c2                	mov    %eax,%edx
  801720:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801724:	52                   	push   %edx
  801725:	50                   	push   %eax
  801726:	ff 75 0c             	pushl  0xc(%ebp)
  801729:	ff 75 08             	pushl  0x8(%ebp)
  80172c:	e8 0c 04 00 00       	call   801b3d <sys_createSharedObject>
  801731:	83 c4 10             	add    $0x10,%esp
  801734:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  801737:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80173b:	78 08                	js     801745 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  80173d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801740:	8b 40 08             	mov    0x8(%eax),%eax
  801743:	eb 0c                	jmp    801751 <smalloc+0xae>
				}
				else
				{
					return NULL;
  801745:	b8 00 00 00 00       	mov    $0x0,%eax
  80174a:	eb 05                	jmp    801751 <smalloc+0xae>
				}
			}

		}
		return NULL;
  80174c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801759:	e8 f5 fb ff ff       	call   801353 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80175e:	83 ec 08             	sub    $0x8,%esp
  801761:	ff 75 0c             	pushl  0xc(%ebp)
  801764:	ff 75 08             	pushl  0x8(%ebp)
  801767:	e8 fb 03 00 00       	call   801b67 <sys_getSizeOfSharedObject>
  80176c:	83 c4 10             	add    $0x10,%esp
  80176f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801772:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801776:	75 07                	jne    80177f <sget+0x2c>
	{
		return NULL;
  801778:	b8 00 00 00 00       	mov    $0x0,%eax
  80177d:	eb 64                	jmp    8017e3 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80177f:	e8 34 06 00 00       	call   801db8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801784:	85 c0                	test   %eax,%eax
  801786:	74 56                	je     8017de <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801788:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  80178f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801792:	83 ec 0c             	sub    $0xc,%esp
  801795:	50                   	push   %eax
  801796:	e8 1e 0c 00 00       	call   8023b9 <alloc_block_FF>
  80179b:	83 c4 10             	add    $0x10,%esp
  80179e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  8017a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017a5:	75 07                	jne    8017ae <sget+0x5b>
		{
		return NULL;
  8017a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ac:	eb 35                	jmp    8017e3 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  8017ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b1:	8b 40 08             	mov    0x8(%eax),%eax
  8017b4:	83 ec 04             	sub    $0x4,%esp
  8017b7:	50                   	push   %eax
  8017b8:	ff 75 0c             	pushl  0xc(%ebp)
  8017bb:	ff 75 08             	pushl  0x8(%ebp)
  8017be:	e8 c1 03 00 00       	call   801b84 <sys_getSharedObject>
  8017c3:	83 c4 10             	add    $0x10,%esp
  8017c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  8017c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017cd:	78 08                	js     8017d7 <sget+0x84>
			{
				return (void*)v1->sva;
  8017cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d2:	8b 40 08             	mov    0x8(%eax),%eax
  8017d5:	eb 0c                	jmp    8017e3 <sget+0x90>
			}
			else
			{
				return NULL;
  8017d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017dc:	eb 05                	jmp    8017e3 <sget+0x90>
			}
		}
	}
  return NULL;
  8017de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e3:	c9                   	leave  
  8017e4:	c3                   	ret    

008017e5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
  8017e8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017eb:	e8 63 fb ff ff       	call   801353 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017f0:	83 ec 04             	sub    $0x4,%esp
  8017f3:	68 c4 39 80 00       	push   $0x8039c4
  8017f8:	68 0e 01 00 00       	push   $0x10e
  8017fd:	68 93 39 80 00       	push   $0x803993
  801802:	e8 0e eb ff ff       	call   800315 <_panic>

00801807 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80180d:	83 ec 04             	sub    $0x4,%esp
  801810:	68 ec 39 80 00       	push   $0x8039ec
  801815:	68 22 01 00 00       	push   $0x122
  80181a:	68 93 39 80 00       	push   $0x803993
  80181f:	e8 f1 ea ff ff       	call   800315 <_panic>

00801824 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
  801827:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80182a:	83 ec 04             	sub    $0x4,%esp
  80182d:	68 10 3a 80 00       	push   $0x803a10
  801832:	68 2d 01 00 00       	push   $0x12d
  801837:	68 93 39 80 00       	push   $0x803993
  80183c:	e8 d4 ea ff ff       	call   800315 <_panic>

00801841 <shrink>:

}
void shrink(uint32 newSize)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
  801844:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801847:	83 ec 04             	sub    $0x4,%esp
  80184a:	68 10 3a 80 00       	push   $0x803a10
  80184f:	68 32 01 00 00       	push   $0x132
  801854:	68 93 39 80 00       	push   $0x803993
  801859:	e8 b7 ea ff ff       	call   800315 <_panic>

0080185e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801864:	83 ec 04             	sub    $0x4,%esp
  801867:	68 10 3a 80 00       	push   $0x803a10
  80186c:	68 37 01 00 00       	push   $0x137
  801871:	68 93 39 80 00       	push   $0x803993
  801876:	e8 9a ea ff ff       	call   800315 <_panic>

0080187b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	57                   	push   %edi
  80187f:	56                   	push   %esi
  801880:	53                   	push   %ebx
  801881:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801884:	8b 45 08             	mov    0x8(%ebp),%eax
  801887:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80188d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801890:	8b 7d 18             	mov    0x18(%ebp),%edi
  801893:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801896:	cd 30                	int    $0x30
  801898:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80189b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80189e:	83 c4 10             	add    $0x10,%esp
  8018a1:	5b                   	pop    %ebx
  8018a2:	5e                   	pop    %esi
  8018a3:	5f                   	pop    %edi
  8018a4:	5d                   	pop    %ebp
  8018a5:	c3                   	ret    

008018a6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	83 ec 04             	sub    $0x4,%esp
  8018ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8018af:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018b2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	52                   	push   %edx
  8018be:	ff 75 0c             	pushl  0xc(%ebp)
  8018c1:	50                   	push   %eax
  8018c2:	6a 00                	push   $0x0
  8018c4:	e8 b2 ff ff ff       	call   80187b <syscall>
  8018c9:	83 c4 18             	add    $0x18,%esp
}
  8018cc:	90                   	nop
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <sys_cgetc>:

int
sys_cgetc(void)
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 01                	push   $0x1
  8018de:	e8 98 ff ff ff       	call   80187b <syscall>
  8018e3:	83 c4 18             	add    $0x18,%esp
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	52                   	push   %edx
  8018f8:	50                   	push   %eax
  8018f9:	6a 05                	push   $0x5
  8018fb:	e8 7b ff ff ff       	call   80187b <syscall>
  801900:	83 c4 18             	add    $0x18,%esp
}
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
  801908:	56                   	push   %esi
  801909:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80190a:	8b 75 18             	mov    0x18(%ebp),%esi
  80190d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801910:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801913:	8b 55 0c             	mov    0xc(%ebp),%edx
  801916:	8b 45 08             	mov    0x8(%ebp),%eax
  801919:	56                   	push   %esi
  80191a:	53                   	push   %ebx
  80191b:	51                   	push   %ecx
  80191c:	52                   	push   %edx
  80191d:	50                   	push   %eax
  80191e:	6a 06                	push   $0x6
  801920:	e8 56 ff ff ff       	call   80187b <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
}
  801928:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80192b:	5b                   	pop    %ebx
  80192c:	5e                   	pop    %esi
  80192d:	5d                   	pop    %ebp
  80192e:	c3                   	ret    

0080192f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801932:	8b 55 0c             	mov    0xc(%ebp),%edx
  801935:	8b 45 08             	mov    0x8(%ebp),%eax
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	52                   	push   %edx
  80193f:	50                   	push   %eax
  801940:	6a 07                	push   $0x7
  801942:	e8 34 ff ff ff       	call   80187b <syscall>
  801947:	83 c4 18             	add    $0x18,%esp
}
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	ff 75 0c             	pushl  0xc(%ebp)
  801958:	ff 75 08             	pushl  0x8(%ebp)
  80195b:	6a 08                	push   $0x8
  80195d:	e8 19 ff ff ff       	call   80187b <syscall>
  801962:	83 c4 18             	add    $0x18,%esp
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 09                	push   $0x9
  801976:	e8 00 ff ff ff       	call   80187b <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 0a                	push   $0xa
  80198f:	e8 e7 fe ff ff       	call   80187b <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 0b                	push   $0xb
  8019a8:	e8 ce fe ff ff       	call   80187b <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
}
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	ff 75 0c             	pushl  0xc(%ebp)
  8019be:	ff 75 08             	pushl  0x8(%ebp)
  8019c1:	6a 0f                	push   $0xf
  8019c3:	e8 b3 fe ff ff       	call   80187b <syscall>
  8019c8:	83 c4 18             	add    $0x18,%esp
	return;
  8019cb:	90                   	nop
}
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	ff 75 0c             	pushl  0xc(%ebp)
  8019da:	ff 75 08             	pushl  0x8(%ebp)
  8019dd:	6a 10                	push   $0x10
  8019df:	e8 97 fe ff ff       	call   80187b <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e7:	90                   	nop
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	ff 75 10             	pushl  0x10(%ebp)
  8019f4:	ff 75 0c             	pushl  0xc(%ebp)
  8019f7:	ff 75 08             	pushl  0x8(%ebp)
  8019fa:	6a 11                	push   $0x11
  8019fc:	e8 7a fe ff ff       	call   80187b <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
	return ;
  801a04:	90                   	nop
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 0c                	push   $0xc
  801a16:	e8 60 fe ff ff       	call   80187b <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	ff 75 08             	pushl  0x8(%ebp)
  801a2e:	6a 0d                	push   $0xd
  801a30:	e8 46 fe ff ff       	call   80187b <syscall>
  801a35:	83 c4 18             	add    $0x18,%esp
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 0e                	push   $0xe
  801a49:	e8 2d fe ff ff       	call   80187b <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
}
  801a51:	90                   	nop
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 13                	push   $0x13
  801a63:	e8 13 fe ff ff       	call   80187b <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
}
  801a6b:	90                   	nop
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 14                	push   $0x14
  801a7d:	e8 f9 fd ff ff       	call   80187b <syscall>
  801a82:	83 c4 18             	add    $0x18,%esp
}
  801a85:	90                   	nop
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
  801a8b:	83 ec 04             	sub    $0x4,%esp
  801a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a91:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a94:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	50                   	push   %eax
  801aa1:	6a 15                	push   $0x15
  801aa3:	e8 d3 fd ff ff       	call   80187b <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
}
  801aab:	90                   	nop
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 16                	push   $0x16
  801abd:	e8 b9 fd ff ff       	call   80187b <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
}
  801ac5:	90                   	nop
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801acb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	ff 75 0c             	pushl  0xc(%ebp)
  801ad7:	50                   	push   %eax
  801ad8:	6a 17                	push   $0x17
  801ada:	e8 9c fd ff ff       	call   80187b <syscall>
  801adf:	83 c4 18             	add    $0x18,%esp
}
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ae7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	52                   	push   %edx
  801af4:	50                   	push   %eax
  801af5:	6a 1a                	push   $0x1a
  801af7:	e8 7f fd ff ff       	call   80187b <syscall>
  801afc:	83 c4 18             	add    $0x18,%esp
}
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	52                   	push   %edx
  801b11:	50                   	push   %eax
  801b12:	6a 18                	push   $0x18
  801b14:	e8 62 fd ff ff       	call   80187b <syscall>
  801b19:	83 c4 18             	add    $0x18,%esp
}
  801b1c:	90                   	nop
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b25:	8b 45 08             	mov    0x8(%ebp),%eax
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	52                   	push   %edx
  801b2f:	50                   	push   %eax
  801b30:	6a 19                	push   $0x19
  801b32:	e8 44 fd ff ff       	call   80187b <syscall>
  801b37:	83 c4 18             	add    $0x18,%esp
}
  801b3a:	90                   	nop
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
  801b40:	83 ec 04             	sub    $0x4,%esp
  801b43:	8b 45 10             	mov    0x10(%ebp),%eax
  801b46:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b49:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b4c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
  801b53:	6a 00                	push   $0x0
  801b55:	51                   	push   %ecx
  801b56:	52                   	push   %edx
  801b57:	ff 75 0c             	pushl  0xc(%ebp)
  801b5a:	50                   	push   %eax
  801b5b:	6a 1b                	push   $0x1b
  801b5d:	e8 19 fd ff ff       	call   80187b <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	52                   	push   %edx
  801b77:	50                   	push   %eax
  801b78:	6a 1c                	push   $0x1c
  801b7a:	e8 fc fc ff ff       	call   80187b <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
}
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b87:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	51                   	push   %ecx
  801b95:	52                   	push   %edx
  801b96:	50                   	push   %eax
  801b97:	6a 1d                	push   $0x1d
  801b99:	e8 dd fc ff ff       	call   80187b <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
}
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ba6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	52                   	push   %edx
  801bb3:	50                   	push   %eax
  801bb4:	6a 1e                	push   $0x1e
  801bb6:	e8 c0 fc ff ff       	call   80187b <syscall>
  801bbb:	83 c4 18             	add    $0x18,%esp
}
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 1f                	push   $0x1f
  801bcf:	e8 a7 fc ff ff       	call   80187b <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
}
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdf:	6a 00                	push   $0x0
  801be1:	ff 75 14             	pushl  0x14(%ebp)
  801be4:	ff 75 10             	pushl  0x10(%ebp)
  801be7:	ff 75 0c             	pushl  0xc(%ebp)
  801bea:	50                   	push   %eax
  801beb:	6a 20                	push   $0x20
  801bed:	e8 89 fc ff ff       	call   80187b <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	50                   	push   %eax
  801c06:	6a 21                	push   $0x21
  801c08:	e8 6e fc ff ff       	call   80187b <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
}
  801c10:	90                   	nop
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c16:	8b 45 08             	mov    0x8(%ebp),%eax
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	50                   	push   %eax
  801c22:	6a 22                	push   $0x22
  801c24:	e8 52 fc ff ff       	call   80187b <syscall>
  801c29:	83 c4 18             	add    $0x18,%esp
}
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    

00801c2e <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 02                	push   $0x2
  801c3d:	e8 39 fc ff ff       	call   80187b <syscall>
  801c42:	83 c4 18             	add    $0x18,%esp
}
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 03                	push   $0x3
  801c56:	e8 20 fc ff ff       	call   80187b <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
}
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    

00801c60 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 04                	push   $0x4
  801c6f:	e8 07 fc ff ff       	call   80187b <syscall>
  801c74:	83 c4 18             	add    $0x18,%esp
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <sys_exit_env>:


void sys_exit_env(void)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 23                	push   $0x23
  801c88:	e8 ee fb ff ff       	call   80187b <syscall>
  801c8d:	83 c4 18             	add    $0x18,%esp
}
  801c90:	90                   	nop
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    

00801c93 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
  801c96:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c99:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c9c:	8d 50 04             	lea    0x4(%eax),%edx
  801c9f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	52                   	push   %edx
  801ca9:	50                   	push   %eax
  801caa:	6a 24                	push   $0x24
  801cac:	e8 ca fb ff ff       	call   80187b <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
	return result;
  801cb4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cbd:	89 01                	mov    %eax,(%ecx)
  801cbf:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc5:	c9                   	leave  
  801cc6:	c2 04 00             	ret    $0x4

00801cc9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	ff 75 10             	pushl  0x10(%ebp)
  801cd3:	ff 75 0c             	pushl  0xc(%ebp)
  801cd6:	ff 75 08             	pushl  0x8(%ebp)
  801cd9:	6a 12                	push   $0x12
  801cdb:	e8 9b fb ff ff       	call   80187b <syscall>
  801ce0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce3:	90                   	nop
}
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 25                	push   $0x25
  801cf5:	e8 81 fb ff ff       	call   80187b <syscall>
  801cfa:	83 c4 18             	add    $0x18,%esp
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
  801d02:	83 ec 04             	sub    $0x4,%esp
  801d05:	8b 45 08             	mov    0x8(%ebp),%eax
  801d08:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d0b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	50                   	push   %eax
  801d18:	6a 26                	push   $0x26
  801d1a:	e8 5c fb ff ff       	call   80187b <syscall>
  801d1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d22:	90                   	nop
}
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <rsttst>:
void rsttst()
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 28                	push   $0x28
  801d34:	e8 42 fb ff ff       	call   80187b <syscall>
  801d39:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3c:	90                   	nop
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	83 ec 04             	sub    $0x4,%esp
  801d45:	8b 45 14             	mov    0x14(%ebp),%eax
  801d48:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d4b:	8b 55 18             	mov    0x18(%ebp),%edx
  801d4e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d52:	52                   	push   %edx
  801d53:	50                   	push   %eax
  801d54:	ff 75 10             	pushl  0x10(%ebp)
  801d57:	ff 75 0c             	pushl  0xc(%ebp)
  801d5a:	ff 75 08             	pushl  0x8(%ebp)
  801d5d:	6a 27                	push   $0x27
  801d5f:	e8 17 fb ff ff       	call   80187b <syscall>
  801d64:	83 c4 18             	add    $0x18,%esp
	return ;
  801d67:	90                   	nop
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <chktst>:
void chktst(uint32 n)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	ff 75 08             	pushl  0x8(%ebp)
  801d78:	6a 29                	push   $0x29
  801d7a:	e8 fc fa ff ff       	call   80187b <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d82:	90                   	nop
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <inctst>:

void inctst()
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 2a                	push   $0x2a
  801d94:	e8 e2 fa ff ff       	call   80187b <syscall>
  801d99:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9c:	90                   	nop
}
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    

00801d9f <gettst>:
uint32 gettst()
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 2b                	push   $0x2b
  801dae:	e8 c8 fa ff ff       	call   80187b <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 2c                	push   $0x2c
  801dca:	e8 ac fa ff ff       	call   80187b <syscall>
  801dcf:	83 c4 18             	add    $0x18,%esp
  801dd2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dd5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dd9:	75 07                	jne    801de2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ddb:	b8 01 00 00 00       	mov    $0x1,%eax
  801de0:	eb 05                	jmp    801de7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801de2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
  801dec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 2c                	push   $0x2c
  801dfb:	e8 7b fa ff ff       	call   80187b <syscall>
  801e00:	83 c4 18             	add    $0x18,%esp
  801e03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e06:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e0a:	75 07                	jne    801e13 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e0c:	b8 01 00 00 00       	mov    $0x1,%eax
  801e11:	eb 05                	jmp    801e18 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e18:	c9                   	leave  
  801e19:	c3                   	ret    

00801e1a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
  801e1d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 2c                	push   $0x2c
  801e2c:	e8 4a fa ff ff       	call   80187b <syscall>
  801e31:	83 c4 18             	add    $0x18,%esp
  801e34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e37:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e3b:	75 07                	jne    801e44 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e3d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e42:	eb 05                	jmp    801e49 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e49:	c9                   	leave  
  801e4a:	c3                   	ret    

00801e4b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
  801e4e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 2c                	push   $0x2c
  801e5d:	e8 19 fa ff ff       	call   80187b <syscall>
  801e62:	83 c4 18             	add    $0x18,%esp
  801e65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e68:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e6c:	75 07                	jne    801e75 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e73:	eb 05                	jmp    801e7a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	ff 75 08             	pushl  0x8(%ebp)
  801e8a:	6a 2d                	push   $0x2d
  801e8c:	e8 ea f9 ff ff       	call   80187b <syscall>
  801e91:	83 c4 18             	add    $0x18,%esp
	return ;
  801e94:	90                   	nop
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e9b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e9e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ea1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea7:	6a 00                	push   $0x0
  801ea9:	53                   	push   %ebx
  801eaa:	51                   	push   %ecx
  801eab:	52                   	push   %edx
  801eac:	50                   	push   %eax
  801ead:	6a 2e                	push   $0x2e
  801eaf:	e8 c7 f9 ff ff       	call   80187b <syscall>
  801eb4:	83 c4 18             	add    $0x18,%esp
}
  801eb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eba:	c9                   	leave  
  801ebb:	c3                   	ret    

00801ebc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ebf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	52                   	push   %edx
  801ecc:	50                   	push   %eax
  801ecd:	6a 2f                	push   $0x2f
  801ecf:	e8 a7 f9 ff ff       	call   80187b <syscall>
  801ed4:	83 c4 18             	add    $0x18,%esp
}
  801ed7:	c9                   	leave  
  801ed8:	c3                   	ret    

00801ed9 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
  801edc:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801edf:	83 ec 0c             	sub    $0xc,%esp
  801ee2:	68 20 3a 80 00       	push   $0x803a20
  801ee7:	e8 dd e6 ff ff       	call   8005c9 <cprintf>
  801eec:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801eef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ef6:	83 ec 0c             	sub    $0xc,%esp
  801ef9:	68 4c 3a 80 00       	push   $0x803a4c
  801efe:	e8 c6 e6 ff ff       	call   8005c9 <cprintf>
  801f03:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f06:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f0a:	a1 38 41 80 00       	mov    0x804138,%eax
  801f0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f12:	eb 56                	jmp    801f6a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f14:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f18:	74 1c                	je     801f36 <print_mem_block_lists+0x5d>
  801f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1d:	8b 50 08             	mov    0x8(%eax),%edx
  801f20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f23:	8b 48 08             	mov    0x8(%eax),%ecx
  801f26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f29:	8b 40 0c             	mov    0xc(%eax),%eax
  801f2c:	01 c8                	add    %ecx,%eax
  801f2e:	39 c2                	cmp    %eax,%edx
  801f30:	73 04                	jae    801f36 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f32:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f39:	8b 50 08             	mov    0x8(%eax),%edx
  801f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f42:	01 c2                	add    %eax,%edx
  801f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f47:	8b 40 08             	mov    0x8(%eax),%eax
  801f4a:	83 ec 04             	sub    $0x4,%esp
  801f4d:	52                   	push   %edx
  801f4e:	50                   	push   %eax
  801f4f:	68 61 3a 80 00       	push   $0x803a61
  801f54:	e8 70 e6 ff ff       	call   8005c9 <cprintf>
  801f59:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f62:	a1 40 41 80 00       	mov    0x804140,%eax
  801f67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f6e:	74 07                	je     801f77 <print_mem_block_lists+0x9e>
  801f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f73:	8b 00                	mov    (%eax),%eax
  801f75:	eb 05                	jmp    801f7c <print_mem_block_lists+0xa3>
  801f77:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7c:	a3 40 41 80 00       	mov    %eax,0x804140
  801f81:	a1 40 41 80 00       	mov    0x804140,%eax
  801f86:	85 c0                	test   %eax,%eax
  801f88:	75 8a                	jne    801f14 <print_mem_block_lists+0x3b>
  801f8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f8e:	75 84                	jne    801f14 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f90:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f94:	75 10                	jne    801fa6 <print_mem_block_lists+0xcd>
  801f96:	83 ec 0c             	sub    $0xc,%esp
  801f99:	68 70 3a 80 00       	push   $0x803a70
  801f9e:	e8 26 e6 ff ff       	call   8005c9 <cprintf>
  801fa3:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fa6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fad:	83 ec 0c             	sub    $0xc,%esp
  801fb0:	68 94 3a 80 00       	push   $0x803a94
  801fb5:	e8 0f e6 ff ff       	call   8005c9 <cprintf>
  801fba:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fbd:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fc1:	a1 40 40 80 00       	mov    0x804040,%eax
  801fc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc9:	eb 56                	jmp    802021 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fcb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fcf:	74 1c                	je     801fed <print_mem_block_lists+0x114>
  801fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd4:	8b 50 08             	mov    0x8(%eax),%edx
  801fd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fda:	8b 48 08             	mov    0x8(%eax),%ecx
  801fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe0:	8b 40 0c             	mov    0xc(%eax),%eax
  801fe3:	01 c8                	add    %ecx,%eax
  801fe5:	39 c2                	cmp    %eax,%edx
  801fe7:	73 04                	jae    801fed <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fe9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff0:	8b 50 08             	mov    0x8(%eax),%edx
  801ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ff9:	01 c2                	add    %eax,%edx
  801ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffe:	8b 40 08             	mov    0x8(%eax),%eax
  802001:	83 ec 04             	sub    $0x4,%esp
  802004:	52                   	push   %edx
  802005:	50                   	push   %eax
  802006:	68 61 3a 80 00       	push   $0x803a61
  80200b:	e8 b9 e5 ff ff       	call   8005c9 <cprintf>
  802010:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802016:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802019:	a1 48 40 80 00       	mov    0x804048,%eax
  80201e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802021:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802025:	74 07                	je     80202e <print_mem_block_lists+0x155>
  802027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202a:	8b 00                	mov    (%eax),%eax
  80202c:	eb 05                	jmp    802033 <print_mem_block_lists+0x15a>
  80202e:	b8 00 00 00 00       	mov    $0x0,%eax
  802033:	a3 48 40 80 00       	mov    %eax,0x804048
  802038:	a1 48 40 80 00       	mov    0x804048,%eax
  80203d:	85 c0                	test   %eax,%eax
  80203f:	75 8a                	jne    801fcb <print_mem_block_lists+0xf2>
  802041:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802045:	75 84                	jne    801fcb <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802047:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80204b:	75 10                	jne    80205d <print_mem_block_lists+0x184>
  80204d:	83 ec 0c             	sub    $0xc,%esp
  802050:	68 ac 3a 80 00       	push   $0x803aac
  802055:	e8 6f e5 ff ff       	call   8005c9 <cprintf>
  80205a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80205d:	83 ec 0c             	sub    $0xc,%esp
  802060:	68 20 3a 80 00       	push   $0x803a20
  802065:	e8 5f e5 ff ff       	call   8005c9 <cprintf>
  80206a:	83 c4 10             	add    $0x10,%esp

}
  80206d:	90                   	nop
  80206e:	c9                   	leave  
  80206f:	c3                   	ret    

00802070 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  802076:	8b 45 08             	mov    0x8(%ebp),%eax
  802079:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  80207c:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802083:	00 00 00 
  802086:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80208d:	00 00 00 
  802090:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802097:	00 00 00 
	for(int i = 0; i<n;i++)
  80209a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020a1:	e9 9e 00 00 00       	jmp    802144 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  8020a6:	a1 50 40 80 00       	mov    0x804050,%eax
  8020ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ae:	c1 e2 04             	shl    $0x4,%edx
  8020b1:	01 d0                	add    %edx,%eax
  8020b3:	85 c0                	test   %eax,%eax
  8020b5:	75 14                	jne    8020cb <initialize_MemBlocksList+0x5b>
  8020b7:	83 ec 04             	sub    $0x4,%esp
  8020ba:	68 d4 3a 80 00       	push   $0x803ad4
  8020bf:	6a 47                	push   $0x47
  8020c1:	68 f7 3a 80 00       	push   $0x803af7
  8020c6:	e8 4a e2 ff ff       	call   800315 <_panic>
  8020cb:	a1 50 40 80 00       	mov    0x804050,%eax
  8020d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d3:	c1 e2 04             	shl    $0x4,%edx
  8020d6:	01 d0                	add    %edx,%eax
  8020d8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020de:	89 10                	mov    %edx,(%eax)
  8020e0:	8b 00                	mov    (%eax),%eax
  8020e2:	85 c0                	test   %eax,%eax
  8020e4:	74 18                	je     8020fe <initialize_MemBlocksList+0x8e>
  8020e6:	a1 48 41 80 00       	mov    0x804148,%eax
  8020eb:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020f1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020f4:	c1 e1 04             	shl    $0x4,%ecx
  8020f7:	01 ca                	add    %ecx,%edx
  8020f9:	89 50 04             	mov    %edx,0x4(%eax)
  8020fc:	eb 12                	jmp    802110 <initialize_MemBlocksList+0xa0>
  8020fe:	a1 50 40 80 00       	mov    0x804050,%eax
  802103:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802106:	c1 e2 04             	shl    $0x4,%edx
  802109:	01 d0                	add    %edx,%eax
  80210b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802110:	a1 50 40 80 00       	mov    0x804050,%eax
  802115:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802118:	c1 e2 04             	shl    $0x4,%edx
  80211b:	01 d0                	add    %edx,%eax
  80211d:	a3 48 41 80 00       	mov    %eax,0x804148
  802122:	a1 50 40 80 00       	mov    0x804050,%eax
  802127:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80212a:	c1 e2 04             	shl    $0x4,%edx
  80212d:	01 d0                	add    %edx,%eax
  80212f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802136:	a1 54 41 80 00       	mov    0x804154,%eax
  80213b:	40                   	inc    %eax
  80213c:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  802141:	ff 45 f4             	incl   -0xc(%ebp)
  802144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802147:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80214a:	0f 82 56 ff ff ff    	jb     8020a6 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  802150:	90                   	nop
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
  802156:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  802159:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  80215f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802166:	a1 40 40 80 00       	mov    0x804040,%eax
  80216b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80216e:	eb 23                	jmp    802193 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802170:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802173:	8b 40 08             	mov    0x8(%eax),%eax
  802176:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802179:	75 09                	jne    802184 <find_block+0x31>
		{
			found = 1;
  80217b:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802182:	eb 35                	jmp    8021b9 <find_block+0x66>
		}
		else
		{
			found = 0;
  802184:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80218b:	a1 48 40 80 00       	mov    0x804048,%eax
  802190:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802193:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802197:	74 07                	je     8021a0 <find_block+0x4d>
  802199:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80219c:	8b 00                	mov    (%eax),%eax
  80219e:	eb 05                	jmp    8021a5 <find_block+0x52>
  8021a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a5:	a3 48 40 80 00       	mov    %eax,0x804048
  8021aa:	a1 48 40 80 00       	mov    0x804048,%eax
  8021af:	85 c0                	test   %eax,%eax
  8021b1:	75 bd                	jne    802170 <find_block+0x1d>
  8021b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021b7:	75 b7                	jne    802170 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  8021b9:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  8021bd:	75 05                	jne    8021c4 <find_block+0x71>
	{
		return blk;
  8021bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c2:	eb 05                	jmp    8021c9 <find_block+0x76>
	}
	else
	{
		return NULL;
  8021c4:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  8021c9:	c9                   	leave  
  8021ca:	c3                   	ret    

008021cb <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021cb:	55                   	push   %ebp
  8021cc:	89 e5                	mov    %esp,%ebp
  8021ce:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  8021d7:	a1 40 40 80 00       	mov    0x804040,%eax
  8021dc:	85 c0                	test   %eax,%eax
  8021de:	74 12                	je     8021f2 <insert_sorted_allocList+0x27>
  8021e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e3:	8b 50 08             	mov    0x8(%eax),%edx
  8021e6:	a1 40 40 80 00       	mov    0x804040,%eax
  8021eb:	8b 40 08             	mov    0x8(%eax),%eax
  8021ee:	39 c2                	cmp    %eax,%edx
  8021f0:	73 65                	jae    802257 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  8021f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021f6:	75 14                	jne    80220c <insert_sorted_allocList+0x41>
  8021f8:	83 ec 04             	sub    $0x4,%esp
  8021fb:	68 d4 3a 80 00       	push   $0x803ad4
  802200:	6a 7b                	push   $0x7b
  802202:	68 f7 3a 80 00       	push   $0x803af7
  802207:	e8 09 e1 ff ff       	call   800315 <_panic>
  80220c:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802215:	89 10                	mov    %edx,(%eax)
  802217:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221a:	8b 00                	mov    (%eax),%eax
  80221c:	85 c0                	test   %eax,%eax
  80221e:	74 0d                	je     80222d <insert_sorted_allocList+0x62>
  802220:	a1 40 40 80 00       	mov    0x804040,%eax
  802225:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802228:	89 50 04             	mov    %edx,0x4(%eax)
  80222b:	eb 08                	jmp    802235 <insert_sorted_allocList+0x6a>
  80222d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802230:	a3 44 40 80 00       	mov    %eax,0x804044
  802235:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802238:	a3 40 40 80 00       	mov    %eax,0x804040
  80223d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802240:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802247:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80224c:	40                   	inc    %eax
  80224d:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802252:	e9 5f 01 00 00       	jmp    8023b6 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  802257:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225a:	8b 50 08             	mov    0x8(%eax),%edx
  80225d:	a1 44 40 80 00       	mov    0x804044,%eax
  802262:	8b 40 08             	mov    0x8(%eax),%eax
  802265:	39 c2                	cmp    %eax,%edx
  802267:	76 65                	jbe    8022ce <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802269:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80226d:	75 14                	jne    802283 <insert_sorted_allocList+0xb8>
  80226f:	83 ec 04             	sub    $0x4,%esp
  802272:	68 10 3b 80 00       	push   $0x803b10
  802277:	6a 7f                	push   $0x7f
  802279:	68 f7 3a 80 00       	push   $0x803af7
  80227e:	e8 92 e0 ff ff       	call   800315 <_panic>
  802283:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802289:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228c:	89 50 04             	mov    %edx,0x4(%eax)
  80228f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802292:	8b 40 04             	mov    0x4(%eax),%eax
  802295:	85 c0                	test   %eax,%eax
  802297:	74 0c                	je     8022a5 <insert_sorted_allocList+0xda>
  802299:	a1 44 40 80 00       	mov    0x804044,%eax
  80229e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022a1:	89 10                	mov    %edx,(%eax)
  8022a3:	eb 08                	jmp    8022ad <insert_sorted_allocList+0xe2>
  8022a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a8:	a3 40 40 80 00       	mov    %eax,0x804040
  8022ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b0:	a3 44 40 80 00       	mov    %eax,0x804044
  8022b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022be:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022c3:	40                   	inc    %eax
  8022c4:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  8022c9:	e9 e8 00 00 00       	jmp    8023b6 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8022ce:	a1 40 40 80 00       	mov    0x804040,%eax
  8022d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d6:	e9 ab 00 00 00       	jmp    802386 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  8022db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022de:	8b 00                	mov    (%eax),%eax
  8022e0:	85 c0                	test   %eax,%eax
  8022e2:	0f 84 96 00 00 00    	je     80237e <insert_sorted_allocList+0x1b3>
  8022e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022eb:	8b 50 08             	mov    0x8(%eax),%edx
  8022ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f1:	8b 40 08             	mov    0x8(%eax),%eax
  8022f4:	39 c2                	cmp    %eax,%edx
  8022f6:	0f 86 82 00 00 00    	jbe    80237e <insert_sorted_allocList+0x1b3>
  8022fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ff:	8b 50 08             	mov    0x8(%eax),%edx
  802302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802305:	8b 00                	mov    (%eax),%eax
  802307:	8b 40 08             	mov    0x8(%eax),%eax
  80230a:	39 c2                	cmp    %eax,%edx
  80230c:	73 70                	jae    80237e <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  80230e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802312:	74 06                	je     80231a <insert_sorted_allocList+0x14f>
  802314:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802318:	75 17                	jne    802331 <insert_sorted_allocList+0x166>
  80231a:	83 ec 04             	sub    $0x4,%esp
  80231d:	68 34 3b 80 00       	push   $0x803b34
  802322:	68 87 00 00 00       	push   $0x87
  802327:	68 f7 3a 80 00       	push   $0x803af7
  80232c:	e8 e4 df ff ff       	call   800315 <_panic>
  802331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802334:	8b 10                	mov    (%eax),%edx
  802336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802339:	89 10                	mov    %edx,(%eax)
  80233b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233e:	8b 00                	mov    (%eax),%eax
  802340:	85 c0                	test   %eax,%eax
  802342:	74 0b                	je     80234f <insert_sorted_allocList+0x184>
  802344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802347:	8b 00                	mov    (%eax),%eax
  802349:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80234c:	89 50 04             	mov    %edx,0x4(%eax)
  80234f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802352:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802355:	89 10                	mov    %edx,(%eax)
  802357:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80235d:	89 50 04             	mov    %edx,0x4(%eax)
  802360:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802363:	8b 00                	mov    (%eax),%eax
  802365:	85 c0                	test   %eax,%eax
  802367:	75 08                	jne    802371 <insert_sorted_allocList+0x1a6>
  802369:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236c:	a3 44 40 80 00       	mov    %eax,0x804044
  802371:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802376:	40                   	inc    %eax
  802377:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80237c:	eb 38                	jmp    8023b6 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  80237e:	a1 48 40 80 00       	mov    0x804048,%eax
  802383:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802386:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238a:	74 07                	je     802393 <insert_sorted_allocList+0x1c8>
  80238c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238f:	8b 00                	mov    (%eax),%eax
  802391:	eb 05                	jmp    802398 <insert_sorted_allocList+0x1cd>
  802393:	b8 00 00 00 00       	mov    $0x0,%eax
  802398:	a3 48 40 80 00       	mov    %eax,0x804048
  80239d:	a1 48 40 80 00       	mov    0x804048,%eax
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	0f 85 31 ff ff ff    	jne    8022db <insert_sorted_allocList+0x110>
  8023aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ae:	0f 85 27 ff ff ff    	jne    8022db <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  8023b4:	eb 00                	jmp    8023b6 <insert_sorted_allocList+0x1eb>
  8023b6:	90                   	nop
  8023b7:	c9                   	leave  
  8023b8:	c3                   	ret    

008023b9 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023b9:	55                   	push   %ebp
  8023ba:	89 e5                	mov    %esp,%ebp
  8023bc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  8023bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8023c5:	a1 48 41 80 00       	mov    0x804148,%eax
  8023ca:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8023cd:	a1 38 41 80 00       	mov    0x804138,%eax
  8023d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d5:	e9 77 01 00 00       	jmp    802551 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8023e3:	0f 85 8a 00 00 00    	jne    802473 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8023e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ed:	75 17                	jne    802406 <alloc_block_FF+0x4d>
  8023ef:	83 ec 04             	sub    $0x4,%esp
  8023f2:	68 68 3b 80 00       	push   $0x803b68
  8023f7:	68 9e 00 00 00       	push   $0x9e
  8023fc:	68 f7 3a 80 00       	push   $0x803af7
  802401:	e8 0f df ff ff       	call   800315 <_panic>
  802406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802409:	8b 00                	mov    (%eax),%eax
  80240b:	85 c0                	test   %eax,%eax
  80240d:	74 10                	je     80241f <alloc_block_FF+0x66>
  80240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802412:	8b 00                	mov    (%eax),%eax
  802414:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802417:	8b 52 04             	mov    0x4(%edx),%edx
  80241a:	89 50 04             	mov    %edx,0x4(%eax)
  80241d:	eb 0b                	jmp    80242a <alloc_block_FF+0x71>
  80241f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802422:	8b 40 04             	mov    0x4(%eax),%eax
  802425:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80242a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242d:	8b 40 04             	mov    0x4(%eax),%eax
  802430:	85 c0                	test   %eax,%eax
  802432:	74 0f                	je     802443 <alloc_block_FF+0x8a>
  802434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802437:	8b 40 04             	mov    0x4(%eax),%eax
  80243a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80243d:	8b 12                	mov    (%edx),%edx
  80243f:	89 10                	mov    %edx,(%eax)
  802441:	eb 0a                	jmp    80244d <alloc_block_FF+0x94>
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	8b 00                	mov    (%eax),%eax
  802448:	a3 38 41 80 00       	mov    %eax,0x804138
  80244d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802450:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802459:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802460:	a1 44 41 80 00       	mov    0x804144,%eax
  802465:	48                   	dec    %eax
  802466:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  80246b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246e:	e9 11 01 00 00       	jmp    802584 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802476:	8b 40 0c             	mov    0xc(%eax),%eax
  802479:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80247c:	0f 86 c7 00 00 00    	jbe    802549 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802482:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802486:	75 17                	jne    80249f <alloc_block_FF+0xe6>
  802488:	83 ec 04             	sub    $0x4,%esp
  80248b:	68 68 3b 80 00       	push   $0x803b68
  802490:	68 a3 00 00 00       	push   $0xa3
  802495:	68 f7 3a 80 00       	push   $0x803af7
  80249a:	e8 76 de ff ff       	call   800315 <_panic>
  80249f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a2:	8b 00                	mov    (%eax),%eax
  8024a4:	85 c0                	test   %eax,%eax
  8024a6:	74 10                	je     8024b8 <alloc_block_FF+0xff>
  8024a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ab:	8b 00                	mov    (%eax),%eax
  8024ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024b0:	8b 52 04             	mov    0x4(%edx),%edx
  8024b3:	89 50 04             	mov    %edx,0x4(%eax)
  8024b6:	eb 0b                	jmp    8024c3 <alloc_block_FF+0x10a>
  8024b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024bb:	8b 40 04             	mov    0x4(%eax),%eax
  8024be:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c6:	8b 40 04             	mov    0x4(%eax),%eax
  8024c9:	85 c0                	test   %eax,%eax
  8024cb:	74 0f                	je     8024dc <alloc_block_FF+0x123>
  8024cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d0:	8b 40 04             	mov    0x4(%eax),%eax
  8024d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024d6:	8b 12                	mov    (%edx),%edx
  8024d8:	89 10                	mov    %edx,(%eax)
  8024da:	eb 0a                	jmp    8024e6 <alloc_block_FF+0x12d>
  8024dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024df:	8b 00                	mov    (%eax),%eax
  8024e1:	a3 48 41 80 00       	mov    %eax,0x804148
  8024e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f9:	a1 54 41 80 00       	mov    0x804154,%eax
  8024fe:	48                   	dec    %eax
  8024ff:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802504:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802507:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80250a:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  80250d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802510:	8b 40 0c             	mov    0xc(%eax),%eax
  802513:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802516:	89 c2                	mov    %eax,%edx
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  80251e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802521:	8b 40 08             	mov    0x8(%eax),%eax
  802524:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252a:	8b 50 08             	mov    0x8(%eax),%edx
  80252d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802530:	8b 40 0c             	mov    0xc(%eax),%eax
  802533:	01 c2                	add    %eax,%edx
  802535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802538:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  80253b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802541:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802544:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802547:	eb 3b                	jmp    802584 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802549:	a1 40 41 80 00       	mov    0x804140,%eax
  80254e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802551:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802555:	74 07                	je     80255e <alloc_block_FF+0x1a5>
  802557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255a:	8b 00                	mov    (%eax),%eax
  80255c:	eb 05                	jmp    802563 <alloc_block_FF+0x1aa>
  80255e:	b8 00 00 00 00       	mov    $0x0,%eax
  802563:	a3 40 41 80 00       	mov    %eax,0x804140
  802568:	a1 40 41 80 00       	mov    0x804140,%eax
  80256d:	85 c0                	test   %eax,%eax
  80256f:	0f 85 65 fe ff ff    	jne    8023da <alloc_block_FF+0x21>
  802575:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802579:	0f 85 5b fe ff ff    	jne    8023da <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  80257f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802584:	c9                   	leave  
  802585:	c3                   	ret    

00802586 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802586:	55                   	push   %ebp
  802587:	89 e5                	mov    %esp,%ebp
  802589:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  80258c:	8b 45 08             	mov    0x8(%ebp),%eax
  80258f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802592:	a1 48 41 80 00       	mov    0x804148,%eax
  802597:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  80259a:	a1 44 41 80 00       	mov    0x804144,%eax
  80259f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025a2:	a1 38 41 80 00       	mov    0x804138,%eax
  8025a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025aa:	e9 a1 00 00 00       	jmp    802650 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  8025af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8025b8:	0f 85 8a 00 00 00    	jne    802648 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  8025be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c2:	75 17                	jne    8025db <alloc_block_BF+0x55>
  8025c4:	83 ec 04             	sub    $0x4,%esp
  8025c7:	68 68 3b 80 00       	push   $0x803b68
  8025cc:	68 c2 00 00 00       	push   $0xc2
  8025d1:	68 f7 3a 80 00       	push   $0x803af7
  8025d6:	e8 3a dd ff ff       	call   800315 <_panic>
  8025db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025de:	8b 00                	mov    (%eax),%eax
  8025e0:	85 c0                	test   %eax,%eax
  8025e2:	74 10                	je     8025f4 <alloc_block_BF+0x6e>
  8025e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e7:	8b 00                	mov    (%eax),%eax
  8025e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ec:	8b 52 04             	mov    0x4(%edx),%edx
  8025ef:	89 50 04             	mov    %edx,0x4(%eax)
  8025f2:	eb 0b                	jmp    8025ff <alloc_block_BF+0x79>
  8025f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f7:	8b 40 04             	mov    0x4(%eax),%eax
  8025fa:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	8b 40 04             	mov    0x4(%eax),%eax
  802605:	85 c0                	test   %eax,%eax
  802607:	74 0f                	je     802618 <alloc_block_BF+0x92>
  802609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260c:	8b 40 04             	mov    0x4(%eax),%eax
  80260f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802612:	8b 12                	mov    (%edx),%edx
  802614:	89 10                	mov    %edx,(%eax)
  802616:	eb 0a                	jmp    802622 <alloc_block_BF+0x9c>
  802618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261b:	8b 00                	mov    (%eax),%eax
  80261d:	a3 38 41 80 00       	mov    %eax,0x804138
  802622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802625:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80262b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802635:	a1 44 41 80 00       	mov    0x804144,%eax
  80263a:	48                   	dec    %eax
  80263b:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	e9 11 02 00 00       	jmp    802859 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802648:	a1 40 41 80 00       	mov    0x804140,%eax
  80264d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802650:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802654:	74 07                	je     80265d <alloc_block_BF+0xd7>
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802659:	8b 00                	mov    (%eax),%eax
  80265b:	eb 05                	jmp    802662 <alloc_block_BF+0xdc>
  80265d:	b8 00 00 00 00       	mov    $0x0,%eax
  802662:	a3 40 41 80 00       	mov    %eax,0x804140
  802667:	a1 40 41 80 00       	mov    0x804140,%eax
  80266c:	85 c0                	test   %eax,%eax
  80266e:	0f 85 3b ff ff ff    	jne    8025af <alloc_block_BF+0x29>
  802674:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802678:	0f 85 31 ff ff ff    	jne    8025af <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80267e:	a1 38 41 80 00       	mov    0x804138,%eax
  802683:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802686:	eb 27                	jmp    8026af <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268b:	8b 40 0c             	mov    0xc(%eax),%eax
  80268e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802691:	76 14                	jbe    8026a7 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802696:	8b 40 0c             	mov    0xc(%eax),%eax
  802699:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  80269c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269f:	8b 40 08             	mov    0x8(%eax),%eax
  8026a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  8026a5:	eb 2e                	jmp    8026d5 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026a7:	a1 40 41 80 00       	mov    0x804140,%eax
  8026ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b3:	74 07                	je     8026bc <alloc_block_BF+0x136>
  8026b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b8:	8b 00                	mov    (%eax),%eax
  8026ba:	eb 05                	jmp    8026c1 <alloc_block_BF+0x13b>
  8026bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c1:	a3 40 41 80 00       	mov    %eax,0x804140
  8026c6:	a1 40 41 80 00       	mov    0x804140,%eax
  8026cb:	85 c0                	test   %eax,%eax
  8026cd:	75 b9                	jne    802688 <alloc_block_BF+0x102>
  8026cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d3:	75 b3                	jne    802688 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026d5:	a1 38 41 80 00       	mov    0x804138,%eax
  8026da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026dd:	eb 30                	jmp    80270f <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  8026df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8026e8:	73 1d                	jae    802707 <alloc_block_BF+0x181>
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8026f3:	76 12                	jbe    802707 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	8b 40 08             	mov    0x8(%eax),%eax
  802704:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802707:	a1 40 41 80 00       	mov    0x804140,%eax
  80270c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80270f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802713:	74 07                	je     80271c <alloc_block_BF+0x196>
  802715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802718:	8b 00                	mov    (%eax),%eax
  80271a:	eb 05                	jmp    802721 <alloc_block_BF+0x19b>
  80271c:	b8 00 00 00 00       	mov    $0x0,%eax
  802721:	a3 40 41 80 00       	mov    %eax,0x804140
  802726:	a1 40 41 80 00       	mov    0x804140,%eax
  80272b:	85 c0                	test   %eax,%eax
  80272d:	75 b0                	jne    8026df <alloc_block_BF+0x159>
  80272f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802733:	75 aa                	jne    8026df <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802735:	a1 38 41 80 00       	mov    0x804138,%eax
  80273a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80273d:	e9 e4 00 00 00       	jmp    802826 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	8b 40 0c             	mov    0xc(%eax),%eax
  802748:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80274b:	0f 85 cd 00 00 00    	jne    80281e <alloc_block_BF+0x298>
  802751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802754:	8b 40 08             	mov    0x8(%eax),%eax
  802757:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80275a:	0f 85 be 00 00 00    	jne    80281e <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802760:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802764:	75 17                	jne    80277d <alloc_block_BF+0x1f7>
  802766:	83 ec 04             	sub    $0x4,%esp
  802769:	68 68 3b 80 00       	push   $0x803b68
  80276e:	68 db 00 00 00       	push   $0xdb
  802773:	68 f7 3a 80 00       	push   $0x803af7
  802778:	e8 98 db ff ff       	call   800315 <_panic>
  80277d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802780:	8b 00                	mov    (%eax),%eax
  802782:	85 c0                	test   %eax,%eax
  802784:	74 10                	je     802796 <alloc_block_BF+0x210>
  802786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802789:	8b 00                	mov    (%eax),%eax
  80278b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80278e:	8b 52 04             	mov    0x4(%edx),%edx
  802791:	89 50 04             	mov    %edx,0x4(%eax)
  802794:	eb 0b                	jmp    8027a1 <alloc_block_BF+0x21b>
  802796:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802799:	8b 40 04             	mov    0x4(%eax),%eax
  80279c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a4:	8b 40 04             	mov    0x4(%eax),%eax
  8027a7:	85 c0                	test   %eax,%eax
  8027a9:	74 0f                	je     8027ba <alloc_block_BF+0x234>
  8027ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ae:	8b 40 04             	mov    0x4(%eax),%eax
  8027b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027b4:	8b 12                	mov    (%edx),%edx
  8027b6:	89 10                	mov    %edx,(%eax)
  8027b8:	eb 0a                	jmp    8027c4 <alloc_block_BF+0x23e>
  8027ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027bd:	8b 00                	mov    (%eax),%eax
  8027bf:	a3 48 41 80 00       	mov    %eax,0x804148
  8027c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027d7:	a1 54 41 80 00       	mov    0x804154,%eax
  8027dc:	48                   	dec    %eax
  8027dd:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8027e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027e8:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  8027eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027f1:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  8027f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027fa:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8027fd:	89 c2                	mov    %eax,%edx
  8027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802802:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802808:	8b 50 08             	mov    0x8(%eax),%edx
  80280b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80280e:	8b 40 0c             	mov    0xc(%eax),%eax
  802811:	01 c2                	add    %eax,%edx
  802813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802816:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802819:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80281c:	eb 3b                	jmp    802859 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80281e:	a1 40 41 80 00       	mov    0x804140,%eax
  802823:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802826:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282a:	74 07                	je     802833 <alloc_block_BF+0x2ad>
  80282c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282f:	8b 00                	mov    (%eax),%eax
  802831:	eb 05                	jmp    802838 <alloc_block_BF+0x2b2>
  802833:	b8 00 00 00 00       	mov    $0x0,%eax
  802838:	a3 40 41 80 00       	mov    %eax,0x804140
  80283d:	a1 40 41 80 00       	mov    0x804140,%eax
  802842:	85 c0                	test   %eax,%eax
  802844:	0f 85 f8 fe ff ff    	jne    802742 <alloc_block_BF+0x1bc>
  80284a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284e:	0f 85 ee fe ff ff    	jne    802742 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802854:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802859:	c9                   	leave  
  80285a:	c3                   	ret    

0080285b <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  80285b:	55                   	push   %ebp
  80285c:	89 e5                	mov    %esp,%ebp
  80285e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802861:	8b 45 08             	mov    0x8(%ebp),%eax
  802864:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802867:	a1 48 41 80 00       	mov    0x804148,%eax
  80286c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80286f:	a1 38 41 80 00       	mov    0x804138,%eax
  802874:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802877:	e9 77 01 00 00       	jmp    8029f3 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  80287c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287f:	8b 40 0c             	mov    0xc(%eax),%eax
  802882:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802885:	0f 85 8a 00 00 00    	jne    802915 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80288b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80288f:	75 17                	jne    8028a8 <alloc_block_NF+0x4d>
  802891:	83 ec 04             	sub    $0x4,%esp
  802894:	68 68 3b 80 00       	push   $0x803b68
  802899:	68 f7 00 00 00       	push   $0xf7
  80289e:	68 f7 3a 80 00       	push   $0x803af7
  8028a3:	e8 6d da ff ff       	call   800315 <_panic>
  8028a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ab:	8b 00                	mov    (%eax),%eax
  8028ad:	85 c0                	test   %eax,%eax
  8028af:	74 10                	je     8028c1 <alloc_block_NF+0x66>
  8028b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b4:	8b 00                	mov    (%eax),%eax
  8028b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b9:	8b 52 04             	mov    0x4(%edx),%edx
  8028bc:	89 50 04             	mov    %edx,0x4(%eax)
  8028bf:	eb 0b                	jmp    8028cc <alloc_block_NF+0x71>
  8028c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c4:	8b 40 04             	mov    0x4(%eax),%eax
  8028c7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cf:	8b 40 04             	mov    0x4(%eax),%eax
  8028d2:	85 c0                	test   %eax,%eax
  8028d4:	74 0f                	je     8028e5 <alloc_block_NF+0x8a>
  8028d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d9:	8b 40 04             	mov    0x4(%eax),%eax
  8028dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028df:	8b 12                	mov    (%edx),%edx
  8028e1:	89 10                	mov    %edx,(%eax)
  8028e3:	eb 0a                	jmp    8028ef <alloc_block_NF+0x94>
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	8b 00                	mov    (%eax),%eax
  8028ea:	a3 38 41 80 00       	mov    %eax,0x804138
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802902:	a1 44 41 80 00       	mov    0x804144,%eax
  802907:	48                   	dec    %eax
  802908:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	e9 11 01 00 00       	jmp    802a26 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802918:	8b 40 0c             	mov    0xc(%eax),%eax
  80291b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80291e:	0f 86 c7 00 00 00    	jbe    8029eb <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802924:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802928:	75 17                	jne    802941 <alloc_block_NF+0xe6>
  80292a:	83 ec 04             	sub    $0x4,%esp
  80292d:	68 68 3b 80 00       	push   $0x803b68
  802932:	68 fc 00 00 00       	push   $0xfc
  802937:	68 f7 3a 80 00       	push   $0x803af7
  80293c:	e8 d4 d9 ff ff       	call   800315 <_panic>
  802941:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802944:	8b 00                	mov    (%eax),%eax
  802946:	85 c0                	test   %eax,%eax
  802948:	74 10                	je     80295a <alloc_block_NF+0xff>
  80294a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294d:	8b 00                	mov    (%eax),%eax
  80294f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802952:	8b 52 04             	mov    0x4(%edx),%edx
  802955:	89 50 04             	mov    %edx,0x4(%eax)
  802958:	eb 0b                	jmp    802965 <alloc_block_NF+0x10a>
  80295a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295d:	8b 40 04             	mov    0x4(%eax),%eax
  802960:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802965:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802968:	8b 40 04             	mov    0x4(%eax),%eax
  80296b:	85 c0                	test   %eax,%eax
  80296d:	74 0f                	je     80297e <alloc_block_NF+0x123>
  80296f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802972:	8b 40 04             	mov    0x4(%eax),%eax
  802975:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802978:	8b 12                	mov    (%edx),%edx
  80297a:	89 10                	mov    %edx,(%eax)
  80297c:	eb 0a                	jmp    802988 <alloc_block_NF+0x12d>
  80297e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802981:	8b 00                	mov    (%eax),%eax
  802983:	a3 48 41 80 00       	mov    %eax,0x804148
  802988:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802991:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802994:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80299b:	a1 54 41 80 00       	mov    0x804154,%eax
  8029a0:	48                   	dec    %eax
  8029a1:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8029a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029ac:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b5:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8029b8:	89 c2                	mov    %eax,%edx
  8029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bd:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	8b 40 08             	mov    0x8(%eax),%eax
  8029c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8029c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cc:	8b 50 08             	mov    0x8(%eax),%edx
  8029cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d5:	01 c2                	add    %eax,%edx
  8029d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029da:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8029dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029e3:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8029e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e9:	eb 3b                	jmp    802a26 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8029eb:	a1 40 41 80 00       	mov    0x804140,%eax
  8029f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f7:	74 07                	je     802a00 <alloc_block_NF+0x1a5>
  8029f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fc:	8b 00                	mov    (%eax),%eax
  8029fe:	eb 05                	jmp    802a05 <alloc_block_NF+0x1aa>
  802a00:	b8 00 00 00 00       	mov    $0x0,%eax
  802a05:	a3 40 41 80 00       	mov    %eax,0x804140
  802a0a:	a1 40 41 80 00       	mov    0x804140,%eax
  802a0f:	85 c0                	test   %eax,%eax
  802a11:	0f 85 65 fe ff ff    	jne    80287c <alloc_block_NF+0x21>
  802a17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a1b:	0f 85 5b fe ff ff    	jne    80287c <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802a21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a26:	c9                   	leave  
  802a27:	c3                   	ret    

00802a28 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802a28:	55                   	push   %ebp
  802a29:	89 e5                	mov    %esp,%ebp
  802a2b:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a31:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802a38:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802a42:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a46:	75 17                	jne    802a5f <addToAvailMemBlocksList+0x37>
  802a48:	83 ec 04             	sub    $0x4,%esp
  802a4b:	68 10 3b 80 00       	push   $0x803b10
  802a50:	68 10 01 00 00       	push   $0x110
  802a55:	68 f7 3a 80 00       	push   $0x803af7
  802a5a:	e8 b6 d8 ff ff       	call   800315 <_panic>
  802a5f:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802a65:	8b 45 08             	mov    0x8(%ebp),%eax
  802a68:	89 50 04             	mov    %edx,0x4(%eax)
  802a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6e:	8b 40 04             	mov    0x4(%eax),%eax
  802a71:	85 c0                	test   %eax,%eax
  802a73:	74 0c                	je     802a81 <addToAvailMemBlocksList+0x59>
  802a75:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802a7a:	8b 55 08             	mov    0x8(%ebp),%edx
  802a7d:	89 10                	mov    %edx,(%eax)
  802a7f:	eb 08                	jmp    802a89 <addToAvailMemBlocksList+0x61>
  802a81:	8b 45 08             	mov    0x8(%ebp),%eax
  802a84:	a3 48 41 80 00       	mov    %eax,0x804148
  802a89:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a91:	8b 45 08             	mov    0x8(%ebp),%eax
  802a94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a9a:	a1 54 41 80 00       	mov    0x804154,%eax
  802a9f:	40                   	inc    %eax
  802aa0:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802aa5:	90                   	nop
  802aa6:	c9                   	leave  
  802aa7:	c3                   	ret    

00802aa8 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802aa8:	55                   	push   %ebp
  802aa9:	89 e5                	mov    %esp,%ebp
  802aab:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802aae:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ab3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802ab6:	a1 44 41 80 00       	mov    0x804144,%eax
  802abb:	85 c0                	test   %eax,%eax
  802abd:	75 68                	jne    802b27 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802abf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ac3:	75 17                	jne    802adc <insert_sorted_with_merge_freeList+0x34>
  802ac5:	83 ec 04             	sub    $0x4,%esp
  802ac8:	68 d4 3a 80 00       	push   $0x803ad4
  802acd:	68 1a 01 00 00       	push   $0x11a
  802ad2:	68 f7 3a 80 00       	push   $0x803af7
  802ad7:	e8 39 d8 ff ff       	call   800315 <_panic>
  802adc:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae5:	89 10                	mov    %edx,(%eax)
  802ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aea:	8b 00                	mov    (%eax),%eax
  802aec:	85 c0                	test   %eax,%eax
  802aee:	74 0d                	je     802afd <insert_sorted_with_merge_freeList+0x55>
  802af0:	a1 38 41 80 00       	mov    0x804138,%eax
  802af5:	8b 55 08             	mov    0x8(%ebp),%edx
  802af8:	89 50 04             	mov    %edx,0x4(%eax)
  802afb:	eb 08                	jmp    802b05 <insert_sorted_with_merge_freeList+0x5d>
  802afd:	8b 45 08             	mov    0x8(%ebp),%eax
  802b00:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b05:	8b 45 08             	mov    0x8(%ebp),%eax
  802b08:	a3 38 41 80 00       	mov    %eax,0x804138
  802b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b17:	a1 44 41 80 00       	mov    0x804144,%eax
  802b1c:	40                   	inc    %eax
  802b1d:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802b22:	e9 c5 03 00 00       	jmp    802eec <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2a:	8b 50 08             	mov    0x8(%eax),%edx
  802b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b30:	8b 40 08             	mov    0x8(%eax),%eax
  802b33:	39 c2                	cmp    %eax,%edx
  802b35:	0f 83 b2 00 00 00    	jae    802bed <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3e:	8b 50 08             	mov    0x8(%eax),%edx
  802b41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b44:	8b 40 0c             	mov    0xc(%eax),%eax
  802b47:	01 c2                	add    %eax,%edx
  802b49:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4c:	8b 40 08             	mov    0x8(%eax),%eax
  802b4f:	39 c2                	cmp    %eax,%edx
  802b51:	75 27                	jne    802b7a <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b56:	8b 50 0c             	mov    0xc(%eax),%edx
  802b59:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5f:	01 c2                	add    %eax,%edx
  802b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b64:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802b67:	83 ec 0c             	sub    $0xc,%esp
  802b6a:	ff 75 08             	pushl  0x8(%ebp)
  802b6d:	e8 b6 fe ff ff       	call   802a28 <addToAvailMemBlocksList>
  802b72:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802b75:	e9 72 03 00 00       	jmp    802eec <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802b7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b7e:	74 06                	je     802b86 <insert_sorted_with_merge_freeList+0xde>
  802b80:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b84:	75 17                	jne    802b9d <insert_sorted_with_merge_freeList+0xf5>
  802b86:	83 ec 04             	sub    $0x4,%esp
  802b89:	68 34 3b 80 00       	push   $0x803b34
  802b8e:	68 24 01 00 00       	push   $0x124
  802b93:	68 f7 3a 80 00       	push   $0x803af7
  802b98:	e8 78 d7 ff ff       	call   800315 <_panic>
  802b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba0:	8b 10                	mov    (%eax),%edx
  802ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba5:	89 10                	mov    %edx,(%eax)
  802ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  802baa:	8b 00                	mov    (%eax),%eax
  802bac:	85 c0                	test   %eax,%eax
  802bae:	74 0b                	je     802bbb <insert_sorted_with_merge_freeList+0x113>
  802bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb3:	8b 00                	mov    (%eax),%eax
  802bb5:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb8:	89 50 04             	mov    %edx,0x4(%eax)
  802bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbe:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc1:	89 10                	mov    %edx,(%eax)
  802bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bc9:	89 50 04             	mov    %edx,0x4(%eax)
  802bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcf:	8b 00                	mov    (%eax),%eax
  802bd1:	85 c0                	test   %eax,%eax
  802bd3:	75 08                	jne    802bdd <insert_sorted_with_merge_freeList+0x135>
  802bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bdd:	a1 44 41 80 00       	mov    0x804144,%eax
  802be2:	40                   	inc    %eax
  802be3:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802be8:	e9 ff 02 00 00       	jmp    802eec <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802bed:	a1 38 41 80 00       	mov    0x804138,%eax
  802bf2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bf5:	e9 c2 02 00 00       	jmp    802ebc <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	8b 50 08             	mov    0x8(%eax),%edx
  802c00:	8b 45 08             	mov    0x8(%ebp),%eax
  802c03:	8b 40 08             	mov    0x8(%eax),%eax
  802c06:	39 c2                	cmp    %eax,%edx
  802c08:	0f 86 a6 02 00 00    	jbe    802eb4 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c11:	8b 40 04             	mov    0x4(%eax),%eax
  802c14:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802c17:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c1b:	0f 85 ba 00 00 00    	jne    802cdb <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802c21:	8b 45 08             	mov    0x8(%ebp),%eax
  802c24:	8b 50 0c             	mov    0xc(%eax),%edx
  802c27:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2a:	8b 40 08             	mov    0x8(%eax),%eax
  802c2d:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c32:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802c35:	39 c2                	cmp    %eax,%edx
  802c37:	75 33                	jne    802c6c <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802c39:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3c:	8b 50 08             	mov    0x8(%eax),%edx
  802c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c42:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	8b 50 0c             	mov    0xc(%eax),%edx
  802c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c51:	01 c2                	add    %eax,%edx
  802c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c56:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802c59:	83 ec 0c             	sub    $0xc,%esp
  802c5c:	ff 75 08             	pushl  0x8(%ebp)
  802c5f:	e8 c4 fd ff ff       	call   802a28 <addToAvailMemBlocksList>
  802c64:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802c67:	e9 80 02 00 00       	jmp    802eec <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802c6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c70:	74 06                	je     802c78 <insert_sorted_with_merge_freeList+0x1d0>
  802c72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c76:	75 17                	jne    802c8f <insert_sorted_with_merge_freeList+0x1e7>
  802c78:	83 ec 04             	sub    $0x4,%esp
  802c7b:	68 88 3b 80 00       	push   $0x803b88
  802c80:	68 3a 01 00 00       	push   $0x13a
  802c85:	68 f7 3a 80 00       	push   $0x803af7
  802c8a:	e8 86 d6 ff ff       	call   800315 <_panic>
  802c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c92:	8b 50 04             	mov    0x4(%eax),%edx
  802c95:	8b 45 08             	mov    0x8(%ebp),%eax
  802c98:	89 50 04             	mov    %edx,0x4(%eax)
  802c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ca1:	89 10                	mov    %edx,(%eax)
  802ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca6:	8b 40 04             	mov    0x4(%eax),%eax
  802ca9:	85 c0                	test   %eax,%eax
  802cab:	74 0d                	je     802cba <insert_sorted_with_merge_freeList+0x212>
  802cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb0:	8b 40 04             	mov    0x4(%eax),%eax
  802cb3:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb6:	89 10                	mov    %edx,(%eax)
  802cb8:	eb 08                	jmp    802cc2 <insert_sorted_with_merge_freeList+0x21a>
  802cba:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbd:	a3 38 41 80 00       	mov    %eax,0x804138
  802cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc5:	8b 55 08             	mov    0x8(%ebp),%edx
  802cc8:	89 50 04             	mov    %edx,0x4(%eax)
  802ccb:	a1 44 41 80 00       	mov    0x804144,%eax
  802cd0:	40                   	inc    %eax
  802cd1:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802cd6:	e9 11 02 00 00       	jmp    802eec <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802cdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cde:	8b 50 08             	mov    0x8(%eax),%edx
  802ce1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce7:	01 c2                	add    %eax,%edx
  802ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cec:	8b 40 0c             	mov    0xc(%eax),%eax
  802cef:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf4:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802cf7:	39 c2                	cmp    %eax,%edx
  802cf9:	0f 85 bf 00 00 00    	jne    802dbe <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802cff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d02:	8b 50 0c             	mov    0xc(%eax),%edx
  802d05:	8b 45 08             	mov    0x8(%ebp),%eax
  802d08:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0b:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d10:	8b 40 0c             	mov    0xc(%eax),%eax
  802d13:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802d15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d18:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802d1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d1f:	75 17                	jne    802d38 <insert_sorted_with_merge_freeList+0x290>
  802d21:	83 ec 04             	sub    $0x4,%esp
  802d24:	68 68 3b 80 00       	push   $0x803b68
  802d29:	68 43 01 00 00       	push   $0x143
  802d2e:	68 f7 3a 80 00       	push   $0x803af7
  802d33:	e8 dd d5 ff ff       	call   800315 <_panic>
  802d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3b:	8b 00                	mov    (%eax),%eax
  802d3d:	85 c0                	test   %eax,%eax
  802d3f:	74 10                	je     802d51 <insert_sorted_with_merge_freeList+0x2a9>
  802d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d44:	8b 00                	mov    (%eax),%eax
  802d46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d49:	8b 52 04             	mov    0x4(%edx),%edx
  802d4c:	89 50 04             	mov    %edx,0x4(%eax)
  802d4f:	eb 0b                	jmp    802d5c <insert_sorted_with_merge_freeList+0x2b4>
  802d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d54:	8b 40 04             	mov    0x4(%eax),%eax
  802d57:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5f:	8b 40 04             	mov    0x4(%eax),%eax
  802d62:	85 c0                	test   %eax,%eax
  802d64:	74 0f                	je     802d75 <insert_sorted_with_merge_freeList+0x2cd>
  802d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d69:	8b 40 04             	mov    0x4(%eax),%eax
  802d6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d6f:	8b 12                	mov    (%edx),%edx
  802d71:	89 10                	mov    %edx,(%eax)
  802d73:	eb 0a                	jmp    802d7f <insert_sorted_with_merge_freeList+0x2d7>
  802d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d78:	8b 00                	mov    (%eax),%eax
  802d7a:	a3 38 41 80 00       	mov    %eax,0x804138
  802d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d92:	a1 44 41 80 00       	mov    0x804144,%eax
  802d97:	48                   	dec    %eax
  802d98:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802d9d:	83 ec 0c             	sub    $0xc,%esp
  802da0:	ff 75 08             	pushl  0x8(%ebp)
  802da3:	e8 80 fc ff ff       	call   802a28 <addToAvailMemBlocksList>
  802da8:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802dab:	83 ec 0c             	sub    $0xc,%esp
  802dae:	ff 75 f4             	pushl  -0xc(%ebp)
  802db1:	e8 72 fc ff ff       	call   802a28 <addToAvailMemBlocksList>
  802db6:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802db9:	e9 2e 01 00 00       	jmp    802eec <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802dbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc1:	8b 50 08             	mov    0x8(%eax),%edx
  802dc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dca:	01 c2                	add    %eax,%edx
  802dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcf:	8b 40 08             	mov    0x8(%eax),%eax
  802dd2:	39 c2                	cmp    %eax,%edx
  802dd4:	75 27                	jne    802dfd <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802dd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd9:	8b 50 0c             	mov    0xc(%eax),%edx
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	8b 40 0c             	mov    0xc(%eax),%eax
  802de2:	01 c2                	add    %eax,%edx
  802de4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de7:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802dea:	83 ec 0c             	sub    $0xc,%esp
  802ded:	ff 75 08             	pushl  0x8(%ebp)
  802df0:	e8 33 fc ff ff       	call   802a28 <addToAvailMemBlocksList>
  802df5:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802df8:	e9 ef 00 00 00       	jmp    802eec <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802e00:	8b 50 0c             	mov    0xc(%eax),%edx
  802e03:	8b 45 08             	mov    0x8(%ebp),%eax
  802e06:	8b 40 08             	mov    0x8(%eax),%eax
  802e09:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0e:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802e11:	39 c2                	cmp    %eax,%edx
  802e13:	75 33                	jne    802e48 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802e15:	8b 45 08             	mov    0x8(%ebp),%eax
  802e18:	8b 50 08             	mov    0x8(%eax),%edx
  802e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1e:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e24:	8b 50 0c             	mov    0xc(%eax),%edx
  802e27:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2d:	01 c2                	add    %eax,%edx
  802e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e32:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802e35:	83 ec 0c             	sub    $0xc,%esp
  802e38:	ff 75 08             	pushl  0x8(%ebp)
  802e3b:	e8 e8 fb ff ff       	call   802a28 <addToAvailMemBlocksList>
  802e40:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802e43:	e9 a4 00 00 00       	jmp    802eec <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802e48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e4c:	74 06                	je     802e54 <insert_sorted_with_merge_freeList+0x3ac>
  802e4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e52:	75 17                	jne    802e6b <insert_sorted_with_merge_freeList+0x3c3>
  802e54:	83 ec 04             	sub    $0x4,%esp
  802e57:	68 88 3b 80 00       	push   $0x803b88
  802e5c:	68 56 01 00 00       	push   $0x156
  802e61:	68 f7 3a 80 00       	push   $0x803af7
  802e66:	e8 aa d4 ff ff       	call   800315 <_panic>
  802e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6e:	8b 50 04             	mov    0x4(%eax),%edx
  802e71:	8b 45 08             	mov    0x8(%ebp),%eax
  802e74:	89 50 04             	mov    %edx,0x4(%eax)
  802e77:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7d:	89 10                	mov    %edx,(%eax)
  802e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e82:	8b 40 04             	mov    0x4(%eax),%eax
  802e85:	85 c0                	test   %eax,%eax
  802e87:	74 0d                	je     802e96 <insert_sorted_with_merge_freeList+0x3ee>
  802e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8c:	8b 40 04             	mov    0x4(%eax),%eax
  802e8f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e92:	89 10                	mov    %edx,(%eax)
  802e94:	eb 08                	jmp    802e9e <insert_sorted_with_merge_freeList+0x3f6>
  802e96:	8b 45 08             	mov    0x8(%ebp),%eax
  802e99:	a3 38 41 80 00       	mov    %eax,0x804138
  802e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea4:	89 50 04             	mov    %edx,0x4(%eax)
  802ea7:	a1 44 41 80 00       	mov    0x804144,%eax
  802eac:	40                   	inc    %eax
  802ead:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802eb2:	eb 38                	jmp    802eec <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802eb4:	a1 40 41 80 00       	mov    0x804140,%eax
  802eb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ebc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec0:	74 07                	je     802ec9 <insert_sorted_with_merge_freeList+0x421>
  802ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec5:	8b 00                	mov    (%eax),%eax
  802ec7:	eb 05                	jmp    802ece <insert_sorted_with_merge_freeList+0x426>
  802ec9:	b8 00 00 00 00       	mov    $0x0,%eax
  802ece:	a3 40 41 80 00       	mov    %eax,0x804140
  802ed3:	a1 40 41 80 00       	mov    0x804140,%eax
  802ed8:	85 c0                	test   %eax,%eax
  802eda:	0f 85 1a fd ff ff    	jne    802bfa <insert_sorted_with_merge_freeList+0x152>
  802ee0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee4:	0f 85 10 fd ff ff    	jne    802bfa <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802eea:	eb 00                	jmp    802eec <insert_sorted_with_merge_freeList+0x444>
  802eec:	90                   	nop
  802eed:	c9                   	leave  
  802eee:	c3                   	ret    
  802eef:	90                   	nop

00802ef0 <__udivdi3>:
  802ef0:	55                   	push   %ebp
  802ef1:	57                   	push   %edi
  802ef2:	56                   	push   %esi
  802ef3:	53                   	push   %ebx
  802ef4:	83 ec 1c             	sub    $0x1c,%esp
  802ef7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802efb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802eff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802f03:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f07:	89 ca                	mov    %ecx,%edx
  802f09:	89 f8                	mov    %edi,%eax
  802f0b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802f0f:	85 f6                	test   %esi,%esi
  802f11:	75 2d                	jne    802f40 <__udivdi3+0x50>
  802f13:	39 cf                	cmp    %ecx,%edi
  802f15:	77 65                	ja     802f7c <__udivdi3+0x8c>
  802f17:	89 fd                	mov    %edi,%ebp
  802f19:	85 ff                	test   %edi,%edi
  802f1b:	75 0b                	jne    802f28 <__udivdi3+0x38>
  802f1d:	b8 01 00 00 00       	mov    $0x1,%eax
  802f22:	31 d2                	xor    %edx,%edx
  802f24:	f7 f7                	div    %edi
  802f26:	89 c5                	mov    %eax,%ebp
  802f28:	31 d2                	xor    %edx,%edx
  802f2a:	89 c8                	mov    %ecx,%eax
  802f2c:	f7 f5                	div    %ebp
  802f2e:	89 c1                	mov    %eax,%ecx
  802f30:	89 d8                	mov    %ebx,%eax
  802f32:	f7 f5                	div    %ebp
  802f34:	89 cf                	mov    %ecx,%edi
  802f36:	89 fa                	mov    %edi,%edx
  802f38:	83 c4 1c             	add    $0x1c,%esp
  802f3b:	5b                   	pop    %ebx
  802f3c:	5e                   	pop    %esi
  802f3d:	5f                   	pop    %edi
  802f3e:	5d                   	pop    %ebp
  802f3f:	c3                   	ret    
  802f40:	39 ce                	cmp    %ecx,%esi
  802f42:	77 28                	ja     802f6c <__udivdi3+0x7c>
  802f44:	0f bd fe             	bsr    %esi,%edi
  802f47:	83 f7 1f             	xor    $0x1f,%edi
  802f4a:	75 40                	jne    802f8c <__udivdi3+0x9c>
  802f4c:	39 ce                	cmp    %ecx,%esi
  802f4e:	72 0a                	jb     802f5a <__udivdi3+0x6a>
  802f50:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802f54:	0f 87 9e 00 00 00    	ja     802ff8 <__udivdi3+0x108>
  802f5a:	b8 01 00 00 00       	mov    $0x1,%eax
  802f5f:	89 fa                	mov    %edi,%edx
  802f61:	83 c4 1c             	add    $0x1c,%esp
  802f64:	5b                   	pop    %ebx
  802f65:	5e                   	pop    %esi
  802f66:	5f                   	pop    %edi
  802f67:	5d                   	pop    %ebp
  802f68:	c3                   	ret    
  802f69:	8d 76 00             	lea    0x0(%esi),%esi
  802f6c:	31 ff                	xor    %edi,%edi
  802f6e:	31 c0                	xor    %eax,%eax
  802f70:	89 fa                	mov    %edi,%edx
  802f72:	83 c4 1c             	add    $0x1c,%esp
  802f75:	5b                   	pop    %ebx
  802f76:	5e                   	pop    %esi
  802f77:	5f                   	pop    %edi
  802f78:	5d                   	pop    %ebp
  802f79:	c3                   	ret    
  802f7a:	66 90                	xchg   %ax,%ax
  802f7c:	89 d8                	mov    %ebx,%eax
  802f7e:	f7 f7                	div    %edi
  802f80:	31 ff                	xor    %edi,%edi
  802f82:	89 fa                	mov    %edi,%edx
  802f84:	83 c4 1c             	add    $0x1c,%esp
  802f87:	5b                   	pop    %ebx
  802f88:	5e                   	pop    %esi
  802f89:	5f                   	pop    %edi
  802f8a:	5d                   	pop    %ebp
  802f8b:	c3                   	ret    
  802f8c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802f91:	89 eb                	mov    %ebp,%ebx
  802f93:	29 fb                	sub    %edi,%ebx
  802f95:	89 f9                	mov    %edi,%ecx
  802f97:	d3 e6                	shl    %cl,%esi
  802f99:	89 c5                	mov    %eax,%ebp
  802f9b:	88 d9                	mov    %bl,%cl
  802f9d:	d3 ed                	shr    %cl,%ebp
  802f9f:	89 e9                	mov    %ebp,%ecx
  802fa1:	09 f1                	or     %esi,%ecx
  802fa3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802fa7:	89 f9                	mov    %edi,%ecx
  802fa9:	d3 e0                	shl    %cl,%eax
  802fab:	89 c5                	mov    %eax,%ebp
  802fad:	89 d6                	mov    %edx,%esi
  802faf:	88 d9                	mov    %bl,%cl
  802fb1:	d3 ee                	shr    %cl,%esi
  802fb3:	89 f9                	mov    %edi,%ecx
  802fb5:	d3 e2                	shl    %cl,%edx
  802fb7:	8b 44 24 08          	mov    0x8(%esp),%eax
  802fbb:	88 d9                	mov    %bl,%cl
  802fbd:	d3 e8                	shr    %cl,%eax
  802fbf:	09 c2                	or     %eax,%edx
  802fc1:	89 d0                	mov    %edx,%eax
  802fc3:	89 f2                	mov    %esi,%edx
  802fc5:	f7 74 24 0c          	divl   0xc(%esp)
  802fc9:	89 d6                	mov    %edx,%esi
  802fcb:	89 c3                	mov    %eax,%ebx
  802fcd:	f7 e5                	mul    %ebp
  802fcf:	39 d6                	cmp    %edx,%esi
  802fd1:	72 19                	jb     802fec <__udivdi3+0xfc>
  802fd3:	74 0b                	je     802fe0 <__udivdi3+0xf0>
  802fd5:	89 d8                	mov    %ebx,%eax
  802fd7:	31 ff                	xor    %edi,%edi
  802fd9:	e9 58 ff ff ff       	jmp    802f36 <__udivdi3+0x46>
  802fde:	66 90                	xchg   %ax,%ax
  802fe0:	8b 54 24 08          	mov    0x8(%esp),%edx
  802fe4:	89 f9                	mov    %edi,%ecx
  802fe6:	d3 e2                	shl    %cl,%edx
  802fe8:	39 c2                	cmp    %eax,%edx
  802fea:	73 e9                	jae    802fd5 <__udivdi3+0xe5>
  802fec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802fef:	31 ff                	xor    %edi,%edi
  802ff1:	e9 40 ff ff ff       	jmp    802f36 <__udivdi3+0x46>
  802ff6:	66 90                	xchg   %ax,%ax
  802ff8:	31 c0                	xor    %eax,%eax
  802ffa:	e9 37 ff ff ff       	jmp    802f36 <__udivdi3+0x46>
  802fff:	90                   	nop

00803000 <__umoddi3>:
  803000:	55                   	push   %ebp
  803001:	57                   	push   %edi
  803002:	56                   	push   %esi
  803003:	53                   	push   %ebx
  803004:	83 ec 1c             	sub    $0x1c,%esp
  803007:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80300b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80300f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803013:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803017:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80301b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80301f:	89 f3                	mov    %esi,%ebx
  803021:	89 fa                	mov    %edi,%edx
  803023:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803027:	89 34 24             	mov    %esi,(%esp)
  80302a:	85 c0                	test   %eax,%eax
  80302c:	75 1a                	jne    803048 <__umoddi3+0x48>
  80302e:	39 f7                	cmp    %esi,%edi
  803030:	0f 86 a2 00 00 00    	jbe    8030d8 <__umoddi3+0xd8>
  803036:	89 c8                	mov    %ecx,%eax
  803038:	89 f2                	mov    %esi,%edx
  80303a:	f7 f7                	div    %edi
  80303c:	89 d0                	mov    %edx,%eax
  80303e:	31 d2                	xor    %edx,%edx
  803040:	83 c4 1c             	add    $0x1c,%esp
  803043:	5b                   	pop    %ebx
  803044:	5e                   	pop    %esi
  803045:	5f                   	pop    %edi
  803046:	5d                   	pop    %ebp
  803047:	c3                   	ret    
  803048:	39 f0                	cmp    %esi,%eax
  80304a:	0f 87 ac 00 00 00    	ja     8030fc <__umoddi3+0xfc>
  803050:	0f bd e8             	bsr    %eax,%ebp
  803053:	83 f5 1f             	xor    $0x1f,%ebp
  803056:	0f 84 ac 00 00 00    	je     803108 <__umoddi3+0x108>
  80305c:	bf 20 00 00 00       	mov    $0x20,%edi
  803061:	29 ef                	sub    %ebp,%edi
  803063:	89 fe                	mov    %edi,%esi
  803065:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803069:	89 e9                	mov    %ebp,%ecx
  80306b:	d3 e0                	shl    %cl,%eax
  80306d:	89 d7                	mov    %edx,%edi
  80306f:	89 f1                	mov    %esi,%ecx
  803071:	d3 ef                	shr    %cl,%edi
  803073:	09 c7                	or     %eax,%edi
  803075:	89 e9                	mov    %ebp,%ecx
  803077:	d3 e2                	shl    %cl,%edx
  803079:	89 14 24             	mov    %edx,(%esp)
  80307c:	89 d8                	mov    %ebx,%eax
  80307e:	d3 e0                	shl    %cl,%eax
  803080:	89 c2                	mov    %eax,%edx
  803082:	8b 44 24 08          	mov    0x8(%esp),%eax
  803086:	d3 e0                	shl    %cl,%eax
  803088:	89 44 24 04          	mov    %eax,0x4(%esp)
  80308c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803090:	89 f1                	mov    %esi,%ecx
  803092:	d3 e8                	shr    %cl,%eax
  803094:	09 d0                	or     %edx,%eax
  803096:	d3 eb                	shr    %cl,%ebx
  803098:	89 da                	mov    %ebx,%edx
  80309a:	f7 f7                	div    %edi
  80309c:	89 d3                	mov    %edx,%ebx
  80309e:	f7 24 24             	mull   (%esp)
  8030a1:	89 c6                	mov    %eax,%esi
  8030a3:	89 d1                	mov    %edx,%ecx
  8030a5:	39 d3                	cmp    %edx,%ebx
  8030a7:	0f 82 87 00 00 00    	jb     803134 <__umoddi3+0x134>
  8030ad:	0f 84 91 00 00 00    	je     803144 <__umoddi3+0x144>
  8030b3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8030b7:	29 f2                	sub    %esi,%edx
  8030b9:	19 cb                	sbb    %ecx,%ebx
  8030bb:	89 d8                	mov    %ebx,%eax
  8030bd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8030c1:	d3 e0                	shl    %cl,%eax
  8030c3:	89 e9                	mov    %ebp,%ecx
  8030c5:	d3 ea                	shr    %cl,%edx
  8030c7:	09 d0                	or     %edx,%eax
  8030c9:	89 e9                	mov    %ebp,%ecx
  8030cb:	d3 eb                	shr    %cl,%ebx
  8030cd:	89 da                	mov    %ebx,%edx
  8030cf:	83 c4 1c             	add    $0x1c,%esp
  8030d2:	5b                   	pop    %ebx
  8030d3:	5e                   	pop    %esi
  8030d4:	5f                   	pop    %edi
  8030d5:	5d                   	pop    %ebp
  8030d6:	c3                   	ret    
  8030d7:	90                   	nop
  8030d8:	89 fd                	mov    %edi,%ebp
  8030da:	85 ff                	test   %edi,%edi
  8030dc:	75 0b                	jne    8030e9 <__umoddi3+0xe9>
  8030de:	b8 01 00 00 00       	mov    $0x1,%eax
  8030e3:	31 d2                	xor    %edx,%edx
  8030e5:	f7 f7                	div    %edi
  8030e7:	89 c5                	mov    %eax,%ebp
  8030e9:	89 f0                	mov    %esi,%eax
  8030eb:	31 d2                	xor    %edx,%edx
  8030ed:	f7 f5                	div    %ebp
  8030ef:	89 c8                	mov    %ecx,%eax
  8030f1:	f7 f5                	div    %ebp
  8030f3:	89 d0                	mov    %edx,%eax
  8030f5:	e9 44 ff ff ff       	jmp    80303e <__umoddi3+0x3e>
  8030fa:	66 90                	xchg   %ax,%ax
  8030fc:	89 c8                	mov    %ecx,%eax
  8030fe:	89 f2                	mov    %esi,%edx
  803100:	83 c4 1c             	add    $0x1c,%esp
  803103:	5b                   	pop    %ebx
  803104:	5e                   	pop    %esi
  803105:	5f                   	pop    %edi
  803106:	5d                   	pop    %ebp
  803107:	c3                   	ret    
  803108:	3b 04 24             	cmp    (%esp),%eax
  80310b:	72 06                	jb     803113 <__umoddi3+0x113>
  80310d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803111:	77 0f                	ja     803122 <__umoddi3+0x122>
  803113:	89 f2                	mov    %esi,%edx
  803115:	29 f9                	sub    %edi,%ecx
  803117:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80311b:	89 14 24             	mov    %edx,(%esp)
  80311e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803122:	8b 44 24 04          	mov    0x4(%esp),%eax
  803126:	8b 14 24             	mov    (%esp),%edx
  803129:	83 c4 1c             	add    $0x1c,%esp
  80312c:	5b                   	pop    %ebx
  80312d:	5e                   	pop    %esi
  80312e:	5f                   	pop    %edi
  80312f:	5d                   	pop    %ebp
  803130:	c3                   	ret    
  803131:	8d 76 00             	lea    0x0(%esi),%esi
  803134:	2b 04 24             	sub    (%esp),%eax
  803137:	19 fa                	sbb    %edi,%edx
  803139:	89 d1                	mov    %edx,%ecx
  80313b:	89 c6                	mov    %eax,%esi
  80313d:	e9 71 ff ff ff       	jmp    8030b3 <__umoddi3+0xb3>
  803142:	66 90                	xchg   %ax,%ax
  803144:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803148:	72 ea                	jb     803134 <__umoddi3+0x134>
  80314a:	89 d9                	mov    %ebx,%ecx
  80314c:	e9 62 ff ff ff       	jmp    8030b3 <__umoddi3+0xb3>
