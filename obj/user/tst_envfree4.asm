
obj/user/tst_envfree4:     file format elf32-i386


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
  800031:	e8 0d 01 00 00       	call   800143 <libmain>
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
	// Testing scenario 4: Freeing the allocated semaphores
	// Testing removing the shared variables
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 c0 30 80 00       	push   $0x8030c0
  80004a:	e8 be 15 00 00       	call   80160d <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 6e 18 00 00       	call   8018d1 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 06 19 00 00       	call   801971 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 d0 30 80 00       	push   $0x8030d0
  800079:	e8 b5 04 00 00       	call   800533 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tsem1", 100,(myEnv->SecondListSize), 50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	6a 64                	push   $0x64
  800091:	68 03 31 80 00       	push   $0x803103
  800096:	e8 a8 1a 00 00       	call   801b43 <sys_create_env>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8000a7:	e8 b5 1a 00 00       	call   801b61 <sys_run_env>
  8000ac:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000af:	90                   	nop
  8000b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b3:	8b 00                	mov    (%eax),%eax
  8000b5:	83 f8 01             	cmp    $0x1,%eax
  8000b8:	75 f6                	jne    8000b0 <_main+0x78>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ba:	e8 12 18 00 00       	call   8018d1 <sys_calculate_free_frames>
  8000bf:	83 ec 08             	sub    $0x8,%esp
  8000c2:	50                   	push   %eax
  8000c3:	68 0c 31 80 00       	push   $0x80310c
  8000c8:	e8 66 04 00 00       	call   800533 <cprintf>
  8000cd:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d6:	e8 a2 1a 00 00       	call   801b7d <sys_destroy_env>
  8000db:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000de:	e8 ee 17 00 00       	call   8018d1 <sys_calculate_free_frames>
  8000e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e6:	e8 86 18 00 00       	call   801971 <sys_pf_calculate_allocated_pages>
  8000eb:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f4:	74 27                	je     80011d <_main+0xe5>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  8000f6:	83 ec 08             	sub    $0x8,%esp
  8000f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000fc:	68 40 31 80 00       	push   $0x803140
  800101:	e8 2d 04 00 00       	call   800533 <cprintf>
  800106:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	68 90 31 80 00       	push   $0x803190
  800111:	6a 1f                	push   $0x1f
  800113:	68 c6 31 80 00       	push   $0x8031c6
  800118:	e8 62 01 00 00       	call   80027f <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	ff 75 e4             	pushl  -0x1c(%ebp)
  800123:	68 dc 31 80 00       	push   $0x8031dc
  800128:	e8 06 04 00 00       	call   800533 <cprintf>
  80012d:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 4 for envfree completed successfully.\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 3c 32 80 00       	push   $0x80323c
  800138:	e8 f6 03 00 00       	call   800533 <cprintf>
  80013d:	83 c4 10             	add    $0x10,%esp
	return;
  800140:	90                   	nop
}
  800141:	c9                   	leave  
  800142:	c3                   	ret    

00800143 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800149:	e8 63 1a 00 00       	call   801bb1 <sys_getenvindex>
  80014e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800151:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800154:	89 d0                	mov    %edx,%eax
  800156:	c1 e0 03             	shl    $0x3,%eax
  800159:	01 d0                	add    %edx,%eax
  80015b:	01 c0                	add    %eax,%eax
  80015d:	01 d0                	add    %edx,%eax
  80015f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800166:	01 d0                	add    %edx,%eax
  800168:	c1 e0 04             	shl    $0x4,%eax
  80016b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800170:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800175:	a1 20 40 80 00       	mov    0x804020,%eax
  80017a:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800180:	84 c0                	test   %al,%al
  800182:	74 0f                	je     800193 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800184:	a1 20 40 80 00       	mov    0x804020,%eax
  800189:	05 5c 05 00 00       	add    $0x55c,%eax
  80018e:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800193:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800197:	7e 0a                	jle    8001a3 <libmain+0x60>
		binaryname = argv[0];
  800199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019c:	8b 00                	mov    (%eax),%eax
  80019e:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001a3:	83 ec 08             	sub    $0x8,%esp
  8001a6:	ff 75 0c             	pushl  0xc(%ebp)
  8001a9:	ff 75 08             	pushl  0x8(%ebp)
  8001ac:	e8 87 fe ff ff       	call   800038 <_main>
  8001b1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001b4:	e8 05 18 00 00       	call   8019be <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b9:	83 ec 0c             	sub    $0xc,%esp
  8001bc:	68 a0 32 80 00       	push   $0x8032a0
  8001c1:	e8 6d 03 00 00       	call   800533 <cprintf>
  8001c6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ce:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001d4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d9:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001df:	83 ec 04             	sub    $0x4,%esp
  8001e2:	52                   	push   %edx
  8001e3:	50                   	push   %eax
  8001e4:	68 c8 32 80 00       	push   $0x8032c8
  8001e9:	e8 45 03 00 00       	call   800533 <cprintf>
  8001ee:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f6:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800201:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800207:	a1 20 40 80 00       	mov    0x804020,%eax
  80020c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800212:	51                   	push   %ecx
  800213:	52                   	push   %edx
  800214:	50                   	push   %eax
  800215:	68 f0 32 80 00       	push   $0x8032f0
  80021a:	e8 14 03 00 00       	call   800533 <cprintf>
  80021f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800222:	a1 20 40 80 00       	mov    0x804020,%eax
  800227:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	50                   	push   %eax
  800231:	68 48 33 80 00       	push   $0x803348
  800236:	e8 f8 02 00 00       	call   800533 <cprintf>
  80023b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	68 a0 32 80 00       	push   $0x8032a0
  800246:	e8 e8 02 00 00       	call   800533 <cprintf>
  80024b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80024e:	e8 85 17 00 00       	call   8019d8 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800253:	e8 19 00 00 00       	call   800271 <exit>
}
  800258:	90                   	nop
  800259:	c9                   	leave  
  80025a:	c3                   	ret    

0080025b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80025b:	55                   	push   %ebp
  80025c:	89 e5                	mov    %esp,%ebp
  80025e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800261:	83 ec 0c             	sub    $0xc,%esp
  800264:	6a 00                	push   $0x0
  800266:	e8 12 19 00 00       	call   801b7d <sys_destroy_env>
  80026b:	83 c4 10             	add    $0x10,%esp
}
  80026e:	90                   	nop
  80026f:	c9                   	leave  
  800270:	c3                   	ret    

00800271 <exit>:

void
exit(void)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800277:	e8 67 19 00 00       	call   801be3 <sys_exit_env>
}
  80027c:	90                   	nop
  80027d:	c9                   	leave  
  80027e:	c3                   	ret    

0080027f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
  800282:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800285:	8d 45 10             	lea    0x10(%ebp),%eax
  800288:	83 c0 04             	add    $0x4,%eax
  80028b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80028e:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800293:	85 c0                	test   %eax,%eax
  800295:	74 16                	je     8002ad <_panic+0x2e>
		cprintf("%s: ", argv0);
  800297:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	50                   	push   %eax
  8002a0:	68 5c 33 80 00       	push   $0x80335c
  8002a5:	e8 89 02 00 00       	call   800533 <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ad:	a1 00 40 80 00       	mov    0x804000,%eax
  8002b2:	ff 75 0c             	pushl  0xc(%ebp)
  8002b5:	ff 75 08             	pushl  0x8(%ebp)
  8002b8:	50                   	push   %eax
  8002b9:	68 61 33 80 00       	push   $0x803361
  8002be:	e8 70 02 00 00       	call   800533 <cprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c9:	83 ec 08             	sub    $0x8,%esp
  8002cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8002cf:	50                   	push   %eax
  8002d0:	e8 f3 01 00 00       	call   8004c8 <vcprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002d8:	83 ec 08             	sub    $0x8,%esp
  8002db:	6a 00                	push   $0x0
  8002dd:	68 7d 33 80 00       	push   $0x80337d
  8002e2:	e8 e1 01 00 00       	call   8004c8 <vcprintf>
  8002e7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002ea:	e8 82 ff ff ff       	call   800271 <exit>

	// should not return here
	while (1) ;
  8002ef:	eb fe                	jmp    8002ef <_panic+0x70>

008002f1 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002f7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002fc:	8b 50 74             	mov    0x74(%eax),%edx
  8002ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800302:	39 c2                	cmp    %eax,%edx
  800304:	74 14                	je     80031a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	68 80 33 80 00       	push   $0x803380
  80030e:	6a 26                	push   $0x26
  800310:	68 cc 33 80 00       	push   $0x8033cc
  800315:	e8 65 ff ff ff       	call   80027f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80031a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800321:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800328:	e9 c2 00 00 00       	jmp    8003ef <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80032d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800330:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800337:	8b 45 08             	mov    0x8(%ebp),%eax
  80033a:	01 d0                	add    %edx,%eax
  80033c:	8b 00                	mov    (%eax),%eax
  80033e:	85 c0                	test   %eax,%eax
  800340:	75 08                	jne    80034a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800342:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800345:	e9 a2 00 00 00       	jmp    8003ec <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80034a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800351:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800358:	eb 69                	jmp    8003c3 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80035a:	a1 20 40 80 00       	mov    0x804020,%eax
  80035f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800365:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800368:	89 d0                	mov    %edx,%eax
  80036a:	01 c0                	add    %eax,%eax
  80036c:	01 d0                	add    %edx,%eax
  80036e:	c1 e0 03             	shl    $0x3,%eax
  800371:	01 c8                	add    %ecx,%eax
  800373:	8a 40 04             	mov    0x4(%eax),%al
  800376:	84 c0                	test   %al,%al
  800378:	75 46                	jne    8003c0 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80037a:	a1 20 40 80 00       	mov    0x804020,%eax
  80037f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800385:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800388:	89 d0                	mov    %edx,%eax
  80038a:	01 c0                	add    %eax,%eax
  80038c:	01 d0                	add    %edx,%eax
  80038e:	c1 e0 03             	shl    $0x3,%eax
  800391:	01 c8                	add    %ecx,%eax
  800393:	8b 00                	mov    (%eax),%eax
  800395:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800398:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8003af:	01 c8                	add    %ecx,%eax
  8003b1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b3:	39 c2                	cmp    %eax,%edx
  8003b5:	75 09                	jne    8003c0 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003b7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003be:	eb 12                	jmp    8003d2 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c0:	ff 45 e8             	incl   -0x18(%ebp)
  8003c3:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c8:	8b 50 74             	mov    0x74(%eax),%edx
  8003cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ce:	39 c2                	cmp    %eax,%edx
  8003d0:	77 88                	ja     80035a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003d6:	75 14                	jne    8003ec <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003d8:	83 ec 04             	sub    $0x4,%esp
  8003db:	68 d8 33 80 00       	push   $0x8033d8
  8003e0:	6a 3a                	push   $0x3a
  8003e2:	68 cc 33 80 00       	push   $0x8033cc
  8003e7:	e8 93 fe ff ff       	call   80027f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003ec:	ff 45 f0             	incl   -0x10(%ebp)
  8003ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f5:	0f 8c 32 ff ff ff    	jl     80032d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800402:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800409:	eb 26                	jmp    800431 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80040b:	a1 20 40 80 00       	mov    0x804020,%eax
  800410:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800416:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800419:	89 d0                	mov    %edx,%eax
  80041b:	01 c0                	add    %eax,%eax
  80041d:	01 d0                	add    %edx,%eax
  80041f:	c1 e0 03             	shl    $0x3,%eax
  800422:	01 c8                	add    %ecx,%eax
  800424:	8a 40 04             	mov    0x4(%eax),%al
  800427:	3c 01                	cmp    $0x1,%al
  800429:	75 03                	jne    80042e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80042b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042e:	ff 45 e0             	incl   -0x20(%ebp)
  800431:	a1 20 40 80 00       	mov    0x804020,%eax
  800436:	8b 50 74             	mov    0x74(%eax),%edx
  800439:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043c:	39 c2                	cmp    %eax,%edx
  80043e:	77 cb                	ja     80040b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800443:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800446:	74 14                	je     80045c <CheckWSWithoutLastIndex+0x16b>
		panic(
  800448:	83 ec 04             	sub    $0x4,%esp
  80044b:	68 2c 34 80 00       	push   $0x80342c
  800450:	6a 44                	push   $0x44
  800452:	68 cc 33 80 00       	push   $0x8033cc
  800457:	e8 23 fe ff ff       	call   80027f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80045c:	90                   	nop
  80045d:	c9                   	leave  
  80045e:	c3                   	ret    

0080045f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80045f:	55                   	push   %ebp
  800460:	89 e5                	mov    %esp,%ebp
  800462:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800465:	8b 45 0c             	mov    0xc(%ebp),%eax
  800468:	8b 00                	mov    (%eax),%eax
  80046a:	8d 48 01             	lea    0x1(%eax),%ecx
  80046d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800470:	89 0a                	mov    %ecx,(%edx)
  800472:	8b 55 08             	mov    0x8(%ebp),%edx
  800475:	88 d1                	mov    %dl,%cl
  800477:	8b 55 0c             	mov    0xc(%ebp),%edx
  80047a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80047e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800481:	8b 00                	mov    (%eax),%eax
  800483:	3d ff 00 00 00       	cmp    $0xff,%eax
  800488:	75 2c                	jne    8004b6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80048a:	a0 24 40 80 00       	mov    0x804024,%al
  80048f:	0f b6 c0             	movzbl %al,%eax
  800492:	8b 55 0c             	mov    0xc(%ebp),%edx
  800495:	8b 12                	mov    (%edx),%edx
  800497:	89 d1                	mov    %edx,%ecx
  800499:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049c:	83 c2 08             	add    $0x8,%edx
  80049f:	83 ec 04             	sub    $0x4,%esp
  8004a2:	50                   	push   %eax
  8004a3:	51                   	push   %ecx
  8004a4:	52                   	push   %edx
  8004a5:	e8 66 13 00 00       	call   801810 <sys_cputs>
  8004aa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b9:	8b 40 04             	mov    0x4(%eax),%eax
  8004bc:	8d 50 01             	lea    0x1(%eax),%edx
  8004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004c5:	90                   	nop
  8004c6:	c9                   	leave  
  8004c7:	c3                   	ret    

008004c8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004d1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004d8:	00 00 00 
	b.cnt = 0;
  8004db:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004e5:	ff 75 0c             	pushl  0xc(%ebp)
  8004e8:	ff 75 08             	pushl  0x8(%ebp)
  8004eb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f1:	50                   	push   %eax
  8004f2:	68 5f 04 80 00       	push   $0x80045f
  8004f7:	e8 11 02 00 00       	call   80070d <vprintfmt>
  8004fc:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004ff:	a0 24 40 80 00       	mov    0x804024,%al
  800504:	0f b6 c0             	movzbl %al,%eax
  800507:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80050d:	83 ec 04             	sub    $0x4,%esp
  800510:	50                   	push   %eax
  800511:	52                   	push   %edx
  800512:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800518:	83 c0 08             	add    $0x8,%eax
  80051b:	50                   	push   %eax
  80051c:	e8 ef 12 00 00       	call   801810 <sys_cputs>
  800521:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800524:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80052b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800531:	c9                   	leave  
  800532:	c3                   	ret    

00800533 <cprintf>:

int cprintf(const char *fmt, ...) {
  800533:	55                   	push   %ebp
  800534:	89 e5                	mov    %esp,%ebp
  800536:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800539:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800540:	8d 45 0c             	lea    0xc(%ebp),%eax
  800543:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800546:	8b 45 08             	mov    0x8(%ebp),%eax
  800549:	83 ec 08             	sub    $0x8,%esp
  80054c:	ff 75 f4             	pushl  -0xc(%ebp)
  80054f:	50                   	push   %eax
  800550:	e8 73 ff ff ff       	call   8004c8 <vcprintf>
  800555:	83 c4 10             	add    $0x10,%esp
  800558:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80055b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80055e:	c9                   	leave  
  80055f:	c3                   	ret    

00800560 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800560:	55                   	push   %ebp
  800561:	89 e5                	mov    %esp,%ebp
  800563:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800566:	e8 53 14 00 00       	call   8019be <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80056b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800571:	8b 45 08             	mov    0x8(%ebp),%eax
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	ff 75 f4             	pushl  -0xc(%ebp)
  80057a:	50                   	push   %eax
  80057b:	e8 48 ff ff ff       	call   8004c8 <vcprintf>
  800580:	83 c4 10             	add    $0x10,%esp
  800583:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800586:	e8 4d 14 00 00       	call   8019d8 <sys_enable_interrupt>
	return cnt;
  80058b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80058e:	c9                   	leave  
  80058f:	c3                   	ret    

00800590 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
  800593:	53                   	push   %ebx
  800594:	83 ec 14             	sub    $0x14,%esp
  800597:	8b 45 10             	mov    0x10(%ebp),%eax
  80059a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80059d:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a3:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ab:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ae:	77 55                	ja     800605 <printnum+0x75>
  8005b0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b3:	72 05                	jb     8005ba <printnum+0x2a>
  8005b5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005b8:	77 4b                	ja     800605 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ba:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005bd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005c0:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c8:	52                   	push   %edx
  8005c9:	50                   	push   %eax
  8005ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cd:	ff 75 f0             	pushl  -0x10(%ebp)
  8005d0:	e8 87 28 00 00       	call   802e5c <__udivdi3>
  8005d5:	83 c4 10             	add    $0x10,%esp
  8005d8:	83 ec 04             	sub    $0x4,%esp
  8005db:	ff 75 20             	pushl  0x20(%ebp)
  8005de:	53                   	push   %ebx
  8005df:	ff 75 18             	pushl  0x18(%ebp)
  8005e2:	52                   	push   %edx
  8005e3:	50                   	push   %eax
  8005e4:	ff 75 0c             	pushl  0xc(%ebp)
  8005e7:	ff 75 08             	pushl  0x8(%ebp)
  8005ea:	e8 a1 ff ff ff       	call   800590 <printnum>
  8005ef:	83 c4 20             	add    $0x20,%esp
  8005f2:	eb 1a                	jmp    80060e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f4:	83 ec 08             	sub    $0x8,%esp
  8005f7:	ff 75 0c             	pushl  0xc(%ebp)
  8005fa:	ff 75 20             	pushl  0x20(%ebp)
  8005fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800600:	ff d0                	call   *%eax
  800602:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800605:	ff 4d 1c             	decl   0x1c(%ebp)
  800608:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80060c:	7f e6                	jg     8005f4 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80060e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800611:	bb 00 00 00 00       	mov    $0x0,%ebx
  800616:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800619:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061c:	53                   	push   %ebx
  80061d:	51                   	push   %ecx
  80061e:	52                   	push   %edx
  80061f:	50                   	push   %eax
  800620:	e8 47 29 00 00       	call   802f6c <__umoddi3>
  800625:	83 c4 10             	add    $0x10,%esp
  800628:	05 94 36 80 00       	add    $0x803694,%eax
  80062d:	8a 00                	mov    (%eax),%al
  80062f:	0f be c0             	movsbl %al,%eax
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	50                   	push   %eax
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	ff d0                	call   *%eax
  80063e:	83 c4 10             	add    $0x10,%esp
}
  800641:	90                   	nop
  800642:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800645:	c9                   	leave  
  800646:	c3                   	ret    

00800647 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800647:	55                   	push   %ebp
  800648:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80064a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80064e:	7e 1c                	jle    80066c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800650:	8b 45 08             	mov    0x8(%ebp),%eax
  800653:	8b 00                	mov    (%eax),%eax
  800655:	8d 50 08             	lea    0x8(%eax),%edx
  800658:	8b 45 08             	mov    0x8(%ebp),%eax
  80065b:	89 10                	mov    %edx,(%eax)
  80065d:	8b 45 08             	mov    0x8(%ebp),%eax
  800660:	8b 00                	mov    (%eax),%eax
  800662:	83 e8 08             	sub    $0x8,%eax
  800665:	8b 50 04             	mov    0x4(%eax),%edx
  800668:	8b 00                	mov    (%eax),%eax
  80066a:	eb 40                	jmp    8006ac <getuint+0x65>
	else if (lflag)
  80066c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800670:	74 1e                	je     800690 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800672:	8b 45 08             	mov    0x8(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	8d 50 04             	lea    0x4(%eax),%edx
  80067a:	8b 45 08             	mov    0x8(%ebp),%eax
  80067d:	89 10                	mov    %edx,(%eax)
  80067f:	8b 45 08             	mov    0x8(%ebp),%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	83 e8 04             	sub    $0x4,%eax
  800687:	8b 00                	mov    (%eax),%eax
  800689:	ba 00 00 00 00       	mov    $0x0,%edx
  80068e:	eb 1c                	jmp    8006ac <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	8d 50 04             	lea    0x4(%eax),%edx
  800698:	8b 45 08             	mov    0x8(%ebp),%eax
  80069b:	89 10                	mov    %edx,(%eax)
  80069d:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a0:	8b 00                	mov    (%eax),%eax
  8006a2:	83 e8 04             	sub    $0x4,%eax
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ac:	5d                   	pop    %ebp
  8006ad:	c3                   	ret    

008006ae <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006ae:	55                   	push   %ebp
  8006af:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b5:	7e 1c                	jle    8006d3 <getint+0x25>
		return va_arg(*ap, long long);
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	8d 50 08             	lea    0x8(%eax),%edx
  8006bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c2:	89 10                	mov    %edx,(%eax)
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	83 e8 08             	sub    $0x8,%eax
  8006cc:	8b 50 04             	mov    0x4(%eax),%edx
  8006cf:	8b 00                	mov    (%eax),%eax
  8006d1:	eb 38                	jmp    80070b <getint+0x5d>
	else if (lflag)
  8006d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006d7:	74 1a                	je     8006f3 <getint+0x45>
		return va_arg(*ap, long);
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	8d 50 04             	lea    0x4(%eax),%edx
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	89 10                	mov    %edx,(%eax)
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	83 e8 04             	sub    $0x4,%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	99                   	cltd   
  8006f1:	eb 18                	jmp    80070b <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	8d 50 04             	lea    0x4(%eax),%edx
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	89 10                	mov    %edx,(%eax)
  800700:	8b 45 08             	mov    0x8(%ebp),%eax
  800703:	8b 00                	mov    (%eax),%eax
  800705:	83 e8 04             	sub    $0x4,%eax
  800708:	8b 00                	mov    (%eax),%eax
  80070a:	99                   	cltd   
}
  80070b:	5d                   	pop    %ebp
  80070c:	c3                   	ret    

0080070d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80070d:	55                   	push   %ebp
  80070e:	89 e5                	mov    %esp,%ebp
  800710:	56                   	push   %esi
  800711:	53                   	push   %ebx
  800712:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800715:	eb 17                	jmp    80072e <vprintfmt+0x21>
			if (ch == '\0')
  800717:	85 db                	test   %ebx,%ebx
  800719:	0f 84 af 03 00 00    	je     800ace <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80071f:	83 ec 08             	sub    $0x8,%esp
  800722:	ff 75 0c             	pushl  0xc(%ebp)
  800725:	53                   	push   %ebx
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	ff d0                	call   *%eax
  80072b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072e:	8b 45 10             	mov    0x10(%ebp),%eax
  800731:	8d 50 01             	lea    0x1(%eax),%edx
  800734:	89 55 10             	mov    %edx,0x10(%ebp)
  800737:	8a 00                	mov    (%eax),%al
  800739:	0f b6 d8             	movzbl %al,%ebx
  80073c:	83 fb 25             	cmp    $0x25,%ebx
  80073f:	75 d6                	jne    800717 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800741:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800745:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80074c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800753:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80075a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800761:	8b 45 10             	mov    0x10(%ebp),%eax
  800764:	8d 50 01             	lea    0x1(%eax),%edx
  800767:	89 55 10             	mov    %edx,0x10(%ebp)
  80076a:	8a 00                	mov    (%eax),%al
  80076c:	0f b6 d8             	movzbl %al,%ebx
  80076f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800772:	83 f8 55             	cmp    $0x55,%eax
  800775:	0f 87 2b 03 00 00    	ja     800aa6 <vprintfmt+0x399>
  80077b:	8b 04 85 b8 36 80 00 	mov    0x8036b8(,%eax,4),%eax
  800782:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800784:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800788:	eb d7                	jmp    800761 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80078a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80078e:	eb d1                	jmp    800761 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800790:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800797:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80079a:	89 d0                	mov    %edx,%eax
  80079c:	c1 e0 02             	shl    $0x2,%eax
  80079f:	01 d0                	add    %edx,%eax
  8007a1:	01 c0                	add    %eax,%eax
  8007a3:	01 d8                	add    %ebx,%eax
  8007a5:	83 e8 30             	sub    $0x30,%eax
  8007a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ae:	8a 00                	mov    (%eax),%al
  8007b0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007b3:	83 fb 2f             	cmp    $0x2f,%ebx
  8007b6:	7e 3e                	jle    8007f6 <vprintfmt+0xe9>
  8007b8:	83 fb 39             	cmp    $0x39,%ebx
  8007bb:	7f 39                	jg     8007f6 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007bd:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007c0:	eb d5                	jmp    800797 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c5:	83 c0 04             	add    $0x4,%eax
  8007c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ce:	83 e8 04             	sub    $0x4,%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007d6:	eb 1f                	jmp    8007f7 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007dc:	79 83                	jns    800761 <vprintfmt+0x54>
				width = 0;
  8007de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007e5:	e9 77 ff ff ff       	jmp    800761 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007ea:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007f1:	e9 6b ff ff ff       	jmp    800761 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007f6:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fb:	0f 89 60 ff ff ff    	jns    800761 <vprintfmt+0x54>
				width = precision, precision = -1;
  800801:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800804:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800807:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80080e:	e9 4e ff ff ff       	jmp    800761 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800813:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800816:	e9 46 ff ff ff       	jmp    800761 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80081b:	8b 45 14             	mov    0x14(%ebp),%eax
  80081e:	83 c0 04             	add    $0x4,%eax
  800821:	89 45 14             	mov    %eax,0x14(%ebp)
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	83 e8 04             	sub    $0x4,%eax
  80082a:	8b 00                	mov    (%eax),%eax
  80082c:	83 ec 08             	sub    $0x8,%esp
  80082f:	ff 75 0c             	pushl  0xc(%ebp)
  800832:	50                   	push   %eax
  800833:	8b 45 08             	mov    0x8(%ebp),%eax
  800836:	ff d0                	call   *%eax
  800838:	83 c4 10             	add    $0x10,%esp
			break;
  80083b:	e9 89 02 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800840:	8b 45 14             	mov    0x14(%ebp),%eax
  800843:	83 c0 04             	add    $0x4,%eax
  800846:	89 45 14             	mov    %eax,0x14(%ebp)
  800849:	8b 45 14             	mov    0x14(%ebp),%eax
  80084c:	83 e8 04             	sub    $0x4,%eax
  80084f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800851:	85 db                	test   %ebx,%ebx
  800853:	79 02                	jns    800857 <vprintfmt+0x14a>
				err = -err;
  800855:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800857:	83 fb 64             	cmp    $0x64,%ebx
  80085a:	7f 0b                	jg     800867 <vprintfmt+0x15a>
  80085c:	8b 34 9d 00 35 80 00 	mov    0x803500(,%ebx,4),%esi
  800863:	85 f6                	test   %esi,%esi
  800865:	75 19                	jne    800880 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800867:	53                   	push   %ebx
  800868:	68 a5 36 80 00       	push   $0x8036a5
  80086d:	ff 75 0c             	pushl  0xc(%ebp)
  800870:	ff 75 08             	pushl  0x8(%ebp)
  800873:	e8 5e 02 00 00       	call   800ad6 <printfmt>
  800878:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80087b:	e9 49 02 00 00       	jmp    800ac9 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800880:	56                   	push   %esi
  800881:	68 ae 36 80 00       	push   $0x8036ae
  800886:	ff 75 0c             	pushl  0xc(%ebp)
  800889:	ff 75 08             	pushl  0x8(%ebp)
  80088c:	e8 45 02 00 00       	call   800ad6 <printfmt>
  800891:	83 c4 10             	add    $0x10,%esp
			break;
  800894:	e9 30 02 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800899:	8b 45 14             	mov    0x14(%ebp),%eax
  80089c:	83 c0 04             	add    $0x4,%eax
  80089f:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a5:	83 e8 04             	sub    $0x4,%eax
  8008a8:	8b 30                	mov    (%eax),%esi
  8008aa:	85 f6                	test   %esi,%esi
  8008ac:	75 05                	jne    8008b3 <vprintfmt+0x1a6>
				p = "(null)";
  8008ae:	be b1 36 80 00       	mov    $0x8036b1,%esi
			if (width > 0 && padc != '-')
  8008b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b7:	7e 6d                	jle    800926 <vprintfmt+0x219>
  8008b9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008bd:	74 67                	je     800926 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	50                   	push   %eax
  8008c6:	56                   	push   %esi
  8008c7:	e8 0c 03 00 00       	call   800bd8 <strnlen>
  8008cc:	83 c4 10             	add    $0x10,%esp
  8008cf:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d2:	eb 16                	jmp    8008ea <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008d4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008d8:	83 ec 08             	sub    $0x8,%esp
  8008db:	ff 75 0c             	pushl  0xc(%ebp)
  8008de:	50                   	push   %eax
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	ff d0                	call   *%eax
  8008e4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e7:	ff 4d e4             	decl   -0x1c(%ebp)
  8008ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ee:	7f e4                	jg     8008d4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f0:	eb 34                	jmp    800926 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008f6:	74 1c                	je     800914 <vprintfmt+0x207>
  8008f8:	83 fb 1f             	cmp    $0x1f,%ebx
  8008fb:	7e 05                	jle    800902 <vprintfmt+0x1f5>
  8008fd:	83 fb 7e             	cmp    $0x7e,%ebx
  800900:	7e 12                	jle    800914 <vprintfmt+0x207>
					putch('?', putdat);
  800902:	83 ec 08             	sub    $0x8,%esp
  800905:	ff 75 0c             	pushl  0xc(%ebp)
  800908:	6a 3f                	push   $0x3f
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	ff d0                	call   *%eax
  80090f:	83 c4 10             	add    $0x10,%esp
  800912:	eb 0f                	jmp    800923 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	ff 75 0c             	pushl  0xc(%ebp)
  80091a:	53                   	push   %ebx
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	ff d0                	call   *%eax
  800920:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800923:	ff 4d e4             	decl   -0x1c(%ebp)
  800926:	89 f0                	mov    %esi,%eax
  800928:	8d 70 01             	lea    0x1(%eax),%esi
  80092b:	8a 00                	mov    (%eax),%al
  80092d:	0f be d8             	movsbl %al,%ebx
  800930:	85 db                	test   %ebx,%ebx
  800932:	74 24                	je     800958 <vprintfmt+0x24b>
  800934:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800938:	78 b8                	js     8008f2 <vprintfmt+0x1e5>
  80093a:	ff 4d e0             	decl   -0x20(%ebp)
  80093d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800941:	79 af                	jns    8008f2 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800943:	eb 13                	jmp    800958 <vprintfmt+0x24b>
				putch(' ', putdat);
  800945:	83 ec 08             	sub    $0x8,%esp
  800948:	ff 75 0c             	pushl  0xc(%ebp)
  80094b:	6a 20                	push   $0x20
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	ff d0                	call   *%eax
  800952:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800955:	ff 4d e4             	decl   -0x1c(%ebp)
  800958:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095c:	7f e7                	jg     800945 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80095e:	e9 66 01 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800963:	83 ec 08             	sub    $0x8,%esp
  800966:	ff 75 e8             	pushl  -0x18(%ebp)
  800969:	8d 45 14             	lea    0x14(%ebp),%eax
  80096c:	50                   	push   %eax
  80096d:	e8 3c fd ff ff       	call   8006ae <getint>
  800972:	83 c4 10             	add    $0x10,%esp
  800975:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800978:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80097b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80097e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800981:	85 d2                	test   %edx,%edx
  800983:	79 23                	jns    8009a8 <vprintfmt+0x29b>
				putch('-', putdat);
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	ff 75 0c             	pushl  0xc(%ebp)
  80098b:	6a 2d                	push   $0x2d
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	ff d0                	call   *%eax
  800992:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800995:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800998:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80099b:	f7 d8                	neg    %eax
  80099d:	83 d2 00             	adc    $0x0,%edx
  8009a0:	f7 da                	neg    %edx
  8009a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009a8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009af:	e9 bc 00 00 00       	jmp    800a70 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ba:	8d 45 14             	lea    0x14(%ebp),%eax
  8009bd:	50                   	push   %eax
  8009be:	e8 84 fc ff ff       	call   800647 <getuint>
  8009c3:	83 c4 10             	add    $0x10,%esp
  8009c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009cc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d3:	e9 98 00 00 00       	jmp    800a70 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d8:	83 ec 08             	sub    $0x8,%esp
  8009db:	ff 75 0c             	pushl  0xc(%ebp)
  8009de:	6a 58                	push   $0x58
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	ff d0                	call   *%eax
  8009e5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	6a 58                	push   $0x58
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	ff d0                	call   *%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f8:	83 ec 08             	sub    $0x8,%esp
  8009fb:	ff 75 0c             	pushl  0xc(%ebp)
  8009fe:	6a 58                	push   $0x58
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	ff d0                	call   *%eax
  800a05:	83 c4 10             	add    $0x10,%esp
			break;
  800a08:	e9 bc 00 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	6a 30                	push   $0x30
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	ff d0                	call   *%eax
  800a1a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a1d:	83 ec 08             	sub    $0x8,%esp
  800a20:	ff 75 0c             	pushl  0xc(%ebp)
  800a23:	6a 78                	push   $0x78
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	ff d0                	call   *%eax
  800a2a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a30:	83 c0 04             	add    $0x4,%eax
  800a33:	89 45 14             	mov    %eax,0x14(%ebp)
  800a36:	8b 45 14             	mov    0x14(%ebp),%eax
  800a39:	83 e8 04             	sub    $0x4,%eax
  800a3c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a48:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a4f:	eb 1f                	jmp    800a70 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a51:	83 ec 08             	sub    $0x8,%esp
  800a54:	ff 75 e8             	pushl  -0x18(%ebp)
  800a57:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5a:	50                   	push   %eax
  800a5b:	e8 e7 fb ff ff       	call   800647 <getuint>
  800a60:	83 c4 10             	add    $0x10,%esp
  800a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a66:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a69:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a70:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a77:	83 ec 04             	sub    $0x4,%esp
  800a7a:	52                   	push   %edx
  800a7b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a7e:	50                   	push   %eax
  800a7f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a82:	ff 75 f0             	pushl  -0x10(%ebp)
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	ff 75 08             	pushl  0x8(%ebp)
  800a8b:	e8 00 fb ff ff       	call   800590 <printnum>
  800a90:	83 c4 20             	add    $0x20,%esp
			break;
  800a93:	eb 34                	jmp    800ac9 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	53                   	push   %ebx
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
			break;
  800aa4:	eb 23                	jmp    800ac9 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	6a 25                	push   $0x25
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	ff d0                	call   *%eax
  800ab3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ab6:	ff 4d 10             	decl   0x10(%ebp)
  800ab9:	eb 03                	jmp    800abe <vprintfmt+0x3b1>
  800abb:	ff 4d 10             	decl   0x10(%ebp)
  800abe:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac1:	48                   	dec    %eax
  800ac2:	8a 00                	mov    (%eax),%al
  800ac4:	3c 25                	cmp    $0x25,%al
  800ac6:	75 f3                	jne    800abb <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ac8:	90                   	nop
		}
	}
  800ac9:	e9 47 fc ff ff       	jmp    800715 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ace:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800acf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ad2:	5b                   	pop    %ebx
  800ad3:	5e                   	pop    %esi
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800adc:	8d 45 10             	lea    0x10(%ebp),%eax
  800adf:	83 c0 04             	add    $0x4,%eax
  800ae2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ae5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae8:	ff 75 f4             	pushl  -0xc(%ebp)
  800aeb:	50                   	push   %eax
  800aec:	ff 75 0c             	pushl  0xc(%ebp)
  800aef:	ff 75 08             	pushl  0x8(%ebp)
  800af2:	e8 16 fc ff ff       	call   80070d <vprintfmt>
  800af7:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800afa:	90                   	nop
  800afb:	c9                   	leave  
  800afc:	c3                   	ret    

00800afd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	8b 40 08             	mov    0x8(%eax),%eax
  800b06:	8d 50 01             	lea    0x1(%eax),%edx
  800b09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b12:	8b 10                	mov    (%eax),%edx
  800b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b17:	8b 40 04             	mov    0x4(%eax),%eax
  800b1a:	39 c2                	cmp    %eax,%edx
  800b1c:	73 12                	jae    800b30 <sprintputch+0x33>
		*b->buf++ = ch;
  800b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b21:	8b 00                	mov    (%eax),%eax
  800b23:	8d 48 01             	lea    0x1(%eax),%ecx
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b29:	89 0a                	mov    %ecx,(%edx)
  800b2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2e:	88 10                	mov    %dl,(%eax)
}
  800b30:	90                   	nop
  800b31:	5d                   	pop    %ebp
  800b32:	c3                   	ret    

00800b33 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
  800b36:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b42:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
  800b48:	01 d0                	add    %edx,%eax
  800b4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b58:	74 06                	je     800b60 <vsnprintf+0x2d>
  800b5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b5e:	7f 07                	jg     800b67 <vsnprintf+0x34>
		return -E_INVAL;
  800b60:	b8 03 00 00 00       	mov    $0x3,%eax
  800b65:	eb 20                	jmp    800b87 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b67:	ff 75 14             	pushl  0x14(%ebp)
  800b6a:	ff 75 10             	pushl  0x10(%ebp)
  800b6d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b70:	50                   	push   %eax
  800b71:	68 fd 0a 80 00       	push   $0x800afd
  800b76:	e8 92 fb ff ff       	call   80070d <vprintfmt>
  800b7b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b81:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b87:	c9                   	leave  
  800b88:	c3                   	ret    

00800b89 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
  800b8c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b8f:	8d 45 10             	lea    0x10(%ebp),%eax
  800b92:	83 c0 04             	add    $0x4,%eax
  800b95:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b98:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b9e:	50                   	push   %eax
  800b9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ba2:	ff 75 08             	pushl  0x8(%ebp)
  800ba5:	e8 89 ff ff ff       	call   800b33 <vsnprintf>
  800baa:	83 c4 10             	add    $0x10,%esp
  800bad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb3:	c9                   	leave  
  800bb4:	c3                   	ret    

00800bb5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc2:	eb 06                	jmp    800bca <strlen+0x15>
		n++;
  800bc4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bc7:	ff 45 08             	incl   0x8(%ebp)
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	8a 00                	mov    (%eax),%al
  800bcf:	84 c0                	test   %al,%al
  800bd1:	75 f1                	jne    800bc4 <strlen+0xf>
		n++;
	return n;
  800bd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd6:	c9                   	leave  
  800bd7:	c3                   	ret    

00800bd8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bde:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be5:	eb 09                	jmp    800bf0 <strnlen+0x18>
		n++;
  800be7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bea:	ff 45 08             	incl   0x8(%ebp)
  800bed:	ff 4d 0c             	decl   0xc(%ebp)
  800bf0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf4:	74 09                	je     800bff <strnlen+0x27>
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	8a 00                	mov    (%eax),%al
  800bfb:	84 c0                	test   %al,%al
  800bfd:	75 e8                	jne    800be7 <strnlen+0xf>
		n++;
	return n;
  800bff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c10:	90                   	nop
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	8d 50 01             	lea    0x1(%eax),%edx
  800c17:	89 55 08             	mov    %edx,0x8(%ebp)
  800c1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c1d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c20:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c23:	8a 12                	mov    (%edx),%dl
  800c25:	88 10                	mov    %dl,(%eax)
  800c27:	8a 00                	mov    (%eax),%al
  800c29:	84 c0                	test   %al,%al
  800c2b:	75 e4                	jne    800c11 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c30:	c9                   	leave  
  800c31:	c3                   	ret    

00800c32 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c45:	eb 1f                	jmp    800c66 <strncpy+0x34>
		*dst++ = *src;
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	8d 50 01             	lea    0x1(%eax),%edx
  800c4d:	89 55 08             	mov    %edx,0x8(%ebp)
  800c50:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c53:	8a 12                	mov    (%edx),%dl
  800c55:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	84 c0                	test   %al,%al
  800c5e:	74 03                	je     800c63 <strncpy+0x31>
			src++;
  800c60:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c63:	ff 45 fc             	incl   -0x4(%ebp)
  800c66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c69:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c6c:	72 d9                	jb     800c47 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c71:	c9                   	leave  
  800c72:	c3                   	ret    

00800c73 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c83:	74 30                	je     800cb5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c85:	eb 16                	jmp    800c9d <strlcpy+0x2a>
			*dst++ = *src++;
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	8d 50 01             	lea    0x1(%eax),%edx
  800c8d:	89 55 08             	mov    %edx,0x8(%ebp)
  800c90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c93:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c96:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c99:	8a 12                	mov    (%edx),%dl
  800c9b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c9d:	ff 4d 10             	decl   0x10(%ebp)
  800ca0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca4:	74 09                	je     800caf <strlcpy+0x3c>
  800ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca9:	8a 00                	mov    (%eax),%al
  800cab:	84 c0                	test   %al,%al
  800cad:	75 d8                	jne    800c87 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbb:	29 c2                	sub    %eax,%edx
  800cbd:	89 d0                	mov    %edx,%eax
}
  800cbf:	c9                   	leave  
  800cc0:	c3                   	ret    

00800cc1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cc4:	eb 06                	jmp    800ccc <strcmp+0xb>
		p++, q++;
  800cc6:	ff 45 08             	incl   0x8(%ebp)
  800cc9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	84 c0                	test   %al,%al
  800cd3:	74 0e                	je     800ce3 <strcmp+0x22>
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8a 10                	mov    (%eax),%dl
  800cda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	38 c2                	cmp    %al,%dl
  800ce1:	74 e3                	je     800cc6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	8a 00                	mov    (%eax),%al
  800ce8:	0f b6 d0             	movzbl %al,%edx
  800ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cee:	8a 00                	mov    (%eax),%al
  800cf0:	0f b6 c0             	movzbl %al,%eax
  800cf3:	29 c2                	sub    %eax,%edx
  800cf5:	89 d0                	mov    %edx,%eax
}
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cfc:	eb 09                	jmp    800d07 <strncmp+0xe>
		n--, p++, q++;
  800cfe:	ff 4d 10             	decl   0x10(%ebp)
  800d01:	ff 45 08             	incl   0x8(%ebp)
  800d04:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0b:	74 17                	je     800d24 <strncmp+0x2b>
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	84 c0                	test   %al,%al
  800d14:	74 0e                	je     800d24 <strncmp+0x2b>
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8a 10                	mov    (%eax),%dl
  800d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1e:	8a 00                	mov    (%eax),%al
  800d20:	38 c2                	cmp    %al,%dl
  800d22:	74 da                	je     800cfe <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d28:	75 07                	jne    800d31 <strncmp+0x38>
		return 0;
  800d2a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2f:	eb 14                	jmp    800d45 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	0f b6 d0             	movzbl %al,%edx
  800d39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	0f b6 c0             	movzbl %al,%eax
  800d41:	29 c2                	sub    %eax,%edx
  800d43:	89 d0                	mov    %edx,%eax
}
  800d45:	5d                   	pop    %ebp
  800d46:	c3                   	ret    

00800d47 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	83 ec 04             	sub    $0x4,%esp
  800d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d50:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d53:	eb 12                	jmp    800d67 <strchr+0x20>
		if (*s == c)
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d5d:	75 05                	jne    800d64 <strchr+0x1d>
			return (char *) s;
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	eb 11                	jmp    800d75 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d64:	ff 45 08             	incl   0x8(%ebp)
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	84 c0                	test   %al,%al
  800d6e:	75 e5                	jne    800d55 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d75:	c9                   	leave  
  800d76:	c3                   	ret    

00800d77 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	83 ec 04             	sub    $0x4,%esp
  800d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d80:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d83:	eb 0d                	jmp    800d92 <strfind+0x1b>
		if (*s == c)
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d8d:	74 0e                	je     800d9d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d8f:	ff 45 08             	incl   0x8(%ebp)
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	84 c0                	test   %al,%al
  800d99:	75 ea                	jne    800d85 <strfind+0xe>
  800d9b:	eb 01                	jmp    800d9e <strfind+0x27>
		if (*s == c)
			break;
  800d9d:	90                   	nop
	return (char *) s;
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da1:	c9                   	leave  
  800da2:	c3                   	ret    

00800da3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800daf:	8b 45 10             	mov    0x10(%ebp),%eax
  800db2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800db5:	eb 0e                	jmp    800dc5 <memset+0x22>
		*p++ = c;
  800db7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dba:	8d 50 01             	lea    0x1(%eax),%edx
  800dbd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dc5:	ff 4d f8             	decl   -0x8(%ebp)
  800dc8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dcc:	79 e9                	jns    800db7 <memset+0x14>
		*p++ = c;

	return v;
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd1:	c9                   	leave  
  800dd2:	c3                   	ret    

00800dd3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800de5:	eb 16                	jmp    800dfd <memcpy+0x2a>
		*d++ = *s++;
  800de7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dea:	8d 50 01             	lea    0x1(%eax),%edx
  800ded:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800df0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800df3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800df9:	8a 12                	mov    (%edx),%dl
  800dfb:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dfd:	8b 45 10             	mov    0x10(%ebp),%eax
  800e00:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e03:	89 55 10             	mov    %edx,0x10(%ebp)
  800e06:	85 c0                	test   %eax,%eax
  800e08:	75 dd                	jne    800de7 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0d:	c9                   	leave  
  800e0e:	c3                   	ret    

00800e0f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
  800e12:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e24:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e27:	73 50                	jae    800e79 <memmove+0x6a>
  800e29:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2f:	01 d0                	add    %edx,%eax
  800e31:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e34:	76 43                	jbe    800e79 <memmove+0x6a>
		s += n;
  800e36:	8b 45 10             	mov    0x10(%ebp),%eax
  800e39:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e42:	eb 10                	jmp    800e54 <memmove+0x45>
			*--d = *--s;
  800e44:	ff 4d f8             	decl   -0x8(%ebp)
  800e47:	ff 4d fc             	decl   -0x4(%ebp)
  800e4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e4d:	8a 10                	mov    (%eax),%dl
  800e4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e52:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e54:	8b 45 10             	mov    0x10(%ebp),%eax
  800e57:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5d:	85 c0                	test   %eax,%eax
  800e5f:	75 e3                	jne    800e44 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e61:	eb 23                	jmp    800e86 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e63:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e66:	8d 50 01             	lea    0x1(%eax),%edx
  800e69:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e72:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e75:	8a 12                	mov    (%edx),%dl
  800e77:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e79:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e7f:	89 55 10             	mov    %edx,0x10(%ebp)
  800e82:	85 c0                	test   %eax,%eax
  800e84:	75 dd                	jne    800e63 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e89:	c9                   	leave  
  800e8a:	c3                   	ret    

00800e8b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e9d:	eb 2a                	jmp    800ec9 <memcmp+0x3e>
		if (*s1 != *s2)
  800e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea2:	8a 10                	mov    (%eax),%dl
  800ea4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea7:	8a 00                	mov    (%eax),%al
  800ea9:	38 c2                	cmp    %al,%dl
  800eab:	74 16                	je     800ec3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ead:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb0:	8a 00                	mov    (%eax),%al
  800eb2:	0f b6 d0             	movzbl %al,%edx
  800eb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	0f b6 c0             	movzbl %al,%eax
  800ebd:	29 c2                	sub    %eax,%edx
  800ebf:	89 d0                	mov    %edx,%eax
  800ec1:	eb 18                	jmp    800edb <memcmp+0x50>
		s1++, s2++;
  800ec3:	ff 45 fc             	incl   -0x4(%ebp)
  800ec6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ec9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ecf:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed2:	85 c0                	test   %eax,%eax
  800ed4:	75 c9                	jne    800e9f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ed6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800edb:	c9                   	leave  
  800edc:	c3                   	ret    

00800edd <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ee3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee9:	01 d0                	add    %edx,%eax
  800eeb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eee:	eb 15                	jmp    800f05 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	0f b6 d0             	movzbl %al,%edx
  800ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efb:	0f b6 c0             	movzbl %al,%eax
  800efe:	39 c2                	cmp    %eax,%edx
  800f00:	74 0d                	je     800f0f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f02:	ff 45 08             	incl   0x8(%ebp)
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f0b:	72 e3                	jb     800ef0 <memfind+0x13>
  800f0d:	eb 01                	jmp    800f10 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f0f:	90                   	nop
	return (void *) s;
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f13:	c9                   	leave  
  800f14:	c3                   	ret    

00800f15 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f22:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f29:	eb 03                	jmp    800f2e <strtol+0x19>
		s++;
  800f2b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	3c 20                	cmp    $0x20,%al
  800f35:	74 f4                	je     800f2b <strtol+0x16>
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	8a 00                	mov    (%eax),%al
  800f3c:	3c 09                	cmp    $0x9,%al
  800f3e:	74 eb                	je     800f2b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	3c 2b                	cmp    $0x2b,%al
  800f47:	75 05                	jne    800f4e <strtol+0x39>
		s++;
  800f49:	ff 45 08             	incl   0x8(%ebp)
  800f4c:	eb 13                	jmp    800f61 <strtol+0x4c>
	else if (*s == '-')
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	3c 2d                	cmp    $0x2d,%al
  800f55:	75 0a                	jne    800f61 <strtol+0x4c>
		s++, neg = 1;
  800f57:	ff 45 08             	incl   0x8(%ebp)
  800f5a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f65:	74 06                	je     800f6d <strtol+0x58>
  800f67:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f6b:	75 20                	jne    800f8d <strtol+0x78>
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	3c 30                	cmp    $0x30,%al
  800f74:	75 17                	jne    800f8d <strtol+0x78>
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	40                   	inc    %eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	3c 78                	cmp    $0x78,%al
  800f7e:	75 0d                	jne    800f8d <strtol+0x78>
		s += 2, base = 16;
  800f80:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f84:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f8b:	eb 28                	jmp    800fb5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f91:	75 15                	jne    800fa8 <strtol+0x93>
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	3c 30                	cmp    $0x30,%al
  800f9a:	75 0c                	jne    800fa8 <strtol+0x93>
		s++, base = 8;
  800f9c:	ff 45 08             	incl   0x8(%ebp)
  800f9f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fa6:	eb 0d                	jmp    800fb5 <strtol+0xa0>
	else if (base == 0)
  800fa8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fac:	75 07                	jne    800fb5 <strtol+0xa0>
		base = 10;
  800fae:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3c 2f                	cmp    $0x2f,%al
  800fbc:	7e 19                	jle    800fd7 <strtol+0xc2>
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	3c 39                	cmp    $0x39,%al
  800fc5:	7f 10                	jg     800fd7 <strtol+0xc2>
			dig = *s - '0';
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	0f be c0             	movsbl %al,%eax
  800fcf:	83 e8 30             	sub    $0x30,%eax
  800fd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd5:	eb 42                	jmp    801019 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 60                	cmp    $0x60,%al
  800fde:	7e 19                	jle    800ff9 <strtol+0xe4>
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	3c 7a                	cmp    $0x7a,%al
  800fe7:	7f 10                	jg     800ff9 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	0f be c0             	movsbl %al,%eax
  800ff1:	83 e8 57             	sub    $0x57,%eax
  800ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ff7:	eb 20                	jmp    801019 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	3c 40                	cmp    $0x40,%al
  801000:	7e 39                	jle    80103b <strtol+0x126>
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	3c 5a                	cmp    $0x5a,%al
  801009:	7f 30                	jg     80103b <strtol+0x126>
			dig = *s - 'A' + 10;
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	0f be c0             	movsbl %al,%eax
  801013:	83 e8 37             	sub    $0x37,%eax
  801016:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80101f:	7d 19                	jge    80103a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801021:	ff 45 08             	incl   0x8(%ebp)
  801024:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801027:	0f af 45 10          	imul   0x10(%ebp),%eax
  80102b:	89 c2                	mov    %eax,%edx
  80102d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801030:	01 d0                	add    %edx,%eax
  801032:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801035:	e9 7b ff ff ff       	jmp    800fb5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80103a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80103b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80103f:	74 08                	je     801049 <strtol+0x134>
		*endptr = (char *) s;
  801041:	8b 45 0c             	mov    0xc(%ebp),%eax
  801044:	8b 55 08             	mov    0x8(%ebp),%edx
  801047:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801049:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80104d:	74 07                	je     801056 <strtol+0x141>
  80104f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801052:	f7 d8                	neg    %eax
  801054:	eb 03                	jmp    801059 <strtol+0x144>
  801056:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801059:	c9                   	leave  
  80105a:	c3                   	ret    

0080105b <ltostr>:

void
ltostr(long value, char *str)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801068:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80106f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801073:	79 13                	jns    801088 <ltostr+0x2d>
	{
		neg = 1;
  801075:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80107c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801082:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801085:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801090:	99                   	cltd   
  801091:	f7 f9                	idiv   %ecx
  801093:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801096:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801099:	8d 50 01             	lea    0x1(%eax),%edx
  80109c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80109f:	89 c2                	mov    %eax,%edx
  8010a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a4:	01 d0                	add    %edx,%eax
  8010a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010a9:	83 c2 30             	add    $0x30,%edx
  8010ac:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010b6:	f7 e9                	imul   %ecx
  8010b8:	c1 fa 02             	sar    $0x2,%edx
  8010bb:	89 c8                	mov    %ecx,%eax
  8010bd:	c1 f8 1f             	sar    $0x1f,%eax
  8010c0:	29 c2                	sub    %eax,%edx
  8010c2:	89 d0                	mov    %edx,%eax
  8010c4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ca:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010cf:	f7 e9                	imul   %ecx
  8010d1:	c1 fa 02             	sar    $0x2,%edx
  8010d4:	89 c8                	mov    %ecx,%eax
  8010d6:	c1 f8 1f             	sar    $0x1f,%eax
  8010d9:	29 c2                	sub    %eax,%edx
  8010db:	89 d0                	mov    %edx,%eax
  8010dd:	c1 e0 02             	shl    $0x2,%eax
  8010e0:	01 d0                	add    %edx,%eax
  8010e2:	01 c0                	add    %eax,%eax
  8010e4:	29 c1                	sub    %eax,%ecx
  8010e6:	89 ca                	mov    %ecx,%edx
  8010e8:	85 d2                	test   %edx,%edx
  8010ea:	75 9c                	jne    801088 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f6:	48                   	dec    %eax
  8010f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010fe:	74 3d                	je     80113d <ltostr+0xe2>
		start = 1 ;
  801100:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801107:	eb 34                	jmp    80113d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801109:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110f:	01 d0                	add    %edx,%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801116:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111c:	01 c2                	add    %eax,%edx
  80111e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801121:	8b 45 0c             	mov    0xc(%ebp),%eax
  801124:	01 c8                	add    %ecx,%eax
  801126:	8a 00                	mov    (%eax),%al
  801128:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80112a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80112d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801130:	01 c2                	add    %eax,%edx
  801132:	8a 45 eb             	mov    -0x15(%ebp),%al
  801135:	88 02                	mov    %al,(%edx)
		start++ ;
  801137:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80113a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80113d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801140:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801143:	7c c4                	jl     801109 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801145:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	01 d0                	add    %edx,%eax
  80114d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801150:	90                   	nop
  801151:	c9                   	leave  
  801152:	c3                   	ret    

00801153 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801159:	ff 75 08             	pushl  0x8(%ebp)
  80115c:	e8 54 fa ff ff       	call   800bb5 <strlen>
  801161:	83 c4 04             	add    $0x4,%esp
  801164:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801167:	ff 75 0c             	pushl  0xc(%ebp)
  80116a:	e8 46 fa ff ff       	call   800bb5 <strlen>
  80116f:	83 c4 04             	add    $0x4,%esp
  801172:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801175:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80117c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801183:	eb 17                	jmp    80119c <strcconcat+0x49>
		final[s] = str1[s] ;
  801185:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801188:	8b 45 10             	mov    0x10(%ebp),%eax
  80118b:	01 c2                	add    %eax,%edx
  80118d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	01 c8                	add    %ecx,%eax
  801195:	8a 00                	mov    (%eax),%al
  801197:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801199:	ff 45 fc             	incl   -0x4(%ebp)
  80119c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80119f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011a2:	7c e1                	jl     801185 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011a4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011b2:	eb 1f                	jmp    8011d3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ba:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011bd:	89 c2                	mov    %eax,%edx
  8011bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c2:	01 c2                	add    %eax,%edx
  8011c4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ca:	01 c8                	add    %ecx,%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011d0:	ff 45 f8             	incl   -0x8(%ebp)
  8011d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d9:	7c d9                	jl     8011b4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011de:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e1:	01 d0                	add    %edx,%eax
  8011e3:	c6 00 00             	movb   $0x0,(%eax)
}
  8011e6:	90                   	nop
  8011e7:	c9                   	leave  
  8011e8:	c3                   	ret    

008011e9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f8:	8b 00                	mov    (%eax),%eax
  8011fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801201:	8b 45 10             	mov    0x10(%ebp),%eax
  801204:	01 d0                	add    %edx,%eax
  801206:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120c:	eb 0c                	jmp    80121a <strsplit+0x31>
			*string++ = 0;
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	8d 50 01             	lea    0x1(%eax),%edx
  801214:	89 55 08             	mov    %edx,0x8(%ebp)
  801217:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	84 c0                	test   %al,%al
  801221:	74 18                	je     80123b <strsplit+0x52>
  801223:	8b 45 08             	mov    0x8(%ebp),%eax
  801226:	8a 00                	mov    (%eax),%al
  801228:	0f be c0             	movsbl %al,%eax
  80122b:	50                   	push   %eax
  80122c:	ff 75 0c             	pushl  0xc(%ebp)
  80122f:	e8 13 fb ff ff       	call   800d47 <strchr>
  801234:	83 c4 08             	add    $0x8,%esp
  801237:	85 c0                	test   %eax,%eax
  801239:	75 d3                	jne    80120e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	8a 00                	mov    (%eax),%al
  801240:	84 c0                	test   %al,%al
  801242:	74 5a                	je     80129e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801244:	8b 45 14             	mov    0x14(%ebp),%eax
  801247:	8b 00                	mov    (%eax),%eax
  801249:	83 f8 0f             	cmp    $0xf,%eax
  80124c:	75 07                	jne    801255 <strsplit+0x6c>
		{
			return 0;
  80124e:	b8 00 00 00 00       	mov    $0x0,%eax
  801253:	eb 66                	jmp    8012bb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801255:	8b 45 14             	mov    0x14(%ebp),%eax
  801258:	8b 00                	mov    (%eax),%eax
  80125a:	8d 48 01             	lea    0x1(%eax),%ecx
  80125d:	8b 55 14             	mov    0x14(%ebp),%edx
  801260:	89 0a                	mov    %ecx,(%edx)
  801262:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801269:	8b 45 10             	mov    0x10(%ebp),%eax
  80126c:	01 c2                	add    %eax,%edx
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801273:	eb 03                	jmp    801278 <strsplit+0x8f>
			string++;
  801275:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	8a 00                	mov    (%eax),%al
  80127d:	84 c0                	test   %al,%al
  80127f:	74 8b                	je     80120c <strsplit+0x23>
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	0f be c0             	movsbl %al,%eax
  801289:	50                   	push   %eax
  80128a:	ff 75 0c             	pushl  0xc(%ebp)
  80128d:	e8 b5 fa ff ff       	call   800d47 <strchr>
  801292:	83 c4 08             	add    $0x8,%esp
  801295:	85 c0                	test   %eax,%eax
  801297:	74 dc                	je     801275 <strsplit+0x8c>
			string++;
	}
  801299:	e9 6e ff ff ff       	jmp    80120c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80129e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80129f:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a2:	8b 00                	mov    (%eax),%eax
  8012a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ae:	01 d0                	add    %edx,%eax
  8012b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012b6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012bb:	c9                   	leave  
  8012bc:	c3                   	ret    

008012bd <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012c3:	a1 04 40 80 00       	mov    0x804004,%eax
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	74 1f                	je     8012eb <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012cc:	e8 1d 00 00 00       	call   8012ee <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012d1:	83 ec 0c             	sub    $0xc,%esp
  8012d4:	68 10 38 80 00       	push   $0x803810
  8012d9:	e8 55 f2 ff ff       	call   800533 <cprintf>
  8012de:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012e1:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012e8:	00 00 00 
	}
}
  8012eb:	90                   	nop
  8012ec:	c9                   	leave  
  8012ed:	c3                   	ret    

008012ee <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  8012f4:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8012fb:	00 00 00 
  8012fe:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801305:	00 00 00 
  801308:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80130f:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801312:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801319:	00 00 00 
  80131c:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801323:	00 00 00 
  801326:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80132d:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801330:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801337:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  80133a:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801344:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801349:	2d 00 10 00 00       	sub    $0x1000,%eax
  80134e:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  801353:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  80135a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80135d:	a1 20 41 80 00       	mov    0x804120,%eax
  801362:	0f af c2             	imul   %edx,%eax
  801365:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801368:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  80136f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801372:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801375:	01 d0                	add    %edx,%eax
  801377:	48                   	dec    %eax
  801378:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80137b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80137e:	ba 00 00 00 00       	mov    $0x0,%edx
  801383:	f7 75 e8             	divl   -0x18(%ebp)
  801386:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801389:	29 d0                	sub    %edx,%eax
  80138b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  80138e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801391:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801398:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80139b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8013a1:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8013a7:	83 ec 04             	sub    $0x4,%esp
  8013aa:	6a 06                	push   $0x6
  8013ac:	50                   	push   %eax
  8013ad:	52                   	push   %edx
  8013ae:	e8 a1 05 00 00       	call   801954 <sys_allocate_chunk>
  8013b3:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013b6:	a1 20 41 80 00       	mov    0x804120,%eax
  8013bb:	83 ec 0c             	sub    $0xc,%esp
  8013be:	50                   	push   %eax
  8013bf:	e8 16 0c 00 00       	call   801fda <initialize_MemBlocksList>
  8013c4:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  8013c7:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8013cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  8013cf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8013d3:	75 14                	jne    8013e9 <initialize_dyn_block_system+0xfb>
  8013d5:	83 ec 04             	sub    $0x4,%esp
  8013d8:	68 35 38 80 00       	push   $0x803835
  8013dd:	6a 2d                	push   $0x2d
  8013df:	68 53 38 80 00       	push   $0x803853
  8013e4:	e8 96 ee ff ff       	call   80027f <_panic>
  8013e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013ec:	8b 00                	mov    (%eax),%eax
  8013ee:	85 c0                	test   %eax,%eax
  8013f0:	74 10                	je     801402 <initialize_dyn_block_system+0x114>
  8013f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013f5:	8b 00                	mov    (%eax),%eax
  8013f7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8013fa:	8b 52 04             	mov    0x4(%edx),%edx
  8013fd:	89 50 04             	mov    %edx,0x4(%eax)
  801400:	eb 0b                	jmp    80140d <initialize_dyn_block_system+0x11f>
  801402:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801405:	8b 40 04             	mov    0x4(%eax),%eax
  801408:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80140d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801410:	8b 40 04             	mov    0x4(%eax),%eax
  801413:	85 c0                	test   %eax,%eax
  801415:	74 0f                	je     801426 <initialize_dyn_block_system+0x138>
  801417:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80141a:	8b 40 04             	mov    0x4(%eax),%eax
  80141d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801420:	8b 12                	mov    (%edx),%edx
  801422:	89 10                	mov    %edx,(%eax)
  801424:	eb 0a                	jmp    801430 <initialize_dyn_block_system+0x142>
  801426:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801429:	8b 00                	mov    (%eax),%eax
  80142b:	a3 48 41 80 00       	mov    %eax,0x804148
  801430:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801433:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801439:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80143c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801443:	a1 54 41 80 00       	mov    0x804154,%eax
  801448:	48                   	dec    %eax
  801449:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  80144e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801451:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801458:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80145b:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801462:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801466:	75 14                	jne    80147c <initialize_dyn_block_system+0x18e>
  801468:	83 ec 04             	sub    $0x4,%esp
  80146b:	68 60 38 80 00       	push   $0x803860
  801470:	6a 30                	push   $0x30
  801472:	68 53 38 80 00       	push   $0x803853
  801477:	e8 03 ee ff ff       	call   80027f <_panic>
  80147c:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  801482:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801485:	89 50 04             	mov    %edx,0x4(%eax)
  801488:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80148b:	8b 40 04             	mov    0x4(%eax),%eax
  80148e:	85 c0                	test   %eax,%eax
  801490:	74 0c                	je     80149e <initialize_dyn_block_system+0x1b0>
  801492:	a1 3c 41 80 00       	mov    0x80413c,%eax
  801497:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80149a:	89 10                	mov    %edx,(%eax)
  80149c:	eb 08                	jmp    8014a6 <initialize_dyn_block_system+0x1b8>
  80149e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014a1:	a3 38 41 80 00       	mov    %eax,0x804138
  8014a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014a9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8014ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014b7:	a1 44 41 80 00       	mov    0x804144,%eax
  8014bc:	40                   	inc    %eax
  8014bd:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8014c2:	90                   	nop
  8014c3:	c9                   	leave  
  8014c4:	c3                   	ret    

008014c5 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
  8014c8:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014cb:	e8 ed fd ff ff       	call   8012bd <InitializeUHeap>
	if (size == 0) return NULL ;
  8014d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014d4:	75 07                	jne    8014dd <malloc+0x18>
  8014d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014db:	eb 67                	jmp    801544 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  8014dd:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ea:	01 d0                	add    %edx,%eax
  8014ec:	48                   	dec    %eax
  8014ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f8:	f7 75 f4             	divl   -0xc(%ebp)
  8014fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014fe:	29 d0                	sub    %edx,%eax
  801500:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801503:	e8 1a 08 00 00       	call   801d22 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801508:	85 c0                	test   %eax,%eax
  80150a:	74 33                	je     80153f <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  80150c:	83 ec 0c             	sub    $0xc,%esp
  80150f:	ff 75 08             	pushl  0x8(%ebp)
  801512:	e8 0c 0e 00 00       	call   802323 <alloc_block_FF>
  801517:	83 c4 10             	add    $0x10,%esp
  80151a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  80151d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801521:	74 1c                	je     80153f <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801523:	83 ec 0c             	sub    $0xc,%esp
  801526:	ff 75 ec             	pushl  -0x14(%ebp)
  801529:	e8 07 0c 00 00       	call   802135 <insert_sorted_allocList>
  80152e:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801531:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801534:	8b 40 08             	mov    0x8(%eax),%eax
  801537:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  80153a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80153d:	eb 05                	jmp    801544 <malloc+0x7f>
		}
	}
	return NULL;
  80153f:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801544:	c9                   	leave  
  801545:	c3                   	ret    

00801546 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
  801549:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801552:	83 ec 08             	sub    $0x8,%esp
  801555:	ff 75 f4             	pushl  -0xc(%ebp)
  801558:	68 40 40 80 00       	push   $0x804040
  80155d:	e8 5b 0b 00 00       	call   8020bd <find_block>
  801562:	83 c4 10             	add    $0x10,%esp
  801565:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801568:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156b:	8b 40 0c             	mov    0xc(%eax),%eax
  80156e:	83 ec 08             	sub    $0x8,%esp
  801571:	50                   	push   %eax
  801572:	ff 75 f4             	pushl  -0xc(%ebp)
  801575:	e8 a2 03 00 00       	call   80191c <sys_free_user_mem>
  80157a:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  80157d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801581:	75 14                	jne    801597 <free+0x51>
  801583:	83 ec 04             	sub    $0x4,%esp
  801586:	68 35 38 80 00       	push   $0x803835
  80158b:	6a 76                	push   $0x76
  80158d:	68 53 38 80 00       	push   $0x803853
  801592:	e8 e8 ec ff ff       	call   80027f <_panic>
  801597:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159a:	8b 00                	mov    (%eax),%eax
  80159c:	85 c0                	test   %eax,%eax
  80159e:	74 10                	je     8015b0 <free+0x6a>
  8015a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a3:	8b 00                	mov    (%eax),%eax
  8015a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015a8:	8b 52 04             	mov    0x4(%edx),%edx
  8015ab:	89 50 04             	mov    %edx,0x4(%eax)
  8015ae:	eb 0b                	jmp    8015bb <free+0x75>
  8015b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b3:	8b 40 04             	mov    0x4(%eax),%eax
  8015b6:	a3 44 40 80 00       	mov    %eax,0x804044
  8015bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015be:	8b 40 04             	mov    0x4(%eax),%eax
  8015c1:	85 c0                	test   %eax,%eax
  8015c3:	74 0f                	je     8015d4 <free+0x8e>
  8015c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c8:	8b 40 04             	mov    0x4(%eax),%eax
  8015cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015ce:	8b 12                	mov    (%edx),%edx
  8015d0:	89 10                	mov    %edx,(%eax)
  8015d2:	eb 0a                	jmp    8015de <free+0x98>
  8015d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d7:	8b 00                	mov    (%eax),%eax
  8015d9:	a3 40 40 80 00       	mov    %eax,0x804040
  8015de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015f1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015f6:	48                   	dec    %eax
  8015f7:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  8015fc:	83 ec 0c             	sub    $0xc,%esp
  8015ff:	ff 75 f0             	pushl  -0x10(%ebp)
  801602:	e8 0b 14 00 00       	call   802a12 <insert_sorted_with_merge_freeList>
  801607:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80160a:	90                   	nop
  80160b:	c9                   	leave  
  80160c:	c3                   	ret    

0080160d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
  801610:	83 ec 28             	sub    $0x28,%esp
  801613:	8b 45 10             	mov    0x10(%ebp),%eax
  801616:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801619:	e8 9f fc ff ff       	call   8012bd <InitializeUHeap>
	if (size == 0) return NULL ;
  80161e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801622:	75 0a                	jne    80162e <smalloc+0x21>
  801624:	b8 00 00 00 00       	mov    $0x0,%eax
  801629:	e9 8d 00 00 00       	jmp    8016bb <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  80162e:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801635:	8b 55 0c             	mov    0xc(%ebp),%edx
  801638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163b:	01 d0                	add    %edx,%eax
  80163d:	48                   	dec    %eax
  80163e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801641:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801644:	ba 00 00 00 00       	mov    $0x0,%edx
  801649:	f7 75 f4             	divl   -0xc(%ebp)
  80164c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164f:	29 d0                	sub    %edx,%eax
  801651:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801654:	e8 c9 06 00 00       	call   801d22 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801659:	85 c0                	test   %eax,%eax
  80165b:	74 59                	je     8016b6 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  80165d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801664:	83 ec 0c             	sub    $0xc,%esp
  801667:	ff 75 0c             	pushl  0xc(%ebp)
  80166a:	e8 b4 0c 00 00       	call   802323 <alloc_block_FF>
  80166f:	83 c4 10             	add    $0x10,%esp
  801672:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801675:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801679:	75 07                	jne    801682 <smalloc+0x75>
			{
				return NULL;
  80167b:	b8 00 00 00 00       	mov    $0x0,%eax
  801680:	eb 39                	jmp    8016bb <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801682:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801685:	8b 40 08             	mov    0x8(%eax),%eax
  801688:	89 c2                	mov    %eax,%edx
  80168a:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80168e:	52                   	push   %edx
  80168f:	50                   	push   %eax
  801690:	ff 75 0c             	pushl  0xc(%ebp)
  801693:	ff 75 08             	pushl  0x8(%ebp)
  801696:	e8 0c 04 00 00       	call   801aa7 <sys_createSharedObject>
  80169b:	83 c4 10             	add    $0x10,%esp
  80169e:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  8016a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016a5:	78 08                	js     8016af <smalloc+0xa2>
				{
					return (void*)v1->sva;
  8016a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016aa:	8b 40 08             	mov    0x8(%eax),%eax
  8016ad:	eb 0c                	jmp    8016bb <smalloc+0xae>
				}
				else
				{
					return NULL;
  8016af:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b4:	eb 05                	jmp    8016bb <smalloc+0xae>
				}
			}

		}
		return NULL;
  8016b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016c3:	e8 f5 fb ff ff       	call   8012bd <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016c8:	83 ec 08             	sub    $0x8,%esp
  8016cb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ce:	ff 75 08             	pushl  0x8(%ebp)
  8016d1:	e8 fb 03 00 00       	call   801ad1 <sys_getSizeOfSharedObject>
  8016d6:	83 c4 10             	add    $0x10,%esp
  8016d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  8016dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016e0:	75 07                	jne    8016e9 <sget+0x2c>
	{
		return NULL;
  8016e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e7:	eb 64                	jmp    80174d <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016e9:	e8 34 06 00 00       	call   801d22 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016ee:	85 c0                	test   %eax,%eax
  8016f0:	74 56                	je     801748 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  8016f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  8016f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016fc:	83 ec 0c             	sub    $0xc,%esp
  8016ff:	50                   	push   %eax
  801700:	e8 1e 0c 00 00       	call   802323 <alloc_block_FF>
  801705:	83 c4 10             	add    $0x10,%esp
  801708:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  80170b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80170f:	75 07                	jne    801718 <sget+0x5b>
		{
		return NULL;
  801711:	b8 00 00 00 00       	mov    $0x0,%eax
  801716:	eb 35                	jmp    80174d <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801718:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171b:	8b 40 08             	mov    0x8(%eax),%eax
  80171e:	83 ec 04             	sub    $0x4,%esp
  801721:	50                   	push   %eax
  801722:	ff 75 0c             	pushl  0xc(%ebp)
  801725:	ff 75 08             	pushl  0x8(%ebp)
  801728:	e8 c1 03 00 00       	call   801aee <sys_getSharedObject>
  80172d:	83 c4 10             	add    $0x10,%esp
  801730:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801733:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801737:	78 08                	js     801741 <sget+0x84>
			{
				return (void*)v1->sva;
  801739:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173c:	8b 40 08             	mov    0x8(%eax),%eax
  80173f:	eb 0c                	jmp    80174d <sget+0x90>
			}
			else
			{
				return NULL;
  801741:	b8 00 00 00 00       	mov    $0x0,%eax
  801746:	eb 05                	jmp    80174d <sget+0x90>
			}
		}
	}
  return NULL;
  801748:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174d:	c9                   	leave  
  80174e:	c3                   	ret    

0080174f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801755:	e8 63 fb ff ff       	call   8012bd <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80175a:	83 ec 04             	sub    $0x4,%esp
  80175d:	68 84 38 80 00       	push   $0x803884
  801762:	68 0e 01 00 00       	push   $0x10e
  801767:	68 53 38 80 00       	push   $0x803853
  80176c:	e8 0e eb ff ff       	call   80027f <_panic>

00801771 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
  801774:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801777:	83 ec 04             	sub    $0x4,%esp
  80177a:	68 ac 38 80 00       	push   $0x8038ac
  80177f:	68 22 01 00 00       	push   $0x122
  801784:	68 53 38 80 00       	push   $0x803853
  801789:	e8 f1 ea ff ff       	call   80027f <_panic>

0080178e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801794:	83 ec 04             	sub    $0x4,%esp
  801797:	68 d0 38 80 00       	push   $0x8038d0
  80179c:	68 2d 01 00 00       	push   $0x12d
  8017a1:	68 53 38 80 00       	push   $0x803853
  8017a6:	e8 d4 ea ff ff       	call   80027f <_panic>

008017ab <shrink>:

}
void shrink(uint32 newSize)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017b1:	83 ec 04             	sub    $0x4,%esp
  8017b4:	68 d0 38 80 00       	push   $0x8038d0
  8017b9:	68 32 01 00 00       	push   $0x132
  8017be:	68 53 38 80 00       	push   $0x803853
  8017c3:	e8 b7 ea ff ff       	call   80027f <_panic>

008017c8 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017ce:	83 ec 04             	sub    $0x4,%esp
  8017d1:	68 d0 38 80 00       	push   $0x8038d0
  8017d6:	68 37 01 00 00       	push   $0x137
  8017db:	68 53 38 80 00       	push   $0x803853
  8017e0:	e8 9a ea ff ff       	call   80027f <_panic>

008017e5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
  8017e8:	57                   	push   %edi
  8017e9:	56                   	push   %esi
  8017ea:	53                   	push   %ebx
  8017eb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017f7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017fa:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017fd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801800:	cd 30                	int    $0x30
  801802:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801805:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801808:	83 c4 10             	add    $0x10,%esp
  80180b:	5b                   	pop    %ebx
  80180c:	5e                   	pop    %esi
  80180d:	5f                   	pop    %edi
  80180e:	5d                   	pop    %ebp
  80180f:	c3                   	ret    

00801810 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	83 ec 04             	sub    $0x4,%esp
  801816:	8b 45 10             	mov    0x10(%ebp),%eax
  801819:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80181c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	52                   	push   %edx
  801828:	ff 75 0c             	pushl  0xc(%ebp)
  80182b:	50                   	push   %eax
  80182c:	6a 00                	push   $0x0
  80182e:	e8 b2 ff ff ff       	call   8017e5 <syscall>
  801833:	83 c4 18             	add    $0x18,%esp
}
  801836:	90                   	nop
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <sys_cgetc>:

int
sys_cgetc(void)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 01                	push   $0x1
  801848:	e8 98 ff ff ff       	call   8017e5 <syscall>
  80184d:	83 c4 18             	add    $0x18,%esp
}
  801850:	c9                   	leave  
  801851:	c3                   	ret    

00801852 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801855:	8b 55 0c             	mov    0xc(%ebp),%edx
  801858:	8b 45 08             	mov    0x8(%ebp),%eax
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	52                   	push   %edx
  801862:	50                   	push   %eax
  801863:	6a 05                	push   $0x5
  801865:	e8 7b ff ff ff       	call   8017e5 <syscall>
  80186a:	83 c4 18             	add    $0x18,%esp
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	56                   	push   %esi
  801873:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801874:	8b 75 18             	mov    0x18(%ebp),%esi
  801877:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80187a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80187d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801880:	8b 45 08             	mov    0x8(%ebp),%eax
  801883:	56                   	push   %esi
  801884:	53                   	push   %ebx
  801885:	51                   	push   %ecx
  801886:	52                   	push   %edx
  801887:	50                   	push   %eax
  801888:	6a 06                	push   $0x6
  80188a:	e8 56 ff ff ff       	call   8017e5 <syscall>
  80188f:	83 c4 18             	add    $0x18,%esp
}
  801892:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801895:	5b                   	pop    %ebx
  801896:	5e                   	pop    %esi
  801897:	5d                   	pop    %ebp
  801898:	c3                   	ret    

00801899 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80189c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	52                   	push   %edx
  8018a9:	50                   	push   %eax
  8018aa:	6a 07                	push   $0x7
  8018ac:	e8 34 ff ff ff       	call   8017e5 <syscall>
  8018b1:	83 c4 18             	add    $0x18,%esp
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	ff 75 0c             	pushl  0xc(%ebp)
  8018c2:	ff 75 08             	pushl  0x8(%ebp)
  8018c5:	6a 08                	push   $0x8
  8018c7:	e8 19 ff ff ff       	call   8017e5 <syscall>
  8018cc:	83 c4 18             	add    $0x18,%esp
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 09                	push   $0x9
  8018e0:	e8 00 ff ff ff       	call   8017e5 <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 0a                	push   $0xa
  8018f9:	e8 e7 fe ff ff       	call   8017e5 <syscall>
  8018fe:	83 c4 18             	add    $0x18,%esp
}
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 0b                	push   $0xb
  801912:	e8 ce fe ff ff       	call   8017e5 <syscall>
  801917:	83 c4 18             	add    $0x18,%esp
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	ff 75 0c             	pushl  0xc(%ebp)
  801928:	ff 75 08             	pushl  0x8(%ebp)
  80192b:	6a 0f                	push   $0xf
  80192d:	e8 b3 fe ff ff       	call   8017e5 <syscall>
  801932:	83 c4 18             	add    $0x18,%esp
	return;
  801935:	90                   	nop
}
  801936:	c9                   	leave  
  801937:	c3                   	ret    

00801938 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	ff 75 0c             	pushl  0xc(%ebp)
  801944:	ff 75 08             	pushl  0x8(%ebp)
  801947:	6a 10                	push   $0x10
  801949:	e8 97 fe ff ff       	call   8017e5 <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
	return ;
  801951:	90                   	nop
}
  801952:	c9                   	leave  
  801953:	c3                   	ret    

00801954 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	ff 75 10             	pushl  0x10(%ebp)
  80195e:	ff 75 0c             	pushl  0xc(%ebp)
  801961:	ff 75 08             	pushl  0x8(%ebp)
  801964:	6a 11                	push   $0x11
  801966:	e8 7a fe ff ff       	call   8017e5 <syscall>
  80196b:	83 c4 18             	add    $0x18,%esp
	return ;
  80196e:	90                   	nop
}
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 0c                	push   $0xc
  801980:	e8 60 fe ff ff       	call   8017e5 <syscall>
  801985:	83 c4 18             	add    $0x18,%esp
}
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	ff 75 08             	pushl  0x8(%ebp)
  801998:	6a 0d                	push   $0xd
  80199a:	e8 46 fe ff ff       	call   8017e5 <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 0e                	push   $0xe
  8019b3:	e8 2d fe ff ff       	call   8017e5 <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
}
  8019bb:	90                   	nop
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 13                	push   $0x13
  8019cd:	e8 13 fe ff ff       	call   8017e5 <syscall>
  8019d2:	83 c4 18             	add    $0x18,%esp
}
  8019d5:	90                   	nop
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 14                	push   $0x14
  8019e7:	e8 f9 fd ff ff       	call   8017e5 <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
}
  8019ef:	90                   	nop
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	83 ec 04             	sub    $0x4,%esp
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019fe:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	50                   	push   %eax
  801a0b:	6a 15                	push   $0x15
  801a0d:	e8 d3 fd ff ff       	call   8017e5 <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
}
  801a15:	90                   	nop
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 16                	push   $0x16
  801a27:	e8 b9 fd ff ff       	call   8017e5 <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
}
  801a2f:	90                   	nop
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a35:	8b 45 08             	mov    0x8(%ebp),%eax
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	ff 75 0c             	pushl  0xc(%ebp)
  801a41:	50                   	push   %eax
  801a42:	6a 17                	push   $0x17
  801a44:	e8 9c fd ff ff       	call   8017e5 <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
}
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	52                   	push   %edx
  801a5e:	50                   	push   %eax
  801a5f:	6a 1a                	push   $0x1a
  801a61:	e8 7f fd ff ff       	call   8017e5 <syscall>
  801a66:	83 c4 18             	add    $0x18,%esp
}
  801a69:	c9                   	leave  
  801a6a:	c3                   	ret    

00801a6b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	52                   	push   %edx
  801a7b:	50                   	push   %eax
  801a7c:	6a 18                	push   $0x18
  801a7e:	e8 62 fd ff ff       	call   8017e5 <syscall>
  801a83:	83 c4 18             	add    $0x18,%esp
}
  801a86:	90                   	nop
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	52                   	push   %edx
  801a99:	50                   	push   %eax
  801a9a:	6a 19                	push   $0x19
  801a9c:	e8 44 fd ff ff       	call   8017e5 <syscall>
  801aa1:	83 c4 18             	add    $0x18,%esp
}
  801aa4:	90                   	nop
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
  801aaa:	83 ec 04             	sub    $0x4,%esp
  801aad:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ab3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ab6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aba:	8b 45 08             	mov    0x8(%ebp),%eax
  801abd:	6a 00                	push   $0x0
  801abf:	51                   	push   %ecx
  801ac0:	52                   	push   %edx
  801ac1:	ff 75 0c             	pushl  0xc(%ebp)
  801ac4:	50                   	push   %eax
  801ac5:	6a 1b                	push   $0x1b
  801ac7:	e8 19 fd ff ff       	call   8017e5 <syscall>
  801acc:	83 c4 18             	add    $0x18,%esp
}
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ad4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	52                   	push   %edx
  801ae1:	50                   	push   %eax
  801ae2:	6a 1c                	push   $0x1c
  801ae4:	e8 fc fc ff ff       	call   8017e5 <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801af1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801af4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	51                   	push   %ecx
  801aff:	52                   	push   %edx
  801b00:	50                   	push   %eax
  801b01:	6a 1d                	push   $0x1d
  801b03:	e8 dd fc ff ff       	call   8017e5 <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	52                   	push   %edx
  801b1d:	50                   	push   %eax
  801b1e:	6a 1e                	push   $0x1e
  801b20:	e8 c0 fc ff ff       	call   8017e5 <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 1f                	push   $0x1f
  801b39:	e8 a7 fc ff ff       	call   8017e5 <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
}
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	6a 00                	push   $0x0
  801b4b:	ff 75 14             	pushl  0x14(%ebp)
  801b4e:	ff 75 10             	pushl  0x10(%ebp)
  801b51:	ff 75 0c             	pushl  0xc(%ebp)
  801b54:	50                   	push   %eax
  801b55:	6a 20                	push   $0x20
  801b57:	e8 89 fc ff ff       	call   8017e5 <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	50                   	push   %eax
  801b70:	6a 21                	push   $0x21
  801b72:	e8 6e fc ff ff       	call   8017e5 <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
}
  801b7a:	90                   	nop
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	50                   	push   %eax
  801b8c:	6a 22                	push   $0x22
  801b8e:	e8 52 fc ff ff       	call   8017e5 <syscall>
  801b93:	83 c4 18             	add    $0x18,%esp
}
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 02                	push   $0x2
  801ba7:	e8 39 fc ff ff       	call   8017e5 <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 03                	push   $0x3
  801bc0:	e8 20 fc ff ff       	call   8017e5 <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 04                	push   $0x4
  801bd9:	e8 07 fc ff ff       	call   8017e5 <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <sys_exit_env>:


void sys_exit_env(void)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 23                	push   $0x23
  801bf2:	e8 ee fb ff ff       	call   8017e5 <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
}
  801bfa:	90                   	nop
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
  801c00:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c03:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c06:	8d 50 04             	lea    0x4(%eax),%edx
  801c09:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	52                   	push   %edx
  801c13:	50                   	push   %eax
  801c14:	6a 24                	push   $0x24
  801c16:	e8 ca fb ff ff       	call   8017e5 <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
	return result;
  801c1e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c21:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c24:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c27:	89 01                	mov    %eax,(%ecx)
  801c29:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	c9                   	leave  
  801c30:	c2 04 00             	ret    $0x4

00801c33 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	ff 75 10             	pushl  0x10(%ebp)
  801c3d:	ff 75 0c             	pushl  0xc(%ebp)
  801c40:	ff 75 08             	pushl  0x8(%ebp)
  801c43:	6a 12                	push   $0x12
  801c45:	e8 9b fb ff ff       	call   8017e5 <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4d:	90                   	nop
}
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 25                	push   $0x25
  801c5f:	e8 81 fb ff ff       	call   8017e5 <syscall>
  801c64:	83 c4 18             	add    $0x18,%esp
}
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
  801c6c:	83 ec 04             	sub    $0x4,%esp
  801c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c72:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c75:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	50                   	push   %eax
  801c82:	6a 26                	push   $0x26
  801c84:	e8 5c fb ff ff       	call   8017e5 <syscall>
  801c89:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8c:	90                   	nop
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <rsttst>:
void rsttst()
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 28                	push   $0x28
  801c9e:	e8 42 fb ff ff       	call   8017e5 <syscall>
  801ca3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca6:	90                   	nop
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
  801cac:	83 ec 04             	sub    $0x4,%esp
  801caf:	8b 45 14             	mov    0x14(%ebp),%eax
  801cb2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cb5:	8b 55 18             	mov    0x18(%ebp),%edx
  801cb8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cbc:	52                   	push   %edx
  801cbd:	50                   	push   %eax
  801cbe:	ff 75 10             	pushl  0x10(%ebp)
  801cc1:	ff 75 0c             	pushl  0xc(%ebp)
  801cc4:	ff 75 08             	pushl  0x8(%ebp)
  801cc7:	6a 27                	push   $0x27
  801cc9:	e8 17 fb ff ff       	call   8017e5 <syscall>
  801cce:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd1:	90                   	nop
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <chktst>:
void chktst(uint32 n)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	ff 75 08             	pushl  0x8(%ebp)
  801ce2:	6a 29                	push   $0x29
  801ce4:	e8 fc fa ff ff       	call   8017e5 <syscall>
  801ce9:	83 c4 18             	add    $0x18,%esp
	return ;
  801cec:	90                   	nop
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <inctst>:

void inctst()
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 2a                	push   $0x2a
  801cfe:	e8 e2 fa ff ff       	call   8017e5 <syscall>
  801d03:	83 c4 18             	add    $0x18,%esp
	return ;
  801d06:	90                   	nop
}
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <gettst>:
uint32 gettst()
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 2b                	push   $0x2b
  801d18:	e8 c8 fa ff ff       	call   8017e5 <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
}
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
  801d25:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 2c                	push   $0x2c
  801d34:	e8 ac fa ff ff       	call   8017e5 <syscall>
  801d39:	83 c4 18             	add    $0x18,%esp
  801d3c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d3f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d43:	75 07                	jne    801d4c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d45:	b8 01 00 00 00       	mov    $0x1,%eax
  801d4a:	eb 05                	jmp    801d51 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
  801d56:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 2c                	push   $0x2c
  801d65:	e8 7b fa ff ff       	call   8017e5 <syscall>
  801d6a:	83 c4 18             	add    $0x18,%esp
  801d6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d70:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d74:	75 07                	jne    801d7d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d76:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7b:	eb 05                	jmp    801d82 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    

00801d84 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
  801d87:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 2c                	push   $0x2c
  801d96:	e8 4a fa ff ff       	call   8017e5 <syscall>
  801d9b:	83 c4 18             	add    $0x18,%esp
  801d9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801da1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801da5:	75 07                	jne    801dae <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801da7:	b8 01 00 00 00       	mov    $0x1,%eax
  801dac:	eb 05                	jmp    801db3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 2c                	push   $0x2c
  801dc7:	e8 19 fa ff ff       	call   8017e5 <syscall>
  801dcc:	83 c4 18             	add    $0x18,%esp
  801dcf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dd2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dd6:	75 07                	jne    801ddf <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dd8:	b8 01 00 00 00       	mov    $0x1,%eax
  801ddd:	eb 05                	jmp    801de4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ddf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	ff 75 08             	pushl  0x8(%ebp)
  801df4:	6a 2d                	push   $0x2d
  801df6:	e8 ea f9 ff ff       	call   8017e5 <syscall>
  801dfb:	83 c4 18             	add    $0x18,%esp
	return ;
  801dfe:	90                   	nop
}
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
  801e04:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e05:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e08:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e11:	6a 00                	push   $0x0
  801e13:	53                   	push   %ebx
  801e14:	51                   	push   %ecx
  801e15:	52                   	push   %edx
  801e16:	50                   	push   %eax
  801e17:	6a 2e                	push   $0x2e
  801e19:	e8 c7 f9 ff ff       	call   8017e5 <syscall>
  801e1e:	83 c4 18             	add    $0x18,%esp
}
  801e21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	52                   	push   %edx
  801e36:	50                   	push   %eax
  801e37:	6a 2f                	push   $0x2f
  801e39:	e8 a7 f9 ff ff       	call   8017e5 <syscall>
  801e3e:	83 c4 18             	add    $0x18,%esp
}
  801e41:	c9                   	leave  
  801e42:	c3                   	ret    

00801e43 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
  801e46:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e49:	83 ec 0c             	sub    $0xc,%esp
  801e4c:	68 e0 38 80 00       	push   $0x8038e0
  801e51:	e8 dd e6 ff ff       	call   800533 <cprintf>
  801e56:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e59:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e60:	83 ec 0c             	sub    $0xc,%esp
  801e63:	68 0c 39 80 00       	push   $0x80390c
  801e68:	e8 c6 e6 ff ff       	call   800533 <cprintf>
  801e6d:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e70:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e74:	a1 38 41 80 00       	mov    0x804138,%eax
  801e79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e7c:	eb 56                	jmp    801ed4 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e82:	74 1c                	je     801ea0 <print_mem_block_lists+0x5d>
  801e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e87:	8b 50 08             	mov    0x8(%eax),%edx
  801e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e8d:	8b 48 08             	mov    0x8(%eax),%ecx
  801e90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e93:	8b 40 0c             	mov    0xc(%eax),%eax
  801e96:	01 c8                	add    %ecx,%eax
  801e98:	39 c2                	cmp    %eax,%edx
  801e9a:	73 04                	jae    801ea0 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e9c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea3:	8b 50 08             	mov    0x8(%eax),%edx
  801ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea9:	8b 40 0c             	mov    0xc(%eax),%eax
  801eac:	01 c2                	add    %eax,%edx
  801eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb1:	8b 40 08             	mov    0x8(%eax),%eax
  801eb4:	83 ec 04             	sub    $0x4,%esp
  801eb7:	52                   	push   %edx
  801eb8:	50                   	push   %eax
  801eb9:	68 21 39 80 00       	push   $0x803921
  801ebe:	e8 70 e6 ff ff       	call   800533 <cprintf>
  801ec3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ecc:	a1 40 41 80 00       	mov    0x804140,%eax
  801ed1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ed4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ed8:	74 07                	je     801ee1 <print_mem_block_lists+0x9e>
  801eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edd:	8b 00                	mov    (%eax),%eax
  801edf:	eb 05                	jmp    801ee6 <print_mem_block_lists+0xa3>
  801ee1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee6:	a3 40 41 80 00       	mov    %eax,0x804140
  801eeb:	a1 40 41 80 00       	mov    0x804140,%eax
  801ef0:	85 c0                	test   %eax,%eax
  801ef2:	75 8a                	jne    801e7e <print_mem_block_lists+0x3b>
  801ef4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef8:	75 84                	jne    801e7e <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801efa:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801efe:	75 10                	jne    801f10 <print_mem_block_lists+0xcd>
  801f00:	83 ec 0c             	sub    $0xc,%esp
  801f03:	68 30 39 80 00       	push   $0x803930
  801f08:	e8 26 e6 ff ff       	call   800533 <cprintf>
  801f0d:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f10:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f17:	83 ec 0c             	sub    $0xc,%esp
  801f1a:	68 54 39 80 00       	push   $0x803954
  801f1f:	e8 0f e6 ff ff       	call   800533 <cprintf>
  801f24:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f27:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f2b:	a1 40 40 80 00       	mov    0x804040,%eax
  801f30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f33:	eb 56                	jmp    801f8b <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f35:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f39:	74 1c                	je     801f57 <print_mem_block_lists+0x114>
  801f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3e:	8b 50 08             	mov    0x8(%eax),%edx
  801f41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f44:	8b 48 08             	mov    0x8(%eax),%ecx
  801f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f4a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f4d:	01 c8                	add    %ecx,%eax
  801f4f:	39 c2                	cmp    %eax,%edx
  801f51:	73 04                	jae    801f57 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f53:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5a:	8b 50 08             	mov    0x8(%eax),%edx
  801f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f60:	8b 40 0c             	mov    0xc(%eax),%eax
  801f63:	01 c2                	add    %eax,%edx
  801f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f68:	8b 40 08             	mov    0x8(%eax),%eax
  801f6b:	83 ec 04             	sub    $0x4,%esp
  801f6e:	52                   	push   %edx
  801f6f:	50                   	push   %eax
  801f70:	68 21 39 80 00       	push   $0x803921
  801f75:	e8 b9 e5 ff ff       	call   800533 <cprintf>
  801f7a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f80:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f83:	a1 48 40 80 00       	mov    0x804048,%eax
  801f88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f8f:	74 07                	je     801f98 <print_mem_block_lists+0x155>
  801f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f94:	8b 00                	mov    (%eax),%eax
  801f96:	eb 05                	jmp    801f9d <print_mem_block_lists+0x15a>
  801f98:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9d:	a3 48 40 80 00       	mov    %eax,0x804048
  801fa2:	a1 48 40 80 00       	mov    0x804048,%eax
  801fa7:	85 c0                	test   %eax,%eax
  801fa9:	75 8a                	jne    801f35 <print_mem_block_lists+0xf2>
  801fab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801faf:	75 84                	jne    801f35 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fb1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fb5:	75 10                	jne    801fc7 <print_mem_block_lists+0x184>
  801fb7:	83 ec 0c             	sub    $0xc,%esp
  801fba:	68 6c 39 80 00       	push   $0x80396c
  801fbf:	e8 6f e5 ff ff       	call   800533 <cprintf>
  801fc4:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fc7:	83 ec 0c             	sub    $0xc,%esp
  801fca:	68 e0 38 80 00       	push   $0x8038e0
  801fcf:	e8 5f e5 ff ff       	call   800533 <cprintf>
  801fd4:	83 c4 10             	add    $0x10,%esp

}
  801fd7:	90                   	nop
  801fd8:	c9                   	leave  
  801fd9:	c3                   	ret    

00801fda <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
  801fdd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  801fe6:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801fed:	00 00 00 
  801ff0:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801ff7:	00 00 00 
  801ffa:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802001:	00 00 00 
	for(int i = 0; i<n;i++)
  802004:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80200b:	e9 9e 00 00 00       	jmp    8020ae <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802010:	a1 50 40 80 00       	mov    0x804050,%eax
  802015:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802018:	c1 e2 04             	shl    $0x4,%edx
  80201b:	01 d0                	add    %edx,%eax
  80201d:	85 c0                	test   %eax,%eax
  80201f:	75 14                	jne    802035 <initialize_MemBlocksList+0x5b>
  802021:	83 ec 04             	sub    $0x4,%esp
  802024:	68 94 39 80 00       	push   $0x803994
  802029:	6a 47                	push   $0x47
  80202b:	68 b7 39 80 00       	push   $0x8039b7
  802030:	e8 4a e2 ff ff       	call   80027f <_panic>
  802035:	a1 50 40 80 00       	mov    0x804050,%eax
  80203a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80203d:	c1 e2 04             	shl    $0x4,%edx
  802040:	01 d0                	add    %edx,%eax
  802042:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802048:	89 10                	mov    %edx,(%eax)
  80204a:	8b 00                	mov    (%eax),%eax
  80204c:	85 c0                	test   %eax,%eax
  80204e:	74 18                	je     802068 <initialize_MemBlocksList+0x8e>
  802050:	a1 48 41 80 00       	mov    0x804148,%eax
  802055:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80205b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80205e:	c1 e1 04             	shl    $0x4,%ecx
  802061:	01 ca                	add    %ecx,%edx
  802063:	89 50 04             	mov    %edx,0x4(%eax)
  802066:	eb 12                	jmp    80207a <initialize_MemBlocksList+0xa0>
  802068:	a1 50 40 80 00       	mov    0x804050,%eax
  80206d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802070:	c1 e2 04             	shl    $0x4,%edx
  802073:	01 d0                	add    %edx,%eax
  802075:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80207a:	a1 50 40 80 00       	mov    0x804050,%eax
  80207f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802082:	c1 e2 04             	shl    $0x4,%edx
  802085:	01 d0                	add    %edx,%eax
  802087:	a3 48 41 80 00       	mov    %eax,0x804148
  80208c:	a1 50 40 80 00       	mov    0x804050,%eax
  802091:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802094:	c1 e2 04             	shl    $0x4,%edx
  802097:	01 d0                	add    %edx,%eax
  802099:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020a0:	a1 54 41 80 00       	mov    0x804154,%eax
  8020a5:	40                   	inc    %eax
  8020a6:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8020ab:	ff 45 f4             	incl   -0xc(%ebp)
  8020ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8020b4:	0f 82 56 ff ff ff    	jb     802010 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8020ba:	90                   	nop
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    

008020bd <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020bd:	55                   	push   %ebp
  8020be:	89 e5                	mov    %esp,%ebp
  8020c0:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  8020c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  8020c9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8020d0:	a1 40 40 80 00       	mov    0x804040,%eax
  8020d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020d8:	eb 23                	jmp    8020fd <find_block+0x40>
	{
		if(blk->sva == virAddress)
  8020da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020dd:	8b 40 08             	mov    0x8(%eax),%eax
  8020e0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8020e3:	75 09                	jne    8020ee <find_block+0x31>
		{
			found = 1;
  8020e5:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  8020ec:	eb 35                	jmp    802123 <find_block+0x66>
		}
		else
		{
			found = 0;
  8020ee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8020f5:	a1 48 40 80 00       	mov    0x804048,%eax
  8020fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802101:	74 07                	je     80210a <find_block+0x4d>
  802103:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802106:	8b 00                	mov    (%eax),%eax
  802108:	eb 05                	jmp    80210f <find_block+0x52>
  80210a:	b8 00 00 00 00       	mov    $0x0,%eax
  80210f:	a3 48 40 80 00       	mov    %eax,0x804048
  802114:	a1 48 40 80 00       	mov    0x804048,%eax
  802119:	85 c0                	test   %eax,%eax
  80211b:	75 bd                	jne    8020da <find_block+0x1d>
  80211d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802121:	75 b7                	jne    8020da <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802123:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802127:	75 05                	jne    80212e <find_block+0x71>
	{
		return blk;
  802129:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80212c:	eb 05                	jmp    802133 <find_block+0x76>
	}
	else
	{
		return NULL;
  80212e:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802133:	c9                   	leave  
  802134:	c3                   	ret    

00802135 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
  802138:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  80213b:	8b 45 08             	mov    0x8(%ebp),%eax
  80213e:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802141:	a1 40 40 80 00       	mov    0x804040,%eax
  802146:	85 c0                	test   %eax,%eax
  802148:	74 12                	je     80215c <insert_sorted_allocList+0x27>
  80214a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214d:	8b 50 08             	mov    0x8(%eax),%edx
  802150:	a1 40 40 80 00       	mov    0x804040,%eax
  802155:	8b 40 08             	mov    0x8(%eax),%eax
  802158:	39 c2                	cmp    %eax,%edx
  80215a:	73 65                	jae    8021c1 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  80215c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802160:	75 14                	jne    802176 <insert_sorted_allocList+0x41>
  802162:	83 ec 04             	sub    $0x4,%esp
  802165:	68 94 39 80 00       	push   $0x803994
  80216a:	6a 7b                	push   $0x7b
  80216c:	68 b7 39 80 00       	push   $0x8039b7
  802171:	e8 09 e1 ff ff       	call   80027f <_panic>
  802176:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80217c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217f:	89 10                	mov    %edx,(%eax)
  802181:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802184:	8b 00                	mov    (%eax),%eax
  802186:	85 c0                	test   %eax,%eax
  802188:	74 0d                	je     802197 <insert_sorted_allocList+0x62>
  80218a:	a1 40 40 80 00       	mov    0x804040,%eax
  80218f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802192:	89 50 04             	mov    %edx,0x4(%eax)
  802195:	eb 08                	jmp    80219f <insert_sorted_allocList+0x6a>
  802197:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219a:	a3 44 40 80 00       	mov    %eax,0x804044
  80219f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a2:	a3 40 40 80 00       	mov    %eax,0x804040
  8021a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021b1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021b6:	40                   	inc    %eax
  8021b7:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8021bc:	e9 5f 01 00 00       	jmp    802320 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8021c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c4:	8b 50 08             	mov    0x8(%eax),%edx
  8021c7:	a1 44 40 80 00       	mov    0x804044,%eax
  8021cc:	8b 40 08             	mov    0x8(%eax),%eax
  8021cf:	39 c2                	cmp    %eax,%edx
  8021d1:	76 65                	jbe    802238 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  8021d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021d7:	75 14                	jne    8021ed <insert_sorted_allocList+0xb8>
  8021d9:	83 ec 04             	sub    $0x4,%esp
  8021dc:	68 d0 39 80 00       	push   $0x8039d0
  8021e1:	6a 7f                	push   $0x7f
  8021e3:	68 b7 39 80 00       	push   $0x8039b7
  8021e8:	e8 92 e0 ff ff       	call   80027f <_panic>
  8021ed:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f6:	89 50 04             	mov    %edx,0x4(%eax)
  8021f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fc:	8b 40 04             	mov    0x4(%eax),%eax
  8021ff:	85 c0                	test   %eax,%eax
  802201:	74 0c                	je     80220f <insert_sorted_allocList+0xda>
  802203:	a1 44 40 80 00       	mov    0x804044,%eax
  802208:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80220b:	89 10                	mov    %edx,(%eax)
  80220d:	eb 08                	jmp    802217 <insert_sorted_allocList+0xe2>
  80220f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802212:	a3 40 40 80 00       	mov    %eax,0x804040
  802217:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221a:	a3 44 40 80 00       	mov    %eax,0x804044
  80221f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802222:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802228:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80222d:	40                   	inc    %eax
  80222e:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802233:	e9 e8 00 00 00       	jmp    802320 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802238:	a1 40 40 80 00       	mov    0x804040,%eax
  80223d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802240:	e9 ab 00 00 00       	jmp    8022f0 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802245:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802248:	8b 00                	mov    (%eax),%eax
  80224a:	85 c0                	test   %eax,%eax
  80224c:	0f 84 96 00 00 00    	je     8022e8 <insert_sorted_allocList+0x1b3>
  802252:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802255:	8b 50 08             	mov    0x8(%eax),%edx
  802258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225b:	8b 40 08             	mov    0x8(%eax),%eax
  80225e:	39 c2                	cmp    %eax,%edx
  802260:	0f 86 82 00 00 00    	jbe    8022e8 <insert_sorted_allocList+0x1b3>
  802266:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802269:	8b 50 08             	mov    0x8(%eax),%edx
  80226c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226f:	8b 00                	mov    (%eax),%eax
  802271:	8b 40 08             	mov    0x8(%eax),%eax
  802274:	39 c2                	cmp    %eax,%edx
  802276:	73 70                	jae    8022e8 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802278:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80227c:	74 06                	je     802284 <insert_sorted_allocList+0x14f>
  80227e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802282:	75 17                	jne    80229b <insert_sorted_allocList+0x166>
  802284:	83 ec 04             	sub    $0x4,%esp
  802287:	68 f4 39 80 00       	push   $0x8039f4
  80228c:	68 87 00 00 00       	push   $0x87
  802291:	68 b7 39 80 00       	push   $0x8039b7
  802296:	e8 e4 df ff ff       	call   80027f <_panic>
  80229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229e:	8b 10                	mov    (%eax),%edx
  8022a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a3:	89 10                	mov    %edx,(%eax)
  8022a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a8:	8b 00                	mov    (%eax),%eax
  8022aa:	85 c0                	test   %eax,%eax
  8022ac:	74 0b                	je     8022b9 <insert_sorted_allocList+0x184>
  8022ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b1:	8b 00                	mov    (%eax),%eax
  8022b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022b6:	89 50 04             	mov    %edx,0x4(%eax)
  8022b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022bf:	89 10                	mov    %edx,(%eax)
  8022c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c7:	89 50 04             	mov    %edx,0x4(%eax)
  8022ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022cd:	8b 00                	mov    (%eax),%eax
  8022cf:	85 c0                	test   %eax,%eax
  8022d1:	75 08                	jne    8022db <insert_sorted_allocList+0x1a6>
  8022d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d6:	a3 44 40 80 00       	mov    %eax,0x804044
  8022db:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022e0:	40                   	inc    %eax
  8022e1:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8022e6:	eb 38                	jmp    802320 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8022e8:	a1 48 40 80 00       	mov    0x804048,%eax
  8022ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f4:	74 07                	je     8022fd <insert_sorted_allocList+0x1c8>
  8022f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f9:	8b 00                	mov    (%eax),%eax
  8022fb:	eb 05                	jmp    802302 <insert_sorted_allocList+0x1cd>
  8022fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802302:	a3 48 40 80 00       	mov    %eax,0x804048
  802307:	a1 48 40 80 00       	mov    0x804048,%eax
  80230c:	85 c0                	test   %eax,%eax
  80230e:	0f 85 31 ff ff ff    	jne    802245 <insert_sorted_allocList+0x110>
  802314:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802318:	0f 85 27 ff ff ff    	jne    802245 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80231e:	eb 00                	jmp    802320 <insert_sorted_allocList+0x1eb>
  802320:	90                   	nop
  802321:	c9                   	leave  
  802322:	c3                   	ret    

00802323 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
  802326:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802329:	8b 45 08             	mov    0x8(%ebp),%eax
  80232c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  80232f:	a1 48 41 80 00       	mov    0x804148,%eax
  802334:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802337:	a1 38 41 80 00       	mov    0x804138,%eax
  80233c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80233f:	e9 77 01 00 00       	jmp    8024bb <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802347:	8b 40 0c             	mov    0xc(%eax),%eax
  80234a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80234d:	0f 85 8a 00 00 00    	jne    8023dd <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802353:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802357:	75 17                	jne    802370 <alloc_block_FF+0x4d>
  802359:	83 ec 04             	sub    $0x4,%esp
  80235c:	68 28 3a 80 00       	push   $0x803a28
  802361:	68 9e 00 00 00       	push   $0x9e
  802366:	68 b7 39 80 00       	push   $0x8039b7
  80236b:	e8 0f df ff ff       	call   80027f <_panic>
  802370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802373:	8b 00                	mov    (%eax),%eax
  802375:	85 c0                	test   %eax,%eax
  802377:	74 10                	je     802389 <alloc_block_FF+0x66>
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	8b 00                	mov    (%eax),%eax
  80237e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802381:	8b 52 04             	mov    0x4(%edx),%edx
  802384:	89 50 04             	mov    %edx,0x4(%eax)
  802387:	eb 0b                	jmp    802394 <alloc_block_FF+0x71>
  802389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238c:	8b 40 04             	mov    0x4(%eax),%eax
  80238f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802397:	8b 40 04             	mov    0x4(%eax),%eax
  80239a:	85 c0                	test   %eax,%eax
  80239c:	74 0f                	je     8023ad <alloc_block_FF+0x8a>
  80239e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a1:	8b 40 04             	mov    0x4(%eax),%eax
  8023a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a7:	8b 12                	mov    (%edx),%edx
  8023a9:	89 10                	mov    %edx,(%eax)
  8023ab:	eb 0a                	jmp    8023b7 <alloc_block_FF+0x94>
  8023ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b0:	8b 00                	mov    (%eax),%eax
  8023b2:	a3 38 41 80 00       	mov    %eax,0x804138
  8023b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ca:	a1 44 41 80 00       	mov    0x804144,%eax
  8023cf:	48                   	dec    %eax
  8023d0:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	e9 11 01 00 00       	jmp    8024ee <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  8023dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8023e6:	0f 86 c7 00 00 00    	jbe    8024b3 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8023ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023f0:	75 17                	jne    802409 <alloc_block_FF+0xe6>
  8023f2:	83 ec 04             	sub    $0x4,%esp
  8023f5:	68 28 3a 80 00       	push   $0x803a28
  8023fa:	68 a3 00 00 00       	push   $0xa3
  8023ff:	68 b7 39 80 00       	push   $0x8039b7
  802404:	e8 76 de ff ff       	call   80027f <_panic>
  802409:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80240c:	8b 00                	mov    (%eax),%eax
  80240e:	85 c0                	test   %eax,%eax
  802410:	74 10                	je     802422 <alloc_block_FF+0xff>
  802412:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802415:	8b 00                	mov    (%eax),%eax
  802417:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80241a:	8b 52 04             	mov    0x4(%edx),%edx
  80241d:	89 50 04             	mov    %edx,0x4(%eax)
  802420:	eb 0b                	jmp    80242d <alloc_block_FF+0x10a>
  802422:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802425:	8b 40 04             	mov    0x4(%eax),%eax
  802428:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80242d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802430:	8b 40 04             	mov    0x4(%eax),%eax
  802433:	85 c0                	test   %eax,%eax
  802435:	74 0f                	je     802446 <alloc_block_FF+0x123>
  802437:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80243a:	8b 40 04             	mov    0x4(%eax),%eax
  80243d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802440:	8b 12                	mov    (%edx),%edx
  802442:	89 10                	mov    %edx,(%eax)
  802444:	eb 0a                	jmp    802450 <alloc_block_FF+0x12d>
  802446:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802449:	8b 00                	mov    (%eax),%eax
  80244b:	a3 48 41 80 00       	mov    %eax,0x804148
  802450:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802453:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80245c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802463:	a1 54 41 80 00       	mov    0x804154,%eax
  802468:	48                   	dec    %eax
  802469:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  80246e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802471:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802474:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247a:	8b 40 0c             	mov    0xc(%eax),%eax
  80247d:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802480:	89 c2                	mov    %eax,%edx
  802482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802485:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	8b 40 08             	mov    0x8(%eax),%eax
  80248e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802494:	8b 50 08             	mov    0x8(%eax),%edx
  802497:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80249a:	8b 40 0c             	mov    0xc(%eax),%eax
  80249d:	01 c2                	add    %eax,%edx
  80249f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a2:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8024a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024ab:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8024ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b1:	eb 3b                	jmp    8024ee <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8024b3:	a1 40 41 80 00       	mov    0x804140,%eax
  8024b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024bf:	74 07                	je     8024c8 <alloc_block_FF+0x1a5>
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	8b 00                	mov    (%eax),%eax
  8024c6:	eb 05                	jmp    8024cd <alloc_block_FF+0x1aa>
  8024c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cd:	a3 40 41 80 00       	mov    %eax,0x804140
  8024d2:	a1 40 41 80 00       	mov    0x804140,%eax
  8024d7:	85 c0                	test   %eax,%eax
  8024d9:	0f 85 65 fe ff ff    	jne    802344 <alloc_block_FF+0x21>
  8024df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e3:	0f 85 5b fe ff ff    	jne    802344 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8024e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ee:	c9                   	leave  
  8024ef:	c3                   	ret    

008024f0 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024f0:	55                   	push   %ebp
  8024f1:	89 e5                	mov    %esp,%ebp
  8024f3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  8024f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  8024fc:	a1 48 41 80 00       	mov    0x804148,%eax
  802501:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802504:	a1 44 41 80 00       	mov    0x804144,%eax
  802509:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  80250c:	a1 38 41 80 00       	mov    0x804138,%eax
  802511:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802514:	e9 a1 00 00 00       	jmp    8025ba <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	8b 40 0c             	mov    0xc(%eax),%eax
  80251f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802522:	0f 85 8a 00 00 00    	jne    8025b2 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802528:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80252c:	75 17                	jne    802545 <alloc_block_BF+0x55>
  80252e:	83 ec 04             	sub    $0x4,%esp
  802531:	68 28 3a 80 00       	push   $0x803a28
  802536:	68 c2 00 00 00       	push   $0xc2
  80253b:	68 b7 39 80 00       	push   $0x8039b7
  802540:	e8 3a dd ff ff       	call   80027f <_panic>
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	8b 00                	mov    (%eax),%eax
  80254a:	85 c0                	test   %eax,%eax
  80254c:	74 10                	je     80255e <alloc_block_BF+0x6e>
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	8b 00                	mov    (%eax),%eax
  802553:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802556:	8b 52 04             	mov    0x4(%edx),%edx
  802559:	89 50 04             	mov    %edx,0x4(%eax)
  80255c:	eb 0b                	jmp    802569 <alloc_block_BF+0x79>
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	8b 40 04             	mov    0x4(%eax),%eax
  802564:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	8b 40 04             	mov    0x4(%eax),%eax
  80256f:	85 c0                	test   %eax,%eax
  802571:	74 0f                	je     802582 <alloc_block_BF+0x92>
  802573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802576:	8b 40 04             	mov    0x4(%eax),%eax
  802579:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257c:	8b 12                	mov    (%edx),%edx
  80257e:	89 10                	mov    %edx,(%eax)
  802580:	eb 0a                	jmp    80258c <alloc_block_BF+0x9c>
  802582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802585:	8b 00                	mov    (%eax),%eax
  802587:	a3 38 41 80 00       	mov    %eax,0x804138
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80259f:	a1 44 41 80 00       	mov    0x804144,%eax
  8025a4:	48                   	dec    %eax
  8025a5:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	e9 11 02 00 00       	jmp    8027c3 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025b2:	a1 40 41 80 00       	mov    0x804140,%eax
  8025b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025be:	74 07                	je     8025c7 <alloc_block_BF+0xd7>
  8025c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c3:	8b 00                	mov    (%eax),%eax
  8025c5:	eb 05                	jmp    8025cc <alloc_block_BF+0xdc>
  8025c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cc:	a3 40 41 80 00       	mov    %eax,0x804140
  8025d1:	a1 40 41 80 00       	mov    0x804140,%eax
  8025d6:	85 c0                	test   %eax,%eax
  8025d8:	0f 85 3b ff ff ff    	jne    802519 <alloc_block_BF+0x29>
  8025de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e2:	0f 85 31 ff ff ff    	jne    802519 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025e8:	a1 38 41 80 00       	mov    0x804138,%eax
  8025ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f0:	eb 27                	jmp    802619 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  8025f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8025fb:	76 14                	jbe    802611 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  8025fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802600:	8b 40 0c             	mov    0xc(%eax),%eax
  802603:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802609:	8b 40 08             	mov    0x8(%eax),%eax
  80260c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  80260f:	eb 2e                	jmp    80263f <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802611:	a1 40 41 80 00       	mov    0x804140,%eax
  802616:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802619:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261d:	74 07                	je     802626 <alloc_block_BF+0x136>
  80261f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802622:	8b 00                	mov    (%eax),%eax
  802624:	eb 05                	jmp    80262b <alloc_block_BF+0x13b>
  802626:	b8 00 00 00 00       	mov    $0x0,%eax
  80262b:	a3 40 41 80 00       	mov    %eax,0x804140
  802630:	a1 40 41 80 00       	mov    0x804140,%eax
  802635:	85 c0                	test   %eax,%eax
  802637:	75 b9                	jne    8025f2 <alloc_block_BF+0x102>
  802639:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263d:	75 b3                	jne    8025f2 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80263f:	a1 38 41 80 00       	mov    0x804138,%eax
  802644:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802647:	eb 30                	jmp    802679 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	8b 40 0c             	mov    0xc(%eax),%eax
  80264f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802652:	73 1d                	jae    802671 <alloc_block_BF+0x181>
  802654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802657:	8b 40 0c             	mov    0xc(%eax),%eax
  80265a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80265d:	76 12                	jbe    802671 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	8b 40 0c             	mov    0xc(%eax),%eax
  802665:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	8b 40 08             	mov    0x8(%eax),%eax
  80266e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802671:	a1 40 41 80 00       	mov    0x804140,%eax
  802676:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802679:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267d:	74 07                	je     802686 <alloc_block_BF+0x196>
  80267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802682:	8b 00                	mov    (%eax),%eax
  802684:	eb 05                	jmp    80268b <alloc_block_BF+0x19b>
  802686:	b8 00 00 00 00       	mov    $0x0,%eax
  80268b:	a3 40 41 80 00       	mov    %eax,0x804140
  802690:	a1 40 41 80 00       	mov    0x804140,%eax
  802695:	85 c0                	test   %eax,%eax
  802697:	75 b0                	jne    802649 <alloc_block_BF+0x159>
  802699:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269d:	75 aa                	jne    802649 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80269f:	a1 38 41 80 00       	mov    0x804138,%eax
  8026a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a7:	e9 e4 00 00 00       	jmp    802790 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  8026ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026af:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8026b5:	0f 85 cd 00 00 00    	jne    802788 <alloc_block_BF+0x298>
  8026bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026be:	8b 40 08             	mov    0x8(%eax),%eax
  8026c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026c4:	0f 85 be 00 00 00    	jne    802788 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  8026ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026ce:	75 17                	jne    8026e7 <alloc_block_BF+0x1f7>
  8026d0:	83 ec 04             	sub    $0x4,%esp
  8026d3:	68 28 3a 80 00       	push   $0x803a28
  8026d8:	68 db 00 00 00       	push   $0xdb
  8026dd:	68 b7 39 80 00       	push   $0x8039b7
  8026e2:	e8 98 db ff ff       	call   80027f <_panic>
  8026e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ea:	8b 00                	mov    (%eax),%eax
  8026ec:	85 c0                	test   %eax,%eax
  8026ee:	74 10                	je     802700 <alloc_block_BF+0x210>
  8026f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f3:	8b 00                	mov    (%eax),%eax
  8026f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026f8:	8b 52 04             	mov    0x4(%edx),%edx
  8026fb:	89 50 04             	mov    %edx,0x4(%eax)
  8026fe:	eb 0b                	jmp    80270b <alloc_block_BF+0x21b>
  802700:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802703:	8b 40 04             	mov    0x4(%eax),%eax
  802706:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80270b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80270e:	8b 40 04             	mov    0x4(%eax),%eax
  802711:	85 c0                	test   %eax,%eax
  802713:	74 0f                	je     802724 <alloc_block_BF+0x234>
  802715:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802718:	8b 40 04             	mov    0x4(%eax),%eax
  80271b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80271e:	8b 12                	mov    (%edx),%edx
  802720:	89 10                	mov    %edx,(%eax)
  802722:	eb 0a                	jmp    80272e <alloc_block_BF+0x23e>
  802724:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802727:	8b 00                	mov    (%eax),%eax
  802729:	a3 48 41 80 00       	mov    %eax,0x804148
  80272e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802731:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802737:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80273a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802741:	a1 54 41 80 00       	mov    0x804154,%eax
  802746:	48                   	dec    %eax
  802747:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  80274c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80274f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802752:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802755:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802758:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80275b:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  80275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802761:	8b 40 0c             	mov    0xc(%eax),%eax
  802764:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802767:	89 c2                	mov    %eax,%edx
  802769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276c:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  80276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802772:	8b 50 08             	mov    0x8(%eax),%edx
  802775:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802778:	8b 40 0c             	mov    0xc(%eax),%eax
  80277b:	01 c2                	add    %eax,%edx
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802783:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802786:	eb 3b                	jmp    8027c3 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802788:	a1 40 41 80 00       	mov    0x804140,%eax
  80278d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802790:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802794:	74 07                	je     80279d <alloc_block_BF+0x2ad>
  802796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802799:	8b 00                	mov    (%eax),%eax
  80279b:	eb 05                	jmp    8027a2 <alloc_block_BF+0x2b2>
  80279d:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a2:	a3 40 41 80 00       	mov    %eax,0x804140
  8027a7:	a1 40 41 80 00       	mov    0x804140,%eax
  8027ac:	85 c0                	test   %eax,%eax
  8027ae:	0f 85 f8 fe ff ff    	jne    8026ac <alloc_block_BF+0x1bc>
  8027b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b8:	0f 85 ee fe ff ff    	jne    8026ac <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  8027be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027c3:	c9                   	leave  
  8027c4:	c3                   	ret    

008027c5 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027c5:	55                   	push   %ebp
  8027c6:	89 e5                	mov    %esp,%ebp
  8027c8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  8027cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8027d1:	a1 48 41 80 00       	mov    0x804148,%eax
  8027d6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8027d9:	a1 38 41 80 00       	mov    0x804138,%eax
  8027de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e1:	e9 77 01 00 00       	jmp    80295d <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  8027e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027ef:	0f 85 8a 00 00 00    	jne    80287f <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8027f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f9:	75 17                	jne    802812 <alloc_block_NF+0x4d>
  8027fb:	83 ec 04             	sub    $0x4,%esp
  8027fe:	68 28 3a 80 00       	push   $0x803a28
  802803:	68 f7 00 00 00       	push   $0xf7
  802808:	68 b7 39 80 00       	push   $0x8039b7
  80280d:	e8 6d da ff ff       	call   80027f <_panic>
  802812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802815:	8b 00                	mov    (%eax),%eax
  802817:	85 c0                	test   %eax,%eax
  802819:	74 10                	je     80282b <alloc_block_NF+0x66>
  80281b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281e:	8b 00                	mov    (%eax),%eax
  802820:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802823:	8b 52 04             	mov    0x4(%edx),%edx
  802826:	89 50 04             	mov    %edx,0x4(%eax)
  802829:	eb 0b                	jmp    802836 <alloc_block_NF+0x71>
  80282b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282e:	8b 40 04             	mov    0x4(%eax),%eax
  802831:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802839:	8b 40 04             	mov    0x4(%eax),%eax
  80283c:	85 c0                	test   %eax,%eax
  80283e:	74 0f                	je     80284f <alloc_block_NF+0x8a>
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	8b 40 04             	mov    0x4(%eax),%eax
  802846:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802849:	8b 12                	mov    (%edx),%edx
  80284b:	89 10                	mov    %edx,(%eax)
  80284d:	eb 0a                	jmp    802859 <alloc_block_NF+0x94>
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	8b 00                	mov    (%eax),%eax
  802854:	a3 38 41 80 00       	mov    %eax,0x804138
  802859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80286c:	a1 44 41 80 00       	mov    0x804144,%eax
  802871:	48                   	dec    %eax
  802872:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	e9 11 01 00 00       	jmp    802990 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	8b 40 0c             	mov    0xc(%eax),%eax
  802885:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802888:	0f 86 c7 00 00 00    	jbe    802955 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  80288e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802892:	75 17                	jne    8028ab <alloc_block_NF+0xe6>
  802894:	83 ec 04             	sub    $0x4,%esp
  802897:	68 28 3a 80 00       	push   $0x803a28
  80289c:	68 fc 00 00 00       	push   $0xfc
  8028a1:	68 b7 39 80 00       	push   $0x8039b7
  8028a6:	e8 d4 d9 ff ff       	call   80027f <_panic>
  8028ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ae:	8b 00                	mov    (%eax),%eax
  8028b0:	85 c0                	test   %eax,%eax
  8028b2:	74 10                	je     8028c4 <alloc_block_NF+0xff>
  8028b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b7:	8b 00                	mov    (%eax),%eax
  8028b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028bc:	8b 52 04             	mov    0x4(%edx),%edx
  8028bf:	89 50 04             	mov    %edx,0x4(%eax)
  8028c2:	eb 0b                	jmp    8028cf <alloc_block_NF+0x10a>
  8028c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ca:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d2:	8b 40 04             	mov    0x4(%eax),%eax
  8028d5:	85 c0                	test   %eax,%eax
  8028d7:	74 0f                	je     8028e8 <alloc_block_NF+0x123>
  8028d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028dc:	8b 40 04             	mov    0x4(%eax),%eax
  8028df:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028e2:	8b 12                	mov    (%edx),%edx
  8028e4:	89 10                	mov    %edx,(%eax)
  8028e6:	eb 0a                	jmp    8028f2 <alloc_block_NF+0x12d>
  8028e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028eb:	8b 00                	mov    (%eax),%eax
  8028ed:	a3 48 41 80 00       	mov    %eax,0x804148
  8028f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802905:	a1 54 41 80 00       	mov    0x804154,%eax
  80290a:	48                   	dec    %eax
  80290b:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802910:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802913:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802916:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291c:	8b 40 0c             	mov    0xc(%eax),%eax
  80291f:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802922:	89 c2                	mov    %eax,%edx
  802924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802927:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	8b 40 08             	mov    0x8(%eax),%eax
  802930:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	8b 50 08             	mov    0x8(%eax),%edx
  802939:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293c:	8b 40 0c             	mov    0xc(%eax),%eax
  80293f:	01 c2                	add    %eax,%edx
  802941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802944:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802947:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80294d:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802950:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802953:	eb 3b                	jmp    802990 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802955:	a1 40 41 80 00       	mov    0x804140,%eax
  80295a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80295d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802961:	74 07                	je     80296a <alloc_block_NF+0x1a5>
  802963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802966:	8b 00                	mov    (%eax),%eax
  802968:	eb 05                	jmp    80296f <alloc_block_NF+0x1aa>
  80296a:	b8 00 00 00 00       	mov    $0x0,%eax
  80296f:	a3 40 41 80 00       	mov    %eax,0x804140
  802974:	a1 40 41 80 00       	mov    0x804140,%eax
  802979:	85 c0                	test   %eax,%eax
  80297b:	0f 85 65 fe ff ff    	jne    8027e6 <alloc_block_NF+0x21>
  802981:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802985:	0f 85 5b fe ff ff    	jne    8027e6 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  80298b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802990:	c9                   	leave  
  802991:	c3                   	ret    

00802992 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802992:	55                   	push   %ebp
  802993:	89 e5                	mov    %esp,%ebp
  802995:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802998:	8b 45 08             	mov    0x8(%ebp),%eax
  80299b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  8029a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  8029ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029b0:	75 17                	jne    8029c9 <addToAvailMemBlocksList+0x37>
  8029b2:	83 ec 04             	sub    $0x4,%esp
  8029b5:	68 d0 39 80 00       	push   $0x8039d0
  8029ba:	68 10 01 00 00       	push   $0x110
  8029bf:	68 b7 39 80 00       	push   $0x8039b7
  8029c4:	e8 b6 d8 ff ff       	call   80027f <_panic>
  8029c9:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  8029cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d2:	89 50 04             	mov    %edx,0x4(%eax)
  8029d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d8:	8b 40 04             	mov    0x4(%eax),%eax
  8029db:	85 c0                	test   %eax,%eax
  8029dd:	74 0c                	je     8029eb <addToAvailMemBlocksList+0x59>
  8029df:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8029e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8029e7:	89 10                	mov    %edx,(%eax)
  8029e9:	eb 08                	jmp    8029f3 <addToAvailMemBlocksList+0x61>
  8029eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ee:	a3 48 41 80 00       	mov    %eax,0x804148
  8029f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a04:	a1 54 41 80 00       	mov    0x804154,%eax
  802a09:	40                   	inc    %eax
  802a0a:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802a0f:	90                   	nop
  802a10:	c9                   	leave  
  802a11:	c3                   	ret    

00802a12 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a12:	55                   	push   %ebp
  802a13:	89 e5                	mov    %esp,%ebp
  802a15:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802a18:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802a20:	a1 44 41 80 00       	mov    0x804144,%eax
  802a25:	85 c0                	test   %eax,%eax
  802a27:	75 68                	jne    802a91 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802a29:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a2d:	75 17                	jne    802a46 <insert_sorted_with_merge_freeList+0x34>
  802a2f:	83 ec 04             	sub    $0x4,%esp
  802a32:	68 94 39 80 00       	push   $0x803994
  802a37:	68 1a 01 00 00       	push   $0x11a
  802a3c:	68 b7 39 80 00       	push   $0x8039b7
  802a41:	e8 39 d8 ff ff       	call   80027f <_panic>
  802a46:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4f:	89 10                	mov    %edx,(%eax)
  802a51:	8b 45 08             	mov    0x8(%ebp),%eax
  802a54:	8b 00                	mov    (%eax),%eax
  802a56:	85 c0                	test   %eax,%eax
  802a58:	74 0d                	je     802a67 <insert_sorted_with_merge_freeList+0x55>
  802a5a:	a1 38 41 80 00       	mov    0x804138,%eax
  802a5f:	8b 55 08             	mov    0x8(%ebp),%edx
  802a62:	89 50 04             	mov    %edx,0x4(%eax)
  802a65:	eb 08                	jmp    802a6f <insert_sorted_with_merge_freeList+0x5d>
  802a67:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a72:	a3 38 41 80 00       	mov    %eax,0x804138
  802a77:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a81:	a1 44 41 80 00       	mov    0x804144,%eax
  802a86:	40                   	inc    %eax
  802a87:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802a8c:	e9 c5 03 00 00       	jmp    802e56 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a94:	8b 50 08             	mov    0x8(%eax),%edx
  802a97:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9a:	8b 40 08             	mov    0x8(%eax),%eax
  802a9d:	39 c2                	cmp    %eax,%edx
  802a9f:	0f 83 b2 00 00 00    	jae    802b57 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa8:	8b 50 08             	mov    0x8(%eax),%edx
  802aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aae:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab1:	01 c2                	add    %eax,%edx
  802ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab6:	8b 40 08             	mov    0x8(%eax),%eax
  802ab9:	39 c2                	cmp    %eax,%edx
  802abb:	75 27                	jne    802ae4 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac0:	8b 50 0c             	mov    0xc(%eax),%edx
  802ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac9:	01 c2                	add    %eax,%edx
  802acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ace:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802ad1:	83 ec 0c             	sub    $0xc,%esp
  802ad4:	ff 75 08             	pushl  0x8(%ebp)
  802ad7:	e8 b6 fe ff ff       	call   802992 <addToAvailMemBlocksList>
  802adc:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802adf:	e9 72 03 00 00       	jmp    802e56 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802ae4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ae8:	74 06                	je     802af0 <insert_sorted_with_merge_freeList+0xde>
  802aea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aee:	75 17                	jne    802b07 <insert_sorted_with_merge_freeList+0xf5>
  802af0:	83 ec 04             	sub    $0x4,%esp
  802af3:	68 f4 39 80 00       	push   $0x8039f4
  802af8:	68 24 01 00 00       	push   $0x124
  802afd:	68 b7 39 80 00       	push   $0x8039b7
  802b02:	e8 78 d7 ff ff       	call   80027f <_panic>
  802b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0a:	8b 10                	mov    (%eax),%edx
  802b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0f:	89 10                	mov    %edx,(%eax)
  802b11:	8b 45 08             	mov    0x8(%ebp),%eax
  802b14:	8b 00                	mov    (%eax),%eax
  802b16:	85 c0                	test   %eax,%eax
  802b18:	74 0b                	je     802b25 <insert_sorted_with_merge_freeList+0x113>
  802b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1d:	8b 00                	mov    (%eax),%eax
  802b1f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b22:	89 50 04             	mov    %edx,0x4(%eax)
  802b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b28:	8b 55 08             	mov    0x8(%ebp),%edx
  802b2b:	89 10                	mov    %edx,(%eax)
  802b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b30:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b33:	89 50 04             	mov    %edx,0x4(%eax)
  802b36:	8b 45 08             	mov    0x8(%ebp),%eax
  802b39:	8b 00                	mov    (%eax),%eax
  802b3b:	85 c0                	test   %eax,%eax
  802b3d:	75 08                	jne    802b47 <insert_sorted_with_merge_freeList+0x135>
  802b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b42:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b47:	a1 44 41 80 00       	mov    0x804144,%eax
  802b4c:	40                   	inc    %eax
  802b4d:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802b52:	e9 ff 02 00 00       	jmp    802e56 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802b57:	a1 38 41 80 00       	mov    0x804138,%eax
  802b5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b5f:	e9 c2 02 00 00       	jmp    802e26 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b67:	8b 50 08             	mov    0x8(%eax),%edx
  802b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6d:	8b 40 08             	mov    0x8(%eax),%eax
  802b70:	39 c2                	cmp    %eax,%edx
  802b72:	0f 86 a6 02 00 00    	jbe    802e1e <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7b:	8b 40 04             	mov    0x4(%eax),%eax
  802b7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802b81:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b85:	0f 85 ba 00 00 00    	jne    802c45 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8e:	8b 50 0c             	mov    0xc(%eax),%edx
  802b91:	8b 45 08             	mov    0x8(%ebp),%eax
  802b94:	8b 40 08             	mov    0x8(%eax),%eax
  802b97:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9c:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802b9f:	39 c2                	cmp    %eax,%edx
  802ba1:	75 33                	jne    802bd6 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba6:	8b 50 08             	mov    0x8(%eax),%edx
  802ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bac:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	8b 50 0c             	mov    0xc(%eax),%edx
  802bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb8:	8b 40 0c             	mov    0xc(%eax),%eax
  802bbb:	01 c2                	add    %eax,%edx
  802bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc0:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802bc3:	83 ec 0c             	sub    $0xc,%esp
  802bc6:	ff 75 08             	pushl  0x8(%ebp)
  802bc9:	e8 c4 fd ff ff       	call   802992 <addToAvailMemBlocksList>
  802bce:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802bd1:	e9 80 02 00 00       	jmp    802e56 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802bd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bda:	74 06                	je     802be2 <insert_sorted_with_merge_freeList+0x1d0>
  802bdc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802be0:	75 17                	jne    802bf9 <insert_sorted_with_merge_freeList+0x1e7>
  802be2:	83 ec 04             	sub    $0x4,%esp
  802be5:	68 48 3a 80 00       	push   $0x803a48
  802bea:	68 3a 01 00 00       	push   $0x13a
  802bef:	68 b7 39 80 00       	push   $0x8039b7
  802bf4:	e8 86 d6 ff ff       	call   80027f <_panic>
  802bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfc:	8b 50 04             	mov    0x4(%eax),%edx
  802bff:	8b 45 08             	mov    0x8(%ebp),%eax
  802c02:	89 50 04             	mov    %edx,0x4(%eax)
  802c05:	8b 45 08             	mov    0x8(%ebp),%eax
  802c08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c0b:	89 10                	mov    %edx,(%eax)
  802c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c10:	8b 40 04             	mov    0x4(%eax),%eax
  802c13:	85 c0                	test   %eax,%eax
  802c15:	74 0d                	je     802c24 <insert_sorted_with_merge_freeList+0x212>
  802c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1a:	8b 40 04             	mov    0x4(%eax),%eax
  802c1d:	8b 55 08             	mov    0x8(%ebp),%edx
  802c20:	89 10                	mov    %edx,(%eax)
  802c22:	eb 08                	jmp    802c2c <insert_sorted_with_merge_freeList+0x21a>
  802c24:	8b 45 08             	mov    0x8(%ebp),%eax
  802c27:	a3 38 41 80 00       	mov    %eax,0x804138
  802c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c32:	89 50 04             	mov    %edx,0x4(%eax)
  802c35:	a1 44 41 80 00       	mov    0x804144,%eax
  802c3a:	40                   	inc    %eax
  802c3b:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802c40:	e9 11 02 00 00       	jmp    802e56 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802c45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c48:	8b 50 08             	mov    0x8(%eax),%edx
  802c4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c51:	01 c2                	add    %eax,%edx
  802c53:	8b 45 08             	mov    0x8(%ebp),%eax
  802c56:	8b 40 0c             	mov    0xc(%eax),%eax
  802c59:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5e:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802c61:	39 c2                	cmp    %eax,%edx
  802c63:	0f 85 bf 00 00 00    	jne    802d28 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802c69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6c:	8b 50 0c             	mov    0xc(%eax),%edx
  802c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c72:	8b 40 0c             	mov    0xc(%eax),%eax
  802c75:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7d:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802c7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c82:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802c85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c89:	75 17                	jne    802ca2 <insert_sorted_with_merge_freeList+0x290>
  802c8b:	83 ec 04             	sub    $0x4,%esp
  802c8e:	68 28 3a 80 00       	push   $0x803a28
  802c93:	68 43 01 00 00       	push   $0x143
  802c98:	68 b7 39 80 00       	push   $0x8039b7
  802c9d:	e8 dd d5 ff ff       	call   80027f <_panic>
  802ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca5:	8b 00                	mov    (%eax),%eax
  802ca7:	85 c0                	test   %eax,%eax
  802ca9:	74 10                	je     802cbb <insert_sorted_with_merge_freeList+0x2a9>
  802cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cae:	8b 00                	mov    (%eax),%eax
  802cb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb3:	8b 52 04             	mov    0x4(%edx),%edx
  802cb6:	89 50 04             	mov    %edx,0x4(%eax)
  802cb9:	eb 0b                	jmp    802cc6 <insert_sorted_with_merge_freeList+0x2b4>
  802cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbe:	8b 40 04             	mov    0x4(%eax),%eax
  802cc1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc9:	8b 40 04             	mov    0x4(%eax),%eax
  802ccc:	85 c0                	test   %eax,%eax
  802cce:	74 0f                	je     802cdf <insert_sorted_with_merge_freeList+0x2cd>
  802cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd3:	8b 40 04             	mov    0x4(%eax),%eax
  802cd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd9:	8b 12                	mov    (%edx),%edx
  802cdb:	89 10                	mov    %edx,(%eax)
  802cdd:	eb 0a                	jmp    802ce9 <insert_sorted_with_merge_freeList+0x2d7>
  802cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce2:	8b 00                	mov    (%eax),%eax
  802ce4:	a3 38 41 80 00       	mov    %eax,0x804138
  802ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cfc:	a1 44 41 80 00       	mov    0x804144,%eax
  802d01:	48                   	dec    %eax
  802d02:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802d07:	83 ec 0c             	sub    $0xc,%esp
  802d0a:	ff 75 08             	pushl  0x8(%ebp)
  802d0d:	e8 80 fc ff ff       	call   802992 <addToAvailMemBlocksList>
  802d12:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802d15:	83 ec 0c             	sub    $0xc,%esp
  802d18:	ff 75 f4             	pushl  -0xc(%ebp)
  802d1b:	e8 72 fc ff ff       	call   802992 <addToAvailMemBlocksList>
  802d20:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802d23:	e9 2e 01 00 00       	jmp    802e56 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802d28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2b:	8b 50 08             	mov    0x8(%eax),%edx
  802d2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d31:	8b 40 0c             	mov    0xc(%eax),%eax
  802d34:	01 c2                	add    %eax,%edx
  802d36:	8b 45 08             	mov    0x8(%ebp),%eax
  802d39:	8b 40 08             	mov    0x8(%eax),%eax
  802d3c:	39 c2                	cmp    %eax,%edx
  802d3e:	75 27                	jne    802d67 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802d40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d43:	8b 50 0c             	mov    0xc(%eax),%edx
  802d46:	8b 45 08             	mov    0x8(%ebp),%eax
  802d49:	8b 40 0c             	mov    0xc(%eax),%eax
  802d4c:	01 c2                	add    %eax,%edx
  802d4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d51:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802d54:	83 ec 0c             	sub    $0xc,%esp
  802d57:	ff 75 08             	pushl  0x8(%ebp)
  802d5a:	e8 33 fc ff ff       	call   802992 <addToAvailMemBlocksList>
  802d5f:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802d62:	e9 ef 00 00 00       	jmp    802e56 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802d67:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6a:	8b 50 0c             	mov    0xc(%eax),%edx
  802d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d70:	8b 40 08             	mov    0x8(%eax),%eax
  802d73:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d78:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802d7b:	39 c2                	cmp    %eax,%edx
  802d7d:	75 33                	jne    802db2 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d82:	8b 50 08             	mov    0x8(%eax),%edx
  802d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d88:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8e:	8b 50 0c             	mov    0xc(%eax),%edx
  802d91:	8b 45 08             	mov    0x8(%ebp),%eax
  802d94:	8b 40 0c             	mov    0xc(%eax),%eax
  802d97:	01 c2                	add    %eax,%edx
  802d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9c:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802d9f:	83 ec 0c             	sub    $0xc,%esp
  802da2:	ff 75 08             	pushl  0x8(%ebp)
  802da5:	e8 e8 fb ff ff       	call   802992 <addToAvailMemBlocksList>
  802daa:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802dad:	e9 a4 00 00 00       	jmp    802e56 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802db2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db6:	74 06                	je     802dbe <insert_sorted_with_merge_freeList+0x3ac>
  802db8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dbc:	75 17                	jne    802dd5 <insert_sorted_with_merge_freeList+0x3c3>
  802dbe:	83 ec 04             	sub    $0x4,%esp
  802dc1:	68 48 3a 80 00       	push   $0x803a48
  802dc6:	68 56 01 00 00       	push   $0x156
  802dcb:	68 b7 39 80 00       	push   $0x8039b7
  802dd0:	e8 aa d4 ff ff       	call   80027f <_panic>
  802dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd8:	8b 50 04             	mov    0x4(%eax),%edx
  802ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dde:	89 50 04             	mov    %edx,0x4(%eax)
  802de1:	8b 45 08             	mov    0x8(%ebp),%eax
  802de4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de7:	89 10                	mov    %edx,(%eax)
  802de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dec:	8b 40 04             	mov    0x4(%eax),%eax
  802def:	85 c0                	test   %eax,%eax
  802df1:	74 0d                	je     802e00 <insert_sorted_with_merge_freeList+0x3ee>
  802df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df6:	8b 40 04             	mov    0x4(%eax),%eax
  802df9:	8b 55 08             	mov    0x8(%ebp),%edx
  802dfc:	89 10                	mov    %edx,(%eax)
  802dfe:	eb 08                	jmp    802e08 <insert_sorted_with_merge_freeList+0x3f6>
  802e00:	8b 45 08             	mov    0x8(%ebp),%eax
  802e03:	a3 38 41 80 00       	mov    %eax,0x804138
  802e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0b:	8b 55 08             	mov    0x8(%ebp),%edx
  802e0e:	89 50 04             	mov    %edx,0x4(%eax)
  802e11:	a1 44 41 80 00       	mov    0x804144,%eax
  802e16:	40                   	inc    %eax
  802e17:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802e1c:	eb 38                	jmp    802e56 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802e1e:	a1 40 41 80 00       	mov    0x804140,%eax
  802e23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e2a:	74 07                	je     802e33 <insert_sorted_with_merge_freeList+0x421>
  802e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2f:	8b 00                	mov    (%eax),%eax
  802e31:	eb 05                	jmp    802e38 <insert_sorted_with_merge_freeList+0x426>
  802e33:	b8 00 00 00 00       	mov    $0x0,%eax
  802e38:	a3 40 41 80 00       	mov    %eax,0x804140
  802e3d:	a1 40 41 80 00       	mov    0x804140,%eax
  802e42:	85 c0                	test   %eax,%eax
  802e44:	0f 85 1a fd ff ff    	jne    802b64 <insert_sorted_with_merge_freeList+0x152>
  802e4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e4e:	0f 85 10 fd ff ff    	jne    802b64 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e54:	eb 00                	jmp    802e56 <insert_sorted_with_merge_freeList+0x444>
  802e56:	90                   	nop
  802e57:	c9                   	leave  
  802e58:	c3                   	ret    
  802e59:	66 90                	xchg   %ax,%ax
  802e5b:	90                   	nop

00802e5c <__udivdi3>:
  802e5c:	55                   	push   %ebp
  802e5d:	57                   	push   %edi
  802e5e:	56                   	push   %esi
  802e5f:	53                   	push   %ebx
  802e60:	83 ec 1c             	sub    $0x1c,%esp
  802e63:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802e67:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802e6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802e6f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802e73:	89 ca                	mov    %ecx,%edx
  802e75:	89 f8                	mov    %edi,%eax
  802e77:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802e7b:	85 f6                	test   %esi,%esi
  802e7d:	75 2d                	jne    802eac <__udivdi3+0x50>
  802e7f:	39 cf                	cmp    %ecx,%edi
  802e81:	77 65                	ja     802ee8 <__udivdi3+0x8c>
  802e83:	89 fd                	mov    %edi,%ebp
  802e85:	85 ff                	test   %edi,%edi
  802e87:	75 0b                	jne    802e94 <__udivdi3+0x38>
  802e89:	b8 01 00 00 00       	mov    $0x1,%eax
  802e8e:	31 d2                	xor    %edx,%edx
  802e90:	f7 f7                	div    %edi
  802e92:	89 c5                	mov    %eax,%ebp
  802e94:	31 d2                	xor    %edx,%edx
  802e96:	89 c8                	mov    %ecx,%eax
  802e98:	f7 f5                	div    %ebp
  802e9a:	89 c1                	mov    %eax,%ecx
  802e9c:	89 d8                	mov    %ebx,%eax
  802e9e:	f7 f5                	div    %ebp
  802ea0:	89 cf                	mov    %ecx,%edi
  802ea2:	89 fa                	mov    %edi,%edx
  802ea4:	83 c4 1c             	add    $0x1c,%esp
  802ea7:	5b                   	pop    %ebx
  802ea8:	5e                   	pop    %esi
  802ea9:	5f                   	pop    %edi
  802eaa:	5d                   	pop    %ebp
  802eab:	c3                   	ret    
  802eac:	39 ce                	cmp    %ecx,%esi
  802eae:	77 28                	ja     802ed8 <__udivdi3+0x7c>
  802eb0:	0f bd fe             	bsr    %esi,%edi
  802eb3:	83 f7 1f             	xor    $0x1f,%edi
  802eb6:	75 40                	jne    802ef8 <__udivdi3+0x9c>
  802eb8:	39 ce                	cmp    %ecx,%esi
  802eba:	72 0a                	jb     802ec6 <__udivdi3+0x6a>
  802ebc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802ec0:	0f 87 9e 00 00 00    	ja     802f64 <__udivdi3+0x108>
  802ec6:	b8 01 00 00 00       	mov    $0x1,%eax
  802ecb:	89 fa                	mov    %edi,%edx
  802ecd:	83 c4 1c             	add    $0x1c,%esp
  802ed0:	5b                   	pop    %ebx
  802ed1:	5e                   	pop    %esi
  802ed2:	5f                   	pop    %edi
  802ed3:	5d                   	pop    %ebp
  802ed4:	c3                   	ret    
  802ed5:	8d 76 00             	lea    0x0(%esi),%esi
  802ed8:	31 ff                	xor    %edi,%edi
  802eda:	31 c0                	xor    %eax,%eax
  802edc:	89 fa                	mov    %edi,%edx
  802ede:	83 c4 1c             	add    $0x1c,%esp
  802ee1:	5b                   	pop    %ebx
  802ee2:	5e                   	pop    %esi
  802ee3:	5f                   	pop    %edi
  802ee4:	5d                   	pop    %ebp
  802ee5:	c3                   	ret    
  802ee6:	66 90                	xchg   %ax,%ax
  802ee8:	89 d8                	mov    %ebx,%eax
  802eea:	f7 f7                	div    %edi
  802eec:	31 ff                	xor    %edi,%edi
  802eee:	89 fa                	mov    %edi,%edx
  802ef0:	83 c4 1c             	add    $0x1c,%esp
  802ef3:	5b                   	pop    %ebx
  802ef4:	5e                   	pop    %esi
  802ef5:	5f                   	pop    %edi
  802ef6:	5d                   	pop    %ebp
  802ef7:	c3                   	ret    
  802ef8:	bd 20 00 00 00       	mov    $0x20,%ebp
  802efd:	89 eb                	mov    %ebp,%ebx
  802eff:	29 fb                	sub    %edi,%ebx
  802f01:	89 f9                	mov    %edi,%ecx
  802f03:	d3 e6                	shl    %cl,%esi
  802f05:	89 c5                	mov    %eax,%ebp
  802f07:	88 d9                	mov    %bl,%cl
  802f09:	d3 ed                	shr    %cl,%ebp
  802f0b:	89 e9                	mov    %ebp,%ecx
  802f0d:	09 f1                	or     %esi,%ecx
  802f0f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802f13:	89 f9                	mov    %edi,%ecx
  802f15:	d3 e0                	shl    %cl,%eax
  802f17:	89 c5                	mov    %eax,%ebp
  802f19:	89 d6                	mov    %edx,%esi
  802f1b:	88 d9                	mov    %bl,%cl
  802f1d:	d3 ee                	shr    %cl,%esi
  802f1f:	89 f9                	mov    %edi,%ecx
  802f21:	d3 e2                	shl    %cl,%edx
  802f23:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f27:	88 d9                	mov    %bl,%cl
  802f29:	d3 e8                	shr    %cl,%eax
  802f2b:	09 c2                	or     %eax,%edx
  802f2d:	89 d0                	mov    %edx,%eax
  802f2f:	89 f2                	mov    %esi,%edx
  802f31:	f7 74 24 0c          	divl   0xc(%esp)
  802f35:	89 d6                	mov    %edx,%esi
  802f37:	89 c3                	mov    %eax,%ebx
  802f39:	f7 e5                	mul    %ebp
  802f3b:	39 d6                	cmp    %edx,%esi
  802f3d:	72 19                	jb     802f58 <__udivdi3+0xfc>
  802f3f:	74 0b                	je     802f4c <__udivdi3+0xf0>
  802f41:	89 d8                	mov    %ebx,%eax
  802f43:	31 ff                	xor    %edi,%edi
  802f45:	e9 58 ff ff ff       	jmp    802ea2 <__udivdi3+0x46>
  802f4a:	66 90                	xchg   %ax,%ax
  802f4c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802f50:	89 f9                	mov    %edi,%ecx
  802f52:	d3 e2                	shl    %cl,%edx
  802f54:	39 c2                	cmp    %eax,%edx
  802f56:	73 e9                	jae    802f41 <__udivdi3+0xe5>
  802f58:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802f5b:	31 ff                	xor    %edi,%edi
  802f5d:	e9 40 ff ff ff       	jmp    802ea2 <__udivdi3+0x46>
  802f62:	66 90                	xchg   %ax,%ax
  802f64:	31 c0                	xor    %eax,%eax
  802f66:	e9 37 ff ff ff       	jmp    802ea2 <__udivdi3+0x46>
  802f6b:	90                   	nop

00802f6c <__umoddi3>:
  802f6c:	55                   	push   %ebp
  802f6d:	57                   	push   %edi
  802f6e:	56                   	push   %esi
  802f6f:	53                   	push   %ebx
  802f70:	83 ec 1c             	sub    $0x1c,%esp
  802f73:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802f77:	8b 74 24 34          	mov    0x34(%esp),%esi
  802f7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802f7f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802f83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802f87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802f8b:	89 f3                	mov    %esi,%ebx
  802f8d:	89 fa                	mov    %edi,%edx
  802f8f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802f93:	89 34 24             	mov    %esi,(%esp)
  802f96:	85 c0                	test   %eax,%eax
  802f98:	75 1a                	jne    802fb4 <__umoddi3+0x48>
  802f9a:	39 f7                	cmp    %esi,%edi
  802f9c:	0f 86 a2 00 00 00    	jbe    803044 <__umoddi3+0xd8>
  802fa2:	89 c8                	mov    %ecx,%eax
  802fa4:	89 f2                	mov    %esi,%edx
  802fa6:	f7 f7                	div    %edi
  802fa8:	89 d0                	mov    %edx,%eax
  802faa:	31 d2                	xor    %edx,%edx
  802fac:	83 c4 1c             	add    $0x1c,%esp
  802faf:	5b                   	pop    %ebx
  802fb0:	5e                   	pop    %esi
  802fb1:	5f                   	pop    %edi
  802fb2:	5d                   	pop    %ebp
  802fb3:	c3                   	ret    
  802fb4:	39 f0                	cmp    %esi,%eax
  802fb6:	0f 87 ac 00 00 00    	ja     803068 <__umoddi3+0xfc>
  802fbc:	0f bd e8             	bsr    %eax,%ebp
  802fbf:	83 f5 1f             	xor    $0x1f,%ebp
  802fc2:	0f 84 ac 00 00 00    	je     803074 <__umoddi3+0x108>
  802fc8:	bf 20 00 00 00       	mov    $0x20,%edi
  802fcd:	29 ef                	sub    %ebp,%edi
  802fcf:	89 fe                	mov    %edi,%esi
  802fd1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802fd5:	89 e9                	mov    %ebp,%ecx
  802fd7:	d3 e0                	shl    %cl,%eax
  802fd9:	89 d7                	mov    %edx,%edi
  802fdb:	89 f1                	mov    %esi,%ecx
  802fdd:	d3 ef                	shr    %cl,%edi
  802fdf:	09 c7                	or     %eax,%edi
  802fe1:	89 e9                	mov    %ebp,%ecx
  802fe3:	d3 e2                	shl    %cl,%edx
  802fe5:	89 14 24             	mov    %edx,(%esp)
  802fe8:	89 d8                	mov    %ebx,%eax
  802fea:	d3 e0                	shl    %cl,%eax
  802fec:	89 c2                	mov    %eax,%edx
  802fee:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ff2:	d3 e0                	shl    %cl,%eax
  802ff4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ff8:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ffc:	89 f1                	mov    %esi,%ecx
  802ffe:	d3 e8                	shr    %cl,%eax
  803000:	09 d0                	or     %edx,%eax
  803002:	d3 eb                	shr    %cl,%ebx
  803004:	89 da                	mov    %ebx,%edx
  803006:	f7 f7                	div    %edi
  803008:	89 d3                	mov    %edx,%ebx
  80300a:	f7 24 24             	mull   (%esp)
  80300d:	89 c6                	mov    %eax,%esi
  80300f:	89 d1                	mov    %edx,%ecx
  803011:	39 d3                	cmp    %edx,%ebx
  803013:	0f 82 87 00 00 00    	jb     8030a0 <__umoddi3+0x134>
  803019:	0f 84 91 00 00 00    	je     8030b0 <__umoddi3+0x144>
  80301f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803023:	29 f2                	sub    %esi,%edx
  803025:	19 cb                	sbb    %ecx,%ebx
  803027:	89 d8                	mov    %ebx,%eax
  803029:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80302d:	d3 e0                	shl    %cl,%eax
  80302f:	89 e9                	mov    %ebp,%ecx
  803031:	d3 ea                	shr    %cl,%edx
  803033:	09 d0                	or     %edx,%eax
  803035:	89 e9                	mov    %ebp,%ecx
  803037:	d3 eb                	shr    %cl,%ebx
  803039:	89 da                	mov    %ebx,%edx
  80303b:	83 c4 1c             	add    $0x1c,%esp
  80303e:	5b                   	pop    %ebx
  80303f:	5e                   	pop    %esi
  803040:	5f                   	pop    %edi
  803041:	5d                   	pop    %ebp
  803042:	c3                   	ret    
  803043:	90                   	nop
  803044:	89 fd                	mov    %edi,%ebp
  803046:	85 ff                	test   %edi,%edi
  803048:	75 0b                	jne    803055 <__umoddi3+0xe9>
  80304a:	b8 01 00 00 00       	mov    $0x1,%eax
  80304f:	31 d2                	xor    %edx,%edx
  803051:	f7 f7                	div    %edi
  803053:	89 c5                	mov    %eax,%ebp
  803055:	89 f0                	mov    %esi,%eax
  803057:	31 d2                	xor    %edx,%edx
  803059:	f7 f5                	div    %ebp
  80305b:	89 c8                	mov    %ecx,%eax
  80305d:	f7 f5                	div    %ebp
  80305f:	89 d0                	mov    %edx,%eax
  803061:	e9 44 ff ff ff       	jmp    802faa <__umoddi3+0x3e>
  803066:	66 90                	xchg   %ax,%ax
  803068:	89 c8                	mov    %ecx,%eax
  80306a:	89 f2                	mov    %esi,%edx
  80306c:	83 c4 1c             	add    $0x1c,%esp
  80306f:	5b                   	pop    %ebx
  803070:	5e                   	pop    %esi
  803071:	5f                   	pop    %edi
  803072:	5d                   	pop    %ebp
  803073:	c3                   	ret    
  803074:	3b 04 24             	cmp    (%esp),%eax
  803077:	72 06                	jb     80307f <__umoddi3+0x113>
  803079:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80307d:	77 0f                	ja     80308e <__umoddi3+0x122>
  80307f:	89 f2                	mov    %esi,%edx
  803081:	29 f9                	sub    %edi,%ecx
  803083:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803087:	89 14 24             	mov    %edx,(%esp)
  80308a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80308e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803092:	8b 14 24             	mov    (%esp),%edx
  803095:	83 c4 1c             	add    $0x1c,%esp
  803098:	5b                   	pop    %ebx
  803099:	5e                   	pop    %esi
  80309a:	5f                   	pop    %edi
  80309b:	5d                   	pop    %ebp
  80309c:	c3                   	ret    
  80309d:	8d 76 00             	lea    0x0(%esi),%esi
  8030a0:	2b 04 24             	sub    (%esp),%eax
  8030a3:	19 fa                	sbb    %edi,%edx
  8030a5:	89 d1                	mov    %edx,%ecx
  8030a7:	89 c6                	mov    %eax,%esi
  8030a9:	e9 71 ff ff ff       	jmp    80301f <__umoddi3+0xb3>
  8030ae:	66 90                	xchg   %ax,%ax
  8030b0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8030b4:	72 ea                	jb     8030a0 <__umoddi3+0x134>
  8030b6:	89 d9                	mov    %ebx,%ecx
  8030b8:	e9 62 ff ff ff       	jmp    80301f <__umoddi3+0xb3>
