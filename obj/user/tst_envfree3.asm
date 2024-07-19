
obj/user/tst_envfree3:     file format elf32-i386


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
  800031:	e8 5f 01 00 00       	call   800195 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	// Testing scenario 3: Freeing the allocated shared variables [covers: smalloc (1 env) & sget (multiple envs)]
	// Testing removing the shared variables
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 e0 31 80 00       	push   $0x8031e0
  80004a:	e8 10 16 00 00       	call   80165f <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 c0 18 00 00       	call   801923 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 58 19 00 00       	call   8019c3 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 f0 31 80 00       	push   $0x8031f0
  800079:	e8 07 05 00 00       	call   800585 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", 2000,(myEnv->SecondListSize), 50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 23 32 80 00       	push   $0x803223
  800099:	e8 f7 1a 00 00       	call   801b95 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr2", 2000,(myEnv->SecondListSize), 50);
  8000a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8000a9:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000af:	6a 32                	push   $0x32
  8000b1:	50                   	push   %eax
  8000b2:	68 d0 07 00 00       	push   $0x7d0
  8000b7:	68 2c 32 80 00       	push   $0x80322c
  8000bc:	e8 d4 1a 00 00       	call   801b95 <sys_create_env>
  8000c1:	83 c4 10             	add    $0x10,%esp
  8000c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	ff 75 e8             	pushl  -0x18(%ebp)
  8000cd:	e8 e1 1a 00 00       	call   801bb3 <sys_run_env>
  8000d2:	83 c4 10             	add    $0x10,%esp
	env_sleep(5000) ;
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 88 13 00 00       	push   $0x1388
  8000dd:	e8 c9 2d 00 00       	call   802eab <env_sleep>
  8000e2:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000eb:	e8 c3 1a 00 00       	call   801bb3 <sys_run_env>
  8000f0:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000f3:	90                   	nop
  8000f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f7:	8b 00                	mov    (%eax),%eax
  8000f9:	83 f8 02             	cmp    $0x2,%eax
  8000fc:	75 f6                	jne    8000f4 <_main+0xbc>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000fe:	e8 20 18 00 00       	call   801923 <sys_calculate_free_frames>
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	50                   	push   %eax
  800107:	68 38 32 80 00       	push   $0x803238
  80010c:	e8 74 04 00 00       	call   800585 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	ff 75 e8             	pushl  -0x18(%ebp)
  80011a:	e8 b0 1a 00 00       	call   801bcf <sys_destroy_env>
  80011f:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	ff 75 e4             	pushl  -0x1c(%ebp)
  800128:	e8 a2 1a 00 00       	call   801bcf <sys_destroy_env>
  80012d:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  800130:	e8 ee 17 00 00       	call   801923 <sys_calculate_free_frames>
  800135:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800138:	e8 86 18 00 00       	call   8019c3 <sys_pf_calculate_allocated_pages>
  80013d:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  800140:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800143:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800146:	74 27                	je     80016f <_main+0x137>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	ff 75 e0             	pushl  -0x20(%ebp)
  80014e:	68 6c 32 80 00       	push   $0x80326c
  800153:	e8 2d 04 00 00       	call   800585 <cprintf>
  800158:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  80015b:	83 ec 04             	sub    $0x4,%esp
  80015e:	68 bc 32 80 00       	push   $0x8032bc
  800163:	6a 23                	push   $0x23
  800165:	68 f2 32 80 00       	push   $0x8032f2
  80016a:	e8 62 01 00 00       	call   8002d1 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	ff 75 e0             	pushl  -0x20(%ebp)
  800175:	68 08 33 80 00       	push   $0x803308
  80017a:	e8 06 04 00 00       	call   800585 <cprintf>
  80017f:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 3 for envfree completed successfully.\n");
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 68 33 80 00       	push   $0x803368
  80018a:	e8 f6 03 00 00       	call   800585 <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp
	return;
  800192:	90                   	nop
}
  800193:	c9                   	leave  
  800194:	c3                   	ret    

00800195 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800195:	55                   	push   %ebp
  800196:	89 e5                	mov    %esp,%ebp
  800198:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80019b:	e8 63 1a 00 00       	call   801c03 <sys_getenvindex>
  8001a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001a6:	89 d0                	mov    %edx,%eax
  8001a8:	c1 e0 03             	shl    $0x3,%eax
  8001ab:	01 d0                	add    %edx,%eax
  8001ad:	01 c0                	add    %eax,%eax
  8001af:	01 d0                	add    %edx,%eax
  8001b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b8:	01 d0                	add    %edx,%eax
  8001ba:	c1 e0 04             	shl    $0x4,%eax
  8001bd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001c2:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001c7:	a1 20 40 80 00       	mov    0x804020,%eax
  8001cc:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001d2:	84 c0                	test   %al,%al
  8001d4:	74 0f                	je     8001e5 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001d6:	a1 20 40 80 00       	mov    0x804020,%eax
  8001db:	05 5c 05 00 00       	add    $0x55c,%eax
  8001e0:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001e9:	7e 0a                	jle    8001f5 <libmain+0x60>
		binaryname = argv[0];
  8001eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ee:	8b 00                	mov    (%eax),%eax
  8001f0:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001f5:	83 ec 08             	sub    $0x8,%esp
  8001f8:	ff 75 0c             	pushl  0xc(%ebp)
  8001fb:	ff 75 08             	pushl  0x8(%ebp)
  8001fe:	e8 35 fe ff ff       	call   800038 <_main>
  800203:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800206:	e8 05 18 00 00       	call   801a10 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	68 cc 33 80 00       	push   $0x8033cc
  800213:	e8 6d 03 00 00       	call   800585 <cprintf>
  800218:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80021b:	a1 20 40 80 00       	mov    0x804020,%eax
  800220:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800226:	a1 20 40 80 00       	mov    0x804020,%eax
  80022b:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800231:	83 ec 04             	sub    $0x4,%esp
  800234:	52                   	push   %edx
  800235:	50                   	push   %eax
  800236:	68 f4 33 80 00       	push   $0x8033f4
  80023b:	e8 45 03 00 00       	call   800585 <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800243:	a1 20 40 80 00       	mov    0x804020,%eax
  800248:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80024e:	a1 20 40 80 00       	mov    0x804020,%eax
  800253:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800259:	a1 20 40 80 00       	mov    0x804020,%eax
  80025e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800264:	51                   	push   %ecx
  800265:	52                   	push   %edx
  800266:	50                   	push   %eax
  800267:	68 1c 34 80 00       	push   $0x80341c
  80026c:	e8 14 03 00 00       	call   800585 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800274:	a1 20 40 80 00       	mov    0x804020,%eax
  800279:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80027f:	83 ec 08             	sub    $0x8,%esp
  800282:	50                   	push   %eax
  800283:	68 74 34 80 00       	push   $0x803474
  800288:	e8 f8 02 00 00       	call   800585 <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 cc 33 80 00       	push   $0x8033cc
  800298:	e8 e8 02 00 00       	call   800585 <cprintf>
  80029d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002a0:	e8 85 17 00 00       	call   801a2a <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002a5:	e8 19 00 00 00       	call   8002c3 <exit>
}
  8002aa:	90                   	nop
  8002ab:	c9                   	leave  
  8002ac:	c3                   	ret    

008002ad <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002ad:	55                   	push   %ebp
  8002ae:	89 e5                	mov    %esp,%ebp
  8002b0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002b3:	83 ec 0c             	sub    $0xc,%esp
  8002b6:	6a 00                	push   $0x0
  8002b8:	e8 12 19 00 00       	call   801bcf <sys_destroy_env>
  8002bd:	83 c4 10             	add    $0x10,%esp
}
  8002c0:	90                   	nop
  8002c1:	c9                   	leave  
  8002c2:	c3                   	ret    

008002c3 <exit>:

void
exit(void)
{
  8002c3:	55                   	push   %ebp
  8002c4:	89 e5                	mov    %esp,%ebp
  8002c6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002c9:	e8 67 19 00 00       	call   801c35 <sys_exit_env>
}
  8002ce:	90                   	nop
  8002cf:	c9                   	leave  
  8002d0:	c3                   	ret    

008002d1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002d7:	8d 45 10             	lea    0x10(%ebp),%eax
  8002da:	83 c0 04             	add    $0x4,%eax
  8002dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002e0:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002e5:	85 c0                	test   %eax,%eax
  8002e7:	74 16                	je     8002ff <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002e9:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002ee:	83 ec 08             	sub    $0x8,%esp
  8002f1:	50                   	push   %eax
  8002f2:	68 88 34 80 00       	push   $0x803488
  8002f7:	e8 89 02 00 00       	call   800585 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ff:	a1 00 40 80 00       	mov    0x804000,%eax
  800304:	ff 75 0c             	pushl  0xc(%ebp)
  800307:	ff 75 08             	pushl  0x8(%ebp)
  80030a:	50                   	push   %eax
  80030b:	68 8d 34 80 00       	push   $0x80348d
  800310:	e8 70 02 00 00       	call   800585 <cprintf>
  800315:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800318:	8b 45 10             	mov    0x10(%ebp),%eax
  80031b:	83 ec 08             	sub    $0x8,%esp
  80031e:	ff 75 f4             	pushl  -0xc(%ebp)
  800321:	50                   	push   %eax
  800322:	e8 f3 01 00 00       	call   80051a <vcprintf>
  800327:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80032a:	83 ec 08             	sub    $0x8,%esp
  80032d:	6a 00                	push   $0x0
  80032f:	68 a9 34 80 00       	push   $0x8034a9
  800334:	e8 e1 01 00 00       	call   80051a <vcprintf>
  800339:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80033c:	e8 82 ff ff ff       	call   8002c3 <exit>

	// should not return here
	while (1) ;
  800341:	eb fe                	jmp    800341 <_panic+0x70>

00800343 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800343:	55                   	push   %ebp
  800344:	89 e5                	mov    %esp,%ebp
  800346:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800349:	a1 20 40 80 00       	mov    0x804020,%eax
  80034e:	8b 50 74             	mov    0x74(%eax),%edx
  800351:	8b 45 0c             	mov    0xc(%ebp),%eax
  800354:	39 c2                	cmp    %eax,%edx
  800356:	74 14                	je     80036c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800358:	83 ec 04             	sub    $0x4,%esp
  80035b:	68 ac 34 80 00       	push   $0x8034ac
  800360:	6a 26                	push   $0x26
  800362:	68 f8 34 80 00       	push   $0x8034f8
  800367:	e8 65 ff ff ff       	call   8002d1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80036c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800373:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80037a:	e9 c2 00 00 00       	jmp    800441 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80037f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800382:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	01 d0                	add    %edx,%eax
  80038e:	8b 00                	mov    (%eax),%eax
  800390:	85 c0                	test   %eax,%eax
  800392:	75 08                	jne    80039c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800394:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800397:	e9 a2 00 00 00       	jmp    80043e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80039c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003a3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003aa:	eb 69                	jmp    800415 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003ba:	89 d0                	mov    %edx,%eax
  8003bc:	01 c0                	add    %eax,%eax
  8003be:	01 d0                	add    %edx,%eax
  8003c0:	c1 e0 03             	shl    $0x3,%eax
  8003c3:	01 c8                	add    %ecx,%eax
  8003c5:	8a 40 04             	mov    0x4(%eax),%al
  8003c8:	84 c0                	test   %al,%al
  8003ca:	75 46                	jne    800412 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8003d1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003da:	89 d0                	mov    %edx,%eax
  8003dc:	01 c0                	add    %eax,%eax
  8003de:	01 d0                	add    %edx,%eax
  8003e0:	c1 e0 03             	shl    $0x3,%eax
  8003e3:	01 c8                	add    %ecx,%eax
  8003e5:	8b 00                	mov    (%eax),%eax
  8003e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003f2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800401:	01 c8                	add    %ecx,%eax
  800403:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800405:	39 c2                	cmp    %eax,%edx
  800407:	75 09                	jne    800412 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800409:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800410:	eb 12                	jmp    800424 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800412:	ff 45 e8             	incl   -0x18(%ebp)
  800415:	a1 20 40 80 00       	mov    0x804020,%eax
  80041a:	8b 50 74             	mov    0x74(%eax),%edx
  80041d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800420:	39 c2                	cmp    %eax,%edx
  800422:	77 88                	ja     8003ac <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800424:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800428:	75 14                	jne    80043e <CheckWSWithoutLastIndex+0xfb>
			panic(
  80042a:	83 ec 04             	sub    $0x4,%esp
  80042d:	68 04 35 80 00       	push   $0x803504
  800432:	6a 3a                	push   $0x3a
  800434:	68 f8 34 80 00       	push   $0x8034f8
  800439:	e8 93 fe ff ff       	call   8002d1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80043e:	ff 45 f0             	incl   -0x10(%ebp)
  800441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800444:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800447:	0f 8c 32 ff ff ff    	jl     80037f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80044d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800454:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80045b:	eb 26                	jmp    800483 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80045d:	a1 20 40 80 00       	mov    0x804020,%eax
  800462:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800468:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80046b:	89 d0                	mov    %edx,%eax
  80046d:	01 c0                	add    %eax,%eax
  80046f:	01 d0                	add    %edx,%eax
  800471:	c1 e0 03             	shl    $0x3,%eax
  800474:	01 c8                	add    %ecx,%eax
  800476:	8a 40 04             	mov    0x4(%eax),%al
  800479:	3c 01                	cmp    $0x1,%al
  80047b:	75 03                	jne    800480 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80047d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800480:	ff 45 e0             	incl   -0x20(%ebp)
  800483:	a1 20 40 80 00       	mov    0x804020,%eax
  800488:	8b 50 74             	mov    0x74(%eax),%edx
  80048b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80048e:	39 c2                	cmp    %eax,%edx
  800490:	77 cb                	ja     80045d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800495:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800498:	74 14                	je     8004ae <CheckWSWithoutLastIndex+0x16b>
		panic(
  80049a:	83 ec 04             	sub    $0x4,%esp
  80049d:	68 58 35 80 00       	push   $0x803558
  8004a2:	6a 44                	push   $0x44
  8004a4:	68 f8 34 80 00       	push   $0x8034f8
  8004a9:	e8 23 fe ff ff       	call   8002d1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004ae:	90                   	nop
  8004af:	c9                   	leave  
  8004b0:	c3                   	ret    

008004b1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004b1:	55                   	push   %ebp
  8004b2:	89 e5                	mov    %esp,%ebp
  8004b4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	8d 48 01             	lea    0x1(%eax),%ecx
  8004bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c2:	89 0a                	mov    %ecx,(%edx)
  8004c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c7:	88 d1                	mov    %dl,%cl
  8004c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d3:	8b 00                	mov    (%eax),%eax
  8004d5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004da:	75 2c                	jne    800508 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004dc:	a0 24 40 80 00       	mov    0x804024,%al
  8004e1:	0f b6 c0             	movzbl %al,%eax
  8004e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e7:	8b 12                	mov    (%edx),%edx
  8004e9:	89 d1                	mov    %edx,%ecx
  8004eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ee:	83 c2 08             	add    $0x8,%edx
  8004f1:	83 ec 04             	sub    $0x4,%esp
  8004f4:	50                   	push   %eax
  8004f5:	51                   	push   %ecx
  8004f6:	52                   	push   %edx
  8004f7:	e8 66 13 00 00       	call   801862 <sys_cputs>
  8004fc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800502:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050b:	8b 40 04             	mov    0x4(%eax),%eax
  80050e:	8d 50 01             	lea    0x1(%eax),%edx
  800511:	8b 45 0c             	mov    0xc(%ebp),%eax
  800514:	89 50 04             	mov    %edx,0x4(%eax)
}
  800517:	90                   	nop
  800518:	c9                   	leave  
  800519:	c3                   	ret    

0080051a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80051a:	55                   	push   %ebp
  80051b:	89 e5                	mov    %esp,%ebp
  80051d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800523:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80052a:	00 00 00 
	b.cnt = 0;
  80052d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800534:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800537:	ff 75 0c             	pushl  0xc(%ebp)
  80053a:	ff 75 08             	pushl  0x8(%ebp)
  80053d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800543:	50                   	push   %eax
  800544:	68 b1 04 80 00       	push   $0x8004b1
  800549:	e8 11 02 00 00       	call   80075f <vprintfmt>
  80054e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800551:	a0 24 40 80 00       	mov    0x804024,%al
  800556:	0f b6 c0             	movzbl %al,%eax
  800559:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80055f:	83 ec 04             	sub    $0x4,%esp
  800562:	50                   	push   %eax
  800563:	52                   	push   %edx
  800564:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80056a:	83 c0 08             	add    $0x8,%eax
  80056d:	50                   	push   %eax
  80056e:	e8 ef 12 00 00       	call   801862 <sys_cputs>
  800573:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800576:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80057d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800583:	c9                   	leave  
  800584:	c3                   	ret    

00800585 <cprintf>:

int cprintf(const char *fmt, ...) {
  800585:	55                   	push   %ebp
  800586:	89 e5                	mov    %esp,%ebp
  800588:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80058b:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800592:	8d 45 0c             	lea    0xc(%ebp),%eax
  800595:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800598:	8b 45 08             	mov    0x8(%ebp),%eax
  80059b:	83 ec 08             	sub    $0x8,%esp
  80059e:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a1:	50                   	push   %eax
  8005a2:	e8 73 ff ff ff       	call   80051a <vcprintf>
  8005a7:	83 c4 10             	add    $0x10,%esp
  8005aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005b0:	c9                   	leave  
  8005b1:	c3                   	ret    

008005b2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005b2:	55                   	push   %ebp
  8005b3:	89 e5                	mov    %esp,%ebp
  8005b5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005b8:	e8 53 14 00 00       	call   801a10 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005bd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	83 ec 08             	sub    $0x8,%esp
  8005c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cc:	50                   	push   %eax
  8005cd:	e8 48 ff ff ff       	call   80051a <vcprintf>
  8005d2:	83 c4 10             	add    $0x10,%esp
  8005d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005d8:	e8 4d 14 00 00       	call   801a2a <sys_enable_interrupt>
	return cnt;
  8005dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005e0:	c9                   	leave  
  8005e1:	c3                   	ret    

008005e2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005e2:	55                   	push   %ebp
  8005e3:	89 e5                	mov    %esp,%ebp
  8005e5:	53                   	push   %ebx
  8005e6:	83 ec 14             	sub    $0x14,%esp
  8005e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f5:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800600:	77 55                	ja     800657 <printnum+0x75>
  800602:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800605:	72 05                	jb     80060c <printnum+0x2a>
  800607:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80060a:	77 4b                	ja     800657 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80060c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80060f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800612:	8b 45 18             	mov    0x18(%ebp),%eax
  800615:	ba 00 00 00 00       	mov    $0x0,%edx
  80061a:	52                   	push   %edx
  80061b:	50                   	push   %eax
  80061c:	ff 75 f4             	pushl  -0xc(%ebp)
  80061f:	ff 75 f0             	pushl  -0x10(%ebp)
  800622:	e8 39 29 00 00       	call   802f60 <__udivdi3>
  800627:	83 c4 10             	add    $0x10,%esp
  80062a:	83 ec 04             	sub    $0x4,%esp
  80062d:	ff 75 20             	pushl  0x20(%ebp)
  800630:	53                   	push   %ebx
  800631:	ff 75 18             	pushl  0x18(%ebp)
  800634:	52                   	push   %edx
  800635:	50                   	push   %eax
  800636:	ff 75 0c             	pushl  0xc(%ebp)
  800639:	ff 75 08             	pushl  0x8(%ebp)
  80063c:	e8 a1 ff ff ff       	call   8005e2 <printnum>
  800641:	83 c4 20             	add    $0x20,%esp
  800644:	eb 1a                	jmp    800660 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	ff 75 0c             	pushl  0xc(%ebp)
  80064c:	ff 75 20             	pushl  0x20(%ebp)
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	ff d0                	call   *%eax
  800654:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800657:	ff 4d 1c             	decl   0x1c(%ebp)
  80065a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80065e:	7f e6                	jg     800646 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800660:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800663:	bb 00 00 00 00       	mov    $0x0,%ebx
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80066e:	53                   	push   %ebx
  80066f:	51                   	push   %ecx
  800670:	52                   	push   %edx
  800671:	50                   	push   %eax
  800672:	e8 f9 29 00 00       	call   803070 <__umoddi3>
  800677:	83 c4 10             	add    $0x10,%esp
  80067a:	05 d4 37 80 00       	add    $0x8037d4,%eax
  80067f:	8a 00                	mov    (%eax),%al
  800681:	0f be c0             	movsbl %al,%eax
  800684:	83 ec 08             	sub    $0x8,%esp
  800687:	ff 75 0c             	pushl  0xc(%ebp)
  80068a:	50                   	push   %eax
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	ff d0                	call   *%eax
  800690:	83 c4 10             	add    $0x10,%esp
}
  800693:	90                   	nop
  800694:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800697:	c9                   	leave  
  800698:	c3                   	ret    

00800699 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800699:	55                   	push   %ebp
  80069a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80069c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a0:	7e 1c                	jle    8006be <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	8d 50 08             	lea    0x8(%eax),%edx
  8006aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ad:	89 10                	mov    %edx,(%eax)
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	83 e8 08             	sub    $0x8,%eax
  8006b7:	8b 50 04             	mov    0x4(%eax),%edx
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	eb 40                	jmp    8006fe <getuint+0x65>
	else if (lflag)
  8006be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c2:	74 1e                	je     8006e2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	8d 50 04             	lea    0x4(%eax),%edx
  8006cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cf:	89 10                	mov    %edx,(%eax)
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	83 e8 04             	sub    $0x4,%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e0:	eb 1c                	jmp    8006fe <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	8d 50 04             	lea    0x4(%eax),%edx
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	89 10                	mov    %edx,(%eax)
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	83 e8 04             	sub    $0x4,%eax
  8006f7:	8b 00                	mov    (%eax),%eax
  8006f9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006fe:	5d                   	pop    %ebp
  8006ff:	c3                   	ret    

00800700 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800700:	55                   	push   %ebp
  800701:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800703:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800707:	7e 1c                	jle    800725 <getint+0x25>
		return va_arg(*ap, long long);
  800709:	8b 45 08             	mov    0x8(%ebp),%eax
  80070c:	8b 00                	mov    (%eax),%eax
  80070e:	8d 50 08             	lea    0x8(%eax),%edx
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	89 10                	mov    %edx,(%eax)
  800716:	8b 45 08             	mov    0x8(%ebp),%eax
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	83 e8 08             	sub    $0x8,%eax
  80071e:	8b 50 04             	mov    0x4(%eax),%edx
  800721:	8b 00                	mov    (%eax),%eax
  800723:	eb 38                	jmp    80075d <getint+0x5d>
	else if (lflag)
  800725:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800729:	74 1a                	je     800745 <getint+0x45>
		return va_arg(*ap, long);
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	8d 50 04             	lea    0x4(%eax),%edx
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	89 10                	mov    %edx,(%eax)
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	83 e8 04             	sub    $0x4,%eax
  800740:	8b 00                	mov    (%eax),%eax
  800742:	99                   	cltd   
  800743:	eb 18                	jmp    80075d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800745:	8b 45 08             	mov    0x8(%ebp),%eax
  800748:	8b 00                	mov    (%eax),%eax
  80074a:	8d 50 04             	lea    0x4(%eax),%edx
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	89 10                	mov    %edx,(%eax)
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	8b 00                	mov    (%eax),%eax
  800757:	83 e8 04             	sub    $0x4,%eax
  80075a:	8b 00                	mov    (%eax),%eax
  80075c:	99                   	cltd   
}
  80075d:	5d                   	pop    %ebp
  80075e:	c3                   	ret    

0080075f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80075f:	55                   	push   %ebp
  800760:	89 e5                	mov    %esp,%ebp
  800762:	56                   	push   %esi
  800763:	53                   	push   %ebx
  800764:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800767:	eb 17                	jmp    800780 <vprintfmt+0x21>
			if (ch == '\0')
  800769:	85 db                	test   %ebx,%ebx
  80076b:	0f 84 af 03 00 00    	je     800b20 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 0c             	pushl  0xc(%ebp)
  800777:	53                   	push   %ebx
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	ff d0                	call   *%eax
  80077d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800780:	8b 45 10             	mov    0x10(%ebp),%eax
  800783:	8d 50 01             	lea    0x1(%eax),%edx
  800786:	89 55 10             	mov    %edx,0x10(%ebp)
  800789:	8a 00                	mov    (%eax),%al
  80078b:	0f b6 d8             	movzbl %al,%ebx
  80078e:	83 fb 25             	cmp    $0x25,%ebx
  800791:	75 d6                	jne    800769 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800793:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800797:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80079e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007a5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007ac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b6:	8d 50 01             	lea    0x1(%eax),%edx
  8007b9:	89 55 10             	mov    %edx,0x10(%ebp)
  8007bc:	8a 00                	mov    (%eax),%al
  8007be:	0f b6 d8             	movzbl %al,%ebx
  8007c1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007c4:	83 f8 55             	cmp    $0x55,%eax
  8007c7:	0f 87 2b 03 00 00    	ja     800af8 <vprintfmt+0x399>
  8007cd:	8b 04 85 f8 37 80 00 	mov    0x8037f8(,%eax,4),%eax
  8007d4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007d6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007da:	eb d7                	jmp    8007b3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007dc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007e0:	eb d1                	jmp    8007b3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007ec:	89 d0                	mov    %edx,%eax
  8007ee:	c1 e0 02             	shl    $0x2,%eax
  8007f1:	01 d0                	add    %edx,%eax
  8007f3:	01 c0                	add    %eax,%eax
  8007f5:	01 d8                	add    %ebx,%eax
  8007f7:	83 e8 30             	sub    $0x30,%eax
  8007fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800800:	8a 00                	mov    (%eax),%al
  800802:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800805:	83 fb 2f             	cmp    $0x2f,%ebx
  800808:	7e 3e                	jle    800848 <vprintfmt+0xe9>
  80080a:	83 fb 39             	cmp    $0x39,%ebx
  80080d:	7f 39                	jg     800848 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80080f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800812:	eb d5                	jmp    8007e9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	83 c0 04             	add    $0x4,%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	83 e8 04             	sub    $0x4,%eax
  800823:	8b 00                	mov    (%eax),%eax
  800825:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800828:	eb 1f                	jmp    800849 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80082a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082e:	79 83                	jns    8007b3 <vprintfmt+0x54>
				width = 0;
  800830:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800837:	e9 77 ff ff ff       	jmp    8007b3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80083c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800843:	e9 6b ff ff ff       	jmp    8007b3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800848:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800849:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084d:	0f 89 60 ff ff ff    	jns    8007b3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800853:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800856:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800859:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800860:	e9 4e ff ff ff       	jmp    8007b3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800865:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800868:	e9 46 ff ff ff       	jmp    8007b3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80086d:	8b 45 14             	mov    0x14(%ebp),%eax
  800870:	83 c0 04             	add    $0x4,%eax
  800873:	89 45 14             	mov    %eax,0x14(%ebp)
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	83 e8 04             	sub    $0x4,%eax
  80087c:	8b 00                	mov    (%eax),%eax
  80087e:	83 ec 08             	sub    $0x8,%esp
  800881:	ff 75 0c             	pushl  0xc(%ebp)
  800884:	50                   	push   %eax
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	ff d0                	call   *%eax
  80088a:	83 c4 10             	add    $0x10,%esp
			break;
  80088d:	e9 89 02 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800892:	8b 45 14             	mov    0x14(%ebp),%eax
  800895:	83 c0 04             	add    $0x4,%eax
  800898:	89 45 14             	mov    %eax,0x14(%ebp)
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	83 e8 04             	sub    $0x4,%eax
  8008a1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008a3:	85 db                	test   %ebx,%ebx
  8008a5:	79 02                	jns    8008a9 <vprintfmt+0x14a>
				err = -err;
  8008a7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008a9:	83 fb 64             	cmp    $0x64,%ebx
  8008ac:	7f 0b                	jg     8008b9 <vprintfmt+0x15a>
  8008ae:	8b 34 9d 40 36 80 00 	mov    0x803640(,%ebx,4),%esi
  8008b5:	85 f6                	test   %esi,%esi
  8008b7:	75 19                	jne    8008d2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b9:	53                   	push   %ebx
  8008ba:	68 e5 37 80 00       	push   $0x8037e5
  8008bf:	ff 75 0c             	pushl  0xc(%ebp)
  8008c2:	ff 75 08             	pushl  0x8(%ebp)
  8008c5:	e8 5e 02 00 00       	call   800b28 <printfmt>
  8008ca:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008cd:	e9 49 02 00 00       	jmp    800b1b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008d2:	56                   	push   %esi
  8008d3:	68 ee 37 80 00       	push   $0x8037ee
  8008d8:	ff 75 0c             	pushl  0xc(%ebp)
  8008db:	ff 75 08             	pushl  0x8(%ebp)
  8008de:	e8 45 02 00 00       	call   800b28 <printfmt>
  8008e3:	83 c4 10             	add    $0x10,%esp
			break;
  8008e6:	e9 30 02 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ee:	83 c0 04             	add    $0x4,%eax
  8008f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f7:	83 e8 04             	sub    $0x4,%eax
  8008fa:	8b 30                	mov    (%eax),%esi
  8008fc:	85 f6                	test   %esi,%esi
  8008fe:	75 05                	jne    800905 <vprintfmt+0x1a6>
				p = "(null)";
  800900:	be f1 37 80 00       	mov    $0x8037f1,%esi
			if (width > 0 && padc != '-')
  800905:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800909:	7e 6d                	jle    800978 <vprintfmt+0x219>
  80090b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80090f:	74 67                	je     800978 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800911:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	50                   	push   %eax
  800918:	56                   	push   %esi
  800919:	e8 0c 03 00 00       	call   800c2a <strnlen>
  80091e:	83 c4 10             	add    $0x10,%esp
  800921:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800924:	eb 16                	jmp    80093c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800926:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80092a:	83 ec 08             	sub    $0x8,%esp
  80092d:	ff 75 0c             	pushl  0xc(%ebp)
  800930:	50                   	push   %eax
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	ff d0                	call   *%eax
  800936:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800939:	ff 4d e4             	decl   -0x1c(%ebp)
  80093c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800940:	7f e4                	jg     800926 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800942:	eb 34                	jmp    800978 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800944:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800948:	74 1c                	je     800966 <vprintfmt+0x207>
  80094a:	83 fb 1f             	cmp    $0x1f,%ebx
  80094d:	7e 05                	jle    800954 <vprintfmt+0x1f5>
  80094f:	83 fb 7e             	cmp    $0x7e,%ebx
  800952:	7e 12                	jle    800966 <vprintfmt+0x207>
					putch('?', putdat);
  800954:	83 ec 08             	sub    $0x8,%esp
  800957:	ff 75 0c             	pushl  0xc(%ebp)
  80095a:	6a 3f                	push   $0x3f
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	ff d0                	call   *%eax
  800961:	83 c4 10             	add    $0x10,%esp
  800964:	eb 0f                	jmp    800975 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800966:	83 ec 08             	sub    $0x8,%esp
  800969:	ff 75 0c             	pushl  0xc(%ebp)
  80096c:	53                   	push   %ebx
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	ff d0                	call   *%eax
  800972:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800975:	ff 4d e4             	decl   -0x1c(%ebp)
  800978:	89 f0                	mov    %esi,%eax
  80097a:	8d 70 01             	lea    0x1(%eax),%esi
  80097d:	8a 00                	mov    (%eax),%al
  80097f:	0f be d8             	movsbl %al,%ebx
  800982:	85 db                	test   %ebx,%ebx
  800984:	74 24                	je     8009aa <vprintfmt+0x24b>
  800986:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80098a:	78 b8                	js     800944 <vprintfmt+0x1e5>
  80098c:	ff 4d e0             	decl   -0x20(%ebp)
  80098f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800993:	79 af                	jns    800944 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800995:	eb 13                	jmp    8009aa <vprintfmt+0x24b>
				putch(' ', putdat);
  800997:	83 ec 08             	sub    $0x8,%esp
  80099a:	ff 75 0c             	pushl  0xc(%ebp)
  80099d:	6a 20                	push   $0x20
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	ff d0                	call   *%eax
  8009a4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009a7:	ff 4d e4             	decl   -0x1c(%ebp)
  8009aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ae:	7f e7                	jg     800997 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009b0:	e9 66 01 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009b5:	83 ec 08             	sub    $0x8,%esp
  8009b8:	ff 75 e8             	pushl  -0x18(%ebp)
  8009bb:	8d 45 14             	lea    0x14(%ebp),%eax
  8009be:	50                   	push   %eax
  8009bf:	e8 3c fd ff ff       	call   800700 <getint>
  8009c4:	83 c4 10             	add    $0x10,%esp
  8009c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d3:	85 d2                	test   %edx,%edx
  8009d5:	79 23                	jns    8009fa <vprintfmt+0x29b>
				putch('-', putdat);
  8009d7:	83 ec 08             	sub    $0x8,%esp
  8009da:	ff 75 0c             	pushl  0xc(%ebp)
  8009dd:	6a 2d                	push   $0x2d
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	ff d0                	call   *%eax
  8009e4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ed:	f7 d8                	neg    %eax
  8009ef:	83 d2 00             	adc    $0x0,%edx
  8009f2:	f7 da                	neg    %edx
  8009f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009fa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a01:	e9 bc 00 00 00       	jmp    800ac2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	ff 75 e8             	pushl  -0x18(%ebp)
  800a0c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a0f:	50                   	push   %eax
  800a10:	e8 84 fc ff ff       	call   800699 <getuint>
  800a15:	83 c4 10             	add    $0x10,%esp
  800a18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a1e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a25:	e9 98 00 00 00       	jmp    800ac2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a2a:	83 ec 08             	sub    $0x8,%esp
  800a2d:	ff 75 0c             	pushl  0xc(%ebp)
  800a30:	6a 58                	push   $0x58
  800a32:	8b 45 08             	mov    0x8(%ebp),%eax
  800a35:	ff d0                	call   *%eax
  800a37:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a3a:	83 ec 08             	sub    $0x8,%esp
  800a3d:	ff 75 0c             	pushl  0xc(%ebp)
  800a40:	6a 58                	push   $0x58
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	ff d0                	call   *%eax
  800a47:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	ff 75 0c             	pushl  0xc(%ebp)
  800a50:	6a 58                	push   $0x58
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	ff d0                	call   *%eax
  800a57:	83 c4 10             	add    $0x10,%esp
			break;
  800a5a:	e9 bc 00 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a5f:	83 ec 08             	sub    $0x8,%esp
  800a62:	ff 75 0c             	pushl  0xc(%ebp)
  800a65:	6a 30                	push   $0x30
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	ff d0                	call   *%eax
  800a6c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a6f:	83 ec 08             	sub    $0x8,%esp
  800a72:	ff 75 0c             	pushl  0xc(%ebp)
  800a75:	6a 78                	push   $0x78
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	ff d0                	call   *%eax
  800a7c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a82:	83 c0 04             	add    $0x4,%eax
  800a85:	89 45 14             	mov    %eax,0x14(%ebp)
  800a88:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8b:	83 e8 04             	sub    $0x4,%eax
  800a8e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a9a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800aa1:	eb 1f                	jmp    800ac2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa9:	8d 45 14             	lea    0x14(%ebp),%eax
  800aac:	50                   	push   %eax
  800aad:	e8 e7 fb ff ff       	call   800699 <getuint>
  800ab2:	83 c4 10             	add    $0x10,%esp
  800ab5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800abb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ac2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ac6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac9:	83 ec 04             	sub    $0x4,%esp
  800acc:	52                   	push   %edx
  800acd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ad0:	50                   	push   %eax
  800ad1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad4:	ff 75 f0             	pushl  -0x10(%ebp)
  800ad7:	ff 75 0c             	pushl  0xc(%ebp)
  800ada:	ff 75 08             	pushl  0x8(%ebp)
  800add:	e8 00 fb ff ff       	call   8005e2 <printnum>
  800ae2:	83 c4 20             	add    $0x20,%esp
			break;
  800ae5:	eb 34                	jmp    800b1b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	53                   	push   %ebx
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	ff d0                	call   *%eax
  800af3:	83 c4 10             	add    $0x10,%esp
			break;
  800af6:	eb 23                	jmp    800b1b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 0c             	pushl  0xc(%ebp)
  800afe:	6a 25                	push   $0x25
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	ff d0                	call   *%eax
  800b05:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b08:	ff 4d 10             	decl   0x10(%ebp)
  800b0b:	eb 03                	jmp    800b10 <vprintfmt+0x3b1>
  800b0d:	ff 4d 10             	decl   0x10(%ebp)
  800b10:	8b 45 10             	mov    0x10(%ebp),%eax
  800b13:	48                   	dec    %eax
  800b14:	8a 00                	mov    (%eax),%al
  800b16:	3c 25                	cmp    $0x25,%al
  800b18:	75 f3                	jne    800b0d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b1a:	90                   	nop
		}
	}
  800b1b:	e9 47 fc ff ff       	jmp    800767 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b20:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b21:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b24:	5b                   	pop    %ebx
  800b25:	5e                   	pop    %esi
  800b26:	5d                   	pop    %ebp
  800b27:	c3                   	ret    

00800b28 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b2e:	8d 45 10             	lea    0x10(%ebp),%eax
  800b31:	83 c0 04             	add    $0x4,%eax
  800b34:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b37:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3d:	50                   	push   %eax
  800b3e:	ff 75 0c             	pushl  0xc(%ebp)
  800b41:	ff 75 08             	pushl  0x8(%ebp)
  800b44:	e8 16 fc ff ff       	call   80075f <vprintfmt>
  800b49:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b4c:	90                   	nop
  800b4d:	c9                   	leave  
  800b4e:	c3                   	ret    

00800b4f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b55:	8b 40 08             	mov    0x8(%eax),%eax
  800b58:	8d 50 01             	lea    0x1(%eax),%edx
  800b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b64:	8b 10                	mov    (%eax),%edx
  800b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b69:	8b 40 04             	mov    0x4(%eax),%eax
  800b6c:	39 c2                	cmp    %eax,%edx
  800b6e:	73 12                	jae    800b82 <sprintputch+0x33>
		*b->buf++ = ch;
  800b70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b73:	8b 00                	mov    (%eax),%eax
  800b75:	8d 48 01             	lea    0x1(%eax),%ecx
  800b78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7b:	89 0a                	mov    %ecx,(%edx)
  800b7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b80:	88 10                	mov    %dl,(%eax)
}
  800b82:	90                   	nop
  800b83:	5d                   	pop    %ebp
  800b84:	c3                   	ret    

00800b85 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b94:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	01 d0                	add    %edx,%eax
  800b9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ba6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800baa:	74 06                	je     800bb2 <vsnprintf+0x2d>
  800bac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb0:	7f 07                	jg     800bb9 <vsnprintf+0x34>
		return -E_INVAL;
  800bb2:	b8 03 00 00 00       	mov    $0x3,%eax
  800bb7:	eb 20                	jmp    800bd9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bb9:	ff 75 14             	pushl  0x14(%ebp)
  800bbc:	ff 75 10             	pushl  0x10(%ebp)
  800bbf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bc2:	50                   	push   %eax
  800bc3:	68 4f 0b 80 00       	push   $0x800b4f
  800bc8:	e8 92 fb ff ff       	call   80075f <vprintfmt>
  800bcd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

00800bdb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800be1:	8d 45 10             	lea    0x10(%ebp),%eax
  800be4:	83 c0 04             	add    $0x4,%eax
  800be7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bea:	8b 45 10             	mov    0x10(%ebp),%eax
  800bed:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf0:	50                   	push   %eax
  800bf1:	ff 75 0c             	pushl  0xc(%ebp)
  800bf4:	ff 75 08             	pushl  0x8(%ebp)
  800bf7:	e8 89 ff ff ff       	call   800b85 <vsnprintf>
  800bfc:	83 c4 10             	add    $0x10,%esp
  800bff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c05:	c9                   	leave  
  800c06:	c3                   	ret    

00800c07 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c14:	eb 06                	jmp    800c1c <strlen+0x15>
		n++;
  800c16:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c19:	ff 45 08             	incl   0x8(%ebp)
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	8a 00                	mov    (%eax),%al
  800c21:	84 c0                	test   %al,%al
  800c23:	75 f1                	jne    800c16 <strlen+0xf>
		n++;
	return n;
  800c25:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c28:	c9                   	leave  
  800c29:	c3                   	ret    

00800c2a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c37:	eb 09                	jmp    800c42 <strnlen+0x18>
		n++;
  800c39:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c3c:	ff 45 08             	incl   0x8(%ebp)
  800c3f:	ff 4d 0c             	decl   0xc(%ebp)
  800c42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c46:	74 09                	je     800c51 <strnlen+0x27>
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	84 c0                	test   %al,%al
  800c4f:	75 e8                	jne    800c39 <strnlen+0xf>
		n++;
	return n;
  800c51:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c54:	c9                   	leave  
  800c55:	c3                   	ret    

00800c56 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c62:	90                   	nop
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	8d 50 01             	lea    0x1(%eax),%edx
  800c69:	89 55 08             	mov    %edx,0x8(%ebp)
  800c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c72:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c75:	8a 12                	mov    (%edx),%dl
  800c77:	88 10                	mov    %dl,(%eax)
  800c79:	8a 00                	mov    (%eax),%al
  800c7b:	84 c0                	test   %al,%al
  800c7d:	75 e4                	jne    800c63 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    

00800c84 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c97:	eb 1f                	jmp    800cb8 <strncpy+0x34>
		*dst++ = *src;
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8d 50 01             	lea    0x1(%eax),%edx
  800c9f:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca5:	8a 12                	mov    (%edx),%dl
  800ca7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cac:	8a 00                	mov    (%eax),%al
  800cae:	84 c0                	test   %al,%al
  800cb0:	74 03                	je     800cb5 <strncpy+0x31>
			src++;
  800cb2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cb5:	ff 45 fc             	incl   -0x4(%ebp)
  800cb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbb:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cbe:	72 d9                	jb     800c99 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cc3:	c9                   	leave  
  800cc4:	c3                   	ret    

00800cc5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cd1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd5:	74 30                	je     800d07 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cd7:	eb 16                	jmp    800cef <strlcpy+0x2a>
			*dst++ = *src++;
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	8d 50 01             	lea    0x1(%eax),%edx
  800cdf:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ceb:	8a 12                	mov    (%edx),%dl
  800ced:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cef:	ff 4d 10             	decl   0x10(%ebp)
  800cf2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf6:	74 09                	je     800d01 <strlcpy+0x3c>
  800cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfb:	8a 00                	mov    (%eax),%al
  800cfd:	84 c0                	test   %al,%al
  800cff:	75 d8                	jne    800cd9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d07:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0d:	29 c2                	sub    %eax,%edx
  800d0f:	89 d0                	mov    %edx,%eax
}
  800d11:	c9                   	leave  
  800d12:	c3                   	ret    

00800d13 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d16:	eb 06                	jmp    800d1e <strcmp+0xb>
		p++, q++;
  800d18:	ff 45 08             	incl   0x8(%ebp)
  800d1b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	84 c0                	test   %al,%al
  800d25:	74 0e                	je     800d35 <strcmp+0x22>
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8a 10                	mov    (%eax),%dl
  800d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	38 c2                	cmp    %al,%dl
  800d33:	74 e3                	je     800d18 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d35:	8b 45 08             	mov    0x8(%ebp),%eax
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	0f b6 d0             	movzbl %al,%edx
  800d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	0f b6 c0             	movzbl %al,%eax
  800d45:	29 c2                	sub    %eax,%edx
  800d47:	89 d0                	mov    %edx,%eax
}
  800d49:	5d                   	pop    %ebp
  800d4a:	c3                   	ret    

00800d4b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d4e:	eb 09                	jmp    800d59 <strncmp+0xe>
		n--, p++, q++;
  800d50:	ff 4d 10             	decl   0x10(%ebp)
  800d53:	ff 45 08             	incl   0x8(%ebp)
  800d56:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5d:	74 17                	je     800d76 <strncmp+0x2b>
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	84 c0                	test   %al,%al
  800d66:	74 0e                	je     800d76 <strncmp+0x2b>
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 10                	mov    (%eax),%dl
  800d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d70:	8a 00                	mov    (%eax),%al
  800d72:	38 c2                	cmp    %al,%dl
  800d74:	74 da                	je     800d50 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7a:	75 07                	jne    800d83 <strncmp+0x38>
		return 0;
  800d7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d81:	eb 14                	jmp    800d97 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d83:	8b 45 08             	mov    0x8(%ebp),%eax
  800d86:	8a 00                	mov    (%eax),%al
  800d88:	0f b6 d0             	movzbl %al,%edx
  800d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8e:	8a 00                	mov    (%eax),%al
  800d90:	0f b6 c0             	movzbl %al,%eax
  800d93:	29 c2                	sub    %eax,%edx
  800d95:	89 d0                	mov    %edx,%eax
}
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    

00800d99 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	83 ec 04             	sub    $0x4,%esp
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800da5:	eb 12                	jmp    800db9 <strchr+0x20>
		if (*s == c)
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800daf:	75 05                	jne    800db6 <strchr+0x1d>
			return (char *) s;
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	eb 11                	jmp    800dc7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800db6:	ff 45 08             	incl   0x8(%ebp)
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	8a 00                	mov    (%eax),%al
  800dbe:	84 c0                	test   %al,%al
  800dc0:	75 e5                	jne    800da7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dc7:	c9                   	leave  
  800dc8:	c3                   	ret    

00800dc9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	83 ec 04             	sub    $0x4,%esp
  800dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dd5:	eb 0d                	jmp    800de4 <strfind+0x1b>
		if (*s == c)
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	8a 00                	mov    (%eax),%al
  800ddc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ddf:	74 0e                	je     800def <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800de1:	ff 45 08             	incl   0x8(%ebp)
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	8a 00                	mov    (%eax),%al
  800de9:	84 c0                	test   %al,%al
  800deb:	75 ea                	jne    800dd7 <strfind+0xe>
  800ded:	eb 01                	jmp    800df0 <strfind+0x27>
		if (*s == c)
			break;
  800def:	90                   	nop
	return (char *) s;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df3:	c9                   	leave  
  800df4:	c3                   	ret    

00800df5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e01:	8b 45 10             	mov    0x10(%ebp),%eax
  800e04:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e07:	eb 0e                	jmp    800e17 <memset+0x22>
		*p++ = c;
  800e09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e0c:	8d 50 01             	lea    0x1(%eax),%edx
  800e0f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e15:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e17:	ff 4d f8             	decl   -0x8(%ebp)
  800e1a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e1e:	79 e9                	jns    800e09 <memset+0x14>
		*p++ = c;

	return v;
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e23:	c9                   	leave  
  800e24:	c3                   	ret    

00800e25 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e37:	eb 16                	jmp    800e4f <memcpy+0x2a>
		*d++ = *s++;
  800e39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3c:	8d 50 01             	lea    0x1(%eax),%edx
  800e3f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e42:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e45:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e48:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e4b:	8a 12                	mov    (%edx),%dl
  800e4d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e52:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e55:	89 55 10             	mov    %edx,0x10(%ebp)
  800e58:	85 c0                	test   %eax,%eax
  800e5a:	75 dd                	jne    800e39 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5f:	c9                   	leave  
  800e60:	c3                   	ret    

00800e61 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e76:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e79:	73 50                	jae    800ecb <memmove+0x6a>
  800e7b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e81:	01 d0                	add    %edx,%eax
  800e83:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e86:	76 43                	jbe    800ecb <memmove+0x6a>
		s += n;
  800e88:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e91:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e94:	eb 10                	jmp    800ea6 <memmove+0x45>
			*--d = *--s;
  800e96:	ff 4d f8             	decl   -0x8(%ebp)
  800e99:	ff 4d fc             	decl   -0x4(%ebp)
  800e9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9f:	8a 10                	mov    (%eax),%dl
  800ea1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ea6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eac:	89 55 10             	mov    %edx,0x10(%ebp)
  800eaf:	85 c0                	test   %eax,%eax
  800eb1:	75 e3                	jne    800e96 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800eb3:	eb 23                	jmp    800ed8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800eb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb8:	8d 50 01             	lea    0x1(%eax),%edx
  800ebb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ebe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ec1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ec4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ec7:	8a 12                	mov    (%edx),%dl
  800ec9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ecb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ece:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed4:	85 c0                	test   %eax,%eax
  800ed6:	75 dd                	jne    800eb5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800edb:	c9                   	leave  
  800edc:	c3                   	ret    

00800edd <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eec:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eef:	eb 2a                	jmp    800f1b <memcmp+0x3e>
		if (*s1 != *s2)
  800ef1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef4:	8a 10                	mov    (%eax),%dl
  800ef6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef9:	8a 00                	mov    (%eax),%al
  800efb:	38 c2                	cmp    %al,%dl
  800efd:	74 16                	je     800f15 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	0f b6 d0             	movzbl %al,%edx
  800f07:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	0f b6 c0             	movzbl %al,%eax
  800f0f:	29 c2                	sub    %eax,%edx
  800f11:	89 d0                	mov    %edx,%eax
  800f13:	eb 18                	jmp    800f2d <memcmp+0x50>
		s1++, s2++;
  800f15:	ff 45 fc             	incl   -0x4(%ebp)
  800f18:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f21:	89 55 10             	mov    %edx,0x10(%ebp)
  800f24:	85 c0                	test   %eax,%eax
  800f26:	75 c9                	jne    800ef1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f2d:	c9                   	leave  
  800f2e:	c3                   	ret    

00800f2f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f2f:	55                   	push   %ebp
  800f30:	89 e5                	mov    %esp,%ebp
  800f32:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f35:	8b 55 08             	mov    0x8(%ebp),%edx
  800f38:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3b:	01 d0                	add    %edx,%eax
  800f3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f40:	eb 15                	jmp    800f57 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	0f b6 d0             	movzbl %al,%edx
  800f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4d:	0f b6 c0             	movzbl %al,%eax
  800f50:	39 c2                	cmp    %eax,%edx
  800f52:	74 0d                	je     800f61 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f54:	ff 45 08             	incl   0x8(%ebp)
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f5d:	72 e3                	jb     800f42 <memfind+0x13>
  800f5f:	eb 01                	jmp    800f62 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f61:	90                   	nop
	return (void *) s;
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f65:	c9                   	leave  
  800f66:	c3                   	ret    

00800f67 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f74:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f7b:	eb 03                	jmp    800f80 <strtol+0x19>
		s++;
  800f7d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	3c 20                	cmp    $0x20,%al
  800f87:	74 f4                	je     800f7d <strtol+0x16>
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 00                	mov    (%eax),%al
  800f8e:	3c 09                	cmp    $0x9,%al
  800f90:	74 eb                	je     800f7d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	8a 00                	mov    (%eax),%al
  800f97:	3c 2b                	cmp    $0x2b,%al
  800f99:	75 05                	jne    800fa0 <strtol+0x39>
		s++;
  800f9b:	ff 45 08             	incl   0x8(%ebp)
  800f9e:	eb 13                	jmp    800fb3 <strtol+0x4c>
	else if (*s == '-')
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	3c 2d                	cmp    $0x2d,%al
  800fa7:	75 0a                	jne    800fb3 <strtol+0x4c>
		s++, neg = 1;
  800fa9:	ff 45 08             	incl   0x8(%ebp)
  800fac:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb7:	74 06                	je     800fbf <strtol+0x58>
  800fb9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fbd:	75 20                	jne    800fdf <strtol+0x78>
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	3c 30                	cmp    $0x30,%al
  800fc6:	75 17                	jne    800fdf <strtol+0x78>
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	40                   	inc    %eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	3c 78                	cmp    $0x78,%al
  800fd0:	75 0d                	jne    800fdf <strtol+0x78>
		s += 2, base = 16;
  800fd2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fd6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fdd:	eb 28                	jmp    801007 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe3:	75 15                	jne    800ffa <strtol+0x93>
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8a 00                	mov    (%eax),%al
  800fea:	3c 30                	cmp    $0x30,%al
  800fec:	75 0c                	jne    800ffa <strtol+0x93>
		s++, base = 8;
  800fee:	ff 45 08             	incl   0x8(%ebp)
  800ff1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ff8:	eb 0d                	jmp    801007 <strtol+0xa0>
	else if (base == 0)
  800ffa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffe:	75 07                	jne    801007 <strtol+0xa0>
		base = 10;
  801000:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	3c 2f                	cmp    $0x2f,%al
  80100e:	7e 19                	jle    801029 <strtol+0xc2>
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	3c 39                	cmp    $0x39,%al
  801017:	7f 10                	jg     801029 <strtol+0xc2>
			dig = *s - '0';
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	0f be c0             	movsbl %al,%eax
  801021:	83 e8 30             	sub    $0x30,%eax
  801024:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801027:	eb 42                	jmp    80106b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	3c 60                	cmp    $0x60,%al
  801030:	7e 19                	jle    80104b <strtol+0xe4>
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	3c 7a                	cmp    $0x7a,%al
  801039:	7f 10                	jg     80104b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	8a 00                	mov    (%eax),%al
  801040:	0f be c0             	movsbl %al,%eax
  801043:	83 e8 57             	sub    $0x57,%eax
  801046:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801049:	eb 20                	jmp    80106b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	3c 40                	cmp    $0x40,%al
  801052:	7e 39                	jle    80108d <strtol+0x126>
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	3c 5a                	cmp    $0x5a,%al
  80105b:	7f 30                	jg     80108d <strtol+0x126>
			dig = *s - 'A' + 10;
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	0f be c0             	movsbl %al,%eax
  801065:	83 e8 37             	sub    $0x37,%eax
  801068:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80106b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801071:	7d 19                	jge    80108c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801073:	ff 45 08             	incl   0x8(%ebp)
  801076:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801079:	0f af 45 10          	imul   0x10(%ebp),%eax
  80107d:	89 c2                	mov    %eax,%edx
  80107f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801082:	01 d0                	add    %edx,%eax
  801084:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801087:	e9 7b ff ff ff       	jmp    801007 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80108c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80108d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801091:	74 08                	je     80109b <strtol+0x134>
		*endptr = (char *) s;
  801093:	8b 45 0c             	mov    0xc(%ebp),%eax
  801096:	8b 55 08             	mov    0x8(%ebp),%edx
  801099:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80109b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80109f:	74 07                	je     8010a8 <strtol+0x141>
  8010a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a4:	f7 d8                	neg    %eax
  8010a6:	eb 03                	jmp    8010ab <strtol+0x144>
  8010a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010ab:	c9                   	leave  
  8010ac:	c3                   	ret    

008010ad <ltostr>:

void
ltostr(long value, char *str)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010ba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c5:	79 13                	jns    8010da <ltostr+0x2d>
	{
		neg = 1;
  8010c7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010d4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010d7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010e2:	99                   	cltd   
  8010e3:	f7 f9                	idiv   %ecx
  8010e5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010eb:	8d 50 01             	lea    0x1(%eax),%edx
  8010ee:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010f1:	89 c2                	mov    %eax,%edx
  8010f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f6:	01 d0                	add    %edx,%eax
  8010f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010fb:	83 c2 30             	add    $0x30,%edx
  8010fe:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801100:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801103:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801108:	f7 e9                	imul   %ecx
  80110a:	c1 fa 02             	sar    $0x2,%edx
  80110d:	89 c8                	mov    %ecx,%eax
  80110f:	c1 f8 1f             	sar    $0x1f,%eax
  801112:	29 c2                	sub    %eax,%edx
  801114:	89 d0                	mov    %edx,%eax
  801116:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801119:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80111c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801121:	f7 e9                	imul   %ecx
  801123:	c1 fa 02             	sar    $0x2,%edx
  801126:	89 c8                	mov    %ecx,%eax
  801128:	c1 f8 1f             	sar    $0x1f,%eax
  80112b:	29 c2                	sub    %eax,%edx
  80112d:	89 d0                	mov    %edx,%eax
  80112f:	c1 e0 02             	shl    $0x2,%eax
  801132:	01 d0                	add    %edx,%eax
  801134:	01 c0                	add    %eax,%eax
  801136:	29 c1                	sub    %eax,%ecx
  801138:	89 ca                	mov    %ecx,%edx
  80113a:	85 d2                	test   %edx,%edx
  80113c:	75 9c                	jne    8010da <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80113e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801145:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801148:	48                   	dec    %eax
  801149:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80114c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801150:	74 3d                	je     80118f <ltostr+0xe2>
		start = 1 ;
  801152:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801159:	eb 34                	jmp    80118f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80115b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80115e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801161:	01 d0                	add    %edx,%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801168:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	01 c2                	add    %eax,%edx
  801170:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801173:	8b 45 0c             	mov    0xc(%ebp),%eax
  801176:	01 c8                	add    %ecx,%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80117c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80117f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801182:	01 c2                	add    %eax,%edx
  801184:	8a 45 eb             	mov    -0x15(%ebp),%al
  801187:	88 02                	mov    %al,(%edx)
		start++ ;
  801189:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80118c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80118f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801192:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801195:	7c c4                	jl     80115b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801197:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80119a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119d:	01 d0                	add    %edx,%eax
  80119f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011a2:	90                   	nop
  8011a3:	c9                   	leave  
  8011a4:	c3                   	ret    

008011a5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011ab:	ff 75 08             	pushl  0x8(%ebp)
  8011ae:	e8 54 fa ff ff       	call   800c07 <strlen>
  8011b3:	83 c4 04             	add    $0x4,%esp
  8011b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011b9:	ff 75 0c             	pushl  0xc(%ebp)
  8011bc:	e8 46 fa ff ff       	call   800c07 <strlen>
  8011c1:	83 c4 04             	add    $0x4,%esp
  8011c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011d5:	eb 17                	jmp    8011ee <strcconcat+0x49>
		final[s] = str1[s] ;
  8011d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011da:	8b 45 10             	mov    0x10(%ebp),%eax
  8011dd:	01 c2                	add    %eax,%edx
  8011df:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	01 c8                	add    %ecx,%eax
  8011e7:	8a 00                	mov    (%eax),%al
  8011e9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011eb:	ff 45 fc             	incl   -0x4(%ebp)
  8011ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011f4:	7c e1                	jl     8011d7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011f6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801204:	eb 1f                	jmp    801225 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801206:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801209:	8d 50 01             	lea    0x1(%eax),%edx
  80120c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80120f:	89 c2                	mov    %eax,%edx
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	01 c2                	add    %eax,%edx
  801216:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801219:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121c:	01 c8                	add    %ecx,%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801222:	ff 45 f8             	incl   -0x8(%ebp)
  801225:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801228:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80122b:	7c d9                	jl     801206 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80122d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801230:	8b 45 10             	mov    0x10(%ebp),%eax
  801233:	01 d0                	add    %edx,%eax
  801235:	c6 00 00             	movb   $0x0,(%eax)
}
  801238:	90                   	nop
  801239:	c9                   	leave  
  80123a:	c3                   	ret    

0080123b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80123e:	8b 45 14             	mov    0x14(%ebp),%eax
  801241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801253:	8b 45 10             	mov    0x10(%ebp),%eax
  801256:	01 d0                	add    %edx,%eax
  801258:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80125e:	eb 0c                	jmp    80126c <strsplit+0x31>
			*string++ = 0;
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	8d 50 01             	lea    0x1(%eax),%edx
  801266:	89 55 08             	mov    %edx,0x8(%ebp)
  801269:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	84 c0                	test   %al,%al
  801273:	74 18                	je     80128d <strsplit+0x52>
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	0f be c0             	movsbl %al,%eax
  80127d:	50                   	push   %eax
  80127e:	ff 75 0c             	pushl  0xc(%ebp)
  801281:	e8 13 fb ff ff       	call   800d99 <strchr>
  801286:	83 c4 08             	add    $0x8,%esp
  801289:	85 c0                	test   %eax,%eax
  80128b:	75 d3                	jne    801260 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	84 c0                	test   %al,%al
  801294:	74 5a                	je     8012f0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801296:	8b 45 14             	mov    0x14(%ebp),%eax
  801299:	8b 00                	mov    (%eax),%eax
  80129b:	83 f8 0f             	cmp    $0xf,%eax
  80129e:	75 07                	jne    8012a7 <strsplit+0x6c>
		{
			return 0;
  8012a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a5:	eb 66                	jmp    80130d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012aa:	8b 00                	mov    (%eax),%eax
  8012ac:	8d 48 01             	lea    0x1(%eax),%ecx
  8012af:	8b 55 14             	mov    0x14(%ebp),%edx
  8012b2:	89 0a                	mov    %ecx,(%edx)
  8012b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012be:	01 c2                	add    %eax,%edx
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c5:	eb 03                	jmp    8012ca <strsplit+0x8f>
			string++;
  8012c7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	84 c0                	test   %al,%al
  8012d1:	74 8b                	je     80125e <strsplit+0x23>
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8a 00                	mov    (%eax),%al
  8012d8:	0f be c0             	movsbl %al,%eax
  8012db:	50                   	push   %eax
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	e8 b5 fa ff ff       	call   800d99 <strchr>
  8012e4:	83 c4 08             	add    $0x8,%esp
  8012e7:	85 c0                	test   %eax,%eax
  8012e9:	74 dc                	je     8012c7 <strsplit+0x8c>
			string++;
	}
  8012eb:	e9 6e ff ff ff       	jmp    80125e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012f0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f4:	8b 00                	mov    (%eax),%eax
  8012f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	01 d0                	add    %edx,%eax
  801302:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801308:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80130d:	c9                   	leave  
  80130e:	c3                   	ret    

0080130f <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801315:	a1 04 40 80 00       	mov    0x804004,%eax
  80131a:	85 c0                	test   %eax,%eax
  80131c:	74 1f                	je     80133d <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80131e:	e8 1d 00 00 00       	call   801340 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801323:	83 ec 0c             	sub    $0xc,%esp
  801326:	68 50 39 80 00       	push   $0x803950
  80132b:	e8 55 f2 ff ff       	call   800585 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801333:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80133a:	00 00 00 
	}
}
  80133d:	90                   	nop
  80133e:	c9                   	leave  
  80133f:	c3                   	ret    

00801340 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
  801343:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801346:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80134d:	00 00 00 
  801350:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801357:	00 00 00 
  80135a:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801361:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801364:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80136b:	00 00 00 
  80136e:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801375:	00 00 00 
  801378:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80137f:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801382:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801389:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  80138c:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801396:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80139b:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013a0:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  8013a5:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  8013ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013af:	a1 20 41 80 00       	mov    0x804120,%eax
  8013b4:	0f af c2             	imul   %edx,%eax
  8013b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  8013ba:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8013c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013c7:	01 d0                	add    %edx,%eax
  8013c9:	48                   	dec    %eax
  8013ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8013cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8013d5:	f7 75 e8             	divl   -0x18(%ebp)
  8013d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013db:	29 d0                	sub    %edx,%eax
  8013dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  8013e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013e3:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  8013ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013ed:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8013f3:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8013f9:	83 ec 04             	sub    $0x4,%esp
  8013fc:	6a 06                	push   $0x6
  8013fe:	50                   	push   %eax
  8013ff:	52                   	push   %edx
  801400:	e8 a1 05 00 00       	call   8019a6 <sys_allocate_chunk>
  801405:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801408:	a1 20 41 80 00       	mov    0x804120,%eax
  80140d:	83 ec 0c             	sub    $0xc,%esp
  801410:	50                   	push   %eax
  801411:	e8 16 0c 00 00       	call   80202c <initialize_MemBlocksList>
  801416:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801419:	a1 4c 41 80 00       	mov    0x80414c,%eax
  80141e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801421:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801425:	75 14                	jne    80143b <initialize_dyn_block_system+0xfb>
  801427:	83 ec 04             	sub    $0x4,%esp
  80142a:	68 75 39 80 00       	push   $0x803975
  80142f:	6a 2d                	push   $0x2d
  801431:	68 93 39 80 00       	push   $0x803993
  801436:	e8 96 ee ff ff       	call   8002d1 <_panic>
  80143b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80143e:	8b 00                	mov    (%eax),%eax
  801440:	85 c0                	test   %eax,%eax
  801442:	74 10                	je     801454 <initialize_dyn_block_system+0x114>
  801444:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801447:	8b 00                	mov    (%eax),%eax
  801449:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80144c:	8b 52 04             	mov    0x4(%edx),%edx
  80144f:	89 50 04             	mov    %edx,0x4(%eax)
  801452:	eb 0b                	jmp    80145f <initialize_dyn_block_system+0x11f>
  801454:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801457:	8b 40 04             	mov    0x4(%eax),%eax
  80145a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80145f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801462:	8b 40 04             	mov    0x4(%eax),%eax
  801465:	85 c0                	test   %eax,%eax
  801467:	74 0f                	je     801478 <initialize_dyn_block_system+0x138>
  801469:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80146c:	8b 40 04             	mov    0x4(%eax),%eax
  80146f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801472:	8b 12                	mov    (%edx),%edx
  801474:	89 10                	mov    %edx,(%eax)
  801476:	eb 0a                	jmp    801482 <initialize_dyn_block_system+0x142>
  801478:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80147b:	8b 00                	mov    (%eax),%eax
  80147d:	a3 48 41 80 00       	mov    %eax,0x804148
  801482:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801485:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80148b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80148e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801495:	a1 54 41 80 00       	mov    0x804154,%eax
  80149a:	48                   	dec    %eax
  80149b:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  8014a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014a3:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  8014aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014ad:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  8014b4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8014b8:	75 14                	jne    8014ce <initialize_dyn_block_system+0x18e>
  8014ba:	83 ec 04             	sub    $0x4,%esp
  8014bd:	68 a0 39 80 00       	push   $0x8039a0
  8014c2:	6a 30                	push   $0x30
  8014c4:	68 93 39 80 00       	push   $0x803993
  8014c9:	e8 03 ee ff ff       	call   8002d1 <_panic>
  8014ce:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8014d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014d7:	89 50 04             	mov    %edx,0x4(%eax)
  8014da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014dd:	8b 40 04             	mov    0x4(%eax),%eax
  8014e0:	85 c0                	test   %eax,%eax
  8014e2:	74 0c                	je     8014f0 <initialize_dyn_block_system+0x1b0>
  8014e4:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8014e9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014ec:	89 10                	mov    %edx,(%eax)
  8014ee:	eb 08                	jmp    8014f8 <initialize_dyn_block_system+0x1b8>
  8014f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014f3:	a3 38 41 80 00       	mov    %eax,0x804138
  8014f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014fb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801500:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801503:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801509:	a1 44 41 80 00       	mov    0x804144,%eax
  80150e:	40                   	inc    %eax
  80150f:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801514:	90                   	nop
  801515:	c9                   	leave  
  801516:	c3                   	ret    

00801517 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
  80151a:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80151d:	e8 ed fd ff ff       	call   80130f <InitializeUHeap>
	if (size == 0) return NULL ;
  801522:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801526:	75 07                	jne    80152f <malloc+0x18>
  801528:	b8 00 00 00 00       	mov    $0x0,%eax
  80152d:	eb 67                	jmp    801596 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  80152f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801536:	8b 55 08             	mov    0x8(%ebp),%edx
  801539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153c:	01 d0                	add    %edx,%eax
  80153e:	48                   	dec    %eax
  80153f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801542:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801545:	ba 00 00 00 00       	mov    $0x0,%edx
  80154a:	f7 75 f4             	divl   -0xc(%ebp)
  80154d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801550:	29 d0                	sub    %edx,%eax
  801552:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801555:	e8 1a 08 00 00       	call   801d74 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80155a:	85 c0                	test   %eax,%eax
  80155c:	74 33                	je     801591 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  80155e:	83 ec 0c             	sub    $0xc,%esp
  801561:	ff 75 08             	pushl  0x8(%ebp)
  801564:	e8 0c 0e 00 00       	call   802375 <alloc_block_FF>
  801569:	83 c4 10             	add    $0x10,%esp
  80156c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  80156f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801573:	74 1c                	je     801591 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801575:	83 ec 0c             	sub    $0xc,%esp
  801578:	ff 75 ec             	pushl  -0x14(%ebp)
  80157b:	e8 07 0c 00 00       	call   802187 <insert_sorted_allocList>
  801580:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801583:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801586:	8b 40 08             	mov    0x8(%eax),%eax
  801589:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  80158c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80158f:	eb 05                	jmp    801596 <malloc+0x7f>
		}
	}
	return NULL;
  801591:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  8015a4:	83 ec 08             	sub    $0x8,%esp
  8015a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8015aa:	68 40 40 80 00       	push   $0x804040
  8015af:	e8 5b 0b 00 00       	call   80210f <find_block>
  8015b4:	83 c4 10             	add    $0x10,%esp
  8015b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  8015ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8015c0:	83 ec 08             	sub    $0x8,%esp
  8015c3:	50                   	push   %eax
  8015c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8015c7:	e8 a2 03 00 00       	call   80196e <sys_free_user_mem>
  8015cc:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  8015cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015d3:	75 14                	jne    8015e9 <free+0x51>
  8015d5:	83 ec 04             	sub    $0x4,%esp
  8015d8:	68 75 39 80 00       	push   $0x803975
  8015dd:	6a 76                	push   $0x76
  8015df:	68 93 39 80 00       	push   $0x803993
  8015e4:	e8 e8 ec ff ff       	call   8002d1 <_panic>
  8015e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ec:	8b 00                	mov    (%eax),%eax
  8015ee:	85 c0                	test   %eax,%eax
  8015f0:	74 10                	je     801602 <free+0x6a>
  8015f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f5:	8b 00                	mov    (%eax),%eax
  8015f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015fa:	8b 52 04             	mov    0x4(%edx),%edx
  8015fd:	89 50 04             	mov    %edx,0x4(%eax)
  801600:	eb 0b                	jmp    80160d <free+0x75>
  801602:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801605:	8b 40 04             	mov    0x4(%eax),%eax
  801608:	a3 44 40 80 00       	mov    %eax,0x804044
  80160d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801610:	8b 40 04             	mov    0x4(%eax),%eax
  801613:	85 c0                	test   %eax,%eax
  801615:	74 0f                	je     801626 <free+0x8e>
  801617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161a:	8b 40 04             	mov    0x4(%eax),%eax
  80161d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801620:	8b 12                	mov    (%edx),%edx
  801622:	89 10                	mov    %edx,(%eax)
  801624:	eb 0a                	jmp    801630 <free+0x98>
  801626:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801629:	8b 00                	mov    (%eax),%eax
  80162b:	a3 40 40 80 00       	mov    %eax,0x804040
  801630:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801633:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801639:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801643:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801648:	48                   	dec    %eax
  801649:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  80164e:	83 ec 0c             	sub    $0xc,%esp
  801651:	ff 75 f0             	pushl  -0x10(%ebp)
  801654:	e8 0b 14 00 00       	call   802a64 <insert_sorted_with_merge_freeList>
  801659:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80165c:	90                   	nop
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	83 ec 28             	sub    $0x28,%esp
  801665:	8b 45 10             	mov    0x10(%ebp),%eax
  801668:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80166b:	e8 9f fc ff ff       	call   80130f <InitializeUHeap>
	if (size == 0) return NULL ;
  801670:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801674:	75 0a                	jne    801680 <smalloc+0x21>
  801676:	b8 00 00 00 00       	mov    $0x0,%eax
  80167b:	e9 8d 00 00 00       	jmp    80170d <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801680:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801687:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168d:	01 d0                	add    %edx,%eax
  80168f:	48                   	dec    %eax
  801690:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801693:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801696:	ba 00 00 00 00       	mov    $0x0,%edx
  80169b:	f7 75 f4             	divl   -0xc(%ebp)
  80169e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a1:	29 d0                	sub    %edx,%eax
  8016a3:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016a6:	e8 c9 06 00 00       	call   801d74 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016ab:	85 c0                	test   %eax,%eax
  8016ad:	74 59                	je     801708 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  8016af:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  8016b6:	83 ec 0c             	sub    $0xc,%esp
  8016b9:	ff 75 0c             	pushl  0xc(%ebp)
  8016bc:	e8 b4 0c 00 00       	call   802375 <alloc_block_FF>
  8016c1:	83 c4 10             	add    $0x10,%esp
  8016c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  8016c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016cb:	75 07                	jne    8016d4 <smalloc+0x75>
			{
				return NULL;
  8016cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d2:	eb 39                	jmp    80170d <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  8016d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016d7:	8b 40 08             	mov    0x8(%eax),%eax
  8016da:	89 c2                	mov    %eax,%edx
  8016dc:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8016e0:	52                   	push   %edx
  8016e1:	50                   	push   %eax
  8016e2:	ff 75 0c             	pushl  0xc(%ebp)
  8016e5:	ff 75 08             	pushl  0x8(%ebp)
  8016e8:	e8 0c 04 00 00       	call   801af9 <sys_createSharedObject>
  8016ed:	83 c4 10             	add    $0x10,%esp
  8016f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  8016f3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016f7:	78 08                	js     801701 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  8016f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016fc:	8b 40 08             	mov    0x8(%eax),%eax
  8016ff:	eb 0c                	jmp    80170d <smalloc+0xae>
				}
				else
				{
					return NULL;
  801701:	b8 00 00 00 00       	mov    $0x0,%eax
  801706:	eb 05                	jmp    80170d <smalloc+0xae>
				}
			}

		}
		return NULL;
  801708:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
  801712:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801715:	e8 f5 fb ff ff       	call   80130f <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80171a:	83 ec 08             	sub    $0x8,%esp
  80171d:	ff 75 0c             	pushl  0xc(%ebp)
  801720:	ff 75 08             	pushl  0x8(%ebp)
  801723:	e8 fb 03 00 00       	call   801b23 <sys_getSizeOfSharedObject>
  801728:	83 c4 10             	add    $0x10,%esp
  80172b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  80172e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801732:	75 07                	jne    80173b <sget+0x2c>
	{
		return NULL;
  801734:	b8 00 00 00 00       	mov    $0x0,%eax
  801739:	eb 64                	jmp    80179f <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80173b:	e8 34 06 00 00       	call   801d74 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801740:	85 c0                	test   %eax,%eax
  801742:	74 56                	je     80179a <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801744:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  80174b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174e:	83 ec 0c             	sub    $0xc,%esp
  801751:	50                   	push   %eax
  801752:	e8 1e 0c 00 00       	call   802375 <alloc_block_FF>
  801757:	83 c4 10             	add    $0x10,%esp
  80175a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  80175d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801761:	75 07                	jne    80176a <sget+0x5b>
		{
		return NULL;
  801763:	b8 00 00 00 00       	mov    $0x0,%eax
  801768:	eb 35                	jmp    80179f <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  80176a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176d:	8b 40 08             	mov    0x8(%eax),%eax
  801770:	83 ec 04             	sub    $0x4,%esp
  801773:	50                   	push   %eax
  801774:	ff 75 0c             	pushl  0xc(%ebp)
  801777:	ff 75 08             	pushl  0x8(%ebp)
  80177a:	e8 c1 03 00 00       	call   801b40 <sys_getSharedObject>
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801785:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801789:	78 08                	js     801793 <sget+0x84>
			{
				return (void*)v1->sva;
  80178b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178e:	8b 40 08             	mov    0x8(%eax),%eax
  801791:	eb 0c                	jmp    80179f <sget+0x90>
			}
			else
			{
				return NULL;
  801793:	b8 00 00 00 00       	mov    $0x0,%eax
  801798:	eb 05                	jmp    80179f <sget+0x90>
			}
		}
	}
  return NULL;
  80179a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
  8017a4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017a7:	e8 63 fb ff ff       	call   80130f <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017ac:	83 ec 04             	sub    $0x4,%esp
  8017af:	68 c4 39 80 00       	push   $0x8039c4
  8017b4:	68 0e 01 00 00       	push   $0x10e
  8017b9:	68 93 39 80 00       	push   $0x803993
  8017be:	e8 0e eb ff ff       	call   8002d1 <_panic>

008017c3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017c9:	83 ec 04             	sub    $0x4,%esp
  8017cc:	68 ec 39 80 00       	push   $0x8039ec
  8017d1:	68 22 01 00 00       	push   $0x122
  8017d6:	68 93 39 80 00       	push   $0x803993
  8017db:	e8 f1 ea ff ff       	call   8002d1 <_panic>

008017e0 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e6:	83 ec 04             	sub    $0x4,%esp
  8017e9:	68 10 3a 80 00       	push   $0x803a10
  8017ee:	68 2d 01 00 00       	push   $0x12d
  8017f3:	68 93 39 80 00       	push   $0x803993
  8017f8:	e8 d4 ea ff ff       	call   8002d1 <_panic>

008017fd <shrink>:

}
void shrink(uint32 newSize)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801803:	83 ec 04             	sub    $0x4,%esp
  801806:	68 10 3a 80 00       	push   $0x803a10
  80180b:	68 32 01 00 00       	push   $0x132
  801810:	68 93 39 80 00       	push   $0x803993
  801815:	e8 b7 ea ff ff       	call   8002d1 <_panic>

0080181a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801820:	83 ec 04             	sub    $0x4,%esp
  801823:	68 10 3a 80 00       	push   $0x803a10
  801828:	68 37 01 00 00       	push   $0x137
  80182d:	68 93 39 80 00       	push   $0x803993
  801832:	e8 9a ea ff ff       	call   8002d1 <_panic>

00801837 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
  80183a:	57                   	push   %edi
  80183b:	56                   	push   %esi
  80183c:	53                   	push   %ebx
  80183d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	8b 55 0c             	mov    0xc(%ebp),%edx
  801846:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801849:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80184c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80184f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801852:	cd 30                	int    $0x30
  801854:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801857:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80185a:	83 c4 10             	add    $0x10,%esp
  80185d:	5b                   	pop    %ebx
  80185e:	5e                   	pop    %esi
  80185f:	5f                   	pop    %edi
  801860:	5d                   	pop    %ebp
  801861:	c3                   	ret    

00801862 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
  801865:	83 ec 04             	sub    $0x4,%esp
  801868:	8b 45 10             	mov    0x10(%ebp),%eax
  80186b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80186e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	52                   	push   %edx
  80187a:	ff 75 0c             	pushl  0xc(%ebp)
  80187d:	50                   	push   %eax
  80187e:	6a 00                	push   $0x0
  801880:	e8 b2 ff ff ff       	call   801837 <syscall>
  801885:	83 c4 18             	add    $0x18,%esp
}
  801888:	90                   	nop
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_cgetc>:

int
sys_cgetc(void)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 01                	push   $0x1
  80189a:	e8 98 ff ff ff       	call   801837 <syscall>
  80189f:	83 c4 18             	add    $0x18,%esp
}
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	52                   	push   %edx
  8018b4:	50                   	push   %eax
  8018b5:	6a 05                	push   $0x5
  8018b7:	e8 7b ff ff ff       	call   801837 <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	56                   	push   %esi
  8018c5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018c6:	8b 75 18             	mov    0x18(%ebp),%esi
  8018c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d5:	56                   	push   %esi
  8018d6:	53                   	push   %ebx
  8018d7:	51                   	push   %ecx
  8018d8:	52                   	push   %edx
  8018d9:	50                   	push   %eax
  8018da:	6a 06                	push   $0x6
  8018dc:	e8 56 ff ff ff       	call   801837 <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
}
  8018e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e7:	5b                   	pop    %ebx
  8018e8:	5e                   	pop    %esi
  8018e9:	5d                   	pop    %ebp
  8018ea:	c3                   	ret    

008018eb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	52                   	push   %edx
  8018fb:	50                   	push   %eax
  8018fc:	6a 07                	push   $0x7
  8018fe:	e8 34 ff ff ff       	call   801837 <syscall>
  801903:	83 c4 18             	add    $0x18,%esp
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	ff 75 0c             	pushl  0xc(%ebp)
  801914:	ff 75 08             	pushl  0x8(%ebp)
  801917:	6a 08                	push   $0x8
  801919:	e8 19 ff ff ff       	call   801837 <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
}
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 09                	push   $0x9
  801932:	e8 00 ff ff ff       	call   801837 <syscall>
  801937:	83 c4 18             	add    $0x18,%esp
}
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 0a                	push   $0xa
  80194b:	e8 e7 fe ff ff       	call   801837 <syscall>
  801950:	83 c4 18             	add    $0x18,%esp
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 0b                	push   $0xb
  801964:	e8 ce fe ff ff       	call   801837 <syscall>
  801969:	83 c4 18             	add    $0x18,%esp
}
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	ff 75 0c             	pushl  0xc(%ebp)
  80197a:	ff 75 08             	pushl  0x8(%ebp)
  80197d:	6a 0f                	push   $0xf
  80197f:	e8 b3 fe ff ff       	call   801837 <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
	return;
  801987:	90                   	nop
}
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	ff 75 0c             	pushl  0xc(%ebp)
  801996:	ff 75 08             	pushl  0x8(%ebp)
  801999:	6a 10                	push   $0x10
  80199b:	e8 97 fe ff ff       	call   801837 <syscall>
  8019a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a3:	90                   	nop
}
  8019a4:	c9                   	leave  
  8019a5:	c3                   	ret    

008019a6 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	ff 75 10             	pushl  0x10(%ebp)
  8019b0:	ff 75 0c             	pushl  0xc(%ebp)
  8019b3:	ff 75 08             	pushl  0x8(%ebp)
  8019b6:	6a 11                	push   $0x11
  8019b8:	e8 7a fe ff ff       	call   801837 <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c0:	90                   	nop
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 0c                	push   $0xc
  8019d2:	e8 60 fe ff ff       	call   801837 <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
}
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	ff 75 08             	pushl  0x8(%ebp)
  8019ea:	6a 0d                	push   $0xd
  8019ec:	e8 46 fe ff ff       	call   801837 <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 0e                	push   $0xe
  801a05:	e8 2d fe ff ff       	call   801837 <syscall>
  801a0a:	83 c4 18             	add    $0x18,%esp
}
  801a0d:	90                   	nop
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 13                	push   $0x13
  801a1f:	e8 13 fe ff ff       	call   801837 <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	90                   	nop
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 14                	push   $0x14
  801a39:	e8 f9 fd ff ff       	call   801837 <syscall>
  801a3e:	83 c4 18             	add    $0x18,%esp
}
  801a41:	90                   	nop
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
  801a47:	83 ec 04             	sub    $0x4,%esp
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a50:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	50                   	push   %eax
  801a5d:	6a 15                	push   $0x15
  801a5f:	e8 d3 fd ff ff       	call   801837 <syscall>
  801a64:	83 c4 18             	add    $0x18,%esp
}
  801a67:	90                   	nop
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 16                	push   $0x16
  801a79:	e8 b9 fd ff ff       	call   801837 <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
}
  801a81:	90                   	nop
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	ff 75 0c             	pushl  0xc(%ebp)
  801a93:	50                   	push   %eax
  801a94:	6a 17                	push   $0x17
  801a96:	e8 9c fd ff ff       	call   801837 <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aa3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	52                   	push   %edx
  801ab0:	50                   	push   %eax
  801ab1:	6a 1a                	push   $0x1a
  801ab3:	e8 7f fd ff ff       	call   801837 <syscall>
  801ab8:	83 c4 18             	add    $0x18,%esp
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ac0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	52                   	push   %edx
  801acd:	50                   	push   %eax
  801ace:	6a 18                	push   $0x18
  801ad0:	e8 62 fd ff ff       	call   801837 <syscall>
  801ad5:	83 c4 18             	add    $0x18,%esp
}
  801ad8:	90                   	nop
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ade:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	52                   	push   %edx
  801aeb:	50                   	push   %eax
  801aec:	6a 19                	push   $0x19
  801aee:	e8 44 fd ff ff       	call   801837 <syscall>
  801af3:	83 c4 18             	add    $0x18,%esp
}
  801af6:	90                   	nop
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
  801afc:	83 ec 04             	sub    $0x4,%esp
  801aff:	8b 45 10             	mov    0x10(%ebp),%eax
  801b02:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b05:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b08:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0f:	6a 00                	push   $0x0
  801b11:	51                   	push   %ecx
  801b12:	52                   	push   %edx
  801b13:	ff 75 0c             	pushl  0xc(%ebp)
  801b16:	50                   	push   %eax
  801b17:	6a 1b                	push   $0x1b
  801b19:	e8 19 fd ff ff       	call   801837 <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	52                   	push   %edx
  801b33:	50                   	push   %eax
  801b34:	6a 1c                	push   $0x1c
  801b36:	e8 fc fc ff ff       	call   801837 <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b43:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b49:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	51                   	push   %ecx
  801b51:	52                   	push   %edx
  801b52:	50                   	push   %eax
  801b53:	6a 1d                	push   $0x1d
  801b55:	e8 dd fc ff ff       	call   801837 <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b65:	8b 45 08             	mov    0x8(%ebp),%eax
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	52                   	push   %edx
  801b6f:	50                   	push   %eax
  801b70:	6a 1e                	push   $0x1e
  801b72:	e8 c0 fc ff ff       	call   801837 <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 1f                	push   $0x1f
  801b8b:	e8 a7 fc ff ff       	call   801837 <syscall>
  801b90:	83 c4 18             	add    $0x18,%esp
}
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	6a 00                	push   $0x0
  801b9d:	ff 75 14             	pushl  0x14(%ebp)
  801ba0:	ff 75 10             	pushl  0x10(%ebp)
  801ba3:	ff 75 0c             	pushl  0xc(%ebp)
  801ba6:	50                   	push   %eax
  801ba7:	6a 20                	push   $0x20
  801ba9:	e8 89 fc ff ff       	call   801837 <syscall>
  801bae:	83 c4 18             	add    $0x18,%esp
}
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	50                   	push   %eax
  801bc2:	6a 21                	push   $0x21
  801bc4:	e8 6e fc ff ff       	call   801837 <syscall>
  801bc9:	83 c4 18             	add    $0x18,%esp
}
  801bcc:	90                   	nop
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	50                   	push   %eax
  801bde:	6a 22                	push   $0x22
  801be0:	e8 52 fc ff ff       	call   801837 <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 02                	push   $0x2
  801bf9:	e8 39 fc ff ff       	call   801837 <syscall>
  801bfe:	83 c4 18             	add    $0x18,%esp
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 03                	push   $0x3
  801c12:	e8 20 fc ff ff       	call   801837 <syscall>
  801c17:	83 c4 18             	add    $0x18,%esp
}
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 04                	push   $0x4
  801c2b:	e8 07 fc ff ff       	call   801837 <syscall>
  801c30:	83 c4 18             	add    $0x18,%esp
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <sys_exit_env>:


void sys_exit_env(void)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 23                	push   $0x23
  801c44:	e8 ee fb ff ff       	call   801837 <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
}
  801c4c:	90                   	nop
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
  801c52:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c55:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c58:	8d 50 04             	lea    0x4(%eax),%edx
  801c5b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	52                   	push   %edx
  801c65:	50                   	push   %eax
  801c66:	6a 24                	push   $0x24
  801c68:	e8 ca fb ff ff       	call   801837 <syscall>
  801c6d:	83 c4 18             	add    $0x18,%esp
	return result;
  801c70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c73:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c76:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c79:	89 01                	mov    %eax,(%ecx)
  801c7b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c81:	c9                   	leave  
  801c82:	c2 04 00             	ret    $0x4

00801c85 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	ff 75 10             	pushl  0x10(%ebp)
  801c8f:	ff 75 0c             	pushl  0xc(%ebp)
  801c92:	ff 75 08             	pushl  0x8(%ebp)
  801c95:	6a 12                	push   $0x12
  801c97:	e8 9b fb ff ff       	call   801837 <syscall>
  801c9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9f:	90                   	nop
}
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 25                	push   $0x25
  801cb1:	e8 81 fb ff ff       	call   801837 <syscall>
  801cb6:	83 c4 18             	add    $0x18,%esp
}
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    

00801cbb <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
  801cbe:	83 ec 04             	sub    $0x4,%esp
  801cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cc7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	50                   	push   %eax
  801cd4:	6a 26                	push   $0x26
  801cd6:	e8 5c fb ff ff       	call   801837 <syscall>
  801cdb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cde:	90                   	nop
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <rsttst>:
void rsttst()
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 28                	push   $0x28
  801cf0:	e8 42 fb ff ff       	call   801837 <syscall>
  801cf5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf8:	90                   	nop
}
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
  801cfe:	83 ec 04             	sub    $0x4,%esp
  801d01:	8b 45 14             	mov    0x14(%ebp),%eax
  801d04:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d07:	8b 55 18             	mov    0x18(%ebp),%edx
  801d0a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d0e:	52                   	push   %edx
  801d0f:	50                   	push   %eax
  801d10:	ff 75 10             	pushl  0x10(%ebp)
  801d13:	ff 75 0c             	pushl  0xc(%ebp)
  801d16:	ff 75 08             	pushl  0x8(%ebp)
  801d19:	6a 27                	push   $0x27
  801d1b:	e8 17 fb ff ff       	call   801837 <syscall>
  801d20:	83 c4 18             	add    $0x18,%esp
	return ;
  801d23:	90                   	nop
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <chktst>:
void chktst(uint32 n)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	ff 75 08             	pushl  0x8(%ebp)
  801d34:	6a 29                	push   $0x29
  801d36:	e8 fc fa ff ff       	call   801837 <syscall>
  801d3b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3e:	90                   	nop
}
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    

00801d41 <inctst>:

void inctst()
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 2a                	push   $0x2a
  801d50:	e8 e2 fa ff ff       	call   801837 <syscall>
  801d55:	83 c4 18             	add    $0x18,%esp
	return ;
  801d58:	90                   	nop
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <gettst>:
uint32 gettst()
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 2b                	push   $0x2b
  801d6a:	e8 c8 fa ff ff       	call   801837 <syscall>
  801d6f:	83 c4 18             	add    $0x18,%esp
}
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 2c                	push   $0x2c
  801d86:	e8 ac fa ff ff       	call   801837 <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
  801d8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d91:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d95:	75 07                	jne    801d9e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d97:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9c:	eb 05                	jmp    801da3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
  801da8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 2c                	push   $0x2c
  801db7:	e8 7b fa ff ff       	call   801837 <syscall>
  801dbc:	83 c4 18             	add    $0x18,%esp
  801dbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dc2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dc6:	75 07                	jne    801dcf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dc8:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcd:	eb 05                	jmp    801dd4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
  801dd9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 2c                	push   $0x2c
  801de8:	e8 4a fa ff ff       	call   801837 <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
  801df0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801df3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801df7:	75 07                	jne    801e00 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801df9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfe:	eb 05                	jmp    801e05 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
  801e0a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 2c                	push   $0x2c
  801e19:	e8 19 fa ff ff       	call   801837 <syscall>
  801e1e:	83 c4 18             	add    $0x18,%esp
  801e21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e24:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e28:	75 07                	jne    801e31 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2f:	eb 05                	jmp    801e36 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	ff 75 08             	pushl  0x8(%ebp)
  801e46:	6a 2d                	push   $0x2d
  801e48:	e8 ea f9 ff ff       	call   801837 <syscall>
  801e4d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e50:	90                   	nop
}
  801e51:	c9                   	leave  
  801e52:	c3                   	ret    

00801e53 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
  801e56:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e57:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e5a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e60:	8b 45 08             	mov    0x8(%ebp),%eax
  801e63:	6a 00                	push   $0x0
  801e65:	53                   	push   %ebx
  801e66:	51                   	push   %ecx
  801e67:	52                   	push   %edx
  801e68:	50                   	push   %eax
  801e69:	6a 2e                	push   $0x2e
  801e6b:	e8 c7 f9 ff ff       	call   801837 <syscall>
  801e70:	83 c4 18             	add    $0x18,%esp
}
  801e73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	52                   	push   %edx
  801e88:	50                   	push   %eax
  801e89:	6a 2f                	push   $0x2f
  801e8b:	e8 a7 f9 ff ff       	call   801837 <syscall>
  801e90:	83 c4 18             	add    $0x18,%esp
}
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e9b:	83 ec 0c             	sub    $0xc,%esp
  801e9e:	68 20 3a 80 00       	push   $0x803a20
  801ea3:	e8 dd e6 ff ff       	call   800585 <cprintf>
  801ea8:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801eab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801eb2:	83 ec 0c             	sub    $0xc,%esp
  801eb5:	68 4c 3a 80 00       	push   $0x803a4c
  801eba:	e8 c6 e6 ff ff       	call   800585 <cprintf>
  801ebf:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ec2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ec6:	a1 38 41 80 00       	mov    0x804138,%eax
  801ecb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ece:	eb 56                	jmp    801f26 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ed0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ed4:	74 1c                	je     801ef2 <print_mem_block_lists+0x5d>
  801ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed9:	8b 50 08             	mov    0x8(%eax),%edx
  801edc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801edf:	8b 48 08             	mov    0x8(%eax),%ecx
  801ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee8:	01 c8                	add    %ecx,%eax
  801eea:	39 c2                	cmp    %eax,%edx
  801eec:	73 04                	jae    801ef2 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801eee:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef5:	8b 50 08             	mov    0x8(%eax),%edx
  801ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efb:	8b 40 0c             	mov    0xc(%eax),%eax
  801efe:	01 c2                	add    %eax,%edx
  801f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f03:	8b 40 08             	mov    0x8(%eax),%eax
  801f06:	83 ec 04             	sub    $0x4,%esp
  801f09:	52                   	push   %edx
  801f0a:	50                   	push   %eax
  801f0b:	68 61 3a 80 00       	push   $0x803a61
  801f10:	e8 70 e6 ff ff       	call   800585 <cprintf>
  801f15:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f1e:	a1 40 41 80 00       	mov    0x804140,%eax
  801f23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f2a:	74 07                	je     801f33 <print_mem_block_lists+0x9e>
  801f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2f:	8b 00                	mov    (%eax),%eax
  801f31:	eb 05                	jmp    801f38 <print_mem_block_lists+0xa3>
  801f33:	b8 00 00 00 00       	mov    $0x0,%eax
  801f38:	a3 40 41 80 00       	mov    %eax,0x804140
  801f3d:	a1 40 41 80 00       	mov    0x804140,%eax
  801f42:	85 c0                	test   %eax,%eax
  801f44:	75 8a                	jne    801ed0 <print_mem_block_lists+0x3b>
  801f46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f4a:	75 84                	jne    801ed0 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f4c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f50:	75 10                	jne    801f62 <print_mem_block_lists+0xcd>
  801f52:	83 ec 0c             	sub    $0xc,%esp
  801f55:	68 70 3a 80 00       	push   $0x803a70
  801f5a:	e8 26 e6 ff ff       	call   800585 <cprintf>
  801f5f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f62:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f69:	83 ec 0c             	sub    $0xc,%esp
  801f6c:	68 94 3a 80 00       	push   $0x803a94
  801f71:	e8 0f e6 ff ff       	call   800585 <cprintf>
  801f76:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f79:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f7d:	a1 40 40 80 00       	mov    0x804040,%eax
  801f82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f85:	eb 56                	jmp    801fdd <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f8b:	74 1c                	je     801fa9 <print_mem_block_lists+0x114>
  801f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f90:	8b 50 08             	mov    0x8(%eax),%edx
  801f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f96:	8b 48 08             	mov    0x8(%eax),%ecx
  801f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9f:	01 c8                	add    %ecx,%eax
  801fa1:	39 c2                	cmp    %eax,%edx
  801fa3:	73 04                	jae    801fa9 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fa5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fac:	8b 50 08             	mov    0x8(%eax),%edx
  801faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb2:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb5:	01 c2                	add    %eax,%edx
  801fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fba:	8b 40 08             	mov    0x8(%eax),%eax
  801fbd:	83 ec 04             	sub    $0x4,%esp
  801fc0:	52                   	push   %edx
  801fc1:	50                   	push   %eax
  801fc2:	68 61 3a 80 00       	push   $0x803a61
  801fc7:	e8 b9 e5 ff ff       	call   800585 <cprintf>
  801fcc:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fd5:	a1 48 40 80 00       	mov    0x804048,%eax
  801fda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe1:	74 07                	je     801fea <print_mem_block_lists+0x155>
  801fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe6:	8b 00                	mov    (%eax),%eax
  801fe8:	eb 05                	jmp    801fef <print_mem_block_lists+0x15a>
  801fea:	b8 00 00 00 00       	mov    $0x0,%eax
  801fef:	a3 48 40 80 00       	mov    %eax,0x804048
  801ff4:	a1 48 40 80 00       	mov    0x804048,%eax
  801ff9:	85 c0                	test   %eax,%eax
  801ffb:	75 8a                	jne    801f87 <print_mem_block_lists+0xf2>
  801ffd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802001:	75 84                	jne    801f87 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802003:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802007:	75 10                	jne    802019 <print_mem_block_lists+0x184>
  802009:	83 ec 0c             	sub    $0xc,%esp
  80200c:	68 ac 3a 80 00       	push   $0x803aac
  802011:	e8 6f e5 ff ff       	call   800585 <cprintf>
  802016:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802019:	83 ec 0c             	sub    $0xc,%esp
  80201c:	68 20 3a 80 00       	push   $0x803a20
  802021:	e8 5f e5 ff ff       	call   800585 <cprintf>
  802026:	83 c4 10             	add    $0x10,%esp

}
  802029:	90                   	nop
  80202a:	c9                   	leave  
  80202b:	c3                   	ret    

0080202c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
  80202f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  802032:	8b 45 08             	mov    0x8(%ebp),%eax
  802035:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  802038:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80203f:	00 00 00 
  802042:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802049:	00 00 00 
  80204c:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802053:	00 00 00 
	for(int i = 0; i<n;i++)
  802056:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80205d:	e9 9e 00 00 00       	jmp    802100 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802062:	a1 50 40 80 00       	mov    0x804050,%eax
  802067:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80206a:	c1 e2 04             	shl    $0x4,%edx
  80206d:	01 d0                	add    %edx,%eax
  80206f:	85 c0                	test   %eax,%eax
  802071:	75 14                	jne    802087 <initialize_MemBlocksList+0x5b>
  802073:	83 ec 04             	sub    $0x4,%esp
  802076:	68 d4 3a 80 00       	push   $0x803ad4
  80207b:	6a 47                	push   $0x47
  80207d:	68 f7 3a 80 00       	push   $0x803af7
  802082:	e8 4a e2 ff ff       	call   8002d1 <_panic>
  802087:	a1 50 40 80 00       	mov    0x804050,%eax
  80208c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80208f:	c1 e2 04             	shl    $0x4,%edx
  802092:	01 d0                	add    %edx,%eax
  802094:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80209a:	89 10                	mov    %edx,(%eax)
  80209c:	8b 00                	mov    (%eax),%eax
  80209e:	85 c0                	test   %eax,%eax
  8020a0:	74 18                	je     8020ba <initialize_MemBlocksList+0x8e>
  8020a2:	a1 48 41 80 00       	mov    0x804148,%eax
  8020a7:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020ad:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020b0:	c1 e1 04             	shl    $0x4,%ecx
  8020b3:	01 ca                	add    %ecx,%edx
  8020b5:	89 50 04             	mov    %edx,0x4(%eax)
  8020b8:	eb 12                	jmp    8020cc <initialize_MemBlocksList+0xa0>
  8020ba:	a1 50 40 80 00       	mov    0x804050,%eax
  8020bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c2:	c1 e2 04             	shl    $0x4,%edx
  8020c5:	01 d0                	add    %edx,%eax
  8020c7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020cc:	a1 50 40 80 00       	mov    0x804050,%eax
  8020d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d4:	c1 e2 04             	shl    $0x4,%edx
  8020d7:	01 d0                	add    %edx,%eax
  8020d9:	a3 48 41 80 00       	mov    %eax,0x804148
  8020de:	a1 50 40 80 00       	mov    0x804050,%eax
  8020e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e6:	c1 e2 04             	shl    $0x4,%edx
  8020e9:	01 d0                	add    %edx,%eax
  8020eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020f2:	a1 54 41 80 00       	mov    0x804154,%eax
  8020f7:	40                   	inc    %eax
  8020f8:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8020fd:	ff 45 f4             	incl   -0xc(%ebp)
  802100:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802103:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802106:	0f 82 56 ff ff ff    	jb     802062 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  80210c:	90                   	nop
  80210d:	c9                   	leave  
  80210e:	c3                   	ret    

0080210f <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
  802112:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  802115:	8b 45 0c             	mov    0xc(%ebp),%eax
  802118:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  80211b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802122:	a1 40 40 80 00       	mov    0x804040,%eax
  802127:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80212a:	eb 23                	jmp    80214f <find_block+0x40>
	{
		if(blk->sva == virAddress)
  80212c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80212f:	8b 40 08             	mov    0x8(%eax),%eax
  802132:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802135:	75 09                	jne    802140 <find_block+0x31>
		{
			found = 1;
  802137:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  80213e:	eb 35                	jmp    802175 <find_block+0x66>
		}
		else
		{
			found = 0;
  802140:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802147:	a1 48 40 80 00       	mov    0x804048,%eax
  80214c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80214f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802153:	74 07                	je     80215c <find_block+0x4d>
  802155:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802158:	8b 00                	mov    (%eax),%eax
  80215a:	eb 05                	jmp    802161 <find_block+0x52>
  80215c:	b8 00 00 00 00       	mov    $0x0,%eax
  802161:	a3 48 40 80 00       	mov    %eax,0x804048
  802166:	a1 48 40 80 00       	mov    0x804048,%eax
  80216b:	85 c0                	test   %eax,%eax
  80216d:	75 bd                	jne    80212c <find_block+0x1d>
  80216f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802173:	75 b7                	jne    80212c <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802175:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802179:	75 05                	jne    802180 <find_block+0x71>
	{
		return blk;
  80217b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80217e:	eb 05                	jmp    802185 <find_block+0x76>
	}
	else
	{
		return NULL;
  802180:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802185:	c9                   	leave  
  802186:	c3                   	ret    

00802187 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
  80218a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  80218d:	8b 45 08             	mov    0x8(%ebp),%eax
  802190:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802193:	a1 40 40 80 00       	mov    0x804040,%eax
  802198:	85 c0                	test   %eax,%eax
  80219a:	74 12                	je     8021ae <insert_sorted_allocList+0x27>
  80219c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219f:	8b 50 08             	mov    0x8(%eax),%edx
  8021a2:	a1 40 40 80 00       	mov    0x804040,%eax
  8021a7:	8b 40 08             	mov    0x8(%eax),%eax
  8021aa:	39 c2                	cmp    %eax,%edx
  8021ac:	73 65                	jae    802213 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  8021ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021b2:	75 14                	jne    8021c8 <insert_sorted_allocList+0x41>
  8021b4:	83 ec 04             	sub    $0x4,%esp
  8021b7:	68 d4 3a 80 00       	push   $0x803ad4
  8021bc:	6a 7b                	push   $0x7b
  8021be:	68 f7 3a 80 00       	push   $0x803af7
  8021c3:	e8 09 e1 ff ff       	call   8002d1 <_panic>
  8021c8:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d1:	89 10                	mov    %edx,(%eax)
  8021d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d6:	8b 00                	mov    (%eax),%eax
  8021d8:	85 c0                	test   %eax,%eax
  8021da:	74 0d                	je     8021e9 <insert_sorted_allocList+0x62>
  8021dc:	a1 40 40 80 00       	mov    0x804040,%eax
  8021e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021e4:	89 50 04             	mov    %edx,0x4(%eax)
  8021e7:	eb 08                	jmp    8021f1 <insert_sorted_allocList+0x6a>
  8021e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ec:	a3 44 40 80 00       	mov    %eax,0x804044
  8021f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f4:	a3 40 40 80 00       	mov    %eax,0x804040
  8021f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802203:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802208:	40                   	inc    %eax
  802209:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80220e:	e9 5f 01 00 00       	jmp    802372 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  802213:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802216:	8b 50 08             	mov    0x8(%eax),%edx
  802219:	a1 44 40 80 00       	mov    0x804044,%eax
  80221e:	8b 40 08             	mov    0x8(%eax),%eax
  802221:	39 c2                	cmp    %eax,%edx
  802223:	76 65                	jbe    80228a <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802225:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802229:	75 14                	jne    80223f <insert_sorted_allocList+0xb8>
  80222b:	83 ec 04             	sub    $0x4,%esp
  80222e:	68 10 3b 80 00       	push   $0x803b10
  802233:	6a 7f                	push   $0x7f
  802235:	68 f7 3a 80 00       	push   $0x803af7
  80223a:	e8 92 e0 ff ff       	call   8002d1 <_panic>
  80223f:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802245:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802248:	89 50 04             	mov    %edx,0x4(%eax)
  80224b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80224e:	8b 40 04             	mov    0x4(%eax),%eax
  802251:	85 c0                	test   %eax,%eax
  802253:	74 0c                	je     802261 <insert_sorted_allocList+0xda>
  802255:	a1 44 40 80 00       	mov    0x804044,%eax
  80225a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80225d:	89 10                	mov    %edx,(%eax)
  80225f:	eb 08                	jmp    802269 <insert_sorted_allocList+0xe2>
  802261:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802264:	a3 40 40 80 00       	mov    %eax,0x804040
  802269:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226c:	a3 44 40 80 00       	mov    %eax,0x804044
  802271:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802274:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80227a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80227f:	40                   	inc    %eax
  802280:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802285:	e9 e8 00 00 00       	jmp    802372 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  80228a:	a1 40 40 80 00       	mov    0x804040,%eax
  80228f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802292:	e9 ab 00 00 00       	jmp    802342 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229a:	8b 00                	mov    (%eax),%eax
  80229c:	85 c0                	test   %eax,%eax
  80229e:	0f 84 96 00 00 00    	je     80233a <insert_sorted_allocList+0x1b3>
  8022a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a7:	8b 50 08             	mov    0x8(%eax),%edx
  8022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ad:	8b 40 08             	mov    0x8(%eax),%eax
  8022b0:	39 c2                	cmp    %eax,%edx
  8022b2:	0f 86 82 00 00 00    	jbe    80233a <insert_sorted_allocList+0x1b3>
  8022b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022bb:	8b 50 08             	mov    0x8(%eax),%edx
  8022be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c1:	8b 00                	mov    (%eax),%eax
  8022c3:	8b 40 08             	mov    0x8(%eax),%eax
  8022c6:	39 c2                	cmp    %eax,%edx
  8022c8:	73 70                	jae    80233a <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  8022ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ce:	74 06                	je     8022d6 <insert_sorted_allocList+0x14f>
  8022d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022d4:	75 17                	jne    8022ed <insert_sorted_allocList+0x166>
  8022d6:	83 ec 04             	sub    $0x4,%esp
  8022d9:	68 34 3b 80 00       	push   $0x803b34
  8022de:	68 87 00 00 00       	push   $0x87
  8022e3:	68 f7 3a 80 00       	push   $0x803af7
  8022e8:	e8 e4 df ff ff       	call   8002d1 <_panic>
  8022ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f0:	8b 10                	mov    (%eax),%edx
  8022f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f5:	89 10                	mov    %edx,(%eax)
  8022f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fa:	8b 00                	mov    (%eax),%eax
  8022fc:	85 c0                	test   %eax,%eax
  8022fe:	74 0b                	je     80230b <insert_sorted_allocList+0x184>
  802300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802303:	8b 00                	mov    (%eax),%eax
  802305:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802308:	89 50 04             	mov    %edx,0x4(%eax)
  80230b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802311:	89 10                	mov    %edx,(%eax)
  802313:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802316:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802319:	89 50 04             	mov    %edx,0x4(%eax)
  80231c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231f:	8b 00                	mov    (%eax),%eax
  802321:	85 c0                	test   %eax,%eax
  802323:	75 08                	jne    80232d <insert_sorted_allocList+0x1a6>
  802325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802328:	a3 44 40 80 00       	mov    %eax,0x804044
  80232d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802332:	40                   	inc    %eax
  802333:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802338:	eb 38                	jmp    802372 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  80233a:	a1 48 40 80 00       	mov    0x804048,%eax
  80233f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802342:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802346:	74 07                	je     80234f <insert_sorted_allocList+0x1c8>
  802348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234b:	8b 00                	mov    (%eax),%eax
  80234d:	eb 05                	jmp    802354 <insert_sorted_allocList+0x1cd>
  80234f:	b8 00 00 00 00       	mov    $0x0,%eax
  802354:	a3 48 40 80 00       	mov    %eax,0x804048
  802359:	a1 48 40 80 00       	mov    0x804048,%eax
  80235e:	85 c0                	test   %eax,%eax
  802360:	0f 85 31 ff ff ff    	jne    802297 <insert_sorted_allocList+0x110>
  802366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80236a:	0f 85 27 ff ff ff    	jne    802297 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802370:	eb 00                	jmp    802372 <insert_sorted_allocList+0x1eb>
  802372:	90                   	nop
  802373:	c9                   	leave  
  802374:	c3                   	ret    

00802375 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802375:	55                   	push   %ebp
  802376:	89 e5                	mov    %esp,%ebp
  802378:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  80237b:	8b 45 08             	mov    0x8(%ebp),%eax
  80237e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802381:	a1 48 41 80 00       	mov    0x804148,%eax
  802386:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802389:	a1 38 41 80 00       	mov    0x804138,%eax
  80238e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802391:	e9 77 01 00 00       	jmp    80250d <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802399:	8b 40 0c             	mov    0xc(%eax),%eax
  80239c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80239f:	0f 85 8a 00 00 00    	jne    80242f <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8023a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a9:	75 17                	jne    8023c2 <alloc_block_FF+0x4d>
  8023ab:	83 ec 04             	sub    $0x4,%esp
  8023ae:	68 68 3b 80 00       	push   $0x803b68
  8023b3:	68 9e 00 00 00       	push   $0x9e
  8023b8:	68 f7 3a 80 00       	push   $0x803af7
  8023bd:	e8 0f df ff ff       	call   8002d1 <_panic>
  8023c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c5:	8b 00                	mov    (%eax),%eax
  8023c7:	85 c0                	test   %eax,%eax
  8023c9:	74 10                	je     8023db <alloc_block_FF+0x66>
  8023cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ce:	8b 00                	mov    (%eax),%eax
  8023d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d3:	8b 52 04             	mov    0x4(%edx),%edx
  8023d6:	89 50 04             	mov    %edx,0x4(%eax)
  8023d9:	eb 0b                	jmp    8023e6 <alloc_block_FF+0x71>
  8023db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023de:	8b 40 04             	mov    0x4(%eax),%eax
  8023e1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e9:	8b 40 04             	mov    0x4(%eax),%eax
  8023ec:	85 c0                	test   %eax,%eax
  8023ee:	74 0f                	je     8023ff <alloc_block_FF+0x8a>
  8023f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f3:	8b 40 04             	mov    0x4(%eax),%eax
  8023f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f9:	8b 12                	mov    (%edx),%edx
  8023fb:	89 10                	mov    %edx,(%eax)
  8023fd:	eb 0a                	jmp    802409 <alloc_block_FF+0x94>
  8023ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802402:	8b 00                	mov    (%eax),%eax
  802404:	a3 38 41 80 00       	mov    %eax,0x804138
  802409:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802415:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80241c:	a1 44 41 80 00       	mov    0x804144,%eax
  802421:	48                   	dec    %eax
  802422:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242a:	e9 11 01 00 00       	jmp    802540 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  80242f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802432:	8b 40 0c             	mov    0xc(%eax),%eax
  802435:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802438:	0f 86 c7 00 00 00    	jbe    802505 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  80243e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802442:	75 17                	jne    80245b <alloc_block_FF+0xe6>
  802444:	83 ec 04             	sub    $0x4,%esp
  802447:	68 68 3b 80 00       	push   $0x803b68
  80244c:	68 a3 00 00 00       	push   $0xa3
  802451:	68 f7 3a 80 00       	push   $0x803af7
  802456:	e8 76 de ff ff       	call   8002d1 <_panic>
  80245b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80245e:	8b 00                	mov    (%eax),%eax
  802460:	85 c0                	test   %eax,%eax
  802462:	74 10                	je     802474 <alloc_block_FF+0xff>
  802464:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802467:	8b 00                	mov    (%eax),%eax
  802469:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80246c:	8b 52 04             	mov    0x4(%edx),%edx
  80246f:	89 50 04             	mov    %edx,0x4(%eax)
  802472:	eb 0b                	jmp    80247f <alloc_block_FF+0x10a>
  802474:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802477:	8b 40 04             	mov    0x4(%eax),%eax
  80247a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80247f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802482:	8b 40 04             	mov    0x4(%eax),%eax
  802485:	85 c0                	test   %eax,%eax
  802487:	74 0f                	je     802498 <alloc_block_FF+0x123>
  802489:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80248c:	8b 40 04             	mov    0x4(%eax),%eax
  80248f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802492:	8b 12                	mov    (%edx),%edx
  802494:	89 10                	mov    %edx,(%eax)
  802496:	eb 0a                	jmp    8024a2 <alloc_block_FF+0x12d>
  802498:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80249b:	8b 00                	mov    (%eax),%eax
  80249d:	a3 48 41 80 00       	mov    %eax,0x804148
  8024a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024b5:	a1 54 41 80 00       	mov    0x804154,%eax
  8024ba:	48                   	dec    %eax
  8024bb:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8024c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024c6:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8024c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8024cf:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8024d2:	89 c2                	mov    %eax,%edx
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8024da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dd:	8b 40 08             	mov    0x8(%eax),%eax
  8024e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8024e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e6:	8b 50 08             	mov    0x8(%eax),%edx
  8024e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ef:	01 c2                	add    %eax,%edx
  8024f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f4:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8024f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024fd:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802500:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802503:	eb 3b                	jmp    802540 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802505:	a1 40 41 80 00       	mov    0x804140,%eax
  80250a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80250d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802511:	74 07                	je     80251a <alloc_block_FF+0x1a5>
  802513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802516:	8b 00                	mov    (%eax),%eax
  802518:	eb 05                	jmp    80251f <alloc_block_FF+0x1aa>
  80251a:	b8 00 00 00 00       	mov    $0x0,%eax
  80251f:	a3 40 41 80 00       	mov    %eax,0x804140
  802524:	a1 40 41 80 00       	mov    0x804140,%eax
  802529:	85 c0                	test   %eax,%eax
  80252b:	0f 85 65 fe ff ff    	jne    802396 <alloc_block_FF+0x21>
  802531:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802535:	0f 85 5b fe ff ff    	jne    802396 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  80253b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802540:	c9                   	leave  
  802541:	c3                   	ret    

00802542 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802542:	55                   	push   %ebp
  802543:	89 e5                	mov    %esp,%ebp
  802545:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802548:	8b 45 08             	mov    0x8(%ebp),%eax
  80254b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  80254e:	a1 48 41 80 00       	mov    0x804148,%eax
  802553:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802556:	a1 44 41 80 00       	mov    0x804144,%eax
  80255b:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  80255e:	a1 38 41 80 00       	mov    0x804138,%eax
  802563:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802566:	e9 a1 00 00 00       	jmp    80260c <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  80256b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256e:	8b 40 0c             	mov    0xc(%eax),%eax
  802571:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802574:	0f 85 8a 00 00 00    	jne    802604 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  80257a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257e:	75 17                	jne    802597 <alloc_block_BF+0x55>
  802580:	83 ec 04             	sub    $0x4,%esp
  802583:	68 68 3b 80 00       	push   $0x803b68
  802588:	68 c2 00 00 00       	push   $0xc2
  80258d:	68 f7 3a 80 00       	push   $0x803af7
  802592:	e8 3a dd ff ff       	call   8002d1 <_panic>
  802597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259a:	8b 00                	mov    (%eax),%eax
  80259c:	85 c0                	test   %eax,%eax
  80259e:	74 10                	je     8025b0 <alloc_block_BF+0x6e>
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	8b 00                	mov    (%eax),%eax
  8025a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a8:	8b 52 04             	mov    0x4(%edx),%edx
  8025ab:	89 50 04             	mov    %edx,0x4(%eax)
  8025ae:	eb 0b                	jmp    8025bb <alloc_block_BF+0x79>
  8025b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b3:	8b 40 04             	mov    0x4(%eax),%eax
  8025b6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025be:	8b 40 04             	mov    0x4(%eax),%eax
  8025c1:	85 c0                	test   %eax,%eax
  8025c3:	74 0f                	je     8025d4 <alloc_block_BF+0x92>
  8025c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c8:	8b 40 04             	mov    0x4(%eax),%eax
  8025cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ce:	8b 12                	mov    (%edx),%edx
  8025d0:	89 10                	mov    %edx,(%eax)
  8025d2:	eb 0a                	jmp    8025de <alloc_block_BF+0x9c>
  8025d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d7:	8b 00                	mov    (%eax),%eax
  8025d9:	a3 38 41 80 00       	mov    %eax,0x804138
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025f1:	a1 44 41 80 00       	mov    0x804144,%eax
  8025f6:	48                   	dec    %eax
  8025f7:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8025fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ff:	e9 11 02 00 00       	jmp    802815 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802604:	a1 40 41 80 00       	mov    0x804140,%eax
  802609:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80260c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802610:	74 07                	je     802619 <alloc_block_BF+0xd7>
  802612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802615:	8b 00                	mov    (%eax),%eax
  802617:	eb 05                	jmp    80261e <alloc_block_BF+0xdc>
  802619:	b8 00 00 00 00       	mov    $0x0,%eax
  80261e:	a3 40 41 80 00       	mov    %eax,0x804140
  802623:	a1 40 41 80 00       	mov    0x804140,%eax
  802628:	85 c0                	test   %eax,%eax
  80262a:	0f 85 3b ff ff ff    	jne    80256b <alloc_block_BF+0x29>
  802630:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802634:	0f 85 31 ff ff ff    	jne    80256b <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80263a:	a1 38 41 80 00       	mov    0x804138,%eax
  80263f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802642:	eb 27                	jmp    80266b <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802647:	8b 40 0c             	mov    0xc(%eax),%eax
  80264a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80264d:	76 14                	jbe    802663 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  80264f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802652:	8b 40 0c             	mov    0xc(%eax),%eax
  802655:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	8b 40 08             	mov    0x8(%eax),%eax
  80265e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802661:	eb 2e                	jmp    802691 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802663:	a1 40 41 80 00       	mov    0x804140,%eax
  802668:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266f:	74 07                	je     802678 <alloc_block_BF+0x136>
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	8b 00                	mov    (%eax),%eax
  802676:	eb 05                	jmp    80267d <alloc_block_BF+0x13b>
  802678:	b8 00 00 00 00       	mov    $0x0,%eax
  80267d:	a3 40 41 80 00       	mov    %eax,0x804140
  802682:	a1 40 41 80 00       	mov    0x804140,%eax
  802687:	85 c0                	test   %eax,%eax
  802689:	75 b9                	jne    802644 <alloc_block_BF+0x102>
  80268b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80268f:	75 b3                	jne    802644 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802691:	a1 38 41 80 00       	mov    0x804138,%eax
  802696:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802699:	eb 30                	jmp    8026cb <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  80269b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269e:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8026a4:	73 1d                	jae    8026c3 <alloc_block_BF+0x181>
  8026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ac:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8026af:	76 12                	jbe    8026c3 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  8026b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	8b 40 08             	mov    0x8(%eax),%eax
  8026c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026c3:	a1 40 41 80 00       	mov    0x804140,%eax
  8026c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026cf:	74 07                	je     8026d8 <alloc_block_BF+0x196>
  8026d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d4:	8b 00                	mov    (%eax),%eax
  8026d6:	eb 05                	jmp    8026dd <alloc_block_BF+0x19b>
  8026d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8026dd:	a3 40 41 80 00       	mov    %eax,0x804140
  8026e2:	a1 40 41 80 00       	mov    0x804140,%eax
  8026e7:	85 c0                	test   %eax,%eax
  8026e9:	75 b0                	jne    80269b <alloc_block_BF+0x159>
  8026eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ef:	75 aa                	jne    80269b <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026f1:	a1 38 41 80 00       	mov    0x804138,%eax
  8026f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f9:	e9 e4 00 00 00       	jmp    8027e2 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	8b 40 0c             	mov    0xc(%eax),%eax
  802704:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802707:	0f 85 cd 00 00 00    	jne    8027da <alloc_block_BF+0x298>
  80270d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802710:	8b 40 08             	mov    0x8(%eax),%eax
  802713:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802716:	0f 85 be 00 00 00    	jne    8027da <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  80271c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802720:	75 17                	jne    802739 <alloc_block_BF+0x1f7>
  802722:	83 ec 04             	sub    $0x4,%esp
  802725:	68 68 3b 80 00       	push   $0x803b68
  80272a:	68 db 00 00 00       	push   $0xdb
  80272f:	68 f7 3a 80 00       	push   $0x803af7
  802734:	e8 98 db ff ff       	call   8002d1 <_panic>
  802739:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80273c:	8b 00                	mov    (%eax),%eax
  80273e:	85 c0                	test   %eax,%eax
  802740:	74 10                	je     802752 <alloc_block_BF+0x210>
  802742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802745:	8b 00                	mov    (%eax),%eax
  802747:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80274a:	8b 52 04             	mov    0x4(%edx),%edx
  80274d:	89 50 04             	mov    %edx,0x4(%eax)
  802750:	eb 0b                	jmp    80275d <alloc_block_BF+0x21b>
  802752:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802755:	8b 40 04             	mov    0x4(%eax),%eax
  802758:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80275d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802760:	8b 40 04             	mov    0x4(%eax),%eax
  802763:	85 c0                	test   %eax,%eax
  802765:	74 0f                	je     802776 <alloc_block_BF+0x234>
  802767:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80276a:	8b 40 04             	mov    0x4(%eax),%eax
  80276d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802770:	8b 12                	mov    (%edx),%edx
  802772:	89 10                	mov    %edx,(%eax)
  802774:	eb 0a                	jmp    802780 <alloc_block_BF+0x23e>
  802776:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802779:	8b 00                	mov    (%eax),%eax
  80277b:	a3 48 41 80 00       	mov    %eax,0x804148
  802780:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802783:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802789:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80278c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802793:	a1 54 41 80 00       	mov    0x804154,%eax
  802798:	48                   	dec    %eax
  802799:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  80279e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027a4:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  8027a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027ad:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  8027b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b6:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8027b9:	89 c2                	mov    %eax,%edx
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 50 08             	mov    0x8(%eax),%edx
  8027c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8027cd:	01 c2                	add    %eax,%edx
  8027cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d2:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8027d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d8:	eb 3b                	jmp    802815 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027da:	a1 40 41 80 00       	mov    0x804140,%eax
  8027df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e6:	74 07                	je     8027ef <alloc_block_BF+0x2ad>
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	8b 00                	mov    (%eax),%eax
  8027ed:	eb 05                	jmp    8027f4 <alloc_block_BF+0x2b2>
  8027ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f4:	a3 40 41 80 00       	mov    %eax,0x804140
  8027f9:	a1 40 41 80 00       	mov    0x804140,%eax
  8027fe:	85 c0                	test   %eax,%eax
  802800:	0f 85 f8 fe ff ff    	jne    8026fe <alloc_block_BF+0x1bc>
  802806:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280a:	0f 85 ee fe ff ff    	jne    8026fe <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802810:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802815:	c9                   	leave  
  802816:	c3                   	ret    

00802817 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802817:	55                   	push   %ebp
  802818:	89 e5                	mov    %esp,%ebp
  80281a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  80281d:	8b 45 08             	mov    0x8(%ebp),%eax
  802820:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802823:	a1 48 41 80 00       	mov    0x804148,%eax
  802828:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80282b:	a1 38 41 80 00       	mov    0x804138,%eax
  802830:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802833:	e9 77 01 00 00       	jmp    8029af <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802838:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283b:	8b 40 0c             	mov    0xc(%eax),%eax
  80283e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802841:	0f 85 8a 00 00 00    	jne    8028d1 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802847:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284b:	75 17                	jne    802864 <alloc_block_NF+0x4d>
  80284d:	83 ec 04             	sub    $0x4,%esp
  802850:	68 68 3b 80 00       	push   $0x803b68
  802855:	68 f7 00 00 00       	push   $0xf7
  80285a:	68 f7 3a 80 00       	push   $0x803af7
  80285f:	e8 6d da ff ff       	call   8002d1 <_panic>
  802864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802867:	8b 00                	mov    (%eax),%eax
  802869:	85 c0                	test   %eax,%eax
  80286b:	74 10                	je     80287d <alloc_block_NF+0x66>
  80286d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802870:	8b 00                	mov    (%eax),%eax
  802872:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802875:	8b 52 04             	mov    0x4(%edx),%edx
  802878:	89 50 04             	mov    %edx,0x4(%eax)
  80287b:	eb 0b                	jmp    802888 <alloc_block_NF+0x71>
  80287d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802880:	8b 40 04             	mov    0x4(%eax),%eax
  802883:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	8b 40 04             	mov    0x4(%eax),%eax
  80288e:	85 c0                	test   %eax,%eax
  802890:	74 0f                	je     8028a1 <alloc_block_NF+0x8a>
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	8b 40 04             	mov    0x4(%eax),%eax
  802898:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80289b:	8b 12                	mov    (%edx),%edx
  80289d:	89 10                	mov    %edx,(%eax)
  80289f:	eb 0a                	jmp    8028ab <alloc_block_NF+0x94>
  8028a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a4:	8b 00                	mov    (%eax),%eax
  8028a6:	a3 38 41 80 00       	mov    %eax,0x804138
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028be:	a1 44 41 80 00       	mov    0x804144,%eax
  8028c3:	48                   	dec    %eax
  8028c4:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	e9 11 01 00 00       	jmp    8029e2 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028da:	0f 86 c7 00 00 00    	jbe    8029a7 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8028e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028e4:	75 17                	jne    8028fd <alloc_block_NF+0xe6>
  8028e6:	83 ec 04             	sub    $0x4,%esp
  8028e9:	68 68 3b 80 00       	push   $0x803b68
  8028ee:	68 fc 00 00 00       	push   $0xfc
  8028f3:	68 f7 3a 80 00       	push   $0x803af7
  8028f8:	e8 d4 d9 ff ff       	call   8002d1 <_panic>
  8028fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802900:	8b 00                	mov    (%eax),%eax
  802902:	85 c0                	test   %eax,%eax
  802904:	74 10                	je     802916 <alloc_block_NF+0xff>
  802906:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802909:	8b 00                	mov    (%eax),%eax
  80290b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80290e:	8b 52 04             	mov    0x4(%edx),%edx
  802911:	89 50 04             	mov    %edx,0x4(%eax)
  802914:	eb 0b                	jmp    802921 <alloc_block_NF+0x10a>
  802916:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802919:	8b 40 04             	mov    0x4(%eax),%eax
  80291c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802921:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802924:	8b 40 04             	mov    0x4(%eax),%eax
  802927:	85 c0                	test   %eax,%eax
  802929:	74 0f                	je     80293a <alloc_block_NF+0x123>
  80292b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292e:	8b 40 04             	mov    0x4(%eax),%eax
  802931:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802934:	8b 12                	mov    (%edx),%edx
  802936:	89 10                	mov    %edx,(%eax)
  802938:	eb 0a                	jmp    802944 <alloc_block_NF+0x12d>
  80293a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293d:	8b 00                	mov    (%eax),%eax
  80293f:	a3 48 41 80 00       	mov    %eax,0x804148
  802944:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802947:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80294d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802950:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802957:	a1 54 41 80 00       	mov    0x804154,%eax
  80295c:	48                   	dec    %eax
  80295d:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802962:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802965:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802968:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  80296b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296e:	8b 40 0c             	mov    0xc(%eax),%eax
  802971:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802974:	89 c2                	mov    %eax,%edx
  802976:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802979:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  80297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297f:	8b 40 08             	mov    0x8(%eax),%eax
  802982:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802988:	8b 50 08             	mov    0x8(%eax),%edx
  80298b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298e:	8b 40 0c             	mov    0xc(%eax),%eax
  802991:	01 c2                	add    %eax,%edx
  802993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802996:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802999:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80299f:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8029a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a5:	eb 3b                	jmp    8029e2 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8029a7:	a1 40 41 80 00       	mov    0x804140,%eax
  8029ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b3:	74 07                	je     8029bc <alloc_block_NF+0x1a5>
  8029b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b8:	8b 00                	mov    (%eax),%eax
  8029ba:	eb 05                	jmp    8029c1 <alloc_block_NF+0x1aa>
  8029bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c1:	a3 40 41 80 00       	mov    %eax,0x804140
  8029c6:	a1 40 41 80 00       	mov    0x804140,%eax
  8029cb:	85 c0                	test   %eax,%eax
  8029cd:	0f 85 65 fe ff ff    	jne    802838 <alloc_block_NF+0x21>
  8029d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d7:	0f 85 5b fe ff ff    	jne    802838 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8029dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029e2:	c9                   	leave  
  8029e3:	c3                   	ret    

008029e4 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  8029e4:	55                   	push   %ebp
  8029e5:	89 e5                	mov    %esp,%ebp
  8029e7:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  8029ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ed:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  8029f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  8029fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a02:	75 17                	jne    802a1b <addToAvailMemBlocksList+0x37>
  802a04:	83 ec 04             	sub    $0x4,%esp
  802a07:	68 10 3b 80 00       	push   $0x803b10
  802a0c:	68 10 01 00 00       	push   $0x110
  802a11:	68 f7 3a 80 00       	push   $0x803af7
  802a16:	e8 b6 d8 ff ff       	call   8002d1 <_panic>
  802a1b:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802a21:	8b 45 08             	mov    0x8(%ebp),%eax
  802a24:	89 50 04             	mov    %edx,0x4(%eax)
  802a27:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2a:	8b 40 04             	mov    0x4(%eax),%eax
  802a2d:	85 c0                	test   %eax,%eax
  802a2f:	74 0c                	je     802a3d <addToAvailMemBlocksList+0x59>
  802a31:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802a36:	8b 55 08             	mov    0x8(%ebp),%edx
  802a39:	89 10                	mov    %edx,(%eax)
  802a3b:	eb 08                	jmp    802a45 <addToAvailMemBlocksList+0x61>
  802a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a40:	a3 48 41 80 00       	mov    %eax,0x804148
  802a45:	8b 45 08             	mov    0x8(%ebp),%eax
  802a48:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a56:	a1 54 41 80 00       	mov    0x804154,%eax
  802a5b:	40                   	inc    %eax
  802a5c:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802a61:	90                   	nop
  802a62:	c9                   	leave  
  802a63:	c3                   	ret    

00802a64 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a64:	55                   	push   %ebp
  802a65:	89 e5                	mov    %esp,%ebp
  802a67:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802a6a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802a72:	a1 44 41 80 00       	mov    0x804144,%eax
  802a77:	85 c0                	test   %eax,%eax
  802a79:	75 68                	jne    802ae3 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802a7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a7f:	75 17                	jne    802a98 <insert_sorted_with_merge_freeList+0x34>
  802a81:	83 ec 04             	sub    $0x4,%esp
  802a84:	68 d4 3a 80 00       	push   $0x803ad4
  802a89:	68 1a 01 00 00       	push   $0x11a
  802a8e:	68 f7 3a 80 00       	push   $0x803af7
  802a93:	e8 39 d8 ff ff       	call   8002d1 <_panic>
  802a98:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa1:	89 10                	mov    %edx,(%eax)
  802aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa6:	8b 00                	mov    (%eax),%eax
  802aa8:	85 c0                	test   %eax,%eax
  802aaa:	74 0d                	je     802ab9 <insert_sorted_with_merge_freeList+0x55>
  802aac:	a1 38 41 80 00       	mov    0x804138,%eax
  802ab1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab4:	89 50 04             	mov    %edx,0x4(%eax)
  802ab7:	eb 08                	jmp    802ac1 <insert_sorted_with_merge_freeList+0x5d>
  802ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  802abc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac4:	a3 38 41 80 00       	mov    %eax,0x804138
  802ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  802acc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad3:	a1 44 41 80 00       	mov    0x804144,%eax
  802ad8:	40                   	inc    %eax
  802ad9:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ade:	e9 c5 03 00 00       	jmp    802ea8 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802ae3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae6:	8b 50 08             	mov    0x8(%eax),%edx
  802ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aec:	8b 40 08             	mov    0x8(%eax),%eax
  802aef:	39 c2                	cmp    %eax,%edx
  802af1:	0f 83 b2 00 00 00    	jae    802ba9 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afa:	8b 50 08             	mov    0x8(%eax),%edx
  802afd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b00:	8b 40 0c             	mov    0xc(%eax),%eax
  802b03:	01 c2                	add    %eax,%edx
  802b05:	8b 45 08             	mov    0x8(%ebp),%eax
  802b08:	8b 40 08             	mov    0x8(%eax),%eax
  802b0b:	39 c2                	cmp    %eax,%edx
  802b0d:	75 27                	jne    802b36 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802b0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b12:	8b 50 0c             	mov    0xc(%eax),%edx
  802b15:	8b 45 08             	mov    0x8(%ebp),%eax
  802b18:	8b 40 0c             	mov    0xc(%eax),%eax
  802b1b:	01 c2                	add    %eax,%edx
  802b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b20:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802b23:	83 ec 0c             	sub    $0xc,%esp
  802b26:	ff 75 08             	pushl  0x8(%ebp)
  802b29:	e8 b6 fe ff ff       	call   8029e4 <addToAvailMemBlocksList>
  802b2e:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802b31:	e9 72 03 00 00       	jmp    802ea8 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802b36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b3a:	74 06                	je     802b42 <insert_sorted_with_merge_freeList+0xde>
  802b3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b40:	75 17                	jne    802b59 <insert_sorted_with_merge_freeList+0xf5>
  802b42:	83 ec 04             	sub    $0x4,%esp
  802b45:	68 34 3b 80 00       	push   $0x803b34
  802b4a:	68 24 01 00 00       	push   $0x124
  802b4f:	68 f7 3a 80 00       	push   $0x803af7
  802b54:	e8 78 d7 ff ff       	call   8002d1 <_panic>
  802b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5c:	8b 10                	mov    (%eax),%edx
  802b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b61:	89 10                	mov    %edx,(%eax)
  802b63:	8b 45 08             	mov    0x8(%ebp),%eax
  802b66:	8b 00                	mov    (%eax),%eax
  802b68:	85 c0                	test   %eax,%eax
  802b6a:	74 0b                	je     802b77 <insert_sorted_with_merge_freeList+0x113>
  802b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6f:	8b 00                	mov    (%eax),%eax
  802b71:	8b 55 08             	mov    0x8(%ebp),%edx
  802b74:	89 50 04             	mov    %edx,0x4(%eax)
  802b77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b7d:	89 10                	mov    %edx,(%eax)
  802b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b82:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b85:	89 50 04             	mov    %edx,0x4(%eax)
  802b88:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8b:	8b 00                	mov    (%eax),%eax
  802b8d:	85 c0                	test   %eax,%eax
  802b8f:	75 08                	jne    802b99 <insert_sorted_with_merge_freeList+0x135>
  802b91:	8b 45 08             	mov    0x8(%ebp),%eax
  802b94:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b99:	a1 44 41 80 00       	mov    0x804144,%eax
  802b9e:	40                   	inc    %eax
  802b9f:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ba4:	e9 ff 02 00 00       	jmp    802ea8 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802ba9:	a1 38 41 80 00       	mov    0x804138,%eax
  802bae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bb1:	e9 c2 02 00 00       	jmp    802e78 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb9:	8b 50 08             	mov    0x8(%eax),%edx
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	8b 40 08             	mov    0x8(%eax),%eax
  802bc2:	39 c2                	cmp    %eax,%edx
  802bc4:	0f 86 a6 02 00 00    	jbe    802e70 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcd:	8b 40 04             	mov    0x4(%eax),%eax
  802bd0:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802bd3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bd7:	0f 85 ba 00 00 00    	jne    802c97 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802be0:	8b 50 0c             	mov    0xc(%eax),%edx
  802be3:	8b 45 08             	mov    0x8(%ebp),%eax
  802be6:	8b 40 08             	mov    0x8(%eax),%eax
  802be9:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bee:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802bf1:	39 c2                	cmp    %eax,%edx
  802bf3:	75 33                	jne    802c28 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf8:	8b 50 08             	mov    0x8(%eax),%edx
  802bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfe:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c04:	8b 50 0c             	mov    0xc(%eax),%edx
  802c07:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0d:	01 c2                	add    %eax,%edx
  802c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c12:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802c15:	83 ec 0c             	sub    $0xc,%esp
  802c18:	ff 75 08             	pushl  0x8(%ebp)
  802c1b:	e8 c4 fd ff ff       	call   8029e4 <addToAvailMemBlocksList>
  802c20:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802c23:	e9 80 02 00 00       	jmp    802ea8 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802c28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c2c:	74 06                	je     802c34 <insert_sorted_with_merge_freeList+0x1d0>
  802c2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c32:	75 17                	jne    802c4b <insert_sorted_with_merge_freeList+0x1e7>
  802c34:	83 ec 04             	sub    $0x4,%esp
  802c37:	68 88 3b 80 00       	push   $0x803b88
  802c3c:	68 3a 01 00 00       	push   $0x13a
  802c41:	68 f7 3a 80 00       	push   $0x803af7
  802c46:	e8 86 d6 ff ff       	call   8002d1 <_panic>
  802c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4e:	8b 50 04             	mov    0x4(%eax),%edx
  802c51:	8b 45 08             	mov    0x8(%ebp),%eax
  802c54:	89 50 04             	mov    %edx,0x4(%eax)
  802c57:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c5d:	89 10                	mov    %edx,(%eax)
  802c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c62:	8b 40 04             	mov    0x4(%eax),%eax
  802c65:	85 c0                	test   %eax,%eax
  802c67:	74 0d                	je     802c76 <insert_sorted_with_merge_freeList+0x212>
  802c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6c:	8b 40 04             	mov    0x4(%eax),%eax
  802c6f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c72:	89 10                	mov    %edx,(%eax)
  802c74:	eb 08                	jmp    802c7e <insert_sorted_with_merge_freeList+0x21a>
  802c76:	8b 45 08             	mov    0x8(%ebp),%eax
  802c79:	a3 38 41 80 00       	mov    %eax,0x804138
  802c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c81:	8b 55 08             	mov    0x8(%ebp),%edx
  802c84:	89 50 04             	mov    %edx,0x4(%eax)
  802c87:	a1 44 41 80 00       	mov    0x804144,%eax
  802c8c:	40                   	inc    %eax
  802c8d:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802c92:	e9 11 02 00 00       	jmp    802ea8 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802c97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9a:	8b 50 08             	mov    0x8(%eax),%edx
  802c9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca3:	01 c2                	add    %eax,%edx
  802ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca8:	8b 40 0c             	mov    0xc(%eax),%eax
  802cab:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb0:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802cb3:	39 c2                	cmp    %eax,%edx
  802cb5:	0f 85 bf 00 00 00    	jne    802d7a <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802cbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbe:	8b 50 0c             	mov    0xc(%eax),%edx
  802cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc7:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccc:	8b 40 0c             	mov    0xc(%eax),%eax
  802ccf:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802cd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd4:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802cd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cdb:	75 17                	jne    802cf4 <insert_sorted_with_merge_freeList+0x290>
  802cdd:	83 ec 04             	sub    $0x4,%esp
  802ce0:	68 68 3b 80 00       	push   $0x803b68
  802ce5:	68 43 01 00 00       	push   $0x143
  802cea:	68 f7 3a 80 00       	push   $0x803af7
  802cef:	e8 dd d5 ff ff       	call   8002d1 <_panic>
  802cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf7:	8b 00                	mov    (%eax),%eax
  802cf9:	85 c0                	test   %eax,%eax
  802cfb:	74 10                	je     802d0d <insert_sorted_with_merge_freeList+0x2a9>
  802cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d00:	8b 00                	mov    (%eax),%eax
  802d02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d05:	8b 52 04             	mov    0x4(%edx),%edx
  802d08:	89 50 04             	mov    %edx,0x4(%eax)
  802d0b:	eb 0b                	jmp    802d18 <insert_sorted_with_merge_freeList+0x2b4>
  802d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d10:	8b 40 04             	mov    0x4(%eax),%eax
  802d13:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1b:	8b 40 04             	mov    0x4(%eax),%eax
  802d1e:	85 c0                	test   %eax,%eax
  802d20:	74 0f                	je     802d31 <insert_sorted_with_merge_freeList+0x2cd>
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	8b 40 04             	mov    0x4(%eax),%eax
  802d28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d2b:	8b 12                	mov    (%edx),%edx
  802d2d:	89 10                	mov    %edx,(%eax)
  802d2f:	eb 0a                	jmp    802d3b <insert_sorted_with_merge_freeList+0x2d7>
  802d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d34:	8b 00                	mov    (%eax),%eax
  802d36:	a3 38 41 80 00       	mov    %eax,0x804138
  802d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d4e:	a1 44 41 80 00       	mov    0x804144,%eax
  802d53:	48                   	dec    %eax
  802d54:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802d59:	83 ec 0c             	sub    $0xc,%esp
  802d5c:	ff 75 08             	pushl  0x8(%ebp)
  802d5f:	e8 80 fc ff ff       	call   8029e4 <addToAvailMemBlocksList>
  802d64:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802d67:	83 ec 0c             	sub    $0xc,%esp
  802d6a:	ff 75 f4             	pushl  -0xc(%ebp)
  802d6d:	e8 72 fc ff ff       	call   8029e4 <addToAvailMemBlocksList>
  802d72:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802d75:	e9 2e 01 00 00       	jmp    802ea8 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802d7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7d:	8b 50 08             	mov    0x8(%eax),%edx
  802d80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d83:	8b 40 0c             	mov    0xc(%eax),%eax
  802d86:	01 c2                	add    %eax,%edx
  802d88:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8b:	8b 40 08             	mov    0x8(%eax),%eax
  802d8e:	39 c2                	cmp    %eax,%edx
  802d90:	75 27                	jne    802db9 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802d92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d95:	8b 50 0c             	mov    0xc(%eax),%edx
  802d98:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9e:	01 c2                	add    %eax,%edx
  802da0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da3:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802da6:	83 ec 0c             	sub    $0xc,%esp
  802da9:	ff 75 08             	pushl  0x8(%ebp)
  802dac:	e8 33 fc ff ff       	call   8029e4 <addToAvailMemBlocksList>
  802db1:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802db4:	e9 ef 00 00 00       	jmp    802ea8 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802db9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbc:	8b 50 0c             	mov    0xc(%eax),%edx
  802dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc2:	8b 40 08             	mov    0x8(%eax),%eax
  802dc5:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dca:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802dcd:	39 c2                	cmp    %eax,%edx
  802dcf:	75 33                	jne    802e04 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd4:	8b 50 08             	mov    0x8(%eax),%edx
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de0:	8b 50 0c             	mov    0xc(%eax),%edx
  802de3:	8b 45 08             	mov    0x8(%ebp),%eax
  802de6:	8b 40 0c             	mov    0xc(%eax),%eax
  802de9:	01 c2                	add    %eax,%edx
  802deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dee:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802df1:	83 ec 0c             	sub    $0xc,%esp
  802df4:	ff 75 08             	pushl  0x8(%ebp)
  802df7:	e8 e8 fb ff ff       	call   8029e4 <addToAvailMemBlocksList>
  802dfc:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802dff:	e9 a4 00 00 00       	jmp    802ea8 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802e04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e08:	74 06                	je     802e10 <insert_sorted_with_merge_freeList+0x3ac>
  802e0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e0e:	75 17                	jne    802e27 <insert_sorted_with_merge_freeList+0x3c3>
  802e10:	83 ec 04             	sub    $0x4,%esp
  802e13:	68 88 3b 80 00       	push   $0x803b88
  802e18:	68 56 01 00 00       	push   $0x156
  802e1d:	68 f7 3a 80 00       	push   $0x803af7
  802e22:	e8 aa d4 ff ff       	call   8002d1 <_panic>
  802e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2a:	8b 50 04             	mov    0x4(%eax),%edx
  802e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e30:	89 50 04             	mov    %edx,0x4(%eax)
  802e33:	8b 45 08             	mov    0x8(%ebp),%eax
  802e36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e39:	89 10                	mov    %edx,(%eax)
  802e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3e:	8b 40 04             	mov    0x4(%eax),%eax
  802e41:	85 c0                	test   %eax,%eax
  802e43:	74 0d                	je     802e52 <insert_sorted_with_merge_freeList+0x3ee>
  802e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e48:	8b 40 04             	mov    0x4(%eax),%eax
  802e4b:	8b 55 08             	mov    0x8(%ebp),%edx
  802e4e:	89 10                	mov    %edx,(%eax)
  802e50:	eb 08                	jmp    802e5a <insert_sorted_with_merge_freeList+0x3f6>
  802e52:	8b 45 08             	mov    0x8(%ebp),%eax
  802e55:	a3 38 41 80 00       	mov    %eax,0x804138
  802e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5d:	8b 55 08             	mov    0x8(%ebp),%edx
  802e60:	89 50 04             	mov    %edx,0x4(%eax)
  802e63:	a1 44 41 80 00       	mov    0x804144,%eax
  802e68:	40                   	inc    %eax
  802e69:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802e6e:	eb 38                	jmp    802ea8 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802e70:	a1 40 41 80 00       	mov    0x804140,%eax
  802e75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e7c:	74 07                	je     802e85 <insert_sorted_with_merge_freeList+0x421>
  802e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e81:	8b 00                	mov    (%eax),%eax
  802e83:	eb 05                	jmp    802e8a <insert_sorted_with_merge_freeList+0x426>
  802e85:	b8 00 00 00 00       	mov    $0x0,%eax
  802e8a:	a3 40 41 80 00       	mov    %eax,0x804140
  802e8f:	a1 40 41 80 00       	mov    0x804140,%eax
  802e94:	85 c0                	test   %eax,%eax
  802e96:	0f 85 1a fd ff ff    	jne    802bb6 <insert_sorted_with_merge_freeList+0x152>
  802e9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea0:	0f 85 10 fd ff ff    	jne    802bb6 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ea6:	eb 00                	jmp    802ea8 <insert_sorted_with_merge_freeList+0x444>
  802ea8:	90                   	nop
  802ea9:	c9                   	leave  
  802eaa:	c3                   	ret    

00802eab <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802eab:	55                   	push   %ebp
  802eac:	89 e5                	mov    %esp,%ebp
  802eae:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802eb1:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb4:	89 d0                	mov    %edx,%eax
  802eb6:	c1 e0 02             	shl    $0x2,%eax
  802eb9:	01 d0                	add    %edx,%eax
  802ebb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ec2:	01 d0                	add    %edx,%eax
  802ec4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ecb:	01 d0                	add    %edx,%eax
  802ecd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ed4:	01 d0                	add    %edx,%eax
  802ed6:	c1 e0 04             	shl    $0x4,%eax
  802ed9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802edc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802ee3:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802ee6:	83 ec 0c             	sub    $0xc,%esp
  802ee9:	50                   	push   %eax
  802eea:	e8 60 ed ff ff       	call   801c4f <sys_get_virtual_time>
  802eef:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802ef2:	eb 41                	jmp    802f35 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802ef4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802ef7:	83 ec 0c             	sub    $0xc,%esp
  802efa:	50                   	push   %eax
  802efb:	e8 4f ed ff ff       	call   801c4f <sys_get_virtual_time>
  802f00:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802f03:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f09:	29 c2                	sub    %eax,%edx
  802f0b:	89 d0                	mov    %edx,%eax
  802f0d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802f10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f16:	89 d1                	mov    %edx,%ecx
  802f18:	29 c1                	sub    %eax,%ecx
  802f1a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802f1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f20:	39 c2                	cmp    %eax,%edx
  802f22:	0f 97 c0             	seta   %al
  802f25:	0f b6 c0             	movzbl %al,%eax
  802f28:	29 c1                	sub    %eax,%ecx
  802f2a:	89 c8                	mov    %ecx,%eax
  802f2c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802f2f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f32:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f38:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f3b:	72 b7                	jb     802ef4 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802f3d:	90                   	nop
  802f3e:	c9                   	leave  
  802f3f:	c3                   	ret    

00802f40 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802f40:	55                   	push   %ebp
  802f41:	89 e5                	mov    %esp,%ebp
  802f43:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802f46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802f4d:	eb 03                	jmp    802f52 <busy_wait+0x12>
  802f4f:	ff 45 fc             	incl   -0x4(%ebp)
  802f52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f55:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f58:	72 f5                	jb     802f4f <busy_wait+0xf>
	return i;
  802f5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802f5d:	c9                   	leave  
  802f5e:	c3                   	ret    
  802f5f:	90                   	nop

00802f60 <__udivdi3>:
  802f60:	55                   	push   %ebp
  802f61:	57                   	push   %edi
  802f62:	56                   	push   %esi
  802f63:	53                   	push   %ebx
  802f64:	83 ec 1c             	sub    $0x1c,%esp
  802f67:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802f6b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802f6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802f73:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f77:	89 ca                	mov    %ecx,%edx
  802f79:	89 f8                	mov    %edi,%eax
  802f7b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802f7f:	85 f6                	test   %esi,%esi
  802f81:	75 2d                	jne    802fb0 <__udivdi3+0x50>
  802f83:	39 cf                	cmp    %ecx,%edi
  802f85:	77 65                	ja     802fec <__udivdi3+0x8c>
  802f87:	89 fd                	mov    %edi,%ebp
  802f89:	85 ff                	test   %edi,%edi
  802f8b:	75 0b                	jne    802f98 <__udivdi3+0x38>
  802f8d:	b8 01 00 00 00       	mov    $0x1,%eax
  802f92:	31 d2                	xor    %edx,%edx
  802f94:	f7 f7                	div    %edi
  802f96:	89 c5                	mov    %eax,%ebp
  802f98:	31 d2                	xor    %edx,%edx
  802f9a:	89 c8                	mov    %ecx,%eax
  802f9c:	f7 f5                	div    %ebp
  802f9e:	89 c1                	mov    %eax,%ecx
  802fa0:	89 d8                	mov    %ebx,%eax
  802fa2:	f7 f5                	div    %ebp
  802fa4:	89 cf                	mov    %ecx,%edi
  802fa6:	89 fa                	mov    %edi,%edx
  802fa8:	83 c4 1c             	add    $0x1c,%esp
  802fab:	5b                   	pop    %ebx
  802fac:	5e                   	pop    %esi
  802fad:	5f                   	pop    %edi
  802fae:	5d                   	pop    %ebp
  802faf:	c3                   	ret    
  802fb0:	39 ce                	cmp    %ecx,%esi
  802fb2:	77 28                	ja     802fdc <__udivdi3+0x7c>
  802fb4:	0f bd fe             	bsr    %esi,%edi
  802fb7:	83 f7 1f             	xor    $0x1f,%edi
  802fba:	75 40                	jne    802ffc <__udivdi3+0x9c>
  802fbc:	39 ce                	cmp    %ecx,%esi
  802fbe:	72 0a                	jb     802fca <__udivdi3+0x6a>
  802fc0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802fc4:	0f 87 9e 00 00 00    	ja     803068 <__udivdi3+0x108>
  802fca:	b8 01 00 00 00       	mov    $0x1,%eax
  802fcf:	89 fa                	mov    %edi,%edx
  802fd1:	83 c4 1c             	add    $0x1c,%esp
  802fd4:	5b                   	pop    %ebx
  802fd5:	5e                   	pop    %esi
  802fd6:	5f                   	pop    %edi
  802fd7:	5d                   	pop    %ebp
  802fd8:	c3                   	ret    
  802fd9:	8d 76 00             	lea    0x0(%esi),%esi
  802fdc:	31 ff                	xor    %edi,%edi
  802fde:	31 c0                	xor    %eax,%eax
  802fe0:	89 fa                	mov    %edi,%edx
  802fe2:	83 c4 1c             	add    $0x1c,%esp
  802fe5:	5b                   	pop    %ebx
  802fe6:	5e                   	pop    %esi
  802fe7:	5f                   	pop    %edi
  802fe8:	5d                   	pop    %ebp
  802fe9:	c3                   	ret    
  802fea:	66 90                	xchg   %ax,%ax
  802fec:	89 d8                	mov    %ebx,%eax
  802fee:	f7 f7                	div    %edi
  802ff0:	31 ff                	xor    %edi,%edi
  802ff2:	89 fa                	mov    %edi,%edx
  802ff4:	83 c4 1c             	add    $0x1c,%esp
  802ff7:	5b                   	pop    %ebx
  802ff8:	5e                   	pop    %esi
  802ff9:	5f                   	pop    %edi
  802ffa:	5d                   	pop    %ebp
  802ffb:	c3                   	ret    
  802ffc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803001:	89 eb                	mov    %ebp,%ebx
  803003:	29 fb                	sub    %edi,%ebx
  803005:	89 f9                	mov    %edi,%ecx
  803007:	d3 e6                	shl    %cl,%esi
  803009:	89 c5                	mov    %eax,%ebp
  80300b:	88 d9                	mov    %bl,%cl
  80300d:	d3 ed                	shr    %cl,%ebp
  80300f:	89 e9                	mov    %ebp,%ecx
  803011:	09 f1                	or     %esi,%ecx
  803013:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803017:	89 f9                	mov    %edi,%ecx
  803019:	d3 e0                	shl    %cl,%eax
  80301b:	89 c5                	mov    %eax,%ebp
  80301d:	89 d6                	mov    %edx,%esi
  80301f:	88 d9                	mov    %bl,%cl
  803021:	d3 ee                	shr    %cl,%esi
  803023:	89 f9                	mov    %edi,%ecx
  803025:	d3 e2                	shl    %cl,%edx
  803027:	8b 44 24 08          	mov    0x8(%esp),%eax
  80302b:	88 d9                	mov    %bl,%cl
  80302d:	d3 e8                	shr    %cl,%eax
  80302f:	09 c2                	or     %eax,%edx
  803031:	89 d0                	mov    %edx,%eax
  803033:	89 f2                	mov    %esi,%edx
  803035:	f7 74 24 0c          	divl   0xc(%esp)
  803039:	89 d6                	mov    %edx,%esi
  80303b:	89 c3                	mov    %eax,%ebx
  80303d:	f7 e5                	mul    %ebp
  80303f:	39 d6                	cmp    %edx,%esi
  803041:	72 19                	jb     80305c <__udivdi3+0xfc>
  803043:	74 0b                	je     803050 <__udivdi3+0xf0>
  803045:	89 d8                	mov    %ebx,%eax
  803047:	31 ff                	xor    %edi,%edi
  803049:	e9 58 ff ff ff       	jmp    802fa6 <__udivdi3+0x46>
  80304e:	66 90                	xchg   %ax,%ax
  803050:	8b 54 24 08          	mov    0x8(%esp),%edx
  803054:	89 f9                	mov    %edi,%ecx
  803056:	d3 e2                	shl    %cl,%edx
  803058:	39 c2                	cmp    %eax,%edx
  80305a:	73 e9                	jae    803045 <__udivdi3+0xe5>
  80305c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80305f:	31 ff                	xor    %edi,%edi
  803061:	e9 40 ff ff ff       	jmp    802fa6 <__udivdi3+0x46>
  803066:	66 90                	xchg   %ax,%ax
  803068:	31 c0                	xor    %eax,%eax
  80306a:	e9 37 ff ff ff       	jmp    802fa6 <__udivdi3+0x46>
  80306f:	90                   	nop

00803070 <__umoddi3>:
  803070:	55                   	push   %ebp
  803071:	57                   	push   %edi
  803072:	56                   	push   %esi
  803073:	53                   	push   %ebx
  803074:	83 ec 1c             	sub    $0x1c,%esp
  803077:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80307b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80307f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803083:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803087:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80308b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80308f:	89 f3                	mov    %esi,%ebx
  803091:	89 fa                	mov    %edi,%edx
  803093:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803097:	89 34 24             	mov    %esi,(%esp)
  80309a:	85 c0                	test   %eax,%eax
  80309c:	75 1a                	jne    8030b8 <__umoddi3+0x48>
  80309e:	39 f7                	cmp    %esi,%edi
  8030a0:	0f 86 a2 00 00 00    	jbe    803148 <__umoddi3+0xd8>
  8030a6:	89 c8                	mov    %ecx,%eax
  8030a8:	89 f2                	mov    %esi,%edx
  8030aa:	f7 f7                	div    %edi
  8030ac:	89 d0                	mov    %edx,%eax
  8030ae:	31 d2                	xor    %edx,%edx
  8030b0:	83 c4 1c             	add    $0x1c,%esp
  8030b3:	5b                   	pop    %ebx
  8030b4:	5e                   	pop    %esi
  8030b5:	5f                   	pop    %edi
  8030b6:	5d                   	pop    %ebp
  8030b7:	c3                   	ret    
  8030b8:	39 f0                	cmp    %esi,%eax
  8030ba:	0f 87 ac 00 00 00    	ja     80316c <__umoddi3+0xfc>
  8030c0:	0f bd e8             	bsr    %eax,%ebp
  8030c3:	83 f5 1f             	xor    $0x1f,%ebp
  8030c6:	0f 84 ac 00 00 00    	je     803178 <__umoddi3+0x108>
  8030cc:	bf 20 00 00 00       	mov    $0x20,%edi
  8030d1:	29 ef                	sub    %ebp,%edi
  8030d3:	89 fe                	mov    %edi,%esi
  8030d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8030d9:	89 e9                	mov    %ebp,%ecx
  8030db:	d3 e0                	shl    %cl,%eax
  8030dd:	89 d7                	mov    %edx,%edi
  8030df:	89 f1                	mov    %esi,%ecx
  8030e1:	d3 ef                	shr    %cl,%edi
  8030e3:	09 c7                	or     %eax,%edi
  8030e5:	89 e9                	mov    %ebp,%ecx
  8030e7:	d3 e2                	shl    %cl,%edx
  8030e9:	89 14 24             	mov    %edx,(%esp)
  8030ec:	89 d8                	mov    %ebx,%eax
  8030ee:	d3 e0                	shl    %cl,%eax
  8030f0:	89 c2                	mov    %eax,%edx
  8030f2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030f6:	d3 e0                	shl    %cl,%eax
  8030f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030fc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803100:	89 f1                	mov    %esi,%ecx
  803102:	d3 e8                	shr    %cl,%eax
  803104:	09 d0                	or     %edx,%eax
  803106:	d3 eb                	shr    %cl,%ebx
  803108:	89 da                	mov    %ebx,%edx
  80310a:	f7 f7                	div    %edi
  80310c:	89 d3                	mov    %edx,%ebx
  80310e:	f7 24 24             	mull   (%esp)
  803111:	89 c6                	mov    %eax,%esi
  803113:	89 d1                	mov    %edx,%ecx
  803115:	39 d3                	cmp    %edx,%ebx
  803117:	0f 82 87 00 00 00    	jb     8031a4 <__umoddi3+0x134>
  80311d:	0f 84 91 00 00 00    	je     8031b4 <__umoddi3+0x144>
  803123:	8b 54 24 04          	mov    0x4(%esp),%edx
  803127:	29 f2                	sub    %esi,%edx
  803129:	19 cb                	sbb    %ecx,%ebx
  80312b:	89 d8                	mov    %ebx,%eax
  80312d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803131:	d3 e0                	shl    %cl,%eax
  803133:	89 e9                	mov    %ebp,%ecx
  803135:	d3 ea                	shr    %cl,%edx
  803137:	09 d0                	or     %edx,%eax
  803139:	89 e9                	mov    %ebp,%ecx
  80313b:	d3 eb                	shr    %cl,%ebx
  80313d:	89 da                	mov    %ebx,%edx
  80313f:	83 c4 1c             	add    $0x1c,%esp
  803142:	5b                   	pop    %ebx
  803143:	5e                   	pop    %esi
  803144:	5f                   	pop    %edi
  803145:	5d                   	pop    %ebp
  803146:	c3                   	ret    
  803147:	90                   	nop
  803148:	89 fd                	mov    %edi,%ebp
  80314a:	85 ff                	test   %edi,%edi
  80314c:	75 0b                	jne    803159 <__umoddi3+0xe9>
  80314e:	b8 01 00 00 00       	mov    $0x1,%eax
  803153:	31 d2                	xor    %edx,%edx
  803155:	f7 f7                	div    %edi
  803157:	89 c5                	mov    %eax,%ebp
  803159:	89 f0                	mov    %esi,%eax
  80315b:	31 d2                	xor    %edx,%edx
  80315d:	f7 f5                	div    %ebp
  80315f:	89 c8                	mov    %ecx,%eax
  803161:	f7 f5                	div    %ebp
  803163:	89 d0                	mov    %edx,%eax
  803165:	e9 44 ff ff ff       	jmp    8030ae <__umoddi3+0x3e>
  80316a:	66 90                	xchg   %ax,%ax
  80316c:	89 c8                	mov    %ecx,%eax
  80316e:	89 f2                	mov    %esi,%edx
  803170:	83 c4 1c             	add    $0x1c,%esp
  803173:	5b                   	pop    %ebx
  803174:	5e                   	pop    %esi
  803175:	5f                   	pop    %edi
  803176:	5d                   	pop    %ebp
  803177:	c3                   	ret    
  803178:	3b 04 24             	cmp    (%esp),%eax
  80317b:	72 06                	jb     803183 <__umoddi3+0x113>
  80317d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803181:	77 0f                	ja     803192 <__umoddi3+0x122>
  803183:	89 f2                	mov    %esi,%edx
  803185:	29 f9                	sub    %edi,%ecx
  803187:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80318b:	89 14 24             	mov    %edx,(%esp)
  80318e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803192:	8b 44 24 04          	mov    0x4(%esp),%eax
  803196:	8b 14 24             	mov    (%esp),%edx
  803199:	83 c4 1c             	add    $0x1c,%esp
  80319c:	5b                   	pop    %ebx
  80319d:	5e                   	pop    %esi
  80319e:	5f                   	pop    %edi
  80319f:	5d                   	pop    %ebp
  8031a0:	c3                   	ret    
  8031a1:	8d 76 00             	lea    0x0(%esi),%esi
  8031a4:	2b 04 24             	sub    (%esp),%eax
  8031a7:	19 fa                	sbb    %edi,%edx
  8031a9:	89 d1                	mov    %edx,%ecx
  8031ab:	89 c6                	mov    %eax,%esi
  8031ad:	e9 71 ff ff ff       	jmp    803123 <__umoddi3+0xb3>
  8031b2:	66 90                	xchg   %ax,%ax
  8031b4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8031b8:	72 ea                	jb     8031a4 <__umoddi3+0x134>
  8031ba:	89 d9                	mov    %ebx,%ecx
  8031bc:	e9 62 ff ff ff       	jmp    803123 <__umoddi3+0xb3>
