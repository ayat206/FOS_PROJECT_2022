
obj/user/tst_envfree5_1:     file format elf32-i386


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
  800031:	e8 10 01 00 00       	call   800146 <libmain>
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
	// Testing removing the shared variables
	// Testing scenario 5_1: Kill ONE program has shared variables and it free it
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 c0 30 80 00       	push   $0x8030c0
  80004a:	e8 c1 15 00 00       	call   801610 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 71 18 00 00       	call   8018d4 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 09 19 00 00       	call   801974 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 d0 30 80 00       	push   $0x8030d0
  800079:	e8 b8 04 00 00       	call   800536 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,(myEnv->SecondListSize), 50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 03 31 80 00       	push   $0x803103
  800099:	e8 a8 1a 00 00       	call   801b46 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000aa:	e8 b5 1a 00 00       	call   801b64 <sys_run_env>
  8000af:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000b2:	90                   	nop
  8000b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b6:	8b 00                	mov    (%eax),%eax
  8000b8:	83 f8 01             	cmp    $0x1,%eax
  8000bb:	75 f6                	jne    8000b3 <_main+0x7b>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000bd:	e8 12 18 00 00       	call   8018d4 <sys_calculate_free_frames>
  8000c2:	83 ec 08             	sub    $0x8,%esp
  8000c5:	50                   	push   %eax
  8000c6:	68 0c 31 80 00       	push   $0x80310c
  8000cb:	e8 66 04 00 00       	call   800536 <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d9:	e8 a2 1a 00 00       	call   801b80 <sys_destroy_env>
  8000de:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000e1:	e8 ee 17 00 00       	call   8018d4 <sys_calculate_free_frames>
  8000e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e9:	e8 86 18 00 00       	call   801974 <sys_pf_calculate_allocated_pages>
  8000ee:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f7:	74 27                	je     800120 <_main+0xe8>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n", freeFrames_after);
  8000f9:	83 ec 08             	sub    $0x8,%esp
  8000fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000ff:	68 40 31 80 00       	push   $0x803140
  800104:	e8 2d 04 00 00       	call   800536 <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp
		panic("env_free() does not work correctly... check it again.");
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 90 31 80 00       	push   $0x803190
  800114:	6a 1e                	push   $0x1e
  800116:	68 c6 31 80 00       	push   $0x8031c6
  80011b:	e8 62 01 00 00       	call   800282 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	ff 75 e4             	pushl  -0x1c(%ebp)
  800126:	68 dc 31 80 00       	push   $0x8031dc
  80012b:	e8 06 04 00 00       	call   800536 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_1 for envfree completed successfully.\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 3c 32 80 00       	push   $0x80323c
  80013b:	e8 f6 03 00 00       	call   800536 <cprintf>
  800140:	83 c4 10             	add    $0x10,%esp
	return;
  800143:	90                   	nop
}
  800144:	c9                   	leave  
  800145:	c3                   	ret    

00800146 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800146:	55                   	push   %ebp
  800147:	89 e5                	mov    %esp,%ebp
  800149:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80014c:	e8 63 1a 00 00       	call   801bb4 <sys_getenvindex>
  800151:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800154:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800157:	89 d0                	mov    %edx,%eax
  800159:	c1 e0 03             	shl    $0x3,%eax
  80015c:	01 d0                	add    %edx,%eax
  80015e:	01 c0                	add    %eax,%eax
  800160:	01 d0                	add    %edx,%eax
  800162:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800169:	01 d0                	add    %edx,%eax
  80016b:	c1 e0 04             	shl    $0x4,%eax
  80016e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800173:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800178:	a1 20 40 80 00       	mov    0x804020,%eax
  80017d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800183:	84 c0                	test   %al,%al
  800185:	74 0f                	je     800196 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800187:	a1 20 40 80 00       	mov    0x804020,%eax
  80018c:	05 5c 05 00 00       	add    $0x55c,%eax
  800191:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800196:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80019a:	7e 0a                	jle    8001a6 <libmain+0x60>
		binaryname = argv[0];
  80019c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019f:	8b 00                	mov    (%eax),%eax
  8001a1:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001a6:	83 ec 08             	sub    $0x8,%esp
  8001a9:	ff 75 0c             	pushl  0xc(%ebp)
  8001ac:	ff 75 08             	pushl  0x8(%ebp)
  8001af:	e8 84 fe ff ff       	call   800038 <_main>
  8001b4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001b7:	e8 05 18 00 00       	call   8019c1 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	68 a0 32 80 00       	push   $0x8032a0
  8001c4:	e8 6d 03 00 00       	call   800536 <cprintf>
  8001c9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d1:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001d7:	a1 20 40 80 00       	mov    0x804020,%eax
  8001dc:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	52                   	push   %edx
  8001e6:	50                   	push   %eax
  8001e7:	68 c8 32 80 00       	push   $0x8032c8
  8001ec:	e8 45 03 00 00       	call   800536 <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f9:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001ff:	a1 20 40 80 00       	mov    0x804020,%eax
  800204:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80020a:	a1 20 40 80 00       	mov    0x804020,%eax
  80020f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800215:	51                   	push   %ecx
  800216:	52                   	push   %edx
  800217:	50                   	push   %eax
  800218:	68 f0 32 80 00       	push   $0x8032f0
  80021d:	e8 14 03 00 00       	call   800536 <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800225:	a1 20 40 80 00       	mov    0x804020,%eax
  80022a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	50                   	push   %eax
  800234:	68 48 33 80 00       	push   $0x803348
  800239:	e8 f8 02 00 00       	call   800536 <cprintf>
  80023e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	68 a0 32 80 00       	push   $0x8032a0
  800249:	e8 e8 02 00 00       	call   800536 <cprintf>
  80024e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800251:	e8 85 17 00 00       	call   8019db <sys_enable_interrupt>

	// exit gracefully
	exit();
  800256:	e8 19 00 00 00       	call   800274 <exit>
}
  80025b:	90                   	nop
  80025c:	c9                   	leave  
  80025d:	c3                   	ret    

0080025e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	6a 00                	push   $0x0
  800269:	e8 12 19 00 00       	call   801b80 <sys_destroy_env>
  80026e:	83 c4 10             	add    $0x10,%esp
}
  800271:	90                   	nop
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <exit>:

void
exit(void)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80027a:	e8 67 19 00 00       	call   801be6 <sys_exit_env>
}
  80027f:	90                   	nop
  800280:	c9                   	leave  
  800281:	c3                   	ret    

00800282 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800288:	8d 45 10             	lea    0x10(%ebp),%eax
  80028b:	83 c0 04             	add    $0x4,%eax
  80028e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800291:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800296:	85 c0                	test   %eax,%eax
  800298:	74 16                	je     8002b0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80029a:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80029f:	83 ec 08             	sub    $0x8,%esp
  8002a2:	50                   	push   %eax
  8002a3:	68 5c 33 80 00       	push   $0x80335c
  8002a8:	e8 89 02 00 00       	call   800536 <cprintf>
  8002ad:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002b0:	a1 00 40 80 00       	mov    0x804000,%eax
  8002b5:	ff 75 0c             	pushl  0xc(%ebp)
  8002b8:	ff 75 08             	pushl  0x8(%ebp)
  8002bb:	50                   	push   %eax
  8002bc:	68 61 33 80 00       	push   $0x803361
  8002c1:	e8 70 02 00 00       	call   800536 <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002cc:	83 ec 08             	sub    $0x8,%esp
  8002cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8002d2:	50                   	push   %eax
  8002d3:	e8 f3 01 00 00       	call   8004cb <vcprintf>
  8002d8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	6a 00                	push   $0x0
  8002e0:	68 7d 33 80 00       	push   $0x80337d
  8002e5:	e8 e1 01 00 00       	call   8004cb <vcprintf>
  8002ea:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002ed:	e8 82 ff ff ff       	call   800274 <exit>

	// should not return here
	while (1) ;
  8002f2:	eb fe                	jmp    8002f2 <_panic+0x70>

008002f4 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002fa:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ff:	8b 50 74             	mov    0x74(%eax),%edx
  800302:	8b 45 0c             	mov    0xc(%ebp),%eax
  800305:	39 c2                	cmp    %eax,%edx
  800307:	74 14                	je     80031d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800309:	83 ec 04             	sub    $0x4,%esp
  80030c:	68 80 33 80 00       	push   $0x803380
  800311:	6a 26                	push   $0x26
  800313:	68 cc 33 80 00       	push   $0x8033cc
  800318:	e8 65 ff ff ff       	call   800282 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80031d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800324:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80032b:	e9 c2 00 00 00       	jmp    8003f2 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800333:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033a:	8b 45 08             	mov    0x8(%ebp),%eax
  80033d:	01 d0                	add    %edx,%eax
  80033f:	8b 00                	mov    (%eax),%eax
  800341:	85 c0                	test   %eax,%eax
  800343:	75 08                	jne    80034d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800345:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800348:	e9 a2 00 00 00       	jmp    8003ef <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80034d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800354:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80035b:	eb 69                	jmp    8003c6 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80035d:	a1 20 40 80 00       	mov    0x804020,%eax
  800362:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800368:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80036b:	89 d0                	mov    %edx,%eax
  80036d:	01 c0                	add    %eax,%eax
  80036f:	01 d0                	add    %edx,%eax
  800371:	c1 e0 03             	shl    $0x3,%eax
  800374:	01 c8                	add    %ecx,%eax
  800376:	8a 40 04             	mov    0x4(%eax),%al
  800379:	84 c0                	test   %al,%al
  80037b:	75 46                	jne    8003c3 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80037d:	a1 20 40 80 00       	mov    0x804020,%eax
  800382:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800388:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80038b:	89 d0                	mov    %edx,%eax
  80038d:	01 c0                	add    %eax,%eax
  80038f:	01 d0                	add    %edx,%eax
  800391:	c1 e0 03             	shl    $0x3,%eax
  800394:	01 c8                	add    %ecx,%eax
  800396:	8b 00                	mov    (%eax),%eax
  800398:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80039b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003af:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b2:	01 c8                	add    %ecx,%eax
  8003b4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b6:	39 c2                	cmp    %eax,%edx
  8003b8:	75 09                	jne    8003c3 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003ba:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003c1:	eb 12                	jmp    8003d5 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c3:	ff 45 e8             	incl   -0x18(%ebp)
  8003c6:	a1 20 40 80 00       	mov    0x804020,%eax
  8003cb:	8b 50 74             	mov    0x74(%eax),%edx
  8003ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003d1:	39 c2                	cmp    %eax,%edx
  8003d3:	77 88                	ja     80035d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003d9:	75 14                	jne    8003ef <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003db:	83 ec 04             	sub    $0x4,%esp
  8003de:	68 d8 33 80 00       	push   $0x8033d8
  8003e3:	6a 3a                	push   $0x3a
  8003e5:	68 cc 33 80 00       	push   $0x8033cc
  8003ea:	e8 93 fe ff ff       	call   800282 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003ef:	ff 45 f0             	incl   -0x10(%ebp)
  8003f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f8:	0f 8c 32 ff ff ff    	jl     800330 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003fe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800405:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80040c:	eb 26                	jmp    800434 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80040e:	a1 20 40 80 00       	mov    0x804020,%eax
  800413:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800419:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	01 c0                	add    %eax,%eax
  800420:	01 d0                	add    %edx,%eax
  800422:	c1 e0 03             	shl    $0x3,%eax
  800425:	01 c8                	add    %ecx,%eax
  800427:	8a 40 04             	mov    0x4(%eax),%al
  80042a:	3c 01                	cmp    $0x1,%al
  80042c:	75 03                	jne    800431 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80042e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800431:	ff 45 e0             	incl   -0x20(%ebp)
  800434:	a1 20 40 80 00       	mov    0x804020,%eax
  800439:	8b 50 74             	mov    0x74(%eax),%edx
  80043c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043f:	39 c2                	cmp    %eax,%edx
  800441:	77 cb                	ja     80040e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800446:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800449:	74 14                	je     80045f <CheckWSWithoutLastIndex+0x16b>
		panic(
  80044b:	83 ec 04             	sub    $0x4,%esp
  80044e:	68 2c 34 80 00       	push   $0x80342c
  800453:	6a 44                	push   $0x44
  800455:	68 cc 33 80 00       	push   $0x8033cc
  80045a:	e8 23 fe ff ff       	call   800282 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80045f:	90                   	nop
  800460:	c9                   	leave  
  800461:	c3                   	ret    

00800462 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	8d 48 01             	lea    0x1(%eax),%ecx
  800470:	8b 55 0c             	mov    0xc(%ebp),%edx
  800473:	89 0a                	mov    %ecx,(%edx)
  800475:	8b 55 08             	mov    0x8(%ebp),%edx
  800478:	88 d1                	mov    %dl,%cl
  80047a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80047d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800481:	8b 45 0c             	mov    0xc(%ebp),%eax
  800484:	8b 00                	mov    (%eax),%eax
  800486:	3d ff 00 00 00       	cmp    $0xff,%eax
  80048b:	75 2c                	jne    8004b9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80048d:	a0 24 40 80 00       	mov    0x804024,%al
  800492:	0f b6 c0             	movzbl %al,%eax
  800495:	8b 55 0c             	mov    0xc(%ebp),%edx
  800498:	8b 12                	mov    (%edx),%edx
  80049a:	89 d1                	mov    %edx,%ecx
  80049c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049f:	83 c2 08             	add    $0x8,%edx
  8004a2:	83 ec 04             	sub    $0x4,%esp
  8004a5:	50                   	push   %eax
  8004a6:	51                   	push   %ecx
  8004a7:	52                   	push   %edx
  8004a8:	e8 66 13 00 00       	call   801813 <sys_cputs>
  8004ad:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bc:	8b 40 04             	mov    0x4(%eax),%eax
  8004bf:	8d 50 01             	lea    0x1(%eax),%edx
  8004c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004c8:	90                   	nop
  8004c9:	c9                   	leave  
  8004ca:	c3                   	ret    

008004cb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004cb:	55                   	push   %ebp
  8004cc:	89 e5                	mov    %esp,%ebp
  8004ce:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004d4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004db:	00 00 00 
	b.cnt = 0;
  8004de:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004e8:	ff 75 0c             	pushl  0xc(%ebp)
  8004eb:	ff 75 08             	pushl  0x8(%ebp)
  8004ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f4:	50                   	push   %eax
  8004f5:	68 62 04 80 00       	push   $0x800462
  8004fa:	e8 11 02 00 00       	call   800710 <vprintfmt>
  8004ff:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800502:	a0 24 40 80 00       	mov    0x804024,%al
  800507:	0f b6 c0             	movzbl %al,%eax
  80050a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800510:	83 ec 04             	sub    $0x4,%esp
  800513:	50                   	push   %eax
  800514:	52                   	push   %edx
  800515:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80051b:	83 c0 08             	add    $0x8,%eax
  80051e:	50                   	push   %eax
  80051f:	e8 ef 12 00 00       	call   801813 <sys_cputs>
  800524:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800527:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80052e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800534:	c9                   	leave  
  800535:	c3                   	ret    

00800536 <cprintf>:

int cprintf(const char *fmt, ...) {
  800536:	55                   	push   %ebp
  800537:	89 e5                	mov    %esp,%ebp
  800539:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80053c:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800543:	8d 45 0c             	lea    0xc(%ebp),%eax
  800546:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	83 ec 08             	sub    $0x8,%esp
  80054f:	ff 75 f4             	pushl  -0xc(%ebp)
  800552:	50                   	push   %eax
  800553:	e8 73 ff ff ff       	call   8004cb <vcprintf>
  800558:	83 c4 10             	add    $0x10,%esp
  80055b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80055e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800561:	c9                   	leave  
  800562:	c3                   	ret    

00800563 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800563:	55                   	push   %ebp
  800564:	89 e5                	mov    %esp,%ebp
  800566:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800569:	e8 53 14 00 00       	call   8019c1 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80056e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800571:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800574:	8b 45 08             	mov    0x8(%ebp),%eax
  800577:	83 ec 08             	sub    $0x8,%esp
  80057a:	ff 75 f4             	pushl  -0xc(%ebp)
  80057d:	50                   	push   %eax
  80057e:	e8 48 ff ff ff       	call   8004cb <vcprintf>
  800583:	83 c4 10             	add    $0x10,%esp
  800586:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800589:	e8 4d 14 00 00       	call   8019db <sys_enable_interrupt>
	return cnt;
  80058e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800591:	c9                   	leave  
  800592:	c3                   	ret    

00800593 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	53                   	push   %ebx
  800597:	83 ec 14             	sub    $0x14,%esp
  80059a:	8b 45 10             	mov    0x10(%ebp),%eax
  80059d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a6:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ae:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b1:	77 55                	ja     800608 <printnum+0x75>
  8005b3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b6:	72 05                	jb     8005bd <printnum+0x2a>
  8005b8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005bb:	77 4b                	ja     800608 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005bd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005c0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005c3:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cb:	52                   	push   %edx
  8005cc:	50                   	push   %eax
  8005cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8005d3:	e8 84 28 00 00       	call   802e5c <__udivdi3>
  8005d8:	83 c4 10             	add    $0x10,%esp
  8005db:	83 ec 04             	sub    $0x4,%esp
  8005de:	ff 75 20             	pushl  0x20(%ebp)
  8005e1:	53                   	push   %ebx
  8005e2:	ff 75 18             	pushl  0x18(%ebp)
  8005e5:	52                   	push   %edx
  8005e6:	50                   	push   %eax
  8005e7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ea:	ff 75 08             	pushl  0x8(%ebp)
  8005ed:	e8 a1 ff ff ff       	call   800593 <printnum>
  8005f2:	83 c4 20             	add    $0x20,%esp
  8005f5:	eb 1a                	jmp    800611 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f7:	83 ec 08             	sub    $0x8,%esp
  8005fa:	ff 75 0c             	pushl  0xc(%ebp)
  8005fd:	ff 75 20             	pushl  0x20(%ebp)
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	ff d0                	call   *%eax
  800605:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800608:	ff 4d 1c             	decl   0x1c(%ebp)
  80060b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80060f:	7f e6                	jg     8005f7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800611:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800614:	bb 00 00 00 00       	mov    $0x0,%ebx
  800619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061f:	53                   	push   %ebx
  800620:	51                   	push   %ecx
  800621:	52                   	push   %edx
  800622:	50                   	push   %eax
  800623:	e8 44 29 00 00       	call   802f6c <__umoddi3>
  800628:	83 c4 10             	add    $0x10,%esp
  80062b:	05 94 36 80 00       	add    $0x803694,%eax
  800630:	8a 00                	mov    (%eax),%al
  800632:	0f be c0             	movsbl %al,%eax
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	ff 75 0c             	pushl  0xc(%ebp)
  80063b:	50                   	push   %eax
  80063c:	8b 45 08             	mov    0x8(%ebp),%eax
  80063f:	ff d0                	call   *%eax
  800641:	83 c4 10             	add    $0x10,%esp
}
  800644:	90                   	nop
  800645:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800648:	c9                   	leave  
  800649:	c3                   	ret    

0080064a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80064a:	55                   	push   %ebp
  80064b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80064d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800651:	7e 1c                	jle    80066f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800653:	8b 45 08             	mov    0x8(%ebp),%eax
  800656:	8b 00                	mov    (%eax),%eax
  800658:	8d 50 08             	lea    0x8(%eax),%edx
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	89 10                	mov    %edx,(%eax)
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	83 e8 08             	sub    $0x8,%eax
  800668:	8b 50 04             	mov    0x4(%eax),%edx
  80066b:	8b 00                	mov    (%eax),%eax
  80066d:	eb 40                	jmp    8006af <getuint+0x65>
	else if (lflag)
  80066f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800673:	74 1e                	je     800693 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800675:	8b 45 08             	mov    0x8(%ebp),%eax
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	8d 50 04             	lea    0x4(%eax),%edx
  80067d:	8b 45 08             	mov    0x8(%ebp),%eax
  800680:	89 10                	mov    %edx,(%eax)
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	83 e8 04             	sub    $0x4,%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	ba 00 00 00 00       	mov    $0x0,%edx
  800691:	eb 1c                	jmp    8006af <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	8d 50 04             	lea    0x4(%eax),%edx
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	89 10                	mov    %edx,(%eax)
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	83 e8 04             	sub    $0x4,%eax
  8006a8:	8b 00                	mov    (%eax),%eax
  8006aa:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006af:	5d                   	pop    %ebp
  8006b0:	c3                   	ret    

008006b1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006b1:	55                   	push   %ebp
  8006b2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b8:	7e 1c                	jle    8006d6 <getint+0x25>
		return va_arg(*ap, long long);
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	8d 50 08             	lea    0x8(%eax),%edx
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	89 10                	mov    %edx,(%eax)
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	83 e8 08             	sub    $0x8,%eax
  8006cf:	8b 50 04             	mov    0x4(%eax),%edx
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	eb 38                	jmp    80070e <getint+0x5d>
	else if (lflag)
  8006d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006da:	74 1a                	je     8006f6 <getint+0x45>
		return va_arg(*ap, long);
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	8d 50 04             	lea    0x4(%eax),%edx
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	89 10                	mov    %edx,(%eax)
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	83 e8 04             	sub    $0x4,%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	99                   	cltd   
  8006f4:	eb 18                	jmp    80070e <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	8d 50 04             	lea    0x4(%eax),%edx
  8006fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800701:	89 10                	mov    %edx,(%eax)
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	8b 00                	mov    (%eax),%eax
  800708:	83 e8 04             	sub    $0x4,%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	99                   	cltd   
}
  80070e:	5d                   	pop    %ebp
  80070f:	c3                   	ret    

00800710 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	56                   	push   %esi
  800714:	53                   	push   %ebx
  800715:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800718:	eb 17                	jmp    800731 <vprintfmt+0x21>
			if (ch == '\0')
  80071a:	85 db                	test   %ebx,%ebx
  80071c:	0f 84 af 03 00 00    	je     800ad1 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	ff 75 0c             	pushl  0xc(%ebp)
  800728:	53                   	push   %ebx
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	ff d0                	call   *%eax
  80072e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800731:	8b 45 10             	mov    0x10(%ebp),%eax
  800734:	8d 50 01             	lea    0x1(%eax),%edx
  800737:	89 55 10             	mov    %edx,0x10(%ebp)
  80073a:	8a 00                	mov    (%eax),%al
  80073c:	0f b6 d8             	movzbl %al,%ebx
  80073f:	83 fb 25             	cmp    $0x25,%ebx
  800742:	75 d6                	jne    80071a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800744:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800748:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80074f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800756:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80075d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800764:	8b 45 10             	mov    0x10(%ebp),%eax
  800767:	8d 50 01             	lea    0x1(%eax),%edx
  80076a:	89 55 10             	mov    %edx,0x10(%ebp)
  80076d:	8a 00                	mov    (%eax),%al
  80076f:	0f b6 d8             	movzbl %al,%ebx
  800772:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800775:	83 f8 55             	cmp    $0x55,%eax
  800778:	0f 87 2b 03 00 00    	ja     800aa9 <vprintfmt+0x399>
  80077e:	8b 04 85 b8 36 80 00 	mov    0x8036b8(,%eax,4),%eax
  800785:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800787:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80078b:	eb d7                	jmp    800764 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80078d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800791:	eb d1                	jmp    800764 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800793:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80079a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80079d:	89 d0                	mov    %edx,%eax
  80079f:	c1 e0 02             	shl    $0x2,%eax
  8007a2:	01 d0                	add    %edx,%eax
  8007a4:	01 c0                	add    %eax,%eax
  8007a6:	01 d8                	add    %ebx,%eax
  8007a8:	83 e8 30             	sub    $0x30,%eax
  8007ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b1:	8a 00                	mov    (%eax),%al
  8007b3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007b6:	83 fb 2f             	cmp    $0x2f,%ebx
  8007b9:	7e 3e                	jle    8007f9 <vprintfmt+0xe9>
  8007bb:	83 fb 39             	cmp    $0x39,%ebx
  8007be:	7f 39                	jg     8007f9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007c3:	eb d5                	jmp    80079a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	83 c0 04             	add    $0x4,%eax
  8007cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	83 e8 04             	sub    $0x4,%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007d9:	eb 1f                	jmp    8007fa <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007df:	79 83                	jns    800764 <vprintfmt+0x54>
				width = 0;
  8007e1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007e8:	e9 77 ff ff ff       	jmp    800764 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007ed:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007f4:	e9 6b ff ff ff       	jmp    800764 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007f9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fe:	0f 89 60 ff ff ff    	jns    800764 <vprintfmt+0x54>
				width = precision, precision = -1;
  800804:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800807:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80080a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800811:	e9 4e ff ff ff       	jmp    800764 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800816:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800819:	e9 46 ff ff ff       	jmp    800764 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80081e:	8b 45 14             	mov    0x14(%ebp),%eax
  800821:	83 c0 04             	add    $0x4,%eax
  800824:	89 45 14             	mov    %eax,0x14(%ebp)
  800827:	8b 45 14             	mov    0x14(%ebp),%eax
  80082a:	83 e8 04             	sub    $0x4,%eax
  80082d:	8b 00                	mov    (%eax),%eax
  80082f:	83 ec 08             	sub    $0x8,%esp
  800832:	ff 75 0c             	pushl  0xc(%ebp)
  800835:	50                   	push   %eax
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	ff d0                	call   *%eax
  80083b:	83 c4 10             	add    $0x10,%esp
			break;
  80083e:	e9 89 02 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800843:	8b 45 14             	mov    0x14(%ebp),%eax
  800846:	83 c0 04             	add    $0x4,%eax
  800849:	89 45 14             	mov    %eax,0x14(%ebp)
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	83 e8 04             	sub    $0x4,%eax
  800852:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800854:	85 db                	test   %ebx,%ebx
  800856:	79 02                	jns    80085a <vprintfmt+0x14a>
				err = -err;
  800858:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80085a:	83 fb 64             	cmp    $0x64,%ebx
  80085d:	7f 0b                	jg     80086a <vprintfmt+0x15a>
  80085f:	8b 34 9d 00 35 80 00 	mov    0x803500(,%ebx,4),%esi
  800866:	85 f6                	test   %esi,%esi
  800868:	75 19                	jne    800883 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80086a:	53                   	push   %ebx
  80086b:	68 a5 36 80 00       	push   $0x8036a5
  800870:	ff 75 0c             	pushl  0xc(%ebp)
  800873:	ff 75 08             	pushl  0x8(%ebp)
  800876:	e8 5e 02 00 00       	call   800ad9 <printfmt>
  80087b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80087e:	e9 49 02 00 00       	jmp    800acc <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800883:	56                   	push   %esi
  800884:	68 ae 36 80 00       	push   $0x8036ae
  800889:	ff 75 0c             	pushl  0xc(%ebp)
  80088c:	ff 75 08             	pushl  0x8(%ebp)
  80088f:	e8 45 02 00 00       	call   800ad9 <printfmt>
  800894:	83 c4 10             	add    $0x10,%esp
			break;
  800897:	e9 30 02 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	83 c0 04             	add    $0x4,%eax
  8008a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	83 e8 04             	sub    $0x4,%eax
  8008ab:	8b 30                	mov    (%eax),%esi
  8008ad:	85 f6                	test   %esi,%esi
  8008af:	75 05                	jne    8008b6 <vprintfmt+0x1a6>
				p = "(null)";
  8008b1:	be b1 36 80 00       	mov    $0x8036b1,%esi
			if (width > 0 && padc != '-')
  8008b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ba:	7e 6d                	jle    800929 <vprintfmt+0x219>
  8008bc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008c0:	74 67                	je     800929 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c5:	83 ec 08             	sub    $0x8,%esp
  8008c8:	50                   	push   %eax
  8008c9:	56                   	push   %esi
  8008ca:	e8 0c 03 00 00       	call   800bdb <strnlen>
  8008cf:	83 c4 10             	add    $0x10,%esp
  8008d2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d5:	eb 16                	jmp    8008ed <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008d7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008db:	83 ec 08             	sub    $0x8,%esp
  8008de:	ff 75 0c             	pushl  0xc(%ebp)
  8008e1:	50                   	push   %eax
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	ff d0                	call   *%eax
  8008e7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ea:	ff 4d e4             	decl   -0x1c(%ebp)
  8008ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f1:	7f e4                	jg     8008d7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f3:	eb 34                	jmp    800929 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008f9:	74 1c                	je     800917 <vprintfmt+0x207>
  8008fb:	83 fb 1f             	cmp    $0x1f,%ebx
  8008fe:	7e 05                	jle    800905 <vprintfmt+0x1f5>
  800900:	83 fb 7e             	cmp    $0x7e,%ebx
  800903:	7e 12                	jle    800917 <vprintfmt+0x207>
					putch('?', putdat);
  800905:	83 ec 08             	sub    $0x8,%esp
  800908:	ff 75 0c             	pushl  0xc(%ebp)
  80090b:	6a 3f                	push   $0x3f
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	ff d0                	call   *%eax
  800912:	83 c4 10             	add    $0x10,%esp
  800915:	eb 0f                	jmp    800926 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800917:	83 ec 08             	sub    $0x8,%esp
  80091a:	ff 75 0c             	pushl  0xc(%ebp)
  80091d:	53                   	push   %ebx
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	ff d0                	call   *%eax
  800923:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800926:	ff 4d e4             	decl   -0x1c(%ebp)
  800929:	89 f0                	mov    %esi,%eax
  80092b:	8d 70 01             	lea    0x1(%eax),%esi
  80092e:	8a 00                	mov    (%eax),%al
  800930:	0f be d8             	movsbl %al,%ebx
  800933:	85 db                	test   %ebx,%ebx
  800935:	74 24                	je     80095b <vprintfmt+0x24b>
  800937:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80093b:	78 b8                	js     8008f5 <vprintfmt+0x1e5>
  80093d:	ff 4d e0             	decl   -0x20(%ebp)
  800940:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800944:	79 af                	jns    8008f5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800946:	eb 13                	jmp    80095b <vprintfmt+0x24b>
				putch(' ', putdat);
  800948:	83 ec 08             	sub    $0x8,%esp
  80094b:	ff 75 0c             	pushl  0xc(%ebp)
  80094e:	6a 20                	push   $0x20
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	ff d0                	call   *%eax
  800955:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800958:	ff 4d e4             	decl   -0x1c(%ebp)
  80095b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095f:	7f e7                	jg     800948 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800961:	e9 66 01 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800966:	83 ec 08             	sub    $0x8,%esp
  800969:	ff 75 e8             	pushl  -0x18(%ebp)
  80096c:	8d 45 14             	lea    0x14(%ebp),%eax
  80096f:	50                   	push   %eax
  800970:	e8 3c fd ff ff       	call   8006b1 <getint>
  800975:	83 c4 10             	add    $0x10,%esp
  800978:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80097e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800981:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800984:	85 d2                	test   %edx,%edx
  800986:	79 23                	jns    8009ab <vprintfmt+0x29b>
				putch('-', putdat);
  800988:	83 ec 08             	sub    $0x8,%esp
  80098b:	ff 75 0c             	pushl  0xc(%ebp)
  80098e:	6a 2d                	push   $0x2d
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	ff d0                	call   *%eax
  800995:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800998:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80099b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80099e:	f7 d8                	neg    %eax
  8009a0:	83 d2 00             	adc    $0x0,%edx
  8009a3:	f7 da                	neg    %edx
  8009a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009ab:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009b2:	e9 bc 00 00 00       	jmp    800a73 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009b7:	83 ec 08             	sub    $0x8,%esp
  8009ba:	ff 75 e8             	pushl  -0x18(%ebp)
  8009bd:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c0:	50                   	push   %eax
  8009c1:	e8 84 fc ff ff       	call   80064a <getuint>
  8009c6:	83 c4 10             	add    $0x10,%esp
  8009c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009cf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d6:	e9 98 00 00 00       	jmp    800a73 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	ff 75 0c             	pushl  0xc(%ebp)
  8009e1:	6a 58                	push   $0x58
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	ff d0                	call   *%eax
  8009e8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009eb:	83 ec 08             	sub    $0x8,%esp
  8009ee:	ff 75 0c             	pushl  0xc(%ebp)
  8009f1:	6a 58                	push   $0x58
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	ff d0                	call   *%eax
  8009f8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	ff 75 0c             	pushl  0xc(%ebp)
  800a01:	6a 58                	push   $0x58
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	ff d0                	call   *%eax
  800a08:	83 c4 10             	add    $0x10,%esp
			break;
  800a0b:	e9 bc 00 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a10:	83 ec 08             	sub    $0x8,%esp
  800a13:	ff 75 0c             	pushl  0xc(%ebp)
  800a16:	6a 30                	push   $0x30
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	ff d0                	call   *%eax
  800a1d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a20:	83 ec 08             	sub    $0x8,%esp
  800a23:	ff 75 0c             	pushl  0xc(%ebp)
  800a26:	6a 78                	push   $0x78
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	ff d0                	call   *%eax
  800a2d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a30:	8b 45 14             	mov    0x14(%ebp),%eax
  800a33:	83 c0 04             	add    $0x4,%eax
  800a36:	89 45 14             	mov    %eax,0x14(%ebp)
  800a39:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3c:	83 e8 04             	sub    $0x4,%eax
  800a3f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a4b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a52:	eb 1f                	jmp    800a73 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 e8             	pushl  -0x18(%ebp)
  800a5a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5d:	50                   	push   %eax
  800a5e:	e8 e7 fb ff ff       	call   80064a <getuint>
  800a63:	83 c4 10             	add    $0x10,%esp
  800a66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a69:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a6c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a73:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a7a:	83 ec 04             	sub    $0x4,%esp
  800a7d:	52                   	push   %edx
  800a7e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a81:	50                   	push   %eax
  800a82:	ff 75 f4             	pushl  -0xc(%ebp)
  800a85:	ff 75 f0             	pushl  -0x10(%ebp)
  800a88:	ff 75 0c             	pushl  0xc(%ebp)
  800a8b:	ff 75 08             	pushl  0x8(%ebp)
  800a8e:	e8 00 fb ff ff       	call   800593 <printnum>
  800a93:	83 c4 20             	add    $0x20,%esp
			break;
  800a96:	eb 34                	jmp    800acc <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a98:	83 ec 08             	sub    $0x8,%esp
  800a9b:	ff 75 0c             	pushl  0xc(%ebp)
  800a9e:	53                   	push   %ebx
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	ff d0                	call   *%eax
  800aa4:	83 c4 10             	add    $0x10,%esp
			break;
  800aa7:	eb 23                	jmp    800acc <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	ff 75 0c             	pushl  0xc(%ebp)
  800aaf:	6a 25                	push   $0x25
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	ff d0                	call   *%eax
  800ab6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ab9:	ff 4d 10             	decl   0x10(%ebp)
  800abc:	eb 03                	jmp    800ac1 <vprintfmt+0x3b1>
  800abe:	ff 4d 10             	decl   0x10(%ebp)
  800ac1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac4:	48                   	dec    %eax
  800ac5:	8a 00                	mov    (%eax),%al
  800ac7:	3c 25                	cmp    $0x25,%al
  800ac9:	75 f3                	jne    800abe <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800acb:	90                   	nop
		}
	}
  800acc:	e9 47 fc ff ff       	jmp    800718 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ad1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ad2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ad5:	5b                   	pop    %ebx
  800ad6:	5e                   	pop    %esi
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    

00800ad9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800adf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ae2:	83 c0 04             	add    $0x4,%eax
  800ae5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ae8:	8b 45 10             	mov    0x10(%ebp),%eax
  800aeb:	ff 75 f4             	pushl  -0xc(%ebp)
  800aee:	50                   	push   %eax
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	ff 75 08             	pushl  0x8(%ebp)
  800af5:	e8 16 fc ff ff       	call   800710 <vprintfmt>
  800afa:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800afd:	90                   	nop
  800afe:	c9                   	leave  
  800aff:	c3                   	ret    

00800b00 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b06:	8b 40 08             	mov    0x8(%eax),%eax
  800b09:	8d 50 01             	lea    0x1(%eax),%edx
  800b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b15:	8b 10                	mov    (%eax),%edx
  800b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1a:	8b 40 04             	mov    0x4(%eax),%eax
  800b1d:	39 c2                	cmp    %eax,%edx
  800b1f:	73 12                	jae    800b33 <sprintputch+0x33>
		*b->buf++ = ch;
  800b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b24:	8b 00                	mov    (%eax),%eax
  800b26:	8d 48 01             	lea    0x1(%eax),%ecx
  800b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2c:	89 0a                	mov    %ecx,(%edx)
  800b2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b31:	88 10                	mov    %dl,(%eax)
}
  800b33:	90                   	nop
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	01 d0                	add    %edx,%eax
  800b4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b5b:	74 06                	je     800b63 <vsnprintf+0x2d>
  800b5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b61:	7f 07                	jg     800b6a <vsnprintf+0x34>
		return -E_INVAL;
  800b63:	b8 03 00 00 00       	mov    $0x3,%eax
  800b68:	eb 20                	jmp    800b8a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b6a:	ff 75 14             	pushl  0x14(%ebp)
  800b6d:	ff 75 10             	pushl  0x10(%ebp)
  800b70:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b73:	50                   	push   %eax
  800b74:	68 00 0b 80 00       	push   $0x800b00
  800b79:	e8 92 fb ff ff       	call   800710 <vprintfmt>
  800b7e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b84:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b8a:	c9                   	leave  
  800b8b:	c3                   	ret    

00800b8c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b92:	8d 45 10             	lea    0x10(%ebp),%eax
  800b95:	83 c0 04             	add    $0x4,%eax
  800b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9e:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba1:	50                   	push   %eax
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	ff 75 08             	pushl  0x8(%ebp)
  800ba8:	e8 89 ff ff ff       	call   800b36 <vsnprintf>
  800bad:	83 c4 10             	add    $0x10,%esp
  800bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc5:	eb 06                	jmp    800bcd <strlen+0x15>
		n++;
  800bc7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bca:	ff 45 08             	incl   0x8(%ebp)
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	84 c0                	test   %al,%al
  800bd4:	75 f1                	jne    800bc7 <strlen+0xf>
		n++;
	return n;
  800bd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

00800bdb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be8:	eb 09                	jmp    800bf3 <strnlen+0x18>
		n++;
  800bea:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bed:	ff 45 08             	incl   0x8(%ebp)
  800bf0:	ff 4d 0c             	decl   0xc(%ebp)
  800bf3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf7:	74 09                	je     800c02 <strnlen+0x27>
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8a 00                	mov    (%eax),%al
  800bfe:	84 c0                	test   %al,%al
  800c00:	75 e8                	jne    800bea <strnlen+0xf>
		n++;
	return n;
  800c02:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c05:	c9                   	leave  
  800c06:	c3                   	ret    

00800c07 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c13:	90                   	nop
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	8d 50 01             	lea    0x1(%eax),%edx
  800c1a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c20:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c23:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c26:	8a 12                	mov    (%edx),%dl
  800c28:	88 10                	mov    %dl,(%eax)
  800c2a:	8a 00                	mov    (%eax),%al
  800c2c:	84 c0                	test   %al,%al
  800c2e:	75 e4                	jne    800c14 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c30:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c33:	c9                   	leave  
  800c34:	c3                   	ret    

00800c35 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c48:	eb 1f                	jmp    800c69 <strncpy+0x34>
		*dst++ = *src;
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	8d 50 01             	lea    0x1(%eax),%edx
  800c50:	89 55 08             	mov    %edx,0x8(%ebp)
  800c53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c56:	8a 12                	mov    (%edx),%dl
  800c58:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5d:	8a 00                	mov    (%eax),%al
  800c5f:	84 c0                	test   %al,%al
  800c61:	74 03                	je     800c66 <strncpy+0x31>
			src++;
  800c63:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c66:	ff 45 fc             	incl   -0x4(%ebp)
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c6f:	72 d9                	jb     800c4a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c71:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c74:	c9                   	leave  
  800c75:	c3                   	ret    

00800c76 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c86:	74 30                	je     800cb8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c88:	eb 16                	jmp    800ca0 <strlcpy+0x2a>
			*dst++ = *src++;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	8d 50 01             	lea    0x1(%eax),%edx
  800c90:	89 55 08             	mov    %edx,0x8(%ebp)
  800c93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c96:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c99:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c9c:	8a 12                	mov    (%edx),%dl
  800c9e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ca0:	ff 4d 10             	decl   0x10(%ebp)
  800ca3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca7:	74 09                	je     800cb2 <strlcpy+0x3c>
  800ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cac:	8a 00                	mov    (%eax),%al
  800cae:	84 c0                	test   %al,%al
  800cb0:	75 d8                	jne    800c8a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbe:	29 c2                	sub    %eax,%edx
  800cc0:	89 d0                	mov    %edx,%eax
}
  800cc2:	c9                   	leave  
  800cc3:	c3                   	ret    

00800cc4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cc7:	eb 06                	jmp    800ccf <strcmp+0xb>
		p++, q++;
  800cc9:	ff 45 08             	incl   0x8(%ebp)
  800ccc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8a 00                	mov    (%eax),%al
  800cd4:	84 c0                	test   %al,%al
  800cd6:	74 0e                	je     800ce6 <strcmp+0x22>
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	8a 10                	mov    (%eax),%dl
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	38 c2                	cmp    %al,%dl
  800ce4:	74 e3                	je     800cc9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8a 00                	mov    (%eax),%al
  800ceb:	0f b6 d0             	movzbl %al,%edx
  800cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	0f b6 c0             	movzbl %al,%eax
  800cf6:	29 c2                	sub    %eax,%edx
  800cf8:	89 d0                	mov    %edx,%eax
}
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    

00800cfc <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cff:	eb 09                	jmp    800d0a <strncmp+0xe>
		n--, p++, q++;
  800d01:	ff 4d 10             	decl   0x10(%ebp)
  800d04:	ff 45 08             	incl   0x8(%ebp)
  800d07:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0e:	74 17                	je     800d27 <strncmp+0x2b>
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	84 c0                	test   %al,%al
  800d17:	74 0e                	je     800d27 <strncmp+0x2b>
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8a 10                	mov    (%eax),%dl
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	38 c2                	cmp    %al,%dl
  800d25:	74 da                	je     800d01 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2b:	75 07                	jne    800d34 <strncmp+0x38>
		return 0;
  800d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d32:	eb 14                	jmp    800d48 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	0f b6 d0             	movzbl %al,%edx
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	0f b6 c0             	movzbl %al,%eax
  800d44:	29 c2                	sub    %eax,%edx
  800d46:	89 d0                	mov    %edx,%eax
}
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	83 ec 04             	sub    $0x4,%esp
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d56:	eb 12                	jmp    800d6a <strchr+0x20>
		if (*s == c)
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8a 00                	mov    (%eax),%al
  800d5d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d60:	75 05                	jne    800d67 <strchr+0x1d>
			return (char *) s;
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	eb 11                	jmp    800d78 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d67:	ff 45 08             	incl   0x8(%ebp)
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	84 c0                	test   %al,%al
  800d71:	75 e5                	jne    800d58 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d78:	c9                   	leave  
  800d79:	c3                   	ret    

00800d7a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 04             	sub    $0x4,%esp
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d86:	eb 0d                	jmp    800d95 <strfind+0x1b>
		if (*s == c)
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d90:	74 0e                	je     800da0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d92:	ff 45 08             	incl   0x8(%ebp)
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	84 c0                	test   %al,%al
  800d9c:	75 ea                	jne    800d88 <strfind+0xe>
  800d9e:	eb 01                	jmp    800da1 <strfind+0x27>
		if (*s == c)
			break;
  800da0:	90                   	nop
	return (char *) s;
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da4:	c9                   	leave  
  800da5:	c3                   	ret    

00800da6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800db2:	8b 45 10             	mov    0x10(%ebp),%eax
  800db5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800db8:	eb 0e                	jmp    800dc8 <memset+0x22>
		*p++ = c;
  800dba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dbd:	8d 50 01             	lea    0x1(%eax),%edx
  800dc0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dc8:	ff 4d f8             	decl   -0x8(%ebp)
  800dcb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dcf:	79 e9                	jns    800dba <memset+0x14>
		*p++ = c;

	return v;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd4:	c9                   	leave  
  800dd5:	c3                   	ret    

00800dd6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800de8:	eb 16                	jmp    800e00 <memcpy+0x2a>
		*d++ = *s++;
  800dea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ded:	8d 50 01             	lea    0x1(%eax),%edx
  800df0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800df3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800df6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dfc:	8a 12                	mov    (%edx),%dl
  800dfe:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e00:	8b 45 10             	mov    0x10(%ebp),%eax
  800e03:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e06:	89 55 10             	mov    %edx,0x10(%ebp)
  800e09:	85 c0                	test   %eax,%eax
  800e0b:	75 dd                	jne    800dea <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e10:	c9                   	leave  
  800e11:	c3                   	ret    

00800e12 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e27:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e2a:	73 50                	jae    800e7c <memmove+0x6a>
  800e2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e32:	01 d0                	add    %edx,%eax
  800e34:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e37:	76 43                	jbe    800e7c <memmove+0x6a>
		s += n;
  800e39:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e42:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e45:	eb 10                	jmp    800e57 <memmove+0x45>
			*--d = *--s;
  800e47:	ff 4d f8             	decl   -0x8(%ebp)
  800e4a:	ff 4d fc             	decl   -0x4(%ebp)
  800e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e50:	8a 10                	mov    (%eax),%dl
  800e52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e55:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e57:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e60:	85 c0                	test   %eax,%eax
  800e62:	75 e3                	jne    800e47 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e64:	eb 23                	jmp    800e89 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e69:	8d 50 01             	lea    0x1(%eax),%edx
  800e6c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e6f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e72:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e75:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e78:	8a 12                	mov    (%edx),%dl
  800e7a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e82:	89 55 10             	mov    %edx,0x10(%ebp)
  800e85:	85 c0                	test   %eax,%eax
  800e87:	75 dd                	jne    800e66 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ea0:	eb 2a                	jmp    800ecc <memcmp+0x3e>
		if (*s1 != *s2)
  800ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea5:	8a 10                	mov    (%eax),%dl
  800ea7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	38 c2                	cmp    %al,%dl
  800eae:	74 16                	je     800ec6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	0f b6 d0             	movzbl %al,%edx
  800eb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	0f b6 c0             	movzbl %al,%eax
  800ec0:	29 c2                	sub    %eax,%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	eb 18                	jmp    800ede <memcmp+0x50>
		s1++, s2++;
  800ec6:	ff 45 fc             	incl   -0x4(%ebp)
  800ec9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed5:	85 c0                	test   %eax,%eax
  800ed7:	75 c9                	jne    800ea2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ed9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ede:	c9                   	leave  
  800edf:	c3                   	ret    

00800ee0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	8b 45 10             	mov    0x10(%ebp),%eax
  800eec:	01 d0                	add    %edx,%eax
  800eee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ef1:	eb 15                	jmp    800f08 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	0f b6 d0             	movzbl %al,%edx
  800efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efe:	0f b6 c0             	movzbl %al,%eax
  800f01:	39 c2                	cmp    %eax,%edx
  800f03:	74 0d                	je     800f12 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f05:	ff 45 08             	incl   0x8(%ebp)
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f0e:	72 e3                	jb     800ef3 <memfind+0x13>
  800f10:	eb 01                	jmp    800f13 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f12:	90                   	nop
	return (void *) s;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f25:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f2c:	eb 03                	jmp    800f31 <strtol+0x19>
		s++;
  800f2e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	3c 20                	cmp    $0x20,%al
  800f38:	74 f4                	je     800f2e <strtol+0x16>
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	3c 09                	cmp    $0x9,%al
  800f41:	74 eb                	je     800f2e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	3c 2b                	cmp    $0x2b,%al
  800f4a:	75 05                	jne    800f51 <strtol+0x39>
		s++;
  800f4c:	ff 45 08             	incl   0x8(%ebp)
  800f4f:	eb 13                	jmp    800f64 <strtol+0x4c>
	else if (*s == '-')
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	3c 2d                	cmp    $0x2d,%al
  800f58:	75 0a                	jne    800f64 <strtol+0x4c>
		s++, neg = 1;
  800f5a:	ff 45 08             	incl   0x8(%ebp)
  800f5d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f64:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f68:	74 06                	je     800f70 <strtol+0x58>
  800f6a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f6e:	75 20                	jne    800f90 <strtol+0x78>
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	3c 30                	cmp    $0x30,%al
  800f77:	75 17                	jne    800f90 <strtol+0x78>
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	40                   	inc    %eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	3c 78                	cmp    $0x78,%al
  800f81:	75 0d                	jne    800f90 <strtol+0x78>
		s += 2, base = 16;
  800f83:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f87:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f8e:	eb 28                	jmp    800fb8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f94:	75 15                	jne    800fab <strtol+0x93>
  800f96:	8b 45 08             	mov    0x8(%ebp),%eax
  800f99:	8a 00                	mov    (%eax),%al
  800f9b:	3c 30                	cmp    $0x30,%al
  800f9d:	75 0c                	jne    800fab <strtol+0x93>
		s++, base = 8;
  800f9f:	ff 45 08             	incl   0x8(%ebp)
  800fa2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fa9:	eb 0d                	jmp    800fb8 <strtol+0xa0>
	else if (base == 0)
  800fab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800faf:	75 07                	jne    800fb8 <strtol+0xa0>
		base = 10;
  800fb1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	3c 2f                	cmp    $0x2f,%al
  800fbf:	7e 19                	jle    800fda <strtol+0xc2>
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	3c 39                	cmp    $0x39,%al
  800fc8:	7f 10                	jg     800fda <strtol+0xc2>
			dig = *s - '0';
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	0f be c0             	movsbl %al,%eax
  800fd2:	83 e8 30             	sub    $0x30,%eax
  800fd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd8:	eb 42                	jmp    80101c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	3c 60                	cmp    $0x60,%al
  800fe1:	7e 19                	jle    800ffc <strtol+0xe4>
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	3c 7a                	cmp    $0x7a,%al
  800fea:	7f 10                	jg     800ffc <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	0f be c0             	movsbl %al,%eax
  800ff4:	83 e8 57             	sub    $0x57,%eax
  800ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ffa:	eb 20                	jmp    80101c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 40                	cmp    $0x40,%al
  801003:	7e 39                	jle    80103e <strtol+0x126>
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	3c 5a                	cmp    $0x5a,%al
  80100c:	7f 30                	jg     80103e <strtol+0x126>
			dig = *s - 'A' + 10;
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	0f be c0             	movsbl %al,%eax
  801016:	83 e8 37             	sub    $0x37,%eax
  801019:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80101c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801022:	7d 19                	jge    80103d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801024:	ff 45 08             	incl   0x8(%ebp)
  801027:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80102e:	89 c2                	mov    %eax,%edx
  801030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801033:	01 d0                	add    %edx,%eax
  801035:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801038:	e9 7b ff ff ff       	jmp    800fb8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80103d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80103e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801042:	74 08                	je     80104c <strtol+0x134>
		*endptr = (char *) s;
  801044:	8b 45 0c             	mov    0xc(%ebp),%eax
  801047:	8b 55 08             	mov    0x8(%ebp),%edx
  80104a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80104c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801050:	74 07                	je     801059 <strtol+0x141>
  801052:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801055:	f7 d8                	neg    %eax
  801057:	eb 03                	jmp    80105c <strtol+0x144>
  801059:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80105c:	c9                   	leave  
  80105d:	c3                   	ret    

0080105e <ltostr>:

void
ltostr(long value, char *str)
{
  80105e:	55                   	push   %ebp
  80105f:	89 e5                	mov    %esp,%ebp
  801061:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801064:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80106b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801072:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801076:	79 13                	jns    80108b <ltostr+0x2d>
	{
		neg = 1;
  801078:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80107f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801082:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801085:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801088:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801093:	99                   	cltd   
  801094:	f7 f9                	idiv   %ecx
  801096:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801099:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109c:	8d 50 01             	lea    0x1(%eax),%edx
  80109f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a2:	89 c2                	mov    %eax,%edx
  8010a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a7:	01 d0                	add    %edx,%eax
  8010a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010ac:	83 c2 30             	add    $0x30,%edx
  8010af:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010b9:	f7 e9                	imul   %ecx
  8010bb:	c1 fa 02             	sar    $0x2,%edx
  8010be:	89 c8                	mov    %ecx,%eax
  8010c0:	c1 f8 1f             	sar    $0x1f,%eax
  8010c3:	29 c2                	sub    %eax,%edx
  8010c5:	89 d0                	mov    %edx,%eax
  8010c7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010cd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010d2:	f7 e9                	imul   %ecx
  8010d4:	c1 fa 02             	sar    $0x2,%edx
  8010d7:	89 c8                	mov    %ecx,%eax
  8010d9:	c1 f8 1f             	sar    $0x1f,%eax
  8010dc:	29 c2                	sub    %eax,%edx
  8010de:	89 d0                	mov    %edx,%eax
  8010e0:	c1 e0 02             	shl    $0x2,%eax
  8010e3:	01 d0                	add    %edx,%eax
  8010e5:	01 c0                	add    %eax,%eax
  8010e7:	29 c1                	sub    %eax,%ecx
  8010e9:	89 ca                	mov    %ecx,%edx
  8010eb:	85 d2                	test   %edx,%edx
  8010ed:	75 9c                	jne    80108b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f9:	48                   	dec    %eax
  8010fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801101:	74 3d                	je     801140 <ltostr+0xe2>
		start = 1 ;
  801103:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80110a:	eb 34                	jmp    801140 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80110c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801112:	01 d0                	add    %edx,%eax
  801114:	8a 00                	mov    (%eax),%al
  801116:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801119:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111f:	01 c2                	add    %eax,%edx
  801121:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	01 c8                	add    %ecx,%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80112d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801130:	8b 45 0c             	mov    0xc(%ebp),%eax
  801133:	01 c2                	add    %eax,%edx
  801135:	8a 45 eb             	mov    -0x15(%ebp),%al
  801138:	88 02                	mov    %al,(%edx)
		start++ ;
  80113a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80113d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801143:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801146:	7c c4                	jl     80110c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801148:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80114b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114e:	01 d0                	add    %edx,%eax
  801150:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801153:	90                   	nop
  801154:	c9                   	leave  
  801155:	c3                   	ret    

00801156 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80115c:	ff 75 08             	pushl  0x8(%ebp)
  80115f:	e8 54 fa ff ff       	call   800bb8 <strlen>
  801164:	83 c4 04             	add    $0x4,%esp
  801167:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80116a:	ff 75 0c             	pushl  0xc(%ebp)
  80116d:	e8 46 fa ff ff       	call   800bb8 <strlen>
  801172:	83 c4 04             	add    $0x4,%esp
  801175:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801178:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80117f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801186:	eb 17                	jmp    80119f <strcconcat+0x49>
		final[s] = str1[s] ;
  801188:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80118b:	8b 45 10             	mov    0x10(%ebp),%eax
  80118e:	01 c2                	add    %eax,%edx
  801190:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	01 c8                	add    %ecx,%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80119c:	ff 45 fc             	incl   -0x4(%ebp)
  80119f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011a5:	7c e1                	jl     801188 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011a7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011b5:	eb 1f                	jmp    8011d6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ba:	8d 50 01             	lea    0x1(%eax),%edx
  8011bd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011c0:	89 c2                	mov    %eax,%edx
  8011c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c5:	01 c2                	add    %eax,%edx
  8011c7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cd:	01 c8                	add    %ecx,%eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011d3:	ff 45 f8             	incl   -0x8(%ebp)
  8011d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011dc:	7c d9                	jl     8011b7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011de:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e4:	01 d0                	add    %edx,%eax
  8011e6:	c6 00 00             	movb   $0x0,(%eax)
}
  8011e9:	90                   	nop
  8011ea:	c9                   	leave  
  8011eb:	c3                   	ret    

008011ec <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011ec:	55                   	push   %ebp
  8011ed:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011fb:	8b 00                	mov    (%eax),%eax
  8011fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801204:	8b 45 10             	mov    0x10(%ebp),%eax
  801207:	01 d0                	add    %edx,%eax
  801209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120f:	eb 0c                	jmp    80121d <strsplit+0x31>
			*string++ = 0;
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8d 50 01             	lea    0x1(%eax),%edx
  801217:	89 55 08             	mov    %edx,0x8(%ebp)
  80121a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	8a 00                	mov    (%eax),%al
  801222:	84 c0                	test   %al,%al
  801224:	74 18                	je     80123e <strsplit+0x52>
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	8a 00                	mov    (%eax),%al
  80122b:	0f be c0             	movsbl %al,%eax
  80122e:	50                   	push   %eax
  80122f:	ff 75 0c             	pushl  0xc(%ebp)
  801232:	e8 13 fb ff ff       	call   800d4a <strchr>
  801237:	83 c4 08             	add    $0x8,%esp
  80123a:	85 c0                	test   %eax,%eax
  80123c:	75 d3                	jne    801211 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	84 c0                	test   %al,%al
  801245:	74 5a                	je     8012a1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	83 f8 0f             	cmp    $0xf,%eax
  80124f:	75 07                	jne    801258 <strsplit+0x6c>
		{
			return 0;
  801251:	b8 00 00 00 00       	mov    $0x0,%eax
  801256:	eb 66                	jmp    8012be <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801258:	8b 45 14             	mov    0x14(%ebp),%eax
  80125b:	8b 00                	mov    (%eax),%eax
  80125d:	8d 48 01             	lea    0x1(%eax),%ecx
  801260:	8b 55 14             	mov    0x14(%ebp),%edx
  801263:	89 0a                	mov    %ecx,(%edx)
  801265:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80126c:	8b 45 10             	mov    0x10(%ebp),%eax
  80126f:	01 c2                	add    %eax,%edx
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801276:	eb 03                	jmp    80127b <strsplit+0x8f>
			string++;
  801278:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	8a 00                	mov    (%eax),%al
  801280:	84 c0                	test   %al,%al
  801282:	74 8b                	je     80120f <strsplit+0x23>
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	0f be c0             	movsbl %al,%eax
  80128c:	50                   	push   %eax
  80128d:	ff 75 0c             	pushl  0xc(%ebp)
  801290:	e8 b5 fa ff ff       	call   800d4a <strchr>
  801295:	83 c4 08             	add    $0x8,%esp
  801298:	85 c0                	test   %eax,%eax
  80129a:	74 dc                	je     801278 <strsplit+0x8c>
			string++;
	}
  80129c:	e9 6e ff ff ff       	jmp    80120f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012a1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a5:	8b 00                	mov    (%eax),%eax
  8012a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b1:	01 d0                	add    %edx,%eax
  8012b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012b9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012be:	c9                   	leave  
  8012bf:	c3                   	ret    

008012c0 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012c6:	a1 04 40 80 00       	mov    0x804004,%eax
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	74 1f                	je     8012ee <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012cf:	e8 1d 00 00 00       	call   8012f1 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012d4:	83 ec 0c             	sub    $0xc,%esp
  8012d7:	68 10 38 80 00       	push   $0x803810
  8012dc:	e8 55 f2 ff ff       	call   800536 <cprintf>
  8012e1:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012e4:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012eb:	00 00 00 
	}
}
  8012ee:	90                   	nop
  8012ef:	c9                   	leave  
  8012f0:	c3                   	ret    

008012f1 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  8012f7:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8012fe:	00 00 00 
  801301:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801308:	00 00 00 
  80130b:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801312:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801315:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80131c:	00 00 00 
  80131f:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801326:	00 00 00 
  801329:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801330:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801333:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80133a:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  80133d:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801347:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80134c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801351:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  801356:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  80135d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801360:	a1 20 41 80 00       	mov    0x804120,%eax
  801365:	0f af c2             	imul   %edx,%eax
  801368:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  80136b:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801372:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801375:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801378:	01 d0                	add    %edx,%eax
  80137a:	48                   	dec    %eax
  80137b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80137e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801381:	ba 00 00 00 00       	mov    $0x0,%edx
  801386:	f7 75 e8             	divl   -0x18(%ebp)
  801389:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80138c:	29 d0                	sub    %edx,%eax
  80138e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801391:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801394:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  80139b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80139e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8013a4:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8013aa:	83 ec 04             	sub    $0x4,%esp
  8013ad:	6a 06                	push   $0x6
  8013af:	50                   	push   %eax
  8013b0:	52                   	push   %edx
  8013b1:	e8 a1 05 00 00       	call   801957 <sys_allocate_chunk>
  8013b6:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013b9:	a1 20 41 80 00       	mov    0x804120,%eax
  8013be:	83 ec 0c             	sub    $0xc,%esp
  8013c1:	50                   	push   %eax
  8013c2:	e8 16 0c 00 00       	call   801fdd <initialize_MemBlocksList>
  8013c7:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  8013ca:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8013cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  8013d2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8013d6:	75 14                	jne    8013ec <initialize_dyn_block_system+0xfb>
  8013d8:	83 ec 04             	sub    $0x4,%esp
  8013db:	68 35 38 80 00       	push   $0x803835
  8013e0:	6a 2d                	push   $0x2d
  8013e2:	68 53 38 80 00       	push   $0x803853
  8013e7:	e8 96 ee ff ff       	call   800282 <_panic>
  8013ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013ef:	8b 00                	mov    (%eax),%eax
  8013f1:	85 c0                	test   %eax,%eax
  8013f3:	74 10                	je     801405 <initialize_dyn_block_system+0x114>
  8013f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013f8:	8b 00                	mov    (%eax),%eax
  8013fa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8013fd:	8b 52 04             	mov    0x4(%edx),%edx
  801400:	89 50 04             	mov    %edx,0x4(%eax)
  801403:	eb 0b                	jmp    801410 <initialize_dyn_block_system+0x11f>
  801405:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801408:	8b 40 04             	mov    0x4(%eax),%eax
  80140b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801410:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801413:	8b 40 04             	mov    0x4(%eax),%eax
  801416:	85 c0                	test   %eax,%eax
  801418:	74 0f                	je     801429 <initialize_dyn_block_system+0x138>
  80141a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80141d:	8b 40 04             	mov    0x4(%eax),%eax
  801420:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801423:	8b 12                	mov    (%edx),%edx
  801425:	89 10                	mov    %edx,(%eax)
  801427:	eb 0a                	jmp    801433 <initialize_dyn_block_system+0x142>
  801429:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80142c:	8b 00                	mov    (%eax),%eax
  80142e:	a3 48 41 80 00       	mov    %eax,0x804148
  801433:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801436:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80143c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80143f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801446:	a1 54 41 80 00       	mov    0x804154,%eax
  80144b:	48                   	dec    %eax
  80144c:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801451:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801454:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  80145b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80145e:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801465:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801469:	75 14                	jne    80147f <initialize_dyn_block_system+0x18e>
  80146b:	83 ec 04             	sub    $0x4,%esp
  80146e:	68 60 38 80 00       	push   $0x803860
  801473:	6a 30                	push   $0x30
  801475:	68 53 38 80 00       	push   $0x803853
  80147a:	e8 03 ee ff ff       	call   800282 <_panic>
  80147f:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  801485:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801488:	89 50 04             	mov    %edx,0x4(%eax)
  80148b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80148e:	8b 40 04             	mov    0x4(%eax),%eax
  801491:	85 c0                	test   %eax,%eax
  801493:	74 0c                	je     8014a1 <initialize_dyn_block_system+0x1b0>
  801495:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80149a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80149d:	89 10                	mov    %edx,(%eax)
  80149f:	eb 08                	jmp    8014a9 <initialize_dyn_block_system+0x1b8>
  8014a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014a4:	a3 38 41 80 00       	mov    %eax,0x804138
  8014a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014ac:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8014b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014ba:	a1 44 41 80 00       	mov    0x804144,%eax
  8014bf:	40                   	inc    %eax
  8014c0:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8014c5:	90                   	nop
  8014c6:	c9                   	leave  
  8014c7:	c3                   	ret    

008014c8 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014c8:	55                   	push   %ebp
  8014c9:	89 e5                	mov    %esp,%ebp
  8014cb:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014ce:	e8 ed fd ff ff       	call   8012c0 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014d7:	75 07                	jne    8014e0 <malloc+0x18>
  8014d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8014de:	eb 67                	jmp    801547 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  8014e0:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ed:	01 d0                	add    %edx,%eax
  8014ef:	48                   	dec    %eax
  8014f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8014fb:	f7 75 f4             	divl   -0xc(%ebp)
  8014fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801501:	29 d0                	sub    %edx,%eax
  801503:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801506:	e8 1a 08 00 00       	call   801d25 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80150b:	85 c0                	test   %eax,%eax
  80150d:	74 33                	je     801542 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  80150f:	83 ec 0c             	sub    $0xc,%esp
  801512:	ff 75 08             	pushl  0x8(%ebp)
  801515:	e8 0c 0e 00 00       	call   802326 <alloc_block_FF>
  80151a:	83 c4 10             	add    $0x10,%esp
  80151d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801520:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801524:	74 1c                	je     801542 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801526:	83 ec 0c             	sub    $0xc,%esp
  801529:	ff 75 ec             	pushl  -0x14(%ebp)
  80152c:	e8 07 0c 00 00       	call   802138 <insert_sorted_allocList>
  801531:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801534:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801537:	8b 40 08             	mov    0x8(%eax),%eax
  80153a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  80153d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801540:	eb 05                	jmp    801547 <malloc+0x7f>
		}
	}
	return NULL;
  801542:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801547:	c9                   	leave  
  801548:	c3                   	ret    

00801549 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
  80154c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  80154f:	8b 45 08             	mov    0x8(%ebp),%eax
  801552:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801555:	83 ec 08             	sub    $0x8,%esp
  801558:	ff 75 f4             	pushl  -0xc(%ebp)
  80155b:	68 40 40 80 00       	push   $0x804040
  801560:	e8 5b 0b 00 00       	call   8020c0 <find_block>
  801565:	83 c4 10             	add    $0x10,%esp
  801568:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  80156b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156e:	8b 40 0c             	mov    0xc(%eax),%eax
  801571:	83 ec 08             	sub    $0x8,%esp
  801574:	50                   	push   %eax
  801575:	ff 75 f4             	pushl  -0xc(%ebp)
  801578:	e8 a2 03 00 00       	call   80191f <sys_free_user_mem>
  80157d:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801580:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801584:	75 14                	jne    80159a <free+0x51>
  801586:	83 ec 04             	sub    $0x4,%esp
  801589:	68 35 38 80 00       	push   $0x803835
  80158e:	6a 76                	push   $0x76
  801590:	68 53 38 80 00       	push   $0x803853
  801595:	e8 e8 ec ff ff       	call   800282 <_panic>
  80159a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159d:	8b 00                	mov    (%eax),%eax
  80159f:	85 c0                	test   %eax,%eax
  8015a1:	74 10                	je     8015b3 <free+0x6a>
  8015a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a6:	8b 00                	mov    (%eax),%eax
  8015a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015ab:	8b 52 04             	mov    0x4(%edx),%edx
  8015ae:	89 50 04             	mov    %edx,0x4(%eax)
  8015b1:	eb 0b                	jmp    8015be <free+0x75>
  8015b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b6:	8b 40 04             	mov    0x4(%eax),%eax
  8015b9:	a3 44 40 80 00       	mov    %eax,0x804044
  8015be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c1:	8b 40 04             	mov    0x4(%eax),%eax
  8015c4:	85 c0                	test   %eax,%eax
  8015c6:	74 0f                	je     8015d7 <free+0x8e>
  8015c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cb:	8b 40 04             	mov    0x4(%eax),%eax
  8015ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015d1:	8b 12                	mov    (%edx),%edx
  8015d3:	89 10                	mov    %edx,(%eax)
  8015d5:	eb 0a                	jmp    8015e1 <free+0x98>
  8015d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015da:	8b 00                	mov    (%eax),%eax
  8015dc:	a3 40 40 80 00       	mov    %eax,0x804040
  8015e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015f4:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015f9:	48                   	dec    %eax
  8015fa:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  8015ff:	83 ec 0c             	sub    $0xc,%esp
  801602:	ff 75 f0             	pushl  -0x10(%ebp)
  801605:	e8 0b 14 00 00       	call   802a15 <insert_sorted_with_merge_freeList>
  80160a:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80160d:	90                   	nop
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    

00801610 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
  801613:	83 ec 28             	sub    $0x28,%esp
  801616:	8b 45 10             	mov    0x10(%ebp),%eax
  801619:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80161c:	e8 9f fc ff ff       	call   8012c0 <InitializeUHeap>
	if (size == 0) return NULL ;
  801621:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801625:	75 0a                	jne    801631 <smalloc+0x21>
  801627:	b8 00 00 00 00       	mov    $0x0,%eax
  80162c:	e9 8d 00 00 00       	jmp    8016be <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801631:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801638:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163e:	01 d0                	add    %edx,%eax
  801640:	48                   	dec    %eax
  801641:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801644:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801647:	ba 00 00 00 00       	mov    $0x0,%edx
  80164c:	f7 75 f4             	divl   -0xc(%ebp)
  80164f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801652:	29 d0                	sub    %edx,%eax
  801654:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801657:	e8 c9 06 00 00       	call   801d25 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80165c:	85 c0                	test   %eax,%eax
  80165e:	74 59                	je     8016b9 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801660:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801667:	83 ec 0c             	sub    $0xc,%esp
  80166a:	ff 75 0c             	pushl  0xc(%ebp)
  80166d:	e8 b4 0c 00 00       	call   802326 <alloc_block_FF>
  801672:	83 c4 10             	add    $0x10,%esp
  801675:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801678:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80167c:	75 07                	jne    801685 <smalloc+0x75>
			{
				return NULL;
  80167e:	b8 00 00 00 00       	mov    $0x0,%eax
  801683:	eb 39                	jmp    8016be <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801685:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801688:	8b 40 08             	mov    0x8(%eax),%eax
  80168b:	89 c2                	mov    %eax,%edx
  80168d:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801691:	52                   	push   %edx
  801692:	50                   	push   %eax
  801693:	ff 75 0c             	pushl  0xc(%ebp)
  801696:	ff 75 08             	pushl  0x8(%ebp)
  801699:	e8 0c 04 00 00       	call   801aaa <sys_createSharedObject>
  80169e:	83 c4 10             	add    $0x10,%esp
  8016a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  8016a4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016a8:	78 08                	js     8016b2 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  8016aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ad:	8b 40 08             	mov    0x8(%eax),%eax
  8016b0:	eb 0c                	jmp    8016be <smalloc+0xae>
				}
				else
				{
					return NULL;
  8016b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b7:	eb 05                	jmp    8016be <smalloc+0xae>
				}
			}

		}
		return NULL;
  8016b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016be:	c9                   	leave  
  8016bf:	c3                   	ret    

008016c0 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016c6:	e8 f5 fb ff ff       	call   8012c0 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016cb:	83 ec 08             	sub    $0x8,%esp
  8016ce:	ff 75 0c             	pushl  0xc(%ebp)
  8016d1:	ff 75 08             	pushl  0x8(%ebp)
  8016d4:	e8 fb 03 00 00       	call   801ad4 <sys_getSizeOfSharedObject>
  8016d9:	83 c4 10             	add    $0x10,%esp
  8016dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  8016df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016e3:	75 07                	jne    8016ec <sget+0x2c>
	{
		return NULL;
  8016e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ea:	eb 64                	jmp    801750 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016ec:	e8 34 06 00 00       	call   801d25 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016f1:	85 c0                	test   %eax,%eax
  8016f3:	74 56                	je     80174b <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  8016f5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  8016fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ff:	83 ec 0c             	sub    $0xc,%esp
  801702:	50                   	push   %eax
  801703:	e8 1e 0c 00 00       	call   802326 <alloc_block_FF>
  801708:	83 c4 10             	add    $0x10,%esp
  80170b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  80170e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801712:	75 07                	jne    80171b <sget+0x5b>
		{
		return NULL;
  801714:	b8 00 00 00 00       	mov    $0x0,%eax
  801719:	eb 35                	jmp    801750 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  80171b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171e:	8b 40 08             	mov    0x8(%eax),%eax
  801721:	83 ec 04             	sub    $0x4,%esp
  801724:	50                   	push   %eax
  801725:	ff 75 0c             	pushl  0xc(%ebp)
  801728:	ff 75 08             	pushl  0x8(%ebp)
  80172b:	e8 c1 03 00 00       	call   801af1 <sys_getSharedObject>
  801730:	83 c4 10             	add    $0x10,%esp
  801733:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801736:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80173a:	78 08                	js     801744 <sget+0x84>
			{
				return (void*)v1->sva;
  80173c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173f:	8b 40 08             	mov    0x8(%eax),%eax
  801742:	eb 0c                	jmp    801750 <sget+0x90>
			}
			else
			{
				return NULL;
  801744:	b8 00 00 00 00       	mov    $0x0,%eax
  801749:	eb 05                	jmp    801750 <sget+0x90>
			}
		}
	}
  return NULL;
  80174b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801750:	c9                   	leave  
  801751:	c3                   	ret    

00801752 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
  801755:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801758:	e8 63 fb ff ff       	call   8012c0 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80175d:	83 ec 04             	sub    $0x4,%esp
  801760:	68 84 38 80 00       	push   $0x803884
  801765:	68 0e 01 00 00       	push   $0x10e
  80176a:	68 53 38 80 00       	push   $0x803853
  80176f:	e8 0e eb ff ff       	call   800282 <_panic>

00801774 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
  801777:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80177a:	83 ec 04             	sub    $0x4,%esp
  80177d:	68 ac 38 80 00       	push   $0x8038ac
  801782:	68 22 01 00 00       	push   $0x122
  801787:	68 53 38 80 00       	push   $0x803853
  80178c:	e8 f1 ea ff ff       	call   800282 <_panic>

00801791 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
  801794:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801797:	83 ec 04             	sub    $0x4,%esp
  80179a:	68 d0 38 80 00       	push   $0x8038d0
  80179f:	68 2d 01 00 00       	push   $0x12d
  8017a4:	68 53 38 80 00       	push   $0x803853
  8017a9:	e8 d4 ea ff ff       	call   800282 <_panic>

008017ae <shrink>:

}
void shrink(uint32 newSize)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
  8017b1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017b4:	83 ec 04             	sub    $0x4,%esp
  8017b7:	68 d0 38 80 00       	push   $0x8038d0
  8017bc:	68 32 01 00 00       	push   $0x132
  8017c1:	68 53 38 80 00       	push   $0x803853
  8017c6:	e8 b7 ea ff ff       	call   800282 <_panic>

008017cb <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017d1:	83 ec 04             	sub    $0x4,%esp
  8017d4:	68 d0 38 80 00       	push   $0x8038d0
  8017d9:	68 37 01 00 00       	push   $0x137
  8017de:	68 53 38 80 00       	push   $0x803853
  8017e3:	e8 9a ea ff ff       	call   800282 <_panic>

008017e8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
  8017eb:	57                   	push   %edi
  8017ec:	56                   	push   %esi
  8017ed:	53                   	push   %ebx
  8017ee:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017fd:	8b 7d 18             	mov    0x18(%ebp),%edi
  801800:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801803:	cd 30                	int    $0x30
  801805:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801808:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80180b:	83 c4 10             	add    $0x10,%esp
  80180e:	5b                   	pop    %ebx
  80180f:	5e                   	pop    %esi
  801810:	5f                   	pop    %edi
  801811:	5d                   	pop    %ebp
  801812:	c3                   	ret    

00801813 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
  801816:	83 ec 04             	sub    $0x4,%esp
  801819:	8b 45 10             	mov    0x10(%ebp),%eax
  80181c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80181f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	52                   	push   %edx
  80182b:	ff 75 0c             	pushl  0xc(%ebp)
  80182e:	50                   	push   %eax
  80182f:	6a 00                	push   $0x0
  801831:	e8 b2 ff ff ff       	call   8017e8 <syscall>
  801836:	83 c4 18             	add    $0x18,%esp
}
  801839:	90                   	nop
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <sys_cgetc>:

int
sys_cgetc(void)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 01                	push   $0x1
  80184b:	e8 98 ff ff ff       	call   8017e8 <syscall>
  801850:	83 c4 18             	add    $0x18,%esp
}
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801858:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185b:	8b 45 08             	mov    0x8(%ebp),%eax
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	52                   	push   %edx
  801865:	50                   	push   %eax
  801866:	6a 05                	push   $0x5
  801868:	e8 7b ff ff ff       	call   8017e8 <syscall>
  80186d:	83 c4 18             	add    $0x18,%esp
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	56                   	push   %esi
  801876:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801877:	8b 75 18             	mov    0x18(%ebp),%esi
  80187a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80187d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801880:	8b 55 0c             	mov    0xc(%ebp),%edx
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	56                   	push   %esi
  801887:	53                   	push   %ebx
  801888:	51                   	push   %ecx
  801889:	52                   	push   %edx
  80188a:	50                   	push   %eax
  80188b:	6a 06                	push   $0x6
  80188d:	e8 56 ff ff ff       	call   8017e8 <syscall>
  801892:	83 c4 18             	add    $0x18,%esp
}
  801895:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801898:	5b                   	pop    %ebx
  801899:	5e                   	pop    %esi
  80189a:	5d                   	pop    %ebp
  80189b:	c3                   	ret    

0080189c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80189f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	52                   	push   %edx
  8018ac:	50                   	push   %eax
  8018ad:	6a 07                	push   $0x7
  8018af:	e8 34 ff ff ff       	call   8017e8 <syscall>
  8018b4:	83 c4 18             	add    $0x18,%esp
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	ff 75 0c             	pushl  0xc(%ebp)
  8018c5:	ff 75 08             	pushl  0x8(%ebp)
  8018c8:	6a 08                	push   $0x8
  8018ca:	e8 19 ff ff ff       	call   8017e8 <syscall>
  8018cf:	83 c4 18             	add    $0x18,%esp
}
  8018d2:	c9                   	leave  
  8018d3:	c3                   	ret    

008018d4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 09                	push   $0x9
  8018e3:	e8 00 ff ff ff       	call   8017e8 <syscall>
  8018e8:	83 c4 18             	add    $0x18,%esp
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 0a                	push   $0xa
  8018fc:	e8 e7 fe ff ff       	call   8017e8 <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
}
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 0b                	push   $0xb
  801915:	e8 ce fe ff ff       	call   8017e8 <syscall>
  80191a:	83 c4 18             	add    $0x18,%esp
}
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	ff 75 0c             	pushl  0xc(%ebp)
  80192b:	ff 75 08             	pushl  0x8(%ebp)
  80192e:	6a 0f                	push   $0xf
  801930:	e8 b3 fe ff ff       	call   8017e8 <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
	return;
  801938:	90                   	nop
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	ff 75 0c             	pushl  0xc(%ebp)
  801947:	ff 75 08             	pushl  0x8(%ebp)
  80194a:	6a 10                	push   $0x10
  80194c:	e8 97 fe ff ff       	call   8017e8 <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
	return ;
  801954:	90                   	nop
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	ff 75 10             	pushl  0x10(%ebp)
  801961:	ff 75 0c             	pushl  0xc(%ebp)
  801964:	ff 75 08             	pushl  0x8(%ebp)
  801967:	6a 11                	push   $0x11
  801969:	e8 7a fe ff ff       	call   8017e8 <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
	return ;
  801971:	90                   	nop
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 0c                	push   $0xc
  801983:	e8 60 fe ff ff       	call   8017e8 <syscall>
  801988:	83 c4 18             	add    $0x18,%esp
}
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    

0080198d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	ff 75 08             	pushl  0x8(%ebp)
  80199b:	6a 0d                	push   $0xd
  80199d:	e8 46 fe ff ff       	call   8017e8 <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 0e                	push   $0xe
  8019b6:	e8 2d fe ff ff       	call   8017e8 <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp
}
  8019be:	90                   	nop
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 13                	push   $0x13
  8019d0:	e8 13 fe ff ff       	call   8017e8 <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
}
  8019d8:	90                   	nop
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 14                	push   $0x14
  8019ea:	e8 f9 fd ff ff       	call   8017e8 <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	90                   	nop
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
  8019f8:	83 ec 04             	sub    $0x4,%esp
  8019fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a01:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	50                   	push   %eax
  801a0e:	6a 15                	push   $0x15
  801a10:	e8 d3 fd ff ff       	call   8017e8 <syscall>
  801a15:	83 c4 18             	add    $0x18,%esp
}
  801a18:	90                   	nop
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 16                	push   $0x16
  801a2a:	e8 b9 fd ff ff       	call   8017e8 <syscall>
  801a2f:	83 c4 18             	add    $0x18,%esp
}
  801a32:	90                   	nop
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	ff 75 0c             	pushl  0xc(%ebp)
  801a44:	50                   	push   %eax
  801a45:	6a 17                	push   $0x17
  801a47:	e8 9c fd ff ff       	call   8017e8 <syscall>
  801a4c:	83 c4 18             	add    $0x18,%esp
}
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	52                   	push   %edx
  801a61:	50                   	push   %eax
  801a62:	6a 1a                	push   $0x1a
  801a64:	e8 7f fd ff ff       	call   8017e8 <syscall>
  801a69:	83 c4 18             	add    $0x18,%esp
}
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	52                   	push   %edx
  801a7e:	50                   	push   %eax
  801a7f:	6a 18                	push   $0x18
  801a81:	e8 62 fd ff ff       	call   8017e8 <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
}
  801a89:	90                   	nop
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	52                   	push   %edx
  801a9c:	50                   	push   %eax
  801a9d:	6a 19                	push   $0x19
  801a9f:	e8 44 fd ff ff       	call   8017e8 <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
}
  801aa7:	90                   	nop
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
  801aad:	83 ec 04             	sub    $0x4,%esp
  801ab0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ab6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ab9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801abd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac0:	6a 00                	push   $0x0
  801ac2:	51                   	push   %ecx
  801ac3:	52                   	push   %edx
  801ac4:	ff 75 0c             	pushl  0xc(%ebp)
  801ac7:	50                   	push   %eax
  801ac8:	6a 1b                	push   $0x1b
  801aca:	e8 19 fd ff ff       	call   8017e8 <syscall>
  801acf:	83 c4 18             	add    $0x18,%esp
}
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ad7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ada:	8b 45 08             	mov    0x8(%ebp),%eax
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	52                   	push   %edx
  801ae4:	50                   	push   %eax
  801ae5:	6a 1c                	push   $0x1c
  801ae7:	e8 fc fc ff ff       	call   8017e8 <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
}
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801af4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801af7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afa:	8b 45 08             	mov    0x8(%ebp),%eax
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	51                   	push   %ecx
  801b02:	52                   	push   %edx
  801b03:	50                   	push   %eax
  801b04:	6a 1d                	push   $0x1d
  801b06:	e8 dd fc ff ff       	call   8017e8 <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
}
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b16:	8b 45 08             	mov    0x8(%ebp),%eax
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	52                   	push   %edx
  801b20:	50                   	push   %eax
  801b21:	6a 1e                	push   $0x1e
  801b23:	e8 c0 fc ff ff       	call   8017e8 <syscall>
  801b28:	83 c4 18             	add    $0x18,%esp
}
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 1f                	push   $0x1f
  801b3c:	e8 a7 fc ff ff       	call   8017e8 <syscall>
  801b41:	83 c4 18             	add    $0x18,%esp
}
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b49:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4c:	6a 00                	push   $0x0
  801b4e:	ff 75 14             	pushl  0x14(%ebp)
  801b51:	ff 75 10             	pushl  0x10(%ebp)
  801b54:	ff 75 0c             	pushl  0xc(%ebp)
  801b57:	50                   	push   %eax
  801b58:	6a 20                	push   $0x20
  801b5a:	e8 89 fc ff ff       	call   8017e8 <syscall>
  801b5f:	83 c4 18             	add    $0x18,%esp
}
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	50                   	push   %eax
  801b73:	6a 21                	push   $0x21
  801b75:	e8 6e fc ff ff       	call   8017e8 <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
}
  801b7d:	90                   	nop
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b83:	8b 45 08             	mov    0x8(%ebp),%eax
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	50                   	push   %eax
  801b8f:	6a 22                	push   $0x22
  801b91:	e8 52 fc ff ff       	call   8017e8 <syscall>
  801b96:	83 c4 18             	add    $0x18,%esp
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 02                	push   $0x2
  801baa:	e8 39 fc ff ff       	call   8017e8 <syscall>
  801baf:	83 c4 18             	add    $0x18,%esp
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 03                	push   $0x3
  801bc3:	e8 20 fc ff ff       	call   8017e8 <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 04                	push   $0x4
  801bdc:	e8 07 fc ff ff       	call   8017e8 <syscall>
  801be1:	83 c4 18             	add    $0x18,%esp
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <sys_exit_env>:


void sys_exit_env(void)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 23                	push   $0x23
  801bf5:	e8 ee fb ff ff       	call   8017e8 <syscall>
  801bfa:	83 c4 18             	add    $0x18,%esp
}
  801bfd:	90                   	nop
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c06:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c09:	8d 50 04             	lea    0x4(%eax),%edx
  801c0c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	52                   	push   %edx
  801c16:	50                   	push   %eax
  801c17:	6a 24                	push   $0x24
  801c19:	e8 ca fb ff ff       	call   8017e8 <syscall>
  801c1e:	83 c4 18             	add    $0x18,%esp
	return result;
  801c21:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c24:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c27:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c2a:	89 01                	mov    %eax,(%ecx)
  801c2c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c32:	c9                   	leave  
  801c33:	c2 04 00             	ret    $0x4

00801c36 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	ff 75 10             	pushl  0x10(%ebp)
  801c40:	ff 75 0c             	pushl  0xc(%ebp)
  801c43:	ff 75 08             	pushl  0x8(%ebp)
  801c46:	6a 12                	push   $0x12
  801c48:	e8 9b fb ff ff       	call   8017e8 <syscall>
  801c4d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c50:	90                   	nop
}
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 25                	push   $0x25
  801c62:	e8 81 fb ff ff       	call   8017e8 <syscall>
  801c67:	83 c4 18             	add    $0x18,%esp
}
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
  801c6f:	83 ec 04             	sub    $0x4,%esp
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c78:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	50                   	push   %eax
  801c85:	6a 26                	push   $0x26
  801c87:	e8 5c fb ff ff       	call   8017e8 <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8f:	90                   	nop
}
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <rsttst>:
void rsttst()
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 28                	push   $0x28
  801ca1:	e8 42 fb ff ff       	call   8017e8 <syscall>
  801ca6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca9:	90                   	nop
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
  801caf:	83 ec 04             	sub    $0x4,%esp
  801cb2:	8b 45 14             	mov    0x14(%ebp),%eax
  801cb5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cb8:	8b 55 18             	mov    0x18(%ebp),%edx
  801cbb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cbf:	52                   	push   %edx
  801cc0:	50                   	push   %eax
  801cc1:	ff 75 10             	pushl  0x10(%ebp)
  801cc4:	ff 75 0c             	pushl  0xc(%ebp)
  801cc7:	ff 75 08             	pushl  0x8(%ebp)
  801cca:	6a 27                	push   $0x27
  801ccc:	e8 17 fb ff ff       	call   8017e8 <syscall>
  801cd1:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd4:	90                   	nop
}
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <chktst>:
void chktst(uint32 n)
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	ff 75 08             	pushl  0x8(%ebp)
  801ce5:	6a 29                	push   $0x29
  801ce7:	e8 fc fa ff ff       	call   8017e8 <syscall>
  801cec:	83 c4 18             	add    $0x18,%esp
	return ;
  801cef:	90                   	nop
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <inctst>:

void inctst()
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 2a                	push   $0x2a
  801d01:	e8 e2 fa ff ff       	call   8017e8 <syscall>
  801d06:	83 c4 18             	add    $0x18,%esp
	return ;
  801d09:	90                   	nop
}
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <gettst>:
uint32 gettst()
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 2b                	push   $0x2b
  801d1b:	e8 c8 fa ff ff       	call   8017e8 <syscall>
  801d20:	83 c4 18             	add    $0x18,%esp
}
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
  801d28:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 2c                	push   $0x2c
  801d37:	e8 ac fa ff ff       	call   8017e8 <syscall>
  801d3c:	83 c4 18             	add    $0x18,%esp
  801d3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d42:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d46:	75 07                	jne    801d4f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d48:	b8 01 00 00 00       	mov    $0x1,%eax
  801d4d:	eb 05                	jmp    801d54 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
  801d59:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 2c                	push   $0x2c
  801d68:	e8 7b fa ff ff       	call   8017e8 <syscall>
  801d6d:	83 c4 18             	add    $0x18,%esp
  801d70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d73:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d77:	75 07                	jne    801d80 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d79:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7e:	eb 05                	jmp    801d85 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
  801d8a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 2c                	push   $0x2c
  801d99:	e8 4a fa ff ff       	call   8017e8 <syscall>
  801d9e:	83 c4 18             	add    $0x18,%esp
  801da1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801da4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801da8:	75 07                	jne    801db1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801daa:	b8 01 00 00 00       	mov    $0x1,%eax
  801daf:	eb 05                	jmp    801db6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801db1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  801dca:	e8 19 fa ff ff       	call   8017e8 <syscall>
  801dcf:	83 c4 18             	add    $0x18,%esp
  801dd2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dd5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dd9:	75 07                	jne    801de2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ddb:	b8 01 00 00 00       	mov    $0x1,%eax
  801de0:	eb 05                	jmp    801de7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801de2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	ff 75 08             	pushl  0x8(%ebp)
  801df7:	6a 2d                	push   $0x2d
  801df9:	e8 ea f9 ff ff       	call   8017e8 <syscall>
  801dfe:	83 c4 18             	add    $0x18,%esp
	return ;
  801e01:	90                   	nop
}
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
  801e07:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e08:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e0b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e11:	8b 45 08             	mov    0x8(%ebp),%eax
  801e14:	6a 00                	push   $0x0
  801e16:	53                   	push   %ebx
  801e17:	51                   	push   %ecx
  801e18:	52                   	push   %edx
  801e19:	50                   	push   %eax
  801e1a:	6a 2e                	push   $0x2e
  801e1c:	e8 c7 f9 ff ff       	call   8017e8 <syscall>
  801e21:	83 c4 18             	add    $0x18,%esp
}
  801e24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    

00801e29 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	52                   	push   %edx
  801e39:	50                   	push   %eax
  801e3a:	6a 2f                	push   $0x2f
  801e3c:	e8 a7 f9 ff ff       	call   8017e8 <syscall>
  801e41:	83 c4 18             	add    $0x18,%esp
}
  801e44:	c9                   	leave  
  801e45:	c3                   	ret    

00801e46 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e4c:	83 ec 0c             	sub    $0xc,%esp
  801e4f:	68 e0 38 80 00       	push   $0x8038e0
  801e54:	e8 dd e6 ff ff       	call   800536 <cprintf>
  801e59:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e5c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e63:	83 ec 0c             	sub    $0xc,%esp
  801e66:	68 0c 39 80 00       	push   $0x80390c
  801e6b:	e8 c6 e6 ff ff       	call   800536 <cprintf>
  801e70:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e73:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e77:	a1 38 41 80 00       	mov    0x804138,%eax
  801e7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e7f:	eb 56                	jmp    801ed7 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e81:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e85:	74 1c                	je     801ea3 <print_mem_block_lists+0x5d>
  801e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8a:	8b 50 08             	mov    0x8(%eax),%edx
  801e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e90:	8b 48 08             	mov    0x8(%eax),%ecx
  801e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e96:	8b 40 0c             	mov    0xc(%eax),%eax
  801e99:	01 c8                	add    %ecx,%eax
  801e9b:	39 c2                	cmp    %eax,%edx
  801e9d:	73 04                	jae    801ea3 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e9f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea6:	8b 50 08             	mov    0x8(%eax),%edx
  801ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eac:	8b 40 0c             	mov    0xc(%eax),%eax
  801eaf:	01 c2                	add    %eax,%edx
  801eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb4:	8b 40 08             	mov    0x8(%eax),%eax
  801eb7:	83 ec 04             	sub    $0x4,%esp
  801eba:	52                   	push   %edx
  801ebb:	50                   	push   %eax
  801ebc:	68 21 39 80 00       	push   $0x803921
  801ec1:	e8 70 e6 ff ff       	call   800536 <cprintf>
  801ec6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ecf:	a1 40 41 80 00       	mov    0x804140,%eax
  801ed4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ed7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801edb:	74 07                	je     801ee4 <print_mem_block_lists+0x9e>
  801edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee0:	8b 00                	mov    (%eax),%eax
  801ee2:	eb 05                	jmp    801ee9 <print_mem_block_lists+0xa3>
  801ee4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee9:	a3 40 41 80 00       	mov    %eax,0x804140
  801eee:	a1 40 41 80 00       	mov    0x804140,%eax
  801ef3:	85 c0                	test   %eax,%eax
  801ef5:	75 8a                	jne    801e81 <print_mem_block_lists+0x3b>
  801ef7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801efb:	75 84                	jne    801e81 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801efd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f01:	75 10                	jne    801f13 <print_mem_block_lists+0xcd>
  801f03:	83 ec 0c             	sub    $0xc,%esp
  801f06:	68 30 39 80 00       	push   $0x803930
  801f0b:	e8 26 e6 ff ff       	call   800536 <cprintf>
  801f10:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f13:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f1a:	83 ec 0c             	sub    $0xc,%esp
  801f1d:	68 54 39 80 00       	push   $0x803954
  801f22:	e8 0f e6 ff ff       	call   800536 <cprintf>
  801f27:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f2a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f2e:	a1 40 40 80 00       	mov    0x804040,%eax
  801f33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f36:	eb 56                	jmp    801f8e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f3c:	74 1c                	je     801f5a <print_mem_block_lists+0x114>
  801f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f41:	8b 50 08             	mov    0x8(%eax),%edx
  801f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f47:	8b 48 08             	mov    0x8(%eax),%ecx
  801f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f4d:	8b 40 0c             	mov    0xc(%eax),%eax
  801f50:	01 c8                	add    %ecx,%eax
  801f52:	39 c2                	cmp    %eax,%edx
  801f54:	73 04                	jae    801f5a <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f56:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5d:	8b 50 08             	mov    0x8(%eax),%edx
  801f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f63:	8b 40 0c             	mov    0xc(%eax),%eax
  801f66:	01 c2                	add    %eax,%edx
  801f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6b:	8b 40 08             	mov    0x8(%eax),%eax
  801f6e:	83 ec 04             	sub    $0x4,%esp
  801f71:	52                   	push   %edx
  801f72:	50                   	push   %eax
  801f73:	68 21 39 80 00       	push   $0x803921
  801f78:	e8 b9 e5 ff ff       	call   800536 <cprintf>
  801f7d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f83:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f86:	a1 48 40 80 00       	mov    0x804048,%eax
  801f8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f92:	74 07                	je     801f9b <print_mem_block_lists+0x155>
  801f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f97:	8b 00                	mov    (%eax),%eax
  801f99:	eb 05                	jmp    801fa0 <print_mem_block_lists+0x15a>
  801f9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa0:	a3 48 40 80 00       	mov    %eax,0x804048
  801fa5:	a1 48 40 80 00       	mov    0x804048,%eax
  801faa:	85 c0                	test   %eax,%eax
  801fac:	75 8a                	jne    801f38 <print_mem_block_lists+0xf2>
  801fae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fb2:	75 84                	jne    801f38 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fb4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fb8:	75 10                	jne    801fca <print_mem_block_lists+0x184>
  801fba:	83 ec 0c             	sub    $0xc,%esp
  801fbd:	68 6c 39 80 00       	push   $0x80396c
  801fc2:	e8 6f e5 ff ff       	call   800536 <cprintf>
  801fc7:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fca:	83 ec 0c             	sub    $0xc,%esp
  801fcd:	68 e0 38 80 00       	push   $0x8038e0
  801fd2:	e8 5f e5 ff ff       	call   800536 <cprintf>
  801fd7:	83 c4 10             	add    $0x10,%esp

}
  801fda:	90                   	nop
  801fdb:	c9                   	leave  
  801fdc:	c3                   	ret    

00801fdd <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
  801fe0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  801fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  801fe9:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801ff0:	00 00 00 
  801ff3:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801ffa:	00 00 00 
  801ffd:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802004:	00 00 00 
	for(int i = 0; i<n;i++)
  802007:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80200e:	e9 9e 00 00 00       	jmp    8020b1 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802013:	a1 50 40 80 00       	mov    0x804050,%eax
  802018:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80201b:	c1 e2 04             	shl    $0x4,%edx
  80201e:	01 d0                	add    %edx,%eax
  802020:	85 c0                	test   %eax,%eax
  802022:	75 14                	jne    802038 <initialize_MemBlocksList+0x5b>
  802024:	83 ec 04             	sub    $0x4,%esp
  802027:	68 94 39 80 00       	push   $0x803994
  80202c:	6a 47                	push   $0x47
  80202e:	68 b7 39 80 00       	push   $0x8039b7
  802033:	e8 4a e2 ff ff       	call   800282 <_panic>
  802038:	a1 50 40 80 00       	mov    0x804050,%eax
  80203d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802040:	c1 e2 04             	shl    $0x4,%edx
  802043:	01 d0                	add    %edx,%eax
  802045:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80204b:	89 10                	mov    %edx,(%eax)
  80204d:	8b 00                	mov    (%eax),%eax
  80204f:	85 c0                	test   %eax,%eax
  802051:	74 18                	je     80206b <initialize_MemBlocksList+0x8e>
  802053:	a1 48 41 80 00       	mov    0x804148,%eax
  802058:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80205e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802061:	c1 e1 04             	shl    $0x4,%ecx
  802064:	01 ca                	add    %ecx,%edx
  802066:	89 50 04             	mov    %edx,0x4(%eax)
  802069:	eb 12                	jmp    80207d <initialize_MemBlocksList+0xa0>
  80206b:	a1 50 40 80 00       	mov    0x804050,%eax
  802070:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802073:	c1 e2 04             	shl    $0x4,%edx
  802076:	01 d0                	add    %edx,%eax
  802078:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80207d:	a1 50 40 80 00       	mov    0x804050,%eax
  802082:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802085:	c1 e2 04             	shl    $0x4,%edx
  802088:	01 d0                	add    %edx,%eax
  80208a:	a3 48 41 80 00       	mov    %eax,0x804148
  80208f:	a1 50 40 80 00       	mov    0x804050,%eax
  802094:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802097:	c1 e2 04             	shl    $0x4,%edx
  80209a:	01 d0                	add    %edx,%eax
  80209c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020a3:	a1 54 41 80 00       	mov    0x804154,%eax
  8020a8:	40                   	inc    %eax
  8020a9:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8020ae:	ff 45 f4             	incl   -0xc(%ebp)
  8020b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8020b7:	0f 82 56 ff ff ff    	jb     802013 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8020bd:	90                   	nop
  8020be:	c9                   	leave  
  8020bf:	c3                   	ret    

008020c0 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
  8020c3:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  8020c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  8020cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8020d3:	a1 40 40 80 00       	mov    0x804040,%eax
  8020d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020db:	eb 23                	jmp    802100 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  8020dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020e0:	8b 40 08             	mov    0x8(%eax),%eax
  8020e3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8020e6:	75 09                	jne    8020f1 <find_block+0x31>
		{
			found = 1;
  8020e8:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  8020ef:	eb 35                	jmp    802126 <find_block+0x66>
		}
		else
		{
			found = 0;
  8020f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8020f8:	a1 48 40 80 00       	mov    0x804048,%eax
  8020fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802100:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802104:	74 07                	je     80210d <find_block+0x4d>
  802106:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802109:	8b 00                	mov    (%eax),%eax
  80210b:	eb 05                	jmp    802112 <find_block+0x52>
  80210d:	b8 00 00 00 00       	mov    $0x0,%eax
  802112:	a3 48 40 80 00       	mov    %eax,0x804048
  802117:	a1 48 40 80 00       	mov    0x804048,%eax
  80211c:	85 c0                	test   %eax,%eax
  80211e:	75 bd                	jne    8020dd <find_block+0x1d>
  802120:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802124:	75 b7                	jne    8020dd <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802126:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  80212a:	75 05                	jne    802131 <find_block+0x71>
	{
		return blk;
  80212c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80212f:	eb 05                	jmp    802136 <find_block+0x76>
	}
	else
	{
		return NULL;
  802131:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802136:	c9                   	leave  
  802137:	c3                   	ret    

00802138 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
  80213b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802144:	a1 40 40 80 00       	mov    0x804040,%eax
  802149:	85 c0                	test   %eax,%eax
  80214b:	74 12                	je     80215f <insert_sorted_allocList+0x27>
  80214d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802150:	8b 50 08             	mov    0x8(%eax),%edx
  802153:	a1 40 40 80 00       	mov    0x804040,%eax
  802158:	8b 40 08             	mov    0x8(%eax),%eax
  80215b:	39 c2                	cmp    %eax,%edx
  80215d:	73 65                	jae    8021c4 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  80215f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802163:	75 14                	jne    802179 <insert_sorted_allocList+0x41>
  802165:	83 ec 04             	sub    $0x4,%esp
  802168:	68 94 39 80 00       	push   $0x803994
  80216d:	6a 7b                	push   $0x7b
  80216f:	68 b7 39 80 00       	push   $0x8039b7
  802174:	e8 09 e1 ff ff       	call   800282 <_panic>
  802179:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80217f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802182:	89 10                	mov    %edx,(%eax)
  802184:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802187:	8b 00                	mov    (%eax),%eax
  802189:	85 c0                	test   %eax,%eax
  80218b:	74 0d                	je     80219a <insert_sorted_allocList+0x62>
  80218d:	a1 40 40 80 00       	mov    0x804040,%eax
  802192:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802195:	89 50 04             	mov    %edx,0x4(%eax)
  802198:	eb 08                	jmp    8021a2 <insert_sorted_allocList+0x6a>
  80219a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219d:	a3 44 40 80 00       	mov    %eax,0x804044
  8021a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a5:	a3 40 40 80 00       	mov    %eax,0x804040
  8021aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021b4:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021b9:	40                   	inc    %eax
  8021ba:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8021bf:	e9 5f 01 00 00       	jmp    802323 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8021c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c7:	8b 50 08             	mov    0x8(%eax),%edx
  8021ca:	a1 44 40 80 00       	mov    0x804044,%eax
  8021cf:	8b 40 08             	mov    0x8(%eax),%eax
  8021d2:	39 c2                	cmp    %eax,%edx
  8021d4:	76 65                	jbe    80223b <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  8021d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021da:	75 14                	jne    8021f0 <insert_sorted_allocList+0xb8>
  8021dc:	83 ec 04             	sub    $0x4,%esp
  8021df:	68 d0 39 80 00       	push   $0x8039d0
  8021e4:	6a 7f                	push   $0x7f
  8021e6:	68 b7 39 80 00       	push   $0x8039b7
  8021eb:	e8 92 e0 ff ff       	call   800282 <_panic>
  8021f0:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f9:	89 50 04             	mov    %edx,0x4(%eax)
  8021fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ff:	8b 40 04             	mov    0x4(%eax),%eax
  802202:	85 c0                	test   %eax,%eax
  802204:	74 0c                	je     802212 <insert_sorted_allocList+0xda>
  802206:	a1 44 40 80 00       	mov    0x804044,%eax
  80220b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80220e:	89 10                	mov    %edx,(%eax)
  802210:	eb 08                	jmp    80221a <insert_sorted_allocList+0xe2>
  802212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802215:	a3 40 40 80 00       	mov    %eax,0x804040
  80221a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221d:	a3 44 40 80 00       	mov    %eax,0x804044
  802222:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802225:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80222b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802230:	40                   	inc    %eax
  802231:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802236:	e9 e8 00 00 00       	jmp    802323 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  80223b:	a1 40 40 80 00       	mov    0x804040,%eax
  802240:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802243:	e9 ab 00 00 00       	jmp    8022f3 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224b:	8b 00                	mov    (%eax),%eax
  80224d:	85 c0                	test   %eax,%eax
  80224f:	0f 84 96 00 00 00    	je     8022eb <insert_sorted_allocList+0x1b3>
  802255:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802258:	8b 50 08             	mov    0x8(%eax),%edx
  80225b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225e:	8b 40 08             	mov    0x8(%eax),%eax
  802261:	39 c2                	cmp    %eax,%edx
  802263:	0f 86 82 00 00 00    	jbe    8022eb <insert_sorted_allocList+0x1b3>
  802269:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226c:	8b 50 08             	mov    0x8(%eax),%edx
  80226f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802272:	8b 00                	mov    (%eax),%eax
  802274:	8b 40 08             	mov    0x8(%eax),%eax
  802277:	39 c2                	cmp    %eax,%edx
  802279:	73 70                	jae    8022eb <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  80227b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80227f:	74 06                	je     802287 <insert_sorted_allocList+0x14f>
  802281:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802285:	75 17                	jne    80229e <insert_sorted_allocList+0x166>
  802287:	83 ec 04             	sub    $0x4,%esp
  80228a:	68 f4 39 80 00       	push   $0x8039f4
  80228f:	68 87 00 00 00       	push   $0x87
  802294:	68 b7 39 80 00       	push   $0x8039b7
  802299:	e8 e4 df ff ff       	call   800282 <_panic>
  80229e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a1:	8b 10                	mov    (%eax),%edx
  8022a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a6:	89 10                	mov    %edx,(%eax)
  8022a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ab:	8b 00                	mov    (%eax),%eax
  8022ad:	85 c0                	test   %eax,%eax
  8022af:	74 0b                	je     8022bc <insert_sorted_allocList+0x184>
  8022b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b4:	8b 00                	mov    (%eax),%eax
  8022b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022b9:	89 50 04             	mov    %edx,0x4(%eax)
  8022bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022c2:	89 10                	mov    %edx,(%eax)
  8022c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ca:	89 50 04             	mov    %edx,0x4(%eax)
  8022cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d0:	8b 00                	mov    (%eax),%eax
  8022d2:	85 c0                	test   %eax,%eax
  8022d4:	75 08                	jne    8022de <insert_sorted_allocList+0x1a6>
  8022d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d9:	a3 44 40 80 00       	mov    %eax,0x804044
  8022de:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022e3:	40                   	inc    %eax
  8022e4:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8022e9:	eb 38                	jmp    802323 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8022eb:	a1 48 40 80 00       	mov    0x804048,%eax
  8022f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f7:	74 07                	je     802300 <insert_sorted_allocList+0x1c8>
  8022f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fc:	8b 00                	mov    (%eax),%eax
  8022fe:	eb 05                	jmp    802305 <insert_sorted_allocList+0x1cd>
  802300:	b8 00 00 00 00       	mov    $0x0,%eax
  802305:	a3 48 40 80 00       	mov    %eax,0x804048
  80230a:	a1 48 40 80 00       	mov    0x804048,%eax
  80230f:	85 c0                	test   %eax,%eax
  802311:	0f 85 31 ff ff ff    	jne    802248 <insert_sorted_allocList+0x110>
  802317:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231b:	0f 85 27 ff ff ff    	jne    802248 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802321:	eb 00                	jmp    802323 <insert_sorted_allocList+0x1eb>
  802323:	90                   	nop
  802324:	c9                   	leave  
  802325:	c3                   	ret    

00802326 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802326:	55                   	push   %ebp
  802327:	89 e5                	mov    %esp,%ebp
  802329:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  80232c:	8b 45 08             	mov    0x8(%ebp),%eax
  80232f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802332:	a1 48 41 80 00       	mov    0x804148,%eax
  802337:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80233a:	a1 38 41 80 00       	mov    0x804138,%eax
  80233f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802342:	e9 77 01 00 00       	jmp    8024be <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234a:	8b 40 0c             	mov    0xc(%eax),%eax
  80234d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802350:	0f 85 8a 00 00 00    	jne    8023e0 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802356:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80235a:	75 17                	jne    802373 <alloc_block_FF+0x4d>
  80235c:	83 ec 04             	sub    $0x4,%esp
  80235f:	68 28 3a 80 00       	push   $0x803a28
  802364:	68 9e 00 00 00       	push   $0x9e
  802369:	68 b7 39 80 00       	push   $0x8039b7
  80236e:	e8 0f df ff ff       	call   800282 <_panic>
  802373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802376:	8b 00                	mov    (%eax),%eax
  802378:	85 c0                	test   %eax,%eax
  80237a:	74 10                	je     80238c <alloc_block_FF+0x66>
  80237c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237f:	8b 00                	mov    (%eax),%eax
  802381:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802384:	8b 52 04             	mov    0x4(%edx),%edx
  802387:	89 50 04             	mov    %edx,0x4(%eax)
  80238a:	eb 0b                	jmp    802397 <alloc_block_FF+0x71>
  80238c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238f:	8b 40 04             	mov    0x4(%eax),%eax
  802392:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239a:	8b 40 04             	mov    0x4(%eax),%eax
  80239d:	85 c0                	test   %eax,%eax
  80239f:	74 0f                	je     8023b0 <alloc_block_FF+0x8a>
  8023a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a4:	8b 40 04             	mov    0x4(%eax),%eax
  8023a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023aa:	8b 12                	mov    (%edx),%edx
  8023ac:	89 10                	mov    %edx,(%eax)
  8023ae:	eb 0a                	jmp    8023ba <alloc_block_FF+0x94>
  8023b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b3:	8b 00                	mov    (%eax),%eax
  8023b5:	a3 38 41 80 00       	mov    %eax,0x804138
  8023ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023cd:	a1 44 41 80 00       	mov    0x804144,%eax
  8023d2:	48                   	dec    %eax
  8023d3:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8023d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023db:	e9 11 01 00 00       	jmp    8024f1 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  8023e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8023e9:	0f 86 c7 00 00 00    	jbe    8024b6 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8023ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023f3:	75 17                	jne    80240c <alloc_block_FF+0xe6>
  8023f5:	83 ec 04             	sub    $0x4,%esp
  8023f8:	68 28 3a 80 00       	push   $0x803a28
  8023fd:	68 a3 00 00 00       	push   $0xa3
  802402:	68 b7 39 80 00       	push   $0x8039b7
  802407:	e8 76 de ff ff       	call   800282 <_panic>
  80240c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80240f:	8b 00                	mov    (%eax),%eax
  802411:	85 c0                	test   %eax,%eax
  802413:	74 10                	je     802425 <alloc_block_FF+0xff>
  802415:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802418:	8b 00                	mov    (%eax),%eax
  80241a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80241d:	8b 52 04             	mov    0x4(%edx),%edx
  802420:	89 50 04             	mov    %edx,0x4(%eax)
  802423:	eb 0b                	jmp    802430 <alloc_block_FF+0x10a>
  802425:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802428:	8b 40 04             	mov    0x4(%eax),%eax
  80242b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802430:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802433:	8b 40 04             	mov    0x4(%eax),%eax
  802436:	85 c0                	test   %eax,%eax
  802438:	74 0f                	je     802449 <alloc_block_FF+0x123>
  80243a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80243d:	8b 40 04             	mov    0x4(%eax),%eax
  802440:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802443:	8b 12                	mov    (%edx),%edx
  802445:	89 10                	mov    %edx,(%eax)
  802447:	eb 0a                	jmp    802453 <alloc_block_FF+0x12d>
  802449:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80244c:	8b 00                	mov    (%eax),%eax
  80244e:	a3 48 41 80 00       	mov    %eax,0x804148
  802453:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802456:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80245c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80245f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802466:	a1 54 41 80 00       	mov    0x804154,%eax
  80246b:	48                   	dec    %eax
  80246c:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802471:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802474:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802477:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  80247a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247d:	8b 40 0c             	mov    0xc(%eax),%eax
  802480:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802483:	89 c2                	mov    %eax,%edx
  802485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802488:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  80248b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248e:	8b 40 08             	mov    0x8(%eax),%eax
  802491:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802497:	8b 50 08             	mov    0x8(%eax),%edx
  80249a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80249d:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a0:	01 c2                	add    %eax,%edx
  8024a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a5:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8024a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024ae:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8024b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b4:	eb 3b                	jmp    8024f1 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8024b6:	a1 40 41 80 00       	mov    0x804140,%eax
  8024bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c2:	74 07                	je     8024cb <alloc_block_FF+0x1a5>
  8024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c7:	8b 00                	mov    (%eax),%eax
  8024c9:	eb 05                	jmp    8024d0 <alloc_block_FF+0x1aa>
  8024cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d0:	a3 40 41 80 00       	mov    %eax,0x804140
  8024d5:	a1 40 41 80 00       	mov    0x804140,%eax
  8024da:	85 c0                	test   %eax,%eax
  8024dc:	0f 85 65 fe ff ff    	jne    802347 <alloc_block_FF+0x21>
  8024e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e6:	0f 85 5b fe ff ff    	jne    802347 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8024ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024f1:	c9                   	leave  
  8024f2:	c3                   	ret    

008024f3 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024f3:	55                   	push   %ebp
  8024f4:	89 e5                	mov    %esp,%ebp
  8024f6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  8024f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  8024ff:	a1 48 41 80 00       	mov    0x804148,%eax
  802504:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802507:	a1 44 41 80 00       	mov    0x804144,%eax
  80250c:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  80250f:	a1 38 41 80 00       	mov    0x804138,%eax
  802514:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802517:	e9 a1 00 00 00       	jmp    8025bd <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  80251c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251f:	8b 40 0c             	mov    0xc(%eax),%eax
  802522:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802525:	0f 85 8a 00 00 00    	jne    8025b5 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  80252b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80252f:	75 17                	jne    802548 <alloc_block_BF+0x55>
  802531:	83 ec 04             	sub    $0x4,%esp
  802534:	68 28 3a 80 00       	push   $0x803a28
  802539:	68 c2 00 00 00       	push   $0xc2
  80253e:	68 b7 39 80 00       	push   $0x8039b7
  802543:	e8 3a dd ff ff       	call   800282 <_panic>
  802548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254b:	8b 00                	mov    (%eax),%eax
  80254d:	85 c0                	test   %eax,%eax
  80254f:	74 10                	je     802561 <alloc_block_BF+0x6e>
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	8b 00                	mov    (%eax),%eax
  802556:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802559:	8b 52 04             	mov    0x4(%edx),%edx
  80255c:	89 50 04             	mov    %edx,0x4(%eax)
  80255f:	eb 0b                	jmp    80256c <alloc_block_BF+0x79>
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	8b 40 04             	mov    0x4(%eax),%eax
  802567:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80256c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256f:	8b 40 04             	mov    0x4(%eax),%eax
  802572:	85 c0                	test   %eax,%eax
  802574:	74 0f                	je     802585 <alloc_block_BF+0x92>
  802576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802579:	8b 40 04             	mov    0x4(%eax),%eax
  80257c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257f:	8b 12                	mov    (%edx),%edx
  802581:	89 10                	mov    %edx,(%eax)
  802583:	eb 0a                	jmp    80258f <alloc_block_BF+0x9c>
  802585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802588:	8b 00                	mov    (%eax),%eax
  80258a:	a3 38 41 80 00       	mov    %eax,0x804138
  80258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802592:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025a2:	a1 44 41 80 00       	mov    0x804144,%eax
  8025a7:	48                   	dec    %eax
  8025a8:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	e9 11 02 00 00       	jmp    8027c6 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025b5:	a1 40 41 80 00       	mov    0x804140,%eax
  8025ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c1:	74 07                	je     8025ca <alloc_block_BF+0xd7>
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	8b 00                	mov    (%eax),%eax
  8025c8:	eb 05                	jmp    8025cf <alloc_block_BF+0xdc>
  8025ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cf:	a3 40 41 80 00       	mov    %eax,0x804140
  8025d4:	a1 40 41 80 00       	mov    0x804140,%eax
  8025d9:	85 c0                	test   %eax,%eax
  8025db:	0f 85 3b ff ff ff    	jne    80251c <alloc_block_BF+0x29>
  8025e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e5:	0f 85 31 ff ff ff    	jne    80251c <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025eb:	a1 38 41 80 00       	mov    0x804138,%eax
  8025f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f3:	eb 27                	jmp    80261c <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  8025f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8025fe:	76 14                	jbe    802614 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802603:	8b 40 0c             	mov    0xc(%eax),%eax
  802606:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260c:	8b 40 08             	mov    0x8(%eax),%eax
  80260f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802612:	eb 2e                	jmp    802642 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802614:	a1 40 41 80 00       	mov    0x804140,%eax
  802619:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80261c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802620:	74 07                	je     802629 <alloc_block_BF+0x136>
  802622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802625:	8b 00                	mov    (%eax),%eax
  802627:	eb 05                	jmp    80262e <alloc_block_BF+0x13b>
  802629:	b8 00 00 00 00       	mov    $0x0,%eax
  80262e:	a3 40 41 80 00       	mov    %eax,0x804140
  802633:	a1 40 41 80 00       	mov    0x804140,%eax
  802638:	85 c0                	test   %eax,%eax
  80263a:	75 b9                	jne    8025f5 <alloc_block_BF+0x102>
  80263c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802640:	75 b3                	jne    8025f5 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802642:	a1 38 41 80 00       	mov    0x804138,%eax
  802647:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80264a:	eb 30                	jmp    80267c <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	8b 40 0c             	mov    0xc(%eax),%eax
  802652:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802655:	73 1d                	jae    802674 <alloc_block_BF+0x181>
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	8b 40 0c             	mov    0xc(%eax),%eax
  80265d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802660:	76 12                	jbe    802674 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802665:	8b 40 0c             	mov    0xc(%eax),%eax
  802668:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  80266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266e:	8b 40 08             	mov    0x8(%eax),%eax
  802671:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802674:	a1 40 41 80 00       	mov    0x804140,%eax
  802679:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80267c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802680:	74 07                	je     802689 <alloc_block_BF+0x196>
  802682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802685:	8b 00                	mov    (%eax),%eax
  802687:	eb 05                	jmp    80268e <alloc_block_BF+0x19b>
  802689:	b8 00 00 00 00       	mov    $0x0,%eax
  80268e:	a3 40 41 80 00       	mov    %eax,0x804140
  802693:	a1 40 41 80 00       	mov    0x804140,%eax
  802698:	85 c0                	test   %eax,%eax
  80269a:	75 b0                	jne    80264c <alloc_block_BF+0x159>
  80269c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a0:	75 aa                	jne    80264c <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026a2:	a1 38 41 80 00       	mov    0x804138,%eax
  8026a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026aa:	e9 e4 00 00 00       	jmp    802793 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8026b8:	0f 85 cd 00 00 00    	jne    80278b <alloc_block_BF+0x298>
  8026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c1:	8b 40 08             	mov    0x8(%eax),%eax
  8026c4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026c7:	0f 85 be 00 00 00    	jne    80278b <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  8026cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026d1:	75 17                	jne    8026ea <alloc_block_BF+0x1f7>
  8026d3:	83 ec 04             	sub    $0x4,%esp
  8026d6:	68 28 3a 80 00       	push   $0x803a28
  8026db:	68 db 00 00 00       	push   $0xdb
  8026e0:	68 b7 39 80 00       	push   $0x8039b7
  8026e5:	e8 98 db ff ff       	call   800282 <_panic>
  8026ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ed:	8b 00                	mov    (%eax),%eax
  8026ef:	85 c0                	test   %eax,%eax
  8026f1:	74 10                	je     802703 <alloc_block_BF+0x210>
  8026f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f6:	8b 00                	mov    (%eax),%eax
  8026f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026fb:	8b 52 04             	mov    0x4(%edx),%edx
  8026fe:	89 50 04             	mov    %edx,0x4(%eax)
  802701:	eb 0b                	jmp    80270e <alloc_block_BF+0x21b>
  802703:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802706:	8b 40 04             	mov    0x4(%eax),%eax
  802709:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80270e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802711:	8b 40 04             	mov    0x4(%eax),%eax
  802714:	85 c0                	test   %eax,%eax
  802716:	74 0f                	je     802727 <alloc_block_BF+0x234>
  802718:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80271b:	8b 40 04             	mov    0x4(%eax),%eax
  80271e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802721:	8b 12                	mov    (%edx),%edx
  802723:	89 10                	mov    %edx,(%eax)
  802725:	eb 0a                	jmp    802731 <alloc_block_BF+0x23e>
  802727:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80272a:	8b 00                	mov    (%eax),%eax
  80272c:	a3 48 41 80 00       	mov    %eax,0x804148
  802731:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802734:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80273a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80273d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802744:	a1 54 41 80 00       	mov    0x804154,%eax
  802749:	48                   	dec    %eax
  80274a:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  80274f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802752:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802755:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802758:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80275b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80275e:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802764:	8b 40 0c             	mov    0xc(%eax),%eax
  802767:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80276a:	89 c2                	mov    %eax,%edx
  80276c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276f:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	8b 50 08             	mov    0x8(%eax),%edx
  802778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80277b:	8b 40 0c             	mov    0xc(%eax),%eax
  80277e:	01 c2                	add    %eax,%edx
  802780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802783:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802789:	eb 3b                	jmp    8027c6 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80278b:	a1 40 41 80 00       	mov    0x804140,%eax
  802790:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802793:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802797:	74 07                	je     8027a0 <alloc_block_BF+0x2ad>
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	8b 00                	mov    (%eax),%eax
  80279e:	eb 05                	jmp    8027a5 <alloc_block_BF+0x2b2>
  8027a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a5:	a3 40 41 80 00       	mov    %eax,0x804140
  8027aa:	a1 40 41 80 00       	mov    0x804140,%eax
  8027af:	85 c0                	test   %eax,%eax
  8027b1:	0f 85 f8 fe ff ff    	jne    8026af <alloc_block_BF+0x1bc>
  8027b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027bb:	0f 85 ee fe ff ff    	jne    8026af <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  8027c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027c6:	c9                   	leave  
  8027c7:	c3                   	ret    

008027c8 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027c8:	55                   	push   %ebp
  8027c9:	89 e5                	mov    %esp,%ebp
  8027cb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  8027ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8027d4:	a1 48 41 80 00       	mov    0x804148,%eax
  8027d9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8027dc:	a1 38 41 80 00       	mov    0x804138,%eax
  8027e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e4:	e9 77 01 00 00       	jmp    802960 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  8027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027f2:	0f 85 8a 00 00 00    	jne    802882 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8027f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fc:	75 17                	jne    802815 <alloc_block_NF+0x4d>
  8027fe:	83 ec 04             	sub    $0x4,%esp
  802801:	68 28 3a 80 00       	push   $0x803a28
  802806:	68 f7 00 00 00       	push   $0xf7
  80280b:	68 b7 39 80 00       	push   $0x8039b7
  802810:	e8 6d da ff ff       	call   800282 <_panic>
  802815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802818:	8b 00                	mov    (%eax),%eax
  80281a:	85 c0                	test   %eax,%eax
  80281c:	74 10                	je     80282e <alloc_block_NF+0x66>
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	8b 00                	mov    (%eax),%eax
  802823:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802826:	8b 52 04             	mov    0x4(%edx),%edx
  802829:	89 50 04             	mov    %edx,0x4(%eax)
  80282c:	eb 0b                	jmp    802839 <alloc_block_NF+0x71>
  80282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802831:	8b 40 04             	mov    0x4(%eax),%eax
  802834:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	8b 40 04             	mov    0x4(%eax),%eax
  80283f:	85 c0                	test   %eax,%eax
  802841:	74 0f                	je     802852 <alloc_block_NF+0x8a>
  802843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802846:	8b 40 04             	mov    0x4(%eax),%eax
  802849:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284c:	8b 12                	mov    (%edx),%edx
  80284e:	89 10                	mov    %edx,(%eax)
  802850:	eb 0a                	jmp    80285c <alloc_block_NF+0x94>
  802852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802855:	8b 00                	mov    (%eax),%eax
  802857:	a3 38 41 80 00       	mov    %eax,0x804138
  80285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802868:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80286f:	a1 44 41 80 00       	mov    0x804144,%eax
  802874:	48                   	dec    %eax
  802875:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  80287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287d:	e9 11 01 00 00       	jmp    802993 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802885:	8b 40 0c             	mov    0xc(%eax),%eax
  802888:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80288b:	0f 86 c7 00 00 00    	jbe    802958 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802891:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802895:	75 17                	jne    8028ae <alloc_block_NF+0xe6>
  802897:	83 ec 04             	sub    $0x4,%esp
  80289a:	68 28 3a 80 00       	push   $0x803a28
  80289f:	68 fc 00 00 00       	push   $0xfc
  8028a4:	68 b7 39 80 00       	push   $0x8039b7
  8028a9:	e8 d4 d9 ff ff       	call   800282 <_panic>
  8028ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b1:	8b 00                	mov    (%eax),%eax
  8028b3:	85 c0                	test   %eax,%eax
  8028b5:	74 10                	je     8028c7 <alloc_block_NF+0xff>
  8028b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ba:	8b 00                	mov    (%eax),%eax
  8028bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028bf:	8b 52 04             	mov    0x4(%edx),%edx
  8028c2:	89 50 04             	mov    %edx,0x4(%eax)
  8028c5:	eb 0b                	jmp    8028d2 <alloc_block_NF+0x10a>
  8028c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ca:	8b 40 04             	mov    0x4(%eax),%eax
  8028cd:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d5:	8b 40 04             	mov    0x4(%eax),%eax
  8028d8:	85 c0                	test   %eax,%eax
  8028da:	74 0f                	je     8028eb <alloc_block_NF+0x123>
  8028dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028df:	8b 40 04             	mov    0x4(%eax),%eax
  8028e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028e5:	8b 12                	mov    (%edx),%edx
  8028e7:	89 10                	mov    %edx,(%eax)
  8028e9:	eb 0a                	jmp    8028f5 <alloc_block_NF+0x12d>
  8028eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ee:	8b 00                	mov    (%eax),%eax
  8028f0:	a3 48 41 80 00       	mov    %eax,0x804148
  8028f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802901:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802908:	a1 54 41 80 00       	mov    0x804154,%eax
  80290d:	48                   	dec    %eax
  80290e:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802913:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802916:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802919:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  80291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291f:	8b 40 0c             	mov    0xc(%eax),%eax
  802922:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802925:	89 c2                	mov    %eax,%edx
  802927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292a:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  80292d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802930:	8b 40 08             	mov    0x8(%eax),%eax
  802933:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802939:	8b 50 08             	mov    0x8(%eax),%edx
  80293c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293f:	8b 40 0c             	mov    0xc(%eax),%eax
  802942:	01 c2                	add    %eax,%edx
  802944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802947:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  80294a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802950:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802953:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802956:	eb 3b                	jmp    802993 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802958:	a1 40 41 80 00       	mov    0x804140,%eax
  80295d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802960:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802964:	74 07                	je     80296d <alloc_block_NF+0x1a5>
  802966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802969:	8b 00                	mov    (%eax),%eax
  80296b:	eb 05                	jmp    802972 <alloc_block_NF+0x1aa>
  80296d:	b8 00 00 00 00       	mov    $0x0,%eax
  802972:	a3 40 41 80 00       	mov    %eax,0x804140
  802977:	a1 40 41 80 00       	mov    0x804140,%eax
  80297c:	85 c0                	test   %eax,%eax
  80297e:	0f 85 65 fe ff ff    	jne    8027e9 <alloc_block_NF+0x21>
  802984:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802988:	0f 85 5b fe ff ff    	jne    8027e9 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  80298e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802993:	c9                   	leave  
  802994:	c3                   	ret    

00802995 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802995:	55                   	push   %ebp
  802996:	89 e5                	mov    %esp,%ebp
  802998:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  80299b:	8b 45 08             	mov    0x8(%ebp),%eax
  80299e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  8029a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  8029af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029b3:	75 17                	jne    8029cc <addToAvailMemBlocksList+0x37>
  8029b5:	83 ec 04             	sub    $0x4,%esp
  8029b8:	68 d0 39 80 00       	push   $0x8039d0
  8029bd:	68 10 01 00 00       	push   $0x110
  8029c2:	68 b7 39 80 00       	push   $0x8039b7
  8029c7:	e8 b6 d8 ff ff       	call   800282 <_panic>
  8029cc:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  8029d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d5:	89 50 04             	mov    %edx,0x4(%eax)
  8029d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029db:	8b 40 04             	mov    0x4(%eax),%eax
  8029de:	85 c0                	test   %eax,%eax
  8029e0:	74 0c                	je     8029ee <addToAvailMemBlocksList+0x59>
  8029e2:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8029e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ea:	89 10                	mov    %edx,(%eax)
  8029ec:	eb 08                	jmp    8029f6 <addToAvailMemBlocksList+0x61>
  8029ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f1:	a3 48 41 80 00       	mov    %eax,0x804148
  8029f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802a01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a07:	a1 54 41 80 00       	mov    0x804154,%eax
  802a0c:	40                   	inc    %eax
  802a0d:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802a12:	90                   	nop
  802a13:	c9                   	leave  
  802a14:	c3                   	ret    

00802a15 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a15:	55                   	push   %ebp
  802a16:	89 e5                	mov    %esp,%ebp
  802a18:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802a1b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802a23:	a1 44 41 80 00       	mov    0x804144,%eax
  802a28:	85 c0                	test   %eax,%eax
  802a2a:	75 68                	jne    802a94 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802a2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a30:	75 17                	jne    802a49 <insert_sorted_with_merge_freeList+0x34>
  802a32:	83 ec 04             	sub    $0x4,%esp
  802a35:	68 94 39 80 00       	push   $0x803994
  802a3a:	68 1a 01 00 00       	push   $0x11a
  802a3f:	68 b7 39 80 00       	push   $0x8039b7
  802a44:	e8 39 d8 ff ff       	call   800282 <_panic>
  802a49:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a52:	89 10                	mov    %edx,(%eax)
  802a54:	8b 45 08             	mov    0x8(%ebp),%eax
  802a57:	8b 00                	mov    (%eax),%eax
  802a59:	85 c0                	test   %eax,%eax
  802a5b:	74 0d                	je     802a6a <insert_sorted_with_merge_freeList+0x55>
  802a5d:	a1 38 41 80 00       	mov    0x804138,%eax
  802a62:	8b 55 08             	mov    0x8(%ebp),%edx
  802a65:	89 50 04             	mov    %edx,0x4(%eax)
  802a68:	eb 08                	jmp    802a72 <insert_sorted_with_merge_freeList+0x5d>
  802a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a72:	8b 45 08             	mov    0x8(%ebp),%eax
  802a75:	a3 38 41 80 00       	mov    %eax,0x804138
  802a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a84:	a1 44 41 80 00       	mov    0x804144,%eax
  802a89:	40                   	inc    %eax
  802a8a:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802a8f:	e9 c5 03 00 00       	jmp    802e59 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a97:	8b 50 08             	mov    0x8(%eax),%edx
  802a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9d:	8b 40 08             	mov    0x8(%eax),%eax
  802aa0:	39 c2                	cmp    %eax,%edx
  802aa2:	0f 83 b2 00 00 00    	jae    802b5a <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aab:	8b 50 08             	mov    0x8(%eax),%edx
  802aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab4:	01 c2                	add    %eax,%edx
  802ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab9:	8b 40 08             	mov    0x8(%eax),%eax
  802abc:	39 c2                	cmp    %eax,%edx
  802abe:	75 27                	jne    802ae7 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac3:	8b 50 0c             	mov    0xc(%eax),%edx
  802ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac9:	8b 40 0c             	mov    0xc(%eax),%eax
  802acc:	01 c2                	add    %eax,%edx
  802ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad1:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802ad4:	83 ec 0c             	sub    $0xc,%esp
  802ad7:	ff 75 08             	pushl  0x8(%ebp)
  802ada:	e8 b6 fe ff ff       	call   802995 <addToAvailMemBlocksList>
  802adf:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ae2:	e9 72 03 00 00       	jmp    802e59 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802ae7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aeb:	74 06                	je     802af3 <insert_sorted_with_merge_freeList+0xde>
  802aed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802af1:	75 17                	jne    802b0a <insert_sorted_with_merge_freeList+0xf5>
  802af3:	83 ec 04             	sub    $0x4,%esp
  802af6:	68 f4 39 80 00       	push   $0x8039f4
  802afb:	68 24 01 00 00       	push   $0x124
  802b00:	68 b7 39 80 00       	push   $0x8039b7
  802b05:	e8 78 d7 ff ff       	call   800282 <_panic>
  802b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0d:	8b 10                	mov    (%eax),%edx
  802b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b12:	89 10                	mov    %edx,(%eax)
  802b14:	8b 45 08             	mov    0x8(%ebp),%eax
  802b17:	8b 00                	mov    (%eax),%eax
  802b19:	85 c0                	test   %eax,%eax
  802b1b:	74 0b                	je     802b28 <insert_sorted_with_merge_freeList+0x113>
  802b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b20:	8b 00                	mov    (%eax),%eax
  802b22:	8b 55 08             	mov    0x8(%ebp),%edx
  802b25:	89 50 04             	mov    %edx,0x4(%eax)
  802b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b2e:	89 10                	mov    %edx,(%eax)
  802b30:	8b 45 08             	mov    0x8(%ebp),%eax
  802b33:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b36:	89 50 04             	mov    %edx,0x4(%eax)
  802b39:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3c:	8b 00                	mov    (%eax),%eax
  802b3e:	85 c0                	test   %eax,%eax
  802b40:	75 08                	jne    802b4a <insert_sorted_with_merge_freeList+0x135>
  802b42:	8b 45 08             	mov    0x8(%ebp),%eax
  802b45:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b4a:	a1 44 41 80 00       	mov    0x804144,%eax
  802b4f:	40                   	inc    %eax
  802b50:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802b55:	e9 ff 02 00 00       	jmp    802e59 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802b5a:	a1 38 41 80 00       	mov    0x804138,%eax
  802b5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b62:	e9 c2 02 00 00       	jmp    802e29 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6a:	8b 50 08             	mov    0x8(%eax),%edx
  802b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b70:	8b 40 08             	mov    0x8(%eax),%eax
  802b73:	39 c2                	cmp    %eax,%edx
  802b75:	0f 86 a6 02 00 00    	jbe    802e21 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7e:	8b 40 04             	mov    0x4(%eax),%eax
  802b81:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802b84:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b88:	0f 85 ba 00 00 00    	jne    802c48 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b91:	8b 50 0c             	mov    0xc(%eax),%edx
  802b94:	8b 45 08             	mov    0x8(%ebp),%eax
  802b97:	8b 40 08             	mov    0x8(%eax),%eax
  802b9a:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9f:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802ba2:	39 c2                	cmp    %eax,%edx
  802ba4:	75 33                	jne    802bd9 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba9:	8b 50 08             	mov    0x8(%eax),%edx
  802bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baf:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb5:	8b 50 0c             	mov    0xc(%eax),%edx
  802bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbb:	8b 40 0c             	mov    0xc(%eax),%eax
  802bbe:	01 c2                	add    %eax,%edx
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802bc6:	83 ec 0c             	sub    $0xc,%esp
  802bc9:	ff 75 08             	pushl  0x8(%ebp)
  802bcc:	e8 c4 fd ff ff       	call   802995 <addToAvailMemBlocksList>
  802bd1:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802bd4:	e9 80 02 00 00       	jmp    802e59 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802bd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bdd:	74 06                	je     802be5 <insert_sorted_with_merge_freeList+0x1d0>
  802bdf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802be3:	75 17                	jne    802bfc <insert_sorted_with_merge_freeList+0x1e7>
  802be5:	83 ec 04             	sub    $0x4,%esp
  802be8:	68 48 3a 80 00       	push   $0x803a48
  802bed:	68 3a 01 00 00       	push   $0x13a
  802bf2:	68 b7 39 80 00       	push   $0x8039b7
  802bf7:	e8 86 d6 ff ff       	call   800282 <_panic>
  802bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bff:	8b 50 04             	mov    0x4(%eax),%edx
  802c02:	8b 45 08             	mov    0x8(%ebp),%eax
  802c05:	89 50 04             	mov    %edx,0x4(%eax)
  802c08:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c0e:	89 10                	mov    %edx,(%eax)
  802c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c13:	8b 40 04             	mov    0x4(%eax),%eax
  802c16:	85 c0                	test   %eax,%eax
  802c18:	74 0d                	je     802c27 <insert_sorted_with_merge_freeList+0x212>
  802c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1d:	8b 40 04             	mov    0x4(%eax),%eax
  802c20:	8b 55 08             	mov    0x8(%ebp),%edx
  802c23:	89 10                	mov    %edx,(%eax)
  802c25:	eb 08                	jmp    802c2f <insert_sorted_with_merge_freeList+0x21a>
  802c27:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2a:	a3 38 41 80 00       	mov    %eax,0x804138
  802c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c32:	8b 55 08             	mov    0x8(%ebp),%edx
  802c35:	89 50 04             	mov    %edx,0x4(%eax)
  802c38:	a1 44 41 80 00       	mov    0x804144,%eax
  802c3d:	40                   	inc    %eax
  802c3e:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802c43:	e9 11 02 00 00       	jmp    802e59 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802c48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4b:	8b 50 08             	mov    0x8(%eax),%edx
  802c4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c51:	8b 40 0c             	mov    0xc(%eax),%eax
  802c54:	01 c2                	add    %eax,%edx
  802c56:	8b 45 08             	mov    0x8(%ebp),%eax
  802c59:	8b 40 0c             	mov    0xc(%eax),%eax
  802c5c:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c61:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802c64:	39 c2                	cmp    %eax,%edx
  802c66:	0f 85 bf 00 00 00    	jne    802d2b <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802c6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6f:	8b 50 0c             	mov    0xc(%eax),%edx
  802c72:	8b 45 08             	mov    0x8(%ebp),%eax
  802c75:	8b 40 0c             	mov    0xc(%eax),%eax
  802c78:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c80:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802c82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c85:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802c88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c8c:	75 17                	jne    802ca5 <insert_sorted_with_merge_freeList+0x290>
  802c8e:	83 ec 04             	sub    $0x4,%esp
  802c91:	68 28 3a 80 00       	push   $0x803a28
  802c96:	68 43 01 00 00       	push   $0x143
  802c9b:	68 b7 39 80 00       	push   $0x8039b7
  802ca0:	e8 dd d5 ff ff       	call   800282 <_panic>
  802ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca8:	8b 00                	mov    (%eax),%eax
  802caa:	85 c0                	test   %eax,%eax
  802cac:	74 10                	je     802cbe <insert_sorted_with_merge_freeList+0x2a9>
  802cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb1:	8b 00                	mov    (%eax),%eax
  802cb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb6:	8b 52 04             	mov    0x4(%edx),%edx
  802cb9:	89 50 04             	mov    %edx,0x4(%eax)
  802cbc:	eb 0b                	jmp    802cc9 <insert_sorted_with_merge_freeList+0x2b4>
  802cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc1:	8b 40 04             	mov    0x4(%eax),%eax
  802cc4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccc:	8b 40 04             	mov    0x4(%eax),%eax
  802ccf:	85 c0                	test   %eax,%eax
  802cd1:	74 0f                	je     802ce2 <insert_sorted_with_merge_freeList+0x2cd>
  802cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd6:	8b 40 04             	mov    0x4(%eax),%eax
  802cd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cdc:	8b 12                	mov    (%edx),%edx
  802cde:	89 10                	mov    %edx,(%eax)
  802ce0:	eb 0a                	jmp    802cec <insert_sorted_with_merge_freeList+0x2d7>
  802ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce5:	8b 00                	mov    (%eax),%eax
  802ce7:	a3 38 41 80 00       	mov    %eax,0x804138
  802cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cff:	a1 44 41 80 00       	mov    0x804144,%eax
  802d04:	48                   	dec    %eax
  802d05:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802d0a:	83 ec 0c             	sub    $0xc,%esp
  802d0d:	ff 75 08             	pushl  0x8(%ebp)
  802d10:	e8 80 fc ff ff       	call   802995 <addToAvailMemBlocksList>
  802d15:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802d18:	83 ec 0c             	sub    $0xc,%esp
  802d1b:	ff 75 f4             	pushl  -0xc(%ebp)
  802d1e:	e8 72 fc ff ff       	call   802995 <addToAvailMemBlocksList>
  802d23:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802d26:	e9 2e 01 00 00       	jmp    802e59 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802d2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2e:	8b 50 08             	mov    0x8(%eax),%edx
  802d31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d34:	8b 40 0c             	mov    0xc(%eax),%eax
  802d37:	01 c2                	add    %eax,%edx
  802d39:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3c:	8b 40 08             	mov    0x8(%eax),%eax
  802d3f:	39 c2                	cmp    %eax,%edx
  802d41:	75 27                	jne    802d6a <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802d43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d46:	8b 50 0c             	mov    0xc(%eax),%edx
  802d49:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d4f:	01 c2                	add    %eax,%edx
  802d51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d54:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802d57:	83 ec 0c             	sub    $0xc,%esp
  802d5a:	ff 75 08             	pushl  0x8(%ebp)
  802d5d:	e8 33 fc ff ff       	call   802995 <addToAvailMemBlocksList>
  802d62:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802d65:	e9 ef 00 00 00       	jmp    802e59 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6d:	8b 50 0c             	mov    0xc(%eax),%edx
  802d70:	8b 45 08             	mov    0x8(%ebp),%eax
  802d73:	8b 40 08             	mov    0x8(%eax),%eax
  802d76:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7b:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802d7e:	39 c2                	cmp    %eax,%edx
  802d80:	75 33                	jne    802db5 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802d82:	8b 45 08             	mov    0x8(%ebp),%eax
  802d85:	8b 50 08             	mov    0x8(%eax),%edx
  802d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8b:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d91:	8b 50 0c             	mov    0xc(%eax),%edx
  802d94:	8b 45 08             	mov    0x8(%ebp),%eax
  802d97:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9a:	01 c2                	add    %eax,%edx
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802da2:	83 ec 0c             	sub    $0xc,%esp
  802da5:	ff 75 08             	pushl  0x8(%ebp)
  802da8:	e8 e8 fb ff ff       	call   802995 <addToAvailMemBlocksList>
  802dad:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802db0:	e9 a4 00 00 00       	jmp    802e59 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802db5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db9:	74 06                	je     802dc1 <insert_sorted_with_merge_freeList+0x3ac>
  802dbb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dbf:	75 17                	jne    802dd8 <insert_sorted_with_merge_freeList+0x3c3>
  802dc1:	83 ec 04             	sub    $0x4,%esp
  802dc4:	68 48 3a 80 00       	push   $0x803a48
  802dc9:	68 56 01 00 00       	push   $0x156
  802dce:	68 b7 39 80 00       	push   $0x8039b7
  802dd3:	e8 aa d4 ff ff       	call   800282 <_panic>
  802dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddb:	8b 50 04             	mov    0x4(%eax),%edx
  802dde:	8b 45 08             	mov    0x8(%ebp),%eax
  802de1:	89 50 04             	mov    %edx,0x4(%eax)
  802de4:	8b 45 08             	mov    0x8(%ebp),%eax
  802de7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dea:	89 10                	mov    %edx,(%eax)
  802dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802def:	8b 40 04             	mov    0x4(%eax),%eax
  802df2:	85 c0                	test   %eax,%eax
  802df4:	74 0d                	je     802e03 <insert_sorted_with_merge_freeList+0x3ee>
  802df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df9:	8b 40 04             	mov    0x4(%eax),%eax
  802dfc:	8b 55 08             	mov    0x8(%ebp),%edx
  802dff:	89 10                	mov    %edx,(%eax)
  802e01:	eb 08                	jmp    802e0b <insert_sorted_with_merge_freeList+0x3f6>
  802e03:	8b 45 08             	mov    0x8(%ebp),%eax
  802e06:	a3 38 41 80 00       	mov    %eax,0x804138
  802e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0e:	8b 55 08             	mov    0x8(%ebp),%edx
  802e11:	89 50 04             	mov    %edx,0x4(%eax)
  802e14:	a1 44 41 80 00       	mov    0x804144,%eax
  802e19:	40                   	inc    %eax
  802e1a:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802e1f:	eb 38                	jmp    802e59 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802e21:	a1 40 41 80 00       	mov    0x804140,%eax
  802e26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e2d:	74 07                	je     802e36 <insert_sorted_with_merge_freeList+0x421>
  802e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e32:	8b 00                	mov    (%eax),%eax
  802e34:	eb 05                	jmp    802e3b <insert_sorted_with_merge_freeList+0x426>
  802e36:	b8 00 00 00 00       	mov    $0x0,%eax
  802e3b:	a3 40 41 80 00       	mov    %eax,0x804140
  802e40:	a1 40 41 80 00       	mov    0x804140,%eax
  802e45:	85 c0                	test   %eax,%eax
  802e47:	0f 85 1a fd ff ff    	jne    802b67 <insert_sorted_with_merge_freeList+0x152>
  802e4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e51:	0f 85 10 fd ff ff    	jne    802b67 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e57:	eb 00                	jmp    802e59 <insert_sorted_with_merge_freeList+0x444>
  802e59:	90                   	nop
  802e5a:	c9                   	leave  
  802e5b:	c3                   	ret    

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
