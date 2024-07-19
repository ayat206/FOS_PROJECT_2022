
obj/user/tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 2b 02 00 00       	call   800261 <libmain>
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
  800099:	e8 ff 02 00 00       	call   80039d <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 3b 15 00 00       	call   8015e3 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x,*y,*z;
	int32 parentenvID = sys_getparentenvid();
  8000ab:	e8 38 1c 00 00       	call   801ce8 <sys_getparentenvid>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000b3:	e8 24 1a 00 00       	call   801adc <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000b8:	e8 32 19 00 00       	call   8019ef <sys_calculate_free_frames>
  8000bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 17 32 80 00       	push   $0x803217
  8000c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000cb:	e8 0b 17 00 00       	call   8017db <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000d6:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 1c 32 80 00       	push   $0x80321c
  8000e7:	6a 20                	push   $0x20
  8000e9:	68 fc 31 80 00       	push   $0x8031fc
  8000ee:	e8 aa 02 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000f3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f6:	e8 f4 18 00 00       	call   8019ef <sys_calculate_free_frames>
  8000fb:	29 c3                	sub    %eax,%ebx
  8000fd:	89 d8                	mov    %ebx,%eax
  8000ff:	83 f8 01             	cmp    $0x1,%eax
  800102:	74 14                	je     800118 <_main+0xe0>
  800104:	83 ec 04             	sub    $0x4,%esp
  800107:	68 7c 32 80 00       	push   $0x80327c
  80010c:	6a 21                	push   $0x21
  80010e:	68 fc 31 80 00       	push   $0x8031fc
  800113:	e8 85 02 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  800118:	e8 d9 19 00 00       	call   801af6 <sys_enable_interrupt>

	sys_disable_interrupt();
  80011d:	e8 ba 19 00 00       	call   801adc <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800122:	e8 c8 18 00 00       	call   8019ef <sys_calculate_free_frames>
  800127:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	68 0d 33 80 00       	push   $0x80330d
  800132:	ff 75 ec             	pushl  -0x14(%ebp)
  800135:	e8 a1 16 00 00       	call   8017db <sget>
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800140:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800147:	74 14                	je     80015d <_main+0x125>
  800149:	83 ec 04             	sub    $0x4,%esp
  80014c:	68 1c 32 80 00       	push   $0x80321c
  800151:	6a 27                	push   $0x27
  800153:	68 fc 31 80 00       	push   $0x8031fc
  800158:	e8 40 02 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  80015d:	e8 8d 18 00 00       	call   8019ef <sys_calculate_free_frames>
  800162:	89 c2                	mov    %eax,%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	39 c2                	cmp    %eax,%edx
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 7c 32 80 00       	push   $0x80327c
  800173:	6a 28                	push   $0x28
  800175:	68 fc 31 80 00       	push   $0x8031fc
  80017a:	e8 1e 02 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  80017f:	e8 72 19 00 00       	call   801af6 <sys_enable_interrupt>

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800187:	8b 00                	mov    (%eax),%eax
  800189:	83 f8 14             	cmp    $0x14,%eax
  80018c:	74 14                	je     8001a2 <_main+0x16a>
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	68 10 33 80 00       	push   $0x803310
  800196:	6a 2b                	push   $0x2b
  800198:	68 fc 31 80 00       	push   $0x8031fc
  80019d:	e8 fb 01 00 00       	call   80039d <_panic>

	sys_disable_interrupt();
  8001a2:	e8 35 19 00 00       	call   801adc <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  8001a7:	e8 43 18 00 00       	call   8019ef <sys_calculate_free_frames>
  8001ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  8001af:	83 ec 08             	sub    $0x8,%esp
  8001b2:	68 47 33 80 00       	push   $0x803347
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	e8 1c 16 00 00       	call   8017db <sget>
  8001bf:	83 c4 10             	add    $0x10,%esp
  8001c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001c5:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001cc:	74 14                	je     8001e2 <_main+0x1aa>
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	68 1c 32 80 00       	push   $0x80321c
  8001d6:	6a 30                	push   $0x30
  8001d8:	68 fc 31 80 00       	push   $0x8031fc
  8001dd:	e8 bb 01 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001e2:	e8 08 18 00 00       	call   8019ef <sys_calculate_free_frames>
  8001e7:	89 c2                	mov    %eax,%edx
  8001e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ec:	39 c2                	cmp    %eax,%edx
  8001ee:	74 14                	je     800204 <_main+0x1cc>
  8001f0:	83 ec 04             	sub    $0x4,%esp
  8001f3:	68 7c 32 80 00       	push   $0x80327c
  8001f8:	6a 31                	push   $0x31
  8001fa:	68 fc 31 80 00       	push   $0x8031fc
  8001ff:	e8 99 01 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  800204:	e8 ed 18 00 00       	call   801af6 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  800209:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80020c:	8b 00                	mov    (%eax),%eax
  80020e:	83 f8 0a             	cmp    $0xa,%eax
  800211:	74 14                	je     800227 <_main+0x1ef>
  800213:	83 ec 04             	sub    $0x4,%esp
  800216:	68 10 33 80 00       	push   $0x803310
  80021b:	6a 34                	push   $0x34
  80021d:	68 fc 31 80 00       	push   $0x8031fc
  800222:	e8 76 01 00 00       	call   80039d <_panic>

	*z = *x + *y ;
  800227:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80022a:	8b 10                	mov    (%eax),%edx
  80022c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80022f:	8b 00                	mov    (%eax),%eax
  800231:	01 c2                	add    %eax,%edx
  800233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800236:	89 10                	mov    %edx,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  800238:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80023b:	8b 00                	mov    (%eax),%eax
  80023d:	83 f8 1e             	cmp    $0x1e,%eax
  800240:	74 14                	je     800256 <_main+0x21e>
  800242:	83 ec 04             	sub    $0x4,%esp
  800245:	68 10 33 80 00       	push   $0x803310
  80024a:	6a 37                	push   $0x37
  80024c:	68 fc 31 80 00       	push   $0x8031fc
  800251:	e8 47 01 00 00       	call   80039d <_panic>

	//To indicate that it's completed successfully
	inctst();
  800256:	e8 b2 1b 00 00       	call   801e0d <inctst>

	return;
  80025b:	90                   	nop
}
  80025c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80025f:	c9                   	leave  
  800260:	c3                   	ret    

00800261 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800261:	55                   	push   %ebp
  800262:	89 e5                	mov    %esp,%ebp
  800264:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800267:	e8 63 1a 00 00       	call   801ccf <sys_getenvindex>
  80026c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80026f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800272:	89 d0                	mov    %edx,%eax
  800274:	c1 e0 03             	shl    $0x3,%eax
  800277:	01 d0                	add    %edx,%eax
  800279:	01 c0                	add    %eax,%eax
  80027b:	01 d0                	add    %edx,%eax
  80027d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800284:	01 d0                	add    %edx,%eax
  800286:	c1 e0 04             	shl    $0x4,%eax
  800289:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80028e:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800293:	a1 20 40 80 00       	mov    0x804020,%eax
  800298:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80029e:	84 c0                	test   %al,%al
  8002a0:	74 0f                	je     8002b1 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8002a2:	a1 20 40 80 00       	mov    0x804020,%eax
  8002a7:	05 5c 05 00 00       	add    $0x55c,%eax
  8002ac:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002b5:	7e 0a                	jle    8002c1 <libmain+0x60>
		binaryname = argv[0];
  8002b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ba:	8b 00                	mov    (%eax),%eax
  8002bc:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	ff 75 0c             	pushl  0xc(%ebp)
  8002c7:	ff 75 08             	pushl  0x8(%ebp)
  8002ca:	e8 69 fd ff ff       	call   800038 <_main>
  8002cf:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002d2:	e8 05 18 00 00       	call   801adc <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 64 33 80 00       	push   $0x803364
  8002df:	e8 6d 03 00 00       	call   800651 <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ec:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002f2:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f7:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002fd:	83 ec 04             	sub    $0x4,%esp
  800300:	52                   	push   %edx
  800301:	50                   	push   %eax
  800302:	68 8c 33 80 00       	push   $0x80338c
  800307:	e8 45 03 00 00       	call   800651 <cprintf>
  80030c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80030f:	a1 20 40 80 00       	mov    0x804020,%eax
  800314:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80031a:	a1 20 40 80 00       	mov    0x804020,%eax
  80031f:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800325:	a1 20 40 80 00       	mov    0x804020,%eax
  80032a:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800330:	51                   	push   %ecx
  800331:	52                   	push   %edx
  800332:	50                   	push   %eax
  800333:	68 b4 33 80 00       	push   $0x8033b4
  800338:	e8 14 03 00 00       	call   800651 <cprintf>
  80033d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800340:	a1 20 40 80 00       	mov    0x804020,%eax
  800345:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80034b:	83 ec 08             	sub    $0x8,%esp
  80034e:	50                   	push   %eax
  80034f:	68 0c 34 80 00       	push   $0x80340c
  800354:	e8 f8 02 00 00       	call   800651 <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	68 64 33 80 00       	push   $0x803364
  800364:	e8 e8 02 00 00       	call   800651 <cprintf>
  800369:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80036c:	e8 85 17 00 00       	call   801af6 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800371:	e8 19 00 00 00       	call   80038f <exit>
}
  800376:	90                   	nop
  800377:	c9                   	leave  
  800378:	c3                   	ret    

00800379 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800379:	55                   	push   %ebp
  80037a:	89 e5                	mov    %esp,%ebp
  80037c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	6a 00                	push   $0x0
  800384:	e8 12 19 00 00       	call   801c9b <sys_destroy_env>
  800389:	83 c4 10             	add    $0x10,%esp
}
  80038c:	90                   	nop
  80038d:	c9                   	leave  
  80038e:	c3                   	ret    

0080038f <exit>:

void
exit(void)
{
  80038f:	55                   	push   %ebp
  800390:	89 e5                	mov    %esp,%ebp
  800392:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800395:	e8 67 19 00 00       	call   801d01 <sys_exit_env>
}
  80039a:	90                   	nop
  80039b:	c9                   	leave  
  80039c:	c3                   	ret    

0080039d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80039d:	55                   	push   %ebp
  80039e:	89 e5                	mov    %esp,%ebp
  8003a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8003a6:	83 c0 04             	add    $0x4,%eax
  8003a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003ac:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8003b1:	85 c0                	test   %eax,%eax
  8003b3:	74 16                	je     8003cb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003b5:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8003ba:	83 ec 08             	sub    $0x8,%esp
  8003bd:	50                   	push   %eax
  8003be:	68 20 34 80 00       	push   $0x803420
  8003c3:	e8 89 02 00 00       	call   800651 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003cb:	a1 00 40 80 00       	mov    0x804000,%eax
  8003d0:	ff 75 0c             	pushl  0xc(%ebp)
  8003d3:	ff 75 08             	pushl  0x8(%ebp)
  8003d6:	50                   	push   %eax
  8003d7:	68 25 34 80 00       	push   $0x803425
  8003dc:	e8 70 02 00 00       	call   800651 <cprintf>
  8003e1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e7:	83 ec 08             	sub    $0x8,%esp
  8003ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ed:	50                   	push   %eax
  8003ee:	e8 f3 01 00 00       	call   8005e6 <vcprintf>
  8003f3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003f6:	83 ec 08             	sub    $0x8,%esp
  8003f9:	6a 00                	push   $0x0
  8003fb:	68 41 34 80 00       	push   $0x803441
  800400:	e8 e1 01 00 00       	call   8005e6 <vcprintf>
  800405:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800408:	e8 82 ff ff ff       	call   80038f <exit>

	// should not return here
	while (1) ;
  80040d:	eb fe                	jmp    80040d <_panic+0x70>

0080040f <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80040f:	55                   	push   %ebp
  800410:	89 e5                	mov    %esp,%ebp
  800412:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800415:	a1 20 40 80 00       	mov    0x804020,%eax
  80041a:	8b 50 74             	mov    0x74(%eax),%edx
  80041d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800420:	39 c2                	cmp    %eax,%edx
  800422:	74 14                	je     800438 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800424:	83 ec 04             	sub    $0x4,%esp
  800427:	68 44 34 80 00       	push   $0x803444
  80042c:	6a 26                	push   $0x26
  80042e:	68 90 34 80 00       	push   $0x803490
  800433:	e8 65 ff ff ff       	call   80039d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800438:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80043f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800446:	e9 c2 00 00 00       	jmp    80050d <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80044b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80044e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800455:	8b 45 08             	mov    0x8(%ebp),%eax
  800458:	01 d0                	add    %edx,%eax
  80045a:	8b 00                	mov    (%eax),%eax
  80045c:	85 c0                	test   %eax,%eax
  80045e:	75 08                	jne    800468 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800460:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800463:	e9 a2 00 00 00       	jmp    80050a <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800468:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800476:	eb 69                	jmp    8004e1 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800478:	a1 20 40 80 00       	mov    0x804020,%eax
  80047d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800483:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800486:	89 d0                	mov    %edx,%eax
  800488:	01 c0                	add    %eax,%eax
  80048a:	01 d0                	add    %edx,%eax
  80048c:	c1 e0 03             	shl    $0x3,%eax
  80048f:	01 c8                	add    %ecx,%eax
  800491:	8a 40 04             	mov    0x4(%eax),%al
  800494:	84 c0                	test   %al,%al
  800496:	75 46                	jne    8004de <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800498:	a1 20 40 80 00       	mov    0x804020,%eax
  80049d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004a6:	89 d0                	mov    %edx,%eax
  8004a8:	01 c0                	add    %eax,%eax
  8004aa:	01 d0                	add    %edx,%eax
  8004ac:	c1 e0 03             	shl    $0x3,%eax
  8004af:	01 c8                	add    %ecx,%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004be:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cd:	01 c8                	add    %ecx,%eax
  8004cf:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004d1:	39 c2                	cmp    %eax,%edx
  8004d3:	75 09                	jne    8004de <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004d5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004dc:	eb 12                	jmp    8004f0 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004de:	ff 45 e8             	incl   -0x18(%ebp)
  8004e1:	a1 20 40 80 00       	mov    0x804020,%eax
  8004e6:	8b 50 74             	mov    0x74(%eax),%edx
  8004e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004ec:	39 c2                	cmp    %eax,%edx
  8004ee:	77 88                	ja     800478 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004f4:	75 14                	jne    80050a <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004f6:	83 ec 04             	sub    $0x4,%esp
  8004f9:	68 9c 34 80 00       	push   $0x80349c
  8004fe:	6a 3a                	push   $0x3a
  800500:	68 90 34 80 00       	push   $0x803490
  800505:	e8 93 fe ff ff       	call   80039d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80050a:	ff 45 f0             	incl   -0x10(%ebp)
  80050d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800510:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800513:	0f 8c 32 ff ff ff    	jl     80044b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800519:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800520:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800527:	eb 26                	jmp    80054f <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800529:	a1 20 40 80 00       	mov    0x804020,%eax
  80052e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800534:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800537:	89 d0                	mov    %edx,%eax
  800539:	01 c0                	add    %eax,%eax
  80053b:	01 d0                	add    %edx,%eax
  80053d:	c1 e0 03             	shl    $0x3,%eax
  800540:	01 c8                	add    %ecx,%eax
  800542:	8a 40 04             	mov    0x4(%eax),%al
  800545:	3c 01                	cmp    $0x1,%al
  800547:	75 03                	jne    80054c <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800549:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80054c:	ff 45 e0             	incl   -0x20(%ebp)
  80054f:	a1 20 40 80 00       	mov    0x804020,%eax
  800554:	8b 50 74             	mov    0x74(%eax),%edx
  800557:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80055a:	39 c2                	cmp    %eax,%edx
  80055c:	77 cb                	ja     800529 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80055e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800561:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800564:	74 14                	je     80057a <CheckWSWithoutLastIndex+0x16b>
		panic(
  800566:	83 ec 04             	sub    $0x4,%esp
  800569:	68 f0 34 80 00       	push   $0x8034f0
  80056e:	6a 44                	push   $0x44
  800570:	68 90 34 80 00       	push   $0x803490
  800575:	e8 23 fe ff ff       	call   80039d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80057a:	90                   	nop
  80057b:	c9                   	leave  
  80057c:	c3                   	ret    

0080057d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80057d:	55                   	push   %ebp
  80057e:	89 e5                	mov    %esp,%ebp
  800580:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800583:	8b 45 0c             	mov    0xc(%ebp),%eax
  800586:	8b 00                	mov    (%eax),%eax
  800588:	8d 48 01             	lea    0x1(%eax),%ecx
  80058b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058e:	89 0a                	mov    %ecx,(%edx)
  800590:	8b 55 08             	mov    0x8(%ebp),%edx
  800593:	88 d1                	mov    %dl,%cl
  800595:	8b 55 0c             	mov    0xc(%ebp),%edx
  800598:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80059c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005a6:	75 2c                	jne    8005d4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005a8:	a0 24 40 80 00       	mov    0x804024,%al
  8005ad:	0f b6 c0             	movzbl %al,%eax
  8005b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005b3:	8b 12                	mov    (%edx),%edx
  8005b5:	89 d1                	mov    %edx,%ecx
  8005b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ba:	83 c2 08             	add    $0x8,%edx
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	50                   	push   %eax
  8005c1:	51                   	push   %ecx
  8005c2:	52                   	push   %edx
  8005c3:	e8 66 13 00 00       	call   80192e <sys_cputs>
  8005c8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d7:	8b 40 04             	mov    0x4(%eax),%eax
  8005da:	8d 50 01             	lea    0x1(%eax),%edx
  8005dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e0:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005e3:	90                   	nop
  8005e4:	c9                   	leave  
  8005e5:	c3                   	ret    

008005e6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005e6:	55                   	push   %ebp
  8005e7:	89 e5                	mov    %esp,%ebp
  8005e9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005ef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005f6:	00 00 00 
	b.cnt = 0;
  8005f9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800600:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800603:	ff 75 0c             	pushl  0xc(%ebp)
  800606:	ff 75 08             	pushl  0x8(%ebp)
  800609:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80060f:	50                   	push   %eax
  800610:	68 7d 05 80 00       	push   $0x80057d
  800615:	e8 11 02 00 00       	call   80082b <vprintfmt>
  80061a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80061d:	a0 24 40 80 00       	mov    0x804024,%al
  800622:	0f b6 c0             	movzbl %al,%eax
  800625:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80062b:	83 ec 04             	sub    $0x4,%esp
  80062e:	50                   	push   %eax
  80062f:	52                   	push   %edx
  800630:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800636:	83 c0 08             	add    $0x8,%eax
  800639:	50                   	push   %eax
  80063a:	e8 ef 12 00 00       	call   80192e <sys_cputs>
  80063f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800642:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800649:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80064f:	c9                   	leave  
  800650:	c3                   	ret    

00800651 <cprintf>:

int cprintf(const char *fmt, ...) {
  800651:	55                   	push   %ebp
  800652:	89 e5                	mov    %esp,%ebp
  800654:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800657:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80065e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800661:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	ff 75 f4             	pushl  -0xc(%ebp)
  80066d:	50                   	push   %eax
  80066e:	e8 73 ff ff ff       	call   8005e6 <vcprintf>
  800673:	83 c4 10             	add    $0x10,%esp
  800676:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800679:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    

0080067e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
  800681:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800684:	e8 53 14 00 00       	call   801adc <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800689:	8d 45 0c             	lea    0xc(%ebp),%eax
  80068c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	83 ec 08             	sub    $0x8,%esp
  800695:	ff 75 f4             	pushl  -0xc(%ebp)
  800698:	50                   	push   %eax
  800699:	e8 48 ff ff ff       	call   8005e6 <vcprintf>
  80069e:	83 c4 10             	add    $0x10,%esp
  8006a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006a4:	e8 4d 14 00 00       	call   801af6 <sys_enable_interrupt>
	return cnt;
  8006a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006ac:	c9                   	leave  
  8006ad:	c3                   	ret    

008006ae <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006ae:	55                   	push   %ebp
  8006af:	89 e5                	mov    %esp,%ebp
  8006b1:	53                   	push   %ebx
  8006b2:	83 ec 14             	sub    $0x14,%esp
  8006b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8006b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006c1:	8b 45 18             	mov    0x18(%ebp),%eax
  8006c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006cc:	77 55                	ja     800723 <printnum+0x75>
  8006ce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006d1:	72 05                	jb     8006d8 <printnum+0x2a>
  8006d3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006d6:	77 4b                	ja     800723 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006d8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006db:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006de:	8b 45 18             	mov    0x18(%ebp),%eax
  8006e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e6:	52                   	push   %edx
  8006e7:	50                   	push   %eax
  8006e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8006eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8006ee:	e8 85 28 00 00       	call   802f78 <__udivdi3>
  8006f3:	83 c4 10             	add    $0x10,%esp
  8006f6:	83 ec 04             	sub    $0x4,%esp
  8006f9:	ff 75 20             	pushl  0x20(%ebp)
  8006fc:	53                   	push   %ebx
  8006fd:	ff 75 18             	pushl  0x18(%ebp)
  800700:	52                   	push   %edx
  800701:	50                   	push   %eax
  800702:	ff 75 0c             	pushl  0xc(%ebp)
  800705:	ff 75 08             	pushl  0x8(%ebp)
  800708:	e8 a1 ff ff ff       	call   8006ae <printnum>
  80070d:	83 c4 20             	add    $0x20,%esp
  800710:	eb 1a                	jmp    80072c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800712:	83 ec 08             	sub    $0x8,%esp
  800715:	ff 75 0c             	pushl  0xc(%ebp)
  800718:	ff 75 20             	pushl  0x20(%ebp)
  80071b:	8b 45 08             	mov    0x8(%ebp),%eax
  80071e:	ff d0                	call   *%eax
  800720:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800723:	ff 4d 1c             	decl   0x1c(%ebp)
  800726:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80072a:	7f e6                	jg     800712 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80072c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80072f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800734:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800737:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80073a:	53                   	push   %ebx
  80073b:	51                   	push   %ecx
  80073c:	52                   	push   %edx
  80073d:	50                   	push   %eax
  80073e:	e8 45 29 00 00       	call   803088 <__umoddi3>
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	05 54 37 80 00       	add    $0x803754,%eax
  80074b:	8a 00                	mov    (%eax),%al
  80074d:	0f be c0             	movsbl %al,%eax
  800750:	83 ec 08             	sub    $0x8,%esp
  800753:	ff 75 0c             	pushl  0xc(%ebp)
  800756:	50                   	push   %eax
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	ff d0                	call   *%eax
  80075c:	83 c4 10             	add    $0x10,%esp
}
  80075f:	90                   	nop
  800760:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800768:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80076c:	7e 1c                	jle    80078a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	8d 50 08             	lea    0x8(%eax),%edx
  800776:	8b 45 08             	mov    0x8(%ebp),%eax
  800779:	89 10                	mov    %edx,(%eax)
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	83 e8 08             	sub    $0x8,%eax
  800783:	8b 50 04             	mov    0x4(%eax),%edx
  800786:	8b 00                	mov    (%eax),%eax
  800788:	eb 40                	jmp    8007ca <getuint+0x65>
	else if (lflag)
  80078a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80078e:	74 1e                	je     8007ae <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	8b 00                	mov    (%eax),%eax
  800795:	8d 50 04             	lea    0x4(%eax),%edx
  800798:	8b 45 08             	mov    0x8(%ebp),%eax
  80079b:	89 10                	mov    %edx,(%eax)
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	8b 00                	mov    (%eax),%eax
  8007a2:	83 e8 04             	sub    $0x4,%eax
  8007a5:	8b 00                	mov    (%eax),%eax
  8007a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ac:	eb 1c                	jmp    8007ca <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	8d 50 04             	lea    0x4(%eax),%edx
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	89 10                	mov    %edx,(%eax)
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	83 e8 04             	sub    $0x4,%eax
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007ca:	5d                   	pop    %ebp
  8007cb:	c3                   	ret    

008007cc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007cf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007d3:	7e 1c                	jle    8007f1 <getint+0x25>
		return va_arg(*ap, long long);
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	8d 50 08             	lea    0x8(%eax),%edx
  8007dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e0:	89 10                	mov    %edx,(%eax)
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	83 e8 08             	sub    $0x8,%eax
  8007ea:	8b 50 04             	mov    0x4(%eax),%edx
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	eb 38                	jmp    800829 <getint+0x5d>
	else if (lflag)
  8007f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007f5:	74 1a                	je     800811 <getint+0x45>
		return va_arg(*ap, long);
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	8b 00                	mov    (%eax),%eax
  8007fc:	8d 50 04             	lea    0x4(%eax),%edx
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	89 10                	mov    %edx,(%eax)
  800804:	8b 45 08             	mov    0x8(%ebp),%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	83 e8 04             	sub    $0x4,%eax
  80080c:	8b 00                	mov    (%eax),%eax
  80080e:	99                   	cltd   
  80080f:	eb 18                	jmp    800829 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	8b 00                	mov    (%eax),%eax
  800816:	8d 50 04             	lea    0x4(%eax),%edx
  800819:	8b 45 08             	mov    0x8(%ebp),%eax
  80081c:	89 10                	mov    %edx,(%eax)
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	8b 00                	mov    (%eax),%eax
  800823:	83 e8 04             	sub    $0x4,%eax
  800826:	8b 00                	mov    (%eax),%eax
  800828:	99                   	cltd   
}
  800829:	5d                   	pop    %ebp
  80082a:	c3                   	ret    

0080082b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	56                   	push   %esi
  80082f:	53                   	push   %ebx
  800830:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800833:	eb 17                	jmp    80084c <vprintfmt+0x21>
			if (ch == '\0')
  800835:	85 db                	test   %ebx,%ebx
  800837:	0f 84 af 03 00 00    	je     800bec <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	53                   	push   %ebx
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	ff d0                	call   *%eax
  800849:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80084c:	8b 45 10             	mov    0x10(%ebp),%eax
  80084f:	8d 50 01             	lea    0x1(%eax),%edx
  800852:	89 55 10             	mov    %edx,0x10(%ebp)
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f b6 d8             	movzbl %al,%ebx
  80085a:	83 fb 25             	cmp    $0x25,%ebx
  80085d:	75 d6                	jne    800835 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80085f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800863:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80086a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800871:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800878:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80087f:	8b 45 10             	mov    0x10(%ebp),%eax
  800882:	8d 50 01             	lea    0x1(%eax),%edx
  800885:	89 55 10             	mov    %edx,0x10(%ebp)
  800888:	8a 00                	mov    (%eax),%al
  80088a:	0f b6 d8             	movzbl %al,%ebx
  80088d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800890:	83 f8 55             	cmp    $0x55,%eax
  800893:	0f 87 2b 03 00 00    	ja     800bc4 <vprintfmt+0x399>
  800899:	8b 04 85 78 37 80 00 	mov    0x803778(,%eax,4),%eax
  8008a0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008a2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008a6:	eb d7                	jmp    80087f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008a8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008ac:	eb d1                	jmp    80087f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008b8:	89 d0                	mov    %edx,%eax
  8008ba:	c1 e0 02             	shl    $0x2,%eax
  8008bd:	01 d0                	add    %edx,%eax
  8008bf:	01 c0                	add    %eax,%eax
  8008c1:	01 d8                	add    %ebx,%eax
  8008c3:	83 e8 30             	sub    $0x30,%eax
  8008c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008cc:	8a 00                	mov    (%eax),%al
  8008ce:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008d1:	83 fb 2f             	cmp    $0x2f,%ebx
  8008d4:	7e 3e                	jle    800914 <vprintfmt+0xe9>
  8008d6:	83 fb 39             	cmp    $0x39,%ebx
  8008d9:	7f 39                	jg     800914 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008db:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008de:	eb d5                	jmp    8008b5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	83 c0 04             	add    $0x4,%eax
  8008e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ec:	83 e8 04             	sub    $0x4,%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008f4:	eb 1f                	jmp    800915 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008fa:	79 83                	jns    80087f <vprintfmt+0x54>
				width = 0;
  8008fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800903:	e9 77 ff ff ff       	jmp    80087f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800908:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80090f:	e9 6b ff ff ff       	jmp    80087f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800914:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800915:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800919:	0f 89 60 ff ff ff    	jns    80087f <vprintfmt+0x54>
				width = precision, precision = -1;
  80091f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800922:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800925:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80092c:	e9 4e ff ff ff       	jmp    80087f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800931:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800934:	e9 46 ff ff ff       	jmp    80087f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800939:	8b 45 14             	mov    0x14(%ebp),%eax
  80093c:	83 c0 04             	add    $0x4,%eax
  80093f:	89 45 14             	mov    %eax,0x14(%ebp)
  800942:	8b 45 14             	mov    0x14(%ebp),%eax
  800945:	83 e8 04             	sub    $0x4,%eax
  800948:	8b 00                	mov    (%eax),%eax
  80094a:	83 ec 08             	sub    $0x8,%esp
  80094d:	ff 75 0c             	pushl  0xc(%ebp)
  800950:	50                   	push   %eax
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	ff d0                	call   *%eax
  800956:	83 c4 10             	add    $0x10,%esp
			break;
  800959:	e9 89 02 00 00       	jmp    800be7 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80095e:	8b 45 14             	mov    0x14(%ebp),%eax
  800961:	83 c0 04             	add    $0x4,%eax
  800964:	89 45 14             	mov    %eax,0x14(%ebp)
  800967:	8b 45 14             	mov    0x14(%ebp),%eax
  80096a:	83 e8 04             	sub    $0x4,%eax
  80096d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80096f:	85 db                	test   %ebx,%ebx
  800971:	79 02                	jns    800975 <vprintfmt+0x14a>
				err = -err;
  800973:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800975:	83 fb 64             	cmp    $0x64,%ebx
  800978:	7f 0b                	jg     800985 <vprintfmt+0x15a>
  80097a:	8b 34 9d c0 35 80 00 	mov    0x8035c0(,%ebx,4),%esi
  800981:	85 f6                	test   %esi,%esi
  800983:	75 19                	jne    80099e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800985:	53                   	push   %ebx
  800986:	68 65 37 80 00       	push   $0x803765
  80098b:	ff 75 0c             	pushl  0xc(%ebp)
  80098e:	ff 75 08             	pushl  0x8(%ebp)
  800991:	e8 5e 02 00 00       	call   800bf4 <printfmt>
  800996:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800999:	e9 49 02 00 00       	jmp    800be7 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80099e:	56                   	push   %esi
  80099f:	68 6e 37 80 00       	push   $0x80376e
  8009a4:	ff 75 0c             	pushl  0xc(%ebp)
  8009a7:	ff 75 08             	pushl  0x8(%ebp)
  8009aa:	e8 45 02 00 00       	call   800bf4 <printfmt>
  8009af:	83 c4 10             	add    $0x10,%esp
			break;
  8009b2:	e9 30 02 00 00       	jmp    800be7 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ba:	83 c0 04             	add    $0x4,%eax
  8009bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c3:	83 e8 04             	sub    $0x4,%eax
  8009c6:	8b 30                	mov    (%eax),%esi
  8009c8:	85 f6                	test   %esi,%esi
  8009ca:	75 05                	jne    8009d1 <vprintfmt+0x1a6>
				p = "(null)";
  8009cc:	be 71 37 80 00       	mov    $0x803771,%esi
			if (width > 0 && padc != '-')
  8009d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d5:	7e 6d                	jle    800a44 <vprintfmt+0x219>
  8009d7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009db:	74 67                	je     800a44 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	50                   	push   %eax
  8009e4:	56                   	push   %esi
  8009e5:	e8 0c 03 00 00       	call   800cf6 <strnlen>
  8009ea:	83 c4 10             	add    $0x10,%esp
  8009ed:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009f0:	eb 16                	jmp    800a08 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009f2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009f6:	83 ec 08             	sub    $0x8,%esp
  8009f9:	ff 75 0c             	pushl  0xc(%ebp)
  8009fc:	50                   	push   %eax
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	ff d0                	call   *%eax
  800a02:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a05:	ff 4d e4             	decl   -0x1c(%ebp)
  800a08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a0c:	7f e4                	jg     8009f2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0e:	eb 34                	jmp    800a44 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a10:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a14:	74 1c                	je     800a32 <vprintfmt+0x207>
  800a16:	83 fb 1f             	cmp    $0x1f,%ebx
  800a19:	7e 05                	jle    800a20 <vprintfmt+0x1f5>
  800a1b:	83 fb 7e             	cmp    $0x7e,%ebx
  800a1e:	7e 12                	jle    800a32 <vprintfmt+0x207>
					putch('?', putdat);
  800a20:	83 ec 08             	sub    $0x8,%esp
  800a23:	ff 75 0c             	pushl  0xc(%ebp)
  800a26:	6a 3f                	push   $0x3f
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	ff d0                	call   *%eax
  800a2d:	83 c4 10             	add    $0x10,%esp
  800a30:	eb 0f                	jmp    800a41 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a32:	83 ec 08             	sub    $0x8,%esp
  800a35:	ff 75 0c             	pushl  0xc(%ebp)
  800a38:	53                   	push   %ebx
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	ff d0                	call   *%eax
  800a3e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a41:	ff 4d e4             	decl   -0x1c(%ebp)
  800a44:	89 f0                	mov    %esi,%eax
  800a46:	8d 70 01             	lea    0x1(%eax),%esi
  800a49:	8a 00                	mov    (%eax),%al
  800a4b:	0f be d8             	movsbl %al,%ebx
  800a4e:	85 db                	test   %ebx,%ebx
  800a50:	74 24                	je     800a76 <vprintfmt+0x24b>
  800a52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a56:	78 b8                	js     800a10 <vprintfmt+0x1e5>
  800a58:	ff 4d e0             	decl   -0x20(%ebp)
  800a5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a5f:	79 af                	jns    800a10 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a61:	eb 13                	jmp    800a76 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	ff 75 0c             	pushl  0xc(%ebp)
  800a69:	6a 20                	push   $0x20
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	ff d0                	call   *%eax
  800a70:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a73:	ff 4d e4             	decl   -0x1c(%ebp)
  800a76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a7a:	7f e7                	jg     800a63 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a7c:	e9 66 01 00 00       	jmp    800be7 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a81:	83 ec 08             	sub    $0x8,%esp
  800a84:	ff 75 e8             	pushl  -0x18(%ebp)
  800a87:	8d 45 14             	lea    0x14(%ebp),%eax
  800a8a:	50                   	push   %eax
  800a8b:	e8 3c fd ff ff       	call   8007cc <getint>
  800a90:	83 c4 10             	add    $0x10,%esp
  800a93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a9f:	85 d2                	test   %edx,%edx
  800aa1:	79 23                	jns    800ac6 <vprintfmt+0x29b>
				putch('-', putdat);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 0c             	pushl  0xc(%ebp)
  800aa9:	6a 2d                	push   $0x2d
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	ff d0                	call   *%eax
  800ab0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ab6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ab9:	f7 d8                	neg    %eax
  800abb:	83 d2 00             	adc    $0x0,%edx
  800abe:	f7 da                	neg    %edx
  800ac0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ac6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800acd:	e9 bc 00 00 00       	jmp    800b8e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ad2:	83 ec 08             	sub    $0x8,%esp
  800ad5:	ff 75 e8             	pushl  -0x18(%ebp)
  800ad8:	8d 45 14             	lea    0x14(%ebp),%eax
  800adb:	50                   	push   %eax
  800adc:	e8 84 fc ff ff       	call   800765 <getuint>
  800ae1:	83 c4 10             	add    $0x10,%esp
  800ae4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800aea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800af1:	e9 98 00 00 00       	jmp    800b8e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800af6:	83 ec 08             	sub    $0x8,%esp
  800af9:	ff 75 0c             	pushl  0xc(%ebp)
  800afc:	6a 58                	push   $0x58
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	ff d0                	call   *%eax
  800b03:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b06:	83 ec 08             	sub    $0x8,%esp
  800b09:	ff 75 0c             	pushl  0xc(%ebp)
  800b0c:	6a 58                	push   $0x58
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	ff d0                	call   *%eax
  800b13:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b16:	83 ec 08             	sub    $0x8,%esp
  800b19:	ff 75 0c             	pushl  0xc(%ebp)
  800b1c:	6a 58                	push   $0x58
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	ff d0                	call   *%eax
  800b23:	83 c4 10             	add    $0x10,%esp
			break;
  800b26:	e9 bc 00 00 00       	jmp    800be7 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b2b:	83 ec 08             	sub    $0x8,%esp
  800b2e:	ff 75 0c             	pushl  0xc(%ebp)
  800b31:	6a 30                	push   $0x30
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	ff d0                	call   *%eax
  800b38:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b3b:	83 ec 08             	sub    $0x8,%esp
  800b3e:	ff 75 0c             	pushl  0xc(%ebp)
  800b41:	6a 78                	push   $0x78
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4e:	83 c0 04             	add    $0x4,%eax
  800b51:	89 45 14             	mov    %eax,0x14(%ebp)
  800b54:	8b 45 14             	mov    0x14(%ebp),%eax
  800b57:	83 e8 04             	sub    $0x4,%eax
  800b5a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b66:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b6d:	eb 1f                	jmp    800b8e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	ff 75 e8             	pushl  -0x18(%ebp)
  800b75:	8d 45 14             	lea    0x14(%ebp),%eax
  800b78:	50                   	push   %eax
  800b79:	e8 e7 fb ff ff       	call   800765 <getuint>
  800b7e:	83 c4 10             	add    $0x10,%esp
  800b81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b84:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b87:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b8e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b95:	83 ec 04             	sub    $0x4,%esp
  800b98:	52                   	push   %edx
  800b99:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b9c:	50                   	push   %eax
  800b9d:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba0:	ff 75 f0             	pushl  -0x10(%ebp)
  800ba3:	ff 75 0c             	pushl  0xc(%ebp)
  800ba6:	ff 75 08             	pushl  0x8(%ebp)
  800ba9:	e8 00 fb ff ff       	call   8006ae <printnum>
  800bae:	83 c4 20             	add    $0x20,%esp
			break;
  800bb1:	eb 34                	jmp    800be7 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bb3:	83 ec 08             	sub    $0x8,%esp
  800bb6:	ff 75 0c             	pushl  0xc(%ebp)
  800bb9:	53                   	push   %ebx
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	ff d0                	call   *%eax
  800bbf:	83 c4 10             	add    $0x10,%esp
			break;
  800bc2:	eb 23                	jmp    800be7 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bc4:	83 ec 08             	sub    $0x8,%esp
  800bc7:	ff 75 0c             	pushl  0xc(%ebp)
  800bca:	6a 25                	push   $0x25
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	ff d0                	call   *%eax
  800bd1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bd4:	ff 4d 10             	decl   0x10(%ebp)
  800bd7:	eb 03                	jmp    800bdc <vprintfmt+0x3b1>
  800bd9:	ff 4d 10             	decl   0x10(%ebp)
  800bdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800bdf:	48                   	dec    %eax
  800be0:	8a 00                	mov    (%eax),%al
  800be2:	3c 25                	cmp    $0x25,%al
  800be4:	75 f3                	jne    800bd9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800be6:	90                   	nop
		}
	}
  800be7:	e9 47 fc ff ff       	jmp    800833 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bec:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bf0:	5b                   	pop    %ebx
  800bf1:	5e                   	pop    %esi
  800bf2:	5d                   	pop    %ebp
  800bf3:	c3                   	ret    

00800bf4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bfa:	8d 45 10             	lea    0x10(%ebp),%eax
  800bfd:	83 c0 04             	add    $0x4,%eax
  800c00:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c03:	8b 45 10             	mov    0x10(%ebp),%eax
  800c06:	ff 75 f4             	pushl  -0xc(%ebp)
  800c09:	50                   	push   %eax
  800c0a:	ff 75 0c             	pushl  0xc(%ebp)
  800c0d:	ff 75 08             	pushl  0x8(%ebp)
  800c10:	e8 16 fc ff ff       	call   80082b <vprintfmt>
  800c15:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c18:	90                   	nop
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    

00800c1b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c21:	8b 40 08             	mov    0x8(%eax),%eax
  800c24:	8d 50 01             	lea    0x1(%eax),%edx
  800c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c30:	8b 10                	mov    (%eax),%edx
  800c32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c35:	8b 40 04             	mov    0x4(%eax),%eax
  800c38:	39 c2                	cmp    %eax,%edx
  800c3a:	73 12                	jae    800c4e <sprintputch+0x33>
		*b->buf++ = ch;
  800c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3f:	8b 00                	mov    (%eax),%eax
  800c41:	8d 48 01             	lea    0x1(%eax),%ecx
  800c44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c47:	89 0a                	mov    %ecx,(%edx)
  800c49:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4c:	88 10                	mov    %dl,(%eax)
}
  800c4e:	90                   	nop
  800c4f:	5d                   	pop    %ebp
  800c50:	c3                   	ret    

00800c51 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	01 d0                	add    %edx,%eax
  800c68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c76:	74 06                	je     800c7e <vsnprintf+0x2d>
  800c78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c7c:	7f 07                	jg     800c85 <vsnprintf+0x34>
		return -E_INVAL;
  800c7e:	b8 03 00 00 00       	mov    $0x3,%eax
  800c83:	eb 20                	jmp    800ca5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c85:	ff 75 14             	pushl  0x14(%ebp)
  800c88:	ff 75 10             	pushl  0x10(%ebp)
  800c8b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c8e:	50                   	push   %eax
  800c8f:	68 1b 0c 80 00       	push   $0x800c1b
  800c94:	e8 92 fb ff ff       	call   80082b <vprintfmt>
  800c99:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c9f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ca5:	c9                   	leave  
  800ca6:	c3                   	ret    

00800ca7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cad:	8d 45 10             	lea    0x10(%ebp),%eax
  800cb0:	83 c0 04             	add    $0x4,%eax
  800cb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb9:	ff 75 f4             	pushl  -0xc(%ebp)
  800cbc:	50                   	push   %eax
  800cbd:	ff 75 0c             	pushl  0xc(%ebp)
  800cc0:	ff 75 08             	pushl  0x8(%ebp)
  800cc3:	e8 89 ff ff ff       	call   800c51 <vsnprintf>
  800cc8:	83 c4 10             	add    $0x10,%esp
  800ccb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cd1:	c9                   	leave  
  800cd2:	c3                   	ret    

00800cd3 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cd9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce0:	eb 06                	jmp    800ce8 <strlen+0x15>
		n++;
  800ce2:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ce5:	ff 45 08             	incl   0x8(%ebp)
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	84 c0                	test   %al,%al
  800cef:	75 f1                	jne    800ce2 <strlen+0xf>
		n++;
	return n;
  800cf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf4:	c9                   	leave  
  800cf5:	c3                   	ret    

00800cf6 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cfc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d03:	eb 09                	jmp    800d0e <strnlen+0x18>
		n++;
  800d05:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d08:	ff 45 08             	incl   0x8(%ebp)
  800d0b:	ff 4d 0c             	decl   0xc(%ebp)
  800d0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d12:	74 09                	je     800d1d <strnlen+0x27>
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	84 c0                	test   %al,%al
  800d1b:	75 e8                	jne    800d05 <strnlen+0xf>
		n++;
	return n;
  800d1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d20:	c9                   	leave  
  800d21:	c3                   	ret    

00800d22 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d2e:	90                   	nop
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	8d 50 01             	lea    0x1(%eax),%edx
  800d35:	89 55 08             	mov    %edx,0x8(%ebp)
  800d38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d41:	8a 12                	mov    (%edx),%dl
  800d43:	88 10                	mov    %dl,(%eax)
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	84 c0                	test   %al,%al
  800d49:	75 e4                	jne    800d2f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d4e:	c9                   	leave  
  800d4f:	c3                   	ret    

00800d50 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d63:	eb 1f                	jmp    800d84 <strncpy+0x34>
		*dst++ = *src;
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8d 50 01             	lea    0x1(%eax),%edx
  800d6b:	89 55 08             	mov    %edx,0x8(%ebp)
  800d6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d71:	8a 12                	mov    (%edx),%dl
  800d73:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	8a 00                	mov    (%eax),%al
  800d7a:	84 c0                	test   %al,%al
  800d7c:	74 03                	je     800d81 <strncpy+0x31>
			src++;
  800d7e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d81:	ff 45 fc             	incl   -0x4(%ebp)
  800d84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d87:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d8a:	72 d9                	jb     800d65 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d8f:	c9                   	leave  
  800d90:	c3                   	ret    

00800d91 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da1:	74 30                	je     800dd3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800da3:	eb 16                	jmp    800dbb <strlcpy+0x2a>
			*dst++ = *src++;
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	8d 50 01             	lea    0x1(%eax),%edx
  800dab:	89 55 08             	mov    %edx,0x8(%ebp)
  800dae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800db7:	8a 12                	mov    (%edx),%dl
  800db9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dbb:	ff 4d 10             	decl   0x10(%ebp)
  800dbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc2:	74 09                	je     800dcd <strlcpy+0x3c>
  800dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc7:	8a 00                	mov    (%eax),%al
  800dc9:	84 c0                	test   %al,%al
  800dcb:	75 d8                	jne    800da5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd9:	29 c2                	sub    %eax,%edx
  800ddb:	89 d0                	mov    %edx,%eax
}
  800ddd:	c9                   	leave  
  800dde:	c3                   	ret    

00800ddf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800de2:	eb 06                	jmp    800dea <strcmp+0xb>
		p++, q++;
  800de4:	ff 45 08             	incl   0x8(%ebp)
  800de7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	84 c0                	test   %al,%al
  800df1:	74 0e                	je     800e01 <strcmp+0x22>
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
  800df6:	8a 10                	mov    (%eax),%dl
  800df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	38 c2                	cmp    %al,%dl
  800dff:	74 e3                	je     800de4 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8a 00                	mov    (%eax),%al
  800e06:	0f b6 d0             	movzbl %al,%edx
  800e09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0c:	8a 00                	mov    (%eax),%al
  800e0e:	0f b6 c0             	movzbl %al,%eax
  800e11:	29 c2                	sub    %eax,%edx
  800e13:	89 d0                	mov    %edx,%eax
}
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    

00800e17 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e1a:	eb 09                	jmp    800e25 <strncmp+0xe>
		n--, p++, q++;
  800e1c:	ff 4d 10             	decl   0x10(%ebp)
  800e1f:	ff 45 08             	incl   0x8(%ebp)
  800e22:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e29:	74 17                	je     800e42 <strncmp+0x2b>
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	8a 00                	mov    (%eax),%al
  800e30:	84 c0                	test   %al,%al
  800e32:	74 0e                	je     800e42 <strncmp+0x2b>
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	8a 10                	mov    (%eax),%dl
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	38 c2                	cmp    %al,%dl
  800e40:	74 da                	je     800e1c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e46:	75 07                	jne    800e4f <strncmp+0x38>
		return 0;
  800e48:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4d:	eb 14                	jmp    800e63 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	0f b6 d0             	movzbl %al,%edx
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	0f b6 c0             	movzbl %al,%eax
  800e5f:	29 c2                	sub    %eax,%edx
  800e61:	89 d0                	mov    %edx,%eax
}
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    

00800e65 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	83 ec 04             	sub    $0x4,%esp
  800e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e71:	eb 12                	jmp    800e85 <strchr+0x20>
		if (*s == c)
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	8a 00                	mov    (%eax),%al
  800e78:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e7b:	75 05                	jne    800e82 <strchr+0x1d>
			return (char *) s;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	eb 11                	jmp    800e93 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e82:	ff 45 08             	incl   0x8(%ebp)
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	8a 00                	mov    (%eax),%al
  800e8a:	84 c0                	test   %al,%al
  800e8c:	75 e5                	jne    800e73 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e93:	c9                   	leave  
  800e94:	c3                   	ret    

00800e95 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	83 ec 04             	sub    $0x4,%esp
  800e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ea1:	eb 0d                	jmp    800eb0 <strfind+0x1b>
		if (*s == c)
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eab:	74 0e                	je     800ebb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ead:	ff 45 08             	incl   0x8(%ebp)
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	84 c0                	test   %al,%al
  800eb7:	75 ea                	jne    800ea3 <strfind+0xe>
  800eb9:	eb 01                	jmp    800ebc <strfind+0x27>
		if (*s == c)
			break;
  800ebb:	90                   	nop
	return (char *) s;
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebf:	c9                   	leave  
  800ec0:	c3                   	ret    

00800ec1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
  800ec4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ecd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ed3:	eb 0e                	jmp    800ee3 <memset+0x22>
		*p++ = c;
  800ed5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed8:	8d 50 01             	lea    0x1(%eax),%edx
  800edb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ede:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee1:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ee3:	ff 4d f8             	decl   -0x8(%ebp)
  800ee6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800eea:	79 e9                	jns    800ed5 <memset+0x14>
		*p++ = c;

	return v;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eef:	c9                   	leave  
  800ef0:	c3                   	ret    

00800ef1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f03:	eb 16                	jmp    800f1b <memcpy+0x2a>
		*d++ = *s++;
  800f05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f08:	8d 50 01             	lea    0x1(%eax),%edx
  800f0b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f0e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f11:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f14:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f17:	8a 12                	mov    (%edx),%dl
  800f19:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f21:	89 55 10             	mov    %edx,0x10(%ebp)
  800f24:	85 c0                	test   %eax,%eax
  800f26:	75 dd                	jne    800f05 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f2b:	c9                   	leave  
  800f2c:	c3                   	ret    

00800f2d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f36:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f45:	73 50                	jae    800f97 <memmove+0x6a>
  800f47:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4d:	01 d0                	add    %edx,%eax
  800f4f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f52:	76 43                	jbe    800f97 <memmove+0x6a>
		s += n;
  800f54:	8b 45 10             	mov    0x10(%ebp),%eax
  800f57:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f60:	eb 10                	jmp    800f72 <memmove+0x45>
			*--d = *--s;
  800f62:	ff 4d f8             	decl   -0x8(%ebp)
  800f65:	ff 4d fc             	decl   -0x4(%ebp)
  800f68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f6b:	8a 10                	mov    (%eax),%dl
  800f6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f70:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f72:	8b 45 10             	mov    0x10(%ebp),%eax
  800f75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f78:	89 55 10             	mov    %edx,0x10(%ebp)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	75 e3                	jne    800f62 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f7f:	eb 23                	jmp    800fa4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f84:	8d 50 01             	lea    0x1(%eax),%edx
  800f87:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f8d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f90:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f93:	8a 12                	mov    (%edx),%dl
  800f95:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f97:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800fa0:	85 c0                	test   %eax,%eax
  800fa2:	75 dd                	jne    800f81 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa7:	c9                   	leave  
  800fa8:	c3                   	ret    

00800fa9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fa9:	55                   	push   %ebp
  800faa:	89 e5                	mov    %esp,%ebp
  800fac:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fbb:	eb 2a                	jmp    800fe7 <memcmp+0x3e>
		if (*s1 != *s2)
  800fbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc0:	8a 10                	mov    (%eax),%dl
  800fc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc5:	8a 00                	mov    (%eax),%al
  800fc7:	38 c2                	cmp    %al,%dl
  800fc9:	74 16                	je     800fe1 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fce:	8a 00                	mov    (%eax),%al
  800fd0:	0f b6 d0             	movzbl %al,%edx
  800fd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd6:	8a 00                	mov    (%eax),%al
  800fd8:	0f b6 c0             	movzbl %al,%eax
  800fdb:	29 c2                	sub    %eax,%edx
  800fdd:	89 d0                	mov    %edx,%eax
  800fdf:	eb 18                	jmp    800ff9 <memcmp+0x50>
		s1++, s2++;
  800fe1:	ff 45 fc             	incl   -0x4(%ebp)
  800fe4:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fe7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fea:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fed:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff0:	85 c0                	test   %eax,%eax
  800ff2:	75 c9                	jne    800fbd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ff4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff9:	c9                   	leave  
  800ffa:	c3                   	ret    

00800ffb <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801001:	8b 55 08             	mov    0x8(%ebp),%edx
  801004:	8b 45 10             	mov    0x10(%ebp),%eax
  801007:	01 d0                	add    %edx,%eax
  801009:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80100c:	eb 15                	jmp    801023 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	0f b6 d0             	movzbl %al,%edx
  801016:	8b 45 0c             	mov    0xc(%ebp),%eax
  801019:	0f b6 c0             	movzbl %al,%eax
  80101c:	39 c2                	cmp    %eax,%edx
  80101e:	74 0d                	je     80102d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801020:	ff 45 08             	incl   0x8(%ebp)
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801029:	72 e3                	jb     80100e <memfind+0x13>
  80102b:	eb 01                	jmp    80102e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80102d:	90                   	nop
	return (void *) s;
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801031:	c9                   	leave  
  801032:	c3                   	ret    

00801033 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801039:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801040:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801047:	eb 03                	jmp    80104c <strtol+0x19>
		s++;
  801049:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	8a 00                	mov    (%eax),%al
  801051:	3c 20                	cmp    $0x20,%al
  801053:	74 f4                	je     801049 <strtol+0x16>
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	8a 00                	mov    (%eax),%al
  80105a:	3c 09                	cmp    $0x9,%al
  80105c:	74 eb                	je     801049 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	8a 00                	mov    (%eax),%al
  801063:	3c 2b                	cmp    $0x2b,%al
  801065:	75 05                	jne    80106c <strtol+0x39>
		s++;
  801067:	ff 45 08             	incl   0x8(%ebp)
  80106a:	eb 13                	jmp    80107f <strtol+0x4c>
	else if (*s == '-')
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	3c 2d                	cmp    $0x2d,%al
  801073:	75 0a                	jne    80107f <strtol+0x4c>
		s++, neg = 1;
  801075:	ff 45 08             	incl   0x8(%ebp)
  801078:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80107f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801083:	74 06                	je     80108b <strtol+0x58>
  801085:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801089:	75 20                	jne    8010ab <strtol+0x78>
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	8a 00                	mov    (%eax),%al
  801090:	3c 30                	cmp    $0x30,%al
  801092:	75 17                	jne    8010ab <strtol+0x78>
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	40                   	inc    %eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	3c 78                	cmp    $0x78,%al
  80109c:	75 0d                	jne    8010ab <strtol+0x78>
		s += 2, base = 16;
  80109e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010a2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010a9:	eb 28                	jmp    8010d3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010af:	75 15                	jne    8010c6 <strtol+0x93>
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	8a 00                	mov    (%eax),%al
  8010b6:	3c 30                	cmp    $0x30,%al
  8010b8:	75 0c                	jne    8010c6 <strtol+0x93>
		s++, base = 8;
  8010ba:	ff 45 08             	incl   0x8(%ebp)
  8010bd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010c4:	eb 0d                	jmp    8010d3 <strtol+0xa0>
	else if (base == 0)
  8010c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ca:	75 07                	jne    8010d3 <strtol+0xa0>
		base = 10;
  8010cc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	3c 2f                	cmp    $0x2f,%al
  8010da:	7e 19                	jle    8010f5 <strtol+0xc2>
  8010dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010df:	8a 00                	mov    (%eax),%al
  8010e1:	3c 39                	cmp    $0x39,%al
  8010e3:	7f 10                	jg     8010f5 <strtol+0xc2>
			dig = *s - '0';
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	8a 00                	mov    (%eax),%al
  8010ea:	0f be c0             	movsbl %al,%eax
  8010ed:	83 e8 30             	sub    $0x30,%eax
  8010f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010f3:	eb 42                	jmp    801137 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	8a 00                	mov    (%eax),%al
  8010fa:	3c 60                	cmp    $0x60,%al
  8010fc:	7e 19                	jle    801117 <strtol+0xe4>
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	8a 00                	mov    (%eax),%al
  801103:	3c 7a                	cmp    $0x7a,%al
  801105:	7f 10                	jg     801117 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	8a 00                	mov    (%eax),%al
  80110c:	0f be c0             	movsbl %al,%eax
  80110f:	83 e8 57             	sub    $0x57,%eax
  801112:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801115:	eb 20                	jmp    801137 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	3c 40                	cmp    $0x40,%al
  80111e:	7e 39                	jle    801159 <strtol+0x126>
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	3c 5a                	cmp    $0x5a,%al
  801127:	7f 30                	jg     801159 <strtol+0x126>
			dig = *s - 'A' + 10;
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	8a 00                	mov    (%eax),%al
  80112e:	0f be c0             	movsbl %al,%eax
  801131:	83 e8 37             	sub    $0x37,%eax
  801134:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80113a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80113d:	7d 19                	jge    801158 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80113f:	ff 45 08             	incl   0x8(%ebp)
  801142:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801145:	0f af 45 10          	imul   0x10(%ebp),%eax
  801149:	89 c2                	mov    %eax,%edx
  80114b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80114e:	01 d0                	add    %edx,%eax
  801150:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801153:	e9 7b ff ff ff       	jmp    8010d3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801158:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801159:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80115d:	74 08                	je     801167 <strtol+0x134>
		*endptr = (char *) s;
  80115f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801162:	8b 55 08             	mov    0x8(%ebp),%edx
  801165:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801167:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80116b:	74 07                	je     801174 <strtol+0x141>
  80116d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801170:	f7 d8                	neg    %eax
  801172:	eb 03                	jmp    801177 <strtol+0x144>
  801174:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801177:	c9                   	leave  
  801178:	c3                   	ret    

00801179 <ltostr>:

void
ltostr(long value, char *str)
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
  80117c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80117f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801186:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80118d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801191:	79 13                	jns    8011a6 <ltostr+0x2d>
	{
		neg = 1;
  801193:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80119a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011a0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011a3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011ae:	99                   	cltd   
  8011af:	f7 f9                	idiv   %ecx
  8011b1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011bd:	89 c2                	mov    %eax,%edx
  8011bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c2:	01 d0                	add    %edx,%eax
  8011c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011c7:	83 c2 30             	add    $0x30,%edx
  8011ca:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011cf:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011d4:	f7 e9                	imul   %ecx
  8011d6:	c1 fa 02             	sar    $0x2,%edx
  8011d9:	89 c8                	mov    %ecx,%eax
  8011db:	c1 f8 1f             	sar    $0x1f,%eax
  8011de:	29 c2                	sub    %eax,%edx
  8011e0:	89 d0                	mov    %edx,%eax
  8011e2:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011e8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ed:	f7 e9                	imul   %ecx
  8011ef:	c1 fa 02             	sar    $0x2,%edx
  8011f2:	89 c8                	mov    %ecx,%eax
  8011f4:	c1 f8 1f             	sar    $0x1f,%eax
  8011f7:	29 c2                	sub    %eax,%edx
  8011f9:	89 d0                	mov    %edx,%eax
  8011fb:	c1 e0 02             	shl    $0x2,%eax
  8011fe:	01 d0                	add    %edx,%eax
  801200:	01 c0                	add    %eax,%eax
  801202:	29 c1                	sub    %eax,%ecx
  801204:	89 ca                	mov    %ecx,%edx
  801206:	85 d2                	test   %edx,%edx
  801208:	75 9c                	jne    8011a6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80120a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801211:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801214:	48                   	dec    %eax
  801215:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801218:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80121c:	74 3d                	je     80125b <ltostr+0xe2>
		start = 1 ;
  80121e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801225:	eb 34                	jmp    80125b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801227:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	01 d0                	add    %edx,%eax
  80122f:	8a 00                	mov    (%eax),%al
  801231:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801234:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	01 c2                	add    %eax,%edx
  80123c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80123f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801242:	01 c8                	add    %ecx,%eax
  801244:	8a 00                	mov    (%eax),%al
  801246:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801248:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80124b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124e:	01 c2                	add    %eax,%edx
  801250:	8a 45 eb             	mov    -0x15(%ebp),%al
  801253:	88 02                	mov    %al,(%edx)
		start++ ;
  801255:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801258:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80125b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801261:	7c c4                	jl     801227 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801263:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801266:	8b 45 0c             	mov    0xc(%ebp),%eax
  801269:	01 d0                	add    %edx,%eax
  80126b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80126e:	90                   	nop
  80126f:	c9                   	leave  
  801270:	c3                   	ret    

00801271 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801277:	ff 75 08             	pushl  0x8(%ebp)
  80127a:	e8 54 fa ff ff       	call   800cd3 <strlen>
  80127f:	83 c4 04             	add    $0x4,%esp
  801282:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801285:	ff 75 0c             	pushl  0xc(%ebp)
  801288:	e8 46 fa ff ff       	call   800cd3 <strlen>
  80128d:	83 c4 04             	add    $0x4,%esp
  801290:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801293:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80129a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012a1:	eb 17                	jmp    8012ba <strcconcat+0x49>
		final[s] = str1[s] ;
  8012a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a9:	01 c2                	add    %eax,%edx
  8012ab:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	01 c8                	add    %ecx,%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012b7:	ff 45 fc             	incl   -0x4(%ebp)
  8012ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012c0:	7c e1                	jl     8012a3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012c2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012c9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012d0:	eb 1f                	jmp    8012f1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d5:	8d 50 01             	lea    0x1(%eax),%edx
  8012d8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012db:	89 c2                	mov    %eax,%edx
  8012dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e0:	01 c2                	add    %eax,%edx
  8012e2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e8:	01 c8                	add    %ecx,%eax
  8012ea:	8a 00                	mov    (%eax),%al
  8012ec:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012ee:	ff 45 f8             	incl   -0x8(%ebp)
  8012f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012f7:	7c d9                	jl     8012d2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ff:	01 d0                	add    %edx,%eax
  801301:	c6 00 00             	movb   $0x0,(%eax)
}
  801304:	90                   	nop
  801305:	c9                   	leave  
  801306:	c3                   	ret    

00801307 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80130a:	8b 45 14             	mov    0x14(%ebp),%eax
  80130d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801313:	8b 45 14             	mov    0x14(%ebp),%eax
  801316:	8b 00                	mov    (%eax),%eax
  801318:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80131f:	8b 45 10             	mov    0x10(%ebp),%eax
  801322:	01 d0                	add    %edx,%eax
  801324:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80132a:	eb 0c                	jmp    801338 <strsplit+0x31>
			*string++ = 0;
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	8d 50 01             	lea    0x1(%eax),%edx
  801332:	89 55 08             	mov    %edx,0x8(%ebp)
  801335:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
  80133b:	8a 00                	mov    (%eax),%al
  80133d:	84 c0                	test   %al,%al
  80133f:	74 18                	je     801359 <strsplit+0x52>
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	8a 00                	mov    (%eax),%al
  801346:	0f be c0             	movsbl %al,%eax
  801349:	50                   	push   %eax
  80134a:	ff 75 0c             	pushl  0xc(%ebp)
  80134d:	e8 13 fb ff ff       	call   800e65 <strchr>
  801352:	83 c4 08             	add    $0x8,%esp
  801355:	85 c0                	test   %eax,%eax
  801357:	75 d3                	jne    80132c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	84 c0                	test   %al,%al
  801360:	74 5a                	je     8013bc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801362:	8b 45 14             	mov    0x14(%ebp),%eax
  801365:	8b 00                	mov    (%eax),%eax
  801367:	83 f8 0f             	cmp    $0xf,%eax
  80136a:	75 07                	jne    801373 <strsplit+0x6c>
		{
			return 0;
  80136c:	b8 00 00 00 00       	mov    $0x0,%eax
  801371:	eb 66                	jmp    8013d9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801373:	8b 45 14             	mov    0x14(%ebp),%eax
  801376:	8b 00                	mov    (%eax),%eax
  801378:	8d 48 01             	lea    0x1(%eax),%ecx
  80137b:	8b 55 14             	mov    0x14(%ebp),%edx
  80137e:	89 0a                	mov    %ecx,(%edx)
  801380:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801387:	8b 45 10             	mov    0x10(%ebp),%eax
  80138a:	01 c2                	add    %eax,%edx
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801391:	eb 03                	jmp    801396 <strsplit+0x8f>
			string++;
  801393:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	8a 00                	mov    (%eax),%al
  80139b:	84 c0                	test   %al,%al
  80139d:	74 8b                	je     80132a <strsplit+0x23>
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	8a 00                	mov    (%eax),%al
  8013a4:	0f be c0             	movsbl %al,%eax
  8013a7:	50                   	push   %eax
  8013a8:	ff 75 0c             	pushl  0xc(%ebp)
  8013ab:	e8 b5 fa ff ff       	call   800e65 <strchr>
  8013b0:	83 c4 08             	add    $0x8,%esp
  8013b3:	85 c0                	test   %eax,%eax
  8013b5:	74 dc                	je     801393 <strsplit+0x8c>
			string++;
	}
  8013b7:	e9 6e ff ff ff       	jmp    80132a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013bc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c0:	8b 00                	mov    (%eax),%eax
  8013c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cc:	01 d0                	add    %edx,%eax
  8013ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013d4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013d9:	c9                   	leave  
  8013da:	c3                   	ret    

008013db <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
  8013de:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013e1:	a1 04 40 80 00       	mov    0x804004,%eax
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	74 1f                	je     801409 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013ea:	e8 1d 00 00 00       	call   80140c <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013ef:	83 ec 0c             	sub    $0xc,%esp
  8013f2:	68 d0 38 80 00       	push   $0x8038d0
  8013f7:	e8 55 f2 ff ff       	call   800651 <cprintf>
  8013fc:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013ff:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801406:	00 00 00 
	}
}
  801409:	90                   	nop
  80140a:	c9                   	leave  
  80140b:	c3                   	ret    

0080140c <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801412:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801419:	00 00 00 
  80141c:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801423:	00 00 00 
  801426:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80142d:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801430:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801437:	00 00 00 
  80143a:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801441:	00 00 00 
  801444:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80144b:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  80144e:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801455:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801458:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80145f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801462:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801467:	2d 00 10 00 00       	sub    $0x1000,%eax
  80146c:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  801471:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801478:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80147b:	a1 20 41 80 00       	mov    0x804120,%eax
  801480:	0f af c2             	imul   %edx,%eax
  801483:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801486:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  80148d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801490:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801493:	01 d0                	add    %edx,%eax
  801495:	48                   	dec    %eax
  801496:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801499:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80149c:	ba 00 00 00 00       	mov    $0x0,%edx
  8014a1:	f7 75 e8             	divl   -0x18(%ebp)
  8014a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014a7:	29 d0                	sub    %edx,%eax
  8014a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  8014ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014af:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  8014b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014b9:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8014bf:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8014c5:	83 ec 04             	sub    $0x4,%esp
  8014c8:	6a 06                	push   $0x6
  8014ca:	50                   	push   %eax
  8014cb:	52                   	push   %edx
  8014cc:	e8 a1 05 00 00       	call   801a72 <sys_allocate_chunk>
  8014d1:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014d4:	a1 20 41 80 00       	mov    0x804120,%eax
  8014d9:	83 ec 0c             	sub    $0xc,%esp
  8014dc:	50                   	push   %eax
  8014dd:	e8 16 0c 00 00       	call   8020f8 <initialize_MemBlocksList>
  8014e2:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  8014e5:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8014ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  8014ed:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8014f1:	75 14                	jne    801507 <initialize_dyn_block_system+0xfb>
  8014f3:	83 ec 04             	sub    $0x4,%esp
  8014f6:	68 f5 38 80 00       	push   $0x8038f5
  8014fb:	6a 2d                	push   $0x2d
  8014fd:	68 13 39 80 00       	push   $0x803913
  801502:	e8 96 ee ff ff       	call   80039d <_panic>
  801507:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80150a:	8b 00                	mov    (%eax),%eax
  80150c:	85 c0                	test   %eax,%eax
  80150e:	74 10                	je     801520 <initialize_dyn_block_system+0x114>
  801510:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801513:	8b 00                	mov    (%eax),%eax
  801515:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801518:	8b 52 04             	mov    0x4(%edx),%edx
  80151b:	89 50 04             	mov    %edx,0x4(%eax)
  80151e:	eb 0b                	jmp    80152b <initialize_dyn_block_system+0x11f>
  801520:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801523:	8b 40 04             	mov    0x4(%eax),%eax
  801526:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80152b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80152e:	8b 40 04             	mov    0x4(%eax),%eax
  801531:	85 c0                	test   %eax,%eax
  801533:	74 0f                	je     801544 <initialize_dyn_block_system+0x138>
  801535:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801538:	8b 40 04             	mov    0x4(%eax),%eax
  80153b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80153e:	8b 12                	mov    (%edx),%edx
  801540:	89 10                	mov    %edx,(%eax)
  801542:	eb 0a                	jmp    80154e <initialize_dyn_block_system+0x142>
  801544:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801547:	8b 00                	mov    (%eax),%eax
  801549:	a3 48 41 80 00       	mov    %eax,0x804148
  80154e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801551:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801557:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80155a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801561:	a1 54 41 80 00       	mov    0x804154,%eax
  801566:	48                   	dec    %eax
  801567:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  80156c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80156f:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801576:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801579:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801580:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801584:	75 14                	jne    80159a <initialize_dyn_block_system+0x18e>
  801586:	83 ec 04             	sub    $0x4,%esp
  801589:	68 20 39 80 00       	push   $0x803920
  80158e:	6a 30                	push   $0x30
  801590:	68 13 39 80 00       	push   $0x803913
  801595:	e8 03 ee ff ff       	call   80039d <_panic>
  80159a:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8015a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015a3:	89 50 04             	mov    %edx,0x4(%eax)
  8015a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015a9:	8b 40 04             	mov    0x4(%eax),%eax
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	74 0c                	je     8015bc <initialize_dyn_block_system+0x1b0>
  8015b0:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8015b5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8015b8:	89 10                	mov    %edx,(%eax)
  8015ba:	eb 08                	jmp    8015c4 <initialize_dyn_block_system+0x1b8>
  8015bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015bf:	a3 38 41 80 00       	mov    %eax,0x804138
  8015c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015c7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8015cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015d5:	a1 44 41 80 00       	mov    0x804144,%eax
  8015da:	40                   	inc    %eax
  8015db:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8015e0:	90                   	nop
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015e9:	e8 ed fd ff ff       	call   8013db <InitializeUHeap>
	if (size == 0) return NULL ;
  8015ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015f2:	75 07                	jne    8015fb <malloc+0x18>
  8015f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f9:	eb 67                	jmp    801662 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  8015fb:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801602:	8b 55 08             	mov    0x8(%ebp),%edx
  801605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801608:	01 d0                	add    %edx,%eax
  80160a:	48                   	dec    %eax
  80160b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80160e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801611:	ba 00 00 00 00       	mov    $0x0,%edx
  801616:	f7 75 f4             	divl   -0xc(%ebp)
  801619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161c:	29 d0                	sub    %edx,%eax
  80161e:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801621:	e8 1a 08 00 00       	call   801e40 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801626:	85 c0                	test   %eax,%eax
  801628:	74 33                	je     80165d <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  80162a:	83 ec 0c             	sub    $0xc,%esp
  80162d:	ff 75 08             	pushl  0x8(%ebp)
  801630:	e8 0c 0e 00 00       	call   802441 <alloc_block_FF>
  801635:	83 c4 10             	add    $0x10,%esp
  801638:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  80163b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80163f:	74 1c                	je     80165d <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801641:	83 ec 0c             	sub    $0xc,%esp
  801644:	ff 75 ec             	pushl  -0x14(%ebp)
  801647:	e8 07 0c 00 00       	call   802253 <insert_sorted_allocList>
  80164c:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  80164f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801652:	8b 40 08             	mov    0x8(%eax),%eax
  801655:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801658:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80165b:	eb 05                	jmp    801662 <malloc+0x7f>
		}
	}
	return NULL;
  80165d:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801662:	c9                   	leave  
  801663:	c3                   	ret    

00801664 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
  801667:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801670:	83 ec 08             	sub    $0x8,%esp
  801673:	ff 75 f4             	pushl  -0xc(%ebp)
  801676:	68 40 40 80 00       	push   $0x804040
  80167b:	e8 5b 0b 00 00       	call   8021db <find_block>
  801680:	83 c4 10             	add    $0x10,%esp
  801683:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801686:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801689:	8b 40 0c             	mov    0xc(%eax),%eax
  80168c:	83 ec 08             	sub    $0x8,%esp
  80168f:	50                   	push   %eax
  801690:	ff 75 f4             	pushl  -0xc(%ebp)
  801693:	e8 a2 03 00 00       	call   801a3a <sys_free_user_mem>
  801698:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  80169b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80169f:	75 14                	jne    8016b5 <free+0x51>
  8016a1:	83 ec 04             	sub    $0x4,%esp
  8016a4:	68 f5 38 80 00       	push   $0x8038f5
  8016a9:	6a 76                	push   $0x76
  8016ab:	68 13 39 80 00       	push   $0x803913
  8016b0:	e8 e8 ec ff ff       	call   80039d <_panic>
  8016b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b8:	8b 00                	mov    (%eax),%eax
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	74 10                	je     8016ce <free+0x6a>
  8016be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c1:	8b 00                	mov    (%eax),%eax
  8016c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016c6:	8b 52 04             	mov    0x4(%edx),%edx
  8016c9:	89 50 04             	mov    %edx,0x4(%eax)
  8016cc:	eb 0b                	jmp    8016d9 <free+0x75>
  8016ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d1:	8b 40 04             	mov    0x4(%eax),%eax
  8016d4:	a3 44 40 80 00       	mov    %eax,0x804044
  8016d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016dc:	8b 40 04             	mov    0x4(%eax),%eax
  8016df:	85 c0                	test   %eax,%eax
  8016e1:	74 0f                	je     8016f2 <free+0x8e>
  8016e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e6:	8b 40 04             	mov    0x4(%eax),%eax
  8016e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016ec:	8b 12                	mov    (%edx),%edx
  8016ee:	89 10                	mov    %edx,(%eax)
  8016f0:	eb 0a                	jmp    8016fc <free+0x98>
  8016f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f5:	8b 00                	mov    (%eax),%eax
  8016f7:	a3 40 40 80 00       	mov    %eax,0x804040
  8016fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801708:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80170f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801714:	48                   	dec    %eax
  801715:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  80171a:	83 ec 0c             	sub    $0xc,%esp
  80171d:	ff 75 f0             	pushl  -0x10(%ebp)
  801720:	e8 0b 14 00 00       	call   802b30 <insert_sorted_with_merge_freeList>
  801725:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801728:	90                   	nop
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
  80172e:	83 ec 28             	sub    $0x28,%esp
  801731:	8b 45 10             	mov    0x10(%ebp),%eax
  801734:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801737:	e8 9f fc ff ff       	call   8013db <InitializeUHeap>
	if (size == 0) return NULL ;
  80173c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801740:	75 0a                	jne    80174c <smalloc+0x21>
  801742:	b8 00 00 00 00       	mov    $0x0,%eax
  801747:	e9 8d 00 00 00       	jmp    8017d9 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  80174c:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801753:	8b 55 0c             	mov    0xc(%ebp),%edx
  801756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801759:	01 d0                	add    %edx,%eax
  80175b:	48                   	dec    %eax
  80175c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80175f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801762:	ba 00 00 00 00       	mov    $0x0,%edx
  801767:	f7 75 f4             	divl   -0xc(%ebp)
  80176a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176d:	29 d0                	sub    %edx,%eax
  80176f:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801772:	e8 c9 06 00 00       	call   801e40 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801777:	85 c0                	test   %eax,%eax
  801779:	74 59                	je     8017d4 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  80177b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801782:	83 ec 0c             	sub    $0xc,%esp
  801785:	ff 75 0c             	pushl  0xc(%ebp)
  801788:	e8 b4 0c 00 00       	call   802441 <alloc_block_FF>
  80178d:	83 c4 10             	add    $0x10,%esp
  801790:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801793:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801797:	75 07                	jne    8017a0 <smalloc+0x75>
			{
				return NULL;
  801799:	b8 00 00 00 00       	mov    $0x0,%eax
  80179e:	eb 39                	jmp    8017d9 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  8017a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a3:	8b 40 08             	mov    0x8(%eax),%eax
  8017a6:	89 c2                	mov    %eax,%edx
  8017a8:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8017ac:	52                   	push   %edx
  8017ad:	50                   	push   %eax
  8017ae:	ff 75 0c             	pushl  0xc(%ebp)
  8017b1:	ff 75 08             	pushl  0x8(%ebp)
  8017b4:	e8 0c 04 00 00       	call   801bc5 <sys_createSharedObject>
  8017b9:	83 c4 10             	add    $0x10,%esp
  8017bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  8017bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8017c3:	78 08                	js     8017cd <smalloc+0xa2>
				{
					return (void*)v1->sva;
  8017c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c8:	8b 40 08             	mov    0x8(%eax),%eax
  8017cb:	eb 0c                	jmp    8017d9 <smalloc+0xae>
				}
				else
				{
					return NULL;
  8017cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d2:	eb 05                	jmp    8017d9 <smalloc+0xae>
				}
			}

		}
		return NULL;
  8017d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017e1:	e8 f5 fb ff ff       	call   8013db <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017e6:	83 ec 08             	sub    $0x8,%esp
  8017e9:	ff 75 0c             	pushl  0xc(%ebp)
  8017ec:	ff 75 08             	pushl  0x8(%ebp)
  8017ef:	e8 fb 03 00 00       	call   801bef <sys_getSizeOfSharedObject>
  8017f4:	83 c4 10             	add    $0x10,%esp
  8017f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  8017fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017fe:	75 07                	jne    801807 <sget+0x2c>
	{
		return NULL;
  801800:	b8 00 00 00 00       	mov    $0x0,%eax
  801805:	eb 64                	jmp    80186b <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801807:	e8 34 06 00 00       	call   801e40 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80180c:	85 c0                	test   %eax,%eax
  80180e:	74 56                	je     801866 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801810:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181a:	83 ec 0c             	sub    $0xc,%esp
  80181d:	50                   	push   %eax
  80181e:	e8 1e 0c 00 00       	call   802441 <alloc_block_FF>
  801823:	83 c4 10             	add    $0x10,%esp
  801826:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801829:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80182d:	75 07                	jne    801836 <sget+0x5b>
		{
		return NULL;
  80182f:	b8 00 00 00 00       	mov    $0x0,%eax
  801834:	eb 35                	jmp    80186b <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801836:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801839:	8b 40 08             	mov    0x8(%eax),%eax
  80183c:	83 ec 04             	sub    $0x4,%esp
  80183f:	50                   	push   %eax
  801840:	ff 75 0c             	pushl  0xc(%ebp)
  801843:	ff 75 08             	pushl  0x8(%ebp)
  801846:	e8 c1 03 00 00       	call   801c0c <sys_getSharedObject>
  80184b:	83 c4 10             	add    $0x10,%esp
  80184e:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801851:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801855:	78 08                	js     80185f <sget+0x84>
			{
				return (void*)v1->sva;
  801857:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185a:	8b 40 08             	mov    0x8(%eax),%eax
  80185d:	eb 0c                	jmp    80186b <sget+0x90>
			}
			else
			{
				return NULL;
  80185f:	b8 00 00 00 00       	mov    $0x0,%eax
  801864:	eb 05                	jmp    80186b <sget+0x90>
			}
		}
	}
  return NULL;
  801866:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801873:	e8 63 fb ff ff       	call   8013db <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801878:	83 ec 04             	sub    $0x4,%esp
  80187b:	68 44 39 80 00       	push   $0x803944
  801880:	68 0e 01 00 00       	push   $0x10e
  801885:	68 13 39 80 00       	push   $0x803913
  80188a:	e8 0e eb ff ff       	call   80039d <_panic>

0080188f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
  801892:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801895:	83 ec 04             	sub    $0x4,%esp
  801898:	68 6c 39 80 00       	push   $0x80396c
  80189d:	68 22 01 00 00       	push   $0x122
  8018a2:	68 13 39 80 00       	push   $0x803913
  8018a7:	e8 f1 ea ff ff       	call   80039d <_panic>

008018ac <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018b2:	83 ec 04             	sub    $0x4,%esp
  8018b5:	68 90 39 80 00       	push   $0x803990
  8018ba:	68 2d 01 00 00       	push   $0x12d
  8018bf:	68 13 39 80 00       	push   $0x803913
  8018c4:	e8 d4 ea ff ff       	call   80039d <_panic>

008018c9 <shrink>:

}
void shrink(uint32 newSize)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
  8018cc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018cf:	83 ec 04             	sub    $0x4,%esp
  8018d2:	68 90 39 80 00       	push   $0x803990
  8018d7:	68 32 01 00 00       	push   $0x132
  8018dc:	68 13 39 80 00       	push   $0x803913
  8018e1:	e8 b7 ea ff ff       	call   80039d <_panic>

008018e6 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018ec:	83 ec 04             	sub    $0x4,%esp
  8018ef:	68 90 39 80 00       	push   $0x803990
  8018f4:	68 37 01 00 00       	push   $0x137
  8018f9:	68 13 39 80 00       	push   $0x803913
  8018fe:	e8 9a ea ff ff       	call   80039d <_panic>

00801903 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
  801906:	57                   	push   %edi
  801907:	56                   	push   %esi
  801908:	53                   	push   %ebx
  801909:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
  80190f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801912:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801915:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801918:	8b 7d 18             	mov    0x18(%ebp),%edi
  80191b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80191e:	cd 30                	int    $0x30
  801920:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801923:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801926:	83 c4 10             	add    $0x10,%esp
  801929:	5b                   	pop    %ebx
  80192a:	5e                   	pop    %esi
  80192b:	5f                   	pop    %edi
  80192c:	5d                   	pop    %ebp
  80192d:	c3                   	ret    

0080192e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	83 ec 04             	sub    $0x4,%esp
  801934:	8b 45 10             	mov    0x10(%ebp),%eax
  801937:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80193a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80193e:	8b 45 08             	mov    0x8(%ebp),%eax
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	52                   	push   %edx
  801946:	ff 75 0c             	pushl  0xc(%ebp)
  801949:	50                   	push   %eax
  80194a:	6a 00                	push   $0x0
  80194c:	e8 b2 ff ff ff       	call   801903 <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
}
  801954:	90                   	nop
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <sys_cgetc>:

int
sys_cgetc(void)
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 01                	push   $0x1
  801966:	e8 98 ff ff ff       	call   801903 <syscall>
  80196b:	83 c4 18             	add    $0x18,%esp
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801973:	8b 55 0c             	mov    0xc(%ebp),%edx
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	52                   	push   %edx
  801980:	50                   	push   %eax
  801981:	6a 05                	push   $0x5
  801983:	e8 7b ff ff ff       	call   801903 <syscall>
  801988:	83 c4 18             	add    $0x18,%esp
}
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    

0080198d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
  801990:	56                   	push   %esi
  801991:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801992:	8b 75 18             	mov    0x18(%ebp),%esi
  801995:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801998:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80199b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	56                   	push   %esi
  8019a2:	53                   	push   %ebx
  8019a3:	51                   	push   %ecx
  8019a4:	52                   	push   %edx
  8019a5:	50                   	push   %eax
  8019a6:	6a 06                	push   $0x6
  8019a8:	e8 56 ff ff ff       	call   801903 <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
}
  8019b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019b3:	5b                   	pop    %ebx
  8019b4:	5e                   	pop    %esi
  8019b5:	5d                   	pop    %ebp
  8019b6:	c3                   	ret    

008019b7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	52                   	push   %edx
  8019c7:	50                   	push   %eax
  8019c8:	6a 07                	push   $0x7
  8019ca:	e8 34 ff ff ff       	call   801903 <syscall>
  8019cf:	83 c4 18             	add    $0x18,%esp
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	ff 75 0c             	pushl  0xc(%ebp)
  8019e0:	ff 75 08             	pushl  0x8(%ebp)
  8019e3:	6a 08                	push   $0x8
  8019e5:	e8 19 ff ff ff       	call   801903 <syscall>
  8019ea:	83 c4 18             	add    $0x18,%esp
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 09                	push   $0x9
  8019fe:	e8 00 ff ff ff       	call   801903 <syscall>
  801a03:	83 c4 18             	add    $0x18,%esp
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 0a                	push   $0xa
  801a17:	e8 e7 fe ff ff       	call   801903 <syscall>
  801a1c:	83 c4 18             	add    $0x18,%esp
}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 0b                	push   $0xb
  801a30:	e8 ce fe ff ff       	call   801903 <syscall>
  801a35:	83 c4 18             	add    $0x18,%esp
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	ff 75 0c             	pushl  0xc(%ebp)
  801a46:	ff 75 08             	pushl  0x8(%ebp)
  801a49:	6a 0f                	push   $0xf
  801a4b:	e8 b3 fe ff ff       	call   801903 <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
	return;
  801a53:	90                   	nop
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	ff 75 0c             	pushl  0xc(%ebp)
  801a62:	ff 75 08             	pushl  0x8(%ebp)
  801a65:	6a 10                	push   $0x10
  801a67:	e8 97 fe ff ff       	call   801903 <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a6f:	90                   	nop
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	ff 75 10             	pushl  0x10(%ebp)
  801a7c:	ff 75 0c             	pushl  0xc(%ebp)
  801a7f:	ff 75 08             	pushl  0x8(%ebp)
  801a82:	6a 11                	push   $0x11
  801a84:	e8 7a fe ff ff       	call   801903 <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
	return ;
  801a8c:	90                   	nop
}
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 0c                	push   $0xc
  801a9e:	e8 60 fe ff ff       	call   801903 <syscall>
  801aa3:	83 c4 18             	add    $0x18,%esp
}
  801aa6:	c9                   	leave  
  801aa7:	c3                   	ret    

00801aa8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	ff 75 08             	pushl  0x8(%ebp)
  801ab6:	6a 0d                	push   $0xd
  801ab8:	e8 46 fe ff ff       	call   801903 <syscall>
  801abd:	83 c4 18             	add    $0x18,%esp
}
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 0e                	push   $0xe
  801ad1:	e8 2d fe ff ff       	call   801903 <syscall>
  801ad6:	83 c4 18             	add    $0x18,%esp
}
  801ad9:	90                   	nop
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 13                	push   $0x13
  801aeb:	e8 13 fe ff ff       	call   801903 <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
}
  801af3:	90                   	nop
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 14                	push   $0x14
  801b05:	e8 f9 fd ff ff       	call   801903 <syscall>
  801b0a:	83 c4 18             	add    $0x18,%esp
}
  801b0d:	90                   	nop
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
  801b13:	83 ec 04             	sub    $0x4,%esp
  801b16:	8b 45 08             	mov    0x8(%ebp),%eax
  801b19:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b1c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	50                   	push   %eax
  801b29:	6a 15                	push   $0x15
  801b2b:	e8 d3 fd ff ff       	call   801903 <syscall>
  801b30:	83 c4 18             	add    $0x18,%esp
}
  801b33:	90                   	nop
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 16                	push   $0x16
  801b45:	e8 b9 fd ff ff       	call   801903 <syscall>
  801b4a:	83 c4 18             	add    $0x18,%esp
}
  801b4d:	90                   	nop
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	ff 75 0c             	pushl  0xc(%ebp)
  801b5f:	50                   	push   %eax
  801b60:	6a 17                	push   $0x17
  801b62:	e8 9c fd ff ff       	call   801903 <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
}
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b72:	8b 45 08             	mov    0x8(%ebp),%eax
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	52                   	push   %edx
  801b7c:	50                   	push   %eax
  801b7d:	6a 1a                	push   $0x1a
  801b7f:	e8 7f fd ff ff       	call   801903 <syscall>
  801b84:	83 c4 18             	add    $0x18,%esp
}
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	52                   	push   %edx
  801b99:	50                   	push   %eax
  801b9a:	6a 18                	push   $0x18
  801b9c:	e8 62 fd ff ff       	call   801903 <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
}
  801ba4:	90                   	nop
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801baa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bad:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	52                   	push   %edx
  801bb7:	50                   	push   %eax
  801bb8:	6a 19                	push   $0x19
  801bba:	e8 44 fd ff ff       	call   801903 <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
}
  801bc2:	90                   	nop
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
  801bc8:	83 ec 04             	sub    $0x4,%esp
  801bcb:	8b 45 10             	mov    0x10(%ebp),%eax
  801bce:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bd1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bd4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdb:	6a 00                	push   $0x0
  801bdd:	51                   	push   %ecx
  801bde:	52                   	push   %edx
  801bdf:	ff 75 0c             	pushl  0xc(%ebp)
  801be2:	50                   	push   %eax
  801be3:	6a 1b                	push   $0x1b
  801be5:	e8 19 fd ff ff       	call   801903 <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bf2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	52                   	push   %edx
  801bff:	50                   	push   %eax
  801c00:	6a 1c                	push   $0x1c
  801c02:	e8 fc fc ff ff       	call   801903 <syscall>
  801c07:	83 c4 18             	add    $0x18,%esp
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c0f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c15:	8b 45 08             	mov    0x8(%ebp),%eax
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	51                   	push   %ecx
  801c1d:	52                   	push   %edx
  801c1e:	50                   	push   %eax
  801c1f:	6a 1d                	push   $0x1d
  801c21:	e8 dd fc ff ff       	call   801903 <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c31:	8b 45 08             	mov    0x8(%ebp),%eax
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	52                   	push   %edx
  801c3b:	50                   	push   %eax
  801c3c:	6a 1e                	push   $0x1e
  801c3e:	e8 c0 fc ff ff       	call   801903 <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
}
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 1f                	push   $0x1f
  801c57:	e8 a7 fc ff ff       	call   801903 <syscall>
  801c5c:	83 c4 18             	add    $0x18,%esp
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c64:	8b 45 08             	mov    0x8(%ebp),%eax
  801c67:	6a 00                	push   $0x0
  801c69:	ff 75 14             	pushl  0x14(%ebp)
  801c6c:	ff 75 10             	pushl  0x10(%ebp)
  801c6f:	ff 75 0c             	pushl  0xc(%ebp)
  801c72:	50                   	push   %eax
  801c73:	6a 20                	push   $0x20
  801c75:	e8 89 fc ff ff       	call   801903 <syscall>
  801c7a:	83 c4 18             	add    $0x18,%esp
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c82:	8b 45 08             	mov    0x8(%ebp),%eax
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	50                   	push   %eax
  801c8e:	6a 21                	push   $0x21
  801c90:	e8 6e fc ff ff       	call   801903 <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
}
  801c98:	90                   	nop
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	50                   	push   %eax
  801caa:	6a 22                	push   $0x22
  801cac:	e8 52 fc ff ff       	call   801903 <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 02                	push   $0x2
  801cc5:	e8 39 fc ff ff       	call   801903 <syscall>
  801cca:	83 c4 18             	add    $0x18,%esp
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 03                	push   $0x3
  801cde:	e8 20 fc ff ff       	call   801903 <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 04                	push   $0x4
  801cf7:	e8 07 fc ff ff       	call   801903 <syscall>
  801cfc:	83 c4 18             	add    $0x18,%esp
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <sys_exit_env>:


void sys_exit_env(void)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 23                	push   $0x23
  801d10:	e8 ee fb ff ff       	call   801903 <syscall>
  801d15:	83 c4 18             	add    $0x18,%esp
}
  801d18:	90                   	nop
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d21:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d24:	8d 50 04             	lea    0x4(%eax),%edx
  801d27:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	52                   	push   %edx
  801d31:	50                   	push   %eax
  801d32:	6a 24                	push   $0x24
  801d34:	e8 ca fb ff ff       	call   801903 <syscall>
  801d39:	83 c4 18             	add    $0x18,%esp
	return result;
  801d3c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d42:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d45:	89 01                	mov    %eax,(%ecx)
  801d47:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4d:	c9                   	leave  
  801d4e:	c2 04 00             	ret    $0x4

00801d51 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	ff 75 10             	pushl  0x10(%ebp)
  801d5b:	ff 75 0c             	pushl  0xc(%ebp)
  801d5e:	ff 75 08             	pushl  0x8(%ebp)
  801d61:	6a 12                	push   $0x12
  801d63:	e8 9b fb ff ff       	call   801903 <syscall>
  801d68:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6b:	90                   	nop
}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <sys_rcr2>:
uint32 sys_rcr2()
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 25                	push   $0x25
  801d7d:	e8 81 fb ff ff       	call   801903 <syscall>
  801d82:	83 c4 18             	add    $0x18,%esp
}
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
  801d8a:	83 ec 04             	sub    $0x4,%esp
  801d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d90:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d93:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	50                   	push   %eax
  801da0:	6a 26                	push   $0x26
  801da2:	e8 5c fb ff ff       	call   801903 <syscall>
  801da7:	83 c4 18             	add    $0x18,%esp
	return ;
  801daa:	90                   	nop
}
  801dab:	c9                   	leave  
  801dac:	c3                   	ret    

00801dad <rsttst>:
void rsttst()
{
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 28                	push   $0x28
  801dbc:	e8 42 fb ff ff       	call   801903 <syscall>
  801dc1:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc4:	90                   	nop
}
  801dc5:	c9                   	leave  
  801dc6:	c3                   	ret    

00801dc7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
  801dca:	83 ec 04             	sub    $0x4,%esp
  801dcd:	8b 45 14             	mov    0x14(%ebp),%eax
  801dd0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dd3:	8b 55 18             	mov    0x18(%ebp),%edx
  801dd6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dda:	52                   	push   %edx
  801ddb:	50                   	push   %eax
  801ddc:	ff 75 10             	pushl  0x10(%ebp)
  801ddf:	ff 75 0c             	pushl  0xc(%ebp)
  801de2:	ff 75 08             	pushl  0x8(%ebp)
  801de5:	6a 27                	push   $0x27
  801de7:	e8 17 fb ff ff       	call   801903 <syscall>
  801dec:	83 c4 18             	add    $0x18,%esp
	return ;
  801def:	90                   	nop
}
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <chktst>:
void chktst(uint32 n)
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	ff 75 08             	pushl  0x8(%ebp)
  801e00:	6a 29                	push   $0x29
  801e02:	e8 fc fa ff ff       	call   801903 <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0a:	90                   	nop
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <inctst>:

void inctst()
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 2a                	push   $0x2a
  801e1c:	e8 e2 fa ff ff       	call   801903 <syscall>
  801e21:	83 c4 18             	add    $0x18,%esp
	return ;
  801e24:	90                   	nop
}
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <gettst>:
uint32 gettst()
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 2b                	push   $0x2b
  801e36:	e8 c8 fa ff ff       	call   801903 <syscall>
  801e3b:	83 c4 18             	add    $0x18,%esp
}
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 2c                	push   $0x2c
  801e52:	e8 ac fa ff ff       	call   801903 <syscall>
  801e57:	83 c4 18             	add    $0x18,%esp
  801e5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e5d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e61:	75 07                	jne    801e6a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e63:	b8 01 00 00 00       	mov    $0x1,%eax
  801e68:	eb 05                	jmp    801e6f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e6f:	c9                   	leave  
  801e70:	c3                   	ret    

00801e71 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
  801e74:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 2c                	push   $0x2c
  801e83:	e8 7b fa ff ff       	call   801903 <syscall>
  801e88:	83 c4 18             	add    $0x18,%esp
  801e8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e8e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e92:	75 07                	jne    801e9b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e94:	b8 01 00 00 00       	mov    $0x1,%eax
  801e99:	eb 05                	jmp    801ea0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
  801ea5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 2c                	push   $0x2c
  801eb4:	e8 4a fa ff ff       	call   801903 <syscall>
  801eb9:	83 c4 18             	add    $0x18,%esp
  801ebc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ebf:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ec3:	75 07                	jne    801ecc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ec5:	b8 01 00 00 00       	mov    $0x1,%eax
  801eca:	eb 05                	jmp    801ed1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ecc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed1:	c9                   	leave  
  801ed2:	c3                   	ret    

00801ed3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ed3:	55                   	push   %ebp
  801ed4:	89 e5                	mov    %esp,%ebp
  801ed6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 2c                	push   $0x2c
  801ee5:	e8 19 fa ff ff       	call   801903 <syscall>
  801eea:	83 c4 18             	add    $0x18,%esp
  801eed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ef0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ef4:	75 07                	jne    801efd <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ef6:	b8 01 00 00 00       	mov    $0x1,%eax
  801efb:	eb 05                	jmp    801f02 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801efd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f02:	c9                   	leave  
  801f03:	c3                   	ret    

00801f04 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	ff 75 08             	pushl  0x8(%ebp)
  801f12:	6a 2d                	push   $0x2d
  801f14:	e8 ea f9 ff ff       	call   801903 <syscall>
  801f19:	83 c4 18             	add    $0x18,%esp
	return ;
  801f1c:	90                   	nop
}
  801f1d:	c9                   	leave  
  801f1e:	c3                   	ret    

00801f1f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
  801f22:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f23:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f26:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2f:	6a 00                	push   $0x0
  801f31:	53                   	push   %ebx
  801f32:	51                   	push   %ecx
  801f33:	52                   	push   %edx
  801f34:	50                   	push   %eax
  801f35:	6a 2e                	push   $0x2e
  801f37:	e8 c7 f9 ff ff       	call   801903 <syscall>
  801f3c:	83 c4 18             	add    $0x18,%esp
}
  801f3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	52                   	push   %edx
  801f54:	50                   	push   %eax
  801f55:	6a 2f                	push   $0x2f
  801f57:	e8 a7 f9 ff ff       	call   801903 <syscall>
  801f5c:	83 c4 18             	add    $0x18,%esp
}
  801f5f:	c9                   	leave  
  801f60:	c3                   	ret    

00801f61 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
  801f64:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f67:	83 ec 0c             	sub    $0xc,%esp
  801f6a:	68 a0 39 80 00       	push   $0x8039a0
  801f6f:	e8 dd e6 ff ff       	call   800651 <cprintf>
  801f74:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f77:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f7e:	83 ec 0c             	sub    $0xc,%esp
  801f81:	68 cc 39 80 00       	push   $0x8039cc
  801f86:	e8 c6 e6 ff ff       	call   800651 <cprintf>
  801f8b:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f8e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f92:	a1 38 41 80 00       	mov    0x804138,%eax
  801f97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f9a:	eb 56                	jmp    801ff2 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f9c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fa0:	74 1c                	je     801fbe <print_mem_block_lists+0x5d>
  801fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa5:	8b 50 08             	mov    0x8(%eax),%edx
  801fa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fab:	8b 48 08             	mov    0x8(%eax),%ecx
  801fae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb1:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb4:	01 c8                	add    %ecx,%eax
  801fb6:	39 c2                	cmp    %eax,%edx
  801fb8:	73 04                	jae    801fbe <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fba:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc1:	8b 50 08             	mov    0x8(%eax),%edx
  801fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc7:	8b 40 0c             	mov    0xc(%eax),%eax
  801fca:	01 c2                	add    %eax,%edx
  801fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcf:	8b 40 08             	mov    0x8(%eax),%eax
  801fd2:	83 ec 04             	sub    $0x4,%esp
  801fd5:	52                   	push   %edx
  801fd6:	50                   	push   %eax
  801fd7:	68 e1 39 80 00       	push   $0x8039e1
  801fdc:	e8 70 e6 ff ff       	call   800651 <cprintf>
  801fe1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fea:	a1 40 41 80 00       	mov    0x804140,%eax
  801fef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff6:	74 07                	je     801fff <print_mem_block_lists+0x9e>
  801ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffb:	8b 00                	mov    (%eax),%eax
  801ffd:	eb 05                	jmp    802004 <print_mem_block_lists+0xa3>
  801fff:	b8 00 00 00 00       	mov    $0x0,%eax
  802004:	a3 40 41 80 00       	mov    %eax,0x804140
  802009:	a1 40 41 80 00       	mov    0x804140,%eax
  80200e:	85 c0                	test   %eax,%eax
  802010:	75 8a                	jne    801f9c <print_mem_block_lists+0x3b>
  802012:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802016:	75 84                	jne    801f9c <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802018:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80201c:	75 10                	jne    80202e <print_mem_block_lists+0xcd>
  80201e:	83 ec 0c             	sub    $0xc,%esp
  802021:	68 f0 39 80 00       	push   $0x8039f0
  802026:	e8 26 e6 ff ff       	call   800651 <cprintf>
  80202b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80202e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802035:	83 ec 0c             	sub    $0xc,%esp
  802038:	68 14 3a 80 00       	push   $0x803a14
  80203d:	e8 0f e6 ff ff       	call   800651 <cprintf>
  802042:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802045:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802049:	a1 40 40 80 00       	mov    0x804040,%eax
  80204e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802051:	eb 56                	jmp    8020a9 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802053:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802057:	74 1c                	je     802075 <print_mem_block_lists+0x114>
  802059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205c:	8b 50 08             	mov    0x8(%eax),%edx
  80205f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802062:	8b 48 08             	mov    0x8(%eax),%ecx
  802065:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802068:	8b 40 0c             	mov    0xc(%eax),%eax
  80206b:	01 c8                	add    %ecx,%eax
  80206d:	39 c2                	cmp    %eax,%edx
  80206f:	73 04                	jae    802075 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802071:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802075:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802078:	8b 50 08             	mov    0x8(%eax),%edx
  80207b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207e:	8b 40 0c             	mov    0xc(%eax),%eax
  802081:	01 c2                	add    %eax,%edx
  802083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802086:	8b 40 08             	mov    0x8(%eax),%eax
  802089:	83 ec 04             	sub    $0x4,%esp
  80208c:	52                   	push   %edx
  80208d:	50                   	push   %eax
  80208e:	68 e1 39 80 00       	push   $0x8039e1
  802093:	e8 b9 e5 ff ff       	call   800651 <cprintf>
  802098:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80209b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020a1:	a1 48 40 80 00       	mov    0x804048,%eax
  8020a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020ad:	74 07                	je     8020b6 <print_mem_block_lists+0x155>
  8020af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b2:	8b 00                	mov    (%eax),%eax
  8020b4:	eb 05                	jmp    8020bb <print_mem_block_lists+0x15a>
  8020b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bb:	a3 48 40 80 00       	mov    %eax,0x804048
  8020c0:	a1 48 40 80 00       	mov    0x804048,%eax
  8020c5:	85 c0                	test   %eax,%eax
  8020c7:	75 8a                	jne    802053 <print_mem_block_lists+0xf2>
  8020c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020cd:	75 84                	jne    802053 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020cf:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020d3:	75 10                	jne    8020e5 <print_mem_block_lists+0x184>
  8020d5:	83 ec 0c             	sub    $0xc,%esp
  8020d8:	68 2c 3a 80 00       	push   $0x803a2c
  8020dd:	e8 6f e5 ff ff       	call   800651 <cprintf>
  8020e2:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020e5:	83 ec 0c             	sub    $0xc,%esp
  8020e8:	68 a0 39 80 00       	push   $0x8039a0
  8020ed:	e8 5f e5 ff ff       	call   800651 <cprintf>
  8020f2:	83 c4 10             	add    $0x10,%esp

}
  8020f5:	90                   	nop
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
  8020fb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  8020fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802101:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  802104:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80210b:	00 00 00 
  80210e:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802115:	00 00 00 
  802118:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80211f:	00 00 00 
	for(int i = 0; i<n;i++)
  802122:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802129:	e9 9e 00 00 00       	jmp    8021cc <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80212e:	a1 50 40 80 00       	mov    0x804050,%eax
  802133:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802136:	c1 e2 04             	shl    $0x4,%edx
  802139:	01 d0                	add    %edx,%eax
  80213b:	85 c0                	test   %eax,%eax
  80213d:	75 14                	jne    802153 <initialize_MemBlocksList+0x5b>
  80213f:	83 ec 04             	sub    $0x4,%esp
  802142:	68 54 3a 80 00       	push   $0x803a54
  802147:	6a 47                	push   $0x47
  802149:	68 77 3a 80 00       	push   $0x803a77
  80214e:	e8 4a e2 ff ff       	call   80039d <_panic>
  802153:	a1 50 40 80 00       	mov    0x804050,%eax
  802158:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80215b:	c1 e2 04             	shl    $0x4,%edx
  80215e:	01 d0                	add    %edx,%eax
  802160:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802166:	89 10                	mov    %edx,(%eax)
  802168:	8b 00                	mov    (%eax),%eax
  80216a:	85 c0                	test   %eax,%eax
  80216c:	74 18                	je     802186 <initialize_MemBlocksList+0x8e>
  80216e:	a1 48 41 80 00       	mov    0x804148,%eax
  802173:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802179:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80217c:	c1 e1 04             	shl    $0x4,%ecx
  80217f:	01 ca                	add    %ecx,%edx
  802181:	89 50 04             	mov    %edx,0x4(%eax)
  802184:	eb 12                	jmp    802198 <initialize_MemBlocksList+0xa0>
  802186:	a1 50 40 80 00       	mov    0x804050,%eax
  80218b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80218e:	c1 e2 04             	shl    $0x4,%edx
  802191:	01 d0                	add    %edx,%eax
  802193:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802198:	a1 50 40 80 00       	mov    0x804050,%eax
  80219d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a0:	c1 e2 04             	shl    $0x4,%edx
  8021a3:	01 d0                	add    %edx,%eax
  8021a5:	a3 48 41 80 00       	mov    %eax,0x804148
  8021aa:	a1 50 40 80 00       	mov    0x804050,%eax
  8021af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b2:	c1 e2 04             	shl    $0x4,%edx
  8021b5:	01 d0                	add    %edx,%eax
  8021b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021be:	a1 54 41 80 00       	mov    0x804154,%eax
  8021c3:	40                   	inc    %eax
  8021c4:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8021c9:	ff 45 f4             	incl   -0xc(%ebp)
  8021cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8021d2:	0f 82 56 ff ff ff    	jb     80212e <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8021d8:	90                   	nop
  8021d9:	c9                   	leave  
  8021da:	c3                   	ret    

008021db <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
  8021de:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  8021e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  8021e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8021ee:	a1 40 40 80 00       	mov    0x804040,%eax
  8021f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021f6:	eb 23                	jmp    80221b <find_block+0x40>
	{
		if(blk->sva == virAddress)
  8021f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021fb:	8b 40 08             	mov    0x8(%eax),%eax
  8021fe:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802201:	75 09                	jne    80220c <find_block+0x31>
		{
			found = 1;
  802203:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  80220a:	eb 35                	jmp    802241 <find_block+0x66>
		}
		else
		{
			found = 0;
  80220c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802213:	a1 48 40 80 00       	mov    0x804048,%eax
  802218:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80221b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80221f:	74 07                	je     802228 <find_block+0x4d>
  802221:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802224:	8b 00                	mov    (%eax),%eax
  802226:	eb 05                	jmp    80222d <find_block+0x52>
  802228:	b8 00 00 00 00       	mov    $0x0,%eax
  80222d:	a3 48 40 80 00       	mov    %eax,0x804048
  802232:	a1 48 40 80 00       	mov    0x804048,%eax
  802237:	85 c0                	test   %eax,%eax
  802239:	75 bd                	jne    8021f8 <find_block+0x1d>
  80223b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80223f:	75 b7                	jne    8021f8 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802241:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802245:	75 05                	jne    80224c <find_block+0x71>
	{
		return blk;
  802247:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80224a:	eb 05                	jmp    802251 <find_block+0x76>
	}
	else
	{
		return NULL;
  80224c:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802251:	c9                   	leave  
  802252:	c3                   	ret    

00802253 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
  802256:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  80225f:	a1 40 40 80 00       	mov    0x804040,%eax
  802264:	85 c0                	test   %eax,%eax
  802266:	74 12                	je     80227a <insert_sorted_allocList+0x27>
  802268:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226b:	8b 50 08             	mov    0x8(%eax),%edx
  80226e:	a1 40 40 80 00       	mov    0x804040,%eax
  802273:	8b 40 08             	mov    0x8(%eax),%eax
  802276:	39 c2                	cmp    %eax,%edx
  802278:	73 65                	jae    8022df <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  80227a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80227e:	75 14                	jne    802294 <insert_sorted_allocList+0x41>
  802280:	83 ec 04             	sub    $0x4,%esp
  802283:	68 54 3a 80 00       	push   $0x803a54
  802288:	6a 7b                	push   $0x7b
  80228a:	68 77 3a 80 00       	push   $0x803a77
  80228f:	e8 09 e1 ff ff       	call   80039d <_panic>
  802294:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80229a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229d:	89 10                	mov    %edx,(%eax)
  80229f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a2:	8b 00                	mov    (%eax),%eax
  8022a4:	85 c0                	test   %eax,%eax
  8022a6:	74 0d                	je     8022b5 <insert_sorted_allocList+0x62>
  8022a8:	a1 40 40 80 00       	mov    0x804040,%eax
  8022ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022b0:	89 50 04             	mov    %edx,0x4(%eax)
  8022b3:	eb 08                	jmp    8022bd <insert_sorted_allocList+0x6a>
  8022b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b8:	a3 44 40 80 00       	mov    %eax,0x804044
  8022bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c0:	a3 40 40 80 00       	mov    %eax,0x804040
  8022c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022cf:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022d4:	40                   	inc    %eax
  8022d5:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8022da:	e9 5f 01 00 00       	jmp    80243e <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8022df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e2:	8b 50 08             	mov    0x8(%eax),%edx
  8022e5:	a1 44 40 80 00       	mov    0x804044,%eax
  8022ea:	8b 40 08             	mov    0x8(%eax),%eax
  8022ed:	39 c2                	cmp    %eax,%edx
  8022ef:	76 65                	jbe    802356 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  8022f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022f5:	75 14                	jne    80230b <insert_sorted_allocList+0xb8>
  8022f7:	83 ec 04             	sub    $0x4,%esp
  8022fa:	68 90 3a 80 00       	push   $0x803a90
  8022ff:	6a 7f                	push   $0x7f
  802301:	68 77 3a 80 00       	push   $0x803a77
  802306:	e8 92 e0 ff ff       	call   80039d <_panic>
  80230b:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802311:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802314:	89 50 04             	mov    %edx,0x4(%eax)
  802317:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231a:	8b 40 04             	mov    0x4(%eax),%eax
  80231d:	85 c0                	test   %eax,%eax
  80231f:	74 0c                	je     80232d <insert_sorted_allocList+0xda>
  802321:	a1 44 40 80 00       	mov    0x804044,%eax
  802326:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802329:	89 10                	mov    %edx,(%eax)
  80232b:	eb 08                	jmp    802335 <insert_sorted_allocList+0xe2>
  80232d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802330:	a3 40 40 80 00       	mov    %eax,0x804040
  802335:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802338:	a3 44 40 80 00       	mov    %eax,0x804044
  80233d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802340:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802346:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80234b:	40                   	inc    %eax
  80234c:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802351:	e9 e8 00 00 00       	jmp    80243e <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802356:	a1 40 40 80 00       	mov    0x804040,%eax
  80235b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80235e:	e9 ab 00 00 00       	jmp    80240e <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802366:	8b 00                	mov    (%eax),%eax
  802368:	85 c0                	test   %eax,%eax
  80236a:	0f 84 96 00 00 00    	je     802406 <insert_sorted_allocList+0x1b3>
  802370:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802373:	8b 50 08             	mov    0x8(%eax),%edx
  802376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802379:	8b 40 08             	mov    0x8(%eax),%eax
  80237c:	39 c2                	cmp    %eax,%edx
  80237e:	0f 86 82 00 00 00    	jbe    802406 <insert_sorted_allocList+0x1b3>
  802384:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802387:	8b 50 08             	mov    0x8(%eax),%edx
  80238a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238d:	8b 00                	mov    (%eax),%eax
  80238f:	8b 40 08             	mov    0x8(%eax),%eax
  802392:	39 c2                	cmp    %eax,%edx
  802394:	73 70                	jae    802406 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802396:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80239a:	74 06                	je     8023a2 <insert_sorted_allocList+0x14f>
  80239c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023a0:	75 17                	jne    8023b9 <insert_sorted_allocList+0x166>
  8023a2:	83 ec 04             	sub    $0x4,%esp
  8023a5:	68 b4 3a 80 00       	push   $0x803ab4
  8023aa:	68 87 00 00 00       	push   $0x87
  8023af:	68 77 3a 80 00       	push   $0x803a77
  8023b4:	e8 e4 df ff ff       	call   80039d <_panic>
  8023b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bc:	8b 10                	mov    (%eax),%edx
  8023be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c1:	89 10                	mov    %edx,(%eax)
  8023c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c6:	8b 00                	mov    (%eax),%eax
  8023c8:	85 c0                	test   %eax,%eax
  8023ca:	74 0b                	je     8023d7 <insert_sorted_allocList+0x184>
  8023cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cf:	8b 00                	mov    (%eax),%eax
  8023d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023d4:	89 50 04             	mov    %edx,0x4(%eax)
  8023d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023dd:	89 10                	mov    %edx,(%eax)
  8023df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e5:	89 50 04             	mov    %edx,0x4(%eax)
  8023e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023eb:	8b 00                	mov    (%eax),%eax
  8023ed:	85 c0                	test   %eax,%eax
  8023ef:	75 08                	jne    8023f9 <insert_sorted_allocList+0x1a6>
  8023f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f4:	a3 44 40 80 00       	mov    %eax,0x804044
  8023f9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023fe:	40                   	inc    %eax
  8023ff:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802404:	eb 38                	jmp    80243e <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802406:	a1 48 40 80 00       	mov    0x804048,%eax
  80240b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80240e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802412:	74 07                	je     80241b <insert_sorted_allocList+0x1c8>
  802414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802417:	8b 00                	mov    (%eax),%eax
  802419:	eb 05                	jmp    802420 <insert_sorted_allocList+0x1cd>
  80241b:	b8 00 00 00 00       	mov    $0x0,%eax
  802420:	a3 48 40 80 00       	mov    %eax,0x804048
  802425:	a1 48 40 80 00       	mov    0x804048,%eax
  80242a:	85 c0                	test   %eax,%eax
  80242c:	0f 85 31 ff ff ff    	jne    802363 <insert_sorted_allocList+0x110>
  802432:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802436:	0f 85 27 ff ff ff    	jne    802363 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80243c:	eb 00                	jmp    80243e <insert_sorted_allocList+0x1eb>
  80243e:	90                   	nop
  80243f:	c9                   	leave  
  802440:	c3                   	ret    

00802441 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802441:	55                   	push   %ebp
  802442:	89 e5                	mov    %esp,%ebp
  802444:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802447:	8b 45 08             	mov    0x8(%ebp),%eax
  80244a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  80244d:	a1 48 41 80 00       	mov    0x804148,%eax
  802452:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802455:	a1 38 41 80 00       	mov    0x804138,%eax
  80245a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80245d:	e9 77 01 00 00       	jmp    8025d9 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802465:	8b 40 0c             	mov    0xc(%eax),%eax
  802468:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80246b:	0f 85 8a 00 00 00    	jne    8024fb <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802471:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802475:	75 17                	jne    80248e <alloc_block_FF+0x4d>
  802477:	83 ec 04             	sub    $0x4,%esp
  80247a:	68 e8 3a 80 00       	push   $0x803ae8
  80247f:	68 9e 00 00 00       	push   $0x9e
  802484:	68 77 3a 80 00       	push   $0x803a77
  802489:	e8 0f df ff ff       	call   80039d <_panic>
  80248e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802491:	8b 00                	mov    (%eax),%eax
  802493:	85 c0                	test   %eax,%eax
  802495:	74 10                	je     8024a7 <alloc_block_FF+0x66>
  802497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249a:	8b 00                	mov    (%eax),%eax
  80249c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249f:	8b 52 04             	mov    0x4(%edx),%edx
  8024a2:	89 50 04             	mov    %edx,0x4(%eax)
  8024a5:	eb 0b                	jmp    8024b2 <alloc_block_FF+0x71>
  8024a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024aa:	8b 40 04             	mov    0x4(%eax),%eax
  8024ad:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b5:	8b 40 04             	mov    0x4(%eax),%eax
  8024b8:	85 c0                	test   %eax,%eax
  8024ba:	74 0f                	je     8024cb <alloc_block_FF+0x8a>
  8024bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bf:	8b 40 04             	mov    0x4(%eax),%eax
  8024c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c5:	8b 12                	mov    (%edx),%edx
  8024c7:	89 10                	mov    %edx,(%eax)
  8024c9:	eb 0a                	jmp    8024d5 <alloc_block_FF+0x94>
  8024cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ce:	8b 00                	mov    (%eax),%eax
  8024d0:	a3 38 41 80 00       	mov    %eax,0x804138
  8024d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024e8:	a1 44 41 80 00       	mov    0x804144,%eax
  8024ed:	48                   	dec    %eax
  8024ee:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8024f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f6:	e9 11 01 00 00       	jmp    80260c <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  8024fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802501:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802504:	0f 86 c7 00 00 00    	jbe    8025d1 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  80250a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80250e:	75 17                	jne    802527 <alloc_block_FF+0xe6>
  802510:	83 ec 04             	sub    $0x4,%esp
  802513:	68 e8 3a 80 00       	push   $0x803ae8
  802518:	68 a3 00 00 00       	push   $0xa3
  80251d:	68 77 3a 80 00       	push   $0x803a77
  802522:	e8 76 de ff ff       	call   80039d <_panic>
  802527:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80252a:	8b 00                	mov    (%eax),%eax
  80252c:	85 c0                	test   %eax,%eax
  80252e:	74 10                	je     802540 <alloc_block_FF+0xff>
  802530:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802533:	8b 00                	mov    (%eax),%eax
  802535:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802538:	8b 52 04             	mov    0x4(%edx),%edx
  80253b:	89 50 04             	mov    %edx,0x4(%eax)
  80253e:	eb 0b                	jmp    80254b <alloc_block_FF+0x10a>
  802540:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802543:	8b 40 04             	mov    0x4(%eax),%eax
  802546:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80254b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80254e:	8b 40 04             	mov    0x4(%eax),%eax
  802551:	85 c0                	test   %eax,%eax
  802553:	74 0f                	je     802564 <alloc_block_FF+0x123>
  802555:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802558:	8b 40 04             	mov    0x4(%eax),%eax
  80255b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80255e:	8b 12                	mov    (%edx),%edx
  802560:	89 10                	mov    %edx,(%eax)
  802562:	eb 0a                	jmp    80256e <alloc_block_FF+0x12d>
  802564:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802567:	8b 00                	mov    (%eax),%eax
  802569:	a3 48 41 80 00       	mov    %eax,0x804148
  80256e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802571:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80257a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802581:	a1 54 41 80 00       	mov    0x804154,%eax
  802586:	48                   	dec    %eax
  802587:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  80258c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80258f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802592:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	8b 40 0c             	mov    0xc(%eax),%eax
  80259b:	2b 45 f0             	sub    -0x10(%ebp),%eax
  80259e:	89 c2                	mov    %eax,%edx
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a9:	8b 40 08             	mov    0x8(%eax),%eax
  8025ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8025af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b2:	8b 50 08             	mov    0x8(%eax),%edx
  8025b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bb:	01 c2                	add    %eax,%edx
  8025bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c0:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8025c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025c9:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8025cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025cf:	eb 3b                	jmp    80260c <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8025d1:	a1 40 41 80 00       	mov    0x804140,%eax
  8025d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025dd:	74 07                	je     8025e6 <alloc_block_FF+0x1a5>
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	8b 00                	mov    (%eax),%eax
  8025e4:	eb 05                	jmp    8025eb <alloc_block_FF+0x1aa>
  8025e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025eb:	a3 40 41 80 00       	mov    %eax,0x804140
  8025f0:	a1 40 41 80 00       	mov    0x804140,%eax
  8025f5:	85 c0                	test   %eax,%eax
  8025f7:	0f 85 65 fe ff ff    	jne    802462 <alloc_block_FF+0x21>
  8025fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802601:	0f 85 5b fe ff ff    	jne    802462 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802607:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80260c:	c9                   	leave  
  80260d:	c3                   	ret    

0080260e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80260e:	55                   	push   %ebp
  80260f:	89 e5                	mov    %esp,%ebp
  802611:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802614:	8b 45 08             	mov    0x8(%ebp),%eax
  802617:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  80261a:	a1 48 41 80 00       	mov    0x804148,%eax
  80261f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802622:	a1 44 41 80 00       	mov    0x804144,%eax
  802627:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  80262a:	a1 38 41 80 00       	mov    0x804138,%eax
  80262f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802632:	e9 a1 00 00 00       	jmp    8026d8 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263a:	8b 40 0c             	mov    0xc(%eax),%eax
  80263d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802640:	0f 85 8a 00 00 00    	jne    8026d0 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802646:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264a:	75 17                	jne    802663 <alloc_block_BF+0x55>
  80264c:	83 ec 04             	sub    $0x4,%esp
  80264f:	68 e8 3a 80 00       	push   $0x803ae8
  802654:	68 c2 00 00 00       	push   $0xc2
  802659:	68 77 3a 80 00       	push   $0x803a77
  80265e:	e8 3a dd ff ff       	call   80039d <_panic>
  802663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802666:	8b 00                	mov    (%eax),%eax
  802668:	85 c0                	test   %eax,%eax
  80266a:	74 10                	je     80267c <alloc_block_BF+0x6e>
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	8b 00                	mov    (%eax),%eax
  802671:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802674:	8b 52 04             	mov    0x4(%edx),%edx
  802677:	89 50 04             	mov    %edx,0x4(%eax)
  80267a:	eb 0b                	jmp    802687 <alloc_block_BF+0x79>
  80267c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267f:	8b 40 04             	mov    0x4(%eax),%eax
  802682:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268a:	8b 40 04             	mov    0x4(%eax),%eax
  80268d:	85 c0                	test   %eax,%eax
  80268f:	74 0f                	je     8026a0 <alloc_block_BF+0x92>
  802691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802694:	8b 40 04             	mov    0x4(%eax),%eax
  802697:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80269a:	8b 12                	mov    (%edx),%edx
  80269c:	89 10                	mov    %edx,(%eax)
  80269e:	eb 0a                	jmp    8026aa <alloc_block_BF+0x9c>
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	8b 00                	mov    (%eax),%eax
  8026a5:	a3 38 41 80 00       	mov    %eax,0x804138
  8026aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026bd:	a1 44 41 80 00       	mov    0x804144,%eax
  8026c2:	48                   	dec    %eax
  8026c3:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8026c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cb:	e9 11 02 00 00       	jmp    8028e1 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026d0:	a1 40 41 80 00       	mov    0x804140,%eax
  8026d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026dc:	74 07                	je     8026e5 <alloc_block_BF+0xd7>
  8026de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e1:	8b 00                	mov    (%eax),%eax
  8026e3:	eb 05                	jmp    8026ea <alloc_block_BF+0xdc>
  8026e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ea:	a3 40 41 80 00       	mov    %eax,0x804140
  8026ef:	a1 40 41 80 00       	mov    0x804140,%eax
  8026f4:	85 c0                	test   %eax,%eax
  8026f6:	0f 85 3b ff ff ff    	jne    802637 <alloc_block_BF+0x29>
  8026fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802700:	0f 85 31 ff ff ff    	jne    802637 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802706:	a1 38 41 80 00       	mov    0x804138,%eax
  80270b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80270e:	eb 27                	jmp    802737 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802713:	8b 40 0c             	mov    0xc(%eax),%eax
  802716:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802719:	76 14                	jbe    80272f <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  80271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271e:	8b 40 0c             	mov    0xc(%eax),%eax
  802721:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	8b 40 08             	mov    0x8(%eax),%eax
  80272a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  80272d:	eb 2e                	jmp    80275d <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80272f:	a1 40 41 80 00       	mov    0x804140,%eax
  802734:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802737:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273b:	74 07                	je     802744 <alloc_block_BF+0x136>
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	8b 00                	mov    (%eax),%eax
  802742:	eb 05                	jmp    802749 <alloc_block_BF+0x13b>
  802744:	b8 00 00 00 00       	mov    $0x0,%eax
  802749:	a3 40 41 80 00       	mov    %eax,0x804140
  80274e:	a1 40 41 80 00       	mov    0x804140,%eax
  802753:	85 c0                	test   %eax,%eax
  802755:	75 b9                	jne    802710 <alloc_block_BF+0x102>
  802757:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80275b:	75 b3                	jne    802710 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80275d:	a1 38 41 80 00       	mov    0x804138,%eax
  802762:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802765:	eb 30                	jmp    802797 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 40 0c             	mov    0xc(%eax),%eax
  80276d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802770:	73 1d                	jae    80278f <alloc_block_BF+0x181>
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	8b 40 0c             	mov    0xc(%eax),%eax
  802778:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80277b:	76 12                	jbe    80278f <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	8b 40 0c             	mov    0xc(%eax),%eax
  802783:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802789:	8b 40 08             	mov    0x8(%eax),%eax
  80278c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80278f:	a1 40 41 80 00       	mov    0x804140,%eax
  802794:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802797:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279b:	74 07                	je     8027a4 <alloc_block_BF+0x196>
  80279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a0:	8b 00                	mov    (%eax),%eax
  8027a2:	eb 05                	jmp    8027a9 <alloc_block_BF+0x19b>
  8027a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a9:	a3 40 41 80 00       	mov    %eax,0x804140
  8027ae:	a1 40 41 80 00       	mov    0x804140,%eax
  8027b3:	85 c0                	test   %eax,%eax
  8027b5:	75 b0                	jne    802767 <alloc_block_BF+0x159>
  8027b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027bb:	75 aa                	jne    802767 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027bd:	a1 38 41 80 00       	mov    0x804138,%eax
  8027c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c5:	e9 e4 00 00 00       	jmp    8028ae <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8027d3:	0f 85 cd 00 00 00    	jne    8028a6 <alloc_block_BF+0x298>
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	8b 40 08             	mov    0x8(%eax),%eax
  8027df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027e2:	0f 85 be 00 00 00    	jne    8028a6 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  8027e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027ec:	75 17                	jne    802805 <alloc_block_BF+0x1f7>
  8027ee:	83 ec 04             	sub    $0x4,%esp
  8027f1:	68 e8 3a 80 00       	push   $0x803ae8
  8027f6:	68 db 00 00 00       	push   $0xdb
  8027fb:	68 77 3a 80 00       	push   $0x803a77
  802800:	e8 98 db ff ff       	call   80039d <_panic>
  802805:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802808:	8b 00                	mov    (%eax),%eax
  80280a:	85 c0                	test   %eax,%eax
  80280c:	74 10                	je     80281e <alloc_block_BF+0x210>
  80280e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802811:	8b 00                	mov    (%eax),%eax
  802813:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802816:	8b 52 04             	mov    0x4(%edx),%edx
  802819:	89 50 04             	mov    %edx,0x4(%eax)
  80281c:	eb 0b                	jmp    802829 <alloc_block_BF+0x21b>
  80281e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802821:	8b 40 04             	mov    0x4(%eax),%eax
  802824:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802829:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80282c:	8b 40 04             	mov    0x4(%eax),%eax
  80282f:	85 c0                	test   %eax,%eax
  802831:	74 0f                	je     802842 <alloc_block_BF+0x234>
  802833:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802836:	8b 40 04             	mov    0x4(%eax),%eax
  802839:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80283c:	8b 12                	mov    (%edx),%edx
  80283e:	89 10                	mov    %edx,(%eax)
  802840:	eb 0a                	jmp    80284c <alloc_block_BF+0x23e>
  802842:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802845:	8b 00                	mov    (%eax),%eax
  802847:	a3 48 41 80 00       	mov    %eax,0x804148
  80284c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80284f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802855:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802858:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80285f:	a1 54 41 80 00       	mov    0x804154,%eax
  802864:	48                   	dec    %eax
  802865:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  80286a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80286d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802870:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802873:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802876:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802879:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  80287c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287f:	8b 40 0c             	mov    0xc(%eax),%eax
  802882:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802885:	89 c2                	mov    %eax,%edx
  802887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288a:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  80288d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802890:	8b 50 08             	mov    0x8(%eax),%edx
  802893:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802896:	8b 40 0c             	mov    0xc(%eax),%eax
  802899:	01 c2                	add    %eax,%edx
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8028a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028a4:	eb 3b                	jmp    8028e1 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028a6:	a1 40 41 80 00       	mov    0x804140,%eax
  8028ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b2:	74 07                	je     8028bb <alloc_block_BF+0x2ad>
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	8b 00                	mov    (%eax),%eax
  8028b9:	eb 05                	jmp    8028c0 <alloc_block_BF+0x2b2>
  8028bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c0:	a3 40 41 80 00       	mov    %eax,0x804140
  8028c5:	a1 40 41 80 00       	mov    0x804140,%eax
  8028ca:	85 c0                	test   %eax,%eax
  8028cc:	0f 85 f8 fe ff ff    	jne    8027ca <alloc_block_BF+0x1bc>
  8028d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d6:	0f 85 ee fe ff ff    	jne    8027ca <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  8028dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028e1:	c9                   	leave  
  8028e2:	c3                   	ret    

008028e3 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8028e3:	55                   	push   %ebp
  8028e4:	89 e5                	mov    %esp,%ebp
  8028e6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  8028e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8028ef:	a1 48 41 80 00       	mov    0x804148,%eax
  8028f4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8028f7:	a1 38 41 80 00       	mov    0x804138,%eax
  8028fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ff:	e9 77 01 00 00       	jmp    802a7b <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	8b 40 0c             	mov    0xc(%eax),%eax
  80290a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80290d:	0f 85 8a 00 00 00    	jne    80299d <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802913:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802917:	75 17                	jne    802930 <alloc_block_NF+0x4d>
  802919:	83 ec 04             	sub    $0x4,%esp
  80291c:	68 e8 3a 80 00       	push   $0x803ae8
  802921:	68 f7 00 00 00       	push   $0xf7
  802926:	68 77 3a 80 00       	push   $0x803a77
  80292b:	e8 6d da ff ff       	call   80039d <_panic>
  802930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802933:	8b 00                	mov    (%eax),%eax
  802935:	85 c0                	test   %eax,%eax
  802937:	74 10                	je     802949 <alloc_block_NF+0x66>
  802939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293c:	8b 00                	mov    (%eax),%eax
  80293e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802941:	8b 52 04             	mov    0x4(%edx),%edx
  802944:	89 50 04             	mov    %edx,0x4(%eax)
  802947:	eb 0b                	jmp    802954 <alloc_block_NF+0x71>
  802949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294c:	8b 40 04             	mov    0x4(%eax),%eax
  80294f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802957:	8b 40 04             	mov    0x4(%eax),%eax
  80295a:	85 c0                	test   %eax,%eax
  80295c:	74 0f                	je     80296d <alloc_block_NF+0x8a>
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	8b 40 04             	mov    0x4(%eax),%eax
  802964:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802967:	8b 12                	mov    (%edx),%edx
  802969:	89 10                	mov    %edx,(%eax)
  80296b:	eb 0a                	jmp    802977 <alloc_block_NF+0x94>
  80296d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802970:	8b 00                	mov    (%eax),%eax
  802972:	a3 38 41 80 00       	mov    %eax,0x804138
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802983:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80298a:	a1 44 41 80 00       	mov    0x804144,%eax
  80298f:	48                   	dec    %eax
  802990:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802998:	e9 11 01 00 00       	jmp    802aae <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  80299d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029a6:	0f 86 c7 00 00 00    	jbe    802a73 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8029ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029b0:	75 17                	jne    8029c9 <alloc_block_NF+0xe6>
  8029b2:	83 ec 04             	sub    $0x4,%esp
  8029b5:	68 e8 3a 80 00       	push   $0x803ae8
  8029ba:	68 fc 00 00 00       	push   $0xfc
  8029bf:	68 77 3a 80 00       	push   $0x803a77
  8029c4:	e8 d4 d9 ff ff       	call   80039d <_panic>
  8029c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029cc:	8b 00                	mov    (%eax),%eax
  8029ce:	85 c0                	test   %eax,%eax
  8029d0:	74 10                	je     8029e2 <alloc_block_NF+0xff>
  8029d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d5:	8b 00                	mov    (%eax),%eax
  8029d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029da:	8b 52 04             	mov    0x4(%edx),%edx
  8029dd:	89 50 04             	mov    %edx,0x4(%eax)
  8029e0:	eb 0b                	jmp    8029ed <alloc_block_NF+0x10a>
  8029e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e5:	8b 40 04             	mov    0x4(%eax),%eax
  8029e8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f0:	8b 40 04             	mov    0x4(%eax),%eax
  8029f3:	85 c0                	test   %eax,%eax
  8029f5:	74 0f                	je     802a06 <alloc_block_NF+0x123>
  8029f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fa:	8b 40 04             	mov    0x4(%eax),%eax
  8029fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a00:	8b 12                	mov    (%edx),%edx
  802a02:	89 10                	mov    %edx,(%eax)
  802a04:	eb 0a                	jmp    802a10 <alloc_block_NF+0x12d>
  802a06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a09:	8b 00                	mov    (%eax),%eax
  802a0b:	a3 48 41 80 00       	mov    %eax,0x804148
  802a10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a23:	a1 54 41 80 00       	mov    0x804154,%eax
  802a28:	48                   	dec    %eax
  802a29:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802a2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a31:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a34:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3d:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802a40:	89 c2                	mov    %eax,%edx
  802a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a45:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4b:	8b 40 08             	mov    0x8(%eax),%eax
  802a4e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a54:	8b 50 08             	mov    0x8(%eax),%edx
  802a57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5d:	01 c2                	add    %eax,%edx
  802a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a62:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802a65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a68:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a6b:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802a6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a71:	eb 3b                	jmp    802aae <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802a73:	a1 40 41 80 00       	mov    0x804140,%eax
  802a78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7f:	74 07                	je     802a88 <alloc_block_NF+0x1a5>
  802a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a84:	8b 00                	mov    (%eax),%eax
  802a86:	eb 05                	jmp    802a8d <alloc_block_NF+0x1aa>
  802a88:	b8 00 00 00 00       	mov    $0x0,%eax
  802a8d:	a3 40 41 80 00       	mov    %eax,0x804140
  802a92:	a1 40 41 80 00       	mov    0x804140,%eax
  802a97:	85 c0                	test   %eax,%eax
  802a99:	0f 85 65 fe ff ff    	jne    802904 <alloc_block_NF+0x21>
  802a9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa3:	0f 85 5b fe ff ff    	jne    802904 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802aa9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802aae:	c9                   	leave  
  802aaf:	c3                   	ret    

00802ab0 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802ab0:	55                   	push   %ebp
  802ab1:	89 e5                	mov    %esp,%ebp
  802ab3:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802aca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ace:	75 17                	jne    802ae7 <addToAvailMemBlocksList+0x37>
  802ad0:	83 ec 04             	sub    $0x4,%esp
  802ad3:	68 90 3a 80 00       	push   $0x803a90
  802ad8:	68 10 01 00 00       	push   $0x110
  802add:	68 77 3a 80 00       	push   $0x803a77
  802ae2:	e8 b6 d8 ff ff       	call   80039d <_panic>
  802ae7:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802aed:	8b 45 08             	mov    0x8(%ebp),%eax
  802af0:	89 50 04             	mov    %edx,0x4(%eax)
  802af3:	8b 45 08             	mov    0x8(%ebp),%eax
  802af6:	8b 40 04             	mov    0x4(%eax),%eax
  802af9:	85 c0                	test   %eax,%eax
  802afb:	74 0c                	je     802b09 <addToAvailMemBlocksList+0x59>
  802afd:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802b02:	8b 55 08             	mov    0x8(%ebp),%edx
  802b05:	89 10                	mov    %edx,(%eax)
  802b07:	eb 08                	jmp    802b11 <addToAvailMemBlocksList+0x61>
  802b09:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0c:	a3 48 41 80 00       	mov    %eax,0x804148
  802b11:	8b 45 08             	mov    0x8(%ebp),%eax
  802b14:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b19:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b22:	a1 54 41 80 00       	mov    0x804154,%eax
  802b27:	40                   	inc    %eax
  802b28:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802b2d:	90                   	nop
  802b2e:	c9                   	leave  
  802b2f:	c3                   	ret    

00802b30 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b30:	55                   	push   %ebp
  802b31:	89 e5                	mov    %esp,%ebp
  802b33:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802b36:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802b3e:	a1 44 41 80 00       	mov    0x804144,%eax
  802b43:	85 c0                	test   %eax,%eax
  802b45:	75 68                	jne    802baf <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802b47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b4b:	75 17                	jne    802b64 <insert_sorted_with_merge_freeList+0x34>
  802b4d:	83 ec 04             	sub    $0x4,%esp
  802b50:	68 54 3a 80 00       	push   $0x803a54
  802b55:	68 1a 01 00 00       	push   $0x11a
  802b5a:	68 77 3a 80 00       	push   $0x803a77
  802b5f:	e8 39 d8 ff ff       	call   80039d <_panic>
  802b64:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6d:	89 10                	mov    %edx,(%eax)
  802b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b72:	8b 00                	mov    (%eax),%eax
  802b74:	85 c0                	test   %eax,%eax
  802b76:	74 0d                	je     802b85 <insert_sorted_with_merge_freeList+0x55>
  802b78:	a1 38 41 80 00       	mov    0x804138,%eax
  802b7d:	8b 55 08             	mov    0x8(%ebp),%edx
  802b80:	89 50 04             	mov    %edx,0x4(%eax)
  802b83:	eb 08                	jmp    802b8d <insert_sorted_with_merge_freeList+0x5d>
  802b85:	8b 45 08             	mov    0x8(%ebp),%eax
  802b88:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b90:	a3 38 41 80 00       	mov    %eax,0x804138
  802b95:	8b 45 08             	mov    0x8(%ebp),%eax
  802b98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b9f:	a1 44 41 80 00       	mov    0x804144,%eax
  802ba4:	40                   	inc    %eax
  802ba5:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802baa:	e9 c5 03 00 00       	jmp    802f74 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb2:	8b 50 08             	mov    0x8(%eax),%edx
  802bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb8:	8b 40 08             	mov    0x8(%eax),%eax
  802bbb:	39 c2                	cmp    %eax,%edx
  802bbd:	0f 83 b2 00 00 00    	jae    802c75 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc6:	8b 50 08             	mov    0x8(%eax),%edx
  802bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcc:	8b 40 0c             	mov    0xc(%eax),%eax
  802bcf:	01 c2                	add    %eax,%edx
  802bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd4:	8b 40 08             	mov    0x8(%eax),%eax
  802bd7:	39 c2                	cmp    %eax,%edx
  802bd9:	75 27                	jne    802c02 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bde:	8b 50 0c             	mov    0xc(%eax),%edx
  802be1:	8b 45 08             	mov    0x8(%ebp),%eax
  802be4:	8b 40 0c             	mov    0xc(%eax),%eax
  802be7:	01 c2                	add    %eax,%edx
  802be9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bec:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802bef:	83 ec 0c             	sub    $0xc,%esp
  802bf2:	ff 75 08             	pushl  0x8(%ebp)
  802bf5:	e8 b6 fe ff ff       	call   802ab0 <addToAvailMemBlocksList>
  802bfa:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802bfd:	e9 72 03 00 00       	jmp    802f74 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802c02:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c06:	74 06                	je     802c0e <insert_sorted_with_merge_freeList+0xde>
  802c08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c0c:	75 17                	jne    802c25 <insert_sorted_with_merge_freeList+0xf5>
  802c0e:	83 ec 04             	sub    $0x4,%esp
  802c11:	68 b4 3a 80 00       	push   $0x803ab4
  802c16:	68 24 01 00 00       	push   $0x124
  802c1b:	68 77 3a 80 00       	push   $0x803a77
  802c20:	e8 78 d7 ff ff       	call   80039d <_panic>
  802c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c28:	8b 10                	mov    (%eax),%edx
  802c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2d:	89 10                	mov    %edx,(%eax)
  802c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c32:	8b 00                	mov    (%eax),%eax
  802c34:	85 c0                	test   %eax,%eax
  802c36:	74 0b                	je     802c43 <insert_sorted_with_merge_freeList+0x113>
  802c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3b:	8b 00                	mov    (%eax),%eax
  802c3d:	8b 55 08             	mov    0x8(%ebp),%edx
  802c40:	89 50 04             	mov    %edx,0x4(%eax)
  802c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c46:	8b 55 08             	mov    0x8(%ebp),%edx
  802c49:	89 10                	mov    %edx,(%eax)
  802c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c51:	89 50 04             	mov    %edx,0x4(%eax)
  802c54:	8b 45 08             	mov    0x8(%ebp),%eax
  802c57:	8b 00                	mov    (%eax),%eax
  802c59:	85 c0                	test   %eax,%eax
  802c5b:	75 08                	jne    802c65 <insert_sorted_with_merge_freeList+0x135>
  802c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c60:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c65:	a1 44 41 80 00       	mov    0x804144,%eax
  802c6a:	40                   	inc    %eax
  802c6b:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802c70:	e9 ff 02 00 00       	jmp    802f74 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802c75:	a1 38 41 80 00       	mov    0x804138,%eax
  802c7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c7d:	e9 c2 02 00 00       	jmp    802f44 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c85:	8b 50 08             	mov    0x8(%eax),%edx
  802c88:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8b:	8b 40 08             	mov    0x8(%eax),%eax
  802c8e:	39 c2                	cmp    %eax,%edx
  802c90:	0f 86 a6 02 00 00    	jbe    802f3c <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c99:	8b 40 04             	mov    0x4(%eax),%eax
  802c9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802c9f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ca3:	0f 85 ba 00 00 00    	jne    802d63 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cac:	8b 50 0c             	mov    0xc(%eax),%edx
  802caf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb2:	8b 40 08             	mov    0x8(%eax),%eax
  802cb5:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cba:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802cbd:	39 c2                	cmp    %eax,%edx
  802cbf:	75 33                	jne    802cf4 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc4:	8b 50 08             	mov    0x8(%eax),%edx
  802cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cca:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd0:	8b 50 0c             	mov    0xc(%eax),%edx
  802cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd6:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd9:	01 c2                	add    %eax,%edx
  802cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cde:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802ce1:	83 ec 0c             	sub    $0xc,%esp
  802ce4:	ff 75 08             	pushl  0x8(%ebp)
  802ce7:	e8 c4 fd ff ff       	call   802ab0 <addToAvailMemBlocksList>
  802cec:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802cef:	e9 80 02 00 00       	jmp    802f74 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802cf4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf8:	74 06                	je     802d00 <insert_sorted_with_merge_freeList+0x1d0>
  802cfa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cfe:	75 17                	jne    802d17 <insert_sorted_with_merge_freeList+0x1e7>
  802d00:	83 ec 04             	sub    $0x4,%esp
  802d03:	68 08 3b 80 00       	push   $0x803b08
  802d08:	68 3a 01 00 00       	push   $0x13a
  802d0d:	68 77 3a 80 00       	push   $0x803a77
  802d12:	e8 86 d6 ff ff       	call   80039d <_panic>
  802d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1a:	8b 50 04             	mov    0x4(%eax),%edx
  802d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d20:	89 50 04             	mov    %edx,0x4(%eax)
  802d23:	8b 45 08             	mov    0x8(%ebp),%eax
  802d26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d29:	89 10                	mov    %edx,(%eax)
  802d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2e:	8b 40 04             	mov    0x4(%eax),%eax
  802d31:	85 c0                	test   %eax,%eax
  802d33:	74 0d                	je     802d42 <insert_sorted_with_merge_freeList+0x212>
  802d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d38:	8b 40 04             	mov    0x4(%eax),%eax
  802d3b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d3e:	89 10                	mov    %edx,(%eax)
  802d40:	eb 08                	jmp    802d4a <insert_sorted_with_merge_freeList+0x21a>
  802d42:	8b 45 08             	mov    0x8(%ebp),%eax
  802d45:	a3 38 41 80 00       	mov    %eax,0x804138
  802d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4d:	8b 55 08             	mov    0x8(%ebp),%edx
  802d50:	89 50 04             	mov    %edx,0x4(%eax)
  802d53:	a1 44 41 80 00       	mov    0x804144,%eax
  802d58:	40                   	inc    %eax
  802d59:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802d5e:	e9 11 02 00 00       	jmp    802f74 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802d63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d66:	8b 50 08             	mov    0x8(%eax),%edx
  802d69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6f:	01 c2                	add    %eax,%edx
  802d71:	8b 45 08             	mov    0x8(%ebp),%eax
  802d74:	8b 40 0c             	mov    0xc(%eax),%eax
  802d77:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7c:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802d7f:	39 c2                	cmp    %eax,%edx
  802d81:	0f 85 bf 00 00 00    	jne    802e46 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802d87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8a:	8b 50 0c             	mov    0xc(%eax),%edx
  802d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d90:	8b 40 0c             	mov    0xc(%eax),%eax
  802d93:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d98:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9b:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802d9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da0:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802da3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802da7:	75 17                	jne    802dc0 <insert_sorted_with_merge_freeList+0x290>
  802da9:	83 ec 04             	sub    $0x4,%esp
  802dac:	68 e8 3a 80 00       	push   $0x803ae8
  802db1:	68 43 01 00 00       	push   $0x143
  802db6:	68 77 3a 80 00       	push   $0x803a77
  802dbb:	e8 dd d5 ff ff       	call   80039d <_panic>
  802dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc3:	8b 00                	mov    (%eax),%eax
  802dc5:	85 c0                	test   %eax,%eax
  802dc7:	74 10                	je     802dd9 <insert_sorted_with_merge_freeList+0x2a9>
  802dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcc:	8b 00                	mov    (%eax),%eax
  802dce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd1:	8b 52 04             	mov    0x4(%edx),%edx
  802dd4:	89 50 04             	mov    %edx,0x4(%eax)
  802dd7:	eb 0b                	jmp    802de4 <insert_sorted_with_merge_freeList+0x2b4>
  802dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddc:	8b 40 04             	mov    0x4(%eax),%eax
  802ddf:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de7:	8b 40 04             	mov    0x4(%eax),%eax
  802dea:	85 c0                	test   %eax,%eax
  802dec:	74 0f                	je     802dfd <insert_sorted_with_merge_freeList+0x2cd>
  802dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df1:	8b 40 04             	mov    0x4(%eax),%eax
  802df4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802df7:	8b 12                	mov    (%edx),%edx
  802df9:	89 10                	mov    %edx,(%eax)
  802dfb:	eb 0a                	jmp    802e07 <insert_sorted_with_merge_freeList+0x2d7>
  802dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e00:	8b 00                	mov    (%eax),%eax
  802e02:	a3 38 41 80 00       	mov    %eax,0x804138
  802e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e1a:	a1 44 41 80 00       	mov    0x804144,%eax
  802e1f:	48                   	dec    %eax
  802e20:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802e25:	83 ec 0c             	sub    $0xc,%esp
  802e28:	ff 75 08             	pushl  0x8(%ebp)
  802e2b:	e8 80 fc ff ff       	call   802ab0 <addToAvailMemBlocksList>
  802e30:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802e33:	83 ec 0c             	sub    $0xc,%esp
  802e36:	ff 75 f4             	pushl  -0xc(%ebp)
  802e39:	e8 72 fc ff ff       	call   802ab0 <addToAvailMemBlocksList>
  802e3e:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802e41:	e9 2e 01 00 00       	jmp    802f74 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802e46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e49:	8b 50 08             	mov    0x8(%eax),%edx
  802e4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e4f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e52:	01 c2                	add    %eax,%edx
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	8b 40 08             	mov    0x8(%eax),%eax
  802e5a:	39 c2                	cmp    %eax,%edx
  802e5c:	75 27                	jne    802e85 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802e5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e61:	8b 50 0c             	mov    0xc(%eax),%edx
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6a:	01 c2                	add    %eax,%edx
  802e6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6f:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802e72:	83 ec 0c             	sub    $0xc,%esp
  802e75:	ff 75 08             	pushl  0x8(%ebp)
  802e78:	e8 33 fc ff ff       	call   802ab0 <addToAvailMemBlocksList>
  802e7d:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802e80:	e9 ef 00 00 00       	jmp    802f74 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802e85:	8b 45 08             	mov    0x8(%ebp),%eax
  802e88:	8b 50 0c             	mov    0xc(%eax),%edx
  802e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8e:	8b 40 08             	mov    0x8(%eax),%eax
  802e91:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e96:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802e99:	39 c2                	cmp    %eax,%edx
  802e9b:	75 33                	jne    802ed0 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea0:	8b 50 08             	mov    0x8(%eax),%edx
  802ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea6:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eac:	8b 50 0c             	mov    0xc(%eax),%edx
  802eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb2:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb5:	01 c2                	add    %eax,%edx
  802eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eba:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802ebd:	83 ec 0c             	sub    $0xc,%esp
  802ec0:	ff 75 08             	pushl  0x8(%ebp)
  802ec3:	e8 e8 fb ff ff       	call   802ab0 <addToAvailMemBlocksList>
  802ec8:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802ecb:	e9 a4 00 00 00       	jmp    802f74 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802ed0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed4:	74 06                	je     802edc <insert_sorted_with_merge_freeList+0x3ac>
  802ed6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eda:	75 17                	jne    802ef3 <insert_sorted_with_merge_freeList+0x3c3>
  802edc:	83 ec 04             	sub    $0x4,%esp
  802edf:	68 08 3b 80 00       	push   $0x803b08
  802ee4:	68 56 01 00 00       	push   $0x156
  802ee9:	68 77 3a 80 00       	push   $0x803a77
  802eee:	e8 aa d4 ff ff       	call   80039d <_panic>
  802ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef6:	8b 50 04             	mov    0x4(%eax),%edx
  802ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  802efc:	89 50 04             	mov    %edx,0x4(%eax)
  802eff:	8b 45 08             	mov    0x8(%ebp),%eax
  802f02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f05:	89 10                	mov    %edx,(%eax)
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	8b 40 04             	mov    0x4(%eax),%eax
  802f0d:	85 c0                	test   %eax,%eax
  802f0f:	74 0d                	je     802f1e <insert_sorted_with_merge_freeList+0x3ee>
  802f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f14:	8b 40 04             	mov    0x4(%eax),%eax
  802f17:	8b 55 08             	mov    0x8(%ebp),%edx
  802f1a:	89 10                	mov    %edx,(%eax)
  802f1c:	eb 08                	jmp    802f26 <insert_sorted_with_merge_freeList+0x3f6>
  802f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f21:	a3 38 41 80 00       	mov    %eax,0x804138
  802f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f29:	8b 55 08             	mov    0x8(%ebp),%edx
  802f2c:	89 50 04             	mov    %edx,0x4(%eax)
  802f2f:	a1 44 41 80 00       	mov    0x804144,%eax
  802f34:	40                   	inc    %eax
  802f35:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802f3a:	eb 38                	jmp    802f74 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802f3c:	a1 40 41 80 00       	mov    0x804140,%eax
  802f41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f48:	74 07                	je     802f51 <insert_sorted_with_merge_freeList+0x421>
  802f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4d:	8b 00                	mov    (%eax),%eax
  802f4f:	eb 05                	jmp    802f56 <insert_sorted_with_merge_freeList+0x426>
  802f51:	b8 00 00 00 00       	mov    $0x0,%eax
  802f56:	a3 40 41 80 00       	mov    %eax,0x804140
  802f5b:	a1 40 41 80 00       	mov    0x804140,%eax
  802f60:	85 c0                	test   %eax,%eax
  802f62:	0f 85 1a fd ff ff    	jne    802c82 <insert_sorted_with_merge_freeList+0x152>
  802f68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f6c:	0f 85 10 fd ff ff    	jne    802c82 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f72:	eb 00                	jmp    802f74 <insert_sorted_with_merge_freeList+0x444>
  802f74:	90                   	nop
  802f75:	c9                   	leave  
  802f76:	c3                   	ret    
  802f77:	90                   	nop

00802f78 <__udivdi3>:
  802f78:	55                   	push   %ebp
  802f79:	57                   	push   %edi
  802f7a:	56                   	push   %esi
  802f7b:	53                   	push   %ebx
  802f7c:	83 ec 1c             	sub    $0x1c,%esp
  802f7f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802f83:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802f87:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802f8b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f8f:	89 ca                	mov    %ecx,%edx
  802f91:	89 f8                	mov    %edi,%eax
  802f93:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802f97:	85 f6                	test   %esi,%esi
  802f99:	75 2d                	jne    802fc8 <__udivdi3+0x50>
  802f9b:	39 cf                	cmp    %ecx,%edi
  802f9d:	77 65                	ja     803004 <__udivdi3+0x8c>
  802f9f:	89 fd                	mov    %edi,%ebp
  802fa1:	85 ff                	test   %edi,%edi
  802fa3:	75 0b                	jne    802fb0 <__udivdi3+0x38>
  802fa5:	b8 01 00 00 00       	mov    $0x1,%eax
  802faa:	31 d2                	xor    %edx,%edx
  802fac:	f7 f7                	div    %edi
  802fae:	89 c5                	mov    %eax,%ebp
  802fb0:	31 d2                	xor    %edx,%edx
  802fb2:	89 c8                	mov    %ecx,%eax
  802fb4:	f7 f5                	div    %ebp
  802fb6:	89 c1                	mov    %eax,%ecx
  802fb8:	89 d8                	mov    %ebx,%eax
  802fba:	f7 f5                	div    %ebp
  802fbc:	89 cf                	mov    %ecx,%edi
  802fbe:	89 fa                	mov    %edi,%edx
  802fc0:	83 c4 1c             	add    $0x1c,%esp
  802fc3:	5b                   	pop    %ebx
  802fc4:	5e                   	pop    %esi
  802fc5:	5f                   	pop    %edi
  802fc6:	5d                   	pop    %ebp
  802fc7:	c3                   	ret    
  802fc8:	39 ce                	cmp    %ecx,%esi
  802fca:	77 28                	ja     802ff4 <__udivdi3+0x7c>
  802fcc:	0f bd fe             	bsr    %esi,%edi
  802fcf:	83 f7 1f             	xor    $0x1f,%edi
  802fd2:	75 40                	jne    803014 <__udivdi3+0x9c>
  802fd4:	39 ce                	cmp    %ecx,%esi
  802fd6:	72 0a                	jb     802fe2 <__udivdi3+0x6a>
  802fd8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802fdc:	0f 87 9e 00 00 00    	ja     803080 <__udivdi3+0x108>
  802fe2:	b8 01 00 00 00       	mov    $0x1,%eax
  802fe7:	89 fa                	mov    %edi,%edx
  802fe9:	83 c4 1c             	add    $0x1c,%esp
  802fec:	5b                   	pop    %ebx
  802fed:	5e                   	pop    %esi
  802fee:	5f                   	pop    %edi
  802fef:	5d                   	pop    %ebp
  802ff0:	c3                   	ret    
  802ff1:	8d 76 00             	lea    0x0(%esi),%esi
  802ff4:	31 ff                	xor    %edi,%edi
  802ff6:	31 c0                	xor    %eax,%eax
  802ff8:	89 fa                	mov    %edi,%edx
  802ffa:	83 c4 1c             	add    $0x1c,%esp
  802ffd:	5b                   	pop    %ebx
  802ffe:	5e                   	pop    %esi
  802fff:	5f                   	pop    %edi
  803000:	5d                   	pop    %ebp
  803001:	c3                   	ret    
  803002:	66 90                	xchg   %ax,%ax
  803004:	89 d8                	mov    %ebx,%eax
  803006:	f7 f7                	div    %edi
  803008:	31 ff                	xor    %edi,%edi
  80300a:	89 fa                	mov    %edi,%edx
  80300c:	83 c4 1c             	add    $0x1c,%esp
  80300f:	5b                   	pop    %ebx
  803010:	5e                   	pop    %esi
  803011:	5f                   	pop    %edi
  803012:	5d                   	pop    %ebp
  803013:	c3                   	ret    
  803014:	bd 20 00 00 00       	mov    $0x20,%ebp
  803019:	89 eb                	mov    %ebp,%ebx
  80301b:	29 fb                	sub    %edi,%ebx
  80301d:	89 f9                	mov    %edi,%ecx
  80301f:	d3 e6                	shl    %cl,%esi
  803021:	89 c5                	mov    %eax,%ebp
  803023:	88 d9                	mov    %bl,%cl
  803025:	d3 ed                	shr    %cl,%ebp
  803027:	89 e9                	mov    %ebp,%ecx
  803029:	09 f1                	or     %esi,%ecx
  80302b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80302f:	89 f9                	mov    %edi,%ecx
  803031:	d3 e0                	shl    %cl,%eax
  803033:	89 c5                	mov    %eax,%ebp
  803035:	89 d6                	mov    %edx,%esi
  803037:	88 d9                	mov    %bl,%cl
  803039:	d3 ee                	shr    %cl,%esi
  80303b:	89 f9                	mov    %edi,%ecx
  80303d:	d3 e2                	shl    %cl,%edx
  80303f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803043:	88 d9                	mov    %bl,%cl
  803045:	d3 e8                	shr    %cl,%eax
  803047:	09 c2                	or     %eax,%edx
  803049:	89 d0                	mov    %edx,%eax
  80304b:	89 f2                	mov    %esi,%edx
  80304d:	f7 74 24 0c          	divl   0xc(%esp)
  803051:	89 d6                	mov    %edx,%esi
  803053:	89 c3                	mov    %eax,%ebx
  803055:	f7 e5                	mul    %ebp
  803057:	39 d6                	cmp    %edx,%esi
  803059:	72 19                	jb     803074 <__udivdi3+0xfc>
  80305b:	74 0b                	je     803068 <__udivdi3+0xf0>
  80305d:	89 d8                	mov    %ebx,%eax
  80305f:	31 ff                	xor    %edi,%edi
  803061:	e9 58 ff ff ff       	jmp    802fbe <__udivdi3+0x46>
  803066:	66 90                	xchg   %ax,%ax
  803068:	8b 54 24 08          	mov    0x8(%esp),%edx
  80306c:	89 f9                	mov    %edi,%ecx
  80306e:	d3 e2                	shl    %cl,%edx
  803070:	39 c2                	cmp    %eax,%edx
  803072:	73 e9                	jae    80305d <__udivdi3+0xe5>
  803074:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803077:	31 ff                	xor    %edi,%edi
  803079:	e9 40 ff ff ff       	jmp    802fbe <__udivdi3+0x46>
  80307e:	66 90                	xchg   %ax,%ax
  803080:	31 c0                	xor    %eax,%eax
  803082:	e9 37 ff ff ff       	jmp    802fbe <__udivdi3+0x46>
  803087:	90                   	nop

00803088 <__umoddi3>:
  803088:	55                   	push   %ebp
  803089:	57                   	push   %edi
  80308a:	56                   	push   %esi
  80308b:	53                   	push   %ebx
  80308c:	83 ec 1c             	sub    $0x1c,%esp
  80308f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803093:	8b 74 24 34          	mov    0x34(%esp),%esi
  803097:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80309b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80309f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8030a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8030a7:	89 f3                	mov    %esi,%ebx
  8030a9:	89 fa                	mov    %edi,%edx
  8030ab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8030af:	89 34 24             	mov    %esi,(%esp)
  8030b2:	85 c0                	test   %eax,%eax
  8030b4:	75 1a                	jne    8030d0 <__umoddi3+0x48>
  8030b6:	39 f7                	cmp    %esi,%edi
  8030b8:	0f 86 a2 00 00 00    	jbe    803160 <__umoddi3+0xd8>
  8030be:	89 c8                	mov    %ecx,%eax
  8030c0:	89 f2                	mov    %esi,%edx
  8030c2:	f7 f7                	div    %edi
  8030c4:	89 d0                	mov    %edx,%eax
  8030c6:	31 d2                	xor    %edx,%edx
  8030c8:	83 c4 1c             	add    $0x1c,%esp
  8030cb:	5b                   	pop    %ebx
  8030cc:	5e                   	pop    %esi
  8030cd:	5f                   	pop    %edi
  8030ce:	5d                   	pop    %ebp
  8030cf:	c3                   	ret    
  8030d0:	39 f0                	cmp    %esi,%eax
  8030d2:	0f 87 ac 00 00 00    	ja     803184 <__umoddi3+0xfc>
  8030d8:	0f bd e8             	bsr    %eax,%ebp
  8030db:	83 f5 1f             	xor    $0x1f,%ebp
  8030de:	0f 84 ac 00 00 00    	je     803190 <__umoddi3+0x108>
  8030e4:	bf 20 00 00 00       	mov    $0x20,%edi
  8030e9:	29 ef                	sub    %ebp,%edi
  8030eb:	89 fe                	mov    %edi,%esi
  8030ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8030f1:	89 e9                	mov    %ebp,%ecx
  8030f3:	d3 e0                	shl    %cl,%eax
  8030f5:	89 d7                	mov    %edx,%edi
  8030f7:	89 f1                	mov    %esi,%ecx
  8030f9:	d3 ef                	shr    %cl,%edi
  8030fb:	09 c7                	or     %eax,%edi
  8030fd:	89 e9                	mov    %ebp,%ecx
  8030ff:	d3 e2                	shl    %cl,%edx
  803101:	89 14 24             	mov    %edx,(%esp)
  803104:	89 d8                	mov    %ebx,%eax
  803106:	d3 e0                	shl    %cl,%eax
  803108:	89 c2                	mov    %eax,%edx
  80310a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80310e:	d3 e0                	shl    %cl,%eax
  803110:	89 44 24 04          	mov    %eax,0x4(%esp)
  803114:	8b 44 24 08          	mov    0x8(%esp),%eax
  803118:	89 f1                	mov    %esi,%ecx
  80311a:	d3 e8                	shr    %cl,%eax
  80311c:	09 d0                	or     %edx,%eax
  80311e:	d3 eb                	shr    %cl,%ebx
  803120:	89 da                	mov    %ebx,%edx
  803122:	f7 f7                	div    %edi
  803124:	89 d3                	mov    %edx,%ebx
  803126:	f7 24 24             	mull   (%esp)
  803129:	89 c6                	mov    %eax,%esi
  80312b:	89 d1                	mov    %edx,%ecx
  80312d:	39 d3                	cmp    %edx,%ebx
  80312f:	0f 82 87 00 00 00    	jb     8031bc <__umoddi3+0x134>
  803135:	0f 84 91 00 00 00    	je     8031cc <__umoddi3+0x144>
  80313b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80313f:	29 f2                	sub    %esi,%edx
  803141:	19 cb                	sbb    %ecx,%ebx
  803143:	89 d8                	mov    %ebx,%eax
  803145:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803149:	d3 e0                	shl    %cl,%eax
  80314b:	89 e9                	mov    %ebp,%ecx
  80314d:	d3 ea                	shr    %cl,%edx
  80314f:	09 d0                	or     %edx,%eax
  803151:	89 e9                	mov    %ebp,%ecx
  803153:	d3 eb                	shr    %cl,%ebx
  803155:	89 da                	mov    %ebx,%edx
  803157:	83 c4 1c             	add    $0x1c,%esp
  80315a:	5b                   	pop    %ebx
  80315b:	5e                   	pop    %esi
  80315c:	5f                   	pop    %edi
  80315d:	5d                   	pop    %ebp
  80315e:	c3                   	ret    
  80315f:	90                   	nop
  803160:	89 fd                	mov    %edi,%ebp
  803162:	85 ff                	test   %edi,%edi
  803164:	75 0b                	jne    803171 <__umoddi3+0xe9>
  803166:	b8 01 00 00 00       	mov    $0x1,%eax
  80316b:	31 d2                	xor    %edx,%edx
  80316d:	f7 f7                	div    %edi
  80316f:	89 c5                	mov    %eax,%ebp
  803171:	89 f0                	mov    %esi,%eax
  803173:	31 d2                	xor    %edx,%edx
  803175:	f7 f5                	div    %ebp
  803177:	89 c8                	mov    %ecx,%eax
  803179:	f7 f5                	div    %ebp
  80317b:	89 d0                	mov    %edx,%eax
  80317d:	e9 44 ff ff ff       	jmp    8030c6 <__umoddi3+0x3e>
  803182:	66 90                	xchg   %ax,%ax
  803184:	89 c8                	mov    %ecx,%eax
  803186:	89 f2                	mov    %esi,%edx
  803188:	83 c4 1c             	add    $0x1c,%esp
  80318b:	5b                   	pop    %ebx
  80318c:	5e                   	pop    %esi
  80318d:	5f                   	pop    %edi
  80318e:	5d                   	pop    %ebp
  80318f:	c3                   	ret    
  803190:	3b 04 24             	cmp    (%esp),%eax
  803193:	72 06                	jb     80319b <__umoddi3+0x113>
  803195:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803199:	77 0f                	ja     8031aa <__umoddi3+0x122>
  80319b:	89 f2                	mov    %esi,%edx
  80319d:	29 f9                	sub    %edi,%ecx
  80319f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8031a3:	89 14 24             	mov    %edx,(%esp)
  8031a6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031aa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8031ae:	8b 14 24             	mov    (%esp),%edx
  8031b1:	83 c4 1c             	add    $0x1c,%esp
  8031b4:	5b                   	pop    %ebx
  8031b5:	5e                   	pop    %esi
  8031b6:	5f                   	pop    %edi
  8031b7:	5d                   	pop    %ebp
  8031b8:	c3                   	ret    
  8031b9:	8d 76 00             	lea    0x0(%esi),%esi
  8031bc:	2b 04 24             	sub    (%esp),%eax
  8031bf:	19 fa                	sbb    %edi,%edx
  8031c1:	89 d1                	mov    %edx,%ecx
  8031c3:	89 c6                	mov    %eax,%esi
  8031c5:	e9 71 ff ff ff       	jmp    80313b <__umoddi3+0xb3>
  8031ca:	66 90                	xchg   %ax,%ax
  8031cc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8031d0:	72 ea                	jb     8031bc <__umoddi3+0x134>
  8031d2:	89 d9                	mov    %ebx,%ecx
  8031d4:	e9 62 ff ff ff       	jmp    80313b <__umoddi3+0xb3>
