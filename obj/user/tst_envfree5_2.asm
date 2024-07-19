
obj/user/tst_envfree5_2:     file format elf32-i386


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
  800031:	e8 4b 01 00 00       	call   800181 <libmain>
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
	// Testing scenario 5_2: Kill programs have already shared variables and they free it [include scenario 5_1]
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 c0 31 80 00       	push   $0x8031c0
  80004a:	e8 fc 15 00 00       	call   80164b <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 ac 18 00 00       	call   80190f <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 44 19 00 00       	call   8019af <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 d0 31 80 00       	push   $0x8031d0
  800079:	e8 f3 04 00 00       	call   800571 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,100, 50);
  800081:	6a 32                	push   $0x32
  800083:	6a 64                	push   $0x64
  800085:	68 d0 07 00 00       	push   $0x7d0
  80008a:	68 03 32 80 00       	push   $0x803203
  80008f:	e8 ed 1a 00 00       	call   801b81 <sys_create_env>
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr5", 2000,100, 50);
  80009a:	6a 32                	push   $0x32
  80009c:	6a 64                	push   $0x64
  80009e:	68 d0 07 00 00       	push   $0x7d0
  8000a3:	68 0c 32 80 00       	push   $0x80320c
  8000a8:	e8 d4 1a 00 00       	call   801b81 <sys_create_env>
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b9:	e8 e1 1a 00 00       	call   801b9f <sys_run_env>
  8000be:	83 c4 10             	add    $0x10,%esp
	env_sleep(15000);
  8000c1:	83 ec 0c             	sub    $0xc,%esp
  8000c4:	68 98 3a 00 00       	push   $0x3a98
  8000c9:	e8 c9 2d 00 00       	call   802e97 <env_sleep>
  8000ce:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000d7:	e8 c3 1a 00 00       	call   801b9f <sys_run_env>
  8000dc:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000df:	90                   	nop
  8000e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000e3:	8b 00                	mov    (%eax),%eax
  8000e5:	83 f8 02             	cmp    $0x2,%eax
  8000e8:	75 f6                	jne    8000e0 <_main+0xa8>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ea:	e8 20 18 00 00       	call   80190f <sys_calculate_free_frames>
  8000ef:	83 ec 08             	sub    $0x8,%esp
  8000f2:	50                   	push   %eax
  8000f3:	68 18 32 80 00       	push   $0x803218
  8000f8:	e8 74 04 00 00       	call   800571 <cprintf>
  8000fd:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 e8             	pushl  -0x18(%ebp)
  800106:	e8 b0 1a 00 00       	call   801bbb <sys_destroy_env>
  80010b:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	ff 75 e4             	pushl  -0x1c(%ebp)
  800114:	e8 a2 1a 00 00       	call   801bbb <sys_destroy_env>
  800119:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80011c:	e8 ee 17 00 00       	call   80190f <sys_calculate_free_frames>
  800121:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800124:	e8 86 18 00 00       	call   8019af <sys_pf_calculate_allocated_pages>
  800129:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80012c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800132:	74 27                	je     80015b <_main+0x123>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800134:	83 ec 08             	sub    $0x8,%esp
  800137:	ff 75 e0             	pushl  -0x20(%ebp)
  80013a:	68 4c 32 80 00       	push   $0x80324c
  80013f:	e8 2d 04 00 00       	call   800571 <cprintf>
  800144:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	68 9c 32 80 00       	push   $0x80329c
  80014f:	6a 23                	push   $0x23
  800151:	68 d2 32 80 00       	push   $0x8032d2
  800156:	e8 62 01 00 00       	call   8002bd <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	ff 75 e0             	pushl  -0x20(%ebp)
  800161:	68 e8 32 80 00       	push   $0x8032e8
  800166:	e8 06 04 00 00       	call   800571 <cprintf>
  80016b:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_2 for envfree completed successfully.\n");
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	68 48 33 80 00       	push   $0x803348
  800176:	e8 f6 03 00 00       	call   800571 <cprintf>
  80017b:	83 c4 10             	add    $0x10,%esp
	return;
  80017e:	90                   	nop
}
  80017f:	c9                   	leave  
  800180:	c3                   	ret    

00800181 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800187:	e8 63 1a 00 00       	call   801bef <sys_getenvindex>
  80018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80018f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800192:	89 d0                	mov    %edx,%eax
  800194:	c1 e0 03             	shl    $0x3,%eax
  800197:	01 d0                	add    %edx,%eax
  800199:	01 c0                	add    %eax,%eax
  80019b:	01 d0                	add    %edx,%eax
  80019d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001a4:	01 d0                	add    %edx,%eax
  8001a6:	c1 e0 04             	shl    $0x4,%eax
  8001a9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ae:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001b3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b8:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001be:	84 c0                	test   %al,%al
  8001c0:	74 0f                	je     8001d1 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001c2:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c7:	05 5c 05 00 00       	add    $0x55c,%eax
  8001cc:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001d5:	7e 0a                	jle    8001e1 <libmain+0x60>
		binaryname = argv[0];
  8001d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001da:	8b 00                	mov    (%eax),%eax
  8001dc:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001e1:	83 ec 08             	sub    $0x8,%esp
  8001e4:	ff 75 0c             	pushl  0xc(%ebp)
  8001e7:	ff 75 08             	pushl  0x8(%ebp)
  8001ea:	e8 49 fe ff ff       	call   800038 <_main>
  8001ef:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001f2:	e8 05 18 00 00       	call   8019fc <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	68 ac 33 80 00       	push   $0x8033ac
  8001ff:	e8 6d 03 00 00       	call   800571 <cprintf>
  800204:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800207:	a1 20 40 80 00       	mov    0x804020,%eax
  80020c:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800212:	a1 20 40 80 00       	mov    0x804020,%eax
  800217:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80021d:	83 ec 04             	sub    $0x4,%esp
  800220:	52                   	push   %edx
  800221:	50                   	push   %eax
  800222:	68 d4 33 80 00       	push   $0x8033d4
  800227:	e8 45 03 00 00       	call   800571 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80022f:	a1 20 40 80 00       	mov    0x804020,%eax
  800234:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80023a:	a1 20 40 80 00       	mov    0x804020,%eax
  80023f:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800245:	a1 20 40 80 00       	mov    0x804020,%eax
  80024a:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800250:	51                   	push   %ecx
  800251:	52                   	push   %edx
  800252:	50                   	push   %eax
  800253:	68 fc 33 80 00       	push   $0x8033fc
  800258:	e8 14 03 00 00       	call   800571 <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800260:	a1 20 40 80 00       	mov    0x804020,%eax
  800265:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	50                   	push   %eax
  80026f:	68 54 34 80 00       	push   $0x803454
  800274:	e8 f8 02 00 00       	call   800571 <cprintf>
  800279:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	68 ac 33 80 00       	push   $0x8033ac
  800284:	e8 e8 02 00 00       	call   800571 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80028c:	e8 85 17 00 00       	call   801a16 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800291:	e8 19 00 00 00       	call   8002af <exit>
}
  800296:	90                   	nop
  800297:	c9                   	leave  
  800298:	c3                   	ret    

00800299 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80029f:	83 ec 0c             	sub    $0xc,%esp
  8002a2:	6a 00                	push   $0x0
  8002a4:	e8 12 19 00 00       	call   801bbb <sys_destroy_env>
  8002a9:	83 c4 10             	add    $0x10,%esp
}
  8002ac:	90                   	nop
  8002ad:	c9                   	leave  
  8002ae:	c3                   	ret    

008002af <exit>:

void
exit(void)
{
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002b5:	e8 67 19 00 00       	call   801c21 <sys_exit_env>
}
  8002ba:	90                   	nop
  8002bb:	c9                   	leave  
  8002bc:	c3                   	ret    

008002bd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002bd:	55                   	push   %ebp
  8002be:	89 e5                	mov    %esp,%ebp
  8002c0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002c3:	8d 45 10             	lea    0x10(%ebp),%eax
  8002c6:	83 c0 04             	add    $0x4,%eax
  8002c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002cc:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002d1:	85 c0                	test   %eax,%eax
  8002d3:	74 16                	je     8002eb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002d5:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	50                   	push   %eax
  8002de:	68 68 34 80 00       	push   $0x803468
  8002e3:	e8 89 02 00 00       	call   800571 <cprintf>
  8002e8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002eb:	a1 00 40 80 00       	mov    0x804000,%eax
  8002f0:	ff 75 0c             	pushl  0xc(%ebp)
  8002f3:	ff 75 08             	pushl  0x8(%ebp)
  8002f6:	50                   	push   %eax
  8002f7:	68 6d 34 80 00       	push   $0x80346d
  8002fc:	e8 70 02 00 00       	call   800571 <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800304:	8b 45 10             	mov    0x10(%ebp),%eax
  800307:	83 ec 08             	sub    $0x8,%esp
  80030a:	ff 75 f4             	pushl  -0xc(%ebp)
  80030d:	50                   	push   %eax
  80030e:	e8 f3 01 00 00       	call   800506 <vcprintf>
  800313:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800316:	83 ec 08             	sub    $0x8,%esp
  800319:	6a 00                	push   $0x0
  80031b:	68 89 34 80 00       	push   $0x803489
  800320:	e8 e1 01 00 00       	call   800506 <vcprintf>
  800325:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800328:	e8 82 ff ff ff       	call   8002af <exit>

	// should not return here
	while (1) ;
  80032d:	eb fe                	jmp    80032d <_panic+0x70>

0080032f <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80032f:	55                   	push   %ebp
  800330:	89 e5                	mov    %esp,%ebp
  800332:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800335:	a1 20 40 80 00       	mov    0x804020,%eax
  80033a:	8b 50 74             	mov    0x74(%eax),%edx
  80033d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800340:	39 c2                	cmp    %eax,%edx
  800342:	74 14                	je     800358 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800344:	83 ec 04             	sub    $0x4,%esp
  800347:	68 8c 34 80 00       	push   $0x80348c
  80034c:	6a 26                	push   $0x26
  80034e:	68 d8 34 80 00       	push   $0x8034d8
  800353:	e8 65 ff ff ff       	call   8002bd <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800358:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80035f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800366:	e9 c2 00 00 00       	jmp    80042d <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80036b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80036e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800375:	8b 45 08             	mov    0x8(%ebp),%eax
  800378:	01 d0                	add    %edx,%eax
  80037a:	8b 00                	mov    (%eax),%eax
  80037c:	85 c0                	test   %eax,%eax
  80037e:	75 08                	jne    800388 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800380:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800383:	e9 a2 00 00 00       	jmp    80042a <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800388:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80038f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800396:	eb 69                	jmp    800401 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800398:	a1 20 40 80 00       	mov    0x804020,%eax
  80039d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003a6:	89 d0                	mov    %edx,%eax
  8003a8:	01 c0                	add    %eax,%eax
  8003aa:	01 d0                	add    %edx,%eax
  8003ac:	c1 e0 03             	shl    $0x3,%eax
  8003af:	01 c8                	add    %ecx,%eax
  8003b1:	8a 40 04             	mov    0x4(%eax),%al
  8003b4:	84 c0                	test   %al,%al
  8003b6:	75 46                	jne    8003fe <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b8:	a1 20 40 80 00       	mov    0x804020,%eax
  8003bd:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003c6:	89 d0                	mov    %edx,%eax
  8003c8:	01 c0                	add    %eax,%eax
  8003ca:	01 d0                	add    %edx,%eax
  8003cc:	c1 e0 03             	shl    $0x3,%eax
  8003cf:	01 c8                	add    %ecx,%eax
  8003d1:	8b 00                	mov    (%eax),%eax
  8003d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003de:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ed:	01 c8                	add    %ecx,%eax
  8003ef:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003f1:	39 c2                	cmp    %eax,%edx
  8003f3:	75 09                	jne    8003fe <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003f5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003fc:	eb 12                	jmp    800410 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fe:	ff 45 e8             	incl   -0x18(%ebp)
  800401:	a1 20 40 80 00       	mov    0x804020,%eax
  800406:	8b 50 74             	mov    0x74(%eax),%edx
  800409:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80040c:	39 c2                	cmp    %eax,%edx
  80040e:	77 88                	ja     800398 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800410:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800414:	75 14                	jne    80042a <CheckWSWithoutLastIndex+0xfb>
			panic(
  800416:	83 ec 04             	sub    $0x4,%esp
  800419:	68 e4 34 80 00       	push   $0x8034e4
  80041e:	6a 3a                	push   $0x3a
  800420:	68 d8 34 80 00       	push   $0x8034d8
  800425:	e8 93 fe ff ff       	call   8002bd <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80042a:	ff 45 f0             	incl   -0x10(%ebp)
  80042d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800430:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800433:	0f 8c 32 ff ff ff    	jl     80036b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800439:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800440:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800447:	eb 26                	jmp    80046f <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800449:	a1 20 40 80 00       	mov    0x804020,%eax
  80044e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800454:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800457:	89 d0                	mov    %edx,%eax
  800459:	01 c0                	add    %eax,%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	c1 e0 03             	shl    $0x3,%eax
  800460:	01 c8                	add    %ecx,%eax
  800462:	8a 40 04             	mov    0x4(%eax),%al
  800465:	3c 01                	cmp    $0x1,%al
  800467:	75 03                	jne    80046c <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800469:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046c:	ff 45 e0             	incl   -0x20(%ebp)
  80046f:	a1 20 40 80 00       	mov    0x804020,%eax
  800474:	8b 50 74             	mov    0x74(%eax),%edx
  800477:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80047a:	39 c2                	cmp    %eax,%edx
  80047c:	77 cb                	ja     800449 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80047e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800481:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800484:	74 14                	je     80049a <CheckWSWithoutLastIndex+0x16b>
		panic(
  800486:	83 ec 04             	sub    $0x4,%esp
  800489:	68 38 35 80 00       	push   $0x803538
  80048e:	6a 44                	push   $0x44
  800490:	68 d8 34 80 00       	push   $0x8034d8
  800495:	e8 23 fe ff ff       	call   8002bd <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80049a:	90                   	nop
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a6:	8b 00                	mov    (%eax),%eax
  8004a8:	8d 48 01             	lea    0x1(%eax),%ecx
  8004ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ae:	89 0a                	mov    %ecx,(%edx)
  8004b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b3:	88 d1                	mov    %dl,%cl
  8004b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bf:	8b 00                	mov    (%eax),%eax
  8004c1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004c6:	75 2c                	jne    8004f4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004c8:	a0 24 40 80 00       	mov    0x804024,%al
  8004cd:	0f b6 c0             	movzbl %al,%eax
  8004d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d3:	8b 12                	mov    (%edx),%edx
  8004d5:	89 d1                	mov    %edx,%ecx
  8004d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004da:	83 c2 08             	add    $0x8,%edx
  8004dd:	83 ec 04             	sub    $0x4,%esp
  8004e0:	50                   	push   %eax
  8004e1:	51                   	push   %ecx
  8004e2:	52                   	push   %edx
  8004e3:	e8 66 13 00 00       	call   80184e <sys_cputs>
  8004e8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f7:	8b 40 04             	mov    0x4(%eax),%eax
  8004fa:	8d 50 01             	lea    0x1(%eax),%edx
  8004fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800500:	89 50 04             	mov    %edx,0x4(%eax)
}
  800503:	90                   	nop
  800504:	c9                   	leave  
  800505:	c3                   	ret    

00800506 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800506:	55                   	push   %ebp
  800507:	89 e5                	mov    %esp,%ebp
  800509:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80050f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800516:	00 00 00 
	b.cnt = 0;
  800519:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800520:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800523:	ff 75 0c             	pushl  0xc(%ebp)
  800526:	ff 75 08             	pushl  0x8(%ebp)
  800529:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80052f:	50                   	push   %eax
  800530:	68 9d 04 80 00       	push   $0x80049d
  800535:	e8 11 02 00 00       	call   80074b <vprintfmt>
  80053a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80053d:	a0 24 40 80 00       	mov    0x804024,%al
  800542:	0f b6 c0             	movzbl %al,%eax
  800545:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80054b:	83 ec 04             	sub    $0x4,%esp
  80054e:	50                   	push   %eax
  80054f:	52                   	push   %edx
  800550:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800556:	83 c0 08             	add    $0x8,%eax
  800559:	50                   	push   %eax
  80055a:	e8 ef 12 00 00       	call   80184e <sys_cputs>
  80055f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800562:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800569:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80056f:	c9                   	leave  
  800570:	c3                   	ret    

00800571 <cprintf>:

int cprintf(const char *fmt, ...) {
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
  800574:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800577:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80057e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800581:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	ff 75 f4             	pushl  -0xc(%ebp)
  80058d:	50                   	push   %eax
  80058e:	e8 73 ff ff ff       	call   800506 <vcprintf>
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800599:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80059c:	c9                   	leave  
  80059d:	c3                   	ret    

0080059e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80059e:	55                   	push   %ebp
  80059f:	89 e5                	mov    %esp,%ebp
  8005a1:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005a4:	e8 53 14 00 00       	call   8019fc <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005a9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005af:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b2:	83 ec 08             	sub    $0x8,%esp
  8005b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b8:	50                   	push   %eax
  8005b9:	e8 48 ff ff ff       	call   800506 <vcprintf>
  8005be:	83 c4 10             	add    $0x10,%esp
  8005c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005c4:	e8 4d 14 00 00       	call   801a16 <sys_enable_interrupt>
	return cnt;
  8005c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005cc:	c9                   	leave  
  8005cd:	c3                   	ret    

008005ce <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005ce:	55                   	push   %ebp
  8005cf:	89 e5                	mov    %esp,%ebp
  8005d1:	53                   	push   %ebx
  8005d2:	83 ec 14             	sub    $0x14,%esp
  8005d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005e1:	8b 45 18             	mov    0x18(%ebp),%eax
  8005e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ec:	77 55                	ja     800643 <printnum+0x75>
  8005ee:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005f1:	72 05                	jb     8005f8 <printnum+0x2a>
  8005f3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005f6:	77 4b                	ja     800643 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005f8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005fb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005fe:	8b 45 18             	mov    0x18(%ebp),%eax
  800601:	ba 00 00 00 00       	mov    $0x0,%edx
  800606:	52                   	push   %edx
  800607:	50                   	push   %eax
  800608:	ff 75 f4             	pushl  -0xc(%ebp)
  80060b:	ff 75 f0             	pushl  -0x10(%ebp)
  80060e:	e8 39 29 00 00       	call   802f4c <__udivdi3>
  800613:	83 c4 10             	add    $0x10,%esp
  800616:	83 ec 04             	sub    $0x4,%esp
  800619:	ff 75 20             	pushl  0x20(%ebp)
  80061c:	53                   	push   %ebx
  80061d:	ff 75 18             	pushl  0x18(%ebp)
  800620:	52                   	push   %edx
  800621:	50                   	push   %eax
  800622:	ff 75 0c             	pushl  0xc(%ebp)
  800625:	ff 75 08             	pushl  0x8(%ebp)
  800628:	e8 a1 ff ff ff       	call   8005ce <printnum>
  80062d:	83 c4 20             	add    $0x20,%esp
  800630:	eb 1a                	jmp    80064c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	ff 75 20             	pushl  0x20(%ebp)
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	ff d0                	call   *%eax
  800640:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800643:	ff 4d 1c             	decl   0x1c(%ebp)
  800646:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80064a:	7f e6                	jg     800632 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80064c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80064f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800657:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80065a:	53                   	push   %ebx
  80065b:	51                   	push   %ecx
  80065c:	52                   	push   %edx
  80065d:	50                   	push   %eax
  80065e:	e8 f9 29 00 00       	call   80305c <__umoddi3>
  800663:	83 c4 10             	add    $0x10,%esp
  800666:	05 b4 37 80 00       	add    $0x8037b4,%eax
  80066b:	8a 00                	mov    (%eax),%al
  80066d:	0f be c0             	movsbl %al,%eax
  800670:	83 ec 08             	sub    $0x8,%esp
  800673:	ff 75 0c             	pushl  0xc(%ebp)
  800676:	50                   	push   %eax
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	ff d0                	call   *%eax
  80067c:	83 c4 10             	add    $0x10,%esp
}
  80067f:	90                   	nop
  800680:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800683:	c9                   	leave  
  800684:	c3                   	ret    

00800685 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800688:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80068c:	7e 1c                	jle    8006aa <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	8b 00                	mov    (%eax),%eax
  800693:	8d 50 08             	lea    0x8(%eax),%edx
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	89 10                	mov    %edx,(%eax)
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	83 e8 08             	sub    $0x8,%eax
  8006a3:	8b 50 04             	mov    0x4(%eax),%edx
  8006a6:	8b 00                	mov    (%eax),%eax
  8006a8:	eb 40                	jmp    8006ea <getuint+0x65>
	else if (lflag)
  8006aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006ae:	74 1e                	je     8006ce <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	8b 00                	mov    (%eax),%eax
  8006b5:	8d 50 04             	lea    0x4(%eax),%edx
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	89 10                	mov    %edx,(%eax)
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	83 e8 04             	sub    $0x4,%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cc:	eb 1c                	jmp    8006ea <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	8d 50 04             	lea    0x4(%eax),%edx
  8006d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d9:	89 10                	mov    %edx,(%eax)
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	83 e8 04             	sub    $0x4,%eax
  8006e3:	8b 00                	mov    (%eax),%eax
  8006e5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ea:	5d                   	pop    %ebp
  8006eb:	c3                   	ret    

008006ec <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006ec:	55                   	push   %ebp
  8006ed:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006ef:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006f3:	7e 1c                	jle    800711 <getint+0x25>
		return va_arg(*ap, long long);
  8006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	8d 50 08             	lea    0x8(%eax),%edx
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	89 10                	mov    %edx,(%eax)
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	8b 00                	mov    (%eax),%eax
  800707:	83 e8 08             	sub    $0x8,%eax
  80070a:	8b 50 04             	mov    0x4(%eax),%edx
  80070d:	8b 00                	mov    (%eax),%eax
  80070f:	eb 38                	jmp    800749 <getint+0x5d>
	else if (lflag)
  800711:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800715:	74 1a                	je     800731 <getint+0x45>
		return va_arg(*ap, long);
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	8d 50 04             	lea    0x4(%eax),%edx
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	89 10                	mov    %edx,(%eax)
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	8b 00                	mov    (%eax),%eax
  800729:	83 e8 04             	sub    $0x4,%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	99                   	cltd   
  80072f:	eb 18                	jmp    800749 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800731:	8b 45 08             	mov    0x8(%ebp),%eax
  800734:	8b 00                	mov    (%eax),%eax
  800736:	8d 50 04             	lea    0x4(%eax),%edx
  800739:	8b 45 08             	mov    0x8(%ebp),%eax
  80073c:	89 10                	mov    %edx,(%eax)
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	8b 00                	mov    (%eax),%eax
  800743:	83 e8 04             	sub    $0x4,%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	99                   	cltd   
}
  800749:	5d                   	pop    %ebp
  80074a:	c3                   	ret    

0080074b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80074b:	55                   	push   %ebp
  80074c:	89 e5                	mov    %esp,%ebp
  80074e:	56                   	push   %esi
  80074f:	53                   	push   %ebx
  800750:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800753:	eb 17                	jmp    80076c <vprintfmt+0x21>
			if (ch == '\0')
  800755:	85 db                	test   %ebx,%ebx
  800757:	0f 84 af 03 00 00    	je     800b0c <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	ff 75 0c             	pushl  0xc(%ebp)
  800763:	53                   	push   %ebx
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	ff d0                	call   *%eax
  800769:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80076c:	8b 45 10             	mov    0x10(%ebp),%eax
  80076f:	8d 50 01             	lea    0x1(%eax),%edx
  800772:	89 55 10             	mov    %edx,0x10(%ebp)
  800775:	8a 00                	mov    (%eax),%al
  800777:	0f b6 d8             	movzbl %al,%ebx
  80077a:	83 fb 25             	cmp    $0x25,%ebx
  80077d:	75 d6                	jne    800755 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80077f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800783:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80078a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800791:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800798:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80079f:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a2:	8d 50 01             	lea    0x1(%eax),%edx
  8007a5:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a8:	8a 00                	mov    (%eax),%al
  8007aa:	0f b6 d8             	movzbl %al,%ebx
  8007ad:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007b0:	83 f8 55             	cmp    $0x55,%eax
  8007b3:	0f 87 2b 03 00 00    	ja     800ae4 <vprintfmt+0x399>
  8007b9:	8b 04 85 d8 37 80 00 	mov    0x8037d8(,%eax,4),%eax
  8007c0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007c2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007c6:	eb d7                	jmp    80079f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007c8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007cc:	eb d1                	jmp    80079f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ce:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007d8:	89 d0                	mov    %edx,%eax
  8007da:	c1 e0 02             	shl    $0x2,%eax
  8007dd:	01 d0                	add    %edx,%eax
  8007df:	01 c0                	add    %eax,%eax
  8007e1:	01 d8                	add    %ebx,%eax
  8007e3:	83 e8 30             	sub    $0x30,%eax
  8007e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ec:	8a 00                	mov    (%eax),%al
  8007ee:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007f1:	83 fb 2f             	cmp    $0x2f,%ebx
  8007f4:	7e 3e                	jle    800834 <vprintfmt+0xe9>
  8007f6:	83 fb 39             	cmp    $0x39,%ebx
  8007f9:	7f 39                	jg     800834 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007fb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007fe:	eb d5                	jmp    8007d5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	83 c0 04             	add    $0x4,%eax
  800806:	89 45 14             	mov    %eax,0x14(%ebp)
  800809:	8b 45 14             	mov    0x14(%ebp),%eax
  80080c:	83 e8 04             	sub    $0x4,%eax
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800814:	eb 1f                	jmp    800835 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800816:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80081a:	79 83                	jns    80079f <vprintfmt+0x54>
				width = 0;
  80081c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800823:	e9 77 ff ff ff       	jmp    80079f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800828:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80082f:	e9 6b ff ff ff       	jmp    80079f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800834:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800835:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800839:	0f 89 60 ff ff ff    	jns    80079f <vprintfmt+0x54>
				width = precision, precision = -1;
  80083f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800842:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800845:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80084c:	e9 4e ff ff ff       	jmp    80079f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800851:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800854:	e9 46 ff ff ff       	jmp    80079f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	83 c0 04             	add    $0x4,%eax
  80085f:	89 45 14             	mov    %eax,0x14(%ebp)
  800862:	8b 45 14             	mov    0x14(%ebp),%eax
  800865:	83 e8 04             	sub    $0x4,%eax
  800868:	8b 00                	mov    (%eax),%eax
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	ff 75 0c             	pushl  0xc(%ebp)
  800870:	50                   	push   %eax
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	ff d0                	call   *%eax
  800876:	83 c4 10             	add    $0x10,%esp
			break;
  800879:	e9 89 02 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 c0 04             	add    $0x4,%eax
  800884:	89 45 14             	mov    %eax,0x14(%ebp)
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	83 e8 04             	sub    $0x4,%eax
  80088d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80088f:	85 db                	test   %ebx,%ebx
  800891:	79 02                	jns    800895 <vprintfmt+0x14a>
				err = -err;
  800893:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800895:	83 fb 64             	cmp    $0x64,%ebx
  800898:	7f 0b                	jg     8008a5 <vprintfmt+0x15a>
  80089a:	8b 34 9d 20 36 80 00 	mov    0x803620(,%ebx,4),%esi
  8008a1:	85 f6                	test   %esi,%esi
  8008a3:	75 19                	jne    8008be <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008a5:	53                   	push   %ebx
  8008a6:	68 c5 37 80 00       	push   $0x8037c5
  8008ab:	ff 75 0c             	pushl  0xc(%ebp)
  8008ae:	ff 75 08             	pushl  0x8(%ebp)
  8008b1:	e8 5e 02 00 00       	call   800b14 <printfmt>
  8008b6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b9:	e9 49 02 00 00       	jmp    800b07 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008be:	56                   	push   %esi
  8008bf:	68 ce 37 80 00       	push   $0x8037ce
  8008c4:	ff 75 0c             	pushl  0xc(%ebp)
  8008c7:	ff 75 08             	pushl  0x8(%ebp)
  8008ca:	e8 45 02 00 00       	call   800b14 <printfmt>
  8008cf:	83 c4 10             	add    $0x10,%esp
			break;
  8008d2:	e9 30 02 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	83 c0 04             	add    $0x4,%eax
  8008dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	83 e8 04             	sub    $0x4,%eax
  8008e6:	8b 30                	mov    (%eax),%esi
  8008e8:	85 f6                	test   %esi,%esi
  8008ea:	75 05                	jne    8008f1 <vprintfmt+0x1a6>
				p = "(null)";
  8008ec:	be d1 37 80 00       	mov    $0x8037d1,%esi
			if (width > 0 && padc != '-')
  8008f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f5:	7e 6d                	jle    800964 <vprintfmt+0x219>
  8008f7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008fb:	74 67                	je     800964 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800900:	83 ec 08             	sub    $0x8,%esp
  800903:	50                   	push   %eax
  800904:	56                   	push   %esi
  800905:	e8 0c 03 00 00       	call   800c16 <strnlen>
  80090a:	83 c4 10             	add    $0x10,%esp
  80090d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800910:	eb 16                	jmp    800928 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800912:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800916:	83 ec 08             	sub    $0x8,%esp
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	50                   	push   %eax
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	ff d0                	call   *%eax
  800922:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800925:	ff 4d e4             	decl   -0x1c(%ebp)
  800928:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80092c:	7f e4                	jg     800912 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80092e:	eb 34                	jmp    800964 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800930:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800934:	74 1c                	je     800952 <vprintfmt+0x207>
  800936:	83 fb 1f             	cmp    $0x1f,%ebx
  800939:	7e 05                	jle    800940 <vprintfmt+0x1f5>
  80093b:	83 fb 7e             	cmp    $0x7e,%ebx
  80093e:	7e 12                	jle    800952 <vprintfmt+0x207>
					putch('?', putdat);
  800940:	83 ec 08             	sub    $0x8,%esp
  800943:	ff 75 0c             	pushl  0xc(%ebp)
  800946:	6a 3f                	push   $0x3f
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	ff d0                	call   *%eax
  80094d:	83 c4 10             	add    $0x10,%esp
  800950:	eb 0f                	jmp    800961 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800952:	83 ec 08             	sub    $0x8,%esp
  800955:	ff 75 0c             	pushl  0xc(%ebp)
  800958:	53                   	push   %ebx
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	ff d0                	call   *%eax
  80095e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800961:	ff 4d e4             	decl   -0x1c(%ebp)
  800964:	89 f0                	mov    %esi,%eax
  800966:	8d 70 01             	lea    0x1(%eax),%esi
  800969:	8a 00                	mov    (%eax),%al
  80096b:	0f be d8             	movsbl %al,%ebx
  80096e:	85 db                	test   %ebx,%ebx
  800970:	74 24                	je     800996 <vprintfmt+0x24b>
  800972:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800976:	78 b8                	js     800930 <vprintfmt+0x1e5>
  800978:	ff 4d e0             	decl   -0x20(%ebp)
  80097b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80097f:	79 af                	jns    800930 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800981:	eb 13                	jmp    800996 <vprintfmt+0x24b>
				putch(' ', putdat);
  800983:	83 ec 08             	sub    $0x8,%esp
  800986:	ff 75 0c             	pushl  0xc(%ebp)
  800989:	6a 20                	push   $0x20
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	ff d0                	call   *%eax
  800990:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800993:	ff 4d e4             	decl   -0x1c(%ebp)
  800996:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80099a:	7f e7                	jg     800983 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80099c:	e9 66 01 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a7:	8d 45 14             	lea    0x14(%ebp),%eax
  8009aa:	50                   	push   %eax
  8009ab:	e8 3c fd ff ff       	call   8006ec <getint>
  8009b0:	83 c4 10             	add    $0x10,%esp
  8009b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009bf:	85 d2                	test   %edx,%edx
  8009c1:	79 23                	jns    8009e6 <vprintfmt+0x29b>
				putch('-', putdat);
  8009c3:	83 ec 08             	sub    $0x8,%esp
  8009c6:	ff 75 0c             	pushl  0xc(%ebp)
  8009c9:	6a 2d                	push   $0x2d
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	ff d0                	call   *%eax
  8009d0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d9:	f7 d8                	neg    %eax
  8009db:	83 d2 00             	adc    $0x0,%edx
  8009de:	f7 da                	neg    %edx
  8009e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009e6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009ed:	e9 bc 00 00 00       	jmp    800aae <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009f2:	83 ec 08             	sub    $0x8,%esp
  8009f5:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009fb:	50                   	push   %eax
  8009fc:	e8 84 fc ff ff       	call   800685 <getuint>
  800a01:	83 c4 10             	add    $0x10,%esp
  800a04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a07:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a0a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a11:	e9 98 00 00 00       	jmp    800aae <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a16:	83 ec 08             	sub    $0x8,%esp
  800a19:	ff 75 0c             	pushl  0xc(%ebp)
  800a1c:	6a 58                	push   $0x58
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	ff d0                	call   *%eax
  800a23:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a26:	83 ec 08             	sub    $0x8,%esp
  800a29:	ff 75 0c             	pushl  0xc(%ebp)
  800a2c:	6a 58                	push   $0x58
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	ff d0                	call   *%eax
  800a33:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a36:	83 ec 08             	sub    $0x8,%esp
  800a39:	ff 75 0c             	pushl  0xc(%ebp)
  800a3c:	6a 58                	push   $0x58
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	ff d0                	call   *%eax
  800a43:	83 c4 10             	add    $0x10,%esp
			break;
  800a46:	e9 bc 00 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a4b:	83 ec 08             	sub    $0x8,%esp
  800a4e:	ff 75 0c             	pushl  0xc(%ebp)
  800a51:	6a 30                	push   $0x30
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	ff d0                	call   *%eax
  800a58:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	ff 75 0c             	pushl  0xc(%ebp)
  800a61:	6a 78                	push   $0x78
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	ff d0                	call   *%eax
  800a68:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6e:	83 c0 04             	add    $0x4,%eax
  800a71:	89 45 14             	mov    %eax,0x14(%ebp)
  800a74:	8b 45 14             	mov    0x14(%ebp),%eax
  800a77:	83 e8 04             	sub    $0x4,%eax
  800a7a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a86:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a8d:	eb 1f                	jmp    800aae <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a8f:	83 ec 08             	sub    $0x8,%esp
  800a92:	ff 75 e8             	pushl  -0x18(%ebp)
  800a95:	8d 45 14             	lea    0x14(%ebp),%eax
  800a98:	50                   	push   %eax
  800a99:	e8 e7 fb ff ff       	call   800685 <getuint>
  800a9e:	83 c4 10             	add    $0x10,%esp
  800aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aa7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aae:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ab2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ab5:	83 ec 04             	sub    $0x4,%esp
  800ab8:	52                   	push   %edx
  800ab9:	ff 75 e4             	pushl  -0x1c(%ebp)
  800abc:	50                   	push   %eax
  800abd:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac0:	ff 75 f0             	pushl  -0x10(%ebp)
  800ac3:	ff 75 0c             	pushl  0xc(%ebp)
  800ac6:	ff 75 08             	pushl  0x8(%ebp)
  800ac9:	e8 00 fb ff ff       	call   8005ce <printnum>
  800ace:	83 c4 20             	add    $0x20,%esp
			break;
  800ad1:	eb 34                	jmp    800b07 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	53                   	push   %ebx
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	ff d0                	call   *%eax
  800adf:	83 c4 10             	add    $0x10,%esp
			break;
  800ae2:	eb 23                	jmp    800b07 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	6a 25                	push   $0x25
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	ff d0                	call   *%eax
  800af1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800af4:	ff 4d 10             	decl   0x10(%ebp)
  800af7:	eb 03                	jmp    800afc <vprintfmt+0x3b1>
  800af9:	ff 4d 10             	decl   0x10(%ebp)
  800afc:	8b 45 10             	mov    0x10(%ebp),%eax
  800aff:	48                   	dec    %eax
  800b00:	8a 00                	mov    (%eax),%al
  800b02:	3c 25                	cmp    $0x25,%al
  800b04:	75 f3                	jne    800af9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b06:	90                   	nop
		}
	}
  800b07:	e9 47 fc ff ff       	jmp    800753 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b0c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b10:	5b                   	pop    %ebx
  800b11:	5e                   	pop    %esi
  800b12:	5d                   	pop    %ebp
  800b13:	c3                   	ret    

00800b14 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b1a:	8d 45 10             	lea    0x10(%ebp),%eax
  800b1d:	83 c0 04             	add    $0x4,%eax
  800b20:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b23:	8b 45 10             	mov    0x10(%ebp),%eax
  800b26:	ff 75 f4             	pushl  -0xc(%ebp)
  800b29:	50                   	push   %eax
  800b2a:	ff 75 0c             	pushl  0xc(%ebp)
  800b2d:	ff 75 08             	pushl  0x8(%ebp)
  800b30:	e8 16 fc ff ff       	call   80074b <vprintfmt>
  800b35:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b38:	90                   	nop
  800b39:	c9                   	leave  
  800b3a:	c3                   	ret    

00800b3b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b41:	8b 40 08             	mov    0x8(%eax),%eax
  800b44:	8d 50 01             	lea    0x1(%eax),%edx
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b50:	8b 10                	mov    (%eax),%edx
  800b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b55:	8b 40 04             	mov    0x4(%eax),%eax
  800b58:	39 c2                	cmp    %eax,%edx
  800b5a:	73 12                	jae    800b6e <sprintputch+0x33>
		*b->buf++ = ch;
  800b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5f:	8b 00                	mov    (%eax),%eax
  800b61:	8d 48 01             	lea    0x1(%eax),%ecx
  800b64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b67:	89 0a                	mov    %ecx,(%edx)
  800b69:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6c:	88 10                	mov    %dl,(%eax)
}
  800b6e:	90                   	nop
  800b6f:	5d                   	pop    %ebp
  800b70:	c3                   	ret    

00800b71 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b80:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	01 d0                	add    %edx,%eax
  800b88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b96:	74 06                	je     800b9e <vsnprintf+0x2d>
  800b98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9c:	7f 07                	jg     800ba5 <vsnprintf+0x34>
		return -E_INVAL;
  800b9e:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba3:	eb 20                	jmp    800bc5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ba5:	ff 75 14             	pushl  0x14(%ebp)
  800ba8:	ff 75 10             	pushl  0x10(%ebp)
  800bab:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bae:	50                   	push   %eax
  800baf:	68 3b 0b 80 00       	push   $0x800b3b
  800bb4:	e8 92 fb ff ff       	call   80074b <vprintfmt>
  800bb9:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bbf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bc5:	c9                   	leave  
  800bc6:	c3                   	ret    

00800bc7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bc7:	55                   	push   %ebp
  800bc8:	89 e5                	mov    %esp,%ebp
  800bca:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bcd:	8d 45 10             	lea    0x10(%ebp),%eax
  800bd0:	83 c0 04             	add    $0x4,%eax
  800bd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bdc:	50                   	push   %eax
  800bdd:	ff 75 0c             	pushl  0xc(%ebp)
  800be0:	ff 75 08             	pushl  0x8(%ebp)
  800be3:	e8 89 ff ff ff       	call   800b71 <vsnprintf>
  800be8:	83 c4 10             	add    $0x10,%esp
  800beb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bf1:	c9                   	leave  
  800bf2:	c3                   	ret    

00800bf3 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c00:	eb 06                	jmp    800c08 <strlen+0x15>
		n++;
  800c02:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c05:	ff 45 08             	incl   0x8(%ebp)
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	8a 00                	mov    (%eax),%al
  800c0d:	84 c0                	test   %al,%al
  800c0f:	75 f1                	jne    800c02 <strlen+0xf>
		n++;
	return n;
  800c11:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c14:	c9                   	leave  
  800c15:	c3                   	ret    

00800c16 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c23:	eb 09                	jmp    800c2e <strnlen+0x18>
		n++;
  800c25:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c28:	ff 45 08             	incl   0x8(%ebp)
  800c2b:	ff 4d 0c             	decl   0xc(%ebp)
  800c2e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c32:	74 09                	je     800c3d <strnlen+0x27>
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	75 e8                	jne    800c25 <strnlen+0xf>
		n++;
	return n;
  800c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c4e:	90                   	nop
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	8d 50 01             	lea    0x1(%eax),%edx
  800c55:	89 55 08             	mov    %edx,0x8(%ebp)
  800c58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c5e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c61:	8a 12                	mov    (%edx),%dl
  800c63:	88 10                	mov    %dl,(%eax)
  800c65:	8a 00                	mov    (%eax),%al
  800c67:	84 c0                	test   %al,%al
  800c69:	75 e4                	jne    800c4f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    

00800c70 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c83:	eb 1f                	jmp    800ca4 <strncpy+0x34>
		*dst++ = *src;
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	8d 50 01             	lea    0x1(%eax),%edx
  800c8b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c91:	8a 12                	mov    (%edx),%dl
  800c93:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c98:	8a 00                	mov    (%eax),%al
  800c9a:	84 c0                	test   %al,%al
  800c9c:	74 03                	je     800ca1 <strncpy+0x31>
			src++;
  800c9e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ca1:	ff 45 fc             	incl   -0x4(%ebp)
  800ca4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca7:	3b 45 10             	cmp    0x10(%ebp),%eax
  800caa:	72 d9                	jb     800c85 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cac:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800caf:	c9                   	leave  
  800cb0:	c3                   	ret    

00800cb1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc1:	74 30                	je     800cf3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cc3:	eb 16                	jmp    800cdb <strlcpy+0x2a>
			*dst++ = *src++;
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	8d 50 01             	lea    0x1(%eax),%edx
  800ccb:	89 55 08             	mov    %edx,0x8(%ebp)
  800cce:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd7:	8a 12                	mov    (%edx),%dl
  800cd9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cdb:	ff 4d 10             	decl   0x10(%ebp)
  800cde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce2:	74 09                	je     800ced <strlcpy+0x3c>
  800ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce7:	8a 00                	mov    (%eax),%al
  800ce9:	84 c0                	test   %al,%al
  800ceb:	75 d8                	jne    800cc5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cf3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf9:	29 c2                	sub    %eax,%edx
  800cfb:	89 d0                	mov    %edx,%eax
}
  800cfd:	c9                   	leave  
  800cfe:	c3                   	ret    

00800cff <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d02:	eb 06                	jmp    800d0a <strcmp+0xb>
		p++, q++;
  800d04:	ff 45 08             	incl   0x8(%ebp)
  800d07:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	8a 00                	mov    (%eax),%al
  800d0f:	84 c0                	test   %al,%al
  800d11:	74 0e                	je     800d21 <strcmp+0x22>
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	8a 10                	mov    (%eax),%dl
  800d18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1b:	8a 00                	mov    (%eax),%al
  800d1d:	38 c2                	cmp    %al,%dl
  800d1f:	74 e3                	je     800d04 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8a 00                	mov    (%eax),%al
  800d26:	0f b6 d0             	movzbl %al,%edx
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	0f b6 c0             	movzbl %al,%eax
  800d31:	29 c2                	sub    %eax,%edx
  800d33:	89 d0                	mov    %edx,%eax
}
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    

00800d37 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d3a:	eb 09                	jmp    800d45 <strncmp+0xe>
		n--, p++, q++;
  800d3c:	ff 4d 10             	decl   0x10(%ebp)
  800d3f:	ff 45 08             	incl   0x8(%ebp)
  800d42:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d49:	74 17                	je     800d62 <strncmp+0x2b>
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8a 00                	mov    (%eax),%al
  800d50:	84 c0                	test   %al,%al
  800d52:	74 0e                	je     800d62 <strncmp+0x2b>
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	8a 10                	mov    (%eax),%dl
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	38 c2                	cmp    %al,%dl
  800d60:	74 da                	je     800d3c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d66:	75 07                	jne    800d6f <strncmp+0x38>
		return 0;
  800d68:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6d:	eb 14                	jmp    800d83 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	8a 00                	mov    (%eax),%al
  800d74:	0f b6 d0             	movzbl %al,%edx
  800d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	0f b6 c0             	movzbl %al,%eax
  800d7f:	29 c2                	sub    %eax,%edx
  800d81:	89 d0                	mov    %edx,%eax
}
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    

00800d85 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	83 ec 04             	sub    $0x4,%esp
  800d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d91:	eb 12                	jmp    800da5 <strchr+0x20>
		if (*s == c)
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8a 00                	mov    (%eax),%al
  800d98:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d9b:	75 05                	jne    800da2 <strchr+0x1d>
			return (char *) s;
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	eb 11                	jmp    800db3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800da2:	ff 45 08             	incl   0x8(%ebp)
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	8a 00                	mov    (%eax),%al
  800daa:	84 c0                	test   %al,%al
  800dac:	75 e5                	jne    800d93 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800db3:	c9                   	leave  
  800db4:	c3                   	ret    

00800db5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	83 ec 04             	sub    $0x4,%esp
  800dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbe:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dc1:	eb 0d                	jmp    800dd0 <strfind+0x1b>
		if (*s == c)
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	8a 00                	mov    (%eax),%al
  800dc8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dcb:	74 0e                	je     800ddb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dcd:	ff 45 08             	incl   0x8(%ebp)
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	8a 00                	mov    (%eax),%al
  800dd5:	84 c0                	test   %al,%al
  800dd7:	75 ea                	jne    800dc3 <strfind+0xe>
  800dd9:	eb 01                	jmp    800ddc <strfind+0x27>
		if (*s == c)
			break;
  800ddb:	90                   	nop
	return (char *) s;
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ded:	8b 45 10             	mov    0x10(%ebp),%eax
  800df0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800df3:	eb 0e                	jmp    800e03 <memset+0x22>
		*p++ = c;
  800df5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df8:	8d 50 01             	lea    0x1(%eax),%edx
  800dfb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e01:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e03:	ff 4d f8             	decl   -0x8(%ebp)
  800e06:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e0a:	79 e9                	jns    800df5 <memset+0x14>
		*p++ = c;

	return v;
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0f:	c9                   	leave  
  800e10:	c3                   	ret    

00800e11 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
  800e14:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e23:	eb 16                	jmp    800e3b <memcpy+0x2a>
		*d++ = *s++;
  800e25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e28:	8d 50 01             	lea    0x1(%eax),%edx
  800e2b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e31:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e34:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e37:	8a 12                	mov    (%edx),%dl
  800e39:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e41:	89 55 10             	mov    %edx,0x10(%ebp)
  800e44:	85 c0                	test   %eax,%eax
  800e46:	75 dd                	jne    800e25 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4b:	c9                   	leave  
  800e4c:	c3                   	ret    

00800e4d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e62:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e65:	73 50                	jae    800eb7 <memmove+0x6a>
  800e67:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6d:	01 d0                	add    %edx,%eax
  800e6f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e72:	76 43                	jbe    800eb7 <memmove+0x6a>
		s += n;
  800e74:	8b 45 10             	mov    0x10(%ebp),%eax
  800e77:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e80:	eb 10                	jmp    800e92 <memmove+0x45>
			*--d = *--s;
  800e82:	ff 4d f8             	decl   -0x8(%ebp)
  800e85:	ff 4d fc             	decl   -0x4(%ebp)
  800e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8b:	8a 10                	mov    (%eax),%dl
  800e8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e90:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e92:	8b 45 10             	mov    0x10(%ebp),%eax
  800e95:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e98:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9b:	85 c0                	test   %eax,%eax
  800e9d:	75 e3                	jne    800e82 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e9f:	eb 23                	jmp    800ec4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ea1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea4:	8d 50 01             	lea    0x1(%eax),%edx
  800ea7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eaa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ead:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eb3:	8a 12                	mov    (%edx),%dl
  800eb5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eba:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebd:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec0:	85 c0                	test   %eax,%eax
  800ec2:	75 dd                	jne    800ea1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec7:	c9                   	leave  
  800ec8:	c3                   	ret    

00800ec9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800edb:	eb 2a                	jmp    800f07 <memcmp+0x3e>
		if (*s1 != *s2)
  800edd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee0:	8a 10                	mov    (%eax),%dl
  800ee2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	38 c2                	cmp    %al,%dl
  800ee9:	74 16                	je     800f01 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eee:	8a 00                	mov    (%eax),%al
  800ef0:	0f b6 d0             	movzbl %al,%edx
  800ef3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	0f b6 c0             	movzbl %al,%eax
  800efb:	29 c2                	sub    %eax,%edx
  800efd:	89 d0                	mov    %edx,%eax
  800eff:	eb 18                	jmp    800f19 <memcmp+0x50>
		s1++, s2++;
  800f01:	ff 45 fc             	incl   -0x4(%ebp)
  800f04:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f07:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f0d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f10:	85 c0                	test   %eax,%eax
  800f12:	75 c9                	jne    800edd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f19:	c9                   	leave  
  800f1a:	c3                   	ret    

00800f1b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f21:	8b 55 08             	mov    0x8(%ebp),%edx
  800f24:	8b 45 10             	mov    0x10(%ebp),%eax
  800f27:	01 d0                	add    %edx,%eax
  800f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f2c:	eb 15                	jmp    800f43 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	0f b6 d0             	movzbl %al,%edx
  800f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f39:	0f b6 c0             	movzbl %al,%eax
  800f3c:	39 c2                	cmp    %eax,%edx
  800f3e:	74 0d                	je     800f4d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f40:	ff 45 08             	incl   0x8(%ebp)
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f49:	72 e3                	jb     800f2e <memfind+0x13>
  800f4b:	eb 01                	jmp    800f4e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f4d:	90                   	nop
	return (void *) s;
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f51:	c9                   	leave  
  800f52:	c3                   	ret    

00800f53 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f60:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f67:	eb 03                	jmp    800f6c <strtol+0x19>
		s++;
  800f69:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	3c 20                	cmp    $0x20,%al
  800f73:	74 f4                	je     800f69 <strtol+0x16>
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	8a 00                	mov    (%eax),%al
  800f7a:	3c 09                	cmp    $0x9,%al
  800f7c:	74 eb                	je     800f69 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	3c 2b                	cmp    $0x2b,%al
  800f85:	75 05                	jne    800f8c <strtol+0x39>
		s++;
  800f87:	ff 45 08             	incl   0x8(%ebp)
  800f8a:	eb 13                	jmp    800f9f <strtol+0x4c>
	else if (*s == '-')
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	8a 00                	mov    (%eax),%al
  800f91:	3c 2d                	cmp    $0x2d,%al
  800f93:	75 0a                	jne    800f9f <strtol+0x4c>
		s++, neg = 1;
  800f95:	ff 45 08             	incl   0x8(%ebp)
  800f98:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa3:	74 06                	je     800fab <strtol+0x58>
  800fa5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fa9:	75 20                	jne    800fcb <strtol+0x78>
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	3c 30                	cmp    $0x30,%al
  800fb2:	75 17                	jne    800fcb <strtol+0x78>
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	40                   	inc    %eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3c 78                	cmp    $0x78,%al
  800fbc:	75 0d                	jne    800fcb <strtol+0x78>
		s += 2, base = 16;
  800fbe:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fc2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fc9:	eb 28                	jmp    800ff3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fcf:	75 15                	jne    800fe6 <strtol+0x93>
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	3c 30                	cmp    $0x30,%al
  800fd8:	75 0c                	jne    800fe6 <strtol+0x93>
		s++, base = 8;
  800fda:	ff 45 08             	incl   0x8(%ebp)
  800fdd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fe4:	eb 0d                	jmp    800ff3 <strtol+0xa0>
	else if (base == 0)
  800fe6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fea:	75 07                	jne    800ff3 <strtol+0xa0>
		base = 10;
  800fec:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	8a 00                	mov    (%eax),%al
  800ff8:	3c 2f                	cmp    $0x2f,%al
  800ffa:	7e 19                	jle    801015 <strtol+0xc2>
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 39                	cmp    $0x39,%al
  801003:	7f 10                	jg     801015 <strtol+0xc2>
			dig = *s - '0';
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	0f be c0             	movsbl %al,%eax
  80100d:	83 e8 30             	sub    $0x30,%eax
  801010:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801013:	eb 42                	jmp    801057 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8a 00                	mov    (%eax),%al
  80101a:	3c 60                	cmp    $0x60,%al
  80101c:	7e 19                	jle    801037 <strtol+0xe4>
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	3c 7a                	cmp    $0x7a,%al
  801025:	7f 10                	jg     801037 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	8a 00                	mov    (%eax),%al
  80102c:	0f be c0             	movsbl %al,%eax
  80102f:	83 e8 57             	sub    $0x57,%eax
  801032:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801035:	eb 20                	jmp    801057 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	3c 40                	cmp    $0x40,%al
  80103e:	7e 39                	jle    801079 <strtol+0x126>
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	3c 5a                	cmp    $0x5a,%al
  801047:	7f 30                	jg     801079 <strtol+0x126>
			dig = *s - 'A' + 10;
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	0f be c0             	movsbl %al,%eax
  801051:	83 e8 37             	sub    $0x37,%eax
  801054:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80105a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80105d:	7d 19                	jge    801078 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80105f:	ff 45 08             	incl   0x8(%ebp)
  801062:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801065:	0f af 45 10          	imul   0x10(%ebp),%eax
  801069:	89 c2                	mov    %eax,%edx
  80106b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106e:	01 d0                	add    %edx,%eax
  801070:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801073:	e9 7b ff ff ff       	jmp    800ff3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801078:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801079:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80107d:	74 08                	je     801087 <strtol+0x134>
		*endptr = (char *) s;
  80107f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801082:	8b 55 08             	mov    0x8(%ebp),%edx
  801085:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801087:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80108b:	74 07                	je     801094 <strtol+0x141>
  80108d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801090:	f7 d8                	neg    %eax
  801092:	eb 03                	jmp    801097 <strtol+0x144>
  801094:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801097:	c9                   	leave  
  801098:	c3                   	ret    

00801099 <ltostr>:

void
ltostr(long value, char *str)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80109f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010b1:	79 13                	jns    8010c6 <ltostr+0x2d>
	{
		neg = 1;
  8010b3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010c0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010c3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010ce:	99                   	cltd   
  8010cf:	f7 f9                	idiv   %ecx
  8010d1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d7:	8d 50 01             	lea    0x1(%eax),%edx
  8010da:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010dd:	89 c2                	mov    %eax,%edx
  8010df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e2:	01 d0                	add    %edx,%eax
  8010e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010e7:	83 c2 30             	add    $0x30,%edx
  8010ea:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ef:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010f4:	f7 e9                	imul   %ecx
  8010f6:	c1 fa 02             	sar    $0x2,%edx
  8010f9:	89 c8                	mov    %ecx,%eax
  8010fb:	c1 f8 1f             	sar    $0x1f,%eax
  8010fe:	29 c2                	sub    %eax,%edx
  801100:	89 d0                	mov    %edx,%eax
  801102:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801105:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801108:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80110d:	f7 e9                	imul   %ecx
  80110f:	c1 fa 02             	sar    $0x2,%edx
  801112:	89 c8                	mov    %ecx,%eax
  801114:	c1 f8 1f             	sar    $0x1f,%eax
  801117:	29 c2                	sub    %eax,%edx
  801119:	89 d0                	mov    %edx,%eax
  80111b:	c1 e0 02             	shl    $0x2,%eax
  80111e:	01 d0                	add    %edx,%eax
  801120:	01 c0                	add    %eax,%eax
  801122:	29 c1                	sub    %eax,%ecx
  801124:	89 ca                	mov    %ecx,%edx
  801126:	85 d2                	test   %edx,%edx
  801128:	75 9c                	jne    8010c6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80112a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801131:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801134:	48                   	dec    %eax
  801135:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801138:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80113c:	74 3d                	je     80117b <ltostr+0xe2>
		start = 1 ;
  80113e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801145:	eb 34                	jmp    80117b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801147:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80114a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114d:	01 d0                	add    %edx,%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801154:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115a:	01 c2                	add    %eax,%edx
  80115c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80115f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801162:	01 c8                	add    %ecx,%eax
  801164:	8a 00                	mov    (%eax),%al
  801166:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801168:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	01 c2                	add    %eax,%edx
  801170:	8a 45 eb             	mov    -0x15(%ebp),%al
  801173:	88 02                	mov    %al,(%edx)
		start++ ;
  801175:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801178:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80117b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80117e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801181:	7c c4                	jl     801147 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801183:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801186:	8b 45 0c             	mov    0xc(%ebp),%eax
  801189:	01 d0                	add    %edx,%eax
  80118b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80118e:	90                   	nop
  80118f:	c9                   	leave  
  801190:	c3                   	ret    

00801191 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
  801194:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801197:	ff 75 08             	pushl  0x8(%ebp)
  80119a:	e8 54 fa ff ff       	call   800bf3 <strlen>
  80119f:	83 c4 04             	add    $0x4,%esp
  8011a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011a5:	ff 75 0c             	pushl  0xc(%ebp)
  8011a8:	e8 46 fa ff ff       	call   800bf3 <strlen>
  8011ad:	83 c4 04             	add    $0x4,%esp
  8011b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011c1:	eb 17                	jmp    8011da <strcconcat+0x49>
		final[s] = str1[s] ;
  8011c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c9:	01 c2                	add    %eax,%edx
  8011cb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d1:	01 c8                	add    %ecx,%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011d7:	ff 45 fc             	incl   -0x4(%ebp)
  8011da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011e0:	7c e1                	jl     8011c3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011e9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011f0:	eb 1f                	jmp    801211 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f5:	8d 50 01             	lea    0x1(%eax),%edx
  8011f8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011fb:	89 c2                	mov    %eax,%edx
  8011fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801200:	01 c2                	add    %eax,%edx
  801202:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801205:	8b 45 0c             	mov    0xc(%ebp),%eax
  801208:	01 c8                	add    %ecx,%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80120e:	ff 45 f8             	incl   -0x8(%ebp)
  801211:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801214:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801217:	7c d9                	jl     8011f2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801219:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80121c:	8b 45 10             	mov    0x10(%ebp),%eax
  80121f:	01 d0                	add    %edx,%eax
  801221:	c6 00 00             	movb   $0x0,(%eax)
}
  801224:	90                   	nop
  801225:	c9                   	leave  
  801226:	c3                   	ret    

00801227 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801227:	55                   	push   %ebp
  801228:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80122a:	8b 45 14             	mov    0x14(%ebp),%eax
  80122d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801233:	8b 45 14             	mov    0x14(%ebp),%eax
  801236:	8b 00                	mov    (%eax),%eax
  801238:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80123f:	8b 45 10             	mov    0x10(%ebp),%eax
  801242:	01 d0                	add    %edx,%eax
  801244:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80124a:	eb 0c                	jmp    801258 <strsplit+0x31>
			*string++ = 0;
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8d 50 01             	lea    0x1(%eax),%edx
  801252:	89 55 08             	mov    %edx,0x8(%ebp)
  801255:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	84 c0                	test   %al,%al
  80125f:	74 18                	je     801279 <strsplit+0x52>
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	8a 00                	mov    (%eax),%al
  801266:	0f be c0             	movsbl %al,%eax
  801269:	50                   	push   %eax
  80126a:	ff 75 0c             	pushl  0xc(%ebp)
  80126d:	e8 13 fb ff ff       	call   800d85 <strchr>
  801272:	83 c4 08             	add    $0x8,%esp
  801275:	85 c0                	test   %eax,%eax
  801277:	75 d3                	jne    80124c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	84 c0                	test   %al,%al
  801280:	74 5a                	je     8012dc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801282:	8b 45 14             	mov    0x14(%ebp),%eax
  801285:	8b 00                	mov    (%eax),%eax
  801287:	83 f8 0f             	cmp    $0xf,%eax
  80128a:	75 07                	jne    801293 <strsplit+0x6c>
		{
			return 0;
  80128c:	b8 00 00 00 00       	mov    $0x0,%eax
  801291:	eb 66                	jmp    8012f9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	8d 48 01             	lea    0x1(%eax),%ecx
  80129b:	8b 55 14             	mov    0x14(%ebp),%edx
  80129e:	89 0a                	mov    %ecx,(%edx)
  8012a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012aa:	01 c2                	add    %eax,%edx
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012b1:	eb 03                	jmp    8012b6 <strsplit+0x8f>
			string++;
  8012b3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	8a 00                	mov    (%eax),%al
  8012bb:	84 c0                	test   %al,%al
  8012bd:	74 8b                	je     80124a <strsplit+0x23>
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	8a 00                	mov    (%eax),%al
  8012c4:	0f be c0             	movsbl %al,%eax
  8012c7:	50                   	push   %eax
  8012c8:	ff 75 0c             	pushl  0xc(%ebp)
  8012cb:	e8 b5 fa ff ff       	call   800d85 <strchr>
  8012d0:	83 c4 08             	add    $0x8,%esp
  8012d3:	85 c0                	test   %eax,%eax
  8012d5:	74 dc                	je     8012b3 <strsplit+0x8c>
			string++;
	}
  8012d7:	e9 6e ff ff ff       	jmp    80124a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012dc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e0:	8b 00                	mov    (%eax),%eax
  8012e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ec:	01 d0                	add    %edx,%eax
  8012ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012f4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    

008012fb <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801301:	a1 04 40 80 00       	mov    0x804004,%eax
  801306:	85 c0                	test   %eax,%eax
  801308:	74 1f                	je     801329 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80130a:	e8 1d 00 00 00       	call   80132c <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80130f:	83 ec 0c             	sub    $0xc,%esp
  801312:	68 30 39 80 00       	push   $0x803930
  801317:	e8 55 f2 ff ff       	call   800571 <cprintf>
  80131c:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80131f:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801326:	00 00 00 
	}
}
  801329:	90                   	nop
  80132a:	c9                   	leave  
  80132b:	c3                   	ret    

0080132c <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801332:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801339:	00 00 00 
  80133c:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801343:	00 00 00 
  801346:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80134d:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801350:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801357:	00 00 00 
  80135a:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801361:	00 00 00 
  801364:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80136b:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  80136e:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801375:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801378:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80137f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801382:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801387:	2d 00 10 00 00       	sub    $0x1000,%eax
  80138c:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  801391:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801398:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80139b:	a1 20 41 80 00       	mov    0x804120,%eax
  8013a0:	0f af c2             	imul   %edx,%eax
  8013a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  8013a6:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8013ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013b3:	01 d0                	add    %edx,%eax
  8013b5:	48                   	dec    %eax
  8013b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8013b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c1:	f7 75 e8             	divl   -0x18(%ebp)
  8013c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013c7:	29 d0                	sub    %edx,%eax
  8013c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  8013cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013cf:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  8013d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013d9:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8013df:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8013e5:	83 ec 04             	sub    $0x4,%esp
  8013e8:	6a 06                	push   $0x6
  8013ea:	50                   	push   %eax
  8013eb:	52                   	push   %edx
  8013ec:	e8 a1 05 00 00       	call   801992 <sys_allocate_chunk>
  8013f1:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013f4:	a1 20 41 80 00       	mov    0x804120,%eax
  8013f9:	83 ec 0c             	sub    $0xc,%esp
  8013fc:	50                   	push   %eax
  8013fd:	e8 16 0c 00 00       	call   802018 <initialize_MemBlocksList>
  801402:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801405:	a1 4c 41 80 00       	mov    0x80414c,%eax
  80140a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  80140d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801411:	75 14                	jne    801427 <initialize_dyn_block_system+0xfb>
  801413:	83 ec 04             	sub    $0x4,%esp
  801416:	68 55 39 80 00       	push   $0x803955
  80141b:	6a 2d                	push   $0x2d
  80141d:	68 73 39 80 00       	push   $0x803973
  801422:	e8 96 ee ff ff       	call   8002bd <_panic>
  801427:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80142a:	8b 00                	mov    (%eax),%eax
  80142c:	85 c0                	test   %eax,%eax
  80142e:	74 10                	je     801440 <initialize_dyn_block_system+0x114>
  801430:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801433:	8b 00                	mov    (%eax),%eax
  801435:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801438:	8b 52 04             	mov    0x4(%edx),%edx
  80143b:	89 50 04             	mov    %edx,0x4(%eax)
  80143e:	eb 0b                	jmp    80144b <initialize_dyn_block_system+0x11f>
  801440:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801443:	8b 40 04             	mov    0x4(%eax),%eax
  801446:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80144b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80144e:	8b 40 04             	mov    0x4(%eax),%eax
  801451:	85 c0                	test   %eax,%eax
  801453:	74 0f                	je     801464 <initialize_dyn_block_system+0x138>
  801455:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801458:	8b 40 04             	mov    0x4(%eax),%eax
  80145b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80145e:	8b 12                	mov    (%edx),%edx
  801460:	89 10                	mov    %edx,(%eax)
  801462:	eb 0a                	jmp    80146e <initialize_dyn_block_system+0x142>
  801464:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801467:	8b 00                	mov    (%eax),%eax
  801469:	a3 48 41 80 00       	mov    %eax,0x804148
  80146e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801471:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801477:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80147a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801481:	a1 54 41 80 00       	mov    0x804154,%eax
  801486:	48                   	dec    %eax
  801487:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  80148c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80148f:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801496:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801499:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  8014a0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8014a4:	75 14                	jne    8014ba <initialize_dyn_block_system+0x18e>
  8014a6:	83 ec 04             	sub    $0x4,%esp
  8014a9:	68 80 39 80 00       	push   $0x803980
  8014ae:	6a 30                	push   $0x30
  8014b0:	68 73 39 80 00       	push   $0x803973
  8014b5:	e8 03 ee ff ff       	call   8002bd <_panic>
  8014ba:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8014c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014c3:	89 50 04             	mov    %edx,0x4(%eax)
  8014c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014c9:	8b 40 04             	mov    0x4(%eax),%eax
  8014cc:	85 c0                	test   %eax,%eax
  8014ce:	74 0c                	je     8014dc <initialize_dyn_block_system+0x1b0>
  8014d0:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8014d5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014d8:	89 10                	mov    %edx,(%eax)
  8014da:	eb 08                	jmp    8014e4 <initialize_dyn_block_system+0x1b8>
  8014dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014df:	a3 38 41 80 00       	mov    %eax,0x804138
  8014e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014e7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8014ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014f5:	a1 44 41 80 00       	mov    0x804144,%eax
  8014fa:	40                   	inc    %eax
  8014fb:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801500:	90                   	nop
  801501:	c9                   	leave  
  801502:	c3                   	ret    

00801503 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
  801506:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801509:	e8 ed fd ff ff       	call   8012fb <InitializeUHeap>
	if (size == 0) return NULL ;
  80150e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801512:	75 07                	jne    80151b <malloc+0x18>
  801514:	b8 00 00 00 00       	mov    $0x0,%eax
  801519:	eb 67                	jmp    801582 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  80151b:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801522:	8b 55 08             	mov    0x8(%ebp),%edx
  801525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801528:	01 d0                	add    %edx,%eax
  80152a:	48                   	dec    %eax
  80152b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80152e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801531:	ba 00 00 00 00       	mov    $0x0,%edx
  801536:	f7 75 f4             	divl   -0xc(%ebp)
  801539:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153c:	29 d0                	sub    %edx,%eax
  80153e:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801541:	e8 1a 08 00 00       	call   801d60 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801546:	85 c0                	test   %eax,%eax
  801548:	74 33                	je     80157d <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  80154a:	83 ec 0c             	sub    $0xc,%esp
  80154d:	ff 75 08             	pushl  0x8(%ebp)
  801550:	e8 0c 0e 00 00       	call   802361 <alloc_block_FF>
  801555:	83 c4 10             	add    $0x10,%esp
  801558:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  80155b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80155f:	74 1c                	je     80157d <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801561:	83 ec 0c             	sub    $0xc,%esp
  801564:	ff 75 ec             	pushl  -0x14(%ebp)
  801567:	e8 07 0c 00 00       	call   802173 <insert_sorted_allocList>
  80156c:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  80156f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801572:	8b 40 08             	mov    0x8(%eax),%eax
  801575:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801578:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80157b:	eb 05                	jmp    801582 <malloc+0x7f>
		}
	}
	return NULL;
  80157d:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801582:	c9                   	leave  
  801583:	c3                   	ret    

00801584 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  80158a:	8b 45 08             	mov    0x8(%ebp),%eax
  80158d:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801590:	83 ec 08             	sub    $0x8,%esp
  801593:	ff 75 f4             	pushl  -0xc(%ebp)
  801596:	68 40 40 80 00       	push   $0x804040
  80159b:	e8 5b 0b 00 00       	call   8020fb <find_block>
  8015a0:	83 c4 10             	add    $0x10,%esp
  8015a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  8015a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ac:	83 ec 08             	sub    $0x8,%esp
  8015af:	50                   	push   %eax
  8015b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8015b3:	e8 a2 03 00 00       	call   80195a <sys_free_user_mem>
  8015b8:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  8015bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015bf:	75 14                	jne    8015d5 <free+0x51>
  8015c1:	83 ec 04             	sub    $0x4,%esp
  8015c4:	68 55 39 80 00       	push   $0x803955
  8015c9:	6a 76                	push   $0x76
  8015cb:	68 73 39 80 00       	push   $0x803973
  8015d0:	e8 e8 ec ff ff       	call   8002bd <_panic>
  8015d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d8:	8b 00                	mov    (%eax),%eax
  8015da:	85 c0                	test   %eax,%eax
  8015dc:	74 10                	je     8015ee <free+0x6a>
  8015de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e1:	8b 00                	mov    (%eax),%eax
  8015e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015e6:	8b 52 04             	mov    0x4(%edx),%edx
  8015e9:	89 50 04             	mov    %edx,0x4(%eax)
  8015ec:	eb 0b                	jmp    8015f9 <free+0x75>
  8015ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f1:	8b 40 04             	mov    0x4(%eax),%eax
  8015f4:	a3 44 40 80 00       	mov    %eax,0x804044
  8015f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fc:	8b 40 04             	mov    0x4(%eax),%eax
  8015ff:	85 c0                	test   %eax,%eax
  801601:	74 0f                	je     801612 <free+0x8e>
  801603:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801606:	8b 40 04             	mov    0x4(%eax),%eax
  801609:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80160c:	8b 12                	mov    (%edx),%edx
  80160e:	89 10                	mov    %edx,(%eax)
  801610:	eb 0a                	jmp    80161c <free+0x98>
  801612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801615:	8b 00                	mov    (%eax),%eax
  801617:	a3 40 40 80 00       	mov    %eax,0x804040
  80161c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801625:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801628:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80162f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801634:	48                   	dec    %eax
  801635:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  80163a:	83 ec 0c             	sub    $0xc,%esp
  80163d:	ff 75 f0             	pushl  -0x10(%ebp)
  801640:	e8 0b 14 00 00       	call   802a50 <insert_sorted_with_merge_freeList>
  801645:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801648:	90                   	nop
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
  80164e:	83 ec 28             	sub    $0x28,%esp
  801651:	8b 45 10             	mov    0x10(%ebp),%eax
  801654:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801657:	e8 9f fc ff ff       	call   8012fb <InitializeUHeap>
	if (size == 0) return NULL ;
  80165c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801660:	75 0a                	jne    80166c <smalloc+0x21>
  801662:	b8 00 00 00 00       	mov    $0x0,%eax
  801667:	e9 8d 00 00 00       	jmp    8016f9 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  80166c:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801673:	8b 55 0c             	mov    0xc(%ebp),%edx
  801676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801679:	01 d0                	add    %edx,%eax
  80167b:	48                   	dec    %eax
  80167c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80167f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801682:	ba 00 00 00 00       	mov    $0x0,%edx
  801687:	f7 75 f4             	divl   -0xc(%ebp)
  80168a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168d:	29 d0                	sub    %edx,%eax
  80168f:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801692:	e8 c9 06 00 00       	call   801d60 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801697:	85 c0                	test   %eax,%eax
  801699:	74 59                	je     8016f4 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  80169b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  8016a2:	83 ec 0c             	sub    $0xc,%esp
  8016a5:	ff 75 0c             	pushl  0xc(%ebp)
  8016a8:	e8 b4 0c 00 00       	call   802361 <alloc_block_FF>
  8016ad:	83 c4 10             	add    $0x10,%esp
  8016b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  8016b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016b7:	75 07                	jne    8016c0 <smalloc+0x75>
			{
				return NULL;
  8016b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016be:	eb 39                	jmp    8016f9 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  8016c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016c3:	8b 40 08             	mov    0x8(%eax),%eax
  8016c6:	89 c2                	mov    %eax,%edx
  8016c8:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8016cc:	52                   	push   %edx
  8016cd:	50                   	push   %eax
  8016ce:	ff 75 0c             	pushl  0xc(%ebp)
  8016d1:	ff 75 08             	pushl  0x8(%ebp)
  8016d4:	e8 0c 04 00 00       	call   801ae5 <sys_createSharedObject>
  8016d9:	83 c4 10             	add    $0x10,%esp
  8016dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  8016df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016e3:	78 08                	js     8016ed <smalloc+0xa2>
				{
					return (void*)v1->sva;
  8016e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e8:	8b 40 08             	mov    0x8(%eax),%eax
  8016eb:	eb 0c                	jmp    8016f9 <smalloc+0xae>
				}
				else
				{
					return NULL;
  8016ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f2:	eb 05                	jmp    8016f9 <smalloc+0xae>
				}
			}

		}
		return NULL;
  8016f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f9:	c9                   	leave  
  8016fa:	c3                   	ret    

008016fb <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
  8016fe:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801701:	e8 f5 fb ff ff       	call   8012fb <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801706:	83 ec 08             	sub    $0x8,%esp
  801709:	ff 75 0c             	pushl  0xc(%ebp)
  80170c:	ff 75 08             	pushl  0x8(%ebp)
  80170f:	e8 fb 03 00 00       	call   801b0f <sys_getSizeOfSharedObject>
  801714:	83 c4 10             	add    $0x10,%esp
  801717:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  80171a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80171e:	75 07                	jne    801727 <sget+0x2c>
	{
		return NULL;
  801720:	b8 00 00 00 00       	mov    $0x0,%eax
  801725:	eb 64                	jmp    80178b <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801727:	e8 34 06 00 00       	call   801d60 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80172c:	85 c0                	test   %eax,%eax
  80172e:	74 56                	je     801786 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801730:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80173a:	83 ec 0c             	sub    $0xc,%esp
  80173d:	50                   	push   %eax
  80173e:	e8 1e 0c 00 00       	call   802361 <alloc_block_FF>
  801743:	83 c4 10             	add    $0x10,%esp
  801746:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801749:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80174d:	75 07                	jne    801756 <sget+0x5b>
		{
		return NULL;
  80174f:	b8 00 00 00 00       	mov    $0x0,%eax
  801754:	eb 35                	jmp    80178b <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801756:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801759:	8b 40 08             	mov    0x8(%eax),%eax
  80175c:	83 ec 04             	sub    $0x4,%esp
  80175f:	50                   	push   %eax
  801760:	ff 75 0c             	pushl  0xc(%ebp)
  801763:	ff 75 08             	pushl  0x8(%ebp)
  801766:	e8 c1 03 00 00       	call   801b2c <sys_getSharedObject>
  80176b:	83 c4 10             	add    $0x10,%esp
  80176e:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801771:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801775:	78 08                	js     80177f <sget+0x84>
			{
				return (void*)v1->sva;
  801777:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177a:	8b 40 08             	mov    0x8(%eax),%eax
  80177d:	eb 0c                	jmp    80178b <sget+0x90>
			}
			else
			{
				return NULL;
  80177f:	b8 00 00 00 00       	mov    $0x0,%eax
  801784:	eb 05                	jmp    80178b <sget+0x90>
			}
		}
	}
  return NULL;
  801786:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80178b:	c9                   	leave  
  80178c:	c3                   	ret    

0080178d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801793:	e8 63 fb ff ff       	call   8012fb <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801798:	83 ec 04             	sub    $0x4,%esp
  80179b:	68 a4 39 80 00       	push   $0x8039a4
  8017a0:	68 0e 01 00 00       	push   $0x10e
  8017a5:	68 73 39 80 00       	push   $0x803973
  8017aa:	e8 0e eb ff ff       	call   8002bd <_panic>

008017af <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
  8017b2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017b5:	83 ec 04             	sub    $0x4,%esp
  8017b8:	68 cc 39 80 00       	push   $0x8039cc
  8017bd:	68 22 01 00 00       	push   $0x122
  8017c2:	68 73 39 80 00       	push   $0x803973
  8017c7:	e8 f1 ea ff ff       	call   8002bd <_panic>

008017cc <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017d2:	83 ec 04             	sub    $0x4,%esp
  8017d5:	68 f0 39 80 00       	push   $0x8039f0
  8017da:	68 2d 01 00 00       	push   $0x12d
  8017df:	68 73 39 80 00       	push   $0x803973
  8017e4:	e8 d4 ea ff ff       	call   8002bd <_panic>

008017e9 <shrink>:

}
void shrink(uint32 newSize)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017ef:	83 ec 04             	sub    $0x4,%esp
  8017f2:	68 f0 39 80 00       	push   $0x8039f0
  8017f7:	68 32 01 00 00       	push   $0x132
  8017fc:	68 73 39 80 00       	push   $0x803973
  801801:	e8 b7 ea ff ff       	call   8002bd <_panic>

00801806 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80180c:	83 ec 04             	sub    $0x4,%esp
  80180f:	68 f0 39 80 00       	push   $0x8039f0
  801814:	68 37 01 00 00       	push   $0x137
  801819:	68 73 39 80 00       	push   $0x803973
  80181e:	e8 9a ea ff ff       	call   8002bd <_panic>

00801823 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	57                   	push   %edi
  801827:	56                   	push   %esi
  801828:	53                   	push   %ebx
  801829:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80182c:	8b 45 08             	mov    0x8(%ebp),%eax
  80182f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801832:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801835:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801838:	8b 7d 18             	mov    0x18(%ebp),%edi
  80183b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80183e:	cd 30                	int    $0x30
  801840:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801843:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801846:	83 c4 10             	add    $0x10,%esp
  801849:	5b                   	pop    %ebx
  80184a:	5e                   	pop    %esi
  80184b:	5f                   	pop    %edi
  80184c:	5d                   	pop    %ebp
  80184d:	c3                   	ret    

0080184e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
  801851:	83 ec 04             	sub    $0x4,%esp
  801854:	8b 45 10             	mov    0x10(%ebp),%eax
  801857:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80185a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80185e:	8b 45 08             	mov    0x8(%ebp),%eax
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	52                   	push   %edx
  801866:	ff 75 0c             	pushl  0xc(%ebp)
  801869:	50                   	push   %eax
  80186a:	6a 00                	push   $0x0
  80186c:	e8 b2 ff ff ff       	call   801823 <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	90                   	nop
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <sys_cgetc>:

int
sys_cgetc(void)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 01                	push   $0x1
  801886:	e8 98 ff ff ff       	call   801823 <syscall>
  80188b:	83 c4 18             	add    $0x18,%esp
}
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801893:	8b 55 0c             	mov    0xc(%ebp),%edx
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	52                   	push   %edx
  8018a0:	50                   	push   %eax
  8018a1:	6a 05                	push   $0x5
  8018a3:	e8 7b ff ff ff       	call   801823 <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp
}
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    

008018ad <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
  8018b0:	56                   	push   %esi
  8018b1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018b2:	8b 75 18             	mov    0x18(%ebp),%esi
  8018b5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	56                   	push   %esi
  8018c2:	53                   	push   %ebx
  8018c3:	51                   	push   %ecx
  8018c4:	52                   	push   %edx
  8018c5:	50                   	push   %eax
  8018c6:	6a 06                	push   $0x6
  8018c8:	e8 56 ff ff ff       	call   801823 <syscall>
  8018cd:	83 c4 18             	add    $0x18,%esp
}
  8018d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d3:	5b                   	pop    %ebx
  8018d4:	5e                   	pop    %esi
  8018d5:	5d                   	pop    %ebp
  8018d6:	c3                   	ret    

008018d7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	52                   	push   %edx
  8018e7:	50                   	push   %eax
  8018e8:	6a 07                	push   $0x7
  8018ea:	e8 34 ff ff ff       	call   801823 <syscall>
  8018ef:	83 c4 18             	add    $0x18,%esp
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	ff 75 0c             	pushl  0xc(%ebp)
  801900:	ff 75 08             	pushl  0x8(%ebp)
  801903:	6a 08                	push   $0x8
  801905:	e8 19 ff ff ff       	call   801823 <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 09                	push   $0x9
  80191e:	e8 00 ff ff ff       	call   801823 <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
}
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 0a                	push   $0xa
  801937:	e8 e7 fe ff ff       	call   801823 <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
}
  80193f:	c9                   	leave  
  801940:	c3                   	ret    

00801941 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 0b                	push   $0xb
  801950:	e8 ce fe ff ff       	call   801823 <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
}
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	ff 75 0c             	pushl  0xc(%ebp)
  801966:	ff 75 08             	pushl  0x8(%ebp)
  801969:	6a 0f                	push   $0xf
  80196b:	e8 b3 fe ff ff       	call   801823 <syscall>
  801970:	83 c4 18             	add    $0x18,%esp
	return;
  801973:	90                   	nop
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	ff 75 0c             	pushl  0xc(%ebp)
  801982:	ff 75 08             	pushl  0x8(%ebp)
  801985:	6a 10                	push   $0x10
  801987:	e8 97 fe ff ff       	call   801823 <syscall>
  80198c:	83 c4 18             	add    $0x18,%esp
	return ;
  80198f:	90                   	nop
}
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	ff 75 10             	pushl  0x10(%ebp)
  80199c:	ff 75 0c             	pushl  0xc(%ebp)
  80199f:	ff 75 08             	pushl  0x8(%ebp)
  8019a2:	6a 11                	push   $0x11
  8019a4:	e8 7a fe ff ff       	call   801823 <syscall>
  8019a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ac:	90                   	nop
}
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 0c                	push   $0xc
  8019be:	e8 60 fe ff ff       	call   801823 <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
}
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	ff 75 08             	pushl  0x8(%ebp)
  8019d6:	6a 0d                	push   $0xd
  8019d8:	e8 46 fe ff ff       	call   801823 <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 0e                	push   $0xe
  8019f1:	e8 2d fe ff ff       	call   801823 <syscall>
  8019f6:	83 c4 18             	add    $0x18,%esp
}
  8019f9:	90                   	nop
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 13                	push   $0x13
  801a0b:	e8 13 fe ff ff       	call   801823 <syscall>
  801a10:	83 c4 18             	add    $0x18,%esp
}
  801a13:	90                   	nop
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 14                	push   $0x14
  801a25:	e8 f9 fd ff ff       	call   801823 <syscall>
  801a2a:	83 c4 18             	add    $0x18,%esp
}
  801a2d:	90                   	nop
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 04             	sub    $0x4,%esp
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a3c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	50                   	push   %eax
  801a49:	6a 15                	push   $0x15
  801a4b:	e8 d3 fd ff ff       	call   801823 <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
}
  801a53:	90                   	nop
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 16                	push   $0x16
  801a65:	e8 b9 fd ff ff       	call   801823 <syscall>
  801a6a:	83 c4 18             	add    $0x18,%esp
}
  801a6d:	90                   	nop
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    

00801a70 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a73:	8b 45 08             	mov    0x8(%ebp),%eax
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	ff 75 0c             	pushl  0xc(%ebp)
  801a7f:	50                   	push   %eax
  801a80:	6a 17                	push   $0x17
  801a82:	e8 9c fd ff ff       	call   801823 <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	52                   	push   %edx
  801a9c:	50                   	push   %eax
  801a9d:	6a 1a                	push   $0x1a
  801a9f:	e8 7f fd ff ff       	call   801823 <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	52                   	push   %edx
  801ab9:	50                   	push   %eax
  801aba:	6a 18                	push   $0x18
  801abc:	e8 62 fd ff ff       	call   801823 <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
}
  801ac4:	90                   	nop
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	52                   	push   %edx
  801ad7:	50                   	push   %eax
  801ad8:	6a 19                	push   $0x19
  801ada:	e8 44 fd ff ff       	call   801823 <syscall>
  801adf:	83 c4 18             	add    $0x18,%esp
}
  801ae2:	90                   	nop
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
  801ae8:	83 ec 04             	sub    $0x4,%esp
  801aeb:	8b 45 10             	mov    0x10(%ebp),%eax
  801aee:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801af1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801af4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801af8:	8b 45 08             	mov    0x8(%ebp),%eax
  801afb:	6a 00                	push   $0x0
  801afd:	51                   	push   %ecx
  801afe:	52                   	push   %edx
  801aff:	ff 75 0c             	pushl  0xc(%ebp)
  801b02:	50                   	push   %eax
  801b03:	6a 1b                	push   $0x1b
  801b05:	e8 19 fd ff ff       	call   801823 <syscall>
  801b0a:	83 c4 18             	add    $0x18,%esp
}
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b15:	8b 45 08             	mov    0x8(%ebp),%eax
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	52                   	push   %edx
  801b1f:	50                   	push   %eax
  801b20:	6a 1c                	push   $0x1c
  801b22:	e8 fc fc ff ff       	call   801823 <syscall>
  801b27:	83 c4 18             	add    $0x18,%esp
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b35:	8b 45 08             	mov    0x8(%ebp),%eax
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	51                   	push   %ecx
  801b3d:	52                   	push   %edx
  801b3e:	50                   	push   %eax
  801b3f:	6a 1d                	push   $0x1d
  801b41:	e8 dd fc ff ff       	call   801823 <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b51:	8b 45 08             	mov    0x8(%ebp),%eax
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	52                   	push   %edx
  801b5b:	50                   	push   %eax
  801b5c:	6a 1e                	push   $0x1e
  801b5e:	e8 c0 fc ff ff       	call   801823 <syscall>
  801b63:	83 c4 18             	add    $0x18,%esp
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 1f                	push   $0x1f
  801b77:	e8 a7 fc ff ff       	call   801823 <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b84:	8b 45 08             	mov    0x8(%ebp),%eax
  801b87:	6a 00                	push   $0x0
  801b89:	ff 75 14             	pushl  0x14(%ebp)
  801b8c:	ff 75 10             	pushl  0x10(%ebp)
  801b8f:	ff 75 0c             	pushl  0xc(%ebp)
  801b92:	50                   	push   %eax
  801b93:	6a 20                	push   $0x20
  801b95:	e8 89 fc ff ff       	call   801823 <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	50                   	push   %eax
  801bae:	6a 21                	push   $0x21
  801bb0:	e8 6e fc ff ff       	call   801823 <syscall>
  801bb5:	83 c4 18             	add    $0x18,%esp
}
  801bb8:	90                   	nop
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	50                   	push   %eax
  801bca:	6a 22                	push   $0x22
  801bcc:	e8 52 fc ff ff       	call   801823 <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 02                	push   $0x2
  801be5:	e8 39 fc ff ff       	call   801823 <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 03                	push   $0x3
  801bfe:	e8 20 fc ff ff       	call   801823 <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
}
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 04                	push   $0x4
  801c17:	e8 07 fc ff ff       	call   801823 <syscall>
  801c1c:	83 c4 18             	add    $0x18,%esp
}
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <sys_exit_env>:


void sys_exit_env(void)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 23                	push   $0x23
  801c30:	e8 ee fb ff ff       	call   801823 <syscall>
  801c35:	83 c4 18             	add    $0x18,%esp
}
  801c38:	90                   	nop
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c41:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c44:	8d 50 04             	lea    0x4(%eax),%edx
  801c47:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	52                   	push   %edx
  801c51:	50                   	push   %eax
  801c52:	6a 24                	push   $0x24
  801c54:	e8 ca fb ff ff       	call   801823 <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
	return result;
  801c5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c62:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c65:	89 01                	mov    %eax,(%ecx)
  801c67:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6d:	c9                   	leave  
  801c6e:	c2 04 00             	ret    $0x4

00801c71 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	ff 75 10             	pushl  0x10(%ebp)
  801c7b:	ff 75 0c             	pushl  0xc(%ebp)
  801c7e:	ff 75 08             	pushl  0x8(%ebp)
  801c81:	6a 12                	push   $0x12
  801c83:	e8 9b fb ff ff       	call   801823 <syscall>
  801c88:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8b:	90                   	nop
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <sys_rcr2>:
uint32 sys_rcr2()
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 25                	push   $0x25
  801c9d:	e8 81 fb ff ff       	call   801823 <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	83 ec 04             	sub    $0x4,%esp
  801cad:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cb3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	50                   	push   %eax
  801cc0:	6a 26                	push   $0x26
  801cc2:	e8 5c fb ff ff       	call   801823 <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
	return ;
  801cca:	90                   	nop
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <rsttst>:
void rsttst()
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 28                	push   $0x28
  801cdc:	e8 42 fb ff ff       	call   801823 <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce4:	90                   	nop
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	83 ec 04             	sub    $0x4,%esp
  801ced:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cf3:	8b 55 18             	mov    0x18(%ebp),%edx
  801cf6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cfa:	52                   	push   %edx
  801cfb:	50                   	push   %eax
  801cfc:	ff 75 10             	pushl  0x10(%ebp)
  801cff:	ff 75 0c             	pushl  0xc(%ebp)
  801d02:	ff 75 08             	pushl  0x8(%ebp)
  801d05:	6a 27                	push   $0x27
  801d07:	e8 17 fb ff ff       	call   801823 <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0f:	90                   	nop
}
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    

00801d12 <chktst>:
void chktst(uint32 n)
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	ff 75 08             	pushl  0x8(%ebp)
  801d20:	6a 29                	push   $0x29
  801d22:	e8 fc fa ff ff       	call   801823 <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2a:	90                   	nop
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <inctst>:

void inctst()
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 2a                	push   $0x2a
  801d3c:	e8 e2 fa ff ff       	call   801823 <syscall>
  801d41:	83 c4 18             	add    $0x18,%esp
	return ;
  801d44:	90                   	nop
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <gettst>:
uint32 gettst()
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 2b                	push   $0x2b
  801d56:	e8 c8 fa ff ff       	call   801823 <syscall>
  801d5b:	83 c4 18             	add    $0x18,%esp
}
  801d5e:	c9                   	leave  
  801d5f:	c3                   	ret    

00801d60 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
  801d63:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 2c                	push   $0x2c
  801d72:	e8 ac fa ff ff       	call   801823 <syscall>
  801d77:	83 c4 18             	add    $0x18,%esp
  801d7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d7d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d81:	75 07                	jne    801d8a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d83:	b8 01 00 00 00       	mov    $0x1,%eax
  801d88:	eb 05                	jmp    801d8f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
  801d94:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 2c                	push   $0x2c
  801da3:	e8 7b fa ff ff       	call   801823 <syscall>
  801da8:	83 c4 18             	add    $0x18,%esp
  801dab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dae:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801db2:	75 07                	jne    801dbb <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801db4:	b8 01 00 00 00       	mov    $0x1,%eax
  801db9:	eb 05                	jmp    801dc0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 2c                	push   $0x2c
  801dd4:	e8 4a fa ff ff       	call   801823 <syscall>
  801dd9:	83 c4 18             	add    $0x18,%esp
  801ddc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ddf:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801de3:	75 07                	jne    801dec <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801de5:	b8 01 00 00 00       	mov    $0x1,%eax
  801dea:	eb 05                	jmp    801df1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 2c                	push   $0x2c
  801e05:	e8 19 fa ff ff       	call   801823 <syscall>
  801e0a:	83 c4 18             	add    $0x18,%esp
  801e0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e10:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e14:	75 07                	jne    801e1d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e16:	b8 01 00 00 00       	mov    $0x1,%eax
  801e1b:	eb 05                	jmp    801e22 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	ff 75 08             	pushl  0x8(%ebp)
  801e32:	6a 2d                	push   $0x2d
  801e34:	e8 ea f9 ff ff       	call   801823 <syscall>
  801e39:	83 c4 18             	add    $0x18,%esp
	return ;
  801e3c:	90                   	nop
}
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
  801e42:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e43:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e46:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4f:	6a 00                	push   $0x0
  801e51:	53                   	push   %ebx
  801e52:	51                   	push   %ecx
  801e53:	52                   	push   %edx
  801e54:	50                   	push   %eax
  801e55:	6a 2e                	push   $0x2e
  801e57:	e8 c7 f9 ff ff       	call   801823 <syscall>
  801e5c:	83 c4 18             	add    $0x18,%esp
}
  801e5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    

00801e64 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	52                   	push   %edx
  801e74:	50                   	push   %eax
  801e75:	6a 2f                	push   $0x2f
  801e77:	e8 a7 f9 ff ff       	call   801823 <syscall>
  801e7c:	83 c4 18             	add    $0x18,%esp
}
  801e7f:	c9                   	leave  
  801e80:	c3                   	ret    

00801e81 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e87:	83 ec 0c             	sub    $0xc,%esp
  801e8a:	68 00 3a 80 00       	push   $0x803a00
  801e8f:	e8 dd e6 ff ff       	call   800571 <cprintf>
  801e94:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e97:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e9e:	83 ec 0c             	sub    $0xc,%esp
  801ea1:	68 2c 3a 80 00       	push   $0x803a2c
  801ea6:	e8 c6 e6 ff ff       	call   800571 <cprintf>
  801eab:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801eae:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801eb2:	a1 38 41 80 00       	mov    0x804138,%eax
  801eb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eba:	eb 56                	jmp    801f12 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ebc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ec0:	74 1c                	je     801ede <print_mem_block_lists+0x5d>
  801ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec5:	8b 50 08             	mov    0x8(%eax),%edx
  801ec8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ecb:	8b 48 08             	mov    0x8(%eax),%ecx
  801ece:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed4:	01 c8                	add    %ecx,%eax
  801ed6:	39 c2                	cmp    %eax,%edx
  801ed8:	73 04                	jae    801ede <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801eda:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee1:	8b 50 08             	mov    0x8(%eax),%edx
  801ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee7:	8b 40 0c             	mov    0xc(%eax),%eax
  801eea:	01 c2                	add    %eax,%edx
  801eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eef:	8b 40 08             	mov    0x8(%eax),%eax
  801ef2:	83 ec 04             	sub    $0x4,%esp
  801ef5:	52                   	push   %edx
  801ef6:	50                   	push   %eax
  801ef7:	68 41 3a 80 00       	push   $0x803a41
  801efc:	e8 70 e6 ff ff       	call   800571 <cprintf>
  801f01:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f07:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f0a:	a1 40 41 80 00       	mov    0x804140,%eax
  801f0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f16:	74 07                	je     801f1f <print_mem_block_lists+0x9e>
  801f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1b:	8b 00                	mov    (%eax),%eax
  801f1d:	eb 05                	jmp    801f24 <print_mem_block_lists+0xa3>
  801f1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f24:	a3 40 41 80 00       	mov    %eax,0x804140
  801f29:	a1 40 41 80 00       	mov    0x804140,%eax
  801f2e:	85 c0                	test   %eax,%eax
  801f30:	75 8a                	jne    801ebc <print_mem_block_lists+0x3b>
  801f32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f36:	75 84                	jne    801ebc <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f38:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f3c:	75 10                	jne    801f4e <print_mem_block_lists+0xcd>
  801f3e:	83 ec 0c             	sub    $0xc,%esp
  801f41:	68 50 3a 80 00       	push   $0x803a50
  801f46:	e8 26 e6 ff ff       	call   800571 <cprintf>
  801f4b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f4e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f55:	83 ec 0c             	sub    $0xc,%esp
  801f58:	68 74 3a 80 00       	push   $0x803a74
  801f5d:	e8 0f e6 ff ff       	call   800571 <cprintf>
  801f62:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f65:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f69:	a1 40 40 80 00       	mov    0x804040,%eax
  801f6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f71:	eb 56                	jmp    801fc9 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f77:	74 1c                	je     801f95 <print_mem_block_lists+0x114>
  801f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7c:	8b 50 08             	mov    0x8(%eax),%edx
  801f7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f82:	8b 48 08             	mov    0x8(%eax),%ecx
  801f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f88:	8b 40 0c             	mov    0xc(%eax),%eax
  801f8b:	01 c8                	add    %ecx,%eax
  801f8d:	39 c2                	cmp    %eax,%edx
  801f8f:	73 04                	jae    801f95 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f91:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f98:	8b 50 08             	mov    0x8(%eax),%edx
  801f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9e:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa1:	01 c2                	add    %eax,%edx
  801fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa6:	8b 40 08             	mov    0x8(%eax),%eax
  801fa9:	83 ec 04             	sub    $0x4,%esp
  801fac:	52                   	push   %edx
  801fad:	50                   	push   %eax
  801fae:	68 41 3a 80 00       	push   $0x803a41
  801fb3:	e8 b9 e5 ff ff       	call   800571 <cprintf>
  801fb8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fc1:	a1 48 40 80 00       	mov    0x804048,%eax
  801fc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fcd:	74 07                	je     801fd6 <print_mem_block_lists+0x155>
  801fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd2:	8b 00                	mov    (%eax),%eax
  801fd4:	eb 05                	jmp    801fdb <print_mem_block_lists+0x15a>
  801fd6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdb:	a3 48 40 80 00       	mov    %eax,0x804048
  801fe0:	a1 48 40 80 00       	mov    0x804048,%eax
  801fe5:	85 c0                	test   %eax,%eax
  801fe7:	75 8a                	jne    801f73 <print_mem_block_lists+0xf2>
  801fe9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fed:	75 84                	jne    801f73 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fef:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ff3:	75 10                	jne    802005 <print_mem_block_lists+0x184>
  801ff5:	83 ec 0c             	sub    $0xc,%esp
  801ff8:	68 8c 3a 80 00       	push   $0x803a8c
  801ffd:	e8 6f e5 ff ff       	call   800571 <cprintf>
  802002:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802005:	83 ec 0c             	sub    $0xc,%esp
  802008:	68 00 3a 80 00       	push   $0x803a00
  80200d:	e8 5f e5 ff ff       	call   800571 <cprintf>
  802012:	83 c4 10             	add    $0x10,%esp

}
  802015:	90                   	nop
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  80201e:	8b 45 08             	mov    0x8(%ebp),%eax
  802021:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  802024:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80202b:	00 00 00 
  80202e:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802035:	00 00 00 
  802038:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80203f:	00 00 00 
	for(int i = 0; i<n;i++)
  802042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802049:	e9 9e 00 00 00       	jmp    8020ec <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80204e:	a1 50 40 80 00       	mov    0x804050,%eax
  802053:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802056:	c1 e2 04             	shl    $0x4,%edx
  802059:	01 d0                	add    %edx,%eax
  80205b:	85 c0                	test   %eax,%eax
  80205d:	75 14                	jne    802073 <initialize_MemBlocksList+0x5b>
  80205f:	83 ec 04             	sub    $0x4,%esp
  802062:	68 b4 3a 80 00       	push   $0x803ab4
  802067:	6a 47                	push   $0x47
  802069:	68 d7 3a 80 00       	push   $0x803ad7
  80206e:	e8 4a e2 ff ff       	call   8002bd <_panic>
  802073:	a1 50 40 80 00       	mov    0x804050,%eax
  802078:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80207b:	c1 e2 04             	shl    $0x4,%edx
  80207e:	01 d0                	add    %edx,%eax
  802080:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802086:	89 10                	mov    %edx,(%eax)
  802088:	8b 00                	mov    (%eax),%eax
  80208a:	85 c0                	test   %eax,%eax
  80208c:	74 18                	je     8020a6 <initialize_MemBlocksList+0x8e>
  80208e:	a1 48 41 80 00       	mov    0x804148,%eax
  802093:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802099:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80209c:	c1 e1 04             	shl    $0x4,%ecx
  80209f:	01 ca                	add    %ecx,%edx
  8020a1:	89 50 04             	mov    %edx,0x4(%eax)
  8020a4:	eb 12                	jmp    8020b8 <initialize_MemBlocksList+0xa0>
  8020a6:	a1 50 40 80 00       	mov    0x804050,%eax
  8020ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ae:	c1 e2 04             	shl    $0x4,%edx
  8020b1:	01 d0                	add    %edx,%eax
  8020b3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020b8:	a1 50 40 80 00       	mov    0x804050,%eax
  8020bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c0:	c1 e2 04             	shl    $0x4,%edx
  8020c3:	01 d0                	add    %edx,%eax
  8020c5:	a3 48 41 80 00       	mov    %eax,0x804148
  8020ca:	a1 50 40 80 00       	mov    0x804050,%eax
  8020cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d2:	c1 e2 04             	shl    $0x4,%edx
  8020d5:	01 d0                	add    %edx,%eax
  8020d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020de:	a1 54 41 80 00       	mov    0x804154,%eax
  8020e3:	40                   	inc    %eax
  8020e4:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8020e9:	ff 45 f4             	incl   -0xc(%ebp)
  8020ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8020f2:	0f 82 56 ff ff ff    	jb     80204e <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8020f8:	90                   	nop
  8020f9:	c9                   	leave  
  8020fa:	c3                   	ret    

008020fb <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
  8020fe:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  802101:	8b 45 0c             	mov    0xc(%ebp),%eax
  802104:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  802107:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80210e:	a1 40 40 80 00       	mov    0x804040,%eax
  802113:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802116:	eb 23                	jmp    80213b <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802118:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80211b:	8b 40 08             	mov    0x8(%eax),%eax
  80211e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802121:	75 09                	jne    80212c <find_block+0x31>
		{
			found = 1;
  802123:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  80212a:	eb 35                	jmp    802161 <find_block+0x66>
		}
		else
		{
			found = 0;
  80212c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802133:	a1 48 40 80 00       	mov    0x804048,%eax
  802138:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80213b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80213f:	74 07                	je     802148 <find_block+0x4d>
  802141:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802144:	8b 00                	mov    (%eax),%eax
  802146:	eb 05                	jmp    80214d <find_block+0x52>
  802148:	b8 00 00 00 00       	mov    $0x0,%eax
  80214d:	a3 48 40 80 00       	mov    %eax,0x804048
  802152:	a1 48 40 80 00       	mov    0x804048,%eax
  802157:	85 c0                	test   %eax,%eax
  802159:	75 bd                	jne    802118 <find_block+0x1d>
  80215b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80215f:	75 b7                	jne    802118 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802161:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802165:	75 05                	jne    80216c <find_block+0x71>
	{
		return blk;
  802167:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80216a:	eb 05                	jmp    802171 <find_block+0x76>
	}
	else
	{
		return NULL;
  80216c:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
  802176:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  80217f:	a1 40 40 80 00       	mov    0x804040,%eax
  802184:	85 c0                	test   %eax,%eax
  802186:	74 12                	je     80219a <insert_sorted_allocList+0x27>
  802188:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80218b:	8b 50 08             	mov    0x8(%eax),%edx
  80218e:	a1 40 40 80 00       	mov    0x804040,%eax
  802193:	8b 40 08             	mov    0x8(%eax),%eax
  802196:	39 c2                	cmp    %eax,%edx
  802198:	73 65                	jae    8021ff <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  80219a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80219e:	75 14                	jne    8021b4 <insert_sorted_allocList+0x41>
  8021a0:	83 ec 04             	sub    $0x4,%esp
  8021a3:	68 b4 3a 80 00       	push   $0x803ab4
  8021a8:	6a 7b                	push   $0x7b
  8021aa:	68 d7 3a 80 00       	push   $0x803ad7
  8021af:	e8 09 e1 ff ff       	call   8002bd <_panic>
  8021b4:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021bd:	89 10                	mov    %edx,(%eax)
  8021bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c2:	8b 00                	mov    (%eax),%eax
  8021c4:	85 c0                	test   %eax,%eax
  8021c6:	74 0d                	je     8021d5 <insert_sorted_allocList+0x62>
  8021c8:	a1 40 40 80 00       	mov    0x804040,%eax
  8021cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021d0:	89 50 04             	mov    %edx,0x4(%eax)
  8021d3:	eb 08                	jmp    8021dd <insert_sorted_allocList+0x6a>
  8021d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d8:	a3 44 40 80 00       	mov    %eax,0x804044
  8021dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e0:	a3 40 40 80 00       	mov    %eax,0x804040
  8021e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021ef:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021f4:	40                   	inc    %eax
  8021f5:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8021fa:	e9 5f 01 00 00       	jmp    80235e <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8021ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802202:	8b 50 08             	mov    0x8(%eax),%edx
  802205:	a1 44 40 80 00       	mov    0x804044,%eax
  80220a:	8b 40 08             	mov    0x8(%eax),%eax
  80220d:	39 c2                	cmp    %eax,%edx
  80220f:	76 65                	jbe    802276 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802211:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802215:	75 14                	jne    80222b <insert_sorted_allocList+0xb8>
  802217:	83 ec 04             	sub    $0x4,%esp
  80221a:	68 f0 3a 80 00       	push   $0x803af0
  80221f:	6a 7f                	push   $0x7f
  802221:	68 d7 3a 80 00       	push   $0x803ad7
  802226:	e8 92 e0 ff ff       	call   8002bd <_panic>
  80222b:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802231:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802234:	89 50 04             	mov    %edx,0x4(%eax)
  802237:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223a:	8b 40 04             	mov    0x4(%eax),%eax
  80223d:	85 c0                	test   %eax,%eax
  80223f:	74 0c                	je     80224d <insert_sorted_allocList+0xda>
  802241:	a1 44 40 80 00       	mov    0x804044,%eax
  802246:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802249:	89 10                	mov    %edx,(%eax)
  80224b:	eb 08                	jmp    802255 <insert_sorted_allocList+0xe2>
  80224d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802250:	a3 40 40 80 00       	mov    %eax,0x804040
  802255:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802258:	a3 44 40 80 00       	mov    %eax,0x804044
  80225d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802260:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802266:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80226b:	40                   	inc    %eax
  80226c:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802271:	e9 e8 00 00 00       	jmp    80235e <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802276:	a1 40 40 80 00       	mov    0x804040,%eax
  80227b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80227e:	e9 ab 00 00 00       	jmp    80232e <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802286:	8b 00                	mov    (%eax),%eax
  802288:	85 c0                	test   %eax,%eax
  80228a:	0f 84 96 00 00 00    	je     802326 <insert_sorted_allocList+0x1b3>
  802290:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802293:	8b 50 08             	mov    0x8(%eax),%edx
  802296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802299:	8b 40 08             	mov    0x8(%eax),%eax
  80229c:	39 c2                	cmp    %eax,%edx
  80229e:	0f 86 82 00 00 00    	jbe    802326 <insert_sorted_allocList+0x1b3>
  8022a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a7:	8b 50 08             	mov    0x8(%eax),%edx
  8022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ad:	8b 00                	mov    (%eax),%eax
  8022af:	8b 40 08             	mov    0x8(%eax),%eax
  8022b2:	39 c2                	cmp    %eax,%edx
  8022b4:	73 70                	jae    802326 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  8022b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ba:	74 06                	je     8022c2 <insert_sorted_allocList+0x14f>
  8022bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022c0:	75 17                	jne    8022d9 <insert_sorted_allocList+0x166>
  8022c2:	83 ec 04             	sub    $0x4,%esp
  8022c5:	68 14 3b 80 00       	push   $0x803b14
  8022ca:	68 87 00 00 00       	push   $0x87
  8022cf:	68 d7 3a 80 00       	push   $0x803ad7
  8022d4:	e8 e4 df ff ff       	call   8002bd <_panic>
  8022d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dc:	8b 10                	mov    (%eax),%edx
  8022de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e1:	89 10                	mov    %edx,(%eax)
  8022e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e6:	8b 00                	mov    (%eax),%eax
  8022e8:	85 c0                	test   %eax,%eax
  8022ea:	74 0b                	je     8022f7 <insert_sorted_allocList+0x184>
  8022ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ef:	8b 00                	mov    (%eax),%eax
  8022f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022f4:	89 50 04             	mov    %edx,0x4(%eax)
  8022f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022fd:	89 10                	mov    %edx,(%eax)
  8022ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802302:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802305:	89 50 04             	mov    %edx,0x4(%eax)
  802308:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80230b:	8b 00                	mov    (%eax),%eax
  80230d:	85 c0                	test   %eax,%eax
  80230f:	75 08                	jne    802319 <insert_sorted_allocList+0x1a6>
  802311:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802314:	a3 44 40 80 00       	mov    %eax,0x804044
  802319:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80231e:	40                   	inc    %eax
  80231f:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802324:	eb 38                	jmp    80235e <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802326:	a1 48 40 80 00       	mov    0x804048,%eax
  80232b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80232e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802332:	74 07                	je     80233b <insert_sorted_allocList+0x1c8>
  802334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802337:	8b 00                	mov    (%eax),%eax
  802339:	eb 05                	jmp    802340 <insert_sorted_allocList+0x1cd>
  80233b:	b8 00 00 00 00       	mov    $0x0,%eax
  802340:	a3 48 40 80 00       	mov    %eax,0x804048
  802345:	a1 48 40 80 00       	mov    0x804048,%eax
  80234a:	85 c0                	test   %eax,%eax
  80234c:	0f 85 31 ff ff ff    	jne    802283 <insert_sorted_allocList+0x110>
  802352:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802356:	0f 85 27 ff ff ff    	jne    802283 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80235c:	eb 00                	jmp    80235e <insert_sorted_allocList+0x1eb>
  80235e:	90                   	nop
  80235f:	c9                   	leave  
  802360:	c3                   	ret    

00802361 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802361:	55                   	push   %ebp
  802362:	89 e5                	mov    %esp,%ebp
  802364:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802367:	8b 45 08             	mov    0x8(%ebp),%eax
  80236a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  80236d:	a1 48 41 80 00       	mov    0x804148,%eax
  802372:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802375:	a1 38 41 80 00       	mov    0x804138,%eax
  80237a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80237d:	e9 77 01 00 00       	jmp    8024f9 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802385:	8b 40 0c             	mov    0xc(%eax),%eax
  802388:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80238b:	0f 85 8a 00 00 00    	jne    80241b <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802391:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802395:	75 17                	jne    8023ae <alloc_block_FF+0x4d>
  802397:	83 ec 04             	sub    $0x4,%esp
  80239a:	68 48 3b 80 00       	push   $0x803b48
  80239f:	68 9e 00 00 00       	push   $0x9e
  8023a4:	68 d7 3a 80 00       	push   $0x803ad7
  8023a9:	e8 0f df ff ff       	call   8002bd <_panic>
  8023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b1:	8b 00                	mov    (%eax),%eax
  8023b3:	85 c0                	test   %eax,%eax
  8023b5:	74 10                	je     8023c7 <alloc_block_FF+0x66>
  8023b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ba:	8b 00                	mov    (%eax),%eax
  8023bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023bf:	8b 52 04             	mov    0x4(%edx),%edx
  8023c2:	89 50 04             	mov    %edx,0x4(%eax)
  8023c5:	eb 0b                	jmp    8023d2 <alloc_block_FF+0x71>
  8023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ca:	8b 40 04             	mov    0x4(%eax),%eax
  8023cd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d5:	8b 40 04             	mov    0x4(%eax),%eax
  8023d8:	85 c0                	test   %eax,%eax
  8023da:	74 0f                	je     8023eb <alloc_block_FF+0x8a>
  8023dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023df:	8b 40 04             	mov    0x4(%eax),%eax
  8023e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e5:	8b 12                	mov    (%edx),%edx
  8023e7:	89 10                	mov    %edx,(%eax)
  8023e9:	eb 0a                	jmp    8023f5 <alloc_block_FF+0x94>
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	8b 00                	mov    (%eax),%eax
  8023f0:	a3 38 41 80 00       	mov    %eax,0x804138
  8023f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802401:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802408:	a1 44 41 80 00       	mov    0x804144,%eax
  80240d:	48                   	dec    %eax
  80240e:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802416:	e9 11 01 00 00       	jmp    80252c <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  80241b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241e:	8b 40 0c             	mov    0xc(%eax),%eax
  802421:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802424:	0f 86 c7 00 00 00    	jbe    8024f1 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  80242a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80242e:	75 17                	jne    802447 <alloc_block_FF+0xe6>
  802430:	83 ec 04             	sub    $0x4,%esp
  802433:	68 48 3b 80 00       	push   $0x803b48
  802438:	68 a3 00 00 00       	push   $0xa3
  80243d:	68 d7 3a 80 00       	push   $0x803ad7
  802442:	e8 76 de ff ff       	call   8002bd <_panic>
  802447:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80244a:	8b 00                	mov    (%eax),%eax
  80244c:	85 c0                	test   %eax,%eax
  80244e:	74 10                	je     802460 <alloc_block_FF+0xff>
  802450:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802453:	8b 00                	mov    (%eax),%eax
  802455:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802458:	8b 52 04             	mov    0x4(%edx),%edx
  80245b:	89 50 04             	mov    %edx,0x4(%eax)
  80245e:	eb 0b                	jmp    80246b <alloc_block_FF+0x10a>
  802460:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802463:	8b 40 04             	mov    0x4(%eax),%eax
  802466:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80246b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80246e:	8b 40 04             	mov    0x4(%eax),%eax
  802471:	85 c0                	test   %eax,%eax
  802473:	74 0f                	je     802484 <alloc_block_FF+0x123>
  802475:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802478:	8b 40 04             	mov    0x4(%eax),%eax
  80247b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80247e:	8b 12                	mov    (%edx),%edx
  802480:	89 10                	mov    %edx,(%eax)
  802482:	eb 0a                	jmp    80248e <alloc_block_FF+0x12d>
  802484:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802487:	8b 00                	mov    (%eax),%eax
  802489:	a3 48 41 80 00       	mov    %eax,0x804148
  80248e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802491:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802497:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80249a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024a1:	a1 54 41 80 00       	mov    0x804154,%eax
  8024a6:	48                   	dec    %eax
  8024a7:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8024ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024b2:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8024b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8024bb:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8024be:	89 c2                	mov    %eax,%edx
  8024c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c3:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8024c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c9:	8b 40 08             	mov    0x8(%eax),%eax
  8024cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	8b 50 08             	mov    0x8(%eax),%edx
  8024d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8024db:	01 c2                	add    %eax,%edx
  8024dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e0:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8024e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024e9:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8024ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ef:	eb 3b                	jmp    80252c <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8024f1:	a1 40 41 80 00       	mov    0x804140,%eax
  8024f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024fd:	74 07                	je     802506 <alloc_block_FF+0x1a5>
  8024ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802502:	8b 00                	mov    (%eax),%eax
  802504:	eb 05                	jmp    80250b <alloc_block_FF+0x1aa>
  802506:	b8 00 00 00 00       	mov    $0x0,%eax
  80250b:	a3 40 41 80 00       	mov    %eax,0x804140
  802510:	a1 40 41 80 00       	mov    0x804140,%eax
  802515:	85 c0                	test   %eax,%eax
  802517:	0f 85 65 fe ff ff    	jne    802382 <alloc_block_FF+0x21>
  80251d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802521:	0f 85 5b fe ff ff    	jne    802382 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802527:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80252c:	c9                   	leave  
  80252d:	c3                   	ret    

0080252e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80252e:	55                   	push   %ebp
  80252f:	89 e5                	mov    %esp,%ebp
  802531:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802534:	8b 45 08             	mov    0x8(%ebp),%eax
  802537:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  80253a:	a1 48 41 80 00       	mov    0x804148,%eax
  80253f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802542:	a1 44 41 80 00       	mov    0x804144,%eax
  802547:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  80254a:	a1 38 41 80 00       	mov    0x804138,%eax
  80254f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802552:	e9 a1 00 00 00       	jmp    8025f8 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255a:	8b 40 0c             	mov    0xc(%eax),%eax
  80255d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802560:	0f 85 8a 00 00 00    	jne    8025f0 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802566:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256a:	75 17                	jne    802583 <alloc_block_BF+0x55>
  80256c:	83 ec 04             	sub    $0x4,%esp
  80256f:	68 48 3b 80 00       	push   $0x803b48
  802574:	68 c2 00 00 00       	push   $0xc2
  802579:	68 d7 3a 80 00       	push   $0x803ad7
  80257e:	e8 3a dd ff ff       	call   8002bd <_panic>
  802583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802586:	8b 00                	mov    (%eax),%eax
  802588:	85 c0                	test   %eax,%eax
  80258a:	74 10                	je     80259c <alloc_block_BF+0x6e>
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	8b 00                	mov    (%eax),%eax
  802591:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802594:	8b 52 04             	mov    0x4(%edx),%edx
  802597:	89 50 04             	mov    %edx,0x4(%eax)
  80259a:	eb 0b                	jmp    8025a7 <alloc_block_BF+0x79>
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	8b 40 04             	mov    0x4(%eax),%eax
  8025a2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025aa:	8b 40 04             	mov    0x4(%eax),%eax
  8025ad:	85 c0                	test   %eax,%eax
  8025af:	74 0f                	je     8025c0 <alloc_block_BF+0x92>
  8025b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b4:	8b 40 04             	mov    0x4(%eax),%eax
  8025b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ba:	8b 12                	mov    (%edx),%edx
  8025bc:	89 10                	mov    %edx,(%eax)
  8025be:	eb 0a                	jmp    8025ca <alloc_block_BF+0x9c>
  8025c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c3:	8b 00                	mov    (%eax),%eax
  8025c5:	a3 38 41 80 00       	mov    %eax,0x804138
  8025ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025dd:	a1 44 41 80 00       	mov    0x804144,%eax
  8025e2:	48                   	dec    %eax
  8025e3:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	e9 11 02 00 00       	jmp    802801 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025f0:	a1 40 41 80 00       	mov    0x804140,%eax
  8025f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025fc:	74 07                	je     802605 <alloc_block_BF+0xd7>
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	8b 00                	mov    (%eax),%eax
  802603:	eb 05                	jmp    80260a <alloc_block_BF+0xdc>
  802605:	b8 00 00 00 00       	mov    $0x0,%eax
  80260a:	a3 40 41 80 00       	mov    %eax,0x804140
  80260f:	a1 40 41 80 00       	mov    0x804140,%eax
  802614:	85 c0                	test   %eax,%eax
  802616:	0f 85 3b ff ff ff    	jne    802557 <alloc_block_BF+0x29>
  80261c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802620:	0f 85 31 ff ff ff    	jne    802557 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802626:	a1 38 41 80 00       	mov    0x804138,%eax
  80262b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80262e:	eb 27                	jmp    802657 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802633:	8b 40 0c             	mov    0xc(%eax),%eax
  802636:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802639:	76 14                	jbe    80264f <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  80263b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263e:	8b 40 0c             	mov    0xc(%eax),%eax
  802641:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802647:	8b 40 08             	mov    0x8(%eax),%eax
  80264a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  80264d:	eb 2e                	jmp    80267d <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80264f:	a1 40 41 80 00       	mov    0x804140,%eax
  802654:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802657:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265b:	74 07                	je     802664 <alloc_block_BF+0x136>
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	8b 00                	mov    (%eax),%eax
  802662:	eb 05                	jmp    802669 <alloc_block_BF+0x13b>
  802664:	b8 00 00 00 00       	mov    $0x0,%eax
  802669:	a3 40 41 80 00       	mov    %eax,0x804140
  80266e:	a1 40 41 80 00       	mov    0x804140,%eax
  802673:	85 c0                	test   %eax,%eax
  802675:	75 b9                	jne    802630 <alloc_block_BF+0x102>
  802677:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267b:	75 b3                	jne    802630 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80267d:	a1 38 41 80 00       	mov    0x804138,%eax
  802682:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802685:	eb 30                	jmp    8026b7 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268a:	8b 40 0c             	mov    0xc(%eax),%eax
  80268d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802690:	73 1d                	jae    8026af <alloc_block_BF+0x181>
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	8b 40 0c             	mov    0xc(%eax),%eax
  802698:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80269b:	76 12                	jbe    8026af <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  80269d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  8026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a9:	8b 40 08             	mov    0x8(%eax),%eax
  8026ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026af:	a1 40 41 80 00       	mov    0x804140,%eax
  8026b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026bb:	74 07                	je     8026c4 <alloc_block_BF+0x196>
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	8b 00                	mov    (%eax),%eax
  8026c2:	eb 05                	jmp    8026c9 <alloc_block_BF+0x19b>
  8026c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c9:	a3 40 41 80 00       	mov    %eax,0x804140
  8026ce:	a1 40 41 80 00       	mov    0x804140,%eax
  8026d3:	85 c0                	test   %eax,%eax
  8026d5:	75 b0                	jne    802687 <alloc_block_BF+0x159>
  8026d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026db:	75 aa                	jne    802687 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026dd:	a1 38 41 80 00       	mov    0x804138,%eax
  8026e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e5:	e9 e4 00 00 00       	jmp    8027ce <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8026f3:	0f 85 cd 00 00 00    	jne    8027c6 <alloc_block_BF+0x298>
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	8b 40 08             	mov    0x8(%eax),%eax
  8026ff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802702:	0f 85 be 00 00 00    	jne    8027c6 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802708:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80270c:	75 17                	jne    802725 <alloc_block_BF+0x1f7>
  80270e:	83 ec 04             	sub    $0x4,%esp
  802711:	68 48 3b 80 00       	push   $0x803b48
  802716:	68 db 00 00 00       	push   $0xdb
  80271b:	68 d7 3a 80 00       	push   $0x803ad7
  802720:	e8 98 db ff ff       	call   8002bd <_panic>
  802725:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802728:	8b 00                	mov    (%eax),%eax
  80272a:	85 c0                	test   %eax,%eax
  80272c:	74 10                	je     80273e <alloc_block_BF+0x210>
  80272e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802731:	8b 00                	mov    (%eax),%eax
  802733:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802736:	8b 52 04             	mov    0x4(%edx),%edx
  802739:	89 50 04             	mov    %edx,0x4(%eax)
  80273c:	eb 0b                	jmp    802749 <alloc_block_BF+0x21b>
  80273e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802741:	8b 40 04             	mov    0x4(%eax),%eax
  802744:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802749:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80274c:	8b 40 04             	mov    0x4(%eax),%eax
  80274f:	85 c0                	test   %eax,%eax
  802751:	74 0f                	je     802762 <alloc_block_BF+0x234>
  802753:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802756:	8b 40 04             	mov    0x4(%eax),%eax
  802759:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80275c:	8b 12                	mov    (%edx),%edx
  80275e:	89 10                	mov    %edx,(%eax)
  802760:	eb 0a                	jmp    80276c <alloc_block_BF+0x23e>
  802762:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802765:	8b 00                	mov    (%eax),%eax
  802767:	a3 48 41 80 00       	mov    %eax,0x804148
  80276c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80276f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802775:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802778:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80277f:	a1 54 41 80 00       	mov    0x804154,%eax
  802784:	48                   	dec    %eax
  802785:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  80278a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80278d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802790:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802793:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802796:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802799:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  80279c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279f:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8027a5:	89 c2                	mov    %eax,%edx
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  8027ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b0:	8b 50 08             	mov    0x8(%eax),%edx
  8027b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b9:	01 c2                	add    %eax,%edx
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8027c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c4:	eb 3b                	jmp    802801 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027c6:	a1 40 41 80 00       	mov    0x804140,%eax
  8027cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d2:	74 07                	je     8027db <alloc_block_BF+0x2ad>
  8027d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d7:	8b 00                	mov    (%eax),%eax
  8027d9:	eb 05                	jmp    8027e0 <alloc_block_BF+0x2b2>
  8027db:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e0:	a3 40 41 80 00       	mov    %eax,0x804140
  8027e5:	a1 40 41 80 00       	mov    0x804140,%eax
  8027ea:	85 c0                	test   %eax,%eax
  8027ec:	0f 85 f8 fe ff ff    	jne    8026ea <alloc_block_BF+0x1bc>
  8027f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f6:	0f 85 ee fe ff ff    	jne    8026ea <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  8027fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802801:	c9                   	leave  
  802802:	c3                   	ret    

00802803 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802803:	55                   	push   %ebp
  802804:	89 e5                	mov    %esp,%ebp
  802806:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802809:	8b 45 08             	mov    0x8(%ebp),%eax
  80280c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  80280f:	a1 48 41 80 00       	mov    0x804148,%eax
  802814:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802817:	a1 38 41 80 00       	mov    0x804138,%eax
  80281c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80281f:	e9 77 01 00 00       	jmp    80299b <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802827:	8b 40 0c             	mov    0xc(%eax),%eax
  80282a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80282d:	0f 85 8a 00 00 00    	jne    8028bd <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802833:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802837:	75 17                	jne    802850 <alloc_block_NF+0x4d>
  802839:	83 ec 04             	sub    $0x4,%esp
  80283c:	68 48 3b 80 00       	push   $0x803b48
  802841:	68 f7 00 00 00       	push   $0xf7
  802846:	68 d7 3a 80 00       	push   $0x803ad7
  80284b:	e8 6d da ff ff       	call   8002bd <_panic>
  802850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802853:	8b 00                	mov    (%eax),%eax
  802855:	85 c0                	test   %eax,%eax
  802857:	74 10                	je     802869 <alloc_block_NF+0x66>
  802859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285c:	8b 00                	mov    (%eax),%eax
  80285e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802861:	8b 52 04             	mov    0x4(%edx),%edx
  802864:	89 50 04             	mov    %edx,0x4(%eax)
  802867:	eb 0b                	jmp    802874 <alloc_block_NF+0x71>
  802869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286c:	8b 40 04             	mov    0x4(%eax),%eax
  80286f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802877:	8b 40 04             	mov    0x4(%eax),%eax
  80287a:	85 c0                	test   %eax,%eax
  80287c:	74 0f                	je     80288d <alloc_block_NF+0x8a>
  80287e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802881:	8b 40 04             	mov    0x4(%eax),%eax
  802884:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802887:	8b 12                	mov    (%edx),%edx
  802889:	89 10                	mov    %edx,(%eax)
  80288b:	eb 0a                	jmp    802897 <alloc_block_NF+0x94>
  80288d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802890:	8b 00                	mov    (%eax),%eax
  802892:	a3 38 41 80 00       	mov    %eax,0x804138
  802897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028aa:	a1 44 41 80 00       	mov    0x804144,%eax
  8028af:	48                   	dec    %eax
  8028b0:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8028b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b8:	e9 11 01 00 00       	jmp    8029ce <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  8028bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028c6:	0f 86 c7 00 00 00    	jbe    802993 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8028cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028d0:	75 17                	jne    8028e9 <alloc_block_NF+0xe6>
  8028d2:	83 ec 04             	sub    $0x4,%esp
  8028d5:	68 48 3b 80 00       	push   $0x803b48
  8028da:	68 fc 00 00 00       	push   $0xfc
  8028df:	68 d7 3a 80 00       	push   $0x803ad7
  8028e4:	e8 d4 d9 ff ff       	call   8002bd <_panic>
  8028e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ec:	8b 00                	mov    (%eax),%eax
  8028ee:	85 c0                	test   %eax,%eax
  8028f0:	74 10                	je     802902 <alloc_block_NF+0xff>
  8028f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f5:	8b 00                	mov    (%eax),%eax
  8028f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028fa:	8b 52 04             	mov    0x4(%edx),%edx
  8028fd:	89 50 04             	mov    %edx,0x4(%eax)
  802900:	eb 0b                	jmp    80290d <alloc_block_NF+0x10a>
  802902:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802905:	8b 40 04             	mov    0x4(%eax),%eax
  802908:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80290d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802910:	8b 40 04             	mov    0x4(%eax),%eax
  802913:	85 c0                	test   %eax,%eax
  802915:	74 0f                	je     802926 <alloc_block_NF+0x123>
  802917:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291a:	8b 40 04             	mov    0x4(%eax),%eax
  80291d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802920:	8b 12                	mov    (%edx),%edx
  802922:	89 10                	mov    %edx,(%eax)
  802924:	eb 0a                	jmp    802930 <alloc_block_NF+0x12d>
  802926:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802929:	8b 00                	mov    (%eax),%eax
  80292b:	a3 48 41 80 00       	mov    %eax,0x804148
  802930:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802933:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802939:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802943:	a1 54 41 80 00       	mov    0x804154,%eax
  802948:	48                   	dec    %eax
  802949:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  80294e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802951:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802954:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295a:	8b 40 0c             	mov    0xc(%eax),%eax
  80295d:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802960:	89 c2                	mov    %eax,%edx
  802962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802965:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296b:	8b 40 08             	mov    0x8(%eax),%eax
  80296e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802974:	8b 50 08             	mov    0x8(%eax),%edx
  802977:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297a:	8b 40 0c             	mov    0xc(%eax),%eax
  80297d:	01 c2                	add    %eax,%edx
  80297f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802982:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802985:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802988:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80298b:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  80298e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802991:	eb 3b                	jmp    8029ce <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802993:	a1 40 41 80 00       	mov    0x804140,%eax
  802998:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80299b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299f:	74 07                	je     8029a8 <alloc_block_NF+0x1a5>
  8029a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a4:	8b 00                	mov    (%eax),%eax
  8029a6:	eb 05                	jmp    8029ad <alloc_block_NF+0x1aa>
  8029a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ad:	a3 40 41 80 00       	mov    %eax,0x804140
  8029b2:	a1 40 41 80 00       	mov    0x804140,%eax
  8029b7:	85 c0                	test   %eax,%eax
  8029b9:	0f 85 65 fe ff ff    	jne    802824 <alloc_block_NF+0x21>
  8029bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c3:	0f 85 5b fe ff ff    	jne    802824 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8029c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029ce:	c9                   	leave  
  8029cf:	c3                   	ret    

008029d0 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  8029d0:	55                   	push   %ebp
  8029d1:	89 e5                	mov    %esp,%ebp
  8029d3:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  8029d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  8029e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  8029ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029ee:	75 17                	jne    802a07 <addToAvailMemBlocksList+0x37>
  8029f0:	83 ec 04             	sub    $0x4,%esp
  8029f3:	68 f0 3a 80 00       	push   $0x803af0
  8029f8:	68 10 01 00 00       	push   $0x110
  8029fd:	68 d7 3a 80 00       	push   $0x803ad7
  802a02:	e8 b6 d8 ff ff       	call   8002bd <_panic>
  802a07:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a10:	89 50 04             	mov    %edx,0x4(%eax)
  802a13:	8b 45 08             	mov    0x8(%ebp),%eax
  802a16:	8b 40 04             	mov    0x4(%eax),%eax
  802a19:	85 c0                	test   %eax,%eax
  802a1b:	74 0c                	je     802a29 <addToAvailMemBlocksList+0x59>
  802a1d:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802a22:	8b 55 08             	mov    0x8(%ebp),%edx
  802a25:	89 10                	mov    %edx,(%eax)
  802a27:	eb 08                	jmp    802a31 <addToAvailMemBlocksList+0x61>
  802a29:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2c:	a3 48 41 80 00       	mov    %eax,0x804148
  802a31:	8b 45 08             	mov    0x8(%ebp),%eax
  802a34:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a39:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a42:	a1 54 41 80 00       	mov    0x804154,%eax
  802a47:	40                   	inc    %eax
  802a48:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802a4d:	90                   	nop
  802a4e:	c9                   	leave  
  802a4f:	c3                   	ret    

00802a50 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a50:	55                   	push   %ebp
  802a51:	89 e5                	mov    %esp,%ebp
  802a53:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802a56:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802a5e:	a1 44 41 80 00       	mov    0x804144,%eax
  802a63:	85 c0                	test   %eax,%eax
  802a65:	75 68                	jne    802acf <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802a67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a6b:	75 17                	jne    802a84 <insert_sorted_with_merge_freeList+0x34>
  802a6d:	83 ec 04             	sub    $0x4,%esp
  802a70:	68 b4 3a 80 00       	push   $0x803ab4
  802a75:	68 1a 01 00 00       	push   $0x11a
  802a7a:	68 d7 3a 80 00       	push   $0x803ad7
  802a7f:	e8 39 d8 ff ff       	call   8002bd <_panic>
  802a84:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8d:	89 10                	mov    %edx,(%eax)
  802a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a92:	8b 00                	mov    (%eax),%eax
  802a94:	85 c0                	test   %eax,%eax
  802a96:	74 0d                	je     802aa5 <insert_sorted_with_merge_freeList+0x55>
  802a98:	a1 38 41 80 00       	mov    0x804138,%eax
  802a9d:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa0:	89 50 04             	mov    %edx,0x4(%eax)
  802aa3:	eb 08                	jmp    802aad <insert_sorted_with_merge_freeList+0x5d>
  802aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802aad:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab0:	a3 38 41 80 00       	mov    %eax,0x804138
  802ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802abf:	a1 44 41 80 00       	mov    0x804144,%eax
  802ac4:	40                   	inc    %eax
  802ac5:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802aca:	e9 c5 03 00 00       	jmp    802e94 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802acf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad2:	8b 50 08             	mov    0x8(%eax),%edx
  802ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad8:	8b 40 08             	mov    0x8(%eax),%eax
  802adb:	39 c2                	cmp    %eax,%edx
  802add:	0f 83 b2 00 00 00    	jae    802b95 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802ae3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae6:	8b 50 08             	mov    0x8(%eax),%edx
  802ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aec:	8b 40 0c             	mov    0xc(%eax),%eax
  802aef:	01 c2                	add    %eax,%edx
  802af1:	8b 45 08             	mov    0x8(%ebp),%eax
  802af4:	8b 40 08             	mov    0x8(%eax),%eax
  802af7:	39 c2                	cmp    %eax,%edx
  802af9:	75 27                	jne    802b22 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802afb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afe:	8b 50 0c             	mov    0xc(%eax),%edx
  802b01:	8b 45 08             	mov    0x8(%ebp),%eax
  802b04:	8b 40 0c             	mov    0xc(%eax),%eax
  802b07:	01 c2                	add    %eax,%edx
  802b09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0c:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802b0f:	83 ec 0c             	sub    $0xc,%esp
  802b12:	ff 75 08             	pushl  0x8(%ebp)
  802b15:	e8 b6 fe ff ff       	call   8029d0 <addToAvailMemBlocksList>
  802b1a:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802b1d:	e9 72 03 00 00       	jmp    802e94 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802b22:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b26:	74 06                	je     802b2e <insert_sorted_with_merge_freeList+0xde>
  802b28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b2c:	75 17                	jne    802b45 <insert_sorted_with_merge_freeList+0xf5>
  802b2e:	83 ec 04             	sub    $0x4,%esp
  802b31:	68 14 3b 80 00       	push   $0x803b14
  802b36:	68 24 01 00 00       	push   $0x124
  802b3b:	68 d7 3a 80 00       	push   $0x803ad7
  802b40:	e8 78 d7 ff ff       	call   8002bd <_panic>
  802b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b48:	8b 10                	mov    (%eax),%edx
  802b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4d:	89 10                	mov    %edx,(%eax)
  802b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b52:	8b 00                	mov    (%eax),%eax
  802b54:	85 c0                	test   %eax,%eax
  802b56:	74 0b                	je     802b63 <insert_sorted_with_merge_freeList+0x113>
  802b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5b:	8b 00                	mov    (%eax),%eax
  802b5d:	8b 55 08             	mov    0x8(%ebp),%edx
  802b60:	89 50 04             	mov    %edx,0x4(%eax)
  802b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b66:	8b 55 08             	mov    0x8(%ebp),%edx
  802b69:	89 10                	mov    %edx,(%eax)
  802b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b71:	89 50 04             	mov    %edx,0x4(%eax)
  802b74:	8b 45 08             	mov    0x8(%ebp),%eax
  802b77:	8b 00                	mov    (%eax),%eax
  802b79:	85 c0                	test   %eax,%eax
  802b7b:	75 08                	jne    802b85 <insert_sorted_with_merge_freeList+0x135>
  802b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b80:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b85:	a1 44 41 80 00       	mov    0x804144,%eax
  802b8a:	40                   	inc    %eax
  802b8b:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802b90:	e9 ff 02 00 00       	jmp    802e94 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802b95:	a1 38 41 80 00       	mov    0x804138,%eax
  802b9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b9d:	e9 c2 02 00 00       	jmp    802e64 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba5:	8b 50 08             	mov    0x8(%eax),%edx
  802ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bab:	8b 40 08             	mov    0x8(%eax),%eax
  802bae:	39 c2                	cmp    %eax,%edx
  802bb0:	0f 86 a6 02 00 00    	jbe    802e5c <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb9:	8b 40 04             	mov    0x4(%eax),%eax
  802bbc:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802bbf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bc3:	0f 85 ba 00 00 00    	jne    802c83 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcc:	8b 50 0c             	mov    0xc(%eax),%edx
  802bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd2:	8b 40 08             	mov    0x8(%eax),%eax
  802bd5:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bda:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802bdd:	39 c2                	cmp    %eax,%edx
  802bdf:	75 33                	jne    802c14 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802be1:	8b 45 08             	mov    0x8(%ebp),%eax
  802be4:	8b 50 08             	mov    0x8(%eax),%edx
  802be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bea:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf0:	8b 50 0c             	mov    0xc(%eax),%edx
  802bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf6:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf9:	01 c2                	add    %eax,%edx
  802bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfe:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802c01:	83 ec 0c             	sub    $0xc,%esp
  802c04:	ff 75 08             	pushl  0x8(%ebp)
  802c07:	e8 c4 fd ff ff       	call   8029d0 <addToAvailMemBlocksList>
  802c0c:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802c0f:	e9 80 02 00 00       	jmp    802e94 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802c14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c18:	74 06                	je     802c20 <insert_sorted_with_merge_freeList+0x1d0>
  802c1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c1e:	75 17                	jne    802c37 <insert_sorted_with_merge_freeList+0x1e7>
  802c20:	83 ec 04             	sub    $0x4,%esp
  802c23:	68 68 3b 80 00       	push   $0x803b68
  802c28:	68 3a 01 00 00       	push   $0x13a
  802c2d:	68 d7 3a 80 00       	push   $0x803ad7
  802c32:	e8 86 d6 ff ff       	call   8002bd <_panic>
  802c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3a:	8b 50 04             	mov    0x4(%eax),%edx
  802c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c40:	89 50 04             	mov    %edx,0x4(%eax)
  802c43:	8b 45 08             	mov    0x8(%ebp),%eax
  802c46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c49:	89 10                	mov    %edx,(%eax)
  802c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4e:	8b 40 04             	mov    0x4(%eax),%eax
  802c51:	85 c0                	test   %eax,%eax
  802c53:	74 0d                	je     802c62 <insert_sorted_with_merge_freeList+0x212>
  802c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c58:	8b 40 04             	mov    0x4(%eax),%eax
  802c5b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c5e:	89 10                	mov    %edx,(%eax)
  802c60:	eb 08                	jmp    802c6a <insert_sorted_with_merge_freeList+0x21a>
  802c62:	8b 45 08             	mov    0x8(%ebp),%eax
  802c65:	a3 38 41 80 00       	mov    %eax,0x804138
  802c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6d:	8b 55 08             	mov    0x8(%ebp),%edx
  802c70:	89 50 04             	mov    %edx,0x4(%eax)
  802c73:	a1 44 41 80 00       	mov    0x804144,%eax
  802c78:	40                   	inc    %eax
  802c79:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802c7e:	e9 11 02 00 00       	jmp    802e94 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802c83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c86:	8b 50 08             	mov    0x8(%eax),%edx
  802c89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8f:	01 c2                	add    %eax,%edx
  802c91:	8b 45 08             	mov    0x8(%ebp),%eax
  802c94:	8b 40 0c             	mov    0xc(%eax),%eax
  802c97:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9c:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802c9f:	39 c2                	cmp    %eax,%edx
  802ca1:	0f 85 bf 00 00 00    	jne    802d66 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802ca7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802caa:	8b 50 0c             	mov    0xc(%eax),%edx
  802cad:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb3:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb8:	8b 40 0c             	mov    0xc(%eax),%eax
  802cbb:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802cbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc0:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802cc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc7:	75 17                	jne    802ce0 <insert_sorted_with_merge_freeList+0x290>
  802cc9:	83 ec 04             	sub    $0x4,%esp
  802ccc:	68 48 3b 80 00       	push   $0x803b48
  802cd1:	68 43 01 00 00       	push   $0x143
  802cd6:	68 d7 3a 80 00       	push   $0x803ad7
  802cdb:	e8 dd d5 ff ff       	call   8002bd <_panic>
  802ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce3:	8b 00                	mov    (%eax),%eax
  802ce5:	85 c0                	test   %eax,%eax
  802ce7:	74 10                	je     802cf9 <insert_sorted_with_merge_freeList+0x2a9>
  802ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cec:	8b 00                	mov    (%eax),%eax
  802cee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf1:	8b 52 04             	mov    0x4(%edx),%edx
  802cf4:	89 50 04             	mov    %edx,0x4(%eax)
  802cf7:	eb 0b                	jmp    802d04 <insert_sorted_with_merge_freeList+0x2b4>
  802cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfc:	8b 40 04             	mov    0x4(%eax),%eax
  802cff:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d07:	8b 40 04             	mov    0x4(%eax),%eax
  802d0a:	85 c0                	test   %eax,%eax
  802d0c:	74 0f                	je     802d1d <insert_sorted_with_merge_freeList+0x2cd>
  802d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d11:	8b 40 04             	mov    0x4(%eax),%eax
  802d14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d17:	8b 12                	mov    (%edx),%edx
  802d19:	89 10                	mov    %edx,(%eax)
  802d1b:	eb 0a                	jmp    802d27 <insert_sorted_with_merge_freeList+0x2d7>
  802d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d20:	8b 00                	mov    (%eax),%eax
  802d22:	a3 38 41 80 00       	mov    %eax,0x804138
  802d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d3a:	a1 44 41 80 00       	mov    0x804144,%eax
  802d3f:	48                   	dec    %eax
  802d40:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802d45:	83 ec 0c             	sub    $0xc,%esp
  802d48:	ff 75 08             	pushl  0x8(%ebp)
  802d4b:	e8 80 fc ff ff       	call   8029d0 <addToAvailMemBlocksList>
  802d50:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802d53:	83 ec 0c             	sub    $0xc,%esp
  802d56:	ff 75 f4             	pushl  -0xc(%ebp)
  802d59:	e8 72 fc ff ff       	call   8029d0 <addToAvailMemBlocksList>
  802d5e:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802d61:	e9 2e 01 00 00       	jmp    802e94 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802d66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d69:	8b 50 08             	mov    0x8(%eax),%edx
  802d6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d72:	01 c2                	add    %eax,%edx
  802d74:	8b 45 08             	mov    0x8(%ebp),%eax
  802d77:	8b 40 08             	mov    0x8(%eax),%eax
  802d7a:	39 c2                	cmp    %eax,%edx
  802d7c:	75 27                	jne    802da5 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802d7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d81:	8b 50 0c             	mov    0xc(%eax),%edx
  802d84:	8b 45 08             	mov    0x8(%ebp),%eax
  802d87:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8a:	01 c2                	add    %eax,%edx
  802d8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8f:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802d92:	83 ec 0c             	sub    $0xc,%esp
  802d95:	ff 75 08             	pushl  0x8(%ebp)
  802d98:	e8 33 fc ff ff       	call   8029d0 <addToAvailMemBlocksList>
  802d9d:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802da0:	e9 ef 00 00 00       	jmp    802e94 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802da5:	8b 45 08             	mov    0x8(%ebp),%eax
  802da8:	8b 50 0c             	mov    0xc(%eax),%edx
  802dab:	8b 45 08             	mov    0x8(%ebp),%eax
  802dae:	8b 40 08             	mov    0x8(%eax),%eax
  802db1:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db6:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802db9:	39 c2                	cmp    %eax,%edx
  802dbb:	75 33                	jne    802df0 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc0:	8b 50 08             	mov    0x8(%eax),%edx
  802dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc6:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcc:	8b 50 0c             	mov    0xc(%eax),%edx
  802dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd2:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd5:	01 c2                	add    %eax,%edx
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802ddd:	83 ec 0c             	sub    $0xc,%esp
  802de0:	ff 75 08             	pushl  0x8(%ebp)
  802de3:	e8 e8 fb ff ff       	call   8029d0 <addToAvailMemBlocksList>
  802de8:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802deb:	e9 a4 00 00 00       	jmp    802e94 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802df0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802df4:	74 06                	je     802dfc <insert_sorted_with_merge_freeList+0x3ac>
  802df6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dfa:	75 17                	jne    802e13 <insert_sorted_with_merge_freeList+0x3c3>
  802dfc:	83 ec 04             	sub    $0x4,%esp
  802dff:	68 68 3b 80 00       	push   $0x803b68
  802e04:	68 56 01 00 00       	push   $0x156
  802e09:	68 d7 3a 80 00       	push   $0x803ad7
  802e0e:	e8 aa d4 ff ff       	call   8002bd <_panic>
  802e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e16:	8b 50 04             	mov    0x4(%eax),%edx
  802e19:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1c:	89 50 04             	mov    %edx,0x4(%eax)
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e25:	89 10                	mov    %edx,(%eax)
  802e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2a:	8b 40 04             	mov    0x4(%eax),%eax
  802e2d:	85 c0                	test   %eax,%eax
  802e2f:	74 0d                	je     802e3e <insert_sorted_with_merge_freeList+0x3ee>
  802e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e34:	8b 40 04             	mov    0x4(%eax),%eax
  802e37:	8b 55 08             	mov    0x8(%ebp),%edx
  802e3a:	89 10                	mov    %edx,(%eax)
  802e3c:	eb 08                	jmp    802e46 <insert_sorted_with_merge_freeList+0x3f6>
  802e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e41:	a3 38 41 80 00       	mov    %eax,0x804138
  802e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e49:	8b 55 08             	mov    0x8(%ebp),%edx
  802e4c:	89 50 04             	mov    %edx,0x4(%eax)
  802e4f:	a1 44 41 80 00       	mov    0x804144,%eax
  802e54:	40                   	inc    %eax
  802e55:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802e5a:	eb 38                	jmp    802e94 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802e5c:	a1 40 41 80 00       	mov    0x804140,%eax
  802e61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e68:	74 07                	je     802e71 <insert_sorted_with_merge_freeList+0x421>
  802e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6d:	8b 00                	mov    (%eax),%eax
  802e6f:	eb 05                	jmp    802e76 <insert_sorted_with_merge_freeList+0x426>
  802e71:	b8 00 00 00 00       	mov    $0x0,%eax
  802e76:	a3 40 41 80 00       	mov    %eax,0x804140
  802e7b:	a1 40 41 80 00       	mov    0x804140,%eax
  802e80:	85 c0                	test   %eax,%eax
  802e82:	0f 85 1a fd ff ff    	jne    802ba2 <insert_sorted_with_merge_freeList+0x152>
  802e88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e8c:	0f 85 10 fd ff ff    	jne    802ba2 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e92:	eb 00                	jmp    802e94 <insert_sorted_with_merge_freeList+0x444>
  802e94:	90                   	nop
  802e95:	c9                   	leave  
  802e96:	c3                   	ret    

00802e97 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802e97:	55                   	push   %ebp
  802e98:	89 e5                	mov    %esp,%ebp
  802e9a:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802e9d:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea0:	89 d0                	mov    %edx,%eax
  802ea2:	c1 e0 02             	shl    $0x2,%eax
  802ea5:	01 d0                	add    %edx,%eax
  802ea7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802eae:	01 d0                	add    %edx,%eax
  802eb0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802eb7:	01 d0                	add    %edx,%eax
  802eb9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ec0:	01 d0                	add    %edx,%eax
  802ec2:	c1 e0 04             	shl    $0x4,%eax
  802ec5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802ec8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802ecf:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802ed2:	83 ec 0c             	sub    $0xc,%esp
  802ed5:	50                   	push   %eax
  802ed6:	e8 60 ed ff ff       	call   801c3b <sys_get_virtual_time>
  802edb:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802ede:	eb 41                	jmp    802f21 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802ee0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802ee3:	83 ec 0c             	sub    $0xc,%esp
  802ee6:	50                   	push   %eax
  802ee7:	e8 4f ed ff ff       	call   801c3b <sys_get_virtual_time>
  802eec:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802eef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ef2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef5:	29 c2                	sub    %eax,%edx
  802ef7:	89 d0                	mov    %edx,%eax
  802ef9:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802efc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802eff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f02:	89 d1                	mov    %edx,%ecx
  802f04:	29 c1                	sub    %eax,%ecx
  802f06:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802f09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f0c:	39 c2                	cmp    %eax,%edx
  802f0e:	0f 97 c0             	seta   %al
  802f11:	0f b6 c0             	movzbl %al,%eax
  802f14:	29 c1                	sub    %eax,%ecx
  802f16:	89 c8                	mov    %ecx,%eax
  802f18:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802f1b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f24:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f27:	72 b7                	jb     802ee0 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802f29:	90                   	nop
  802f2a:	c9                   	leave  
  802f2b:	c3                   	ret    

00802f2c <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802f2c:	55                   	push   %ebp
  802f2d:	89 e5                	mov    %esp,%ebp
  802f2f:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802f32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802f39:	eb 03                	jmp    802f3e <busy_wait+0x12>
  802f3b:	ff 45 fc             	incl   -0x4(%ebp)
  802f3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f41:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f44:	72 f5                	jb     802f3b <busy_wait+0xf>
	return i;
  802f46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802f49:	c9                   	leave  
  802f4a:	c3                   	ret    
  802f4b:	90                   	nop

00802f4c <__udivdi3>:
  802f4c:	55                   	push   %ebp
  802f4d:	57                   	push   %edi
  802f4e:	56                   	push   %esi
  802f4f:	53                   	push   %ebx
  802f50:	83 ec 1c             	sub    $0x1c,%esp
  802f53:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802f57:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802f5b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802f5f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f63:	89 ca                	mov    %ecx,%edx
  802f65:	89 f8                	mov    %edi,%eax
  802f67:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802f6b:	85 f6                	test   %esi,%esi
  802f6d:	75 2d                	jne    802f9c <__udivdi3+0x50>
  802f6f:	39 cf                	cmp    %ecx,%edi
  802f71:	77 65                	ja     802fd8 <__udivdi3+0x8c>
  802f73:	89 fd                	mov    %edi,%ebp
  802f75:	85 ff                	test   %edi,%edi
  802f77:	75 0b                	jne    802f84 <__udivdi3+0x38>
  802f79:	b8 01 00 00 00       	mov    $0x1,%eax
  802f7e:	31 d2                	xor    %edx,%edx
  802f80:	f7 f7                	div    %edi
  802f82:	89 c5                	mov    %eax,%ebp
  802f84:	31 d2                	xor    %edx,%edx
  802f86:	89 c8                	mov    %ecx,%eax
  802f88:	f7 f5                	div    %ebp
  802f8a:	89 c1                	mov    %eax,%ecx
  802f8c:	89 d8                	mov    %ebx,%eax
  802f8e:	f7 f5                	div    %ebp
  802f90:	89 cf                	mov    %ecx,%edi
  802f92:	89 fa                	mov    %edi,%edx
  802f94:	83 c4 1c             	add    $0x1c,%esp
  802f97:	5b                   	pop    %ebx
  802f98:	5e                   	pop    %esi
  802f99:	5f                   	pop    %edi
  802f9a:	5d                   	pop    %ebp
  802f9b:	c3                   	ret    
  802f9c:	39 ce                	cmp    %ecx,%esi
  802f9e:	77 28                	ja     802fc8 <__udivdi3+0x7c>
  802fa0:	0f bd fe             	bsr    %esi,%edi
  802fa3:	83 f7 1f             	xor    $0x1f,%edi
  802fa6:	75 40                	jne    802fe8 <__udivdi3+0x9c>
  802fa8:	39 ce                	cmp    %ecx,%esi
  802faa:	72 0a                	jb     802fb6 <__udivdi3+0x6a>
  802fac:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802fb0:	0f 87 9e 00 00 00    	ja     803054 <__udivdi3+0x108>
  802fb6:	b8 01 00 00 00       	mov    $0x1,%eax
  802fbb:	89 fa                	mov    %edi,%edx
  802fbd:	83 c4 1c             	add    $0x1c,%esp
  802fc0:	5b                   	pop    %ebx
  802fc1:	5e                   	pop    %esi
  802fc2:	5f                   	pop    %edi
  802fc3:	5d                   	pop    %ebp
  802fc4:	c3                   	ret    
  802fc5:	8d 76 00             	lea    0x0(%esi),%esi
  802fc8:	31 ff                	xor    %edi,%edi
  802fca:	31 c0                	xor    %eax,%eax
  802fcc:	89 fa                	mov    %edi,%edx
  802fce:	83 c4 1c             	add    $0x1c,%esp
  802fd1:	5b                   	pop    %ebx
  802fd2:	5e                   	pop    %esi
  802fd3:	5f                   	pop    %edi
  802fd4:	5d                   	pop    %ebp
  802fd5:	c3                   	ret    
  802fd6:	66 90                	xchg   %ax,%ax
  802fd8:	89 d8                	mov    %ebx,%eax
  802fda:	f7 f7                	div    %edi
  802fdc:	31 ff                	xor    %edi,%edi
  802fde:	89 fa                	mov    %edi,%edx
  802fe0:	83 c4 1c             	add    $0x1c,%esp
  802fe3:	5b                   	pop    %ebx
  802fe4:	5e                   	pop    %esi
  802fe5:	5f                   	pop    %edi
  802fe6:	5d                   	pop    %ebp
  802fe7:	c3                   	ret    
  802fe8:	bd 20 00 00 00       	mov    $0x20,%ebp
  802fed:	89 eb                	mov    %ebp,%ebx
  802fef:	29 fb                	sub    %edi,%ebx
  802ff1:	89 f9                	mov    %edi,%ecx
  802ff3:	d3 e6                	shl    %cl,%esi
  802ff5:	89 c5                	mov    %eax,%ebp
  802ff7:	88 d9                	mov    %bl,%cl
  802ff9:	d3 ed                	shr    %cl,%ebp
  802ffb:	89 e9                	mov    %ebp,%ecx
  802ffd:	09 f1                	or     %esi,%ecx
  802fff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803003:	89 f9                	mov    %edi,%ecx
  803005:	d3 e0                	shl    %cl,%eax
  803007:	89 c5                	mov    %eax,%ebp
  803009:	89 d6                	mov    %edx,%esi
  80300b:	88 d9                	mov    %bl,%cl
  80300d:	d3 ee                	shr    %cl,%esi
  80300f:	89 f9                	mov    %edi,%ecx
  803011:	d3 e2                	shl    %cl,%edx
  803013:	8b 44 24 08          	mov    0x8(%esp),%eax
  803017:	88 d9                	mov    %bl,%cl
  803019:	d3 e8                	shr    %cl,%eax
  80301b:	09 c2                	or     %eax,%edx
  80301d:	89 d0                	mov    %edx,%eax
  80301f:	89 f2                	mov    %esi,%edx
  803021:	f7 74 24 0c          	divl   0xc(%esp)
  803025:	89 d6                	mov    %edx,%esi
  803027:	89 c3                	mov    %eax,%ebx
  803029:	f7 e5                	mul    %ebp
  80302b:	39 d6                	cmp    %edx,%esi
  80302d:	72 19                	jb     803048 <__udivdi3+0xfc>
  80302f:	74 0b                	je     80303c <__udivdi3+0xf0>
  803031:	89 d8                	mov    %ebx,%eax
  803033:	31 ff                	xor    %edi,%edi
  803035:	e9 58 ff ff ff       	jmp    802f92 <__udivdi3+0x46>
  80303a:	66 90                	xchg   %ax,%ax
  80303c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803040:	89 f9                	mov    %edi,%ecx
  803042:	d3 e2                	shl    %cl,%edx
  803044:	39 c2                	cmp    %eax,%edx
  803046:	73 e9                	jae    803031 <__udivdi3+0xe5>
  803048:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80304b:	31 ff                	xor    %edi,%edi
  80304d:	e9 40 ff ff ff       	jmp    802f92 <__udivdi3+0x46>
  803052:	66 90                	xchg   %ax,%ax
  803054:	31 c0                	xor    %eax,%eax
  803056:	e9 37 ff ff ff       	jmp    802f92 <__udivdi3+0x46>
  80305b:	90                   	nop

0080305c <__umoddi3>:
  80305c:	55                   	push   %ebp
  80305d:	57                   	push   %edi
  80305e:	56                   	push   %esi
  80305f:	53                   	push   %ebx
  803060:	83 ec 1c             	sub    $0x1c,%esp
  803063:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803067:	8b 74 24 34          	mov    0x34(%esp),%esi
  80306b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80306f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803073:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803077:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80307b:	89 f3                	mov    %esi,%ebx
  80307d:	89 fa                	mov    %edi,%edx
  80307f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803083:	89 34 24             	mov    %esi,(%esp)
  803086:	85 c0                	test   %eax,%eax
  803088:	75 1a                	jne    8030a4 <__umoddi3+0x48>
  80308a:	39 f7                	cmp    %esi,%edi
  80308c:	0f 86 a2 00 00 00    	jbe    803134 <__umoddi3+0xd8>
  803092:	89 c8                	mov    %ecx,%eax
  803094:	89 f2                	mov    %esi,%edx
  803096:	f7 f7                	div    %edi
  803098:	89 d0                	mov    %edx,%eax
  80309a:	31 d2                	xor    %edx,%edx
  80309c:	83 c4 1c             	add    $0x1c,%esp
  80309f:	5b                   	pop    %ebx
  8030a0:	5e                   	pop    %esi
  8030a1:	5f                   	pop    %edi
  8030a2:	5d                   	pop    %ebp
  8030a3:	c3                   	ret    
  8030a4:	39 f0                	cmp    %esi,%eax
  8030a6:	0f 87 ac 00 00 00    	ja     803158 <__umoddi3+0xfc>
  8030ac:	0f bd e8             	bsr    %eax,%ebp
  8030af:	83 f5 1f             	xor    $0x1f,%ebp
  8030b2:	0f 84 ac 00 00 00    	je     803164 <__umoddi3+0x108>
  8030b8:	bf 20 00 00 00       	mov    $0x20,%edi
  8030bd:	29 ef                	sub    %ebp,%edi
  8030bf:	89 fe                	mov    %edi,%esi
  8030c1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8030c5:	89 e9                	mov    %ebp,%ecx
  8030c7:	d3 e0                	shl    %cl,%eax
  8030c9:	89 d7                	mov    %edx,%edi
  8030cb:	89 f1                	mov    %esi,%ecx
  8030cd:	d3 ef                	shr    %cl,%edi
  8030cf:	09 c7                	or     %eax,%edi
  8030d1:	89 e9                	mov    %ebp,%ecx
  8030d3:	d3 e2                	shl    %cl,%edx
  8030d5:	89 14 24             	mov    %edx,(%esp)
  8030d8:	89 d8                	mov    %ebx,%eax
  8030da:	d3 e0                	shl    %cl,%eax
  8030dc:	89 c2                	mov    %eax,%edx
  8030de:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030e2:	d3 e0                	shl    %cl,%eax
  8030e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030ec:	89 f1                	mov    %esi,%ecx
  8030ee:	d3 e8                	shr    %cl,%eax
  8030f0:	09 d0                	or     %edx,%eax
  8030f2:	d3 eb                	shr    %cl,%ebx
  8030f4:	89 da                	mov    %ebx,%edx
  8030f6:	f7 f7                	div    %edi
  8030f8:	89 d3                	mov    %edx,%ebx
  8030fa:	f7 24 24             	mull   (%esp)
  8030fd:	89 c6                	mov    %eax,%esi
  8030ff:	89 d1                	mov    %edx,%ecx
  803101:	39 d3                	cmp    %edx,%ebx
  803103:	0f 82 87 00 00 00    	jb     803190 <__umoddi3+0x134>
  803109:	0f 84 91 00 00 00    	je     8031a0 <__umoddi3+0x144>
  80310f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803113:	29 f2                	sub    %esi,%edx
  803115:	19 cb                	sbb    %ecx,%ebx
  803117:	89 d8                	mov    %ebx,%eax
  803119:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80311d:	d3 e0                	shl    %cl,%eax
  80311f:	89 e9                	mov    %ebp,%ecx
  803121:	d3 ea                	shr    %cl,%edx
  803123:	09 d0                	or     %edx,%eax
  803125:	89 e9                	mov    %ebp,%ecx
  803127:	d3 eb                	shr    %cl,%ebx
  803129:	89 da                	mov    %ebx,%edx
  80312b:	83 c4 1c             	add    $0x1c,%esp
  80312e:	5b                   	pop    %ebx
  80312f:	5e                   	pop    %esi
  803130:	5f                   	pop    %edi
  803131:	5d                   	pop    %ebp
  803132:	c3                   	ret    
  803133:	90                   	nop
  803134:	89 fd                	mov    %edi,%ebp
  803136:	85 ff                	test   %edi,%edi
  803138:	75 0b                	jne    803145 <__umoddi3+0xe9>
  80313a:	b8 01 00 00 00       	mov    $0x1,%eax
  80313f:	31 d2                	xor    %edx,%edx
  803141:	f7 f7                	div    %edi
  803143:	89 c5                	mov    %eax,%ebp
  803145:	89 f0                	mov    %esi,%eax
  803147:	31 d2                	xor    %edx,%edx
  803149:	f7 f5                	div    %ebp
  80314b:	89 c8                	mov    %ecx,%eax
  80314d:	f7 f5                	div    %ebp
  80314f:	89 d0                	mov    %edx,%eax
  803151:	e9 44 ff ff ff       	jmp    80309a <__umoddi3+0x3e>
  803156:	66 90                	xchg   %ax,%ax
  803158:	89 c8                	mov    %ecx,%eax
  80315a:	89 f2                	mov    %esi,%edx
  80315c:	83 c4 1c             	add    $0x1c,%esp
  80315f:	5b                   	pop    %ebx
  803160:	5e                   	pop    %esi
  803161:	5f                   	pop    %edi
  803162:	5d                   	pop    %ebp
  803163:	c3                   	ret    
  803164:	3b 04 24             	cmp    (%esp),%eax
  803167:	72 06                	jb     80316f <__umoddi3+0x113>
  803169:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80316d:	77 0f                	ja     80317e <__umoddi3+0x122>
  80316f:	89 f2                	mov    %esi,%edx
  803171:	29 f9                	sub    %edi,%ecx
  803173:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803177:	89 14 24             	mov    %edx,(%esp)
  80317a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80317e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803182:	8b 14 24             	mov    (%esp),%edx
  803185:	83 c4 1c             	add    $0x1c,%esp
  803188:	5b                   	pop    %ebx
  803189:	5e                   	pop    %esi
  80318a:	5f                   	pop    %edi
  80318b:	5d                   	pop    %ebp
  80318c:	c3                   	ret    
  80318d:	8d 76 00             	lea    0x0(%esi),%esi
  803190:	2b 04 24             	sub    (%esp),%eax
  803193:	19 fa                	sbb    %edi,%edx
  803195:	89 d1                	mov    %edx,%ecx
  803197:	89 c6                	mov    %eax,%esi
  803199:	e9 71 ff ff ff       	jmp    80310f <__umoddi3+0xb3>
  80319e:	66 90                	xchg   %ax,%ax
  8031a0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8031a4:	72 ea                	jb     803190 <__umoddi3+0x134>
  8031a6:	89 d9                	mov    %ebx,%ecx
  8031a8:	e9 62 ff ff ff       	jmp    80310f <__umoddi3+0xb3>
