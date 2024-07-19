
obj/user/ef_tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 1e 02 00 00       	call   800254 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program1: Read the 2 shared variables, edit the 3rd one, and exit
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 40 80 00       	mov    0x804020,%eax
  800051:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	89 d0                	mov    %edx,%eax
  80005c:	01 c0                	add    %eax,%eax
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	01 c8                	add    %ecx,%eax
  800065:	8a 40 04             	mov    0x4(%eax),%al
  800068:	84 c0                	test   %al,%al
  80006a:	74 06                	je     800072 <_main+0x3a>
			{
				fullWS = 0;
  80006c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800070:	eb 12                	jmp    800084 <_main+0x4c>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 40 80 00       	mov    0x804020,%eax
  80007a:	8b 50 74             	mov    0x74(%eax),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	39 c2                	cmp    %eax,%edx
  800082:	77 c8                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800084:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800088:	74 14                	je     80009e <_main+0x66>
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	68 e0 31 80 00       	push   $0x8031e0
  800092:	6a 13                	push   $0x13
  800094:	68 fc 31 80 00       	push   $0x8031fc
  800099:	e8 f2 02 00 00       	call   800390 <_panic>
	}
	uint32 *x,*y,*z;
	int32 parentenvID = sys_getparentenvid();
  80009e:	e8 38 1c 00 00       	call   801cdb <sys_getparentenvid>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000a6:	e8 24 1a 00 00       	call   801acf <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000ab:	e8 32 19 00 00       	call   8019e2 <sys_calculate_free_frames>
  8000b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	68 1a 32 80 00       	push   $0x80321a
  8000bb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000be:	e8 0b 17 00 00       	call   8017ce <sget>
  8000c3:	83 c4 10             	add    $0x10,%esp
  8000c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000c9:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d0:	74 14                	je     8000e6 <_main+0xae>
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	68 1c 32 80 00       	push   $0x80321c
  8000da:	6a 1c                	push   $0x1c
  8000dc:	68 fc 31 80 00       	push   $0x8031fc
  8000e1:	e8 aa 02 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000e6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000e9:	e8 f4 18 00 00       	call   8019e2 <sys_calculate_free_frames>
  8000ee:	29 c3                	sub    %eax,%ebx
  8000f0:	89 d8                	mov    %ebx,%eax
  8000f2:	83 f8 01             	cmp    $0x1,%eax
  8000f5:	74 14                	je     80010b <_main+0xd3>
  8000f7:	83 ec 04             	sub    $0x4,%esp
  8000fa:	68 7c 32 80 00       	push   $0x80327c
  8000ff:	6a 1d                	push   $0x1d
  800101:	68 fc 31 80 00       	push   $0x8031fc
  800106:	e8 85 02 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  80010b:	e8 d9 19 00 00       	call   801ae9 <sys_enable_interrupt>

	sys_disable_interrupt();
  800110:	e8 ba 19 00 00       	call   801acf <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800115:	e8 c8 18 00 00       	call   8019e2 <sys_calculate_free_frames>
  80011a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	68 0d 33 80 00       	push   $0x80330d
  800125:	ff 75 ec             	pushl  -0x14(%ebp)
  800128:	e8 a1 16 00 00       	call   8017ce <sget>
  80012d:	83 c4 10             	add    $0x10,%esp
  800130:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800133:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80013a:	74 14                	je     800150 <_main+0x118>
  80013c:	83 ec 04             	sub    $0x4,%esp
  80013f:	68 1c 32 80 00       	push   $0x80321c
  800144:	6a 23                	push   $0x23
  800146:	68 fc 31 80 00       	push   $0x8031fc
  80014b:	e8 40 02 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  800150:	e8 8d 18 00 00       	call   8019e2 <sys_calculate_free_frames>
  800155:	89 c2                	mov    %eax,%edx
  800157:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015a:	39 c2                	cmp    %eax,%edx
  80015c:	74 14                	je     800172 <_main+0x13a>
  80015e:	83 ec 04             	sub    $0x4,%esp
  800161:	68 7c 32 80 00       	push   $0x80327c
  800166:	6a 24                	push   $0x24
  800168:	68 fc 31 80 00       	push   $0x8031fc
  80016d:	e8 1e 02 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  800172:	e8 72 19 00 00       	call   801ae9 <sys_enable_interrupt>
	
	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800177:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80017a:	8b 00                	mov    (%eax),%eax
  80017c:	83 f8 14             	cmp    $0x14,%eax
  80017f:	74 14                	je     800195 <_main+0x15d>
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	68 10 33 80 00       	push   $0x803310
  800189:	6a 27                	push   $0x27
  80018b:	68 fc 31 80 00       	push   $0x8031fc
  800190:	e8 fb 01 00 00       	call   800390 <_panic>

	sys_disable_interrupt();
  800195:	e8 35 19 00 00       	call   801acf <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 43 18 00 00       	call   8019e2 <sys_calculate_free_frames>
  80019f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	68 47 33 80 00       	push   $0x803347
  8001aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ad:	e8 1c 16 00 00       	call   8017ce <sget>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001b8:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 1c 32 80 00       	push   $0x80321c
  8001c9:	6a 2c                	push   $0x2c
  8001cb:	68 fc 31 80 00       	push   $0x8031fc
  8001d0:	e8 bb 01 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001d5:	e8 08 18 00 00       	call   8019e2 <sys_calculate_free_frames>
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	39 c2                	cmp    %eax,%edx
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 7c 32 80 00       	push   $0x80327c
  8001eb:	6a 2d                	push   $0x2d
  8001ed:	68 fc 31 80 00       	push   $0x8031fc
  8001f2:	e8 99 01 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  8001f7:	e8 ed 18 00 00       	call   801ae9 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ff:	8b 00                	mov    (%eax),%eax
  800201:	83 f8 0a             	cmp    $0xa,%eax
  800204:	74 14                	je     80021a <_main+0x1e2>
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 10 33 80 00       	push   $0x803310
  80020e:	6a 30                	push   $0x30
  800210:	68 fc 31 80 00       	push   $0x8031fc
  800215:	e8 76 01 00 00       	call   800390 <_panic>

	*z = *x + *y ;
  80021a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80021d:	8b 10                	mov    (%eax),%edx
  80021f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800222:	8b 00                	mov    (%eax),%eax
  800224:	01 c2                	add    %eax,%edx
  800226:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800229:	89 10                	mov    %edx,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  80022b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80022e:	8b 00                	mov    (%eax),%eax
  800230:	83 f8 1e             	cmp    $0x1e,%eax
  800233:	74 14                	je     800249 <_main+0x211>
  800235:	83 ec 04             	sub    $0x4,%esp
  800238:	68 10 33 80 00       	push   $0x803310
  80023d:	6a 33                	push   $0x33
  80023f:	68 fc 31 80 00       	push   $0x8031fc
  800244:	e8 47 01 00 00       	call   800390 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800249:	e8 b2 1b 00 00       	call   801e00 <inctst>

	return;
  80024e:	90                   	nop
}
  80024f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800252:	c9                   	leave  
  800253:	c3                   	ret    

00800254 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800254:	55                   	push   %ebp
  800255:	89 e5                	mov    %esp,%ebp
  800257:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80025a:	e8 63 1a 00 00       	call   801cc2 <sys_getenvindex>
  80025f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800262:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800265:	89 d0                	mov    %edx,%eax
  800267:	c1 e0 03             	shl    $0x3,%eax
  80026a:	01 d0                	add    %edx,%eax
  80026c:	01 c0                	add    %eax,%eax
  80026e:	01 d0                	add    %edx,%eax
  800270:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800277:	01 d0                	add    %edx,%eax
  800279:	c1 e0 04             	shl    $0x4,%eax
  80027c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800281:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800286:	a1 20 40 80 00       	mov    0x804020,%eax
  80028b:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800291:	84 c0                	test   %al,%al
  800293:	74 0f                	je     8002a4 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800295:	a1 20 40 80 00       	mov    0x804020,%eax
  80029a:	05 5c 05 00 00       	add    $0x55c,%eax
  80029f:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002a8:	7e 0a                	jle    8002b4 <libmain+0x60>
		binaryname = argv[0];
  8002aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ad:	8b 00                	mov    (%eax),%eax
  8002af:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	ff 75 0c             	pushl  0xc(%ebp)
  8002ba:	ff 75 08             	pushl  0x8(%ebp)
  8002bd:	e8 76 fd ff ff       	call   800038 <_main>
  8002c2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002c5:	e8 05 18 00 00       	call   801acf <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002ca:	83 ec 0c             	sub    $0xc,%esp
  8002cd:	68 64 33 80 00       	push   $0x803364
  8002d2:	e8 6d 03 00 00       	call   800644 <cprintf>
  8002d7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002da:	a1 20 40 80 00       	mov    0x804020,%eax
  8002df:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002e5:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ea:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	52                   	push   %edx
  8002f4:	50                   	push   %eax
  8002f5:	68 8c 33 80 00       	push   $0x80338c
  8002fa:	e8 45 03 00 00       	call   800644 <cprintf>
  8002ff:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800302:	a1 20 40 80 00       	mov    0x804020,%eax
  800307:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80030d:	a1 20 40 80 00       	mov    0x804020,%eax
  800312:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800318:	a1 20 40 80 00       	mov    0x804020,%eax
  80031d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800323:	51                   	push   %ecx
  800324:	52                   	push   %edx
  800325:	50                   	push   %eax
  800326:	68 b4 33 80 00       	push   $0x8033b4
  80032b:	e8 14 03 00 00       	call   800644 <cprintf>
  800330:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800333:	a1 20 40 80 00       	mov    0x804020,%eax
  800338:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	50                   	push   %eax
  800342:	68 0c 34 80 00       	push   $0x80340c
  800347:	e8 f8 02 00 00       	call   800644 <cprintf>
  80034c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	68 64 33 80 00       	push   $0x803364
  800357:	e8 e8 02 00 00       	call   800644 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80035f:	e8 85 17 00 00       	call   801ae9 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800364:	e8 19 00 00 00       	call   800382 <exit>
}
  800369:	90                   	nop
  80036a:	c9                   	leave  
  80036b:	c3                   	ret    

0080036c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80036c:	55                   	push   %ebp
  80036d:	89 e5                	mov    %esp,%ebp
  80036f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800372:	83 ec 0c             	sub    $0xc,%esp
  800375:	6a 00                	push   $0x0
  800377:	e8 12 19 00 00       	call   801c8e <sys_destroy_env>
  80037c:	83 c4 10             	add    $0x10,%esp
}
  80037f:	90                   	nop
  800380:	c9                   	leave  
  800381:	c3                   	ret    

00800382 <exit>:

void
exit(void)
{
  800382:	55                   	push   %ebp
  800383:	89 e5                	mov    %esp,%ebp
  800385:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800388:	e8 67 19 00 00       	call   801cf4 <sys_exit_env>
}
  80038d:	90                   	nop
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800396:	8d 45 10             	lea    0x10(%ebp),%eax
  800399:	83 c0 04             	add    $0x4,%eax
  80039c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80039f:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8003a4:	85 c0                	test   %eax,%eax
  8003a6:	74 16                	je     8003be <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003a8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8003ad:	83 ec 08             	sub    $0x8,%esp
  8003b0:	50                   	push   %eax
  8003b1:	68 20 34 80 00       	push   $0x803420
  8003b6:	e8 89 02 00 00       	call   800644 <cprintf>
  8003bb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003be:	a1 00 40 80 00       	mov    0x804000,%eax
  8003c3:	ff 75 0c             	pushl  0xc(%ebp)
  8003c6:	ff 75 08             	pushl  0x8(%ebp)
  8003c9:	50                   	push   %eax
  8003ca:	68 25 34 80 00       	push   $0x803425
  8003cf:	e8 70 02 00 00       	call   800644 <cprintf>
  8003d4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8003da:	83 ec 08             	sub    $0x8,%esp
  8003dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e0:	50                   	push   %eax
  8003e1:	e8 f3 01 00 00       	call   8005d9 <vcprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003e9:	83 ec 08             	sub    $0x8,%esp
  8003ec:	6a 00                	push   $0x0
  8003ee:	68 41 34 80 00       	push   $0x803441
  8003f3:	e8 e1 01 00 00       	call   8005d9 <vcprintf>
  8003f8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003fb:	e8 82 ff ff ff       	call   800382 <exit>

	// should not return here
	while (1) ;
  800400:	eb fe                	jmp    800400 <_panic+0x70>

00800402 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800402:	55                   	push   %ebp
  800403:	89 e5                	mov    %esp,%ebp
  800405:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800408:	a1 20 40 80 00       	mov    0x804020,%eax
  80040d:	8b 50 74             	mov    0x74(%eax),%edx
  800410:	8b 45 0c             	mov    0xc(%ebp),%eax
  800413:	39 c2                	cmp    %eax,%edx
  800415:	74 14                	je     80042b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800417:	83 ec 04             	sub    $0x4,%esp
  80041a:	68 44 34 80 00       	push   $0x803444
  80041f:	6a 26                	push   $0x26
  800421:	68 90 34 80 00       	push   $0x803490
  800426:	e8 65 ff ff ff       	call   800390 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80042b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800432:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800439:	e9 c2 00 00 00       	jmp    800500 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80043e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800441:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	01 d0                	add    %edx,%eax
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	85 c0                	test   %eax,%eax
  800451:	75 08                	jne    80045b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800453:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800456:	e9 a2 00 00 00       	jmp    8004fd <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80045b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800462:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800469:	eb 69                	jmp    8004d4 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80046b:	a1 20 40 80 00       	mov    0x804020,%eax
  800470:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800476:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800479:	89 d0                	mov    %edx,%eax
  80047b:	01 c0                	add    %eax,%eax
  80047d:	01 d0                	add    %edx,%eax
  80047f:	c1 e0 03             	shl    $0x3,%eax
  800482:	01 c8                	add    %ecx,%eax
  800484:	8a 40 04             	mov    0x4(%eax),%al
  800487:	84 c0                	test   %al,%al
  800489:	75 46                	jne    8004d1 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80048b:	a1 20 40 80 00       	mov    0x804020,%eax
  800490:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800496:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800499:	89 d0                	mov    %edx,%eax
  80049b:	01 c0                	add    %eax,%eax
  80049d:	01 d0                	add    %edx,%eax
  80049f:	c1 e0 03             	shl    $0x3,%eax
  8004a2:	01 c8                	add    %ecx,%eax
  8004a4:	8b 00                	mov    (%eax),%eax
  8004a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004b1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	01 c8                	add    %ecx,%eax
  8004c2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004c4:	39 c2                	cmp    %eax,%edx
  8004c6:	75 09                	jne    8004d1 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004c8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004cf:	eb 12                	jmp    8004e3 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d1:	ff 45 e8             	incl   -0x18(%ebp)
  8004d4:	a1 20 40 80 00       	mov    0x804020,%eax
  8004d9:	8b 50 74             	mov    0x74(%eax),%edx
  8004dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004df:	39 c2                	cmp    %eax,%edx
  8004e1:	77 88                	ja     80046b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004e7:	75 14                	jne    8004fd <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004e9:	83 ec 04             	sub    $0x4,%esp
  8004ec:	68 9c 34 80 00       	push   $0x80349c
  8004f1:	6a 3a                	push   $0x3a
  8004f3:	68 90 34 80 00       	push   $0x803490
  8004f8:	e8 93 fe ff ff       	call   800390 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004fd:	ff 45 f0             	incl   -0x10(%ebp)
  800500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800503:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800506:	0f 8c 32 ff ff ff    	jl     80043e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80050c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800513:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80051a:	eb 26                	jmp    800542 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80051c:	a1 20 40 80 00       	mov    0x804020,%eax
  800521:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800527:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80052a:	89 d0                	mov    %edx,%eax
  80052c:	01 c0                	add    %eax,%eax
  80052e:	01 d0                	add    %edx,%eax
  800530:	c1 e0 03             	shl    $0x3,%eax
  800533:	01 c8                	add    %ecx,%eax
  800535:	8a 40 04             	mov    0x4(%eax),%al
  800538:	3c 01                	cmp    $0x1,%al
  80053a:	75 03                	jne    80053f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80053c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053f:	ff 45 e0             	incl   -0x20(%ebp)
  800542:	a1 20 40 80 00       	mov    0x804020,%eax
  800547:	8b 50 74             	mov    0x74(%eax),%edx
  80054a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054d:	39 c2                	cmp    %eax,%edx
  80054f:	77 cb                	ja     80051c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800554:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800557:	74 14                	je     80056d <CheckWSWithoutLastIndex+0x16b>
		panic(
  800559:	83 ec 04             	sub    $0x4,%esp
  80055c:	68 f0 34 80 00       	push   $0x8034f0
  800561:	6a 44                	push   $0x44
  800563:	68 90 34 80 00       	push   $0x803490
  800568:	e8 23 fe ff ff       	call   800390 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80056d:	90                   	nop
  80056e:	c9                   	leave  
  80056f:	c3                   	ret    

00800570 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800570:	55                   	push   %ebp
  800571:	89 e5                	mov    %esp,%ebp
  800573:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800576:	8b 45 0c             	mov    0xc(%ebp),%eax
  800579:	8b 00                	mov    (%eax),%eax
  80057b:	8d 48 01             	lea    0x1(%eax),%ecx
  80057e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800581:	89 0a                	mov    %ecx,(%edx)
  800583:	8b 55 08             	mov    0x8(%ebp),%edx
  800586:	88 d1                	mov    %dl,%cl
  800588:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80058f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800592:	8b 00                	mov    (%eax),%eax
  800594:	3d ff 00 00 00       	cmp    $0xff,%eax
  800599:	75 2c                	jne    8005c7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80059b:	a0 24 40 80 00       	mov    0x804024,%al
  8005a0:	0f b6 c0             	movzbl %al,%eax
  8005a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a6:	8b 12                	mov    (%edx),%edx
  8005a8:	89 d1                	mov    %edx,%ecx
  8005aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ad:	83 c2 08             	add    $0x8,%edx
  8005b0:	83 ec 04             	sub    $0x4,%esp
  8005b3:	50                   	push   %eax
  8005b4:	51                   	push   %ecx
  8005b5:	52                   	push   %edx
  8005b6:	e8 66 13 00 00       	call   801921 <sys_cputs>
  8005bb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ca:	8b 40 04             	mov    0x4(%eax),%eax
  8005cd:	8d 50 01             	lea    0x1(%eax),%edx
  8005d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005d6:	90                   	nop
  8005d7:	c9                   	leave  
  8005d8:	c3                   	ret    

008005d9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005d9:	55                   	push   %ebp
  8005da:	89 e5                	mov    %esp,%ebp
  8005dc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005e9:	00 00 00 
	b.cnt = 0;
  8005ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005f3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005f6:	ff 75 0c             	pushl  0xc(%ebp)
  8005f9:	ff 75 08             	pushl  0x8(%ebp)
  8005fc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800602:	50                   	push   %eax
  800603:	68 70 05 80 00       	push   $0x800570
  800608:	e8 11 02 00 00       	call   80081e <vprintfmt>
  80060d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800610:	a0 24 40 80 00       	mov    0x804024,%al
  800615:	0f b6 c0             	movzbl %al,%eax
  800618:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80061e:	83 ec 04             	sub    $0x4,%esp
  800621:	50                   	push   %eax
  800622:	52                   	push   %edx
  800623:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800629:	83 c0 08             	add    $0x8,%eax
  80062c:	50                   	push   %eax
  80062d:	e8 ef 12 00 00       	call   801921 <sys_cputs>
  800632:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800635:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80063c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800642:	c9                   	leave  
  800643:	c3                   	ret    

00800644 <cprintf>:

int cprintf(const char *fmt, ...) {
  800644:	55                   	push   %ebp
  800645:	89 e5                	mov    %esp,%ebp
  800647:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80064a:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800651:	8d 45 0c             	lea    0xc(%ebp),%eax
  800654:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	ff 75 f4             	pushl  -0xc(%ebp)
  800660:	50                   	push   %eax
  800661:	e8 73 ff ff ff       	call   8005d9 <vcprintf>
  800666:	83 c4 10             	add    $0x10,%esp
  800669:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80066c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80066f:	c9                   	leave  
  800670:	c3                   	ret    

00800671 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800671:	55                   	push   %ebp
  800672:	89 e5                	mov    %esp,%ebp
  800674:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800677:	e8 53 14 00 00       	call   801acf <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80067c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80067f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	83 ec 08             	sub    $0x8,%esp
  800688:	ff 75 f4             	pushl  -0xc(%ebp)
  80068b:	50                   	push   %eax
  80068c:	e8 48 ff ff ff       	call   8005d9 <vcprintf>
  800691:	83 c4 10             	add    $0x10,%esp
  800694:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800697:	e8 4d 14 00 00       	call   801ae9 <sys_enable_interrupt>
	return cnt;
  80069c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80069f:	c9                   	leave  
  8006a0:	c3                   	ret    

008006a1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006a1:	55                   	push   %ebp
  8006a2:	89 e5                	mov    %esp,%ebp
  8006a4:	53                   	push   %ebx
  8006a5:	83 ec 14             	sub    $0x14,%esp
  8006a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8006ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006b4:	8b 45 18             	mov    0x18(%ebp),%eax
  8006b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006bc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006bf:	77 55                	ja     800716 <printnum+0x75>
  8006c1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006c4:	72 05                	jb     8006cb <printnum+0x2a>
  8006c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006c9:	77 4b                	ja     800716 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006cb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006ce:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8006d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d9:	52                   	push   %edx
  8006da:	50                   	push   %eax
  8006db:	ff 75 f4             	pushl  -0xc(%ebp)
  8006de:	ff 75 f0             	pushl  -0x10(%ebp)
  8006e1:	e8 86 28 00 00       	call   802f6c <__udivdi3>
  8006e6:	83 c4 10             	add    $0x10,%esp
  8006e9:	83 ec 04             	sub    $0x4,%esp
  8006ec:	ff 75 20             	pushl  0x20(%ebp)
  8006ef:	53                   	push   %ebx
  8006f0:	ff 75 18             	pushl  0x18(%ebp)
  8006f3:	52                   	push   %edx
  8006f4:	50                   	push   %eax
  8006f5:	ff 75 0c             	pushl  0xc(%ebp)
  8006f8:	ff 75 08             	pushl  0x8(%ebp)
  8006fb:	e8 a1 ff ff ff       	call   8006a1 <printnum>
  800700:	83 c4 20             	add    $0x20,%esp
  800703:	eb 1a                	jmp    80071f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800705:	83 ec 08             	sub    $0x8,%esp
  800708:	ff 75 0c             	pushl  0xc(%ebp)
  80070b:	ff 75 20             	pushl  0x20(%ebp)
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	ff d0                	call   *%eax
  800713:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800716:	ff 4d 1c             	decl   0x1c(%ebp)
  800719:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80071d:	7f e6                	jg     800705 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80071f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800722:	bb 00 00 00 00       	mov    $0x0,%ebx
  800727:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80072a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80072d:	53                   	push   %ebx
  80072e:	51                   	push   %ecx
  80072f:	52                   	push   %edx
  800730:	50                   	push   %eax
  800731:	e8 46 29 00 00       	call   80307c <__umoddi3>
  800736:	83 c4 10             	add    $0x10,%esp
  800739:	05 54 37 80 00       	add    $0x803754,%eax
  80073e:	8a 00                	mov    (%eax),%al
  800740:	0f be c0             	movsbl %al,%eax
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	ff 75 0c             	pushl  0xc(%ebp)
  800749:	50                   	push   %eax
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	ff d0                	call   *%eax
  80074f:	83 c4 10             	add    $0x10,%esp
}
  800752:	90                   	nop
  800753:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800756:	c9                   	leave  
  800757:	c3                   	ret    

00800758 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800758:	55                   	push   %ebp
  800759:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80075b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80075f:	7e 1c                	jle    80077d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	8d 50 08             	lea    0x8(%eax),%edx
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	89 10                	mov    %edx,(%eax)
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	83 e8 08             	sub    $0x8,%eax
  800776:	8b 50 04             	mov    0x4(%eax),%edx
  800779:	8b 00                	mov    (%eax),%eax
  80077b:	eb 40                	jmp    8007bd <getuint+0x65>
	else if (lflag)
  80077d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800781:	74 1e                	je     8007a1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	8d 50 04             	lea    0x4(%eax),%edx
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	89 10                	mov    %edx,(%eax)
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	8b 00                	mov    (%eax),%eax
  800795:	83 e8 04             	sub    $0x4,%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	ba 00 00 00 00       	mov    $0x0,%edx
  80079f:	eb 1c                	jmp    8007bd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	8d 50 04             	lea    0x4(%eax),%edx
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	89 10                	mov    %edx,(%eax)
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	83 e8 04             	sub    $0x4,%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007bd:	5d                   	pop    %ebp
  8007be:	c3                   	ret    

008007bf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007bf:	55                   	push   %ebp
  8007c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007c2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c6:	7e 1c                	jle    8007e4 <getint+0x25>
		return va_arg(*ap, long long);
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	8d 50 08             	lea    0x8(%eax),%edx
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	89 10                	mov    %edx,(%eax)
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	83 e8 08             	sub    $0x8,%eax
  8007dd:	8b 50 04             	mov    0x4(%eax),%edx
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	eb 38                	jmp    80081c <getint+0x5d>
	else if (lflag)
  8007e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e8:	74 1a                	je     800804 <getint+0x45>
		return va_arg(*ap, long);
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	8d 50 04             	lea    0x4(%eax),%edx
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	89 10                	mov    %edx,(%eax)
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	8b 00                	mov    (%eax),%eax
  8007fc:	83 e8 04             	sub    $0x4,%eax
  8007ff:	8b 00                	mov    (%eax),%eax
  800801:	99                   	cltd   
  800802:	eb 18                	jmp    80081c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800804:	8b 45 08             	mov    0x8(%ebp),%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	8d 50 04             	lea    0x4(%eax),%edx
  80080c:	8b 45 08             	mov    0x8(%ebp),%eax
  80080f:	89 10                	mov    %edx,(%eax)
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	8b 00                	mov    (%eax),%eax
  800816:	83 e8 04             	sub    $0x4,%eax
  800819:	8b 00                	mov    (%eax),%eax
  80081b:	99                   	cltd   
}
  80081c:	5d                   	pop    %ebp
  80081d:	c3                   	ret    

0080081e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	56                   	push   %esi
  800822:	53                   	push   %ebx
  800823:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800826:	eb 17                	jmp    80083f <vprintfmt+0x21>
			if (ch == '\0')
  800828:	85 db                	test   %ebx,%ebx
  80082a:	0f 84 af 03 00 00    	je     800bdf <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	53                   	push   %ebx
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	ff d0                	call   *%eax
  80083c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80083f:	8b 45 10             	mov    0x10(%ebp),%eax
  800842:	8d 50 01             	lea    0x1(%eax),%edx
  800845:	89 55 10             	mov    %edx,0x10(%ebp)
  800848:	8a 00                	mov    (%eax),%al
  80084a:	0f b6 d8             	movzbl %al,%ebx
  80084d:	83 fb 25             	cmp    $0x25,%ebx
  800850:	75 d6                	jne    800828 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800852:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800856:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80085d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800864:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80086b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800872:	8b 45 10             	mov    0x10(%ebp),%eax
  800875:	8d 50 01             	lea    0x1(%eax),%edx
  800878:	89 55 10             	mov    %edx,0x10(%ebp)
  80087b:	8a 00                	mov    (%eax),%al
  80087d:	0f b6 d8             	movzbl %al,%ebx
  800880:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800883:	83 f8 55             	cmp    $0x55,%eax
  800886:	0f 87 2b 03 00 00    	ja     800bb7 <vprintfmt+0x399>
  80088c:	8b 04 85 78 37 80 00 	mov    0x803778(,%eax,4),%eax
  800893:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800895:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800899:	eb d7                	jmp    800872 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80089b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80089f:	eb d1                	jmp    800872 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008ab:	89 d0                	mov    %edx,%eax
  8008ad:	c1 e0 02             	shl    $0x2,%eax
  8008b0:	01 d0                	add    %edx,%eax
  8008b2:	01 c0                	add    %eax,%eax
  8008b4:	01 d8                	add    %ebx,%eax
  8008b6:	83 e8 30             	sub    $0x30,%eax
  8008b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8008bf:	8a 00                	mov    (%eax),%al
  8008c1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008c4:	83 fb 2f             	cmp    $0x2f,%ebx
  8008c7:	7e 3e                	jle    800907 <vprintfmt+0xe9>
  8008c9:	83 fb 39             	cmp    $0x39,%ebx
  8008cc:	7f 39                	jg     800907 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ce:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008d1:	eb d5                	jmp    8008a8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d6:	83 c0 04             	add    $0x4,%eax
  8008d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008df:	83 e8 04             	sub    $0x4,%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008e7:	eb 1f                	jmp    800908 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ed:	79 83                	jns    800872 <vprintfmt+0x54>
				width = 0;
  8008ef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008f6:	e9 77 ff ff ff       	jmp    800872 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008fb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800902:	e9 6b ff ff ff       	jmp    800872 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800907:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800908:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80090c:	0f 89 60 ff ff ff    	jns    800872 <vprintfmt+0x54>
				width = precision, precision = -1;
  800912:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800915:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800918:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80091f:	e9 4e ff ff ff       	jmp    800872 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800924:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800927:	e9 46 ff ff ff       	jmp    800872 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80092c:	8b 45 14             	mov    0x14(%ebp),%eax
  80092f:	83 c0 04             	add    $0x4,%eax
  800932:	89 45 14             	mov    %eax,0x14(%ebp)
  800935:	8b 45 14             	mov    0x14(%ebp),%eax
  800938:	83 e8 04             	sub    $0x4,%eax
  80093b:	8b 00                	mov    (%eax),%eax
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 0c             	pushl  0xc(%ebp)
  800943:	50                   	push   %eax
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	ff d0                	call   *%eax
  800949:	83 c4 10             	add    $0x10,%esp
			break;
  80094c:	e9 89 02 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800951:	8b 45 14             	mov    0x14(%ebp),%eax
  800954:	83 c0 04             	add    $0x4,%eax
  800957:	89 45 14             	mov    %eax,0x14(%ebp)
  80095a:	8b 45 14             	mov    0x14(%ebp),%eax
  80095d:	83 e8 04             	sub    $0x4,%eax
  800960:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800962:	85 db                	test   %ebx,%ebx
  800964:	79 02                	jns    800968 <vprintfmt+0x14a>
				err = -err;
  800966:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800968:	83 fb 64             	cmp    $0x64,%ebx
  80096b:	7f 0b                	jg     800978 <vprintfmt+0x15a>
  80096d:	8b 34 9d c0 35 80 00 	mov    0x8035c0(,%ebx,4),%esi
  800974:	85 f6                	test   %esi,%esi
  800976:	75 19                	jne    800991 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800978:	53                   	push   %ebx
  800979:	68 65 37 80 00       	push   $0x803765
  80097e:	ff 75 0c             	pushl  0xc(%ebp)
  800981:	ff 75 08             	pushl  0x8(%ebp)
  800984:	e8 5e 02 00 00       	call   800be7 <printfmt>
  800989:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80098c:	e9 49 02 00 00       	jmp    800bda <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800991:	56                   	push   %esi
  800992:	68 6e 37 80 00       	push   $0x80376e
  800997:	ff 75 0c             	pushl  0xc(%ebp)
  80099a:	ff 75 08             	pushl  0x8(%ebp)
  80099d:	e8 45 02 00 00       	call   800be7 <printfmt>
  8009a2:	83 c4 10             	add    $0x10,%esp
			break;
  8009a5:	e9 30 02 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ad:	83 c0 04             	add    $0x4,%eax
  8009b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b6:	83 e8 04             	sub    $0x4,%eax
  8009b9:	8b 30                	mov    (%eax),%esi
  8009bb:	85 f6                	test   %esi,%esi
  8009bd:	75 05                	jne    8009c4 <vprintfmt+0x1a6>
				p = "(null)";
  8009bf:	be 71 37 80 00       	mov    $0x803771,%esi
			if (width > 0 && padc != '-')
  8009c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c8:	7e 6d                	jle    800a37 <vprintfmt+0x219>
  8009ca:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009ce:	74 67                	je     800a37 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	50                   	push   %eax
  8009d7:	56                   	push   %esi
  8009d8:	e8 0c 03 00 00       	call   800ce9 <strnlen>
  8009dd:	83 c4 10             	add    $0x10,%esp
  8009e0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009e3:	eb 16                	jmp    8009fb <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009e5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	50                   	push   %eax
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	ff d0                	call   *%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009f8:	ff 4d e4             	decl   -0x1c(%ebp)
  8009fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ff:	7f e4                	jg     8009e5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a01:	eb 34                	jmp    800a37 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a03:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a07:	74 1c                	je     800a25 <vprintfmt+0x207>
  800a09:	83 fb 1f             	cmp    $0x1f,%ebx
  800a0c:	7e 05                	jle    800a13 <vprintfmt+0x1f5>
  800a0e:	83 fb 7e             	cmp    $0x7e,%ebx
  800a11:	7e 12                	jle    800a25 <vprintfmt+0x207>
					putch('?', putdat);
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 0c             	pushl  0xc(%ebp)
  800a19:	6a 3f                	push   $0x3f
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	ff d0                	call   *%eax
  800a20:	83 c4 10             	add    $0x10,%esp
  800a23:	eb 0f                	jmp    800a34 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a25:	83 ec 08             	sub    $0x8,%esp
  800a28:	ff 75 0c             	pushl  0xc(%ebp)
  800a2b:	53                   	push   %ebx
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	ff d0                	call   *%eax
  800a31:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a34:	ff 4d e4             	decl   -0x1c(%ebp)
  800a37:	89 f0                	mov    %esi,%eax
  800a39:	8d 70 01             	lea    0x1(%eax),%esi
  800a3c:	8a 00                	mov    (%eax),%al
  800a3e:	0f be d8             	movsbl %al,%ebx
  800a41:	85 db                	test   %ebx,%ebx
  800a43:	74 24                	je     800a69 <vprintfmt+0x24b>
  800a45:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a49:	78 b8                	js     800a03 <vprintfmt+0x1e5>
  800a4b:	ff 4d e0             	decl   -0x20(%ebp)
  800a4e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a52:	79 af                	jns    800a03 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a54:	eb 13                	jmp    800a69 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	ff 75 0c             	pushl  0xc(%ebp)
  800a5c:	6a 20                	push   $0x20
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	ff d0                	call   *%eax
  800a63:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a66:	ff 4d e4             	decl   -0x1c(%ebp)
  800a69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6d:	7f e7                	jg     800a56 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a6f:	e9 66 01 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a74:	83 ec 08             	sub    $0x8,%esp
  800a77:	ff 75 e8             	pushl  -0x18(%ebp)
  800a7a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a7d:	50                   	push   %eax
  800a7e:	e8 3c fd ff ff       	call   8007bf <getint>
  800a83:	83 c4 10             	add    $0x10,%esp
  800a86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a89:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a92:	85 d2                	test   %edx,%edx
  800a94:	79 23                	jns    800ab9 <vprintfmt+0x29b>
				putch('-', putdat);
  800a96:	83 ec 08             	sub    $0x8,%esp
  800a99:	ff 75 0c             	pushl  0xc(%ebp)
  800a9c:	6a 2d                	push   $0x2d
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	ff d0                	call   *%eax
  800aa3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aac:	f7 d8                	neg    %eax
  800aae:	83 d2 00             	adc    $0x0,%edx
  800ab1:	f7 da                	neg    %edx
  800ab3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ab9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ac0:	e9 bc 00 00 00       	jmp    800b81 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ac5:	83 ec 08             	sub    $0x8,%esp
  800ac8:	ff 75 e8             	pushl  -0x18(%ebp)
  800acb:	8d 45 14             	lea    0x14(%ebp),%eax
  800ace:	50                   	push   %eax
  800acf:	e8 84 fc ff ff       	call   800758 <getuint>
  800ad4:	83 c4 10             	add    $0x10,%esp
  800ad7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ada:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800add:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ae4:	e9 98 00 00 00       	jmp    800b81 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ae9:	83 ec 08             	sub    $0x8,%esp
  800aec:	ff 75 0c             	pushl  0xc(%ebp)
  800aef:	6a 58                	push   $0x58
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	ff d0                	call   *%eax
  800af6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800af9:	83 ec 08             	sub    $0x8,%esp
  800afc:	ff 75 0c             	pushl  0xc(%ebp)
  800aff:	6a 58                	push   $0x58
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	ff d0                	call   *%eax
  800b06:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b09:	83 ec 08             	sub    $0x8,%esp
  800b0c:	ff 75 0c             	pushl  0xc(%ebp)
  800b0f:	6a 58                	push   $0x58
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	ff d0                	call   *%eax
  800b16:	83 c4 10             	add    $0x10,%esp
			break;
  800b19:	e9 bc 00 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b1e:	83 ec 08             	sub    $0x8,%esp
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	6a 30                	push   $0x30
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	ff d0                	call   *%eax
  800b2b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	6a 78                	push   $0x78
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b41:	83 c0 04             	add    $0x4,%eax
  800b44:	89 45 14             	mov    %eax,0x14(%ebp)
  800b47:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4a:	83 e8 04             	sub    $0x4,%eax
  800b4d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b59:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b60:	eb 1f                	jmp    800b81 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b62:	83 ec 08             	sub    $0x8,%esp
  800b65:	ff 75 e8             	pushl  -0x18(%ebp)
  800b68:	8d 45 14             	lea    0x14(%ebp),%eax
  800b6b:	50                   	push   %eax
  800b6c:	e8 e7 fb ff ff       	call   800758 <getuint>
  800b71:	83 c4 10             	add    $0x10,%esp
  800b74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b7a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b81:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b88:	83 ec 04             	sub    $0x4,%esp
  800b8b:	52                   	push   %edx
  800b8c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b8f:	50                   	push   %eax
  800b90:	ff 75 f4             	pushl  -0xc(%ebp)
  800b93:	ff 75 f0             	pushl  -0x10(%ebp)
  800b96:	ff 75 0c             	pushl  0xc(%ebp)
  800b99:	ff 75 08             	pushl  0x8(%ebp)
  800b9c:	e8 00 fb ff ff       	call   8006a1 <printnum>
  800ba1:	83 c4 20             	add    $0x20,%esp
			break;
  800ba4:	eb 34                	jmp    800bda <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ba6:	83 ec 08             	sub    $0x8,%esp
  800ba9:	ff 75 0c             	pushl  0xc(%ebp)
  800bac:	53                   	push   %ebx
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	ff d0                	call   *%eax
  800bb2:	83 c4 10             	add    $0x10,%esp
			break;
  800bb5:	eb 23                	jmp    800bda <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bb7:	83 ec 08             	sub    $0x8,%esp
  800bba:	ff 75 0c             	pushl  0xc(%ebp)
  800bbd:	6a 25                	push   $0x25
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	ff d0                	call   *%eax
  800bc4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bc7:	ff 4d 10             	decl   0x10(%ebp)
  800bca:	eb 03                	jmp    800bcf <vprintfmt+0x3b1>
  800bcc:	ff 4d 10             	decl   0x10(%ebp)
  800bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd2:	48                   	dec    %eax
  800bd3:	8a 00                	mov    (%eax),%al
  800bd5:	3c 25                	cmp    $0x25,%al
  800bd7:	75 f3                	jne    800bcc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bd9:	90                   	nop
		}
	}
  800bda:	e9 47 fc ff ff       	jmp    800826 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bdf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800be0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be3:	5b                   	pop    %ebx
  800be4:	5e                   	pop    %esi
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bed:	8d 45 10             	lea    0x10(%ebp),%eax
  800bf0:	83 c0 04             	add    $0x4,%eax
  800bf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bf6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bfc:	50                   	push   %eax
  800bfd:	ff 75 0c             	pushl  0xc(%ebp)
  800c00:	ff 75 08             	pushl  0x8(%ebp)
  800c03:	e8 16 fc ff ff       	call   80081e <vprintfmt>
  800c08:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c0b:	90                   	nop
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    

00800c0e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c14:	8b 40 08             	mov    0x8(%eax),%eax
  800c17:	8d 50 01             	lea    0x1(%eax),%edx
  800c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c23:	8b 10                	mov    (%eax),%edx
  800c25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c28:	8b 40 04             	mov    0x4(%eax),%eax
  800c2b:	39 c2                	cmp    %eax,%edx
  800c2d:	73 12                	jae    800c41 <sprintputch+0x33>
		*b->buf++ = ch;
  800c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c32:	8b 00                	mov    (%eax),%eax
  800c34:	8d 48 01             	lea    0x1(%eax),%ecx
  800c37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3a:	89 0a                	mov    %ecx,(%edx)
  800c3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3f:	88 10                	mov    %dl,(%eax)
}
  800c41:	90                   	nop
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c53:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	01 d0                	add    %edx,%eax
  800c5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c69:	74 06                	je     800c71 <vsnprintf+0x2d>
  800c6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c6f:	7f 07                	jg     800c78 <vsnprintf+0x34>
		return -E_INVAL;
  800c71:	b8 03 00 00 00       	mov    $0x3,%eax
  800c76:	eb 20                	jmp    800c98 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c78:	ff 75 14             	pushl  0x14(%ebp)
  800c7b:	ff 75 10             	pushl  0x10(%ebp)
  800c7e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c81:	50                   	push   %eax
  800c82:	68 0e 0c 80 00       	push   $0x800c0e
  800c87:	e8 92 fb ff ff       	call   80081e <vprintfmt>
  800c8c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c92:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c98:	c9                   	leave  
  800c99:	c3                   	ret    

00800c9a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ca0:	8d 45 10             	lea    0x10(%ebp),%eax
  800ca3:	83 c0 04             	add    $0x4,%eax
  800ca6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ca9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cac:	ff 75 f4             	pushl  -0xc(%ebp)
  800caf:	50                   	push   %eax
  800cb0:	ff 75 0c             	pushl  0xc(%ebp)
  800cb3:	ff 75 08             	pushl  0x8(%ebp)
  800cb6:	e8 89 ff ff ff       	call   800c44 <vsnprintf>
  800cbb:	83 c4 10             	add    $0x10,%esp
  800cbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cc4:	c9                   	leave  
  800cc5:	c3                   	ret    

00800cc6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ccc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd3:	eb 06                	jmp    800cdb <strlen+0x15>
		n++;
  800cd5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cd8:	ff 45 08             	incl   0x8(%ebp)
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	8a 00                	mov    (%eax),%al
  800ce0:	84 c0                	test   %al,%al
  800ce2:	75 f1                	jne    800cd5 <strlen+0xf>
		n++;
	return n;
  800ce4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce7:	c9                   	leave  
  800ce8:	c3                   	ret    

00800ce9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf6:	eb 09                	jmp    800d01 <strnlen+0x18>
		n++;
  800cf8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cfb:	ff 45 08             	incl   0x8(%ebp)
  800cfe:	ff 4d 0c             	decl   0xc(%ebp)
  800d01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d05:	74 09                	je     800d10 <strnlen+0x27>
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	8a 00                	mov    (%eax),%al
  800d0c:	84 c0                	test   %al,%al
  800d0e:	75 e8                	jne    800cf8 <strnlen+0xf>
		n++;
	return n;
  800d10:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d13:	c9                   	leave  
  800d14:	c3                   	ret    

00800d15 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d21:	90                   	nop
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8d 50 01             	lea    0x1(%eax),%edx
  800d28:	89 55 08             	mov    %edx,0x8(%ebp)
  800d2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d31:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d34:	8a 12                	mov    (%edx),%dl
  800d36:	88 10                	mov    %dl,(%eax)
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	84 c0                	test   %al,%al
  800d3c:	75 e4                	jne    800d22 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d41:	c9                   	leave  
  800d42:	c3                   	ret    

00800d43 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d56:	eb 1f                	jmp    800d77 <strncpy+0x34>
		*dst++ = *src;
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8d 50 01             	lea    0x1(%eax),%edx
  800d5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800d61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d64:	8a 12                	mov    (%edx),%dl
  800d66:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	84 c0                	test   %al,%al
  800d6f:	74 03                	je     800d74 <strncpy+0x31>
			src++;
  800d71:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d74:	ff 45 fc             	incl   -0x4(%ebp)
  800d77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d7a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d7d:	72 d9                	jb     800d58 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d82:	c9                   	leave  
  800d83:	c3                   	ret    

00800d84 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d94:	74 30                	je     800dc6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d96:	eb 16                	jmp    800dae <strlcpy+0x2a>
			*dst++ = *src++;
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	8d 50 01             	lea    0x1(%eax),%edx
  800d9e:	89 55 08             	mov    %edx,0x8(%ebp)
  800da1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800daa:	8a 12                	mov    (%edx),%dl
  800dac:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dae:	ff 4d 10             	decl   0x10(%ebp)
  800db1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db5:	74 09                	je     800dc0 <strlcpy+0x3c>
  800db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dba:	8a 00                	mov    (%eax),%al
  800dbc:	84 c0                	test   %al,%al
  800dbe:	75 d8                	jne    800d98 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcc:	29 c2                	sub    %eax,%edx
  800dce:	89 d0                	mov    %edx,%eax
}
  800dd0:	c9                   	leave  
  800dd1:	c3                   	ret    

00800dd2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dd5:	eb 06                	jmp    800ddd <strcmp+0xb>
		p++, q++;
  800dd7:	ff 45 08             	incl   0x8(%ebp)
  800dda:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	8a 00                	mov    (%eax),%al
  800de2:	84 c0                	test   %al,%al
  800de4:	74 0e                	je     800df4 <strcmp+0x22>
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	8a 10                	mov    (%eax),%dl
  800deb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dee:	8a 00                	mov    (%eax),%al
  800df0:	38 c2                	cmp    %al,%dl
  800df2:	74 e3                	je     800dd7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	0f b6 d0             	movzbl %al,%edx
  800dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	0f b6 c0             	movzbl %al,%eax
  800e04:	29 c2                	sub    %eax,%edx
  800e06:	89 d0                	mov    %edx,%eax
}
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    

00800e0a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e0d:	eb 09                	jmp    800e18 <strncmp+0xe>
		n--, p++, q++;
  800e0f:	ff 4d 10             	decl   0x10(%ebp)
  800e12:	ff 45 08             	incl   0x8(%ebp)
  800e15:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1c:	74 17                	je     800e35 <strncmp+0x2b>
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	8a 00                	mov    (%eax),%al
  800e23:	84 c0                	test   %al,%al
  800e25:	74 0e                	je     800e35 <strncmp+0x2b>
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8a 10                	mov    (%eax),%dl
  800e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2f:	8a 00                	mov    (%eax),%al
  800e31:	38 c2                	cmp    %al,%dl
  800e33:	74 da                	je     800e0f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e39:	75 07                	jne    800e42 <strncmp+0x38>
		return 0;
  800e3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e40:	eb 14                	jmp    800e56 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	0f b6 d0             	movzbl %al,%edx
  800e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	0f b6 c0             	movzbl %al,%eax
  800e52:	29 c2                	sub    %eax,%edx
  800e54:	89 d0                	mov    %edx,%eax
}
  800e56:	5d                   	pop    %ebp
  800e57:	c3                   	ret    

00800e58 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	83 ec 04             	sub    $0x4,%esp
  800e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e61:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e64:	eb 12                	jmp    800e78 <strchr+0x20>
		if (*s == c)
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e6e:	75 05                	jne    800e75 <strchr+0x1d>
			return (char *) s;
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	eb 11                	jmp    800e86 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e75:	ff 45 08             	incl   0x8(%ebp)
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	84 c0                	test   %al,%al
  800e7f:	75 e5                	jne    800e66 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e86:	c9                   	leave  
  800e87:	c3                   	ret    

00800e88 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	83 ec 04             	sub    $0x4,%esp
  800e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e91:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e94:	eb 0d                	jmp    800ea3 <strfind+0x1b>
		if (*s == c)
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e9e:	74 0e                	je     800eae <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ea0:	ff 45 08             	incl   0x8(%ebp)
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	84 c0                	test   %al,%al
  800eaa:	75 ea                	jne    800e96 <strfind+0xe>
  800eac:	eb 01                	jmp    800eaf <strfind+0x27>
		if (*s == c)
			break;
  800eae:	90                   	nop
	return (char *) s;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb2:	c9                   	leave  
  800eb3:	c3                   	ret    

00800eb4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ec0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ec6:	eb 0e                	jmp    800ed6 <memset+0x22>
		*p++ = c;
  800ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecb:	8d 50 01             	lea    0x1(%eax),%edx
  800ece:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ed1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ed6:	ff 4d f8             	decl   -0x8(%ebp)
  800ed9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800edd:	79 e9                	jns    800ec8 <memset+0x14>
		*p++ = c;

	return v;
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee2:	c9                   	leave  
  800ee3:	c3                   	ret    

00800ee4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
  800ee7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ef6:	eb 16                	jmp    800f0e <memcpy+0x2a>
		*d++ = *s++;
  800ef8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efb:	8d 50 01             	lea    0x1(%eax),%edx
  800efe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f07:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f0a:	8a 12                	mov    (%edx),%dl
  800f0c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f11:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f14:	89 55 10             	mov    %edx,0x10(%ebp)
  800f17:	85 c0                	test   %eax,%eax
  800f19:	75 dd                	jne    800ef8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1e:	c9                   	leave  
  800f1f:	c3                   	ret    

00800f20 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f35:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f38:	73 50                	jae    800f8a <memmove+0x6a>
  800f3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f40:	01 d0                	add    %edx,%eax
  800f42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f45:	76 43                	jbe    800f8a <memmove+0x6a>
		s += n;
  800f47:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f50:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f53:	eb 10                	jmp    800f65 <memmove+0x45>
			*--d = *--s;
  800f55:	ff 4d f8             	decl   -0x8(%ebp)
  800f58:	ff 4d fc             	decl   -0x4(%ebp)
  800f5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5e:	8a 10                	mov    (%eax),%dl
  800f60:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f63:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f65:	8b 45 10             	mov    0x10(%ebp),%eax
  800f68:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6e:	85 c0                	test   %eax,%eax
  800f70:	75 e3                	jne    800f55 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f72:	eb 23                	jmp    800f97 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f77:	8d 50 01             	lea    0x1(%eax),%edx
  800f7a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f80:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f83:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f86:	8a 12                	mov    (%edx),%dl
  800f88:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f90:	89 55 10             	mov    %edx,0x10(%ebp)
  800f93:	85 c0                	test   %eax,%eax
  800f95:	75 dd                	jne    800f74 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fab:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fae:	eb 2a                	jmp    800fda <memcmp+0x3e>
		if (*s1 != *s2)
  800fb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb3:	8a 10                	mov    (%eax),%dl
  800fb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	38 c2                	cmp    %al,%dl
  800fbc:	74 16                	je     800fd4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	0f b6 d0             	movzbl %al,%edx
  800fc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	0f b6 c0             	movzbl %al,%eax
  800fce:	29 c2                	sub    %eax,%edx
  800fd0:	89 d0                	mov    %edx,%eax
  800fd2:	eb 18                	jmp    800fec <memcmp+0x50>
		s1++, s2++;
  800fd4:	ff 45 fc             	incl   -0x4(%ebp)
  800fd7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fda:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe0:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe3:	85 c0                	test   %eax,%eax
  800fe5:	75 c9                	jne    800fb0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fe7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fec:	c9                   	leave  
  800fed:	c3                   	ret    

00800fee <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ff4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffa:	01 d0                	add    %edx,%eax
  800ffc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fff:	eb 15                	jmp    801016 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	8a 00                	mov    (%eax),%al
  801006:	0f b6 d0             	movzbl %al,%edx
  801009:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100c:	0f b6 c0             	movzbl %al,%eax
  80100f:	39 c2                	cmp    %eax,%edx
  801011:	74 0d                	je     801020 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801013:	ff 45 08             	incl   0x8(%ebp)
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80101c:	72 e3                	jb     801001 <memfind+0x13>
  80101e:	eb 01                	jmp    801021 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801020:	90                   	nop
	return (void *) s;
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801024:	c9                   	leave  
  801025:	c3                   	ret    

00801026 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80102c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801033:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80103a:	eb 03                	jmp    80103f <strtol+0x19>
		s++;
  80103c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	3c 20                	cmp    $0x20,%al
  801046:	74 f4                	je     80103c <strtol+0x16>
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	3c 09                	cmp    $0x9,%al
  80104f:	74 eb                	je     80103c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
  801054:	8a 00                	mov    (%eax),%al
  801056:	3c 2b                	cmp    $0x2b,%al
  801058:	75 05                	jne    80105f <strtol+0x39>
		s++;
  80105a:	ff 45 08             	incl   0x8(%ebp)
  80105d:	eb 13                	jmp    801072 <strtol+0x4c>
	else if (*s == '-')
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	8a 00                	mov    (%eax),%al
  801064:	3c 2d                	cmp    $0x2d,%al
  801066:	75 0a                	jne    801072 <strtol+0x4c>
		s++, neg = 1;
  801068:	ff 45 08             	incl   0x8(%ebp)
  80106b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801072:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801076:	74 06                	je     80107e <strtol+0x58>
  801078:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80107c:	75 20                	jne    80109e <strtol+0x78>
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 30                	cmp    $0x30,%al
  801085:	75 17                	jne    80109e <strtol+0x78>
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	40                   	inc    %eax
  80108b:	8a 00                	mov    (%eax),%al
  80108d:	3c 78                	cmp    $0x78,%al
  80108f:	75 0d                	jne    80109e <strtol+0x78>
		s += 2, base = 16;
  801091:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801095:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80109c:	eb 28                	jmp    8010c6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80109e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a2:	75 15                	jne    8010b9 <strtol+0x93>
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	3c 30                	cmp    $0x30,%al
  8010ab:	75 0c                	jne    8010b9 <strtol+0x93>
		s++, base = 8;
  8010ad:	ff 45 08             	incl   0x8(%ebp)
  8010b0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010b7:	eb 0d                	jmp    8010c6 <strtol+0xa0>
	else if (base == 0)
  8010b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010bd:	75 07                	jne    8010c6 <strtol+0xa0>
		base = 10;
  8010bf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	3c 2f                	cmp    $0x2f,%al
  8010cd:	7e 19                	jle    8010e8 <strtol+0xc2>
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	3c 39                	cmp    $0x39,%al
  8010d6:	7f 10                	jg     8010e8 <strtol+0xc2>
			dig = *s - '0';
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	0f be c0             	movsbl %al,%eax
  8010e0:	83 e8 30             	sub    $0x30,%eax
  8010e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e6:	eb 42                	jmp    80112a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	3c 60                	cmp    $0x60,%al
  8010ef:	7e 19                	jle    80110a <strtol+0xe4>
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	3c 7a                	cmp    $0x7a,%al
  8010f8:	7f 10                	jg     80110a <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	0f be c0             	movsbl %al,%eax
  801102:	83 e8 57             	sub    $0x57,%eax
  801105:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801108:	eb 20                	jmp    80112a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	3c 40                	cmp    $0x40,%al
  801111:	7e 39                	jle    80114c <strtol+0x126>
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	8a 00                	mov    (%eax),%al
  801118:	3c 5a                	cmp    $0x5a,%al
  80111a:	7f 30                	jg     80114c <strtol+0x126>
			dig = *s - 'A' + 10;
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	0f be c0             	movsbl %al,%eax
  801124:	83 e8 37             	sub    $0x37,%eax
  801127:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80112a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801130:	7d 19                	jge    80114b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801132:	ff 45 08             	incl   0x8(%ebp)
  801135:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801138:	0f af 45 10          	imul   0x10(%ebp),%eax
  80113c:	89 c2                	mov    %eax,%edx
  80113e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801141:	01 d0                	add    %edx,%eax
  801143:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801146:	e9 7b ff ff ff       	jmp    8010c6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80114b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80114c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801150:	74 08                	je     80115a <strtol+0x134>
		*endptr = (char *) s;
  801152:	8b 45 0c             	mov    0xc(%ebp),%eax
  801155:	8b 55 08             	mov    0x8(%ebp),%edx
  801158:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80115a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80115e:	74 07                	je     801167 <strtol+0x141>
  801160:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801163:	f7 d8                	neg    %eax
  801165:	eb 03                	jmp    80116a <strtol+0x144>
  801167:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    

0080116c <ltostr>:

void
ltostr(long value, char *str)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801172:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801179:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801180:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801184:	79 13                	jns    801199 <ltostr+0x2d>
	{
		neg = 1;
  801186:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80118d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801190:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801193:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801196:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801199:	8b 45 08             	mov    0x8(%ebp),%eax
  80119c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011a1:	99                   	cltd   
  8011a2:	f7 f9                	idiv   %ecx
  8011a4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011aa:	8d 50 01             	lea    0x1(%eax),%edx
  8011ad:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011b0:	89 c2                	mov    %eax,%edx
  8011b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b5:	01 d0                	add    %edx,%eax
  8011b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011ba:	83 c2 30             	add    $0x30,%edx
  8011bd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011c2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011c7:	f7 e9                	imul   %ecx
  8011c9:	c1 fa 02             	sar    $0x2,%edx
  8011cc:	89 c8                	mov    %ecx,%eax
  8011ce:	c1 f8 1f             	sar    $0x1f,%eax
  8011d1:	29 c2                	sub    %eax,%edx
  8011d3:	89 d0                	mov    %edx,%eax
  8011d5:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011db:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011e0:	f7 e9                	imul   %ecx
  8011e2:	c1 fa 02             	sar    $0x2,%edx
  8011e5:	89 c8                	mov    %ecx,%eax
  8011e7:	c1 f8 1f             	sar    $0x1f,%eax
  8011ea:	29 c2                	sub    %eax,%edx
  8011ec:	89 d0                	mov    %edx,%eax
  8011ee:	c1 e0 02             	shl    $0x2,%eax
  8011f1:	01 d0                	add    %edx,%eax
  8011f3:	01 c0                	add    %eax,%eax
  8011f5:	29 c1                	sub    %eax,%ecx
  8011f7:	89 ca                	mov    %ecx,%edx
  8011f9:	85 d2                	test   %edx,%edx
  8011fb:	75 9c                	jne    801199 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801204:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801207:	48                   	dec    %eax
  801208:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80120b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80120f:	74 3d                	je     80124e <ltostr+0xe2>
		start = 1 ;
  801211:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801218:	eb 34                	jmp    80124e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80121a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80121d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801220:	01 d0                	add    %edx,%eax
  801222:	8a 00                	mov    (%eax),%al
  801224:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801227:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	01 c2                	add    %eax,%edx
  80122f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801232:	8b 45 0c             	mov    0xc(%ebp),%eax
  801235:	01 c8                	add    %ecx,%eax
  801237:	8a 00                	mov    (%eax),%al
  801239:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80123b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80123e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801241:	01 c2                	add    %eax,%edx
  801243:	8a 45 eb             	mov    -0x15(%ebp),%al
  801246:	88 02                	mov    %al,(%edx)
		start++ ;
  801248:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80124b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80124e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801251:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801254:	7c c4                	jl     80121a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801256:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801259:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125c:	01 d0                	add    %edx,%eax
  80125e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801261:	90                   	nop
  801262:	c9                   	leave  
  801263:	c3                   	ret    

00801264 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
  801267:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80126a:	ff 75 08             	pushl  0x8(%ebp)
  80126d:	e8 54 fa ff ff       	call   800cc6 <strlen>
  801272:	83 c4 04             	add    $0x4,%esp
  801275:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801278:	ff 75 0c             	pushl  0xc(%ebp)
  80127b:	e8 46 fa ff ff       	call   800cc6 <strlen>
  801280:	83 c4 04             	add    $0x4,%esp
  801283:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801286:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80128d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801294:	eb 17                	jmp    8012ad <strcconcat+0x49>
		final[s] = str1[s] ;
  801296:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801299:	8b 45 10             	mov    0x10(%ebp),%eax
  80129c:	01 c2                	add    %eax,%edx
  80129e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	01 c8                	add    %ecx,%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012aa:	ff 45 fc             	incl   -0x4(%ebp)
  8012ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012b3:	7c e1                	jl     801296 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012c3:	eb 1f                	jmp    8012e4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c8:	8d 50 01             	lea    0x1(%eax),%edx
  8012cb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ce:	89 c2                	mov    %eax,%edx
  8012d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d3:	01 c2                	add    %eax,%edx
  8012d5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012db:	01 c8                	add    %ecx,%eax
  8012dd:	8a 00                	mov    (%eax),%al
  8012df:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012e1:	ff 45 f8             	incl   -0x8(%ebp)
  8012e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012ea:	7c d9                	jl     8012c5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f2:	01 d0                	add    %edx,%eax
  8012f4:	c6 00 00             	movb   $0x0,(%eax)
}
  8012f7:	90                   	nop
  8012f8:	c9                   	leave  
  8012f9:	c3                   	ret    

008012fa <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801300:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801306:	8b 45 14             	mov    0x14(%ebp),%eax
  801309:	8b 00                	mov    (%eax),%eax
  80130b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801312:	8b 45 10             	mov    0x10(%ebp),%eax
  801315:	01 d0                	add    %edx,%eax
  801317:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80131d:	eb 0c                	jmp    80132b <strsplit+0x31>
			*string++ = 0;
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8d 50 01             	lea    0x1(%eax),%edx
  801325:	89 55 08             	mov    %edx,0x8(%ebp)
  801328:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80132b:	8b 45 08             	mov    0x8(%ebp),%eax
  80132e:	8a 00                	mov    (%eax),%al
  801330:	84 c0                	test   %al,%al
  801332:	74 18                	je     80134c <strsplit+0x52>
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	8a 00                	mov    (%eax),%al
  801339:	0f be c0             	movsbl %al,%eax
  80133c:	50                   	push   %eax
  80133d:	ff 75 0c             	pushl  0xc(%ebp)
  801340:	e8 13 fb ff ff       	call   800e58 <strchr>
  801345:	83 c4 08             	add    $0x8,%esp
  801348:	85 c0                	test   %eax,%eax
  80134a:	75 d3                	jne    80131f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	8a 00                	mov    (%eax),%al
  801351:	84 c0                	test   %al,%al
  801353:	74 5a                	je     8013af <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801355:	8b 45 14             	mov    0x14(%ebp),%eax
  801358:	8b 00                	mov    (%eax),%eax
  80135a:	83 f8 0f             	cmp    $0xf,%eax
  80135d:	75 07                	jne    801366 <strsplit+0x6c>
		{
			return 0;
  80135f:	b8 00 00 00 00       	mov    $0x0,%eax
  801364:	eb 66                	jmp    8013cc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801366:	8b 45 14             	mov    0x14(%ebp),%eax
  801369:	8b 00                	mov    (%eax),%eax
  80136b:	8d 48 01             	lea    0x1(%eax),%ecx
  80136e:	8b 55 14             	mov    0x14(%ebp),%edx
  801371:	89 0a                	mov    %ecx,(%edx)
  801373:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80137a:	8b 45 10             	mov    0x10(%ebp),%eax
  80137d:	01 c2                	add    %eax,%edx
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801384:	eb 03                	jmp    801389 <strsplit+0x8f>
			string++;
  801386:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	8a 00                	mov    (%eax),%al
  80138e:	84 c0                	test   %al,%al
  801390:	74 8b                	je     80131d <strsplit+0x23>
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	8a 00                	mov    (%eax),%al
  801397:	0f be c0             	movsbl %al,%eax
  80139a:	50                   	push   %eax
  80139b:	ff 75 0c             	pushl  0xc(%ebp)
  80139e:	e8 b5 fa ff ff       	call   800e58 <strchr>
  8013a3:	83 c4 08             	add    $0x8,%esp
  8013a6:	85 c0                	test   %eax,%eax
  8013a8:	74 dc                	je     801386 <strsplit+0x8c>
			string++;
	}
  8013aa:	e9 6e ff ff ff       	jmp    80131d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013af:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b3:	8b 00                	mov    (%eax),%eax
  8013b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bf:	01 d0                	add    %edx,%eax
  8013c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013c7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013cc:	c9                   	leave  
  8013cd:	c3                   	ret    

008013ce <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
  8013d1:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013d4:	a1 04 40 80 00       	mov    0x804004,%eax
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	74 1f                	je     8013fc <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013dd:	e8 1d 00 00 00       	call   8013ff <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013e2:	83 ec 0c             	sub    $0xc,%esp
  8013e5:	68 d0 38 80 00       	push   $0x8038d0
  8013ea:	e8 55 f2 ff ff       	call   800644 <cprintf>
  8013ef:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013f2:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8013f9:	00 00 00 
	}
}
  8013fc:	90                   	nop
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    

008013ff <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801405:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80140c:	00 00 00 
  80140f:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801416:	00 00 00 
  801419:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801420:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801423:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80142a:	00 00 00 
  80142d:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801434:	00 00 00 
  801437:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80143e:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801441:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801448:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  80144b:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801455:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80145a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80145f:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  801464:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  80146b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80146e:	a1 20 41 80 00       	mov    0x804120,%eax
  801473:	0f af c2             	imul   %edx,%eax
  801476:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801479:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801480:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801483:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801486:	01 d0                	add    %edx,%eax
  801488:	48                   	dec    %eax
  801489:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80148c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80148f:	ba 00 00 00 00       	mov    $0x0,%edx
  801494:	f7 75 e8             	divl   -0x18(%ebp)
  801497:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80149a:	29 d0                	sub    %edx,%eax
  80149c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  80149f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014a2:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  8014a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014ac:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8014b2:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8014b8:	83 ec 04             	sub    $0x4,%esp
  8014bb:	6a 06                	push   $0x6
  8014bd:	50                   	push   %eax
  8014be:	52                   	push   %edx
  8014bf:	e8 a1 05 00 00       	call   801a65 <sys_allocate_chunk>
  8014c4:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014c7:	a1 20 41 80 00       	mov    0x804120,%eax
  8014cc:	83 ec 0c             	sub    $0xc,%esp
  8014cf:	50                   	push   %eax
  8014d0:	e8 16 0c 00 00       	call   8020eb <initialize_MemBlocksList>
  8014d5:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  8014d8:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8014dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  8014e0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8014e4:	75 14                	jne    8014fa <initialize_dyn_block_system+0xfb>
  8014e6:	83 ec 04             	sub    $0x4,%esp
  8014e9:	68 f5 38 80 00       	push   $0x8038f5
  8014ee:	6a 2d                	push   $0x2d
  8014f0:	68 13 39 80 00       	push   $0x803913
  8014f5:	e8 96 ee ff ff       	call   800390 <_panic>
  8014fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014fd:	8b 00                	mov    (%eax),%eax
  8014ff:	85 c0                	test   %eax,%eax
  801501:	74 10                	je     801513 <initialize_dyn_block_system+0x114>
  801503:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801506:	8b 00                	mov    (%eax),%eax
  801508:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80150b:	8b 52 04             	mov    0x4(%edx),%edx
  80150e:	89 50 04             	mov    %edx,0x4(%eax)
  801511:	eb 0b                	jmp    80151e <initialize_dyn_block_system+0x11f>
  801513:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801516:	8b 40 04             	mov    0x4(%eax),%eax
  801519:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80151e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801521:	8b 40 04             	mov    0x4(%eax),%eax
  801524:	85 c0                	test   %eax,%eax
  801526:	74 0f                	je     801537 <initialize_dyn_block_system+0x138>
  801528:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80152b:	8b 40 04             	mov    0x4(%eax),%eax
  80152e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801531:	8b 12                	mov    (%edx),%edx
  801533:	89 10                	mov    %edx,(%eax)
  801535:	eb 0a                	jmp    801541 <initialize_dyn_block_system+0x142>
  801537:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80153a:	8b 00                	mov    (%eax),%eax
  80153c:	a3 48 41 80 00       	mov    %eax,0x804148
  801541:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801544:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80154a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80154d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801554:	a1 54 41 80 00       	mov    0x804154,%eax
  801559:	48                   	dec    %eax
  80155a:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  80155f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801562:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801569:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80156c:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801573:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801577:	75 14                	jne    80158d <initialize_dyn_block_system+0x18e>
  801579:	83 ec 04             	sub    $0x4,%esp
  80157c:	68 20 39 80 00       	push   $0x803920
  801581:	6a 30                	push   $0x30
  801583:	68 13 39 80 00       	push   $0x803913
  801588:	e8 03 ee ff ff       	call   800390 <_panic>
  80158d:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  801593:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801596:	89 50 04             	mov    %edx,0x4(%eax)
  801599:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80159c:	8b 40 04             	mov    0x4(%eax),%eax
  80159f:	85 c0                	test   %eax,%eax
  8015a1:	74 0c                	je     8015af <initialize_dyn_block_system+0x1b0>
  8015a3:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8015a8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8015ab:	89 10                	mov    %edx,(%eax)
  8015ad:	eb 08                	jmp    8015b7 <initialize_dyn_block_system+0x1b8>
  8015af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015b2:	a3 38 41 80 00       	mov    %eax,0x804138
  8015b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015ba:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8015bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015c8:	a1 44 41 80 00       	mov    0x804144,%eax
  8015cd:	40                   	inc    %eax
  8015ce:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8015d3:	90                   	nop
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    

008015d6 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015dc:	e8 ed fd ff ff       	call   8013ce <InitializeUHeap>
	if (size == 0) return NULL ;
  8015e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015e5:	75 07                	jne    8015ee <malloc+0x18>
  8015e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ec:	eb 67                	jmp    801655 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  8015ee:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8015f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015fb:	01 d0                	add    %edx,%eax
  8015fd:	48                   	dec    %eax
  8015fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801601:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801604:	ba 00 00 00 00       	mov    $0x0,%edx
  801609:	f7 75 f4             	divl   -0xc(%ebp)
  80160c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160f:	29 d0                	sub    %edx,%eax
  801611:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801614:	e8 1a 08 00 00       	call   801e33 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801619:	85 c0                	test   %eax,%eax
  80161b:	74 33                	je     801650 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  80161d:	83 ec 0c             	sub    $0xc,%esp
  801620:	ff 75 08             	pushl  0x8(%ebp)
  801623:	e8 0c 0e 00 00       	call   802434 <alloc_block_FF>
  801628:	83 c4 10             	add    $0x10,%esp
  80162b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  80162e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801632:	74 1c                	je     801650 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801634:	83 ec 0c             	sub    $0xc,%esp
  801637:	ff 75 ec             	pushl  -0x14(%ebp)
  80163a:	e8 07 0c 00 00       	call   802246 <insert_sorted_allocList>
  80163f:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801642:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801645:	8b 40 08             	mov    0x8(%eax),%eax
  801648:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  80164b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80164e:	eb 05                	jmp    801655 <malloc+0x7f>
		}
	}
	return NULL;
  801650:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801655:	c9                   	leave  
  801656:	c3                   	ret    

00801657 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801663:	83 ec 08             	sub    $0x8,%esp
  801666:	ff 75 f4             	pushl  -0xc(%ebp)
  801669:	68 40 40 80 00       	push   $0x804040
  80166e:	e8 5b 0b 00 00       	call   8021ce <find_block>
  801673:	83 c4 10             	add    $0x10,%esp
  801676:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801679:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167c:	8b 40 0c             	mov    0xc(%eax),%eax
  80167f:	83 ec 08             	sub    $0x8,%esp
  801682:	50                   	push   %eax
  801683:	ff 75 f4             	pushl  -0xc(%ebp)
  801686:	e8 a2 03 00 00       	call   801a2d <sys_free_user_mem>
  80168b:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  80168e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801692:	75 14                	jne    8016a8 <free+0x51>
  801694:	83 ec 04             	sub    $0x4,%esp
  801697:	68 f5 38 80 00       	push   $0x8038f5
  80169c:	6a 76                	push   $0x76
  80169e:	68 13 39 80 00       	push   $0x803913
  8016a3:	e8 e8 ec ff ff       	call   800390 <_panic>
  8016a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ab:	8b 00                	mov    (%eax),%eax
  8016ad:	85 c0                	test   %eax,%eax
  8016af:	74 10                	je     8016c1 <free+0x6a>
  8016b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b4:	8b 00                	mov    (%eax),%eax
  8016b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016b9:	8b 52 04             	mov    0x4(%edx),%edx
  8016bc:	89 50 04             	mov    %edx,0x4(%eax)
  8016bf:	eb 0b                	jmp    8016cc <free+0x75>
  8016c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c4:	8b 40 04             	mov    0x4(%eax),%eax
  8016c7:	a3 44 40 80 00       	mov    %eax,0x804044
  8016cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016cf:	8b 40 04             	mov    0x4(%eax),%eax
  8016d2:	85 c0                	test   %eax,%eax
  8016d4:	74 0f                	je     8016e5 <free+0x8e>
  8016d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d9:	8b 40 04             	mov    0x4(%eax),%eax
  8016dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016df:	8b 12                	mov    (%edx),%edx
  8016e1:	89 10                	mov    %edx,(%eax)
  8016e3:	eb 0a                	jmp    8016ef <free+0x98>
  8016e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e8:	8b 00                	mov    (%eax),%eax
  8016ea:	a3 40 40 80 00       	mov    %eax,0x804040
  8016ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801702:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801707:	48                   	dec    %eax
  801708:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  80170d:	83 ec 0c             	sub    $0xc,%esp
  801710:	ff 75 f0             	pushl  -0x10(%ebp)
  801713:	e8 0b 14 00 00       	call   802b23 <insert_sorted_with_merge_freeList>
  801718:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80171b:	90                   	nop
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
  801721:	83 ec 28             	sub    $0x28,%esp
  801724:	8b 45 10             	mov    0x10(%ebp),%eax
  801727:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80172a:	e8 9f fc ff ff       	call   8013ce <InitializeUHeap>
	if (size == 0) return NULL ;
  80172f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801733:	75 0a                	jne    80173f <smalloc+0x21>
  801735:	b8 00 00 00 00       	mov    $0x0,%eax
  80173a:	e9 8d 00 00 00       	jmp    8017cc <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  80173f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801746:	8b 55 0c             	mov    0xc(%ebp),%edx
  801749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174c:	01 d0                	add    %edx,%eax
  80174e:	48                   	dec    %eax
  80174f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801752:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801755:	ba 00 00 00 00       	mov    $0x0,%edx
  80175a:	f7 75 f4             	divl   -0xc(%ebp)
  80175d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801760:	29 d0                	sub    %edx,%eax
  801762:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801765:	e8 c9 06 00 00       	call   801e33 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80176a:	85 c0                	test   %eax,%eax
  80176c:	74 59                	je     8017c7 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  80176e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801775:	83 ec 0c             	sub    $0xc,%esp
  801778:	ff 75 0c             	pushl  0xc(%ebp)
  80177b:	e8 b4 0c 00 00       	call   802434 <alloc_block_FF>
  801780:	83 c4 10             	add    $0x10,%esp
  801783:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801786:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80178a:	75 07                	jne    801793 <smalloc+0x75>
			{
				return NULL;
  80178c:	b8 00 00 00 00       	mov    $0x0,%eax
  801791:	eb 39                	jmp    8017cc <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801793:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801796:	8b 40 08             	mov    0x8(%eax),%eax
  801799:	89 c2                	mov    %eax,%edx
  80179b:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80179f:	52                   	push   %edx
  8017a0:	50                   	push   %eax
  8017a1:	ff 75 0c             	pushl  0xc(%ebp)
  8017a4:	ff 75 08             	pushl  0x8(%ebp)
  8017a7:	e8 0c 04 00 00       	call   801bb8 <sys_createSharedObject>
  8017ac:	83 c4 10             	add    $0x10,%esp
  8017af:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  8017b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8017b6:	78 08                	js     8017c0 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  8017b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017bb:	8b 40 08             	mov    0x8(%eax),%eax
  8017be:	eb 0c                	jmp    8017cc <smalloc+0xae>
				}
				else
				{
					return NULL;
  8017c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c5:	eb 05                	jmp    8017cc <smalloc+0xae>
				}
			}

		}
		return NULL;
  8017c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    

008017ce <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017d4:	e8 f5 fb ff ff       	call   8013ce <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017d9:	83 ec 08             	sub    $0x8,%esp
  8017dc:	ff 75 0c             	pushl  0xc(%ebp)
  8017df:	ff 75 08             	pushl  0x8(%ebp)
  8017e2:	e8 fb 03 00 00       	call   801be2 <sys_getSizeOfSharedObject>
  8017e7:	83 c4 10             	add    $0x10,%esp
  8017ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  8017ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017f1:	75 07                	jne    8017fa <sget+0x2c>
	{
		return NULL;
  8017f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f8:	eb 64                	jmp    80185e <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8017fa:	e8 34 06 00 00       	call   801e33 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017ff:	85 c0                	test   %eax,%eax
  801801:	74 56                	je     801859 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801803:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  80180a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80180d:	83 ec 0c             	sub    $0xc,%esp
  801810:	50                   	push   %eax
  801811:	e8 1e 0c 00 00       	call   802434 <alloc_block_FF>
  801816:	83 c4 10             	add    $0x10,%esp
  801819:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  80181c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801820:	75 07                	jne    801829 <sget+0x5b>
		{
		return NULL;
  801822:	b8 00 00 00 00       	mov    $0x0,%eax
  801827:	eb 35                	jmp    80185e <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801829:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182c:	8b 40 08             	mov    0x8(%eax),%eax
  80182f:	83 ec 04             	sub    $0x4,%esp
  801832:	50                   	push   %eax
  801833:	ff 75 0c             	pushl  0xc(%ebp)
  801836:	ff 75 08             	pushl  0x8(%ebp)
  801839:	e8 c1 03 00 00       	call   801bff <sys_getSharedObject>
  80183e:	83 c4 10             	add    $0x10,%esp
  801841:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801844:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801848:	78 08                	js     801852 <sget+0x84>
			{
				return (void*)v1->sva;
  80184a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80184d:	8b 40 08             	mov    0x8(%eax),%eax
  801850:	eb 0c                	jmp    80185e <sget+0x90>
			}
			else
			{
				return NULL;
  801852:	b8 00 00 00 00       	mov    $0x0,%eax
  801857:	eb 05                	jmp    80185e <sget+0x90>
			}
		}
	}
  return NULL;
  801859:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801866:	e8 63 fb ff ff       	call   8013ce <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80186b:	83 ec 04             	sub    $0x4,%esp
  80186e:	68 44 39 80 00       	push   $0x803944
  801873:	68 0e 01 00 00       	push   $0x10e
  801878:	68 13 39 80 00       	push   $0x803913
  80187d:	e8 0e eb ff ff       	call   800390 <_panic>

00801882 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801888:	83 ec 04             	sub    $0x4,%esp
  80188b:	68 6c 39 80 00       	push   $0x80396c
  801890:	68 22 01 00 00       	push   $0x122
  801895:	68 13 39 80 00       	push   $0x803913
  80189a:	e8 f1 ea ff ff       	call   800390 <_panic>

0080189f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
  8018a2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018a5:	83 ec 04             	sub    $0x4,%esp
  8018a8:	68 90 39 80 00       	push   $0x803990
  8018ad:	68 2d 01 00 00       	push   $0x12d
  8018b2:	68 13 39 80 00       	push   $0x803913
  8018b7:	e8 d4 ea ff ff       	call   800390 <_panic>

008018bc <shrink>:

}
void shrink(uint32 newSize)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018c2:	83 ec 04             	sub    $0x4,%esp
  8018c5:	68 90 39 80 00       	push   $0x803990
  8018ca:	68 32 01 00 00       	push   $0x132
  8018cf:	68 13 39 80 00       	push   $0x803913
  8018d4:	e8 b7 ea ff ff       	call   800390 <_panic>

008018d9 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
  8018dc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018df:	83 ec 04             	sub    $0x4,%esp
  8018e2:	68 90 39 80 00       	push   $0x803990
  8018e7:	68 37 01 00 00       	push   $0x137
  8018ec:	68 13 39 80 00       	push   $0x803913
  8018f1:	e8 9a ea ff ff       	call   800390 <_panic>

008018f6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
  8018f9:	57                   	push   %edi
  8018fa:	56                   	push   %esi
  8018fb:	53                   	push   %ebx
  8018fc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801902:	8b 55 0c             	mov    0xc(%ebp),%edx
  801905:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801908:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80190b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80190e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801911:	cd 30                	int    $0x30
  801913:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801916:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801919:	83 c4 10             	add    $0x10,%esp
  80191c:	5b                   	pop    %ebx
  80191d:	5e                   	pop    %esi
  80191e:	5f                   	pop    %edi
  80191f:	5d                   	pop    %ebp
  801920:	c3                   	ret    

00801921 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
  801924:	83 ec 04             	sub    $0x4,%esp
  801927:	8b 45 10             	mov    0x10(%ebp),%eax
  80192a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80192d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801931:	8b 45 08             	mov    0x8(%ebp),%eax
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	52                   	push   %edx
  801939:	ff 75 0c             	pushl  0xc(%ebp)
  80193c:	50                   	push   %eax
  80193d:	6a 00                	push   $0x0
  80193f:	e8 b2 ff ff ff       	call   8018f6 <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
}
  801947:	90                   	nop
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_cgetc>:

int
sys_cgetc(void)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 01                	push   $0x1
  801959:	e8 98 ff ff ff       	call   8018f6 <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801966:	8b 55 0c             	mov    0xc(%ebp),%edx
  801969:	8b 45 08             	mov    0x8(%ebp),%eax
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	52                   	push   %edx
  801973:	50                   	push   %eax
  801974:	6a 05                	push   $0x5
  801976:	e8 7b ff ff ff       	call   8018f6 <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	56                   	push   %esi
  801984:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801985:	8b 75 18             	mov    0x18(%ebp),%esi
  801988:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80198b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80198e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	56                   	push   %esi
  801995:	53                   	push   %ebx
  801996:	51                   	push   %ecx
  801997:	52                   	push   %edx
  801998:	50                   	push   %eax
  801999:	6a 06                	push   $0x6
  80199b:	e8 56 ff ff ff       	call   8018f6 <syscall>
  8019a0:	83 c4 18             	add    $0x18,%esp
}
  8019a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019a6:	5b                   	pop    %ebx
  8019a7:	5e                   	pop    %esi
  8019a8:	5d                   	pop    %ebp
  8019a9:	c3                   	ret    

008019aa <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	52                   	push   %edx
  8019ba:	50                   	push   %eax
  8019bb:	6a 07                	push   $0x7
  8019bd:	e8 34 ff ff ff       	call   8018f6 <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
}
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	ff 75 0c             	pushl  0xc(%ebp)
  8019d3:	ff 75 08             	pushl  0x8(%ebp)
  8019d6:	6a 08                	push   $0x8
  8019d8:	e8 19 ff ff ff       	call   8018f6 <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 09                	push   $0x9
  8019f1:	e8 00 ff ff ff       	call   8018f6 <syscall>
  8019f6:	83 c4 18             	add    $0x18,%esp
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 0a                	push   $0xa
  801a0a:	e8 e7 fe ff ff       	call   8018f6 <syscall>
  801a0f:	83 c4 18             	add    $0x18,%esp
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 0b                	push   $0xb
  801a23:	e8 ce fe ff ff       	call   8018f6 <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
}
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    

00801a2d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	ff 75 0c             	pushl  0xc(%ebp)
  801a39:	ff 75 08             	pushl  0x8(%ebp)
  801a3c:	6a 0f                	push   $0xf
  801a3e:	e8 b3 fe ff ff       	call   8018f6 <syscall>
  801a43:	83 c4 18             	add    $0x18,%esp
	return;
  801a46:	90                   	nop
}
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	ff 75 0c             	pushl  0xc(%ebp)
  801a55:	ff 75 08             	pushl  0x8(%ebp)
  801a58:	6a 10                	push   $0x10
  801a5a:	e8 97 fe ff ff       	call   8018f6 <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a62:	90                   	nop
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	ff 75 10             	pushl  0x10(%ebp)
  801a6f:	ff 75 0c             	pushl  0xc(%ebp)
  801a72:	ff 75 08             	pushl  0x8(%ebp)
  801a75:	6a 11                	push   $0x11
  801a77:	e8 7a fe ff ff       	call   8018f6 <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a7f:	90                   	nop
}
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    

00801a82 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 0c                	push   $0xc
  801a91:	e8 60 fe ff ff       	call   8018f6 <syscall>
  801a96:	83 c4 18             	add    $0x18,%esp
}
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    

00801a9b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	ff 75 08             	pushl  0x8(%ebp)
  801aa9:	6a 0d                	push   $0xd
  801aab:	e8 46 fe ff ff       	call   8018f6 <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 0e                	push   $0xe
  801ac4:	e8 2d fe ff ff       	call   8018f6 <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
}
  801acc:	90                   	nop
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 13                	push   $0x13
  801ade:	e8 13 fe ff ff       	call   8018f6 <syscall>
  801ae3:	83 c4 18             	add    $0x18,%esp
}
  801ae6:	90                   	nop
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 14                	push   $0x14
  801af8:	e8 f9 fd ff ff       	call   8018f6 <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	90                   	nop
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	83 ec 04             	sub    $0x4,%esp
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b0f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	50                   	push   %eax
  801b1c:	6a 15                	push   $0x15
  801b1e:	e8 d3 fd ff ff       	call   8018f6 <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
}
  801b26:	90                   	nop
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 16                	push   $0x16
  801b38:	e8 b9 fd ff ff       	call   8018f6 <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
}
  801b40:	90                   	nop
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	ff 75 0c             	pushl  0xc(%ebp)
  801b52:	50                   	push   %eax
  801b53:	6a 17                	push   $0x17
  801b55:	e8 9c fd ff ff       	call   8018f6 <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b65:	8b 45 08             	mov    0x8(%ebp),%eax
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	52                   	push   %edx
  801b6f:	50                   	push   %eax
  801b70:	6a 1a                	push   $0x1a
  801b72:	e8 7f fd ff ff       	call   8018f6 <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	52                   	push   %edx
  801b8c:	50                   	push   %eax
  801b8d:	6a 18                	push   $0x18
  801b8f:	e8 62 fd ff ff       	call   8018f6 <syscall>
  801b94:	83 c4 18             	add    $0x18,%esp
}
  801b97:	90                   	nop
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	52                   	push   %edx
  801baa:	50                   	push   %eax
  801bab:	6a 19                	push   $0x19
  801bad:	e8 44 fd ff ff       	call   8018f6 <syscall>
  801bb2:	83 c4 18             	add    $0x18,%esp
}
  801bb5:	90                   	nop
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
  801bbb:	83 ec 04             	sub    $0x4,%esp
  801bbe:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bc4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bc7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bce:	6a 00                	push   $0x0
  801bd0:	51                   	push   %ecx
  801bd1:	52                   	push   %edx
  801bd2:	ff 75 0c             	pushl  0xc(%ebp)
  801bd5:	50                   	push   %eax
  801bd6:	6a 1b                	push   $0x1b
  801bd8:	e8 19 fd ff ff       	call   8018f6 <syscall>
  801bdd:	83 c4 18             	add    $0x18,%esp
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801be5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	52                   	push   %edx
  801bf2:	50                   	push   %eax
  801bf3:	6a 1c                	push   $0x1c
  801bf5:	e8 fc fc ff ff       	call   8018f6 <syscall>
  801bfa:	83 c4 18             	add    $0x18,%esp
}
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c02:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c08:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	51                   	push   %ecx
  801c10:	52                   	push   %edx
  801c11:	50                   	push   %eax
  801c12:	6a 1d                	push   $0x1d
  801c14:	e8 dd fc ff ff       	call   8018f6 <syscall>
  801c19:	83 c4 18             	add    $0x18,%esp
}
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    

00801c1e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	52                   	push   %edx
  801c2e:	50                   	push   %eax
  801c2f:	6a 1e                	push   $0x1e
  801c31:	e8 c0 fc ff ff       	call   8018f6 <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 1f                	push   $0x1f
  801c4a:	e8 a7 fc ff ff       	call   8018f6 <syscall>
  801c4f:	83 c4 18             	add    $0x18,%esp
}
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c57:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5a:	6a 00                	push   $0x0
  801c5c:	ff 75 14             	pushl  0x14(%ebp)
  801c5f:	ff 75 10             	pushl  0x10(%ebp)
  801c62:	ff 75 0c             	pushl  0xc(%ebp)
  801c65:	50                   	push   %eax
  801c66:	6a 20                	push   $0x20
  801c68:	e8 89 fc ff ff       	call   8018f6 <syscall>
  801c6d:	83 c4 18             	add    $0x18,%esp
}
  801c70:	c9                   	leave  
  801c71:	c3                   	ret    

00801c72 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c72:	55                   	push   %ebp
  801c73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c75:	8b 45 08             	mov    0x8(%ebp),%eax
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	50                   	push   %eax
  801c81:	6a 21                	push   $0x21
  801c83:	e8 6e fc ff ff       	call   8018f6 <syscall>
  801c88:	83 c4 18             	add    $0x18,%esp
}
  801c8b:	90                   	nop
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c91:	8b 45 08             	mov    0x8(%ebp),%eax
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	50                   	push   %eax
  801c9d:	6a 22                	push   $0x22
  801c9f:	e8 52 fc ff ff       	call   8018f6 <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 02                	push   $0x2
  801cb8:	e8 39 fc ff ff       	call   8018f6 <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 03                	push   $0x3
  801cd1:	e8 20 fc ff ff       	call   8018f6 <syscall>
  801cd6:	83 c4 18             	add    $0x18,%esp
}
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 04                	push   $0x4
  801cea:	e8 07 fc ff ff       	call   8018f6 <syscall>
  801cef:	83 c4 18             	add    $0x18,%esp
}
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    

00801cf4 <sys_exit_env>:


void sys_exit_env(void)
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 23                	push   $0x23
  801d03:	e8 ee fb ff ff       	call   8018f6 <syscall>
  801d08:	83 c4 18             	add    $0x18,%esp
}
  801d0b:	90                   	nop
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
  801d11:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d14:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d17:	8d 50 04             	lea    0x4(%eax),%edx
  801d1a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	52                   	push   %edx
  801d24:	50                   	push   %eax
  801d25:	6a 24                	push   $0x24
  801d27:	e8 ca fb ff ff       	call   8018f6 <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
	return result;
  801d2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d32:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d35:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d38:	89 01                	mov    %eax,(%ecx)
  801d3a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d40:	c9                   	leave  
  801d41:	c2 04 00             	ret    $0x4

00801d44 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	ff 75 10             	pushl  0x10(%ebp)
  801d4e:	ff 75 0c             	pushl  0xc(%ebp)
  801d51:	ff 75 08             	pushl  0x8(%ebp)
  801d54:	6a 12                	push   $0x12
  801d56:	e8 9b fb ff ff       	call   8018f6 <syscall>
  801d5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5e:	90                   	nop
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 25                	push   $0x25
  801d70:	e8 81 fb ff ff       	call   8018f6 <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
  801d7d:	83 ec 04             	sub    $0x4,%esp
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d86:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	50                   	push   %eax
  801d93:	6a 26                	push   $0x26
  801d95:	e8 5c fb ff ff       	call   8018f6 <syscall>
  801d9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9d:	90                   	nop
}
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <rsttst>:
void rsttst()
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 28                	push   $0x28
  801daf:	e8 42 fb ff ff       	call   8018f6 <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
	return ;
  801db7:	90                   	nop
}
  801db8:	c9                   	leave  
  801db9:	c3                   	ret    

00801dba <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	83 ec 04             	sub    $0x4,%esp
  801dc0:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dc6:	8b 55 18             	mov    0x18(%ebp),%edx
  801dc9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dcd:	52                   	push   %edx
  801dce:	50                   	push   %eax
  801dcf:	ff 75 10             	pushl  0x10(%ebp)
  801dd2:	ff 75 0c             	pushl  0xc(%ebp)
  801dd5:	ff 75 08             	pushl  0x8(%ebp)
  801dd8:	6a 27                	push   $0x27
  801dda:	e8 17 fb ff ff       	call   8018f6 <syscall>
  801ddf:	83 c4 18             	add    $0x18,%esp
	return ;
  801de2:	90                   	nop
}
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <chktst>:
void chktst(uint32 n)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	ff 75 08             	pushl  0x8(%ebp)
  801df3:	6a 29                	push   $0x29
  801df5:	e8 fc fa ff ff       	call   8018f6 <syscall>
  801dfa:	83 c4 18             	add    $0x18,%esp
	return ;
  801dfd:	90                   	nop
}
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <inctst>:

void inctst()
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 2a                	push   $0x2a
  801e0f:	e8 e2 fa ff ff       	call   8018f6 <syscall>
  801e14:	83 c4 18             	add    $0x18,%esp
	return ;
  801e17:	90                   	nop
}
  801e18:	c9                   	leave  
  801e19:	c3                   	ret    

00801e1a <gettst>:
uint32 gettst()
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 2b                	push   $0x2b
  801e29:	e8 c8 fa ff ff       	call   8018f6 <syscall>
  801e2e:	83 c4 18             	add    $0x18,%esp
}
  801e31:	c9                   	leave  
  801e32:	c3                   	ret    

00801e33 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
  801e36:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 2c                	push   $0x2c
  801e45:	e8 ac fa ff ff       	call   8018f6 <syscall>
  801e4a:	83 c4 18             	add    $0x18,%esp
  801e4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e50:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e54:	75 07                	jne    801e5d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e56:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5b:	eb 05                	jmp    801e62 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    

00801e64 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
  801e67:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 2c                	push   $0x2c
  801e76:	e8 7b fa ff ff       	call   8018f6 <syscall>
  801e7b:	83 c4 18             	add    $0x18,%esp
  801e7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e81:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e85:	75 07                	jne    801e8e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e87:	b8 01 00 00 00       	mov    $0x1,%eax
  801e8c:	eb 05                	jmp    801e93 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 2c                	push   $0x2c
  801ea7:	e8 4a fa ff ff       	call   8018f6 <syscall>
  801eac:	83 c4 18             	add    $0x18,%esp
  801eaf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801eb2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801eb6:	75 07                	jne    801ebf <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801eb8:	b8 01 00 00 00       	mov    $0x1,%eax
  801ebd:	eb 05                	jmp    801ec4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ebf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 2c                	push   $0x2c
  801ed8:	e8 19 fa ff ff       	call   8018f6 <syscall>
  801edd:	83 c4 18             	add    $0x18,%esp
  801ee0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ee3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ee7:	75 07                	jne    801ef0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ee9:	b8 01 00 00 00       	mov    $0x1,%eax
  801eee:	eb 05                	jmp    801ef5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ef0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef5:	c9                   	leave  
  801ef6:	c3                   	ret    

00801ef7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	ff 75 08             	pushl  0x8(%ebp)
  801f05:	6a 2d                	push   $0x2d
  801f07:	e8 ea f9 ff ff       	call   8018f6 <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f0f:	90                   	nop
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
  801f15:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f16:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f19:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f22:	6a 00                	push   $0x0
  801f24:	53                   	push   %ebx
  801f25:	51                   	push   %ecx
  801f26:	52                   	push   %edx
  801f27:	50                   	push   %eax
  801f28:	6a 2e                	push   $0x2e
  801f2a:	e8 c7 f9 ff ff       	call   8018f6 <syscall>
  801f2f:	83 c4 18             	add    $0x18,%esp
}
  801f32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f35:	c9                   	leave  
  801f36:	c3                   	ret    

00801f37 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f37:	55                   	push   %ebp
  801f38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	52                   	push   %edx
  801f47:	50                   	push   %eax
  801f48:	6a 2f                	push   $0x2f
  801f4a:	e8 a7 f9 ff ff       	call   8018f6 <syscall>
  801f4f:	83 c4 18             	add    $0x18,%esp
}
  801f52:	c9                   	leave  
  801f53:	c3                   	ret    

00801f54 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f54:	55                   	push   %ebp
  801f55:	89 e5                	mov    %esp,%ebp
  801f57:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f5a:	83 ec 0c             	sub    $0xc,%esp
  801f5d:	68 a0 39 80 00       	push   $0x8039a0
  801f62:	e8 dd e6 ff ff       	call   800644 <cprintf>
  801f67:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f6a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f71:	83 ec 0c             	sub    $0xc,%esp
  801f74:	68 cc 39 80 00       	push   $0x8039cc
  801f79:	e8 c6 e6 ff ff       	call   800644 <cprintf>
  801f7e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f81:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f85:	a1 38 41 80 00       	mov    0x804138,%eax
  801f8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f8d:	eb 56                	jmp    801fe5 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f8f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f93:	74 1c                	je     801fb1 <print_mem_block_lists+0x5d>
  801f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f98:	8b 50 08             	mov    0x8(%eax),%edx
  801f9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9e:	8b 48 08             	mov    0x8(%eax),%ecx
  801fa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa4:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa7:	01 c8                	add    %ecx,%eax
  801fa9:	39 c2                	cmp    %eax,%edx
  801fab:	73 04                	jae    801fb1 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fad:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb4:	8b 50 08             	mov    0x8(%eax),%edx
  801fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fba:	8b 40 0c             	mov    0xc(%eax),%eax
  801fbd:	01 c2                	add    %eax,%edx
  801fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc2:	8b 40 08             	mov    0x8(%eax),%eax
  801fc5:	83 ec 04             	sub    $0x4,%esp
  801fc8:	52                   	push   %edx
  801fc9:	50                   	push   %eax
  801fca:	68 e1 39 80 00       	push   $0x8039e1
  801fcf:	e8 70 e6 ff ff       	call   800644 <cprintf>
  801fd4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fda:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fdd:	a1 40 41 80 00       	mov    0x804140,%eax
  801fe2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fe5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe9:	74 07                	je     801ff2 <print_mem_block_lists+0x9e>
  801feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fee:	8b 00                	mov    (%eax),%eax
  801ff0:	eb 05                	jmp    801ff7 <print_mem_block_lists+0xa3>
  801ff2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff7:	a3 40 41 80 00       	mov    %eax,0x804140
  801ffc:	a1 40 41 80 00       	mov    0x804140,%eax
  802001:	85 c0                	test   %eax,%eax
  802003:	75 8a                	jne    801f8f <print_mem_block_lists+0x3b>
  802005:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802009:	75 84                	jne    801f8f <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80200b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80200f:	75 10                	jne    802021 <print_mem_block_lists+0xcd>
  802011:	83 ec 0c             	sub    $0xc,%esp
  802014:	68 f0 39 80 00       	push   $0x8039f0
  802019:	e8 26 e6 ff ff       	call   800644 <cprintf>
  80201e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802021:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802028:	83 ec 0c             	sub    $0xc,%esp
  80202b:	68 14 3a 80 00       	push   $0x803a14
  802030:	e8 0f e6 ff ff       	call   800644 <cprintf>
  802035:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802038:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80203c:	a1 40 40 80 00       	mov    0x804040,%eax
  802041:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802044:	eb 56                	jmp    80209c <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802046:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80204a:	74 1c                	je     802068 <print_mem_block_lists+0x114>
  80204c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204f:	8b 50 08             	mov    0x8(%eax),%edx
  802052:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802055:	8b 48 08             	mov    0x8(%eax),%ecx
  802058:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205b:	8b 40 0c             	mov    0xc(%eax),%eax
  80205e:	01 c8                	add    %ecx,%eax
  802060:	39 c2                	cmp    %eax,%edx
  802062:	73 04                	jae    802068 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802064:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206b:	8b 50 08             	mov    0x8(%eax),%edx
  80206e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802071:	8b 40 0c             	mov    0xc(%eax),%eax
  802074:	01 c2                	add    %eax,%edx
  802076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802079:	8b 40 08             	mov    0x8(%eax),%eax
  80207c:	83 ec 04             	sub    $0x4,%esp
  80207f:	52                   	push   %edx
  802080:	50                   	push   %eax
  802081:	68 e1 39 80 00       	push   $0x8039e1
  802086:	e8 b9 e5 ff ff       	call   800644 <cprintf>
  80208b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80208e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802091:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802094:	a1 48 40 80 00       	mov    0x804048,%eax
  802099:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80209c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020a0:	74 07                	je     8020a9 <print_mem_block_lists+0x155>
  8020a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a5:	8b 00                	mov    (%eax),%eax
  8020a7:	eb 05                	jmp    8020ae <print_mem_block_lists+0x15a>
  8020a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ae:	a3 48 40 80 00       	mov    %eax,0x804048
  8020b3:	a1 48 40 80 00       	mov    0x804048,%eax
  8020b8:	85 c0                	test   %eax,%eax
  8020ba:	75 8a                	jne    802046 <print_mem_block_lists+0xf2>
  8020bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c0:	75 84                	jne    802046 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020c2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020c6:	75 10                	jne    8020d8 <print_mem_block_lists+0x184>
  8020c8:	83 ec 0c             	sub    $0xc,%esp
  8020cb:	68 2c 3a 80 00       	push   $0x803a2c
  8020d0:	e8 6f e5 ff ff       	call   800644 <cprintf>
  8020d5:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020d8:	83 ec 0c             	sub    $0xc,%esp
  8020db:	68 a0 39 80 00       	push   $0x8039a0
  8020e0:	e8 5f e5 ff ff       	call   800644 <cprintf>
  8020e5:	83 c4 10             	add    $0x10,%esp

}
  8020e8:	90                   	nop
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
  8020ee:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  8020f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f4:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  8020f7:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020fe:	00 00 00 
  802101:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802108:	00 00 00 
  80210b:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802112:	00 00 00 
	for(int i = 0; i<n;i++)
  802115:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80211c:	e9 9e 00 00 00       	jmp    8021bf <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802121:	a1 50 40 80 00       	mov    0x804050,%eax
  802126:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802129:	c1 e2 04             	shl    $0x4,%edx
  80212c:	01 d0                	add    %edx,%eax
  80212e:	85 c0                	test   %eax,%eax
  802130:	75 14                	jne    802146 <initialize_MemBlocksList+0x5b>
  802132:	83 ec 04             	sub    $0x4,%esp
  802135:	68 54 3a 80 00       	push   $0x803a54
  80213a:	6a 47                	push   $0x47
  80213c:	68 77 3a 80 00       	push   $0x803a77
  802141:	e8 4a e2 ff ff       	call   800390 <_panic>
  802146:	a1 50 40 80 00       	mov    0x804050,%eax
  80214b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80214e:	c1 e2 04             	shl    $0x4,%edx
  802151:	01 d0                	add    %edx,%eax
  802153:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802159:	89 10                	mov    %edx,(%eax)
  80215b:	8b 00                	mov    (%eax),%eax
  80215d:	85 c0                	test   %eax,%eax
  80215f:	74 18                	je     802179 <initialize_MemBlocksList+0x8e>
  802161:	a1 48 41 80 00       	mov    0x804148,%eax
  802166:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80216c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80216f:	c1 e1 04             	shl    $0x4,%ecx
  802172:	01 ca                	add    %ecx,%edx
  802174:	89 50 04             	mov    %edx,0x4(%eax)
  802177:	eb 12                	jmp    80218b <initialize_MemBlocksList+0xa0>
  802179:	a1 50 40 80 00       	mov    0x804050,%eax
  80217e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802181:	c1 e2 04             	shl    $0x4,%edx
  802184:	01 d0                	add    %edx,%eax
  802186:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80218b:	a1 50 40 80 00       	mov    0x804050,%eax
  802190:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802193:	c1 e2 04             	shl    $0x4,%edx
  802196:	01 d0                	add    %edx,%eax
  802198:	a3 48 41 80 00       	mov    %eax,0x804148
  80219d:	a1 50 40 80 00       	mov    0x804050,%eax
  8021a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a5:	c1 e2 04             	shl    $0x4,%edx
  8021a8:	01 d0                	add    %edx,%eax
  8021aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021b1:	a1 54 41 80 00       	mov    0x804154,%eax
  8021b6:	40                   	inc    %eax
  8021b7:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8021bc:	ff 45 f4             	incl   -0xc(%ebp)
  8021bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8021c5:	0f 82 56 ff ff ff    	jb     802121 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8021cb:	90                   	nop
  8021cc:	c9                   	leave  
  8021cd:	c3                   	ret    

008021ce <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  8021d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  8021da:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8021e1:	a1 40 40 80 00       	mov    0x804040,%eax
  8021e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021e9:	eb 23                	jmp    80220e <find_block+0x40>
	{
		if(blk->sva == virAddress)
  8021eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ee:	8b 40 08             	mov    0x8(%eax),%eax
  8021f1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8021f4:	75 09                	jne    8021ff <find_block+0x31>
		{
			found = 1;
  8021f6:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  8021fd:	eb 35                	jmp    802234 <find_block+0x66>
		}
		else
		{
			found = 0;
  8021ff:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802206:	a1 48 40 80 00       	mov    0x804048,%eax
  80220b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80220e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802212:	74 07                	je     80221b <find_block+0x4d>
  802214:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802217:	8b 00                	mov    (%eax),%eax
  802219:	eb 05                	jmp    802220 <find_block+0x52>
  80221b:	b8 00 00 00 00       	mov    $0x0,%eax
  802220:	a3 48 40 80 00       	mov    %eax,0x804048
  802225:	a1 48 40 80 00       	mov    0x804048,%eax
  80222a:	85 c0                	test   %eax,%eax
  80222c:	75 bd                	jne    8021eb <find_block+0x1d>
  80222e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802232:	75 b7                	jne    8021eb <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802234:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802238:	75 05                	jne    80223f <find_block+0x71>
	{
		return blk;
  80223a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80223d:	eb 05                	jmp    802244 <find_block+0x76>
	}
	else
	{
		return NULL;
  80223f:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802244:	c9                   	leave  
  802245:	c3                   	ret    

00802246 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
  802249:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  80224c:	8b 45 08             	mov    0x8(%ebp),%eax
  80224f:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802252:	a1 40 40 80 00       	mov    0x804040,%eax
  802257:	85 c0                	test   %eax,%eax
  802259:	74 12                	je     80226d <insert_sorted_allocList+0x27>
  80225b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225e:	8b 50 08             	mov    0x8(%eax),%edx
  802261:	a1 40 40 80 00       	mov    0x804040,%eax
  802266:	8b 40 08             	mov    0x8(%eax),%eax
  802269:	39 c2                	cmp    %eax,%edx
  80226b:	73 65                	jae    8022d2 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  80226d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802271:	75 14                	jne    802287 <insert_sorted_allocList+0x41>
  802273:	83 ec 04             	sub    $0x4,%esp
  802276:	68 54 3a 80 00       	push   $0x803a54
  80227b:	6a 7b                	push   $0x7b
  80227d:	68 77 3a 80 00       	push   $0x803a77
  802282:	e8 09 e1 ff ff       	call   800390 <_panic>
  802287:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80228d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802290:	89 10                	mov    %edx,(%eax)
  802292:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802295:	8b 00                	mov    (%eax),%eax
  802297:	85 c0                	test   %eax,%eax
  802299:	74 0d                	je     8022a8 <insert_sorted_allocList+0x62>
  80229b:	a1 40 40 80 00       	mov    0x804040,%eax
  8022a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022a3:	89 50 04             	mov    %edx,0x4(%eax)
  8022a6:	eb 08                	jmp    8022b0 <insert_sorted_allocList+0x6a>
  8022a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ab:	a3 44 40 80 00       	mov    %eax,0x804044
  8022b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b3:	a3 40 40 80 00       	mov    %eax,0x804040
  8022b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022c2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022c7:	40                   	inc    %eax
  8022c8:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8022cd:	e9 5f 01 00 00       	jmp    802431 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8022d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d5:	8b 50 08             	mov    0x8(%eax),%edx
  8022d8:	a1 44 40 80 00       	mov    0x804044,%eax
  8022dd:	8b 40 08             	mov    0x8(%eax),%eax
  8022e0:	39 c2                	cmp    %eax,%edx
  8022e2:	76 65                	jbe    802349 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  8022e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022e8:	75 14                	jne    8022fe <insert_sorted_allocList+0xb8>
  8022ea:	83 ec 04             	sub    $0x4,%esp
  8022ed:	68 90 3a 80 00       	push   $0x803a90
  8022f2:	6a 7f                	push   $0x7f
  8022f4:	68 77 3a 80 00       	push   $0x803a77
  8022f9:	e8 92 e0 ff ff       	call   800390 <_panic>
  8022fe:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802304:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802307:	89 50 04             	mov    %edx,0x4(%eax)
  80230a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80230d:	8b 40 04             	mov    0x4(%eax),%eax
  802310:	85 c0                	test   %eax,%eax
  802312:	74 0c                	je     802320 <insert_sorted_allocList+0xda>
  802314:	a1 44 40 80 00       	mov    0x804044,%eax
  802319:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80231c:	89 10                	mov    %edx,(%eax)
  80231e:	eb 08                	jmp    802328 <insert_sorted_allocList+0xe2>
  802320:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802323:	a3 40 40 80 00       	mov    %eax,0x804040
  802328:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232b:	a3 44 40 80 00       	mov    %eax,0x804044
  802330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802333:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802339:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80233e:	40                   	inc    %eax
  80233f:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802344:	e9 e8 00 00 00       	jmp    802431 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802349:	a1 40 40 80 00       	mov    0x804040,%eax
  80234e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802351:	e9 ab 00 00 00       	jmp    802401 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802359:	8b 00                	mov    (%eax),%eax
  80235b:	85 c0                	test   %eax,%eax
  80235d:	0f 84 96 00 00 00    	je     8023f9 <insert_sorted_allocList+0x1b3>
  802363:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802366:	8b 50 08             	mov    0x8(%eax),%edx
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	8b 40 08             	mov    0x8(%eax),%eax
  80236f:	39 c2                	cmp    %eax,%edx
  802371:	0f 86 82 00 00 00    	jbe    8023f9 <insert_sorted_allocList+0x1b3>
  802377:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237a:	8b 50 08             	mov    0x8(%eax),%edx
  80237d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802380:	8b 00                	mov    (%eax),%eax
  802382:	8b 40 08             	mov    0x8(%eax),%eax
  802385:	39 c2                	cmp    %eax,%edx
  802387:	73 70                	jae    8023f9 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802389:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238d:	74 06                	je     802395 <insert_sorted_allocList+0x14f>
  80238f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802393:	75 17                	jne    8023ac <insert_sorted_allocList+0x166>
  802395:	83 ec 04             	sub    $0x4,%esp
  802398:	68 b4 3a 80 00       	push   $0x803ab4
  80239d:	68 87 00 00 00       	push   $0x87
  8023a2:	68 77 3a 80 00       	push   $0x803a77
  8023a7:	e8 e4 df ff ff       	call   800390 <_panic>
  8023ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023af:	8b 10                	mov    (%eax),%edx
  8023b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b4:	89 10                	mov    %edx,(%eax)
  8023b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b9:	8b 00                	mov    (%eax),%eax
  8023bb:	85 c0                	test   %eax,%eax
  8023bd:	74 0b                	je     8023ca <insert_sorted_allocList+0x184>
  8023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c2:	8b 00                	mov    (%eax),%eax
  8023c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023c7:	89 50 04             	mov    %edx,0x4(%eax)
  8023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023d0:	89 10                	mov    %edx,(%eax)
  8023d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d8:	89 50 04             	mov    %edx,0x4(%eax)
  8023db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023de:	8b 00                	mov    (%eax),%eax
  8023e0:	85 c0                	test   %eax,%eax
  8023e2:	75 08                	jne    8023ec <insert_sorted_allocList+0x1a6>
  8023e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e7:	a3 44 40 80 00       	mov    %eax,0x804044
  8023ec:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023f1:	40                   	inc    %eax
  8023f2:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8023f7:	eb 38                	jmp    802431 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8023f9:	a1 48 40 80 00       	mov    0x804048,%eax
  8023fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802401:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802405:	74 07                	je     80240e <insert_sorted_allocList+0x1c8>
  802407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240a:	8b 00                	mov    (%eax),%eax
  80240c:	eb 05                	jmp    802413 <insert_sorted_allocList+0x1cd>
  80240e:	b8 00 00 00 00       	mov    $0x0,%eax
  802413:	a3 48 40 80 00       	mov    %eax,0x804048
  802418:	a1 48 40 80 00       	mov    0x804048,%eax
  80241d:	85 c0                	test   %eax,%eax
  80241f:	0f 85 31 ff ff ff    	jne    802356 <insert_sorted_allocList+0x110>
  802425:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802429:	0f 85 27 ff ff ff    	jne    802356 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80242f:	eb 00                	jmp    802431 <insert_sorted_allocList+0x1eb>
  802431:	90                   	nop
  802432:	c9                   	leave  
  802433:	c3                   	ret    

00802434 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802434:	55                   	push   %ebp
  802435:	89 e5                	mov    %esp,%ebp
  802437:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  80243a:	8b 45 08             	mov    0x8(%ebp),%eax
  80243d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802440:	a1 48 41 80 00       	mov    0x804148,%eax
  802445:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802448:	a1 38 41 80 00       	mov    0x804138,%eax
  80244d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802450:	e9 77 01 00 00       	jmp    8025cc <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802458:	8b 40 0c             	mov    0xc(%eax),%eax
  80245b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80245e:	0f 85 8a 00 00 00    	jne    8024ee <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802464:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802468:	75 17                	jne    802481 <alloc_block_FF+0x4d>
  80246a:	83 ec 04             	sub    $0x4,%esp
  80246d:	68 e8 3a 80 00       	push   $0x803ae8
  802472:	68 9e 00 00 00       	push   $0x9e
  802477:	68 77 3a 80 00       	push   $0x803a77
  80247c:	e8 0f df ff ff       	call   800390 <_panic>
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	8b 00                	mov    (%eax),%eax
  802486:	85 c0                	test   %eax,%eax
  802488:	74 10                	je     80249a <alloc_block_FF+0x66>
  80248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248d:	8b 00                	mov    (%eax),%eax
  80248f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802492:	8b 52 04             	mov    0x4(%edx),%edx
  802495:	89 50 04             	mov    %edx,0x4(%eax)
  802498:	eb 0b                	jmp    8024a5 <alloc_block_FF+0x71>
  80249a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249d:	8b 40 04             	mov    0x4(%eax),%eax
  8024a0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a8:	8b 40 04             	mov    0x4(%eax),%eax
  8024ab:	85 c0                	test   %eax,%eax
  8024ad:	74 0f                	je     8024be <alloc_block_FF+0x8a>
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	8b 40 04             	mov    0x4(%eax),%eax
  8024b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b8:	8b 12                	mov    (%edx),%edx
  8024ba:	89 10                	mov    %edx,(%eax)
  8024bc:	eb 0a                	jmp    8024c8 <alloc_block_FF+0x94>
  8024be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c1:	8b 00                	mov    (%eax),%eax
  8024c3:	a3 38 41 80 00       	mov    %eax,0x804138
  8024c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024db:	a1 44 41 80 00       	mov    0x804144,%eax
  8024e0:	48                   	dec    %eax
  8024e1:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8024e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e9:	e9 11 01 00 00       	jmp    8025ff <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  8024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024f7:	0f 86 c7 00 00 00    	jbe    8025c4 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8024fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802501:	75 17                	jne    80251a <alloc_block_FF+0xe6>
  802503:	83 ec 04             	sub    $0x4,%esp
  802506:	68 e8 3a 80 00       	push   $0x803ae8
  80250b:	68 a3 00 00 00       	push   $0xa3
  802510:	68 77 3a 80 00       	push   $0x803a77
  802515:	e8 76 de ff ff       	call   800390 <_panic>
  80251a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251d:	8b 00                	mov    (%eax),%eax
  80251f:	85 c0                	test   %eax,%eax
  802521:	74 10                	je     802533 <alloc_block_FF+0xff>
  802523:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802526:	8b 00                	mov    (%eax),%eax
  802528:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80252b:	8b 52 04             	mov    0x4(%edx),%edx
  80252e:	89 50 04             	mov    %edx,0x4(%eax)
  802531:	eb 0b                	jmp    80253e <alloc_block_FF+0x10a>
  802533:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802536:	8b 40 04             	mov    0x4(%eax),%eax
  802539:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80253e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802541:	8b 40 04             	mov    0x4(%eax),%eax
  802544:	85 c0                	test   %eax,%eax
  802546:	74 0f                	je     802557 <alloc_block_FF+0x123>
  802548:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80254b:	8b 40 04             	mov    0x4(%eax),%eax
  80254e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802551:	8b 12                	mov    (%edx),%edx
  802553:	89 10                	mov    %edx,(%eax)
  802555:	eb 0a                	jmp    802561 <alloc_block_FF+0x12d>
  802557:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255a:	8b 00                	mov    (%eax),%eax
  80255c:	a3 48 41 80 00       	mov    %eax,0x804148
  802561:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802564:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80256a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802574:	a1 54 41 80 00       	mov    0x804154,%eax
  802579:	48                   	dec    %eax
  80257a:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  80257f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802582:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802585:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	8b 40 0c             	mov    0xc(%eax),%eax
  80258e:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802591:	89 c2                	mov    %eax,%edx
  802593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802596:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	8b 40 08             	mov    0x8(%eax),%eax
  80259f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a5:	8b 50 08             	mov    0x8(%eax),%edx
  8025a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ae:	01 c2                	add    %eax,%edx
  8025b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b3:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8025b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025bc:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8025bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c2:	eb 3b                	jmp    8025ff <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8025c4:	a1 40 41 80 00       	mov    0x804140,%eax
  8025c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d0:	74 07                	je     8025d9 <alloc_block_FF+0x1a5>
  8025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d5:	8b 00                	mov    (%eax),%eax
  8025d7:	eb 05                	jmp    8025de <alloc_block_FF+0x1aa>
  8025d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025de:	a3 40 41 80 00       	mov    %eax,0x804140
  8025e3:	a1 40 41 80 00       	mov    0x804140,%eax
  8025e8:	85 c0                	test   %eax,%eax
  8025ea:	0f 85 65 fe ff ff    	jne    802455 <alloc_block_FF+0x21>
  8025f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f4:	0f 85 5b fe ff ff    	jne    802455 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8025fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ff:	c9                   	leave  
  802600:	c3                   	ret    

00802601 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802601:	55                   	push   %ebp
  802602:	89 e5                	mov    %esp,%ebp
  802604:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802607:	8b 45 08             	mov    0x8(%ebp),%eax
  80260a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  80260d:	a1 48 41 80 00       	mov    0x804148,%eax
  802612:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802615:	a1 44 41 80 00       	mov    0x804144,%eax
  80261a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  80261d:	a1 38 41 80 00       	mov    0x804138,%eax
  802622:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802625:	e9 a1 00 00 00       	jmp    8026cb <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	8b 40 0c             	mov    0xc(%eax),%eax
  802630:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802633:	0f 85 8a 00 00 00    	jne    8026c3 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802639:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263d:	75 17                	jne    802656 <alloc_block_BF+0x55>
  80263f:	83 ec 04             	sub    $0x4,%esp
  802642:	68 e8 3a 80 00       	push   $0x803ae8
  802647:	68 c2 00 00 00       	push   $0xc2
  80264c:	68 77 3a 80 00       	push   $0x803a77
  802651:	e8 3a dd ff ff       	call   800390 <_panic>
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802659:	8b 00                	mov    (%eax),%eax
  80265b:	85 c0                	test   %eax,%eax
  80265d:	74 10                	je     80266f <alloc_block_BF+0x6e>
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	8b 00                	mov    (%eax),%eax
  802664:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802667:	8b 52 04             	mov    0x4(%edx),%edx
  80266a:	89 50 04             	mov    %edx,0x4(%eax)
  80266d:	eb 0b                	jmp    80267a <alloc_block_BF+0x79>
  80266f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802672:	8b 40 04             	mov    0x4(%eax),%eax
  802675:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	8b 40 04             	mov    0x4(%eax),%eax
  802680:	85 c0                	test   %eax,%eax
  802682:	74 0f                	je     802693 <alloc_block_BF+0x92>
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	8b 40 04             	mov    0x4(%eax),%eax
  80268a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80268d:	8b 12                	mov    (%edx),%edx
  80268f:	89 10                	mov    %edx,(%eax)
  802691:	eb 0a                	jmp    80269d <alloc_block_BF+0x9c>
  802693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802696:	8b 00                	mov    (%eax),%eax
  802698:	a3 38 41 80 00       	mov    %eax,0x804138
  80269d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026b0:	a1 44 41 80 00       	mov    0x804144,%eax
  8026b5:	48                   	dec    %eax
  8026b6:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8026bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026be:	e9 11 02 00 00       	jmp    8028d4 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026c3:	a1 40 41 80 00       	mov    0x804140,%eax
  8026c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026cf:	74 07                	je     8026d8 <alloc_block_BF+0xd7>
  8026d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d4:	8b 00                	mov    (%eax),%eax
  8026d6:	eb 05                	jmp    8026dd <alloc_block_BF+0xdc>
  8026d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8026dd:	a3 40 41 80 00       	mov    %eax,0x804140
  8026e2:	a1 40 41 80 00       	mov    0x804140,%eax
  8026e7:	85 c0                	test   %eax,%eax
  8026e9:	0f 85 3b ff ff ff    	jne    80262a <alloc_block_BF+0x29>
  8026ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f3:	0f 85 31 ff ff ff    	jne    80262a <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026f9:	a1 38 41 80 00       	mov    0x804138,%eax
  8026fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802701:	eb 27                	jmp    80272a <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	8b 40 0c             	mov    0xc(%eax),%eax
  802709:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80270c:	76 14                	jbe    802722 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  80270e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802711:	8b 40 0c             	mov    0xc(%eax),%eax
  802714:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802717:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271a:	8b 40 08             	mov    0x8(%eax),%eax
  80271d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802720:	eb 2e                	jmp    802750 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802722:	a1 40 41 80 00       	mov    0x804140,%eax
  802727:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80272a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80272e:	74 07                	je     802737 <alloc_block_BF+0x136>
  802730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802733:	8b 00                	mov    (%eax),%eax
  802735:	eb 05                	jmp    80273c <alloc_block_BF+0x13b>
  802737:	b8 00 00 00 00       	mov    $0x0,%eax
  80273c:	a3 40 41 80 00       	mov    %eax,0x804140
  802741:	a1 40 41 80 00       	mov    0x804140,%eax
  802746:	85 c0                	test   %eax,%eax
  802748:	75 b9                	jne    802703 <alloc_block_BF+0x102>
  80274a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274e:	75 b3                	jne    802703 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802750:	a1 38 41 80 00       	mov    0x804138,%eax
  802755:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802758:	eb 30                	jmp    80278a <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	8b 40 0c             	mov    0xc(%eax),%eax
  802760:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802763:	73 1d                	jae    802782 <alloc_block_BF+0x181>
  802765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802768:	8b 40 0c             	mov    0xc(%eax),%eax
  80276b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80276e:	76 12                	jbe    802782 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802773:	8b 40 0c             	mov    0xc(%eax),%eax
  802776:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	8b 40 08             	mov    0x8(%eax),%eax
  80277f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802782:	a1 40 41 80 00       	mov    0x804140,%eax
  802787:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80278a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278e:	74 07                	je     802797 <alloc_block_BF+0x196>
  802790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802793:	8b 00                	mov    (%eax),%eax
  802795:	eb 05                	jmp    80279c <alloc_block_BF+0x19b>
  802797:	b8 00 00 00 00       	mov    $0x0,%eax
  80279c:	a3 40 41 80 00       	mov    %eax,0x804140
  8027a1:	a1 40 41 80 00       	mov    0x804140,%eax
  8027a6:	85 c0                	test   %eax,%eax
  8027a8:	75 b0                	jne    80275a <alloc_block_BF+0x159>
  8027aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ae:	75 aa                	jne    80275a <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027b0:	a1 38 41 80 00       	mov    0x804138,%eax
  8027b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b8:	e9 e4 00 00 00       	jmp    8028a1 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  8027bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8027c6:	0f 85 cd 00 00 00    	jne    802899 <alloc_block_BF+0x298>
  8027cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cf:	8b 40 08             	mov    0x8(%eax),%eax
  8027d2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027d5:	0f 85 be 00 00 00    	jne    802899 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  8027db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027df:	75 17                	jne    8027f8 <alloc_block_BF+0x1f7>
  8027e1:	83 ec 04             	sub    $0x4,%esp
  8027e4:	68 e8 3a 80 00       	push   $0x803ae8
  8027e9:	68 db 00 00 00       	push   $0xdb
  8027ee:	68 77 3a 80 00       	push   $0x803a77
  8027f3:	e8 98 db ff ff       	call   800390 <_panic>
  8027f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027fb:	8b 00                	mov    (%eax),%eax
  8027fd:	85 c0                	test   %eax,%eax
  8027ff:	74 10                	je     802811 <alloc_block_BF+0x210>
  802801:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802804:	8b 00                	mov    (%eax),%eax
  802806:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802809:	8b 52 04             	mov    0x4(%edx),%edx
  80280c:	89 50 04             	mov    %edx,0x4(%eax)
  80280f:	eb 0b                	jmp    80281c <alloc_block_BF+0x21b>
  802811:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802814:	8b 40 04             	mov    0x4(%eax),%eax
  802817:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80281c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80281f:	8b 40 04             	mov    0x4(%eax),%eax
  802822:	85 c0                	test   %eax,%eax
  802824:	74 0f                	je     802835 <alloc_block_BF+0x234>
  802826:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802829:	8b 40 04             	mov    0x4(%eax),%eax
  80282c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80282f:	8b 12                	mov    (%edx),%edx
  802831:	89 10                	mov    %edx,(%eax)
  802833:	eb 0a                	jmp    80283f <alloc_block_BF+0x23e>
  802835:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802838:	8b 00                	mov    (%eax),%eax
  80283a:	a3 48 41 80 00       	mov    %eax,0x804148
  80283f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802842:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802848:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80284b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802852:	a1 54 41 80 00       	mov    0x804154,%eax
  802857:	48                   	dec    %eax
  802858:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  80285d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802860:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802863:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802866:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802869:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80286c:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  80286f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802872:	8b 40 0c             	mov    0xc(%eax),%eax
  802875:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802878:	89 c2                	mov    %eax,%edx
  80287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287d:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	8b 50 08             	mov    0x8(%eax),%edx
  802886:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802889:	8b 40 0c             	mov    0xc(%eax),%eax
  80288c:	01 c2                	add    %eax,%edx
  80288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802891:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802894:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802897:	eb 3b                	jmp    8028d4 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802899:	a1 40 41 80 00       	mov    0x804140,%eax
  80289e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a5:	74 07                	je     8028ae <alloc_block_BF+0x2ad>
  8028a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028aa:	8b 00                	mov    (%eax),%eax
  8028ac:	eb 05                	jmp    8028b3 <alloc_block_BF+0x2b2>
  8028ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b3:	a3 40 41 80 00       	mov    %eax,0x804140
  8028b8:	a1 40 41 80 00       	mov    0x804140,%eax
  8028bd:	85 c0                	test   %eax,%eax
  8028bf:	0f 85 f8 fe ff ff    	jne    8027bd <alloc_block_BF+0x1bc>
  8028c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c9:	0f 85 ee fe ff ff    	jne    8027bd <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  8028cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028d4:	c9                   	leave  
  8028d5:	c3                   	ret    

008028d6 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8028d6:	55                   	push   %ebp
  8028d7:	89 e5                	mov    %esp,%ebp
  8028d9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  8028dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028df:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8028e2:	a1 48 41 80 00       	mov    0x804148,%eax
  8028e7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8028ea:	a1 38 41 80 00       	mov    0x804138,%eax
  8028ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f2:	e9 77 01 00 00       	jmp    802a6e <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  8028f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8028fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802900:	0f 85 8a 00 00 00    	jne    802990 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802906:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80290a:	75 17                	jne    802923 <alloc_block_NF+0x4d>
  80290c:	83 ec 04             	sub    $0x4,%esp
  80290f:	68 e8 3a 80 00       	push   $0x803ae8
  802914:	68 f7 00 00 00       	push   $0xf7
  802919:	68 77 3a 80 00       	push   $0x803a77
  80291e:	e8 6d da ff ff       	call   800390 <_panic>
  802923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802926:	8b 00                	mov    (%eax),%eax
  802928:	85 c0                	test   %eax,%eax
  80292a:	74 10                	je     80293c <alloc_block_NF+0x66>
  80292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292f:	8b 00                	mov    (%eax),%eax
  802931:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802934:	8b 52 04             	mov    0x4(%edx),%edx
  802937:	89 50 04             	mov    %edx,0x4(%eax)
  80293a:	eb 0b                	jmp    802947 <alloc_block_NF+0x71>
  80293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293f:	8b 40 04             	mov    0x4(%eax),%eax
  802942:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294a:	8b 40 04             	mov    0x4(%eax),%eax
  80294d:	85 c0                	test   %eax,%eax
  80294f:	74 0f                	je     802960 <alloc_block_NF+0x8a>
  802951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802954:	8b 40 04             	mov    0x4(%eax),%eax
  802957:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80295a:	8b 12                	mov    (%edx),%edx
  80295c:	89 10                	mov    %edx,(%eax)
  80295e:	eb 0a                	jmp    80296a <alloc_block_NF+0x94>
  802960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802963:	8b 00                	mov    (%eax),%eax
  802965:	a3 38 41 80 00       	mov    %eax,0x804138
  80296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80297d:	a1 44 41 80 00       	mov    0x804144,%eax
  802982:	48                   	dec    %eax
  802983:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	e9 11 01 00 00       	jmp    802aa1 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802993:	8b 40 0c             	mov    0xc(%eax),%eax
  802996:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802999:	0f 86 c7 00 00 00    	jbe    802a66 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  80299f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029a3:	75 17                	jne    8029bc <alloc_block_NF+0xe6>
  8029a5:	83 ec 04             	sub    $0x4,%esp
  8029a8:	68 e8 3a 80 00       	push   $0x803ae8
  8029ad:	68 fc 00 00 00       	push   $0xfc
  8029b2:	68 77 3a 80 00       	push   $0x803a77
  8029b7:	e8 d4 d9 ff ff       	call   800390 <_panic>
  8029bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029bf:	8b 00                	mov    (%eax),%eax
  8029c1:	85 c0                	test   %eax,%eax
  8029c3:	74 10                	je     8029d5 <alloc_block_NF+0xff>
  8029c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c8:	8b 00                	mov    (%eax),%eax
  8029ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029cd:	8b 52 04             	mov    0x4(%edx),%edx
  8029d0:	89 50 04             	mov    %edx,0x4(%eax)
  8029d3:	eb 0b                	jmp    8029e0 <alloc_block_NF+0x10a>
  8029d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d8:	8b 40 04             	mov    0x4(%eax),%eax
  8029db:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e3:	8b 40 04             	mov    0x4(%eax),%eax
  8029e6:	85 c0                	test   %eax,%eax
  8029e8:	74 0f                	je     8029f9 <alloc_block_NF+0x123>
  8029ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ed:	8b 40 04             	mov    0x4(%eax),%eax
  8029f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029f3:	8b 12                	mov    (%edx),%edx
  8029f5:	89 10                	mov    %edx,(%eax)
  8029f7:	eb 0a                	jmp    802a03 <alloc_block_NF+0x12d>
  8029f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fc:	8b 00                	mov    (%eax),%eax
  8029fe:	a3 48 41 80 00       	mov    %eax,0x804148
  802a03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a16:	a1 54 41 80 00       	mov    0x804154,%eax
  802a1b:	48                   	dec    %eax
  802a1c:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802a21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a24:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a27:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a30:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802a33:	89 c2                	mov    %eax,%edx
  802a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a38:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3e:	8b 40 08             	mov    0x8(%eax),%eax
  802a41:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a47:	8b 50 08             	mov    0x8(%eax),%edx
  802a4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a50:	01 c2                	add    %eax,%edx
  802a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a55:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802a58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a5e:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802a61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a64:	eb 3b                	jmp    802aa1 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802a66:	a1 40 41 80 00       	mov    0x804140,%eax
  802a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a72:	74 07                	je     802a7b <alloc_block_NF+0x1a5>
  802a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a77:	8b 00                	mov    (%eax),%eax
  802a79:	eb 05                	jmp    802a80 <alloc_block_NF+0x1aa>
  802a7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a80:	a3 40 41 80 00       	mov    %eax,0x804140
  802a85:	a1 40 41 80 00       	mov    0x804140,%eax
  802a8a:	85 c0                	test   %eax,%eax
  802a8c:	0f 85 65 fe ff ff    	jne    8028f7 <alloc_block_NF+0x21>
  802a92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a96:	0f 85 5b fe ff ff    	jne    8028f7 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802a9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802aa1:	c9                   	leave  
  802aa2:	c3                   	ret    

00802aa3 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802aa3:	55                   	push   %ebp
  802aa4:	89 e5                	mov    %esp,%ebp
  802aa6:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802abd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ac1:	75 17                	jne    802ada <addToAvailMemBlocksList+0x37>
  802ac3:	83 ec 04             	sub    $0x4,%esp
  802ac6:	68 90 3a 80 00       	push   $0x803a90
  802acb:	68 10 01 00 00       	push   $0x110
  802ad0:	68 77 3a 80 00       	push   $0x803a77
  802ad5:	e8 b6 d8 ff ff       	call   800390 <_panic>
  802ada:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae3:	89 50 04             	mov    %edx,0x4(%eax)
  802ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae9:	8b 40 04             	mov    0x4(%eax),%eax
  802aec:	85 c0                	test   %eax,%eax
  802aee:	74 0c                	je     802afc <addToAvailMemBlocksList+0x59>
  802af0:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802af5:	8b 55 08             	mov    0x8(%ebp),%edx
  802af8:	89 10                	mov    %edx,(%eax)
  802afa:	eb 08                	jmp    802b04 <addToAvailMemBlocksList+0x61>
  802afc:	8b 45 08             	mov    0x8(%ebp),%eax
  802aff:	a3 48 41 80 00       	mov    %eax,0x804148
  802b04:	8b 45 08             	mov    0x8(%ebp),%eax
  802b07:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b15:	a1 54 41 80 00       	mov    0x804154,%eax
  802b1a:	40                   	inc    %eax
  802b1b:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802b20:	90                   	nop
  802b21:	c9                   	leave  
  802b22:	c3                   	ret    

00802b23 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b23:	55                   	push   %ebp
  802b24:	89 e5                	mov    %esp,%ebp
  802b26:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802b29:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802b31:	a1 44 41 80 00       	mov    0x804144,%eax
  802b36:	85 c0                	test   %eax,%eax
  802b38:	75 68                	jne    802ba2 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802b3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b3e:	75 17                	jne    802b57 <insert_sorted_with_merge_freeList+0x34>
  802b40:	83 ec 04             	sub    $0x4,%esp
  802b43:	68 54 3a 80 00       	push   $0x803a54
  802b48:	68 1a 01 00 00       	push   $0x11a
  802b4d:	68 77 3a 80 00       	push   $0x803a77
  802b52:	e8 39 d8 ff ff       	call   800390 <_panic>
  802b57:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b60:	89 10                	mov    %edx,(%eax)
  802b62:	8b 45 08             	mov    0x8(%ebp),%eax
  802b65:	8b 00                	mov    (%eax),%eax
  802b67:	85 c0                	test   %eax,%eax
  802b69:	74 0d                	je     802b78 <insert_sorted_with_merge_freeList+0x55>
  802b6b:	a1 38 41 80 00       	mov    0x804138,%eax
  802b70:	8b 55 08             	mov    0x8(%ebp),%edx
  802b73:	89 50 04             	mov    %edx,0x4(%eax)
  802b76:	eb 08                	jmp    802b80 <insert_sorted_with_merge_freeList+0x5d>
  802b78:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b80:	8b 45 08             	mov    0x8(%ebp),%eax
  802b83:	a3 38 41 80 00       	mov    %eax,0x804138
  802b88:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b92:	a1 44 41 80 00       	mov    0x804144,%eax
  802b97:	40                   	inc    %eax
  802b98:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802b9d:	e9 c5 03 00 00       	jmp    802f67 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba5:	8b 50 08             	mov    0x8(%eax),%edx
  802ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bab:	8b 40 08             	mov    0x8(%eax),%eax
  802bae:	39 c2                	cmp    %eax,%edx
  802bb0:	0f 83 b2 00 00 00    	jae    802c68 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802bb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb9:	8b 50 08             	mov    0x8(%eax),%edx
  802bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbf:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc2:	01 c2                	add    %eax,%edx
  802bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc7:	8b 40 08             	mov    0x8(%eax),%eax
  802bca:	39 c2                	cmp    %eax,%edx
  802bcc:	75 27                	jne    802bf5 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd1:	8b 50 0c             	mov    0xc(%eax),%edx
  802bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bda:	01 c2                	add    %eax,%edx
  802bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdf:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802be2:	83 ec 0c             	sub    $0xc,%esp
  802be5:	ff 75 08             	pushl  0x8(%ebp)
  802be8:	e8 b6 fe ff ff       	call   802aa3 <addToAvailMemBlocksList>
  802bed:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802bf0:	e9 72 03 00 00       	jmp    802f67 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802bf5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bf9:	74 06                	je     802c01 <insert_sorted_with_merge_freeList+0xde>
  802bfb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bff:	75 17                	jne    802c18 <insert_sorted_with_merge_freeList+0xf5>
  802c01:	83 ec 04             	sub    $0x4,%esp
  802c04:	68 b4 3a 80 00       	push   $0x803ab4
  802c09:	68 24 01 00 00       	push   $0x124
  802c0e:	68 77 3a 80 00       	push   $0x803a77
  802c13:	e8 78 d7 ff ff       	call   800390 <_panic>
  802c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1b:	8b 10                	mov    (%eax),%edx
  802c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c20:	89 10                	mov    %edx,(%eax)
  802c22:	8b 45 08             	mov    0x8(%ebp),%eax
  802c25:	8b 00                	mov    (%eax),%eax
  802c27:	85 c0                	test   %eax,%eax
  802c29:	74 0b                	je     802c36 <insert_sorted_with_merge_freeList+0x113>
  802c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2e:	8b 00                	mov    (%eax),%eax
  802c30:	8b 55 08             	mov    0x8(%ebp),%edx
  802c33:	89 50 04             	mov    %edx,0x4(%eax)
  802c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c39:	8b 55 08             	mov    0x8(%ebp),%edx
  802c3c:	89 10                	mov    %edx,(%eax)
  802c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c41:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c44:	89 50 04             	mov    %edx,0x4(%eax)
  802c47:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4a:	8b 00                	mov    (%eax),%eax
  802c4c:	85 c0                	test   %eax,%eax
  802c4e:	75 08                	jne    802c58 <insert_sorted_with_merge_freeList+0x135>
  802c50:	8b 45 08             	mov    0x8(%ebp),%eax
  802c53:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c58:	a1 44 41 80 00       	mov    0x804144,%eax
  802c5d:	40                   	inc    %eax
  802c5e:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802c63:	e9 ff 02 00 00       	jmp    802f67 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802c68:	a1 38 41 80 00       	mov    0x804138,%eax
  802c6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c70:	e9 c2 02 00 00       	jmp    802f37 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c78:	8b 50 08             	mov    0x8(%eax),%edx
  802c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7e:	8b 40 08             	mov    0x8(%eax),%eax
  802c81:	39 c2                	cmp    %eax,%edx
  802c83:	0f 86 a6 02 00 00    	jbe    802f2f <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8c:	8b 40 04             	mov    0x4(%eax),%eax
  802c8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802c92:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c96:	0f 85 ba 00 00 00    	jne    802d56 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9f:	8b 50 0c             	mov    0xc(%eax),%edx
  802ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca5:	8b 40 08             	mov    0x8(%eax),%eax
  802ca8:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cad:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802cb0:	39 c2                	cmp    %eax,%edx
  802cb2:	75 33                	jne    802ce7 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb7:	8b 50 08             	mov    0x8(%eax),%edx
  802cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbd:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc3:	8b 50 0c             	mov    0xc(%eax),%edx
  802cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc9:	8b 40 0c             	mov    0xc(%eax),%eax
  802ccc:	01 c2                	add    %eax,%edx
  802cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd1:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802cd4:	83 ec 0c             	sub    $0xc,%esp
  802cd7:	ff 75 08             	pushl  0x8(%ebp)
  802cda:	e8 c4 fd ff ff       	call   802aa3 <addToAvailMemBlocksList>
  802cdf:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802ce2:	e9 80 02 00 00       	jmp    802f67 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802ce7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ceb:	74 06                	je     802cf3 <insert_sorted_with_merge_freeList+0x1d0>
  802ced:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cf1:	75 17                	jne    802d0a <insert_sorted_with_merge_freeList+0x1e7>
  802cf3:	83 ec 04             	sub    $0x4,%esp
  802cf6:	68 08 3b 80 00       	push   $0x803b08
  802cfb:	68 3a 01 00 00       	push   $0x13a
  802d00:	68 77 3a 80 00       	push   $0x803a77
  802d05:	e8 86 d6 ff ff       	call   800390 <_panic>
  802d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0d:	8b 50 04             	mov    0x4(%eax),%edx
  802d10:	8b 45 08             	mov    0x8(%ebp),%eax
  802d13:	89 50 04             	mov    %edx,0x4(%eax)
  802d16:	8b 45 08             	mov    0x8(%ebp),%eax
  802d19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d1c:	89 10                	mov    %edx,(%eax)
  802d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d21:	8b 40 04             	mov    0x4(%eax),%eax
  802d24:	85 c0                	test   %eax,%eax
  802d26:	74 0d                	je     802d35 <insert_sorted_with_merge_freeList+0x212>
  802d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2b:	8b 40 04             	mov    0x4(%eax),%eax
  802d2e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d31:	89 10                	mov    %edx,(%eax)
  802d33:	eb 08                	jmp    802d3d <insert_sorted_with_merge_freeList+0x21a>
  802d35:	8b 45 08             	mov    0x8(%ebp),%eax
  802d38:	a3 38 41 80 00       	mov    %eax,0x804138
  802d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d40:	8b 55 08             	mov    0x8(%ebp),%edx
  802d43:	89 50 04             	mov    %edx,0x4(%eax)
  802d46:	a1 44 41 80 00       	mov    0x804144,%eax
  802d4b:	40                   	inc    %eax
  802d4c:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802d51:	e9 11 02 00 00       	jmp    802f67 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802d56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d59:	8b 50 08             	mov    0x8(%eax),%edx
  802d5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d62:	01 c2                	add    %eax,%edx
  802d64:	8b 45 08             	mov    0x8(%ebp),%eax
  802d67:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6a:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6f:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802d72:	39 c2                	cmp    %eax,%edx
  802d74:	0f 85 bf 00 00 00    	jne    802e39 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802d7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7d:	8b 50 0c             	mov    0xc(%eax),%edx
  802d80:	8b 45 08             	mov    0x8(%ebp),%eax
  802d83:	8b 40 0c             	mov    0xc(%eax),%eax
  802d86:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8e:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802d90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d93:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802d96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d9a:	75 17                	jne    802db3 <insert_sorted_with_merge_freeList+0x290>
  802d9c:	83 ec 04             	sub    $0x4,%esp
  802d9f:	68 e8 3a 80 00       	push   $0x803ae8
  802da4:	68 43 01 00 00       	push   $0x143
  802da9:	68 77 3a 80 00       	push   $0x803a77
  802dae:	e8 dd d5 ff ff       	call   800390 <_panic>
  802db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db6:	8b 00                	mov    (%eax),%eax
  802db8:	85 c0                	test   %eax,%eax
  802dba:	74 10                	je     802dcc <insert_sorted_with_merge_freeList+0x2a9>
  802dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbf:	8b 00                	mov    (%eax),%eax
  802dc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dc4:	8b 52 04             	mov    0x4(%edx),%edx
  802dc7:	89 50 04             	mov    %edx,0x4(%eax)
  802dca:	eb 0b                	jmp    802dd7 <insert_sorted_with_merge_freeList+0x2b4>
  802dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcf:	8b 40 04             	mov    0x4(%eax),%eax
  802dd2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	8b 40 04             	mov    0x4(%eax),%eax
  802ddd:	85 c0                	test   %eax,%eax
  802ddf:	74 0f                	je     802df0 <insert_sorted_with_merge_freeList+0x2cd>
  802de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de4:	8b 40 04             	mov    0x4(%eax),%eax
  802de7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dea:	8b 12                	mov    (%edx),%edx
  802dec:	89 10                	mov    %edx,(%eax)
  802dee:	eb 0a                	jmp    802dfa <insert_sorted_with_merge_freeList+0x2d7>
  802df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df3:	8b 00                	mov    (%eax),%eax
  802df5:	a3 38 41 80 00       	mov    %eax,0x804138
  802dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e06:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e0d:	a1 44 41 80 00       	mov    0x804144,%eax
  802e12:	48                   	dec    %eax
  802e13:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802e18:	83 ec 0c             	sub    $0xc,%esp
  802e1b:	ff 75 08             	pushl  0x8(%ebp)
  802e1e:	e8 80 fc ff ff       	call   802aa3 <addToAvailMemBlocksList>
  802e23:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802e26:	83 ec 0c             	sub    $0xc,%esp
  802e29:	ff 75 f4             	pushl  -0xc(%ebp)
  802e2c:	e8 72 fc ff ff       	call   802aa3 <addToAvailMemBlocksList>
  802e31:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802e34:	e9 2e 01 00 00       	jmp    802f67 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802e39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3c:	8b 50 08             	mov    0x8(%eax),%edx
  802e3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e42:	8b 40 0c             	mov    0xc(%eax),%eax
  802e45:	01 c2                	add    %eax,%edx
  802e47:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4a:	8b 40 08             	mov    0x8(%eax),%eax
  802e4d:	39 c2                	cmp    %eax,%edx
  802e4f:	75 27                	jne    802e78 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802e51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e54:	8b 50 0c             	mov    0xc(%eax),%edx
  802e57:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5d:	01 c2                	add    %eax,%edx
  802e5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e62:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802e65:	83 ec 0c             	sub    $0xc,%esp
  802e68:	ff 75 08             	pushl  0x8(%ebp)
  802e6b:	e8 33 fc ff ff       	call   802aa3 <addToAvailMemBlocksList>
  802e70:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802e73:	e9 ef 00 00 00       	jmp    802f67 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	8b 50 0c             	mov    0xc(%eax),%edx
  802e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e81:	8b 40 08             	mov    0x8(%eax),%eax
  802e84:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e89:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802e8c:	39 c2                	cmp    %eax,%edx
  802e8e:	75 33                	jne    802ec3 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802e90:	8b 45 08             	mov    0x8(%ebp),%eax
  802e93:	8b 50 08             	mov    0x8(%eax),%edx
  802e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e99:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9f:	8b 50 0c             	mov    0xc(%eax),%edx
  802ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea8:	01 c2                	add    %eax,%edx
  802eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ead:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802eb0:	83 ec 0c             	sub    $0xc,%esp
  802eb3:	ff 75 08             	pushl  0x8(%ebp)
  802eb6:	e8 e8 fb ff ff       	call   802aa3 <addToAvailMemBlocksList>
  802ebb:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802ebe:	e9 a4 00 00 00       	jmp    802f67 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802ec3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec7:	74 06                	je     802ecf <insert_sorted_with_merge_freeList+0x3ac>
  802ec9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ecd:	75 17                	jne    802ee6 <insert_sorted_with_merge_freeList+0x3c3>
  802ecf:	83 ec 04             	sub    $0x4,%esp
  802ed2:	68 08 3b 80 00       	push   $0x803b08
  802ed7:	68 56 01 00 00       	push   $0x156
  802edc:	68 77 3a 80 00       	push   $0x803a77
  802ee1:	e8 aa d4 ff ff       	call   800390 <_panic>
  802ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee9:	8b 50 04             	mov    0x4(%eax),%edx
  802eec:	8b 45 08             	mov    0x8(%ebp),%eax
  802eef:	89 50 04             	mov    %edx,0x4(%eax)
  802ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ef8:	89 10                	mov    %edx,(%eax)
  802efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efd:	8b 40 04             	mov    0x4(%eax),%eax
  802f00:	85 c0                	test   %eax,%eax
  802f02:	74 0d                	je     802f11 <insert_sorted_with_merge_freeList+0x3ee>
  802f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f07:	8b 40 04             	mov    0x4(%eax),%eax
  802f0a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f0d:	89 10                	mov    %edx,(%eax)
  802f0f:	eb 08                	jmp    802f19 <insert_sorted_with_merge_freeList+0x3f6>
  802f11:	8b 45 08             	mov    0x8(%ebp),%eax
  802f14:	a3 38 41 80 00       	mov    %eax,0x804138
  802f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1c:	8b 55 08             	mov    0x8(%ebp),%edx
  802f1f:	89 50 04             	mov    %edx,0x4(%eax)
  802f22:	a1 44 41 80 00       	mov    0x804144,%eax
  802f27:	40                   	inc    %eax
  802f28:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802f2d:	eb 38                	jmp    802f67 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802f2f:	a1 40 41 80 00       	mov    0x804140,%eax
  802f34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f3b:	74 07                	je     802f44 <insert_sorted_with_merge_freeList+0x421>
  802f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f40:	8b 00                	mov    (%eax),%eax
  802f42:	eb 05                	jmp    802f49 <insert_sorted_with_merge_freeList+0x426>
  802f44:	b8 00 00 00 00       	mov    $0x0,%eax
  802f49:	a3 40 41 80 00       	mov    %eax,0x804140
  802f4e:	a1 40 41 80 00       	mov    0x804140,%eax
  802f53:	85 c0                	test   %eax,%eax
  802f55:	0f 85 1a fd ff ff    	jne    802c75 <insert_sorted_with_merge_freeList+0x152>
  802f5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f5f:	0f 85 10 fd ff ff    	jne    802c75 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f65:	eb 00                	jmp    802f67 <insert_sorted_with_merge_freeList+0x444>
  802f67:	90                   	nop
  802f68:	c9                   	leave  
  802f69:	c3                   	ret    
  802f6a:	66 90                	xchg   %ax,%ax

00802f6c <__udivdi3>:
  802f6c:	55                   	push   %ebp
  802f6d:	57                   	push   %edi
  802f6e:	56                   	push   %esi
  802f6f:	53                   	push   %ebx
  802f70:	83 ec 1c             	sub    $0x1c,%esp
  802f73:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802f77:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802f7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802f7f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f83:	89 ca                	mov    %ecx,%edx
  802f85:	89 f8                	mov    %edi,%eax
  802f87:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802f8b:	85 f6                	test   %esi,%esi
  802f8d:	75 2d                	jne    802fbc <__udivdi3+0x50>
  802f8f:	39 cf                	cmp    %ecx,%edi
  802f91:	77 65                	ja     802ff8 <__udivdi3+0x8c>
  802f93:	89 fd                	mov    %edi,%ebp
  802f95:	85 ff                	test   %edi,%edi
  802f97:	75 0b                	jne    802fa4 <__udivdi3+0x38>
  802f99:	b8 01 00 00 00       	mov    $0x1,%eax
  802f9e:	31 d2                	xor    %edx,%edx
  802fa0:	f7 f7                	div    %edi
  802fa2:	89 c5                	mov    %eax,%ebp
  802fa4:	31 d2                	xor    %edx,%edx
  802fa6:	89 c8                	mov    %ecx,%eax
  802fa8:	f7 f5                	div    %ebp
  802faa:	89 c1                	mov    %eax,%ecx
  802fac:	89 d8                	mov    %ebx,%eax
  802fae:	f7 f5                	div    %ebp
  802fb0:	89 cf                	mov    %ecx,%edi
  802fb2:	89 fa                	mov    %edi,%edx
  802fb4:	83 c4 1c             	add    $0x1c,%esp
  802fb7:	5b                   	pop    %ebx
  802fb8:	5e                   	pop    %esi
  802fb9:	5f                   	pop    %edi
  802fba:	5d                   	pop    %ebp
  802fbb:	c3                   	ret    
  802fbc:	39 ce                	cmp    %ecx,%esi
  802fbe:	77 28                	ja     802fe8 <__udivdi3+0x7c>
  802fc0:	0f bd fe             	bsr    %esi,%edi
  802fc3:	83 f7 1f             	xor    $0x1f,%edi
  802fc6:	75 40                	jne    803008 <__udivdi3+0x9c>
  802fc8:	39 ce                	cmp    %ecx,%esi
  802fca:	72 0a                	jb     802fd6 <__udivdi3+0x6a>
  802fcc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802fd0:	0f 87 9e 00 00 00    	ja     803074 <__udivdi3+0x108>
  802fd6:	b8 01 00 00 00       	mov    $0x1,%eax
  802fdb:	89 fa                	mov    %edi,%edx
  802fdd:	83 c4 1c             	add    $0x1c,%esp
  802fe0:	5b                   	pop    %ebx
  802fe1:	5e                   	pop    %esi
  802fe2:	5f                   	pop    %edi
  802fe3:	5d                   	pop    %ebp
  802fe4:	c3                   	ret    
  802fe5:	8d 76 00             	lea    0x0(%esi),%esi
  802fe8:	31 ff                	xor    %edi,%edi
  802fea:	31 c0                	xor    %eax,%eax
  802fec:	89 fa                	mov    %edi,%edx
  802fee:	83 c4 1c             	add    $0x1c,%esp
  802ff1:	5b                   	pop    %ebx
  802ff2:	5e                   	pop    %esi
  802ff3:	5f                   	pop    %edi
  802ff4:	5d                   	pop    %ebp
  802ff5:	c3                   	ret    
  802ff6:	66 90                	xchg   %ax,%ax
  802ff8:	89 d8                	mov    %ebx,%eax
  802ffa:	f7 f7                	div    %edi
  802ffc:	31 ff                	xor    %edi,%edi
  802ffe:	89 fa                	mov    %edi,%edx
  803000:	83 c4 1c             	add    $0x1c,%esp
  803003:	5b                   	pop    %ebx
  803004:	5e                   	pop    %esi
  803005:	5f                   	pop    %edi
  803006:	5d                   	pop    %ebp
  803007:	c3                   	ret    
  803008:	bd 20 00 00 00       	mov    $0x20,%ebp
  80300d:	89 eb                	mov    %ebp,%ebx
  80300f:	29 fb                	sub    %edi,%ebx
  803011:	89 f9                	mov    %edi,%ecx
  803013:	d3 e6                	shl    %cl,%esi
  803015:	89 c5                	mov    %eax,%ebp
  803017:	88 d9                	mov    %bl,%cl
  803019:	d3 ed                	shr    %cl,%ebp
  80301b:	89 e9                	mov    %ebp,%ecx
  80301d:	09 f1                	or     %esi,%ecx
  80301f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803023:	89 f9                	mov    %edi,%ecx
  803025:	d3 e0                	shl    %cl,%eax
  803027:	89 c5                	mov    %eax,%ebp
  803029:	89 d6                	mov    %edx,%esi
  80302b:	88 d9                	mov    %bl,%cl
  80302d:	d3 ee                	shr    %cl,%esi
  80302f:	89 f9                	mov    %edi,%ecx
  803031:	d3 e2                	shl    %cl,%edx
  803033:	8b 44 24 08          	mov    0x8(%esp),%eax
  803037:	88 d9                	mov    %bl,%cl
  803039:	d3 e8                	shr    %cl,%eax
  80303b:	09 c2                	or     %eax,%edx
  80303d:	89 d0                	mov    %edx,%eax
  80303f:	89 f2                	mov    %esi,%edx
  803041:	f7 74 24 0c          	divl   0xc(%esp)
  803045:	89 d6                	mov    %edx,%esi
  803047:	89 c3                	mov    %eax,%ebx
  803049:	f7 e5                	mul    %ebp
  80304b:	39 d6                	cmp    %edx,%esi
  80304d:	72 19                	jb     803068 <__udivdi3+0xfc>
  80304f:	74 0b                	je     80305c <__udivdi3+0xf0>
  803051:	89 d8                	mov    %ebx,%eax
  803053:	31 ff                	xor    %edi,%edi
  803055:	e9 58 ff ff ff       	jmp    802fb2 <__udivdi3+0x46>
  80305a:	66 90                	xchg   %ax,%ax
  80305c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803060:	89 f9                	mov    %edi,%ecx
  803062:	d3 e2                	shl    %cl,%edx
  803064:	39 c2                	cmp    %eax,%edx
  803066:	73 e9                	jae    803051 <__udivdi3+0xe5>
  803068:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80306b:	31 ff                	xor    %edi,%edi
  80306d:	e9 40 ff ff ff       	jmp    802fb2 <__udivdi3+0x46>
  803072:	66 90                	xchg   %ax,%ax
  803074:	31 c0                	xor    %eax,%eax
  803076:	e9 37 ff ff ff       	jmp    802fb2 <__udivdi3+0x46>
  80307b:	90                   	nop

0080307c <__umoddi3>:
  80307c:	55                   	push   %ebp
  80307d:	57                   	push   %edi
  80307e:	56                   	push   %esi
  80307f:	53                   	push   %ebx
  803080:	83 ec 1c             	sub    $0x1c,%esp
  803083:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803087:	8b 74 24 34          	mov    0x34(%esp),%esi
  80308b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80308f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803093:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803097:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80309b:	89 f3                	mov    %esi,%ebx
  80309d:	89 fa                	mov    %edi,%edx
  80309f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8030a3:	89 34 24             	mov    %esi,(%esp)
  8030a6:	85 c0                	test   %eax,%eax
  8030a8:	75 1a                	jne    8030c4 <__umoddi3+0x48>
  8030aa:	39 f7                	cmp    %esi,%edi
  8030ac:	0f 86 a2 00 00 00    	jbe    803154 <__umoddi3+0xd8>
  8030b2:	89 c8                	mov    %ecx,%eax
  8030b4:	89 f2                	mov    %esi,%edx
  8030b6:	f7 f7                	div    %edi
  8030b8:	89 d0                	mov    %edx,%eax
  8030ba:	31 d2                	xor    %edx,%edx
  8030bc:	83 c4 1c             	add    $0x1c,%esp
  8030bf:	5b                   	pop    %ebx
  8030c0:	5e                   	pop    %esi
  8030c1:	5f                   	pop    %edi
  8030c2:	5d                   	pop    %ebp
  8030c3:	c3                   	ret    
  8030c4:	39 f0                	cmp    %esi,%eax
  8030c6:	0f 87 ac 00 00 00    	ja     803178 <__umoddi3+0xfc>
  8030cc:	0f bd e8             	bsr    %eax,%ebp
  8030cf:	83 f5 1f             	xor    $0x1f,%ebp
  8030d2:	0f 84 ac 00 00 00    	je     803184 <__umoddi3+0x108>
  8030d8:	bf 20 00 00 00       	mov    $0x20,%edi
  8030dd:	29 ef                	sub    %ebp,%edi
  8030df:	89 fe                	mov    %edi,%esi
  8030e1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8030e5:	89 e9                	mov    %ebp,%ecx
  8030e7:	d3 e0                	shl    %cl,%eax
  8030e9:	89 d7                	mov    %edx,%edi
  8030eb:	89 f1                	mov    %esi,%ecx
  8030ed:	d3 ef                	shr    %cl,%edi
  8030ef:	09 c7                	or     %eax,%edi
  8030f1:	89 e9                	mov    %ebp,%ecx
  8030f3:	d3 e2                	shl    %cl,%edx
  8030f5:	89 14 24             	mov    %edx,(%esp)
  8030f8:	89 d8                	mov    %ebx,%eax
  8030fa:	d3 e0                	shl    %cl,%eax
  8030fc:	89 c2                	mov    %eax,%edx
  8030fe:	8b 44 24 08          	mov    0x8(%esp),%eax
  803102:	d3 e0                	shl    %cl,%eax
  803104:	89 44 24 04          	mov    %eax,0x4(%esp)
  803108:	8b 44 24 08          	mov    0x8(%esp),%eax
  80310c:	89 f1                	mov    %esi,%ecx
  80310e:	d3 e8                	shr    %cl,%eax
  803110:	09 d0                	or     %edx,%eax
  803112:	d3 eb                	shr    %cl,%ebx
  803114:	89 da                	mov    %ebx,%edx
  803116:	f7 f7                	div    %edi
  803118:	89 d3                	mov    %edx,%ebx
  80311a:	f7 24 24             	mull   (%esp)
  80311d:	89 c6                	mov    %eax,%esi
  80311f:	89 d1                	mov    %edx,%ecx
  803121:	39 d3                	cmp    %edx,%ebx
  803123:	0f 82 87 00 00 00    	jb     8031b0 <__umoddi3+0x134>
  803129:	0f 84 91 00 00 00    	je     8031c0 <__umoddi3+0x144>
  80312f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803133:	29 f2                	sub    %esi,%edx
  803135:	19 cb                	sbb    %ecx,%ebx
  803137:	89 d8                	mov    %ebx,%eax
  803139:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80313d:	d3 e0                	shl    %cl,%eax
  80313f:	89 e9                	mov    %ebp,%ecx
  803141:	d3 ea                	shr    %cl,%edx
  803143:	09 d0                	or     %edx,%eax
  803145:	89 e9                	mov    %ebp,%ecx
  803147:	d3 eb                	shr    %cl,%ebx
  803149:	89 da                	mov    %ebx,%edx
  80314b:	83 c4 1c             	add    $0x1c,%esp
  80314e:	5b                   	pop    %ebx
  80314f:	5e                   	pop    %esi
  803150:	5f                   	pop    %edi
  803151:	5d                   	pop    %ebp
  803152:	c3                   	ret    
  803153:	90                   	nop
  803154:	89 fd                	mov    %edi,%ebp
  803156:	85 ff                	test   %edi,%edi
  803158:	75 0b                	jne    803165 <__umoddi3+0xe9>
  80315a:	b8 01 00 00 00       	mov    $0x1,%eax
  80315f:	31 d2                	xor    %edx,%edx
  803161:	f7 f7                	div    %edi
  803163:	89 c5                	mov    %eax,%ebp
  803165:	89 f0                	mov    %esi,%eax
  803167:	31 d2                	xor    %edx,%edx
  803169:	f7 f5                	div    %ebp
  80316b:	89 c8                	mov    %ecx,%eax
  80316d:	f7 f5                	div    %ebp
  80316f:	89 d0                	mov    %edx,%eax
  803171:	e9 44 ff ff ff       	jmp    8030ba <__umoddi3+0x3e>
  803176:	66 90                	xchg   %ax,%ax
  803178:	89 c8                	mov    %ecx,%eax
  80317a:	89 f2                	mov    %esi,%edx
  80317c:	83 c4 1c             	add    $0x1c,%esp
  80317f:	5b                   	pop    %ebx
  803180:	5e                   	pop    %esi
  803181:	5f                   	pop    %edi
  803182:	5d                   	pop    %ebp
  803183:	c3                   	ret    
  803184:	3b 04 24             	cmp    (%esp),%eax
  803187:	72 06                	jb     80318f <__umoddi3+0x113>
  803189:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80318d:	77 0f                	ja     80319e <__umoddi3+0x122>
  80318f:	89 f2                	mov    %esi,%edx
  803191:	29 f9                	sub    %edi,%ecx
  803193:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803197:	89 14 24             	mov    %edx,(%esp)
  80319a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80319e:	8b 44 24 04          	mov    0x4(%esp),%eax
  8031a2:	8b 14 24             	mov    (%esp),%edx
  8031a5:	83 c4 1c             	add    $0x1c,%esp
  8031a8:	5b                   	pop    %ebx
  8031a9:	5e                   	pop    %esi
  8031aa:	5f                   	pop    %edi
  8031ab:	5d                   	pop    %ebp
  8031ac:	c3                   	ret    
  8031ad:	8d 76 00             	lea    0x0(%esi),%esi
  8031b0:	2b 04 24             	sub    (%esp),%eax
  8031b3:	19 fa                	sbb    %edi,%edx
  8031b5:	89 d1                	mov    %edx,%ecx
  8031b7:	89 c6                	mov    %eax,%esi
  8031b9:	e9 71 ff ff ff       	jmp    80312f <__umoddi3+0xb3>
  8031be:	66 90                	xchg   %ax,%ax
  8031c0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8031c4:	72 ea                	jb     8031b0 <__umoddi3+0x134>
  8031c6:	89 d9                	mov    %ebx,%ecx
  8031c8:	e9 62 ff ff ff       	jmp    80312f <__umoddi3+0xb3>
