
obj/user/tst_envfree6:     file format elf32-i386


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
  800031:	e8 5c 01 00 00       	call   800192 <libmain>
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
	// Testing scenario 6: Semaphores & shared variables
	// Testing removing the shared variables and semaphores
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 c0 31 80 00       	push   $0x8031c0
  80004a:	e8 0d 16 00 00       	call   80165c <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 bd 18 00 00       	call   801920 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 55 19 00 00       	call   8019c0 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 d0 31 80 00       	push   $0x8031d0
  800079:	e8 04 05 00 00       	call   800582 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", 2000, (myEnv->SecondListSize),50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 03 32 80 00       	push   $0x803203
  800099:	e8 f4 1a 00 00       	call   801b92 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_midterm", 20,(myEnv->SecondListSize), 50);
  8000a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8000a9:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000af:	6a 32                	push   $0x32
  8000b1:	50                   	push   %eax
  8000b2:	6a 14                	push   $0x14
  8000b4:	68 0c 32 80 00       	push   $0x80320c
  8000b9:	e8 d4 1a 00 00       	call   801b92 <sys_create_env>
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000c4:	83 ec 0c             	sub    $0xc,%esp
  8000c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000ca:	e8 e1 1a 00 00       	call   801bb0 <sys_run_env>
  8000cf:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 10 27 00 00       	push   $0x2710
  8000da:	e8 c9 2d 00 00       	call   802ea8 <env_sleep>
  8000df:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e8:	e8 c3 1a 00 00       	call   801bb0 <sys_run_env>
  8000ed:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000f0:	90                   	nop
  8000f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	83 f8 02             	cmp    $0x2,%eax
  8000f9:	75 f6                	jne    8000f1 <_main+0xb9>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000fb:	e8 20 18 00 00       	call   801920 <sys_calculate_free_frames>
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	50                   	push   %eax
  800104:	68 18 32 80 00       	push   $0x803218
  800109:	e8 74 04 00 00       	call   800582 <cprintf>
  80010e:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	ff 75 e8             	pushl  -0x18(%ebp)
  800117:	e8 b0 1a 00 00       	call   801bcc <sys_destroy_env>
  80011c:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	ff 75 e4             	pushl  -0x1c(%ebp)
  800125:	e8 a2 1a 00 00       	call   801bcc <sys_destroy_env>
  80012a:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80012d:	e8 ee 17 00 00       	call   801920 <sys_calculate_free_frames>
  800132:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800135:	e8 86 18 00 00       	call   8019c0 <sys_pf_calculate_allocated_pages>
  80013a:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80013d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800140:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800143:	74 27                	je     80016c <_main+0x134>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800145:	83 ec 08             	sub    $0x8,%esp
  800148:	ff 75 e0             	pushl  -0x20(%ebp)
  80014b:	68 4c 32 80 00       	push   $0x80324c
  800150:	e8 2d 04 00 00       	call   800582 <cprintf>
  800155:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 9c 32 80 00       	push   $0x80329c
  800160:	6a 23                	push   $0x23
  800162:	68 d2 32 80 00       	push   $0x8032d2
  800167:	e8 62 01 00 00       	call   8002ce <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80016c:	83 ec 08             	sub    $0x8,%esp
  80016f:	ff 75 e0             	pushl  -0x20(%ebp)
  800172:	68 e8 32 80 00       	push   $0x8032e8
  800177:	e8 06 04 00 00       	call   800582 <cprintf>
  80017c:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 6 for envfree completed successfully.\n");
  80017f:	83 ec 0c             	sub    $0xc,%esp
  800182:	68 48 33 80 00       	push   $0x803348
  800187:	e8 f6 03 00 00       	call   800582 <cprintf>
  80018c:	83 c4 10             	add    $0x10,%esp
	return;
  80018f:	90                   	nop
}
  800190:	c9                   	leave  
  800191:	c3                   	ret    

00800192 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800198:	e8 63 1a 00 00       	call   801c00 <sys_getenvindex>
  80019d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001a3:	89 d0                	mov    %edx,%eax
  8001a5:	c1 e0 03             	shl    $0x3,%eax
  8001a8:	01 d0                	add    %edx,%eax
  8001aa:	01 c0                	add    %eax,%eax
  8001ac:	01 d0                	add    %edx,%eax
  8001ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b5:	01 d0                	add    %edx,%eax
  8001b7:	c1 e0 04             	shl    $0x4,%eax
  8001ba:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001bf:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001c4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c9:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001cf:	84 c0                	test   %al,%al
  8001d1:	74 0f                	je     8001e2 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d8:	05 5c 05 00 00       	add    $0x55c,%eax
  8001dd:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001e6:	7e 0a                	jle    8001f2 <libmain+0x60>
		binaryname = argv[0];
  8001e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001eb:	8b 00                	mov    (%eax),%eax
  8001ed:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001f2:	83 ec 08             	sub    $0x8,%esp
  8001f5:	ff 75 0c             	pushl  0xc(%ebp)
  8001f8:	ff 75 08             	pushl  0x8(%ebp)
  8001fb:	e8 38 fe ff ff       	call   800038 <_main>
  800200:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800203:	e8 05 18 00 00       	call   801a0d <sys_disable_interrupt>
	cprintf("**************************************\n");
  800208:	83 ec 0c             	sub    $0xc,%esp
  80020b:	68 ac 33 80 00       	push   $0x8033ac
  800210:	e8 6d 03 00 00       	call   800582 <cprintf>
  800215:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800218:	a1 20 40 80 00       	mov    0x804020,%eax
  80021d:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800223:	a1 20 40 80 00       	mov    0x804020,%eax
  800228:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	52                   	push   %edx
  800232:	50                   	push   %eax
  800233:	68 d4 33 80 00       	push   $0x8033d4
  800238:	e8 45 03 00 00       	call   800582 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800240:	a1 20 40 80 00       	mov    0x804020,%eax
  800245:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80024b:	a1 20 40 80 00       	mov    0x804020,%eax
  800250:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800256:	a1 20 40 80 00       	mov    0x804020,%eax
  80025b:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800261:	51                   	push   %ecx
  800262:	52                   	push   %edx
  800263:	50                   	push   %eax
  800264:	68 fc 33 80 00       	push   $0x8033fc
  800269:	e8 14 03 00 00       	call   800582 <cprintf>
  80026e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800271:	a1 20 40 80 00       	mov    0x804020,%eax
  800276:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80027c:	83 ec 08             	sub    $0x8,%esp
  80027f:	50                   	push   %eax
  800280:	68 54 34 80 00       	push   $0x803454
  800285:	e8 f8 02 00 00       	call   800582 <cprintf>
  80028a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	68 ac 33 80 00       	push   $0x8033ac
  800295:	e8 e8 02 00 00       	call   800582 <cprintf>
  80029a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80029d:	e8 85 17 00 00       	call   801a27 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002a2:	e8 19 00 00 00       	call   8002c0 <exit>
}
  8002a7:	90                   	nop
  8002a8:	c9                   	leave  
  8002a9:	c3                   	ret    

008002aa <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002b0:	83 ec 0c             	sub    $0xc,%esp
  8002b3:	6a 00                	push   $0x0
  8002b5:	e8 12 19 00 00       	call   801bcc <sys_destroy_env>
  8002ba:	83 c4 10             	add    $0x10,%esp
}
  8002bd:	90                   	nop
  8002be:	c9                   	leave  
  8002bf:	c3                   	ret    

008002c0 <exit>:

void
exit(void)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002c6:	e8 67 19 00 00       	call   801c32 <sys_exit_env>
}
  8002cb:	90                   	nop
  8002cc:	c9                   	leave  
  8002cd:	c3                   	ret    

008002ce <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002ce:	55                   	push   %ebp
  8002cf:	89 e5                	mov    %esp,%ebp
  8002d1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002d4:	8d 45 10             	lea    0x10(%ebp),%eax
  8002d7:	83 c0 04             	add    $0x4,%eax
  8002da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002dd:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002e2:	85 c0                	test   %eax,%eax
  8002e4:	74 16                	je     8002fc <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002e6:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002eb:	83 ec 08             	sub    $0x8,%esp
  8002ee:	50                   	push   %eax
  8002ef:	68 68 34 80 00       	push   $0x803468
  8002f4:	e8 89 02 00 00       	call   800582 <cprintf>
  8002f9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002fc:	a1 00 40 80 00       	mov    0x804000,%eax
  800301:	ff 75 0c             	pushl  0xc(%ebp)
  800304:	ff 75 08             	pushl  0x8(%ebp)
  800307:	50                   	push   %eax
  800308:	68 6d 34 80 00       	push   $0x80346d
  80030d:	e8 70 02 00 00       	call   800582 <cprintf>
  800312:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800315:	8b 45 10             	mov    0x10(%ebp),%eax
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	ff 75 f4             	pushl  -0xc(%ebp)
  80031e:	50                   	push   %eax
  80031f:	e8 f3 01 00 00       	call   800517 <vcprintf>
  800324:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	6a 00                	push   $0x0
  80032c:	68 89 34 80 00       	push   $0x803489
  800331:	e8 e1 01 00 00       	call   800517 <vcprintf>
  800336:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800339:	e8 82 ff ff ff       	call   8002c0 <exit>

	// should not return here
	while (1) ;
  80033e:	eb fe                	jmp    80033e <_panic+0x70>

00800340 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800340:	55                   	push   %ebp
  800341:	89 e5                	mov    %esp,%ebp
  800343:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800346:	a1 20 40 80 00       	mov    0x804020,%eax
  80034b:	8b 50 74             	mov    0x74(%eax),%edx
  80034e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800351:	39 c2                	cmp    %eax,%edx
  800353:	74 14                	je     800369 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800355:	83 ec 04             	sub    $0x4,%esp
  800358:	68 8c 34 80 00       	push   $0x80348c
  80035d:	6a 26                	push   $0x26
  80035f:	68 d8 34 80 00       	push   $0x8034d8
  800364:	e8 65 ff ff ff       	call   8002ce <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800369:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800370:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800377:	e9 c2 00 00 00       	jmp    80043e <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80037c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80037f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	01 d0                	add    %edx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	85 c0                	test   %eax,%eax
  80038f:	75 08                	jne    800399 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800391:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800394:	e9 a2 00 00 00       	jmp    80043b <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800399:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003a7:	eb 69                	jmp    800412 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003a9:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ae:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003b7:	89 d0                	mov    %edx,%eax
  8003b9:	01 c0                	add    %eax,%eax
  8003bb:	01 d0                	add    %edx,%eax
  8003bd:	c1 e0 03             	shl    $0x3,%eax
  8003c0:	01 c8                	add    %ecx,%eax
  8003c2:	8a 40 04             	mov    0x4(%eax),%al
  8003c5:	84 c0                	test   %al,%al
  8003c7:	75 46                	jne    80040f <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ce:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d7:	89 d0                	mov    %edx,%eax
  8003d9:	01 c0                	add    %eax,%eax
  8003db:	01 d0                	add    %edx,%eax
  8003dd:	c1 e0 03             	shl    $0x3,%eax
  8003e0:	01 c8                	add    %ecx,%eax
  8003e2:	8b 00                	mov    (%eax),%eax
  8003e4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ef:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fe:	01 c8                	add    %ecx,%eax
  800400:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800402:	39 c2                	cmp    %eax,%edx
  800404:	75 09                	jne    80040f <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800406:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80040d:	eb 12                	jmp    800421 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80040f:	ff 45 e8             	incl   -0x18(%ebp)
  800412:	a1 20 40 80 00       	mov    0x804020,%eax
  800417:	8b 50 74             	mov    0x74(%eax),%edx
  80041a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80041d:	39 c2                	cmp    %eax,%edx
  80041f:	77 88                	ja     8003a9 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800421:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800425:	75 14                	jne    80043b <CheckWSWithoutLastIndex+0xfb>
			panic(
  800427:	83 ec 04             	sub    $0x4,%esp
  80042a:	68 e4 34 80 00       	push   $0x8034e4
  80042f:	6a 3a                	push   $0x3a
  800431:	68 d8 34 80 00       	push   $0x8034d8
  800436:	e8 93 fe ff ff       	call   8002ce <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80043b:	ff 45 f0             	incl   -0x10(%ebp)
  80043e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800441:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800444:	0f 8c 32 ff ff ff    	jl     80037c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80044a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800451:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800458:	eb 26                	jmp    800480 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80045a:	a1 20 40 80 00       	mov    0x804020,%eax
  80045f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800465:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800468:	89 d0                	mov    %edx,%eax
  80046a:	01 c0                	add    %eax,%eax
  80046c:	01 d0                	add    %edx,%eax
  80046e:	c1 e0 03             	shl    $0x3,%eax
  800471:	01 c8                	add    %ecx,%eax
  800473:	8a 40 04             	mov    0x4(%eax),%al
  800476:	3c 01                	cmp    $0x1,%al
  800478:	75 03                	jne    80047d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80047a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80047d:	ff 45 e0             	incl   -0x20(%ebp)
  800480:	a1 20 40 80 00       	mov    0x804020,%eax
  800485:	8b 50 74             	mov    0x74(%eax),%edx
  800488:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80048b:	39 c2                	cmp    %eax,%edx
  80048d:	77 cb                	ja     80045a <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80048f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800492:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800495:	74 14                	je     8004ab <CheckWSWithoutLastIndex+0x16b>
		panic(
  800497:	83 ec 04             	sub    $0x4,%esp
  80049a:	68 38 35 80 00       	push   $0x803538
  80049f:	6a 44                	push   $0x44
  8004a1:	68 d8 34 80 00       	push   $0x8034d8
  8004a6:	e8 23 fe ff ff       	call   8002ce <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004ab:	90                   	nop
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	8d 48 01             	lea    0x1(%eax),%ecx
  8004bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004bf:	89 0a                	mov    %ecx,(%edx)
  8004c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c4:	88 d1                	mov    %dl,%cl
  8004c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d0:	8b 00                	mov    (%eax),%eax
  8004d2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004d7:	75 2c                	jne    800505 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004d9:	a0 24 40 80 00       	mov    0x804024,%al
  8004de:	0f b6 c0             	movzbl %al,%eax
  8004e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e4:	8b 12                	mov    (%edx),%edx
  8004e6:	89 d1                	mov    %edx,%ecx
  8004e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004eb:	83 c2 08             	add    $0x8,%edx
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	50                   	push   %eax
  8004f2:	51                   	push   %ecx
  8004f3:	52                   	push   %edx
  8004f4:	e8 66 13 00 00       	call   80185f <sys_cputs>
  8004f9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800505:	8b 45 0c             	mov    0xc(%ebp),%eax
  800508:	8b 40 04             	mov    0x4(%eax),%eax
  80050b:	8d 50 01             	lea    0x1(%eax),%edx
  80050e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800511:	89 50 04             	mov    %edx,0x4(%eax)
}
  800514:	90                   	nop
  800515:	c9                   	leave  
  800516:	c3                   	ret    

00800517 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800517:	55                   	push   %ebp
  800518:	89 e5                	mov    %esp,%ebp
  80051a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800520:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800527:	00 00 00 
	b.cnt = 0;
  80052a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800531:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800534:	ff 75 0c             	pushl  0xc(%ebp)
  800537:	ff 75 08             	pushl  0x8(%ebp)
  80053a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800540:	50                   	push   %eax
  800541:	68 ae 04 80 00       	push   $0x8004ae
  800546:	e8 11 02 00 00       	call   80075c <vprintfmt>
  80054b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80054e:	a0 24 40 80 00       	mov    0x804024,%al
  800553:	0f b6 c0             	movzbl %al,%eax
  800556:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80055c:	83 ec 04             	sub    $0x4,%esp
  80055f:	50                   	push   %eax
  800560:	52                   	push   %edx
  800561:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800567:	83 c0 08             	add    $0x8,%eax
  80056a:	50                   	push   %eax
  80056b:	e8 ef 12 00 00       	call   80185f <sys_cputs>
  800570:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800573:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80057a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800580:	c9                   	leave  
  800581:	c3                   	ret    

00800582 <cprintf>:

int cprintf(const char *fmt, ...) {
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
  800585:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800588:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80058f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800592:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800595:	8b 45 08             	mov    0x8(%ebp),%eax
  800598:	83 ec 08             	sub    $0x8,%esp
  80059b:	ff 75 f4             	pushl  -0xc(%ebp)
  80059e:	50                   	push   %eax
  80059f:	e8 73 ff ff ff       	call   800517 <vcprintf>
  8005a4:	83 c4 10             	add    $0x10,%esp
  8005a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005ad:	c9                   	leave  
  8005ae:	c3                   	ret    

008005af <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005b5:	e8 53 14 00 00       	call   801a0d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005ba:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c3:	83 ec 08             	sub    $0x8,%esp
  8005c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c9:	50                   	push   %eax
  8005ca:	e8 48 ff ff ff       	call   800517 <vcprintf>
  8005cf:	83 c4 10             	add    $0x10,%esp
  8005d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005d5:	e8 4d 14 00 00       	call   801a27 <sys_enable_interrupt>
	return cnt;
  8005da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005dd:	c9                   	leave  
  8005de:	c3                   	ret    

008005df <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005df:	55                   	push   %ebp
  8005e0:	89 e5                	mov    %esp,%ebp
  8005e2:	53                   	push   %ebx
  8005e3:	83 ec 14             	sub    $0x14,%esp
  8005e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f2:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005fd:	77 55                	ja     800654 <printnum+0x75>
  8005ff:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800602:	72 05                	jb     800609 <printnum+0x2a>
  800604:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800607:	77 4b                	ja     800654 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800609:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80060c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80060f:	8b 45 18             	mov    0x18(%ebp),%eax
  800612:	ba 00 00 00 00       	mov    $0x0,%edx
  800617:	52                   	push   %edx
  800618:	50                   	push   %eax
  800619:	ff 75 f4             	pushl  -0xc(%ebp)
  80061c:	ff 75 f0             	pushl  -0x10(%ebp)
  80061f:	e8 38 29 00 00       	call   802f5c <__udivdi3>
  800624:	83 c4 10             	add    $0x10,%esp
  800627:	83 ec 04             	sub    $0x4,%esp
  80062a:	ff 75 20             	pushl  0x20(%ebp)
  80062d:	53                   	push   %ebx
  80062e:	ff 75 18             	pushl  0x18(%ebp)
  800631:	52                   	push   %edx
  800632:	50                   	push   %eax
  800633:	ff 75 0c             	pushl  0xc(%ebp)
  800636:	ff 75 08             	pushl  0x8(%ebp)
  800639:	e8 a1 ff ff ff       	call   8005df <printnum>
  80063e:	83 c4 20             	add    $0x20,%esp
  800641:	eb 1a                	jmp    80065d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	ff 75 0c             	pushl  0xc(%ebp)
  800649:	ff 75 20             	pushl  0x20(%ebp)
  80064c:	8b 45 08             	mov    0x8(%ebp),%eax
  80064f:	ff d0                	call   *%eax
  800651:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800654:	ff 4d 1c             	decl   0x1c(%ebp)
  800657:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80065b:	7f e6                	jg     800643 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80065d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800660:	bb 00 00 00 00       	mov    $0x0,%ebx
  800665:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800668:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80066b:	53                   	push   %ebx
  80066c:	51                   	push   %ecx
  80066d:	52                   	push   %edx
  80066e:	50                   	push   %eax
  80066f:	e8 f8 29 00 00       	call   80306c <__umoddi3>
  800674:	83 c4 10             	add    $0x10,%esp
  800677:	05 b4 37 80 00       	add    $0x8037b4,%eax
  80067c:	8a 00                	mov    (%eax),%al
  80067e:	0f be c0             	movsbl %al,%eax
  800681:	83 ec 08             	sub    $0x8,%esp
  800684:	ff 75 0c             	pushl  0xc(%ebp)
  800687:	50                   	push   %eax
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	ff d0                	call   *%eax
  80068d:	83 c4 10             	add    $0x10,%esp
}
  800690:	90                   	nop
  800691:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800694:	c9                   	leave  
  800695:	c3                   	ret    

00800696 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800696:	55                   	push   %ebp
  800697:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800699:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80069d:	7e 1c                	jle    8006bb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80069f:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	8d 50 08             	lea    0x8(%eax),%edx
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	89 10                	mov    %edx,(%eax)
  8006ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8006af:	8b 00                	mov    (%eax),%eax
  8006b1:	83 e8 08             	sub    $0x8,%eax
  8006b4:	8b 50 04             	mov    0x4(%eax),%edx
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	eb 40                	jmp    8006fb <getuint+0x65>
	else if (lflag)
  8006bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006bf:	74 1e                	je     8006df <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	8d 50 04             	lea    0x4(%eax),%edx
  8006c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cc:	89 10                	mov    %edx,(%eax)
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	83 e8 04             	sub    $0x4,%eax
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006dd:	eb 1c                	jmp    8006fb <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006df:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	8d 50 04             	lea    0x4(%eax),%edx
  8006e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ea:	89 10                	mov    %edx,(%eax)
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	8b 00                	mov    (%eax),%eax
  8006f1:	83 e8 04             	sub    $0x4,%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006fb:	5d                   	pop    %ebp
  8006fc:	c3                   	ret    

008006fd <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800700:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800704:	7e 1c                	jle    800722 <getint+0x25>
		return va_arg(*ap, long long);
  800706:	8b 45 08             	mov    0x8(%ebp),%eax
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	8d 50 08             	lea    0x8(%eax),%edx
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	89 10                	mov    %edx,(%eax)
  800713:	8b 45 08             	mov    0x8(%ebp),%eax
  800716:	8b 00                	mov    (%eax),%eax
  800718:	83 e8 08             	sub    $0x8,%eax
  80071b:	8b 50 04             	mov    0x4(%eax),%edx
  80071e:	8b 00                	mov    (%eax),%eax
  800720:	eb 38                	jmp    80075a <getint+0x5d>
	else if (lflag)
  800722:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800726:	74 1a                	je     800742 <getint+0x45>
		return va_arg(*ap, long);
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	8d 50 04             	lea    0x4(%eax),%edx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	89 10                	mov    %edx,(%eax)
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	83 e8 04             	sub    $0x4,%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	99                   	cltd   
  800740:	eb 18                	jmp    80075a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800742:	8b 45 08             	mov    0x8(%ebp),%eax
  800745:	8b 00                	mov    (%eax),%eax
  800747:	8d 50 04             	lea    0x4(%eax),%edx
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	89 10                	mov    %edx,(%eax)
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	83 e8 04             	sub    $0x4,%eax
  800757:	8b 00                	mov    (%eax),%eax
  800759:	99                   	cltd   
}
  80075a:	5d                   	pop    %ebp
  80075b:	c3                   	ret    

0080075c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	56                   	push   %esi
  800760:	53                   	push   %ebx
  800761:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800764:	eb 17                	jmp    80077d <vprintfmt+0x21>
			if (ch == '\0')
  800766:	85 db                	test   %ebx,%ebx
  800768:	0f 84 af 03 00 00    	je     800b1d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80076e:	83 ec 08             	sub    $0x8,%esp
  800771:	ff 75 0c             	pushl  0xc(%ebp)
  800774:	53                   	push   %ebx
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	ff d0                	call   *%eax
  80077a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077d:	8b 45 10             	mov    0x10(%ebp),%eax
  800780:	8d 50 01             	lea    0x1(%eax),%edx
  800783:	89 55 10             	mov    %edx,0x10(%ebp)
  800786:	8a 00                	mov    (%eax),%al
  800788:	0f b6 d8             	movzbl %al,%ebx
  80078b:	83 fb 25             	cmp    $0x25,%ebx
  80078e:	75 d6                	jne    800766 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800790:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800794:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80079b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007a2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007a9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b3:	8d 50 01             	lea    0x1(%eax),%edx
  8007b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8007b9:	8a 00                	mov    (%eax),%al
  8007bb:	0f b6 d8             	movzbl %al,%ebx
  8007be:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007c1:	83 f8 55             	cmp    $0x55,%eax
  8007c4:	0f 87 2b 03 00 00    	ja     800af5 <vprintfmt+0x399>
  8007ca:	8b 04 85 d8 37 80 00 	mov    0x8037d8(,%eax,4),%eax
  8007d1:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007d3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007d7:	eb d7                	jmp    8007b0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007d9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007dd:	eb d1                	jmp    8007b0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007df:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007e9:	89 d0                	mov    %edx,%eax
  8007eb:	c1 e0 02             	shl    $0x2,%eax
  8007ee:	01 d0                	add    %edx,%eax
  8007f0:	01 c0                	add    %eax,%eax
  8007f2:	01 d8                	add    %ebx,%eax
  8007f4:	83 e8 30             	sub    $0x30,%eax
  8007f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fd:	8a 00                	mov    (%eax),%al
  8007ff:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800802:	83 fb 2f             	cmp    $0x2f,%ebx
  800805:	7e 3e                	jle    800845 <vprintfmt+0xe9>
  800807:	83 fb 39             	cmp    $0x39,%ebx
  80080a:	7f 39                	jg     800845 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80080c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80080f:	eb d5                	jmp    8007e6 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800811:	8b 45 14             	mov    0x14(%ebp),%eax
  800814:	83 c0 04             	add    $0x4,%eax
  800817:	89 45 14             	mov    %eax,0x14(%ebp)
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	83 e8 04             	sub    $0x4,%eax
  800820:	8b 00                	mov    (%eax),%eax
  800822:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800825:	eb 1f                	jmp    800846 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800827:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082b:	79 83                	jns    8007b0 <vprintfmt+0x54>
				width = 0;
  80082d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800834:	e9 77 ff ff ff       	jmp    8007b0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800839:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800840:	e9 6b ff ff ff       	jmp    8007b0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800845:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800846:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084a:	0f 89 60 ff ff ff    	jns    8007b0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800850:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800853:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800856:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80085d:	e9 4e ff ff ff       	jmp    8007b0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800862:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800865:	e9 46 ff ff ff       	jmp    8007b0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	83 c0 04             	add    $0x4,%eax
  800870:	89 45 14             	mov    %eax,0x14(%ebp)
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	83 e8 04             	sub    $0x4,%eax
  800879:	8b 00                	mov    (%eax),%eax
  80087b:	83 ec 08             	sub    $0x8,%esp
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	50                   	push   %eax
  800882:	8b 45 08             	mov    0x8(%ebp),%eax
  800885:	ff d0                	call   *%eax
  800887:	83 c4 10             	add    $0x10,%esp
			break;
  80088a:	e9 89 02 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80088f:	8b 45 14             	mov    0x14(%ebp),%eax
  800892:	83 c0 04             	add    $0x4,%eax
  800895:	89 45 14             	mov    %eax,0x14(%ebp)
  800898:	8b 45 14             	mov    0x14(%ebp),%eax
  80089b:	83 e8 04             	sub    $0x4,%eax
  80089e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008a0:	85 db                	test   %ebx,%ebx
  8008a2:	79 02                	jns    8008a6 <vprintfmt+0x14a>
				err = -err;
  8008a4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008a6:	83 fb 64             	cmp    $0x64,%ebx
  8008a9:	7f 0b                	jg     8008b6 <vprintfmt+0x15a>
  8008ab:	8b 34 9d 20 36 80 00 	mov    0x803620(,%ebx,4),%esi
  8008b2:	85 f6                	test   %esi,%esi
  8008b4:	75 19                	jne    8008cf <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b6:	53                   	push   %ebx
  8008b7:	68 c5 37 80 00       	push   $0x8037c5
  8008bc:	ff 75 0c             	pushl  0xc(%ebp)
  8008bf:	ff 75 08             	pushl  0x8(%ebp)
  8008c2:	e8 5e 02 00 00       	call   800b25 <printfmt>
  8008c7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008ca:	e9 49 02 00 00       	jmp    800b18 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008cf:	56                   	push   %esi
  8008d0:	68 ce 37 80 00       	push   $0x8037ce
  8008d5:	ff 75 0c             	pushl  0xc(%ebp)
  8008d8:	ff 75 08             	pushl  0x8(%ebp)
  8008db:	e8 45 02 00 00       	call   800b25 <printfmt>
  8008e0:	83 c4 10             	add    $0x10,%esp
			break;
  8008e3:	e9 30 02 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008eb:	83 c0 04             	add    $0x4,%eax
  8008ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f4:	83 e8 04             	sub    $0x4,%eax
  8008f7:	8b 30                	mov    (%eax),%esi
  8008f9:	85 f6                	test   %esi,%esi
  8008fb:	75 05                	jne    800902 <vprintfmt+0x1a6>
				p = "(null)";
  8008fd:	be d1 37 80 00       	mov    $0x8037d1,%esi
			if (width > 0 && padc != '-')
  800902:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800906:	7e 6d                	jle    800975 <vprintfmt+0x219>
  800908:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80090c:	74 67                	je     800975 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80090e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800911:	83 ec 08             	sub    $0x8,%esp
  800914:	50                   	push   %eax
  800915:	56                   	push   %esi
  800916:	e8 0c 03 00 00       	call   800c27 <strnlen>
  80091b:	83 c4 10             	add    $0x10,%esp
  80091e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800921:	eb 16                	jmp    800939 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800923:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800927:	83 ec 08             	sub    $0x8,%esp
  80092a:	ff 75 0c             	pushl  0xc(%ebp)
  80092d:	50                   	push   %eax
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	ff d0                	call   *%eax
  800933:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800936:	ff 4d e4             	decl   -0x1c(%ebp)
  800939:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80093d:	7f e4                	jg     800923 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80093f:	eb 34                	jmp    800975 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800941:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800945:	74 1c                	je     800963 <vprintfmt+0x207>
  800947:	83 fb 1f             	cmp    $0x1f,%ebx
  80094a:	7e 05                	jle    800951 <vprintfmt+0x1f5>
  80094c:	83 fb 7e             	cmp    $0x7e,%ebx
  80094f:	7e 12                	jle    800963 <vprintfmt+0x207>
					putch('?', putdat);
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	ff 75 0c             	pushl  0xc(%ebp)
  800957:	6a 3f                	push   $0x3f
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	ff d0                	call   *%eax
  80095e:	83 c4 10             	add    $0x10,%esp
  800961:	eb 0f                	jmp    800972 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800963:	83 ec 08             	sub    $0x8,%esp
  800966:	ff 75 0c             	pushl  0xc(%ebp)
  800969:	53                   	push   %ebx
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	ff d0                	call   *%eax
  80096f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800972:	ff 4d e4             	decl   -0x1c(%ebp)
  800975:	89 f0                	mov    %esi,%eax
  800977:	8d 70 01             	lea    0x1(%eax),%esi
  80097a:	8a 00                	mov    (%eax),%al
  80097c:	0f be d8             	movsbl %al,%ebx
  80097f:	85 db                	test   %ebx,%ebx
  800981:	74 24                	je     8009a7 <vprintfmt+0x24b>
  800983:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800987:	78 b8                	js     800941 <vprintfmt+0x1e5>
  800989:	ff 4d e0             	decl   -0x20(%ebp)
  80098c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800990:	79 af                	jns    800941 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800992:	eb 13                	jmp    8009a7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800994:	83 ec 08             	sub    $0x8,%esp
  800997:	ff 75 0c             	pushl  0xc(%ebp)
  80099a:	6a 20                	push   $0x20
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	ff d0                	call   *%eax
  8009a1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009a4:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ab:	7f e7                	jg     800994 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009ad:	e9 66 01 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009b2:	83 ec 08             	sub    $0x8,%esp
  8009b5:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009bb:	50                   	push   %eax
  8009bc:	e8 3c fd ff ff       	call   8006fd <getint>
  8009c1:	83 c4 10             	add    $0x10,%esp
  8009c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d0:	85 d2                	test   %edx,%edx
  8009d2:	79 23                	jns    8009f7 <vprintfmt+0x29b>
				putch('-', putdat);
  8009d4:	83 ec 08             	sub    $0x8,%esp
  8009d7:	ff 75 0c             	pushl  0xc(%ebp)
  8009da:	6a 2d                	push   $0x2d
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	ff d0                	call   *%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ea:	f7 d8                	neg    %eax
  8009ec:	83 d2 00             	adc    $0x0,%edx
  8009ef:	f7 da                	neg    %edx
  8009f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009f7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009fe:	e9 bc 00 00 00       	jmp    800abf <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	ff 75 e8             	pushl  -0x18(%ebp)
  800a09:	8d 45 14             	lea    0x14(%ebp),%eax
  800a0c:	50                   	push   %eax
  800a0d:	e8 84 fc ff ff       	call   800696 <getuint>
  800a12:	83 c4 10             	add    $0x10,%esp
  800a15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a22:	e9 98 00 00 00       	jmp    800abf <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a27:	83 ec 08             	sub    $0x8,%esp
  800a2a:	ff 75 0c             	pushl  0xc(%ebp)
  800a2d:	6a 58                	push   $0x58
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	ff d0                	call   *%eax
  800a34:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	ff 75 0c             	pushl  0xc(%ebp)
  800a3d:	6a 58                	push   $0x58
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	ff d0                	call   *%eax
  800a44:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a47:	83 ec 08             	sub    $0x8,%esp
  800a4a:	ff 75 0c             	pushl  0xc(%ebp)
  800a4d:	6a 58                	push   $0x58
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	ff d0                	call   *%eax
  800a54:	83 c4 10             	add    $0x10,%esp
			break;
  800a57:	e9 bc 00 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a5c:	83 ec 08             	sub    $0x8,%esp
  800a5f:	ff 75 0c             	pushl  0xc(%ebp)
  800a62:	6a 30                	push   $0x30
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	ff d0                	call   *%eax
  800a69:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a6c:	83 ec 08             	sub    $0x8,%esp
  800a6f:	ff 75 0c             	pushl  0xc(%ebp)
  800a72:	6a 78                	push   $0x78
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	ff d0                	call   *%eax
  800a79:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7f:	83 c0 04             	add    $0x4,%eax
  800a82:	89 45 14             	mov    %eax,0x14(%ebp)
  800a85:	8b 45 14             	mov    0x14(%ebp),%eax
  800a88:	83 e8 04             	sub    $0x4,%eax
  800a8b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a97:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a9e:	eb 1f                	jmp    800abf <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aa0:	83 ec 08             	sub    $0x8,%esp
  800aa3:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa6:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa9:	50                   	push   %eax
  800aaa:	e8 e7 fb ff ff       	call   800696 <getuint>
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ab8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800abf:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ac3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac6:	83 ec 04             	sub    $0x4,%esp
  800ac9:	52                   	push   %edx
  800aca:	ff 75 e4             	pushl  -0x1c(%ebp)
  800acd:	50                   	push   %eax
  800ace:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad1:	ff 75 f0             	pushl  -0x10(%ebp)
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	ff 75 08             	pushl  0x8(%ebp)
  800ada:	e8 00 fb ff ff       	call   8005df <printnum>
  800adf:	83 c4 20             	add    $0x20,%esp
			break;
  800ae2:	eb 34                	jmp    800b18 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	53                   	push   %ebx
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	ff d0                	call   *%eax
  800af0:	83 c4 10             	add    $0x10,%esp
			break;
  800af3:	eb 23                	jmp    800b18 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	6a 25                	push   $0x25
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	ff d0                	call   *%eax
  800b02:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b05:	ff 4d 10             	decl   0x10(%ebp)
  800b08:	eb 03                	jmp    800b0d <vprintfmt+0x3b1>
  800b0a:	ff 4d 10             	decl   0x10(%ebp)
  800b0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b10:	48                   	dec    %eax
  800b11:	8a 00                	mov    (%eax),%al
  800b13:	3c 25                	cmp    $0x25,%al
  800b15:	75 f3                	jne    800b0a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b17:	90                   	nop
		}
	}
  800b18:	e9 47 fc ff ff       	jmp    800764 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b1d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b21:	5b                   	pop    %ebx
  800b22:	5e                   	pop    %esi
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b2b:	8d 45 10             	lea    0x10(%ebp),%eax
  800b2e:	83 c0 04             	add    $0x4,%eax
  800b31:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b34:	8b 45 10             	mov    0x10(%ebp),%eax
  800b37:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3a:	50                   	push   %eax
  800b3b:	ff 75 0c             	pushl  0xc(%ebp)
  800b3e:	ff 75 08             	pushl  0x8(%ebp)
  800b41:	e8 16 fc ff ff       	call   80075c <vprintfmt>
  800b46:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b49:	90                   	nop
  800b4a:	c9                   	leave  
  800b4b:	c3                   	ret    

00800b4c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b52:	8b 40 08             	mov    0x8(%eax),%eax
  800b55:	8d 50 01             	lea    0x1(%eax),%edx
  800b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	8b 10                	mov    (%eax),%edx
  800b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b66:	8b 40 04             	mov    0x4(%eax),%eax
  800b69:	39 c2                	cmp    %eax,%edx
  800b6b:	73 12                	jae    800b7f <sprintputch+0x33>
		*b->buf++ = ch;
  800b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b70:	8b 00                	mov    (%eax),%eax
  800b72:	8d 48 01             	lea    0x1(%eax),%ecx
  800b75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b78:	89 0a                	mov    %ecx,(%edx)
  800b7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b7d:	88 10                	mov    %dl,(%eax)
}
  800b7f:	90                   	nop
  800b80:	5d                   	pop    %ebp
  800b81:	c3                   	ret    

00800b82 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b91:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	01 d0                	add    %edx,%eax
  800b99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ba3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ba7:	74 06                	je     800baf <vsnprintf+0x2d>
  800ba9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bad:	7f 07                	jg     800bb6 <vsnprintf+0x34>
		return -E_INVAL;
  800baf:	b8 03 00 00 00       	mov    $0x3,%eax
  800bb4:	eb 20                	jmp    800bd6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bb6:	ff 75 14             	pushl  0x14(%ebp)
  800bb9:	ff 75 10             	pushl  0x10(%ebp)
  800bbc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bbf:	50                   	push   %eax
  800bc0:	68 4c 0b 80 00       	push   $0x800b4c
  800bc5:	e8 92 fb ff ff       	call   80075c <vprintfmt>
  800bca:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bd6:	c9                   	leave  
  800bd7:	c3                   	ret    

00800bd8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bde:	8d 45 10             	lea    0x10(%ebp),%eax
  800be1:	83 c0 04             	add    $0x4,%eax
  800be4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800be7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bea:	ff 75 f4             	pushl  -0xc(%ebp)
  800bed:	50                   	push   %eax
  800bee:	ff 75 0c             	pushl  0xc(%ebp)
  800bf1:	ff 75 08             	pushl  0x8(%ebp)
  800bf4:	e8 89 ff ff ff       	call   800b82 <vsnprintf>
  800bf9:	83 c4 10             	add    $0x10,%esp
  800bfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c11:	eb 06                	jmp    800c19 <strlen+0x15>
		n++;
  800c13:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c16:	ff 45 08             	incl   0x8(%ebp)
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	8a 00                	mov    (%eax),%al
  800c1e:	84 c0                	test   %al,%al
  800c20:	75 f1                	jne    800c13 <strlen+0xf>
		n++;
	return n;
  800c22:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c25:	c9                   	leave  
  800c26:	c3                   	ret    

00800c27 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c34:	eb 09                	jmp    800c3f <strnlen+0x18>
		n++;
  800c36:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c39:	ff 45 08             	incl   0x8(%ebp)
  800c3c:	ff 4d 0c             	decl   0xc(%ebp)
  800c3f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c43:	74 09                	je     800c4e <strnlen+0x27>
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	8a 00                	mov    (%eax),%al
  800c4a:	84 c0                	test   %al,%al
  800c4c:	75 e8                	jne    800c36 <strnlen+0xf>
		n++;
	return n;
  800c4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c51:	c9                   	leave  
  800c52:	c3                   	ret    

00800c53 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c5f:	90                   	nop
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8d 50 01             	lea    0x1(%eax),%edx
  800c66:	89 55 08             	mov    %edx,0x8(%ebp)
  800c69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c6f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c72:	8a 12                	mov    (%edx),%dl
  800c74:	88 10                	mov    %dl,(%eax)
  800c76:	8a 00                	mov    (%eax),%al
  800c78:	84 c0                	test   %al,%al
  800c7a:	75 e4                	jne    800c60 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c7f:	c9                   	leave  
  800c80:	c3                   	ret    

00800c81 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c94:	eb 1f                	jmp    800cb5 <strncpy+0x34>
		*dst++ = *src;
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	8d 50 01             	lea    0x1(%eax),%edx
  800c9c:	89 55 08             	mov    %edx,0x8(%ebp)
  800c9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca2:	8a 12                	mov    (%edx),%dl
  800ca4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca9:	8a 00                	mov    (%eax),%al
  800cab:	84 c0                	test   %al,%al
  800cad:	74 03                	je     800cb2 <strncpy+0x31>
			src++;
  800caf:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cb2:	ff 45 fc             	incl   -0x4(%ebp)
  800cb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cbb:	72 d9                	jb     800c96 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cc0:	c9                   	leave  
  800cc1:	c3                   	ret    

00800cc2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd2:	74 30                	je     800d04 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cd4:	eb 16                	jmp    800cec <strlcpy+0x2a>
			*dst++ = *src++;
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	8d 50 01             	lea    0x1(%eax),%edx
  800cdc:	89 55 08             	mov    %edx,0x8(%ebp)
  800cdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ce8:	8a 12                	mov    (%edx),%dl
  800cea:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cec:	ff 4d 10             	decl   0x10(%ebp)
  800cef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf3:	74 09                	je     800cfe <strlcpy+0x3c>
  800cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	84 c0                	test   %al,%al
  800cfc:	75 d8                	jne    800cd6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d04:	8b 55 08             	mov    0x8(%ebp),%edx
  800d07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0a:	29 c2                	sub    %eax,%edx
  800d0c:	89 d0                	mov    %edx,%eax
}
  800d0e:	c9                   	leave  
  800d0f:	c3                   	ret    

00800d10 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d13:	eb 06                	jmp    800d1b <strcmp+0xb>
		p++, q++;
  800d15:	ff 45 08             	incl   0x8(%ebp)
  800d18:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	8a 00                	mov    (%eax),%al
  800d20:	84 c0                	test   %al,%al
  800d22:	74 0e                	je     800d32 <strcmp+0x22>
  800d24:	8b 45 08             	mov    0x8(%ebp),%eax
  800d27:	8a 10                	mov    (%eax),%dl
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	38 c2                	cmp    %al,%dl
  800d30:	74 e3                	je     800d15 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	0f b6 d0             	movzbl %al,%edx
  800d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3d:	8a 00                	mov    (%eax),%al
  800d3f:	0f b6 c0             	movzbl %al,%eax
  800d42:	29 c2                	sub    %eax,%edx
  800d44:	89 d0                	mov    %edx,%eax
}
  800d46:	5d                   	pop    %ebp
  800d47:	c3                   	ret    

00800d48 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d4b:	eb 09                	jmp    800d56 <strncmp+0xe>
		n--, p++, q++;
  800d4d:	ff 4d 10             	decl   0x10(%ebp)
  800d50:	ff 45 08             	incl   0x8(%ebp)
  800d53:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5a:	74 17                	je     800d73 <strncmp+0x2b>
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	84 c0                	test   %al,%al
  800d63:	74 0e                	je     800d73 <strncmp+0x2b>
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8a 10                	mov    (%eax),%dl
  800d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	38 c2                	cmp    %al,%dl
  800d71:	74 da                	je     800d4d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d73:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d77:	75 07                	jne    800d80 <strncmp+0x38>
		return 0;
  800d79:	b8 00 00 00 00       	mov    $0x0,%eax
  800d7e:	eb 14                	jmp    800d94 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	0f b6 d0             	movzbl %al,%edx
  800d88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	0f b6 c0             	movzbl %al,%eax
  800d90:	29 c2                	sub    %eax,%edx
  800d92:	89 d0                	mov    %edx,%eax
}
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    

00800d96 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 04             	sub    $0x4,%esp
  800d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800da2:	eb 12                	jmp    800db6 <strchr+0x20>
		if (*s == c)
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	8a 00                	mov    (%eax),%al
  800da9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dac:	75 05                	jne    800db3 <strchr+0x1d>
			return (char *) s;
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	eb 11                	jmp    800dc4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800db3:	ff 45 08             	incl   0x8(%ebp)
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	84 c0                	test   %al,%al
  800dbd:	75 e5                	jne    800da4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dc4:	c9                   	leave  
  800dc5:	c3                   	ret    

00800dc6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	83 ec 04             	sub    $0x4,%esp
  800dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dd2:	eb 0d                	jmp    800de1 <strfind+0x1b>
		if (*s == c)
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ddc:	74 0e                	je     800dec <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dde:	ff 45 08             	incl   0x8(%ebp)
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	8a 00                	mov    (%eax),%al
  800de6:	84 c0                	test   %al,%al
  800de8:	75 ea                	jne    800dd4 <strfind+0xe>
  800dea:	eb 01                	jmp    800ded <strfind+0x27>
		if (*s == c)
			break;
  800dec:	90                   	nop
	return (char *) s;
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df0:	c9                   	leave  
  800df1:	c3                   	ret    

00800df2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dfe:	8b 45 10             	mov    0x10(%ebp),%eax
  800e01:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e04:	eb 0e                	jmp    800e14 <memset+0x22>
		*p++ = c;
  800e06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e09:	8d 50 01             	lea    0x1(%eax),%edx
  800e0c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e12:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e14:	ff 4d f8             	decl   -0x8(%ebp)
  800e17:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e1b:	79 e9                	jns    800e06 <memset+0x14>
		*p++ = c;

	return v;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e20:	c9                   	leave  
  800e21:	c3                   	ret    

00800e22 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e34:	eb 16                	jmp    800e4c <memcpy+0x2a>
		*d++ = *s++;
  800e36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e39:	8d 50 01             	lea    0x1(%eax),%edx
  800e3c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e3f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e42:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e45:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e48:	8a 12                	mov    (%edx),%dl
  800e4a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e52:	89 55 10             	mov    %edx,0x10(%ebp)
  800e55:	85 c0                	test   %eax,%eax
  800e57:	75 dd                	jne    800e36 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5c:	c9                   	leave  
  800e5d:	c3                   	ret    

00800e5e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e73:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e76:	73 50                	jae    800ec8 <memmove+0x6a>
  800e78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7e:	01 d0                	add    %edx,%eax
  800e80:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e83:	76 43                	jbe    800ec8 <memmove+0x6a>
		s += n;
  800e85:	8b 45 10             	mov    0x10(%ebp),%eax
  800e88:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e91:	eb 10                	jmp    800ea3 <memmove+0x45>
			*--d = *--s;
  800e93:	ff 4d f8             	decl   -0x8(%ebp)
  800e96:	ff 4d fc             	decl   -0x4(%ebp)
  800e99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9c:	8a 10                	mov    (%eax),%dl
  800e9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ea3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea9:	89 55 10             	mov    %edx,0x10(%ebp)
  800eac:	85 c0                	test   %eax,%eax
  800eae:	75 e3                	jne    800e93 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800eb0:	eb 23                	jmp    800ed5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800eb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb5:	8d 50 01             	lea    0x1(%eax),%edx
  800eb8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ebb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ebe:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ec1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ec4:	8a 12                	mov    (%edx),%dl
  800ec6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ece:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed1:	85 c0                	test   %eax,%eax
  800ed3:	75 dd                	jne    800eb2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed8:	c9                   	leave  
  800ed9:	c3                   	ret    

00800eda <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eec:	eb 2a                	jmp    800f18 <memcmp+0x3e>
		if (*s1 != *s2)
  800eee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef1:	8a 10                	mov    (%eax),%dl
  800ef3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	38 c2                	cmp    %al,%dl
  800efa:	74 16                	je     800f12 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800efc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eff:	8a 00                	mov    (%eax),%al
  800f01:	0f b6 d0             	movzbl %al,%edx
  800f04:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f07:	8a 00                	mov    (%eax),%al
  800f09:	0f b6 c0             	movzbl %al,%eax
  800f0c:	29 c2                	sub    %eax,%edx
  800f0e:	89 d0                	mov    %edx,%eax
  800f10:	eb 18                	jmp    800f2a <memcmp+0x50>
		s1++, s2++;
  800f12:	ff 45 fc             	incl   -0x4(%ebp)
  800f15:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f18:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f1e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f21:	85 c0                	test   %eax,%eax
  800f23:	75 c9                	jne    800eee <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f2a:	c9                   	leave  
  800f2b:	c3                   	ret    

00800f2c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f32:	8b 55 08             	mov    0x8(%ebp),%edx
  800f35:	8b 45 10             	mov    0x10(%ebp),%eax
  800f38:	01 d0                	add    %edx,%eax
  800f3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f3d:	eb 15                	jmp    800f54 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	0f b6 d0             	movzbl %al,%edx
  800f47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4a:	0f b6 c0             	movzbl %al,%eax
  800f4d:	39 c2                	cmp    %eax,%edx
  800f4f:	74 0d                	je     800f5e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f51:	ff 45 08             	incl   0x8(%ebp)
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f5a:	72 e3                	jb     800f3f <memfind+0x13>
  800f5c:	eb 01                	jmp    800f5f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f5e:	90                   	nop
	return (void *) s;
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f62:	c9                   	leave  
  800f63:	c3                   	ret    

00800f64 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
  800f67:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f71:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f78:	eb 03                	jmp    800f7d <strtol+0x19>
		s++;
  800f7a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	3c 20                	cmp    $0x20,%al
  800f84:	74 f4                	je     800f7a <strtol+0x16>
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	3c 09                	cmp    $0x9,%al
  800f8d:	74 eb                	je     800f7a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	3c 2b                	cmp    $0x2b,%al
  800f96:	75 05                	jne    800f9d <strtol+0x39>
		s++;
  800f98:	ff 45 08             	incl   0x8(%ebp)
  800f9b:	eb 13                	jmp    800fb0 <strtol+0x4c>
	else if (*s == '-')
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	3c 2d                	cmp    $0x2d,%al
  800fa4:	75 0a                	jne    800fb0 <strtol+0x4c>
		s++, neg = 1;
  800fa6:	ff 45 08             	incl   0x8(%ebp)
  800fa9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb4:	74 06                	je     800fbc <strtol+0x58>
  800fb6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fba:	75 20                	jne    800fdc <strtol+0x78>
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	8a 00                	mov    (%eax),%al
  800fc1:	3c 30                	cmp    $0x30,%al
  800fc3:	75 17                	jne    800fdc <strtol+0x78>
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	40                   	inc    %eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 78                	cmp    $0x78,%al
  800fcd:	75 0d                	jne    800fdc <strtol+0x78>
		s += 2, base = 16;
  800fcf:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fd3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fda:	eb 28                	jmp    801004 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fdc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe0:	75 15                	jne    800ff7 <strtol+0x93>
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	8a 00                	mov    (%eax),%al
  800fe7:	3c 30                	cmp    $0x30,%al
  800fe9:	75 0c                	jne    800ff7 <strtol+0x93>
		s++, base = 8;
  800feb:	ff 45 08             	incl   0x8(%ebp)
  800fee:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ff5:	eb 0d                	jmp    801004 <strtol+0xa0>
	else if (base == 0)
  800ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffb:	75 07                	jne    801004 <strtol+0xa0>
		base = 10;
  800ffd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	3c 2f                	cmp    $0x2f,%al
  80100b:	7e 19                	jle    801026 <strtol+0xc2>
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	3c 39                	cmp    $0x39,%al
  801014:	7f 10                	jg     801026 <strtol+0xc2>
			dig = *s - '0';
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	8a 00                	mov    (%eax),%al
  80101b:	0f be c0             	movsbl %al,%eax
  80101e:	83 e8 30             	sub    $0x30,%eax
  801021:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801024:	eb 42                	jmp    801068 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3c 60                	cmp    $0x60,%al
  80102d:	7e 19                	jle    801048 <strtol+0xe4>
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	3c 7a                	cmp    $0x7a,%al
  801036:	7f 10                	jg     801048 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	0f be c0             	movsbl %al,%eax
  801040:	83 e8 57             	sub    $0x57,%eax
  801043:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801046:	eb 20                	jmp    801068 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	3c 40                	cmp    $0x40,%al
  80104f:	7e 39                	jle    80108a <strtol+0x126>
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
  801054:	8a 00                	mov    (%eax),%al
  801056:	3c 5a                	cmp    $0x5a,%al
  801058:	7f 30                	jg     80108a <strtol+0x126>
			dig = *s - 'A' + 10;
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	8a 00                	mov    (%eax),%al
  80105f:	0f be c0             	movsbl %al,%eax
  801062:	83 e8 37             	sub    $0x37,%eax
  801065:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80106e:	7d 19                	jge    801089 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801070:	ff 45 08             	incl   0x8(%ebp)
  801073:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801076:	0f af 45 10          	imul   0x10(%ebp),%eax
  80107a:	89 c2                	mov    %eax,%edx
  80107c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80107f:	01 d0                	add    %edx,%eax
  801081:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801084:	e9 7b ff ff ff       	jmp    801004 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801089:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80108a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80108e:	74 08                	je     801098 <strtol+0x134>
		*endptr = (char *) s;
  801090:	8b 45 0c             	mov    0xc(%ebp),%eax
  801093:	8b 55 08             	mov    0x8(%ebp),%edx
  801096:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801098:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80109c:	74 07                	je     8010a5 <strtol+0x141>
  80109e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a1:	f7 d8                	neg    %eax
  8010a3:	eb 03                	jmp    8010a8 <strtol+0x144>
  8010a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010a8:	c9                   	leave  
  8010a9:	c3                   	ret    

008010aa <ltostr>:

void
ltostr(long value, char *str)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c2:	79 13                	jns    8010d7 <ltostr+0x2d>
	{
		neg = 1;
  8010c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ce:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010d1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010d4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010df:	99                   	cltd   
  8010e0:	f7 f9                	idiv   %ecx
  8010e2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e8:	8d 50 01             	lea    0x1(%eax),%edx
  8010eb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010ee:	89 c2                	mov    %eax,%edx
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010f8:	83 c2 30             	add    $0x30,%edx
  8010fb:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801100:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801105:	f7 e9                	imul   %ecx
  801107:	c1 fa 02             	sar    $0x2,%edx
  80110a:	89 c8                	mov    %ecx,%eax
  80110c:	c1 f8 1f             	sar    $0x1f,%eax
  80110f:	29 c2                	sub    %eax,%edx
  801111:	89 d0                	mov    %edx,%eax
  801113:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801116:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801119:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80111e:	f7 e9                	imul   %ecx
  801120:	c1 fa 02             	sar    $0x2,%edx
  801123:	89 c8                	mov    %ecx,%eax
  801125:	c1 f8 1f             	sar    $0x1f,%eax
  801128:	29 c2                	sub    %eax,%edx
  80112a:	89 d0                	mov    %edx,%eax
  80112c:	c1 e0 02             	shl    $0x2,%eax
  80112f:	01 d0                	add    %edx,%eax
  801131:	01 c0                	add    %eax,%eax
  801133:	29 c1                	sub    %eax,%ecx
  801135:	89 ca                	mov    %ecx,%edx
  801137:	85 d2                	test   %edx,%edx
  801139:	75 9c                	jne    8010d7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80113b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801142:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801145:	48                   	dec    %eax
  801146:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801149:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80114d:	74 3d                	je     80118c <ltostr+0xe2>
		start = 1 ;
  80114f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801156:	eb 34                	jmp    80118c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801158:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80115b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115e:	01 d0                	add    %edx,%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801165:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801168:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116b:	01 c2                	add    %eax,%edx
  80116d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801170:	8b 45 0c             	mov    0xc(%ebp),%eax
  801173:	01 c8                	add    %ecx,%eax
  801175:	8a 00                	mov    (%eax),%al
  801177:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801179:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80117c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117f:	01 c2                	add    %eax,%edx
  801181:	8a 45 eb             	mov    -0x15(%ebp),%al
  801184:	88 02                	mov    %al,(%edx)
		start++ ;
  801186:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801189:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80118c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801192:	7c c4                	jl     801158 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801194:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	01 d0                	add    %edx,%eax
  80119c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80119f:	90                   	nop
  8011a0:	c9                   	leave  
  8011a1:	c3                   	ret    

008011a2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
  8011a5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011a8:	ff 75 08             	pushl  0x8(%ebp)
  8011ab:	e8 54 fa ff ff       	call   800c04 <strlen>
  8011b0:	83 c4 04             	add    $0x4,%esp
  8011b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011b6:	ff 75 0c             	pushl  0xc(%ebp)
  8011b9:	e8 46 fa ff ff       	call   800c04 <strlen>
  8011be:	83 c4 04             	add    $0x4,%esp
  8011c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011d2:	eb 17                	jmp    8011eb <strcconcat+0x49>
		final[s] = str1[s] ;
  8011d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011da:	01 c2                	add    %eax,%edx
  8011dc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e2:	01 c8                	add    %ecx,%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011e8:	ff 45 fc             	incl   -0x4(%ebp)
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011f1:	7c e1                	jl     8011d4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011f3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011fa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801201:	eb 1f                	jmp    801222 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801203:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801206:	8d 50 01             	lea    0x1(%eax),%edx
  801209:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80120c:	89 c2                	mov    %eax,%edx
  80120e:	8b 45 10             	mov    0x10(%ebp),%eax
  801211:	01 c2                	add    %eax,%edx
  801213:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801216:	8b 45 0c             	mov    0xc(%ebp),%eax
  801219:	01 c8                	add    %ecx,%eax
  80121b:	8a 00                	mov    (%eax),%al
  80121d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80121f:	ff 45 f8             	incl   -0x8(%ebp)
  801222:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801225:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801228:	7c d9                	jl     801203 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80122a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80122d:	8b 45 10             	mov    0x10(%ebp),%eax
  801230:	01 d0                	add    %edx,%eax
  801232:	c6 00 00             	movb   $0x0,(%eax)
}
  801235:	90                   	nop
  801236:	c9                   	leave  
  801237:	c3                   	ret    

00801238 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80123b:	8b 45 14             	mov    0x14(%ebp),%eax
  80123e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801244:	8b 45 14             	mov    0x14(%ebp),%eax
  801247:	8b 00                	mov    (%eax),%eax
  801249:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801250:	8b 45 10             	mov    0x10(%ebp),%eax
  801253:	01 d0                	add    %edx,%eax
  801255:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80125b:	eb 0c                	jmp    801269 <strsplit+0x31>
			*string++ = 0;
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8d 50 01             	lea    0x1(%eax),%edx
  801263:	89 55 08             	mov    %edx,0x8(%ebp)
  801266:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	8a 00                	mov    (%eax),%al
  80126e:	84 c0                	test   %al,%al
  801270:	74 18                	je     80128a <strsplit+0x52>
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	0f be c0             	movsbl %al,%eax
  80127a:	50                   	push   %eax
  80127b:	ff 75 0c             	pushl  0xc(%ebp)
  80127e:	e8 13 fb ff ff       	call   800d96 <strchr>
  801283:	83 c4 08             	add    $0x8,%esp
  801286:	85 c0                	test   %eax,%eax
  801288:	75 d3                	jne    80125d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	8a 00                	mov    (%eax),%al
  80128f:	84 c0                	test   %al,%al
  801291:	74 5a                	je     8012ed <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	83 f8 0f             	cmp    $0xf,%eax
  80129b:	75 07                	jne    8012a4 <strsplit+0x6c>
		{
			return 0;
  80129d:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a2:	eb 66                	jmp    80130a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a7:	8b 00                	mov    (%eax),%eax
  8012a9:	8d 48 01             	lea    0x1(%eax),%ecx
  8012ac:	8b 55 14             	mov    0x14(%ebp),%edx
  8012af:	89 0a                	mov    %ecx,(%edx)
  8012b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bb:	01 c2                	add    %eax,%edx
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c2:	eb 03                	jmp    8012c7 <strsplit+0x8f>
			string++;
  8012c4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	8a 00                	mov    (%eax),%al
  8012cc:	84 c0                	test   %al,%al
  8012ce:	74 8b                	je     80125b <strsplit+0x23>
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	0f be c0             	movsbl %al,%eax
  8012d8:	50                   	push   %eax
  8012d9:	ff 75 0c             	pushl  0xc(%ebp)
  8012dc:	e8 b5 fa ff ff       	call   800d96 <strchr>
  8012e1:	83 c4 08             	add    $0x8,%esp
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	74 dc                	je     8012c4 <strsplit+0x8c>
			string++;
	}
  8012e8:	e9 6e ff ff ff       	jmp    80125b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012ed:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f1:	8b 00                	mov    (%eax),%eax
  8012f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fd:	01 d0                	add    %edx,%eax
  8012ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801305:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80130a:	c9                   	leave  
  80130b:	c3                   	ret    

0080130c <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801312:	a1 04 40 80 00       	mov    0x804004,%eax
  801317:	85 c0                	test   %eax,%eax
  801319:	74 1f                	je     80133a <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80131b:	e8 1d 00 00 00       	call   80133d <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801320:	83 ec 0c             	sub    $0xc,%esp
  801323:	68 30 39 80 00       	push   $0x803930
  801328:	e8 55 f2 ff ff       	call   800582 <cprintf>
  80132d:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801330:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801337:	00 00 00 
	}
}
  80133a:	90                   	nop
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801343:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80134a:	00 00 00 
  80134d:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801354:	00 00 00 
  801357:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80135e:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801361:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801368:	00 00 00 
  80136b:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801372:	00 00 00 
  801375:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80137c:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  80137f:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801386:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801389:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801398:	2d 00 10 00 00       	sub    $0x1000,%eax
  80139d:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  8013a2:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  8013a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013ac:	a1 20 41 80 00       	mov    0x804120,%eax
  8013b1:	0f af c2             	imul   %edx,%eax
  8013b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  8013b7:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8013be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013c4:	01 d0                	add    %edx,%eax
  8013c6:	48                   	dec    %eax
  8013c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8013ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8013d2:	f7 75 e8             	divl   -0x18(%ebp)
  8013d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013d8:	29 d0                	sub    %edx,%eax
  8013da:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  8013dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013e0:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  8013e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013ea:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8013f0:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8013f6:	83 ec 04             	sub    $0x4,%esp
  8013f9:	6a 06                	push   $0x6
  8013fb:	50                   	push   %eax
  8013fc:	52                   	push   %edx
  8013fd:	e8 a1 05 00 00       	call   8019a3 <sys_allocate_chunk>
  801402:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801405:	a1 20 41 80 00       	mov    0x804120,%eax
  80140a:	83 ec 0c             	sub    $0xc,%esp
  80140d:	50                   	push   %eax
  80140e:	e8 16 0c 00 00       	call   802029 <initialize_MemBlocksList>
  801413:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801416:	a1 4c 41 80 00       	mov    0x80414c,%eax
  80141b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  80141e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801422:	75 14                	jne    801438 <initialize_dyn_block_system+0xfb>
  801424:	83 ec 04             	sub    $0x4,%esp
  801427:	68 55 39 80 00       	push   $0x803955
  80142c:	6a 2d                	push   $0x2d
  80142e:	68 73 39 80 00       	push   $0x803973
  801433:	e8 96 ee ff ff       	call   8002ce <_panic>
  801438:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80143b:	8b 00                	mov    (%eax),%eax
  80143d:	85 c0                	test   %eax,%eax
  80143f:	74 10                	je     801451 <initialize_dyn_block_system+0x114>
  801441:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801444:	8b 00                	mov    (%eax),%eax
  801446:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801449:	8b 52 04             	mov    0x4(%edx),%edx
  80144c:	89 50 04             	mov    %edx,0x4(%eax)
  80144f:	eb 0b                	jmp    80145c <initialize_dyn_block_system+0x11f>
  801451:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801454:	8b 40 04             	mov    0x4(%eax),%eax
  801457:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80145c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80145f:	8b 40 04             	mov    0x4(%eax),%eax
  801462:	85 c0                	test   %eax,%eax
  801464:	74 0f                	je     801475 <initialize_dyn_block_system+0x138>
  801466:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801469:	8b 40 04             	mov    0x4(%eax),%eax
  80146c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80146f:	8b 12                	mov    (%edx),%edx
  801471:	89 10                	mov    %edx,(%eax)
  801473:	eb 0a                	jmp    80147f <initialize_dyn_block_system+0x142>
  801475:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801478:	8b 00                	mov    (%eax),%eax
  80147a:	a3 48 41 80 00       	mov    %eax,0x804148
  80147f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801482:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801488:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80148b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801492:	a1 54 41 80 00       	mov    0x804154,%eax
  801497:	48                   	dec    %eax
  801498:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  80149d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014a0:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  8014a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014aa:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  8014b1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8014b5:	75 14                	jne    8014cb <initialize_dyn_block_system+0x18e>
  8014b7:	83 ec 04             	sub    $0x4,%esp
  8014ba:	68 80 39 80 00       	push   $0x803980
  8014bf:	6a 30                	push   $0x30
  8014c1:	68 73 39 80 00       	push   $0x803973
  8014c6:	e8 03 ee ff ff       	call   8002ce <_panic>
  8014cb:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8014d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014d4:	89 50 04             	mov    %edx,0x4(%eax)
  8014d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014da:	8b 40 04             	mov    0x4(%eax),%eax
  8014dd:	85 c0                	test   %eax,%eax
  8014df:	74 0c                	je     8014ed <initialize_dyn_block_system+0x1b0>
  8014e1:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8014e6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014e9:	89 10                	mov    %edx,(%eax)
  8014eb:	eb 08                	jmp    8014f5 <initialize_dyn_block_system+0x1b8>
  8014ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014f0:	a3 38 41 80 00       	mov    %eax,0x804138
  8014f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014f8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8014fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801500:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801506:	a1 44 41 80 00       	mov    0x804144,%eax
  80150b:	40                   	inc    %eax
  80150c:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801511:	90                   	nop
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80151a:	e8 ed fd ff ff       	call   80130c <InitializeUHeap>
	if (size == 0) return NULL ;
  80151f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801523:	75 07                	jne    80152c <malloc+0x18>
  801525:	b8 00 00 00 00       	mov    $0x0,%eax
  80152a:	eb 67                	jmp    801593 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  80152c:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801533:	8b 55 08             	mov    0x8(%ebp),%edx
  801536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801539:	01 d0                	add    %edx,%eax
  80153b:	48                   	dec    %eax
  80153c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80153f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801542:	ba 00 00 00 00       	mov    $0x0,%edx
  801547:	f7 75 f4             	divl   -0xc(%ebp)
  80154a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154d:	29 d0                	sub    %edx,%eax
  80154f:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801552:	e8 1a 08 00 00       	call   801d71 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801557:	85 c0                	test   %eax,%eax
  801559:	74 33                	je     80158e <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  80155b:	83 ec 0c             	sub    $0xc,%esp
  80155e:	ff 75 08             	pushl  0x8(%ebp)
  801561:	e8 0c 0e 00 00       	call   802372 <alloc_block_FF>
  801566:	83 c4 10             	add    $0x10,%esp
  801569:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  80156c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801570:	74 1c                	je     80158e <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801572:	83 ec 0c             	sub    $0xc,%esp
  801575:	ff 75 ec             	pushl  -0x14(%ebp)
  801578:	e8 07 0c 00 00       	call   802184 <insert_sorted_allocList>
  80157d:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801580:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801583:	8b 40 08             	mov    0x8(%eax),%eax
  801586:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801589:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80158c:	eb 05                	jmp    801593 <malloc+0x7f>
		}
	}
	return NULL;
  80158e:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  80159b:	8b 45 08             	mov    0x8(%ebp),%eax
  80159e:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  8015a1:	83 ec 08             	sub    $0x8,%esp
  8015a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a7:	68 40 40 80 00       	push   $0x804040
  8015ac:	e8 5b 0b 00 00       	call   80210c <find_block>
  8015b1:	83 c4 10             	add    $0x10,%esp
  8015b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  8015b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8015bd:	83 ec 08             	sub    $0x8,%esp
  8015c0:	50                   	push   %eax
  8015c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8015c4:	e8 a2 03 00 00       	call   80196b <sys_free_user_mem>
  8015c9:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  8015cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015d0:	75 14                	jne    8015e6 <free+0x51>
  8015d2:	83 ec 04             	sub    $0x4,%esp
  8015d5:	68 55 39 80 00       	push   $0x803955
  8015da:	6a 76                	push   $0x76
  8015dc:	68 73 39 80 00       	push   $0x803973
  8015e1:	e8 e8 ec ff ff       	call   8002ce <_panic>
  8015e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e9:	8b 00                	mov    (%eax),%eax
  8015eb:	85 c0                	test   %eax,%eax
  8015ed:	74 10                	je     8015ff <free+0x6a>
  8015ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f2:	8b 00                	mov    (%eax),%eax
  8015f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015f7:	8b 52 04             	mov    0x4(%edx),%edx
  8015fa:	89 50 04             	mov    %edx,0x4(%eax)
  8015fd:	eb 0b                	jmp    80160a <free+0x75>
  8015ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801602:	8b 40 04             	mov    0x4(%eax),%eax
  801605:	a3 44 40 80 00       	mov    %eax,0x804044
  80160a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160d:	8b 40 04             	mov    0x4(%eax),%eax
  801610:	85 c0                	test   %eax,%eax
  801612:	74 0f                	je     801623 <free+0x8e>
  801614:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801617:	8b 40 04             	mov    0x4(%eax),%eax
  80161a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80161d:	8b 12                	mov    (%edx),%edx
  80161f:	89 10                	mov    %edx,(%eax)
  801621:	eb 0a                	jmp    80162d <free+0x98>
  801623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801626:	8b 00                	mov    (%eax),%eax
  801628:	a3 40 40 80 00       	mov    %eax,0x804040
  80162d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801630:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801639:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801640:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801645:	48                   	dec    %eax
  801646:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  80164b:	83 ec 0c             	sub    $0xc,%esp
  80164e:	ff 75 f0             	pushl  -0x10(%ebp)
  801651:	e8 0b 14 00 00       	call   802a61 <insert_sorted_with_merge_freeList>
  801656:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801659:	90                   	nop
  80165a:	c9                   	leave  
  80165b:	c3                   	ret    

0080165c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
  80165f:	83 ec 28             	sub    $0x28,%esp
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
  801665:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801668:	e8 9f fc ff ff       	call   80130c <InitializeUHeap>
	if (size == 0) return NULL ;
  80166d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801671:	75 0a                	jne    80167d <smalloc+0x21>
  801673:	b8 00 00 00 00       	mov    $0x0,%eax
  801678:	e9 8d 00 00 00       	jmp    80170a <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  80167d:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801684:	8b 55 0c             	mov    0xc(%ebp),%edx
  801687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168a:	01 d0                	add    %edx,%eax
  80168c:	48                   	dec    %eax
  80168d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801690:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801693:	ba 00 00 00 00       	mov    $0x0,%edx
  801698:	f7 75 f4             	divl   -0xc(%ebp)
  80169b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169e:	29 d0                	sub    %edx,%eax
  8016a0:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016a3:	e8 c9 06 00 00       	call   801d71 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016a8:	85 c0                	test   %eax,%eax
  8016aa:	74 59                	je     801705 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  8016ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  8016b3:	83 ec 0c             	sub    $0xc,%esp
  8016b6:	ff 75 0c             	pushl  0xc(%ebp)
  8016b9:	e8 b4 0c 00 00       	call   802372 <alloc_block_FF>
  8016be:	83 c4 10             	add    $0x10,%esp
  8016c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  8016c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016c8:	75 07                	jne    8016d1 <smalloc+0x75>
			{
				return NULL;
  8016ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8016cf:	eb 39                	jmp    80170a <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  8016d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016d4:	8b 40 08             	mov    0x8(%eax),%eax
  8016d7:	89 c2                	mov    %eax,%edx
  8016d9:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8016dd:	52                   	push   %edx
  8016de:	50                   	push   %eax
  8016df:	ff 75 0c             	pushl  0xc(%ebp)
  8016e2:	ff 75 08             	pushl  0x8(%ebp)
  8016e5:	e8 0c 04 00 00       	call   801af6 <sys_createSharedObject>
  8016ea:	83 c4 10             	add    $0x10,%esp
  8016ed:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  8016f0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016f4:	78 08                	js     8016fe <smalloc+0xa2>
				{
					return (void*)v1->sva;
  8016f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f9:	8b 40 08             	mov    0x8(%eax),%eax
  8016fc:	eb 0c                	jmp    80170a <smalloc+0xae>
				}
				else
				{
					return NULL;
  8016fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801703:	eb 05                	jmp    80170a <smalloc+0xae>
				}
			}

		}
		return NULL;
  801705:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80170a:	c9                   	leave  
  80170b:	c3                   	ret    

0080170c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801712:	e8 f5 fb ff ff       	call   80130c <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801717:	83 ec 08             	sub    $0x8,%esp
  80171a:	ff 75 0c             	pushl  0xc(%ebp)
  80171d:	ff 75 08             	pushl  0x8(%ebp)
  801720:	e8 fb 03 00 00       	call   801b20 <sys_getSizeOfSharedObject>
  801725:	83 c4 10             	add    $0x10,%esp
  801728:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  80172b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80172f:	75 07                	jne    801738 <sget+0x2c>
	{
		return NULL;
  801731:	b8 00 00 00 00       	mov    $0x0,%eax
  801736:	eb 64                	jmp    80179c <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801738:	e8 34 06 00 00       	call   801d71 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80173d:	85 c0                	test   %eax,%eax
  80173f:	74 56                	je     801797 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801741:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174b:	83 ec 0c             	sub    $0xc,%esp
  80174e:	50                   	push   %eax
  80174f:	e8 1e 0c 00 00       	call   802372 <alloc_block_FF>
  801754:	83 c4 10             	add    $0x10,%esp
  801757:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  80175a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80175e:	75 07                	jne    801767 <sget+0x5b>
		{
		return NULL;
  801760:	b8 00 00 00 00       	mov    $0x0,%eax
  801765:	eb 35                	jmp    80179c <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801767:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176a:	8b 40 08             	mov    0x8(%eax),%eax
  80176d:	83 ec 04             	sub    $0x4,%esp
  801770:	50                   	push   %eax
  801771:	ff 75 0c             	pushl  0xc(%ebp)
  801774:	ff 75 08             	pushl  0x8(%ebp)
  801777:	e8 c1 03 00 00       	call   801b3d <sys_getSharedObject>
  80177c:	83 c4 10             	add    $0x10,%esp
  80177f:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801782:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801786:	78 08                	js     801790 <sget+0x84>
			{
				return (void*)v1->sva;
  801788:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178b:	8b 40 08             	mov    0x8(%eax),%eax
  80178e:	eb 0c                	jmp    80179c <sget+0x90>
			}
			else
			{
				return NULL;
  801790:	b8 00 00 00 00       	mov    $0x0,%eax
  801795:	eb 05                	jmp    80179c <sget+0x90>
			}
		}
	}
  return NULL;
  801797:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80179c:	c9                   	leave  
  80179d:	c3                   	ret    

0080179e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
  8017a1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017a4:	e8 63 fb ff ff       	call   80130c <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017a9:	83 ec 04             	sub    $0x4,%esp
  8017ac:	68 a4 39 80 00       	push   $0x8039a4
  8017b1:	68 0e 01 00 00       	push   $0x10e
  8017b6:	68 73 39 80 00       	push   $0x803973
  8017bb:	e8 0e eb ff ff       	call   8002ce <_panic>

008017c0 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017c6:	83 ec 04             	sub    $0x4,%esp
  8017c9:	68 cc 39 80 00       	push   $0x8039cc
  8017ce:	68 22 01 00 00       	push   $0x122
  8017d3:	68 73 39 80 00       	push   $0x803973
  8017d8:	e8 f1 ea ff ff       	call   8002ce <_panic>

008017dd <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
  8017e0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e3:	83 ec 04             	sub    $0x4,%esp
  8017e6:	68 f0 39 80 00       	push   $0x8039f0
  8017eb:	68 2d 01 00 00       	push   $0x12d
  8017f0:	68 73 39 80 00       	push   $0x803973
  8017f5:	e8 d4 ea ff ff       	call   8002ce <_panic>

008017fa <shrink>:

}
void shrink(uint32 newSize)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801800:	83 ec 04             	sub    $0x4,%esp
  801803:	68 f0 39 80 00       	push   $0x8039f0
  801808:	68 32 01 00 00       	push   $0x132
  80180d:	68 73 39 80 00       	push   $0x803973
  801812:	e8 b7 ea ff ff       	call   8002ce <_panic>

00801817 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80181d:	83 ec 04             	sub    $0x4,%esp
  801820:	68 f0 39 80 00       	push   $0x8039f0
  801825:	68 37 01 00 00       	push   $0x137
  80182a:	68 73 39 80 00       	push   $0x803973
  80182f:	e8 9a ea ff ff       	call   8002ce <_panic>

00801834 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	57                   	push   %edi
  801838:	56                   	push   %esi
  801839:	53                   	push   %ebx
  80183a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	8b 55 0c             	mov    0xc(%ebp),%edx
  801843:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801846:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801849:	8b 7d 18             	mov    0x18(%ebp),%edi
  80184c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80184f:	cd 30                	int    $0x30
  801851:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801854:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801857:	83 c4 10             	add    $0x10,%esp
  80185a:	5b                   	pop    %ebx
  80185b:	5e                   	pop    %esi
  80185c:	5f                   	pop    %edi
  80185d:	5d                   	pop    %ebp
  80185e:	c3                   	ret    

0080185f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	83 ec 04             	sub    $0x4,%esp
  801865:	8b 45 10             	mov    0x10(%ebp),%eax
  801868:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80186b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80186f:	8b 45 08             	mov    0x8(%ebp),%eax
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	52                   	push   %edx
  801877:	ff 75 0c             	pushl  0xc(%ebp)
  80187a:	50                   	push   %eax
  80187b:	6a 00                	push   $0x0
  80187d:	e8 b2 ff ff ff       	call   801834 <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
}
  801885:	90                   	nop
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <sys_cgetc>:

int
sys_cgetc(void)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 01                	push   $0x1
  801897:	e8 98 ff ff ff       	call   801834 <syscall>
  80189c:	83 c4 18             	add    $0x18,%esp
}
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	52                   	push   %edx
  8018b1:	50                   	push   %eax
  8018b2:	6a 05                	push   $0x5
  8018b4:	e8 7b ff ff ff       	call   801834 <syscall>
  8018b9:	83 c4 18             	add    $0x18,%esp
}
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	56                   	push   %esi
  8018c2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018c3:	8b 75 18             	mov    0x18(%ebp),%esi
  8018c6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d2:	56                   	push   %esi
  8018d3:	53                   	push   %ebx
  8018d4:	51                   	push   %ecx
  8018d5:	52                   	push   %edx
  8018d6:	50                   	push   %eax
  8018d7:	6a 06                	push   $0x6
  8018d9:	e8 56 ff ff ff       	call   801834 <syscall>
  8018de:	83 c4 18             	add    $0x18,%esp
}
  8018e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e4:	5b                   	pop    %ebx
  8018e5:	5e                   	pop    %esi
  8018e6:	5d                   	pop    %ebp
  8018e7:	c3                   	ret    

008018e8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	52                   	push   %edx
  8018f8:	50                   	push   %eax
  8018f9:	6a 07                	push   $0x7
  8018fb:	e8 34 ff ff ff       	call   801834 <syscall>
  801900:	83 c4 18             	add    $0x18,%esp
}
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	ff 75 0c             	pushl  0xc(%ebp)
  801911:	ff 75 08             	pushl  0x8(%ebp)
  801914:	6a 08                	push   $0x8
  801916:	e8 19 ff ff ff       	call   801834 <syscall>
  80191b:	83 c4 18             	add    $0x18,%esp
}
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 09                	push   $0x9
  80192f:	e8 00 ff ff ff       	call   801834 <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 0a                	push   $0xa
  801948:	e8 e7 fe ff ff       	call   801834 <syscall>
  80194d:	83 c4 18             	add    $0x18,%esp
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 0b                	push   $0xb
  801961:	e8 ce fe ff ff       	call   801834 <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	ff 75 0c             	pushl  0xc(%ebp)
  801977:	ff 75 08             	pushl  0x8(%ebp)
  80197a:	6a 0f                	push   $0xf
  80197c:	e8 b3 fe ff ff       	call   801834 <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
	return;
  801984:	90                   	nop
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	ff 75 0c             	pushl  0xc(%ebp)
  801993:	ff 75 08             	pushl  0x8(%ebp)
  801996:	6a 10                	push   $0x10
  801998:	e8 97 fe ff ff       	call   801834 <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a0:	90                   	nop
}
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	ff 75 10             	pushl  0x10(%ebp)
  8019ad:	ff 75 0c             	pushl  0xc(%ebp)
  8019b0:	ff 75 08             	pushl  0x8(%ebp)
  8019b3:	6a 11                	push   $0x11
  8019b5:	e8 7a fe ff ff       	call   801834 <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8019bd:	90                   	nop
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 0c                	push   $0xc
  8019cf:	e8 60 fe ff ff       	call   801834 <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	ff 75 08             	pushl  0x8(%ebp)
  8019e7:	6a 0d                	push   $0xd
  8019e9:	e8 46 fe ff ff       	call   801834 <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 0e                	push   $0xe
  801a02:	e8 2d fe ff ff       	call   801834 <syscall>
  801a07:	83 c4 18             	add    $0x18,%esp
}
  801a0a:	90                   	nop
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 13                	push   $0x13
  801a1c:	e8 13 fe ff ff       	call   801834 <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
}
  801a24:	90                   	nop
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 14                	push   $0x14
  801a36:	e8 f9 fd ff ff       	call   801834 <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
}
  801a3e:	90                   	nop
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
  801a44:	83 ec 04             	sub    $0x4,%esp
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a4d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	50                   	push   %eax
  801a5a:	6a 15                	push   $0x15
  801a5c:	e8 d3 fd ff ff       	call   801834 <syscall>
  801a61:	83 c4 18             	add    $0x18,%esp
}
  801a64:	90                   	nop
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 16                	push   $0x16
  801a76:	e8 b9 fd ff ff       	call   801834 <syscall>
  801a7b:	83 c4 18             	add    $0x18,%esp
}
  801a7e:	90                   	nop
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a84:	8b 45 08             	mov    0x8(%ebp),%eax
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	ff 75 0c             	pushl  0xc(%ebp)
  801a90:	50                   	push   %eax
  801a91:	6a 17                	push   $0x17
  801a93:	e8 9c fd ff ff       	call   801834 <syscall>
  801a98:	83 c4 18             	add    $0x18,%esp
}
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	52                   	push   %edx
  801aad:	50                   	push   %eax
  801aae:	6a 1a                	push   $0x1a
  801ab0:	e8 7f fd ff ff       	call   801834 <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
}
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801abd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	52                   	push   %edx
  801aca:	50                   	push   %eax
  801acb:	6a 18                	push   $0x18
  801acd:	e8 62 fd ff ff       	call   801834 <syscall>
  801ad2:	83 c4 18             	add    $0x18,%esp
}
  801ad5:	90                   	nop
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801adb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ade:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	52                   	push   %edx
  801ae8:	50                   	push   %eax
  801ae9:	6a 19                	push   $0x19
  801aeb:	e8 44 fd ff ff       	call   801834 <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
}
  801af3:	90                   	nop
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	83 ec 04             	sub    $0x4,%esp
  801afc:	8b 45 10             	mov    0x10(%ebp),%eax
  801aff:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b02:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b05:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	6a 00                	push   $0x0
  801b0e:	51                   	push   %ecx
  801b0f:	52                   	push   %edx
  801b10:	ff 75 0c             	pushl  0xc(%ebp)
  801b13:	50                   	push   %eax
  801b14:	6a 1b                	push   $0x1b
  801b16:	e8 19 fd ff ff       	call   801834 <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	52                   	push   %edx
  801b30:	50                   	push   %eax
  801b31:	6a 1c                	push   $0x1c
  801b33:	e8 fc fc ff ff       	call   801834 <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b40:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	51                   	push   %ecx
  801b4e:	52                   	push   %edx
  801b4f:	50                   	push   %eax
  801b50:	6a 1d                	push   $0x1d
  801b52:	e8 dd fc ff ff       	call   801834 <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
}
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    

00801b5c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b62:	8b 45 08             	mov    0x8(%ebp),%eax
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	52                   	push   %edx
  801b6c:	50                   	push   %eax
  801b6d:	6a 1e                	push   $0x1e
  801b6f:	e8 c0 fc ff ff       	call   801834 <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
}
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 1f                	push   $0x1f
  801b88:	e8 a7 fc ff ff       	call   801834 <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b95:	8b 45 08             	mov    0x8(%ebp),%eax
  801b98:	6a 00                	push   $0x0
  801b9a:	ff 75 14             	pushl  0x14(%ebp)
  801b9d:	ff 75 10             	pushl  0x10(%ebp)
  801ba0:	ff 75 0c             	pushl  0xc(%ebp)
  801ba3:	50                   	push   %eax
  801ba4:	6a 20                	push   $0x20
  801ba6:	e8 89 fc ff ff       	call   801834 <syscall>
  801bab:	83 c4 18             	add    $0x18,%esp
}
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	50                   	push   %eax
  801bbf:	6a 21                	push   $0x21
  801bc1:	e8 6e fc ff ff       	call   801834 <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
}
  801bc9:	90                   	nop
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	50                   	push   %eax
  801bdb:	6a 22                	push   $0x22
  801bdd:	e8 52 fc ff ff       	call   801834 <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 02                	push   $0x2
  801bf6:	e8 39 fc ff ff       	call   801834 <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 03                	push   $0x3
  801c0f:	e8 20 fc ff ff       	call   801834 <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
}
  801c17:	c9                   	leave  
  801c18:	c3                   	ret    

00801c19 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 04                	push   $0x4
  801c28:	e8 07 fc ff ff       	call   801834 <syscall>
  801c2d:	83 c4 18             	add    $0x18,%esp
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <sys_exit_env>:


void sys_exit_env(void)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 23                	push   $0x23
  801c41:	e8 ee fb ff ff       	call   801834 <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
}
  801c49:	90                   	nop
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
  801c4f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c52:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c55:	8d 50 04             	lea    0x4(%eax),%edx
  801c58:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	52                   	push   %edx
  801c62:	50                   	push   %eax
  801c63:	6a 24                	push   $0x24
  801c65:	e8 ca fb ff ff       	call   801834 <syscall>
  801c6a:	83 c4 18             	add    $0x18,%esp
	return result;
  801c6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c70:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c73:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c76:	89 01                	mov    %eax,(%ecx)
  801c78:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7e:	c9                   	leave  
  801c7f:	c2 04 00             	ret    $0x4

00801c82 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	ff 75 10             	pushl  0x10(%ebp)
  801c8c:	ff 75 0c             	pushl  0xc(%ebp)
  801c8f:	ff 75 08             	pushl  0x8(%ebp)
  801c92:	6a 12                	push   $0x12
  801c94:	e8 9b fb ff ff       	call   801834 <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9c:	90                   	nop
}
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <sys_rcr2>:
uint32 sys_rcr2()
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 25                	push   $0x25
  801cae:	e8 81 fb ff ff       	call   801834 <syscall>
  801cb3:	83 c4 18             	add    $0x18,%esp
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	83 ec 04             	sub    $0x4,%esp
  801cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cc4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	50                   	push   %eax
  801cd1:	6a 26                	push   $0x26
  801cd3:	e8 5c fb ff ff       	call   801834 <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdb:	90                   	nop
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <rsttst>:
void rsttst()
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 28                	push   $0x28
  801ced:	e8 42 fb ff ff       	call   801834 <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf5:	90                   	nop
}
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
  801cfb:	83 ec 04             	sub    $0x4,%esp
  801cfe:	8b 45 14             	mov    0x14(%ebp),%eax
  801d01:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d04:	8b 55 18             	mov    0x18(%ebp),%edx
  801d07:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d0b:	52                   	push   %edx
  801d0c:	50                   	push   %eax
  801d0d:	ff 75 10             	pushl  0x10(%ebp)
  801d10:	ff 75 0c             	pushl  0xc(%ebp)
  801d13:	ff 75 08             	pushl  0x8(%ebp)
  801d16:	6a 27                	push   $0x27
  801d18:	e8 17 fb ff ff       	call   801834 <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d20:	90                   	nop
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <chktst>:
void chktst(uint32 n)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	ff 75 08             	pushl  0x8(%ebp)
  801d31:	6a 29                	push   $0x29
  801d33:	e8 fc fa ff ff       	call   801834 <syscall>
  801d38:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3b:	90                   	nop
}
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <inctst>:

void inctst()
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 2a                	push   $0x2a
  801d4d:	e8 e2 fa ff ff       	call   801834 <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
	return ;
  801d55:	90                   	nop
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <gettst>:
uint32 gettst()
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 2b                	push   $0x2b
  801d67:	e8 c8 fa ff ff       	call   801834 <syscall>
  801d6c:	83 c4 18             	add    $0x18,%esp
}
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 2c                	push   $0x2c
  801d83:	e8 ac fa ff ff       	call   801834 <syscall>
  801d88:	83 c4 18             	add    $0x18,%esp
  801d8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d8e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d92:	75 07                	jne    801d9b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d94:	b8 01 00 00 00       	mov    $0x1,%eax
  801d99:	eb 05                	jmp    801da0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
  801da5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 2c                	push   $0x2c
  801db4:	e8 7b fa ff ff       	call   801834 <syscall>
  801db9:	83 c4 18             	add    $0x18,%esp
  801dbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dbf:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dc3:	75 07                	jne    801dcc <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dc5:	b8 01 00 00 00       	mov    $0x1,%eax
  801dca:	eb 05                	jmp    801dd1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 2c                	push   $0x2c
  801de5:	e8 4a fa ff ff       	call   801834 <syscall>
  801dea:	83 c4 18             	add    $0x18,%esp
  801ded:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801df0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801df4:	75 07                	jne    801dfd <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801df6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfb:	eb 05                	jmp    801e02 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
  801e07:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 2c                	push   $0x2c
  801e16:	e8 19 fa ff ff       	call   801834 <syscall>
  801e1b:	83 c4 18             	add    $0x18,%esp
  801e1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e21:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e25:	75 07                	jne    801e2e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e27:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2c:	eb 05                	jmp    801e33 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	ff 75 08             	pushl  0x8(%ebp)
  801e43:	6a 2d                	push   $0x2d
  801e45:	e8 ea f9 ff ff       	call   801834 <syscall>
  801e4a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4d:	90                   	nop
}
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e54:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e57:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	6a 00                	push   $0x0
  801e62:	53                   	push   %ebx
  801e63:	51                   	push   %ecx
  801e64:	52                   	push   %edx
  801e65:	50                   	push   %eax
  801e66:	6a 2e                	push   $0x2e
  801e68:	e8 c7 f9 ff ff       	call   801834 <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
}
  801e70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e73:	c9                   	leave  
  801e74:	c3                   	ret    

00801e75 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	52                   	push   %edx
  801e85:	50                   	push   %eax
  801e86:	6a 2f                	push   $0x2f
  801e88:	e8 a7 f9 ff ff       	call   801834 <syscall>
  801e8d:	83 c4 18             	add    $0x18,%esp
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e98:	83 ec 0c             	sub    $0xc,%esp
  801e9b:	68 00 3a 80 00       	push   $0x803a00
  801ea0:	e8 dd e6 ff ff       	call   800582 <cprintf>
  801ea5:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ea8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801eaf:	83 ec 0c             	sub    $0xc,%esp
  801eb2:	68 2c 3a 80 00       	push   $0x803a2c
  801eb7:	e8 c6 e6 ff ff       	call   800582 <cprintf>
  801ebc:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ebf:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ec3:	a1 38 41 80 00       	mov    0x804138,%eax
  801ec8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ecb:	eb 56                	jmp    801f23 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ecd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ed1:	74 1c                	je     801eef <print_mem_block_lists+0x5d>
  801ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed6:	8b 50 08             	mov    0x8(%eax),%edx
  801ed9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801edc:	8b 48 08             	mov    0x8(%eax),%ecx
  801edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee5:	01 c8                	add    %ecx,%eax
  801ee7:	39 c2                	cmp    %eax,%edx
  801ee9:	73 04                	jae    801eef <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801eeb:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef2:	8b 50 08             	mov    0x8(%eax),%edx
  801ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef8:	8b 40 0c             	mov    0xc(%eax),%eax
  801efb:	01 c2                	add    %eax,%edx
  801efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f00:	8b 40 08             	mov    0x8(%eax),%eax
  801f03:	83 ec 04             	sub    $0x4,%esp
  801f06:	52                   	push   %edx
  801f07:	50                   	push   %eax
  801f08:	68 41 3a 80 00       	push   $0x803a41
  801f0d:	e8 70 e6 ff ff       	call   800582 <cprintf>
  801f12:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f18:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f1b:	a1 40 41 80 00       	mov    0x804140,%eax
  801f20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f27:	74 07                	je     801f30 <print_mem_block_lists+0x9e>
  801f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2c:	8b 00                	mov    (%eax),%eax
  801f2e:	eb 05                	jmp    801f35 <print_mem_block_lists+0xa3>
  801f30:	b8 00 00 00 00       	mov    $0x0,%eax
  801f35:	a3 40 41 80 00       	mov    %eax,0x804140
  801f3a:	a1 40 41 80 00       	mov    0x804140,%eax
  801f3f:	85 c0                	test   %eax,%eax
  801f41:	75 8a                	jne    801ecd <print_mem_block_lists+0x3b>
  801f43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f47:	75 84                	jne    801ecd <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f49:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f4d:	75 10                	jne    801f5f <print_mem_block_lists+0xcd>
  801f4f:	83 ec 0c             	sub    $0xc,%esp
  801f52:	68 50 3a 80 00       	push   $0x803a50
  801f57:	e8 26 e6 ff ff       	call   800582 <cprintf>
  801f5c:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f5f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f66:	83 ec 0c             	sub    $0xc,%esp
  801f69:	68 74 3a 80 00       	push   $0x803a74
  801f6e:	e8 0f e6 ff ff       	call   800582 <cprintf>
  801f73:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f76:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f7a:	a1 40 40 80 00       	mov    0x804040,%eax
  801f7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f82:	eb 56                	jmp    801fda <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f84:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f88:	74 1c                	je     801fa6 <print_mem_block_lists+0x114>
  801f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8d:	8b 50 08             	mov    0x8(%eax),%edx
  801f90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f93:	8b 48 08             	mov    0x8(%eax),%ecx
  801f96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f99:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9c:	01 c8                	add    %ecx,%eax
  801f9e:	39 c2                	cmp    %eax,%edx
  801fa0:	73 04                	jae    801fa6 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fa2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa9:	8b 50 08             	mov    0x8(%eax),%edx
  801fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801faf:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb2:	01 c2                	add    %eax,%edx
  801fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb7:	8b 40 08             	mov    0x8(%eax),%eax
  801fba:	83 ec 04             	sub    $0x4,%esp
  801fbd:	52                   	push   %edx
  801fbe:	50                   	push   %eax
  801fbf:	68 41 3a 80 00       	push   $0x803a41
  801fc4:	e8 b9 e5 ff ff       	call   800582 <cprintf>
  801fc9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fd2:	a1 48 40 80 00       	mov    0x804048,%eax
  801fd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fde:	74 07                	je     801fe7 <print_mem_block_lists+0x155>
  801fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe3:	8b 00                	mov    (%eax),%eax
  801fe5:	eb 05                	jmp    801fec <print_mem_block_lists+0x15a>
  801fe7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fec:	a3 48 40 80 00       	mov    %eax,0x804048
  801ff1:	a1 48 40 80 00       	mov    0x804048,%eax
  801ff6:	85 c0                	test   %eax,%eax
  801ff8:	75 8a                	jne    801f84 <print_mem_block_lists+0xf2>
  801ffa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ffe:	75 84                	jne    801f84 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802000:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802004:	75 10                	jne    802016 <print_mem_block_lists+0x184>
  802006:	83 ec 0c             	sub    $0xc,%esp
  802009:	68 8c 3a 80 00       	push   $0x803a8c
  80200e:	e8 6f e5 ff ff       	call   800582 <cprintf>
  802013:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802016:	83 ec 0c             	sub    $0xc,%esp
  802019:	68 00 3a 80 00       	push   $0x803a00
  80201e:	e8 5f e5 ff ff       	call   800582 <cprintf>
  802023:	83 c4 10             	add    $0x10,%esp

}
  802026:	90                   	nop
  802027:	c9                   	leave  
  802028:	c3                   	ret    

00802029 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
  80202c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  80202f:	8b 45 08             	mov    0x8(%ebp),%eax
  802032:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  802035:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80203c:	00 00 00 
  80203f:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802046:	00 00 00 
  802049:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802050:	00 00 00 
	for(int i = 0; i<n;i++)
  802053:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80205a:	e9 9e 00 00 00       	jmp    8020fd <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80205f:	a1 50 40 80 00       	mov    0x804050,%eax
  802064:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802067:	c1 e2 04             	shl    $0x4,%edx
  80206a:	01 d0                	add    %edx,%eax
  80206c:	85 c0                	test   %eax,%eax
  80206e:	75 14                	jne    802084 <initialize_MemBlocksList+0x5b>
  802070:	83 ec 04             	sub    $0x4,%esp
  802073:	68 b4 3a 80 00       	push   $0x803ab4
  802078:	6a 47                	push   $0x47
  80207a:	68 d7 3a 80 00       	push   $0x803ad7
  80207f:	e8 4a e2 ff ff       	call   8002ce <_panic>
  802084:	a1 50 40 80 00       	mov    0x804050,%eax
  802089:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80208c:	c1 e2 04             	shl    $0x4,%edx
  80208f:	01 d0                	add    %edx,%eax
  802091:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802097:	89 10                	mov    %edx,(%eax)
  802099:	8b 00                	mov    (%eax),%eax
  80209b:	85 c0                	test   %eax,%eax
  80209d:	74 18                	je     8020b7 <initialize_MemBlocksList+0x8e>
  80209f:	a1 48 41 80 00       	mov    0x804148,%eax
  8020a4:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020aa:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020ad:	c1 e1 04             	shl    $0x4,%ecx
  8020b0:	01 ca                	add    %ecx,%edx
  8020b2:	89 50 04             	mov    %edx,0x4(%eax)
  8020b5:	eb 12                	jmp    8020c9 <initialize_MemBlocksList+0xa0>
  8020b7:	a1 50 40 80 00       	mov    0x804050,%eax
  8020bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020bf:	c1 e2 04             	shl    $0x4,%edx
  8020c2:	01 d0                	add    %edx,%eax
  8020c4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020c9:	a1 50 40 80 00       	mov    0x804050,%eax
  8020ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d1:	c1 e2 04             	shl    $0x4,%edx
  8020d4:	01 d0                	add    %edx,%eax
  8020d6:	a3 48 41 80 00       	mov    %eax,0x804148
  8020db:	a1 50 40 80 00       	mov    0x804050,%eax
  8020e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e3:	c1 e2 04             	shl    $0x4,%edx
  8020e6:	01 d0                	add    %edx,%eax
  8020e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020ef:	a1 54 41 80 00       	mov    0x804154,%eax
  8020f4:	40                   	inc    %eax
  8020f5:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8020fa:	ff 45 f4             	incl   -0xc(%ebp)
  8020fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802100:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802103:	0f 82 56 ff ff ff    	jb     80205f <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  802109:	90                   	nop
  80210a:	c9                   	leave  
  80210b:	c3                   	ret    

0080210c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
  80210f:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  802112:	8b 45 0c             	mov    0xc(%ebp),%eax
  802115:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  802118:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80211f:	a1 40 40 80 00       	mov    0x804040,%eax
  802124:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802127:	eb 23                	jmp    80214c <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802129:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80212c:	8b 40 08             	mov    0x8(%eax),%eax
  80212f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802132:	75 09                	jne    80213d <find_block+0x31>
		{
			found = 1;
  802134:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  80213b:	eb 35                	jmp    802172 <find_block+0x66>
		}
		else
		{
			found = 0;
  80213d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802144:	a1 48 40 80 00       	mov    0x804048,%eax
  802149:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80214c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802150:	74 07                	je     802159 <find_block+0x4d>
  802152:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802155:	8b 00                	mov    (%eax),%eax
  802157:	eb 05                	jmp    80215e <find_block+0x52>
  802159:	b8 00 00 00 00       	mov    $0x0,%eax
  80215e:	a3 48 40 80 00       	mov    %eax,0x804048
  802163:	a1 48 40 80 00       	mov    0x804048,%eax
  802168:	85 c0                	test   %eax,%eax
  80216a:	75 bd                	jne    802129 <find_block+0x1d>
  80216c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802170:	75 b7                	jne    802129 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802172:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802176:	75 05                	jne    80217d <find_block+0x71>
	{
		return blk;
  802178:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80217b:	eb 05                	jmp    802182 <find_block+0x76>
	}
	else
	{
		return NULL;
  80217d:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
  802187:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802190:	a1 40 40 80 00       	mov    0x804040,%eax
  802195:	85 c0                	test   %eax,%eax
  802197:	74 12                	je     8021ab <insert_sorted_allocList+0x27>
  802199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219c:	8b 50 08             	mov    0x8(%eax),%edx
  80219f:	a1 40 40 80 00       	mov    0x804040,%eax
  8021a4:	8b 40 08             	mov    0x8(%eax),%eax
  8021a7:	39 c2                	cmp    %eax,%edx
  8021a9:	73 65                	jae    802210 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  8021ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021af:	75 14                	jne    8021c5 <insert_sorted_allocList+0x41>
  8021b1:	83 ec 04             	sub    $0x4,%esp
  8021b4:	68 b4 3a 80 00       	push   $0x803ab4
  8021b9:	6a 7b                	push   $0x7b
  8021bb:	68 d7 3a 80 00       	push   $0x803ad7
  8021c0:	e8 09 e1 ff ff       	call   8002ce <_panic>
  8021c5:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ce:	89 10                	mov    %edx,(%eax)
  8021d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d3:	8b 00                	mov    (%eax),%eax
  8021d5:	85 c0                	test   %eax,%eax
  8021d7:	74 0d                	je     8021e6 <insert_sorted_allocList+0x62>
  8021d9:	a1 40 40 80 00       	mov    0x804040,%eax
  8021de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021e1:	89 50 04             	mov    %edx,0x4(%eax)
  8021e4:	eb 08                	jmp    8021ee <insert_sorted_allocList+0x6a>
  8021e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e9:	a3 44 40 80 00       	mov    %eax,0x804044
  8021ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f1:	a3 40 40 80 00       	mov    %eax,0x804040
  8021f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802200:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802205:	40                   	inc    %eax
  802206:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80220b:	e9 5f 01 00 00       	jmp    80236f <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  802210:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802213:	8b 50 08             	mov    0x8(%eax),%edx
  802216:	a1 44 40 80 00       	mov    0x804044,%eax
  80221b:	8b 40 08             	mov    0x8(%eax),%eax
  80221e:	39 c2                	cmp    %eax,%edx
  802220:	76 65                	jbe    802287 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802222:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802226:	75 14                	jne    80223c <insert_sorted_allocList+0xb8>
  802228:	83 ec 04             	sub    $0x4,%esp
  80222b:	68 f0 3a 80 00       	push   $0x803af0
  802230:	6a 7f                	push   $0x7f
  802232:	68 d7 3a 80 00       	push   $0x803ad7
  802237:	e8 92 e0 ff ff       	call   8002ce <_panic>
  80223c:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802242:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802245:	89 50 04             	mov    %edx,0x4(%eax)
  802248:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80224b:	8b 40 04             	mov    0x4(%eax),%eax
  80224e:	85 c0                	test   %eax,%eax
  802250:	74 0c                	je     80225e <insert_sorted_allocList+0xda>
  802252:	a1 44 40 80 00       	mov    0x804044,%eax
  802257:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80225a:	89 10                	mov    %edx,(%eax)
  80225c:	eb 08                	jmp    802266 <insert_sorted_allocList+0xe2>
  80225e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802261:	a3 40 40 80 00       	mov    %eax,0x804040
  802266:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802269:	a3 44 40 80 00       	mov    %eax,0x804044
  80226e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802271:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802277:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80227c:	40                   	inc    %eax
  80227d:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802282:	e9 e8 00 00 00       	jmp    80236f <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802287:	a1 40 40 80 00       	mov    0x804040,%eax
  80228c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80228f:	e9 ab 00 00 00       	jmp    80233f <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802297:	8b 00                	mov    (%eax),%eax
  802299:	85 c0                	test   %eax,%eax
  80229b:	0f 84 96 00 00 00    	je     802337 <insert_sorted_allocList+0x1b3>
  8022a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a4:	8b 50 08             	mov    0x8(%eax),%edx
  8022a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022aa:	8b 40 08             	mov    0x8(%eax),%eax
  8022ad:	39 c2                	cmp    %eax,%edx
  8022af:	0f 86 82 00 00 00    	jbe    802337 <insert_sorted_allocList+0x1b3>
  8022b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b8:	8b 50 08             	mov    0x8(%eax),%edx
  8022bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022be:	8b 00                	mov    (%eax),%eax
  8022c0:	8b 40 08             	mov    0x8(%eax),%eax
  8022c3:	39 c2                	cmp    %eax,%edx
  8022c5:	73 70                	jae    802337 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  8022c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022cb:	74 06                	je     8022d3 <insert_sorted_allocList+0x14f>
  8022cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022d1:	75 17                	jne    8022ea <insert_sorted_allocList+0x166>
  8022d3:	83 ec 04             	sub    $0x4,%esp
  8022d6:	68 14 3b 80 00       	push   $0x803b14
  8022db:	68 87 00 00 00       	push   $0x87
  8022e0:	68 d7 3a 80 00       	push   $0x803ad7
  8022e5:	e8 e4 df ff ff       	call   8002ce <_panic>
  8022ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ed:	8b 10                	mov    (%eax),%edx
  8022ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f2:	89 10                	mov    %edx,(%eax)
  8022f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f7:	8b 00                	mov    (%eax),%eax
  8022f9:	85 c0                	test   %eax,%eax
  8022fb:	74 0b                	je     802308 <insert_sorted_allocList+0x184>
  8022fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802300:	8b 00                	mov    (%eax),%eax
  802302:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802305:	89 50 04             	mov    %edx,0x4(%eax)
  802308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80230e:	89 10                	mov    %edx,(%eax)
  802310:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802313:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802316:	89 50 04             	mov    %edx,0x4(%eax)
  802319:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231c:	8b 00                	mov    (%eax),%eax
  80231e:	85 c0                	test   %eax,%eax
  802320:	75 08                	jne    80232a <insert_sorted_allocList+0x1a6>
  802322:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802325:	a3 44 40 80 00       	mov    %eax,0x804044
  80232a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80232f:	40                   	inc    %eax
  802330:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802335:	eb 38                	jmp    80236f <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802337:	a1 48 40 80 00       	mov    0x804048,%eax
  80233c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80233f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802343:	74 07                	je     80234c <insert_sorted_allocList+0x1c8>
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	8b 00                	mov    (%eax),%eax
  80234a:	eb 05                	jmp    802351 <insert_sorted_allocList+0x1cd>
  80234c:	b8 00 00 00 00       	mov    $0x0,%eax
  802351:	a3 48 40 80 00       	mov    %eax,0x804048
  802356:	a1 48 40 80 00       	mov    0x804048,%eax
  80235b:	85 c0                	test   %eax,%eax
  80235d:	0f 85 31 ff ff ff    	jne    802294 <insert_sorted_allocList+0x110>
  802363:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802367:	0f 85 27 ff ff ff    	jne    802294 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80236d:	eb 00                	jmp    80236f <insert_sorted_allocList+0x1eb>
  80236f:	90                   	nop
  802370:	c9                   	leave  
  802371:	c3                   	ret    

00802372 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802372:	55                   	push   %ebp
  802373:	89 e5                	mov    %esp,%ebp
  802375:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802378:	8b 45 08             	mov    0x8(%ebp),%eax
  80237b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  80237e:	a1 48 41 80 00       	mov    0x804148,%eax
  802383:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802386:	a1 38 41 80 00       	mov    0x804138,%eax
  80238b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80238e:	e9 77 01 00 00       	jmp    80250a <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802396:	8b 40 0c             	mov    0xc(%eax),%eax
  802399:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80239c:	0f 85 8a 00 00 00    	jne    80242c <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8023a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a6:	75 17                	jne    8023bf <alloc_block_FF+0x4d>
  8023a8:	83 ec 04             	sub    $0x4,%esp
  8023ab:	68 48 3b 80 00       	push   $0x803b48
  8023b0:	68 9e 00 00 00       	push   $0x9e
  8023b5:	68 d7 3a 80 00       	push   $0x803ad7
  8023ba:	e8 0f df ff ff       	call   8002ce <_panic>
  8023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c2:	8b 00                	mov    (%eax),%eax
  8023c4:	85 c0                	test   %eax,%eax
  8023c6:	74 10                	je     8023d8 <alloc_block_FF+0x66>
  8023c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cb:	8b 00                	mov    (%eax),%eax
  8023cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d0:	8b 52 04             	mov    0x4(%edx),%edx
  8023d3:	89 50 04             	mov    %edx,0x4(%eax)
  8023d6:	eb 0b                	jmp    8023e3 <alloc_block_FF+0x71>
  8023d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023db:	8b 40 04             	mov    0x4(%eax),%eax
  8023de:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e6:	8b 40 04             	mov    0x4(%eax),%eax
  8023e9:	85 c0                	test   %eax,%eax
  8023eb:	74 0f                	je     8023fc <alloc_block_FF+0x8a>
  8023ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f0:	8b 40 04             	mov    0x4(%eax),%eax
  8023f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f6:	8b 12                	mov    (%edx),%edx
  8023f8:	89 10                	mov    %edx,(%eax)
  8023fa:	eb 0a                	jmp    802406 <alloc_block_FF+0x94>
  8023fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ff:	8b 00                	mov    (%eax),%eax
  802401:	a3 38 41 80 00       	mov    %eax,0x804138
  802406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802409:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802412:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802419:	a1 44 41 80 00       	mov    0x804144,%eax
  80241e:	48                   	dec    %eax
  80241f:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802424:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802427:	e9 11 01 00 00       	jmp    80253d <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  80242c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242f:	8b 40 0c             	mov    0xc(%eax),%eax
  802432:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802435:	0f 86 c7 00 00 00    	jbe    802502 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  80243b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80243f:	75 17                	jne    802458 <alloc_block_FF+0xe6>
  802441:	83 ec 04             	sub    $0x4,%esp
  802444:	68 48 3b 80 00       	push   $0x803b48
  802449:	68 a3 00 00 00       	push   $0xa3
  80244e:	68 d7 3a 80 00       	push   $0x803ad7
  802453:	e8 76 de ff ff       	call   8002ce <_panic>
  802458:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80245b:	8b 00                	mov    (%eax),%eax
  80245d:	85 c0                	test   %eax,%eax
  80245f:	74 10                	je     802471 <alloc_block_FF+0xff>
  802461:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802464:	8b 00                	mov    (%eax),%eax
  802466:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802469:	8b 52 04             	mov    0x4(%edx),%edx
  80246c:	89 50 04             	mov    %edx,0x4(%eax)
  80246f:	eb 0b                	jmp    80247c <alloc_block_FF+0x10a>
  802471:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802474:	8b 40 04             	mov    0x4(%eax),%eax
  802477:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80247c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80247f:	8b 40 04             	mov    0x4(%eax),%eax
  802482:	85 c0                	test   %eax,%eax
  802484:	74 0f                	je     802495 <alloc_block_FF+0x123>
  802486:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802489:	8b 40 04             	mov    0x4(%eax),%eax
  80248c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80248f:	8b 12                	mov    (%edx),%edx
  802491:	89 10                	mov    %edx,(%eax)
  802493:	eb 0a                	jmp    80249f <alloc_block_FF+0x12d>
  802495:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802498:	8b 00                	mov    (%eax),%eax
  80249a:	a3 48 41 80 00       	mov    %eax,0x804148
  80249f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024b2:	a1 54 41 80 00       	mov    0x804154,%eax
  8024b7:	48                   	dec    %eax
  8024b8:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8024bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024c3:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8024c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024cc:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8024cf:	89 c2                	mov    %eax,%edx
  8024d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d4:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	8b 40 08             	mov    0x8(%eax),%eax
  8024dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	8b 50 08             	mov    0x8(%eax),%edx
  8024e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ec:	01 c2                	add    %eax,%edx
  8024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f1:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8024f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024fa:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8024fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802500:	eb 3b                	jmp    80253d <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802502:	a1 40 41 80 00       	mov    0x804140,%eax
  802507:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80250a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80250e:	74 07                	je     802517 <alloc_block_FF+0x1a5>
  802510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802513:	8b 00                	mov    (%eax),%eax
  802515:	eb 05                	jmp    80251c <alloc_block_FF+0x1aa>
  802517:	b8 00 00 00 00       	mov    $0x0,%eax
  80251c:	a3 40 41 80 00       	mov    %eax,0x804140
  802521:	a1 40 41 80 00       	mov    0x804140,%eax
  802526:	85 c0                	test   %eax,%eax
  802528:	0f 85 65 fe ff ff    	jne    802393 <alloc_block_FF+0x21>
  80252e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802532:	0f 85 5b fe ff ff    	jne    802393 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802538:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80253d:	c9                   	leave  
  80253e:	c3                   	ret    

0080253f <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80253f:	55                   	push   %ebp
  802540:	89 e5                	mov    %esp,%ebp
  802542:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802545:	8b 45 08             	mov    0x8(%ebp),%eax
  802548:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  80254b:	a1 48 41 80 00       	mov    0x804148,%eax
  802550:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802553:	a1 44 41 80 00       	mov    0x804144,%eax
  802558:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  80255b:	a1 38 41 80 00       	mov    0x804138,%eax
  802560:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802563:	e9 a1 00 00 00       	jmp    802609 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256b:	8b 40 0c             	mov    0xc(%eax),%eax
  80256e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802571:	0f 85 8a 00 00 00    	jne    802601 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802577:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257b:	75 17                	jne    802594 <alloc_block_BF+0x55>
  80257d:	83 ec 04             	sub    $0x4,%esp
  802580:	68 48 3b 80 00       	push   $0x803b48
  802585:	68 c2 00 00 00       	push   $0xc2
  80258a:	68 d7 3a 80 00       	push   $0x803ad7
  80258f:	e8 3a dd ff ff       	call   8002ce <_panic>
  802594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802597:	8b 00                	mov    (%eax),%eax
  802599:	85 c0                	test   %eax,%eax
  80259b:	74 10                	je     8025ad <alloc_block_BF+0x6e>
  80259d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a0:	8b 00                	mov    (%eax),%eax
  8025a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a5:	8b 52 04             	mov    0x4(%edx),%edx
  8025a8:	89 50 04             	mov    %edx,0x4(%eax)
  8025ab:	eb 0b                	jmp    8025b8 <alloc_block_BF+0x79>
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	8b 40 04             	mov    0x4(%eax),%eax
  8025b3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bb:	8b 40 04             	mov    0x4(%eax),%eax
  8025be:	85 c0                	test   %eax,%eax
  8025c0:	74 0f                	je     8025d1 <alloc_block_BF+0x92>
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	8b 40 04             	mov    0x4(%eax),%eax
  8025c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025cb:	8b 12                	mov    (%edx),%edx
  8025cd:	89 10                	mov    %edx,(%eax)
  8025cf:	eb 0a                	jmp    8025db <alloc_block_BF+0x9c>
  8025d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d4:	8b 00                	mov    (%eax),%eax
  8025d6:	a3 38 41 80 00       	mov    %eax,0x804138
  8025db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ee:	a1 44 41 80 00       	mov    0x804144,%eax
  8025f3:	48                   	dec    %eax
  8025f4:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8025f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fc:	e9 11 02 00 00       	jmp    802812 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802601:	a1 40 41 80 00       	mov    0x804140,%eax
  802606:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802609:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260d:	74 07                	je     802616 <alloc_block_BF+0xd7>
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	8b 00                	mov    (%eax),%eax
  802614:	eb 05                	jmp    80261b <alloc_block_BF+0xdc>
  802616:	b8 00 00 00 00       	mov    $0x0,%eax
  80261b:	a3 40 41 80 00       	mov    %eax,0x804140
  802620:	a1 40 41 80 00       	mov    0x804140,%eax
  802625:	85 c0                	test   %eax,%eax
  802627:	0f 85 3b ff ff ff    	jne    802568 <alloc_block_BF+0x29>
  80262d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802631:	0f 85 31 ff ff ff    	jne    802568 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802637:	a1 38 41 80 00       	mov    0x804138,%eax
  80263c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80263f:	eb 27                	jmp    802668 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802644:	8b 40 0c             	mov    0xc(%eax),%eax
  802647:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80264a:	76 14                	jbe    802660 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	8b 40 0c             	mov    0xc(%eax),%eax
  802652:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802658:	8b 40 08             	mov    0x8(%eax),%eax
  80265b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  80265e:	eb 2e                	jmp    80268e <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802660:	a1 40 41 80 00       	mov    0x804140,%eax
  802665:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802668:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266c:	74 07                	je     802675 <alloc_block_BF+0x136>
  80266e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802671:	8b 00                	mov    (%eax),%eax
  802673:	eb 05                	jmp    80267a <alloc_block_BF+0x13b>
  802675:	b8 00 00 00 00       	mov    $0x0,%eax
  80267a:	a3 40 41 80 00       	mov    %eax,0x804140
  80267f:	a1 40 41 80 00       	mov    0x804140,%eax
  802684:	85 c0                	test   %eax,%eax
  802686:	75 b9                	jne    802641 <alloc_block_BF+0x102>
  802688:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80268c:	75 b3                	jne    802641 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80268e:	a1 38 41 80 00       	mov    0x804138,%eax
  802693:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802696:	eb 30                	jmp    8026c8 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269b:	8b 40 0c             	mov    0xc(%eax),%eax
  80269e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8026a1:	73 1d                	jae    8026c0 <alloc_block_BF+0x181>
  8026a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8026ac:	76 12                	jbe    8026c0 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  8026b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ba:	8b 40 08             	mov    0x8(%eax),%eax
  8026bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026c0:	a1 40 41 80 00       	mov    0x804140,%eax
  8026c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026cc:	74 07                	je     8026d5 <alloc_block_BF+0x196>
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	8b 00                	mov    (%eax),%eax
  8026d3:	eb 05                	jmp    8026da <alloc_block_BF+0x19b>
  8026d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8026da:	a3 40 41 80 00       	mov    %eax,0x804140
  8026df:	a1 40 41 80 00       	mov    0x804140,%eax
  8026e4:	85 c0                	test   %eax,%eax
  8026e6:	75 b0                	jne    802698 <alloc_block_BF+0x159>
  8026e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ec:	75 aa                	jne    802698 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026ee:	a1 38 41 80 00       	mov    0x804138,%eax
  8026f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f6:	e9 e4 00 00 00       	jmp    8027df <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  8026fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802701:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802704:	0f 85 cd 00 00 00    	jne    8027d7 <alloc_block_BF+0x298>
  80270a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270d:	8b 40 08             	mov    0x8(%eax),%eax
  802710:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802713:	0f 85 be 00 00 00    	jne    8027d7 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802719:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80271d:	75 17                	jne    802736 <alloc_block_BF+0x1f7>
  80271f:	83 ec 04             	sub    $0x4,%esp
  802722:	68 48 3b 80 00       	push   $0x803b48
  802727:	68 db 00 00 00       	push   $0xdb
  80272c:	68 d7 3a 80 00       	push   $0x803ad7
  802731:	e8 98 db ff ff       	call   8002ce <_panic>
  802736:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802739:	8b 00                	mov    (%eax),%eax
  80273b:	85 c0                	test   %eax,%eax
  80273d:	74 10                	je     80274f <alloc_block_BF+0x210>
  80273f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802742:	8b 00                	mov    (%eax),%eax
  802744:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802747:	8b 52 04             	mov    0x4(%edx),%edx
  80274a:	89 50 04             	mov    %edx,0x4(%eax)
  80274d:	eb 0b                	jmp    80275a <alloc_block_BF+0x21b>
  80274f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802752:	8b 40 04             	mov    0x4(%eax),%eax
  802755:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80275a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80275d:	8b 40 04             	mov    0x4(%eax),%eax
  802760:	85 c0                	test   %eax,%eax
  802762:	74 0f                	je     802773 <alloc_block_BF+0x234>
  802764:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802767:	8b 40 04             	mov    0x4(%eax),%eax
  80276a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80276d:	8b 12                	mov    (%edx),%edx
  80276f:	89 10                	mov    %edx,(%eax)
  802771:	eb 0a                	jmp    80277d <alloc_block_BF+0x23e>
  802773:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802776:	8b 00                	mov    (%eax),%eax
  802778:	a3 48 41 80 00       	mov    %eax,0x804148
  80277d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802780:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802789:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802790:	a1 54 41 80 00       	mov    0x804154,%eax
  802795:	48                   	dec    %eax
  802796:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  80279b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80279e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027a1:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  8027a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027aa:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  8027ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b3:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8027b6:	89 c2                	mov    %eax,%edx
  8027b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bb:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  8027be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c1:	8b 50 08             	mov    0x8(%eax),%edx
  8027c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ca:	01 c2                	add    %eax,%edx
  8027cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cf:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8027d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d5:	eb 3b                	jmp    802812 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027d7:	a1 40 41 80 00       	mov    0x804140,%eax
  8027dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e3:	74 07                	je     8027ec <alloc_block_BF+0x2ad>
  8027e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e8:	8b 00                	mov    (%eax),%eax
  8027ea:	eb 05                	jmp    8027f1 <alloc_block_BF+0x2b2>
  8027ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f1:	a3 40 41 80 00       	mov    %eax,0x804140
  8027f6:	a1 40 41 80 00       	mov    0x804140,%eax
  8027fb:	85 c0                	test   %eax,%eax
  8027fd:	0f 85 f8 fe ff ff    	jne    8026fb <alloc_block_BF+0x1bc>
  802803:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802807:	0f 85 ee fe ff ff    	jne    8026fb <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  80280d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802812:	c9                   	leave  
  802813:	c3                   	ret    

00802814 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802814:	55                   	push   %ebp
  802815:	89 e5                	mov    %esp,%ebp
  802817:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  80281a:	8b 45 08             	mov    0x8(%ebp),%eax
  80281d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802820:	a1 48 41 80 00       	mov    0x804148,%eax
  802825:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802828:	a1 38 41 80 00       	mov    0x804138,%eax
  80282d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802830:	e9 77 01 00 00       	jmp    8029ac <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802838:	8b 40 0c             	mov    0xc(%eax),%eax
  80283b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80283e:	0f 85 8a 00 00 00    	jne    8028ce <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802844:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802848:	75 17                	jne    802861 <alloc_block_NF+0x4d>
  80284a:	83 ec 04             	sub    $0x4,%esp
  80284d:	68 48 3b 80 00       	push   $0x803b48
  802852:	68 f7 00 00 00       	push   $0xf7
  802857:	68 d7 3a 80 00       	push   $0x803ad7
  80285c:	e8 6d da ff ff       	call   8002ce <_panic>
  802861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802864:	8b 00                	mov    (%eax),%eax
  802866:	85 c0                	test   %eax,%eax
  802868:	74 10                	je     80287a <alloc_block_NF+0x66>
  80286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286d:	8b 00                	mov    (%eax),%eax
  80286f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802872:	8b 52 04             	mov    0x4(%edx),%edx
  802875:	89 50 04             	mov    %edx,0x4(%eax)
  802878:	eb 0b                	jmp    802885 <alloc_block_NF+0x71>
  80287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287d:	8b 40 04             	mov    0x4(%eax),%eax
  802880:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802888:	8b 40 04             	mov    0x4(%eax),%eax
  80288b:	85 c0                	test   %eax,%eax
  80288d:	74 0f                	je     80289e <alloc_block_NF+0x8a>
  80288f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802892:	8b 40 04             	mov    0x4(%eax),%eax
  802895:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802898:	8b 12                	mov    (%edx),%edx
  80289a:	89 10                	mov    %edx,(%eax)
  80289c:	eb 0a                	jmp    8028a8 <alloc_block_NF+0x94>
  80289e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a1:	8b 00                	mov    (%eax),%eax
  8028a3:	a3 38 41 80 00       	mov    %eax,0x804138
  8028a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028bb:	a1 44 41 80 00       	mov    0x804144,%eax
  8028c0:	48                   	dec    %eax
  8028c1:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c9:	e9 11 01 00 00       	jmp    8029df <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  8028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028d7:	0f 86 c7 00 00 00    	jbe    8029a4 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8028dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028e1:	75 17                	jne    8028fa <alloc_block_NF+0xe6>
  8028e3:	83 ec 04             	sub    $0x4,%esp
  8028e6:	68 48 3b 80 00       	push   $0x803b48
  8028eb:	68 fc 00 00 00       	push   $0xfc
  8028f0:	68 d7 3a 80 00       	push   $0x803ad7
  8028f5:	e8 d4 d9 ff ff       	call   8002ce <_panic>
  8028fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fd:	8b 00                	mov    (%eax),%eax
  8028ff:	85 c0                	test   %eax,%eax
  802901:	74 10                	je     802913 <alloc_block_NF+0xff>
  802903:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802906:	8b 00                	mov    (%eax),%eax
  802908:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80290b:	8b 52 04             	mov    0x4(%edx),%edx
  80290e:	89 50 04             	mov    %edx,0x4(%eax)
  802911:	eb 0b                	jmp    80291e <alloc_block_NF+0x10a>
  802913:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802916:	8b 40 04             	mov    0x4(%eax),%eax
  802919:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80291e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802921:	8b 40 04             	mov    0x4(%eax),%eax
  802924:	85 c0                	test   %eax,%eax
  802926:	74 0f                	je     802937 <alloc_block_NF+0x123>
  802928:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292b:	8b 40 04             	mov    0x4(%eax),%eax
  80292e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802931:	8b 12                	mov    (%edx),%edx
  802933:	89 10                	mov    %edx,(%eax)
  802935:	eb 0a                	jmp    802941 <alloc_block_NF+0x12d>
  802937:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293a:	8b 00                	mov    (%eax),%eax
  80293c:	a3 48 41 80 00       	mov    %eax,0x804148
  802941:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802944:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80294a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802954:	a1 54 41 80 00       	mov    0x804154,%eax
  802959:	48                   	dec    %eax
  80295a:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  80295f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802962:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802965:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296b:	8b 40 0c             	mov    0xc(%eax),%eax
  80296e:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802971:	89 c2                	mov    %eax,%edx
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297c:	8b 40 08             	mov    0x8(%eax),%eax
  80297f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802985:	8b 50 08             	mov    0x8(%eax),%edx
  802988:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298b:	8b 40 0c             	mov    0xc(%eax),%eax
  80298e:	01 c2                	add    %eax,%edx
  802990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802993:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802996:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802999:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80299c:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  80299f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a2:	eb 3b                	jmp    8029df <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8029a4:	a1 40 41 80 00       	mov    0x804140,%eax
  8029a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b0:	74 07                	je     8029b9 <alloc_block_NF+0x1a5>
  8029b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b5:	8b 00                	mov    (%eax),%eax
  8029b7:	eb 05                	jmp    8029be <alloc_block_NF+0x1aa>
  8029b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8029be:	a3 40 41 80 00       	mov    %eax,0x804140
  8029c3:	a1 40 41 80 00       	mov    0x804140,%eax
  8029c8:	85 c0                	test   %eax,%eax
  8029ca:	0f 85 65 fe ff ff    	jne    802835 <alloc_block_NF+0x21>
  8029d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d4:	0f 85 5b fe ff ff    	jne    802835 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8029da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029df:	c9                   	leave  
  8029e0:	c3                   	ret    

008029e1 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  8029e1:	55                   	push   %ebp
  8029e2:	89 e5                	mov    %esp,%ebp
  8029e4:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  8029e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  8029f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  8029fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029ff:	75 17                	jne    802a18 <addToAvailMemBlocksList+0x37>
  802a01:	83 ec 04             	sub    $0x4,%esp
  802a04:	68 f0 3a 80 00       	push   $0x803af0
  802a09:	68 10 01 00 00       	push   $0x110
  802a0e:	68 d7 3a 80 00       	push   $0x803ad7
  802a13:	e8 b6 d8 ff ff       	call   8002ce <_panic>
  802a18:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a21:	89 50 04             	mov    %edx,0x4(%eax)
  802a24:	8b 45 08             	mov    0x8(%ebp),%eax
  802a27:	8b 40 04             	mov    0x4(%eax),%eax
  802a2a:	85 c0                	test   %eax,%eax
  802a2c:	74 0c                	je     802a3a <addToAvailMemBlocksList+0x59>
  802a2e:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802a33:	8b 55 08             	mov    0x8(%ebp),%edx
  802a36:	89 10                	mov    %edx,(%eax)
  802a38:	eb 08                	jmp    802a42 <addToAvailMemBlocksList+0x61>
  802a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3d:	a3 48 41 80 00       	mov    %eax,0x804148
  802a42:	8b 45 08             	mov    0x8(%ebp),%eax
  802a45:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a53:	a1 54 41 80 00       	mov    0x804154,%eax
  802a58:	40                   	inc    %eax
  802a59:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802a5e:	90                   	nop
  802a5f:	c9                   	leave  
  802a60:	c3                   	ret    

00802a61 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a61:	55                   	push   %ebp
  802a62:	89 e5                	mov    %esp,%ebp
  802a64:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802a67:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802a6f:	a1 44 41 80 00       	mov    0x804144,%eax
  802a74:	85 c0                	test   %eax,%eax
  802a76:	75 68                	jne    802ae0 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802a78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a7c:	75 17                	jne    802a95 <insert_sorted_with_merge_freeList+0x34>
  802a7e:	83 ec 04             	sub    $0x4,%esp
  802a81:	68 b4 3a 80 00       	push   $0x803ab4
  802a86:	68 1a 01 00 00       	push   $0x11a
  802a8b:	68 d7 3a 80 00       	push   $0x803ad7
  802a90:	e8 39 d8 ff ff       	call   8002ce <_panic>
  802a95:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9e:	89 10                	mov    %edx,(%eax)
  802aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa3:	8b 00                	mov    (%eax),%eax
  802aa5:	85 c0                	test   %eax,%eax
  802aa7:	74 0d                	je     802ab6 <insert_sorted_with_merge_freeList+0x55>
  802aa9:	a1 38 41 80 00       	mov    0x804138,%eax
  802aae:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab1:	89 50 04             	mov    %edx,0x4(%eax)
  802ab4:	eb 08                	jmp    802abe <insert_sorted_with_merge_freeList+0x5d>
  802ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802abe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac1:	a3 38 41 80 00       	mov    %eax,0x804138
  802ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad0:	a1 44 41 80 00       	mov    0x804144,%eax
  802ad5:	40                   	inc    %eax
  802ad6:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802adb:	e9 c5 03 00 00       	jmp    802ea5 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae3:	8b 50 08             	mov    0x8(%eax),%edx
  802ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae9:	8b 40 08             	mov    0x8(%eax),%eax
  802aec:	39 c2                	cmp    %eax,%edx
  802aee:	0f 83 b2 00 00 00    	jae    802ba6 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af7:	8b 50 08             	mov    0x8(%eax),%edx
  802afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afd:	8b 40 0c             	mov    0xc(%eax),%eax
  802b00:	01 c2                	add    %eax,%edx
  802b02:	8b 45 08             	mov    0x8(%ebp),%eax
  802b05:	8b 40 08             	mov    0x8(%eax),%eax
  802b08:	39 c2                	cmp    %eax,%edx
  802b0a:	75 27                	jne    802b33 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802b0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0f:	8b 50 0c             	mov    0xc(%eax),%edx
  802b12:	8b 45 08             	mov    0x8(%ebp),%eax
  802b15:	8b 40 0c             	mov    0xc(%eax),%eax
  802b18:	01 c2                	add    %eax,%edx
  802b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1d:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802b20:	83 ec 0c             	sub    $0xc,%esp
  802b23:	ff 75 08             	pushl  0x8(%ebp)
  802b26:	e8 b6 fe ff ff       	call   8029e1 <addToAvailMemBlocksList>
  802b2b:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802b2e:	e9 72 03 00 00       	jmp    802ea5 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802b33:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b37:	74 06                	je     802b3f <insert_sorted_with_merge_freeList+0xde>
  802b39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b3d:	75 17                	jne    802b56 <insert_sorted_with_merge_freeList+0xf5>
  802b3f:	83 ec 04             	sub    $0x4,%esp
  802b42:	68 14 3b 80 00       	push   $0x803b14
  802b47:	68 24 01 00 00       	push   $0x124
  802b4c:	68 d7 3a 80 00       	push   $0x803ad7
  802b51:	e8 78 d7 ff ff       	call   8002ce <_panic>
  802b56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b59:	8b 10                	mov    (%eax),%edx
  802b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5e:	89 10                	mov    %edx,(%eax)
  802b60:	8b 45 08             	mov    0x8(%ebp),%eax
  802b63:	8b 00                	mov    (%eax),%eax
  802b65:	85 c0                	test   %eax,%eax
  802b67:	74 0b                	je     802b74 <insert_sorted_with_merge_freeList+0x113>
  802b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6c:	8b 00                	mov    (%eax),%eax
  802b6e:	8b 55 08             	mov    0x8(%ebp),%edx
  802b71:	89 50 04             	mov    %edx,0x4(%eax)
  802b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b77:	8b 55 08             	mov    0x8(%ebp),%edx
  802b7a:	89 10                	mov    %edx,(%eax)
  802b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b82:	89 50 04             	mov    %edx,0x4(%eax)
  802b85:	8b 45 08             	mov    0x8(%ebp),%eax
  802b88:	8b 00                	mov    (%eax),%eax
  802b8a:	85 c0                	test   %eax,%eax
  802b8c:	75 08                	jne    802b96 <insert_sorted_with_merge_freeList+0x135>
  802b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b91:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b96:	a1 44 41 80 00       	mov    0x804144,%eax
  802b9b:	40                   	inc    %eax
  802b9c:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ba1:	e9 ff 02 00 00       	jmp    802ea5 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802ba6:	a1 38 41 80 00       	mov    0x804138,%eax
  802bab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bae:	e9 c2 02 00 00       	jmp    802e75 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb6:	8b 50 08             	mov    0x8(%eax),%edx
  802bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbc:	8b 40 08             	mov    0x8(%eax),%eax
  802bbf:	39 c2                	cmp    %eax,%edx
  802bc1:	0f 86 a6 02 00 00    	jbe    802e6d <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bca:	8b 40 04             	mov    0x4(%eax),%eax
  802bcd:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802bd0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bd4:	0f 85 ba 00 00 00    	jne    802c94 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802bda:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdd:	8b 50 0c             	mov    0xc(%eax),%edx
  802be0:	8b 45 08             	mov    0x8(%ebp),%eax
  802be3:	8b 40 08             	mov    0x8(%eax),%eax
  802be6:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802beb:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802bee:	39 c2                	cmp    %eax,%edx
  802bf0:	75 33                	jne    802c25 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf5:	8b 50 08             	mov    0x8(%eax),%edx
  802bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfb:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c01:	8b 50 0c             	mov    0xc(%eax),%edx
  802c04:	8b 45 08             	mov    0x8(%ebp),%eax
  802c07:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0a:	01 c2                	add    %eax,%edx
  802c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0f:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802c12:	83 ec 0c             	sub    $0xc,%esp
  802c15:	ff 75 08             	pushl  0x8(%ebp)
  802c18:	e8 c4 fd ff ff       	call   8029e1 <addToAvailMemBlocksList>
  802c1d:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802c20:	e9 80 02 00 00       	jmp    802ea5 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802c25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c29:	74 06                	je     802c31 <insert_sorted_with_merge_freeList+0x1d0>
  802c2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c2f:	75 17                	jne    802c48 <insert_sorted_with_merge_freeList+0x1e7>
  802c31:	83 ec 04             	sub    $0x4,%esp
  802c34:	68 68 3b 80 00       	push   $0x803b68
  802c39:	68 3a 01 00 00       	push   $0x13a
  802c3e:	68 d7 3a 80 00       	push   $0x803ad7
  802c43:	e8 86 d6 ff ff       	call   8002ce <_panic>
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	8b 50 04             	mov    0x4(%eax),%edx
  802c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c51:	89 50 04             	mov    %edx,0x4(%eax)
  802c54:	8b 45 08             	mov    0x8(%ebp),%eax
  802c57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c5a:	89 10                	mov    %edx,(%eax)
  802c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5f:	8b 40 04             	mov    0x4(%eax),%eax
  802c62:	85 c0                	test   %eax,%eax
  802c64:	74 0d                	je     802c73 <insert_sorted_with_merge_freeList+0x212>
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	8b 40 04             	mov    0x4(%eax),%eax
  802c6c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c6f:	89 10                	mov    %edx,(%eax)
  802c71:	eb 08                	jmp    802c7b <insert_sorted_with_merge_freeList+0x21a>
  802c73:	8b 45 08             	mov    0x8(%ebp),%eax
  802c76:	a3 38 41 80 00       	mov    %eax,0x804138
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	8b 55 08             	mov    0x8(%ebp),%edx
  802c81:	89 50 04             	mov    %edx,0x4(%eax)
  802c84:	a1 44 41 80 00       	mov    0x804144,%eax
  802c89:	40                   	inc    %eax
  802c8a:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802c8f:	e9 11 02 00 00       	jmp    802ea5 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802c94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c97:	8b 50 08             	mov    0x8(%eax),%edx
  802c9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9d:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca0:	01 c2                	add    %eax,%edx
  802ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca8:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cad:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802cb0:	39 c2                	cmp    %eax,%edx
  802cb2:	0f 85 bf 00 00 00    	jne    802d77 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802cb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbb:	8b 50 0c             	mov    0xc(%eax),%edx
  802cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc1:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc4:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc9:	8b 40 0c             	mov    0xc(%eax),%eax
  802ccc:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802cce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd1:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802cd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd8:	75 17                	jne    802cf1 <insert_sorted_with_merge_freeList+0x290>
  802cda:	83 ec 04             	sub    $0x4,%esp
  802cdd:	68 48 3b 80 00       	push   $0x803b48
  802ce2:	68 43 01 00 00       	push   $0x143
  802ce7:	68 d7 3a 80 00       	push   $0x803ad7
  802cec:	e8 dd d5 ff ff       	call   8002ce <_panic>
  802cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf4:	8b 00                	mov    (%eax),%eax
  802cf6:	85 c0                	test   %eax,%eax
  802cf8:	74 10                	je     802d0a <insert_sorted_with_merge_freeList+0x2a9>
  802cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfd:	8b 00                	mov    (%eax),%eax
  802cff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d02:	8b 52 04             	mov    0x4(%edx),%edx
  802d05:	89 50 04             	mov    %edx,0x4(%eax)
  802d08:	eb 0b                	jmp    802d15 <insert_sorted_with_merge_freeList+0x2b4>
  802d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0d:	8b 40 04             	mov    0x4(%eax),%eax
  802d10:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d18:	8b 40 04             	mov    0x4(%eax),%eax
  802d1b:	85 c0                	test   %eax,%eax
  802d1d:	74 0f                	je     802d2e <insert_sorted_with_merge_freeList+0x2cd>
  802d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d22:	8b 40 04             	mov    0x4(%eax),%eax
  802d25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d28:	8b 12                	mov    (%edx),%edx
  802d2a:	89 10                	mov    %edx,(%eax)
  802d2c:	eb 0a                	jmp    802d38 <insert_sorted_with_merge_freeList+0x2d7>
  802d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d31:	8b 00                	mov    (%eax),%eax
  802d33:	a3 38 41 80 00       	mov    %eax,0x804138
  802d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d4b:	a1 44 41 80 00       	mov    0x804144,%eax
  802d50:	48                   	dec    %eax
  802d51:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802d56:	83 ec 0c             	sub    $0xc,%esp
  802d59:	ff 75 08             	pushl  0x8(%ebp)
  802d5c:	e8 80 fc ff ff       	call   8029e1 <addToAvailMemBlocksList>
  802d61:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802d64:	83 ec 0c             	sub    $0xc,%esp
  802d67:	ff 75 f4             	pushl  -0xc(%ebp)
  802d6a:	e8 72 fc ff ff       	call   8029e1 <addToAvailMemBlocksList>
  802d6f:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802d72:	e9 2e 01 00 00       	jmp    802ea5 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802d77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7a:	8b 50 08             	mov    0x8(%eax),%edx
  802d7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d80:	8b 40 0c             	mov    0xc(%eax),%eax
  802d83:	01 c2                	add    %eax,%edx
  802d85:	8b 45 08             	mov    0x8(%ebp),%eax
  802d88:	8b 40 08             	mov    0x8(%eax),%eax
  802d8b:	39 c2                	cmp    %eax,%edx
  802d8d:	75 27                	jne    802db6 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802d8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d92:	8b 50 0c             	mov    0xc(%eax),%edx
  802d95:	8b 45 08             	mov    0x8(%ebp),%eax
  802d98:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9b:	01 c2                	add    %eax,%edx
  802d9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da0:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802da3:	83 ec 0c             	sub    $0xc,%esp
  802da6:	ff 75 08             	pushl  0x8(%ebp)
  802da9:	e8 33 fc ff ff       	call   8029e1 <addToAvailMemBlocksList>
  802dae:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802db1:	e9 ef 00 00 00       	jmp    802ea5 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802db6:	8b 45 08             	mov    0x8(%ebp),%eax
  802db9:	8b 50 0c             	mov    0xc(%eax),%edx
  802dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbf:	8b 40 08             	mov    0x8(%eax),%eax
  802dc2:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc7:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802dca:	39 c2                	cmp    %eax,%edx
  802dcc:	75 33                	jne    802e01 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802dce:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd1:	8b 50 08             	mov    0x8(%eax),%edx
  802dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd7:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddd:	8b 50 0c             	mov    0xc(%eax),%edx
  802de0:	8b 45 08             	mov    0x8(%ebp),%eax
  802de3:	8b 40 0c             	mov    0xc(%eax),%eax
  802de6:	01 c2                	add    %eax,%edx
  802de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802deb:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802dee:	83 ec 0c             	sub    $0xc,%esp
  802df1:	ff 75 08             	pushl  0x8(%ebp)
  802df4:	e8 e8 fb ff ff       	call   8029e1 <addToAvailMemBlocksList>
  802df9:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802dfc:	e9 a4 00 00 00       	jmp    802ea5 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802e01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e05:	74 06                	je     802e0d <insert_sorted_with_merge_freeList+0x3ac>
  802e07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e0b:	75 17                	jne    802e24 <insert_sorted_with_merge_freeList+0x3c3>
  802e0d:	83 ec 04             	sub    $0x4,%esp
  802e10:	68 68 3b 80 00       	push   $0x803b68
  802e15:	68 56 01 00 00       	push   $0x156
  802e1a:	68 d7 3a 80 00       	push   $0x803ad7
  802e1f:	e8 aa d4 ff ff       	call   8002ce <_panic>
  802e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e27:	8b 50 04             	mov    0x4(%eax),%edx
  802e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2d:	89 50 04             	mov    %edx,0x4(%eax)
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e36:	89 10                	mov    %edx,(%eax)
  802e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3b:	8b 40 04             	mov    0x4(%eax),%eax
  802e3e:	85 c0                	test   %eax,%eax
  802e40:	74 0d                	je     802e4f <insert_sorted_with_merge_freeList+0x3ee>
  802e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e45:	8b 40 04             	mov    0x4(%eax),%eax
  802e48:	8b 55 08             	mov    0x8(%ebp),%edx
  802e4b:	89 10                	mov    %edx,(%eax)
  802e4d:	eb 08                	jmp    802e57 <insert_sorted_with_merge_freeList+0x3f6>
  802e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e52:	a3 38 41 80 00       	mov    %eax,0x804138
  802e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5a:	8b 55 08             	mov    0x8(%ebp),%edx
  802e5d:	89 50 04             	mov    %edx,0x4(%eax)
  802e60:	a1 44 41 80 00       	mov    0x804144,%eax
  802e65:	40                   	inc    %eax
  802e66:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802e6b:	eb 38                	jmp    802ea5 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802e6d:	a1 40 41 80 00       	mov    0x804140,%eax
  802e72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e79:	74 07                	je     802e82 <insert_sorted_with_merge_freeList+0x421>
  802e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7e:	8b 00                	mov    (%eax),%eax
  802e80:	eb 05                	jmp    802e87 <insert_sorted_with_merge_freeList+0x426>
  802e82:	b8 00 00 00 00       	mov    $0x0,%eax
  802e87:	a3 40 41 80 00       	mov    %eax,0x804140
  802e8c:	a1 40 41 80 00       	mov    0x804140,%eax
  802e91:	85 c0                	test   %eax,%eax
  802e93:	0f 85 1a fd ff ff    	jne    802bb3 <insert_sorted_with_merge_freeList+0x152>
  802e99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e9d:	0f 85 10 fd ff ff    	jne    802bb3 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ea3:	eb 00                	jmp    802ea5 <insert_sorted_with_merge_freeList+0x444>
  802ea5:	90                   	nop
  802ea6:	c9                   	leave  
  802ea7:	c3                   	ret    

00802ea8 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802ea8:	55                   	push   %ebp
  802ea9:	89 e5                	mov    %esp,%ebp
  802eab:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802eae:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb1:	89 d0                	mov    %edx,%eax
  802eb3:	c1 e0 02             	shl    $0x2,%eax
  802eb6:	01 d0                	add    %edx,%eax
  802eb8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ebf:	01 d0                	add    %edx,%eax
  802ec1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ec8:	01 d0                	add    %edx,%eax
  802eca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ed1:	01 d0                	add    %edx,%eax
  802ed3:	c1 e0 04             	shl    $0x4,%eax
  802ed6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802ed9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802ee0:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802ee3:	83 ec 0c             	sub    $0xc,%esp
  802ee6:	50                   	push   %eax
  802ee7:	e8 60 ed ff ff       	call   801c4c <sys_get_virtual_time>
  802eec:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802eef:	eb 41                	jmp    802f32 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802ef1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802ef4:	83 ec 0c             	sub    $0xc,%esp
  802ef7:	50                   	push   %eax
  802ef8:	e8 4f ed ff ff       	call   801c4c <sys_get_virtual_time>
  802efd:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802f00:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f06:	29 c2                	sub    %eax,%edx
  802f08:	89 d0                	mov    %edx,%eax
  802f0a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802f0d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f13:	89 d1                	mov    %edx,%ecx
  802f15:	29 c1                	sub    %eax,%ecx
  802f17:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802f1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f1d:	39 c2                	cmp    %eax,%edx
  802f1f:	0f 97 c0             	seta   %al
  802f22:	0f b6 c0             	movzbl %al,%eax
  802f25:	29 c1                	sub    %eax,%ecx
  802f27:	89 c8                	mov    %ecx,%eax
  802f29:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802f2c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f35:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f38:	72 b7                	jb     802ef1 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802f3a:	90                   	nop
  802f3b:	c9                   	leave  
  802f3c:	c3                   	ret    

00802f3d <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802f3d:	55                   	push   %ebp
  802f3e:	89 e5                	mov    %esp,%ebp
  802f40:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802f43:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802f4a:	eb 03                	jmp    802f4f <busy_wait+0x12>
  802f4c:	ff 45 fc             	incl   -0x4(%ebp)
  802f4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f52:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f55:	72 f5                	jb     802f4c <busy_wait+0xf>
	return i;
  802f57:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802f5a:	c9                   	leave  
  802f5b:	c3                   	ret    

00802f5c <__udivdi3>:
  802f5c:	55                   	push   %ebp
  802f5d:	57                   	push   %edi
  802f5e:	56                   	push   %esi
  802f5f:	53                   	push   %ebx
  802f60:	83 ec 1c             	sub    $0x1c,%esp
  802f63:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802f67:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802f6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802f6f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f73:	89 ca                	mov    %ecx,%edx
  802f75:	89 f8                	mov    %edi,%eax
  802f77:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802f7b:	85 f6                	test   %esi,%esi
  802f7d:	75 2d                	jne    802fac <__udivdi3+0x50>
  802f7f:	39 cf                	cmp    %ecx,%edi
  802f81:	77 65                	ja     802fe8 <__udivdi3+0x8c>
  802f83:	89 fd                	mov    %edi,%ebp
  802f85:	85 ff                	test   %edi,%edi
  802f87:	75 0b                	jne    802f94 <__udivdi3+0x38>
  802f89:	b8 01 00 00 00       	mov    $0x1,%eax
  802f8e:	31 d2                	xor    %edx,%edx
  802f90:	f7 f7                	div    %edi
  802f92:	89 c5                	mov    %eax,%ebp
  802f94:	31 d2                	xor    %edx,%edx
  802f96:	89 c8                	mov    %ecx,%eax
  802f98:	f7 f5                	div    %ebp
  802f9a:	89 c1                	mov    %eax,%ecx
  802f9c:	89 d8                	mov    %ebx,%eax
  802f9e:	f7 f5                	div    %ebp
  802fa0:	89 cf                	mov    %ecx,%edi
  802fa2:	89 fa                	mov    %edi,%edx
  802fa4:	83 c4 1c             	add    $0x1c,%esp
  802fa7:	5b                   	pop    %ebx
  802fa8:	5e                   	pop    %esi
  802fa9:	5f                   	pop    %edi
  802faa:	5d                   	pop    %ebp
  802fab:	c3                   	ret    
  802fac:	39 ce                	cmp    %ecx,%esi
  802fae:	77 28                	ja     802fd8 <__udivdi3+0x7c>
  802fb0:	0f bd fe             	bsr    %esi,%edi
  802fb3:	83 f7 1f             	xor    $0x1f,%edi
  802fb6:	75 40                	jne    802ff8 <__udivdi3+0x9c>
  802fb8:	39 ce                	cmp    %ecx,%esi
  802fba:	72 0a                	jb     802fc6 <__udivdi3+0x6a>
  802fbc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802fc0:	0f 87 9e 00 00 00    	ja     803064 <__udivdi3+0x108>
  802fc6:	b8 01 00 00 00       	mov    $0x1,%eax
  802fcb:	89 fa                	mov    %edi,%edx
  802fcd:	83 c4 1c             	add    $0x1c,%esp
  802fd0:	5b                   	pop    %ebx
  802fd1:	5e                   	pop    %esi
  802fd2:	5f                   	pop    %edi
  802fd3:	5d                   	pop    %ebp
  802fd4:	c3                   	ret    
  802fd5:	8d 76 00             	lea    0x0(%esi),%esi
  802fd8:	31 ff                	xor    %edi,%edi
  802fda:	31 c0                	xor    %eax,%eax
  802fdc:	89 fa                	mov    %edi,%edx
  802fde:	83 c4 1c             	add    $0x1c,%esp
  802fe1:	5b                   	pop    %ebx
  802fe2:	5e                   	pop    %esi
  802fe3:	5f                   	pop    %edi
  802fe4:	5d                   	pop    %ebp
  802fe5:	c3                   	ret    
  802fe6:	66 90                	xchg   %ax,%ax
  802fe8:	89 d8                	mov    %ebx,%eax
  802fea:	f7 f7                	div    %edi
  802fec:	31 ff                	xor    %edi,%edi
  802fee:	89 fa                	mov    %edi,%edx
  802ff0:	83 c4 1c             	add    $0x1c,%esp
  802ff3:	5b                   	pop    %ebx
  802ff4:	5e                   	pop    %esi
  802ff5:	5f                   	pop    %edi
  802ff6:	5d                   	pop    %ebp
  802ff7:	c3                   	ret    
  802ff8:	bd 20 00 00 00       	mov    $0x20,%ebp
  802ffd:	89 eb                	mov    %ebp,%ebx
  802fff:	29 fb                	sub    %edi,%ebx
  803001:	89 f9                	mov    %edi,%ecx
  803003:	d3 e6                	shl    %cl,%esi
  803005:	89 c5                	mov    %eax,%ebp
  803007:	88 d9                	mov    %bl,%cl
  803009:	d3 ed                	shr    %cl,%ebp
  80300b:	89 e9                	mov    %ebp,%ecx
  80300d:	09 f1                	or     %esi,%ecx
  80300f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803013:	89 f9                	mov    %edi,%ecx
  803015:	d3 e0                	shl    %cl,%eax
  803017:	89 c5                	mov    %eax,%ebp
  803019:	89 d6                	mov    %edx,%esi
  80301b:	88 d9                	mov    %bl,%cl
  80301d:	d3 ee                	shr    %cl,%esi
  80301f:	89 f9                	mov    %edi,%ecx
  803021:	d3 e2                	shl    %cl,%edx
  803023:	8b 44 24 08          	mov    0x8(%esp),%eax
  803027:	88 d9                	mov    %bl,%cl
  803029:	d3 e8                	shr    %cl,%eax
  80302b:	09 c2                	or     %eax,%edx
  80302d:	89 d0                	mov    %edx,%eax
  80302f:	89 f2                	mov    %esi,%edx
  803031:	f7 74 24 0c          	divl   0xc(%esp)
  803035:	89 d6                	mov    %edx,%esi
  803037:	89 c3                	mov    %eax,%ebx
  803039:	f7 e5                	mul    %ebp
  80303b:	39 d6                	cmp    %edx,%esi
  80303d:	72 19                	jb     803058 <__udivdi3+0xfc>
  80303f:	74 0b                	je     80304c <__udivdi3+0xf0>
  803041:	89 d8                	mov    %ebx,%eax
  803043:	31 ff                	xor    %edi,%edi
  803045:	e9 58 ff ff ff       	jmp    802fa2 <__udivdi3+0x46>
  80304a:	66 90                	xchg   %ax,%ax
  80304c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803050:	89 f9                	mov    %edi,%ecx
  803052:	d3 e2                	shl    %cl,%edx
  803054:	39 c2                	cmp    %eax,%edx
  803056:	73 e9                	jae    803041 <__udivdi3+0xe5>
  803058:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80305b:	31 ff                	xor    %edi,%edi
  80305d:	e9 40 ff ff ff       	jmp    802fa2 <__udivdi3+0x46>
  803062:	66 90                	xchg   %ax,%ax
  803064:	31 c0                	xor    %eax,%eax
  803066:	e9 37 ff ff ff       	jmp    802fa2 <__udivdi3+0x46>
  80306b:	90                   	nop

0080306c <__umoddi3>:
  80306c:	55                   	push   %ebp
  80306d:	57                   	push   %edi
  80306e:	56                   	push   %esi
  80306f:	53                   	push   %ebx
  803070:	83 ec 1c             	sub    $0x1c,%esp
  803073:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803077:	8b 74 24 34          	mov    0x34(%esp),%esi
  80307b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80307f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803083:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803087:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80308b:	89 f3                	mov    %esi,%ebx
  80308d:	89 fa                	mov    %edi,%edx
  80308f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803093:	89 34 24             	mov    %esi,(%esp)
  803096:	85 c0                	test   %eax,%eax
  803098:	75 1a                	jne    8030b4 <__umoddi3+0x48>
  80309a:	39 f7                	cmp    %esi,%edi
  80309c:	0f 86 a2 00 00 00    	jbe    803144 <__umoddi3+0xd8>
  8030a2:	89 c8                	mov    %ecx,%eax
  8030a4:	89 f2                	mov    %esi,%edx
  8030a6:	f7 f7                	div    %edi
  8030a8:	89 d0                	mov    %edx,%eax
  8030aa:	31 d2                	xor    %edx,%edx
  8030ac:	83 c4 1c             	add    $0x1c,%esp
  8030af:	5b                   	pop    %ebx
  8030b0:	5e                   	pop    %esi
  8030b1:	5f                   	pop    %edi
  8030b2:	5d                   	pop    %ebp
  8030b3:	c3                   	ret    
  8030b4:	39 f0                	cmp    %esi,%eax
  8030b6:	0f 87 ac 00 00 00    	ja     803168 <__umoddi3+0xfc>
  8030bc:	0f bd e8             	bsr    %eax,%ebp
  8030bf:	83 f5 1f             	xor    $0x1f,%ebp
  8030c2:	0f 84 ac 00 00 00    	je     803174 <__umoddi3+0x108>
  8030c8:	bf 20 00 00 00       	mov    $0x20,%edi
  8030cd:	29 ef                	sub    %ebp,%edi
  8030cf:	89 fe                	mov    %edi,%esi
  8030d1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8030d5:	89 e9                	mov    %ebp,%ecx
  8030d7:	d3 e0                	shl    %cl,%eax
  8030d9:	89 d7                	mov    %edx,%edi
  8030db:	89 f1                	mov    %esi,%ecx
  8030dd:	d3 ef                	shr    %cl,%edi
  8030df:	09 c7                	or     %eax,%edi
  8030e1:	89 e9                	mov    %ebp,%ecx
  8030e3:	d3 e2                	shl    %cl,%edx
  8030e5:	89 14 24             	mov    %edx,(%esp)
  8030e8:	89 d8                	mov    %ebx,%eax
  8030ea:	d3 e0                	shl    %cl,%eax
  8030ec:	89 c2                	mov    %eax,%edx
  8030ee:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030f2:	d3 e0                	shl    %cl,%eax
  8030f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030f8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030fc:	89 f1                	mov    %esi,%ecx
  8030fe:	d3 e8                	shr    %cl,%eax
  803100:	09 d0                	or     %edx,%eax
  803102:	d3 eb                	shr    %cl,%ebx
  803104:	89 da                	mov    %ebx,%edx
  803106:	f7 f7                	div    %edi
  803108:	89 d3                	mov    %edx,%ebx
  80310a:	f7 24 24             	mull   (%esp)
  80310d:	89 c6                	mov    %eax,%esi
  80310f:	89 d1                	mov    %edx,%ecx
  803111:	39 d3                	cmp    %edx,%ebx
  803113:	0f 82 87 00 00 00    	jb     8031a0 <__umoddi3+0x134>
  803119:	0f 84 91 00 00 00    	je     8031b0 <__umoddi3+0x144>
  80311f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803123:	29 f2                	sub    %esi,%edx
  803125:	19 cb                	sbb    %ecx,%ebx
  803127:	89 d8                	mov    %ebx,%eax
  803129:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80312d:	d3 e0                	shl    %cl,%eax
  80312f:	89 e9                	mov    %ebp,%ecx
  803131:	d3 ea                	shr    %cl,%edx
  803133:	09 d0                	or     %edx,%eax
  803135:	89 e9                	mov    %ebp,%ecx
  803137:	d3 eb                	shr    %cl,%ebx
  803139:	89 da                	mov    %ebx,%edx
  80313b:	83 c4 1c             	add    $0x1c,%esp
  80313e:	5b                   	pop    %ebx
  80313f:	5e                   	pop    %esi
  803140:	5f                   	pop    %edi
  803141:	5d                   	pop    %ebp
  803142:	c3                   	ret    
  803143:	90                   	nop
  803144:	89 fd                	mov    %edi,%ebp
  803146:	85 ff                	test   %edi,%edi
  803148:	75 0b                	jne    803155 <__umoddi3+0xe9>
  80314a:	b8 01 00 00 00       	mov    $0x1,%eax
  80314f:	31 d2                	xor    %edx,%edx
  803151:	f7 f7                	div    %edi
  803153:	89 c5                	mov    %eax,%ebp
  803155:	89 f0                	mov    %esi,%eax
  803157:	31 d2                	xor    %edx,%edx
  803159:	f7 f5                	div    %ebp
  80315b:	89 c8                	mov    %ecx,%eax
  80315d:	f7 f5                	div    %ebp
  80315f:	89 d0                	mov    %edx,%eax
  803161:	e9 44 ff ff ff       	jmp    8030aa <__umoddi3+0x3e>
  803166:	66 90                	xchg   %ax,%ax
  803168:	89 c8                	mov    %ecx,%eax
  80316a:	89 f2                	mov    %esi,%edx
  80316c:	83 c4 1c             	add    $0x1c,%esp
  80316f:	5b                   	pop    %ebx
  803170:	5e                   	pop    %esi
  803171:	5f                   	pop    %edi
  803172:	5d                   	pop    %ebp
  803173:	c3                   	ret    
  803174:	3b 04 24             	cmp    (%esp),%eax
  803177:	72 06                	jb     80317f <__umoddi3+0x113>
  803179:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80317d:	77 0f                	ja     80318e <__umoddi3+0x122>
  80317f:	89 f2                	mov    %esi,%edx
  803181:	29 f9                	sub    %edi,%ecx
  803183:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803187:	89 14 24             	mov    %edx,(%esp)
  80318a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80318e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803192:	8b 14 24             	mov    (%esp),%edx
  803195:	83 c4 1c             	add    $0x1c,%esp
  803198:	5b                   	pop    %ebx
  803199:	5e                   	pop    %esi
  80319a:	5f                   	pop    %edi
  80319b:	5d                   	pop    %ebp
  80319c:	c3                   	ret    
  80319d:	8d 76 00             	lea    0x0(%esi),%esi
  8031a0:	2b 04 24             	sub    (%esp),%eax
  8031a3:	19 fa                	sbb    %edi,%edx
  8031a5:	89 d1                	mov    %edx,%ecx
  8031a7:	89 c6                	mov    %eax,%esi
  8031a9:	e9 71 ff ff ff       	jmp    80311f <__umoddi3+0xb3>
  8031ae:	66 90                	xchg   %ax,%ax
  8031b0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8031b4:	72 ea                	jb     8031a0 <__umoddi3+0x134>
  8031b6:	89 d9                	mov    %ebx,%ecx
  8031b8:	e9 62 ff ff ff       	jmp    80311f <__umoddi3+0xb3>
