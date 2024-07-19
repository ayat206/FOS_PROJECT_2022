
obj/user/tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 44 01 00 00       	call   80017a <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
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
_main(void)
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
  80008c:	68 c0 31 80 00       	push   $0x8031c0
  800091:	6a 12                	push   $0x12
  800093:	68 dc 31 80 00       	push   $0x8031dc
  800098:	e8 19 02 00 00       	call   8002b6 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 55 14 00 00       	call   8014fc <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  8000aa:	e8 52 1b 00 00       	call   801c01 <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 f9 31 80 00       	push   $0x8031f9
  8000b7:	50                   	push   %eax
  8000b8:	e8 37 16 00 00       	call   8016f4 <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 fc 31 80 00       	push   $0x8031fc
  8000cb:	e8 9a 04 00 00       	call   80056a <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got z
	inctst();
  8000d3:	e8 4e 1c 00 00       	call   801d26 <inctst>

	cprintf("Slave B2 please be patient ...\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 24 32 80 00       	push   $0x803224
  8000e0:	e8 85 04 00 00       	call   80056a <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(9000);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 28 23 00 00       	push   $0x2328
  8000f0:	e8 9b 2d 00 00       	call   802e90 <env_sleep>
  8000f5:	83 c4 10             	add    $0x10,%esp
	//to ensure that the other environments completed successfully
	while (gettst()!=2) ;// panic("test failed");
  8000f8:	90                   	nop
  8000f9:	e8 42 1c 00 00       	call   801d40 <gettst>
  8000fe:	83 f8 02             	cmp    $0x2,%eax
  800101:	75 f6                	jne    8000f9 <_main+0xc1>

	int freeFrames = sys_calculate_free_frames() ;
  800103:	e8 00 18 00 00       	call   801908 <sys_calculate_free_frames>
  800108:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	ff 75 ec             	pushl  -0x14(%ebp)
  800111:	e8 92 16 00 00       	call   8017a8 <sfree>
  800116:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	68 44 32 80 00       	push   $0x803244
  800121:	e8 44 04 00 00       	call   80056a <cprintf>
  800126:	83 c4 10             	add    $0x10,%esp
	int expected = (1+1) + (1+1);
  800129:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  800130:	e8 d3 17 00 00       	call   801908 <sys_calculate_free_frames>
  800135:	89 c2                	mov    %eax,%edx
  800137:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80013a:	29 c2                	sub    %eax,%edx
  80013c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80013f:	39 c2                	cmp    %eax,%edx
  800141:	74 14                	je     800157 <_main+0x11f>
  800143:	83 ec 04             	sub    $0x4,%esp
  800146:	68 5c 32 80 00       	push   $0x80325c
  80014b:	6a 2a                	push   $0x2a
  80014d:	68 dc 31 80 00       	push   $0x8031dc
  800152:	e8 5f 01 00 00       	call   8002b6 <_panic>


	cprintf("Step B completed successfully!!\n\n\n");
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 fc 32 80 00       	push   $0x8032fc
  80015f:	e8 06 04 00 00       	call   80056a <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	68 20 33 80 00       	push   $0x803320
  80016f:	e8 f6 03 00 00       	call   80056a <cprintf>
  800174:	83 c4 10             	add    $0x10,%esp

	return;
  800177:	90                   	nop
}
  800178:	c9                   	leave  
  800179:	c3                   	ret    

0080017a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800180:	e8 63 1a 00 00       	call   801be8 <sys_getenvindex>
  800185:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800188:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80018b:	89 d0                	mov    %edx,%eax
  80018d:	c1 e0 03             	shl    $0x3,%eax
  800190:	01 d0                	add    %edx,%eax
  800192:	01 c0                	add    %eax,%eax
  800194:	01 d0                	add    %edx,%eax
  800196:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80019d:	01 d0                	add    %edx,%eax
  80019f:	c1 e0 04             	shl    $0x4,%eax
  8001a2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001a7:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b1:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001b7:	84 c0                	test   %al,%al
  8001b9:	74 0f                	je     8001ca <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c0:	05 5c 05 00 00       	add    $0x55c,%eax
  8001c5:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001ce:	7e 0a                	jle    8001da <libmain+0x60>
		binaryname = argv[0];
  8001d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d3:	8b 00                	mov    (%eax),%eax
  8001d5:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	ff 75 0c             	pushl  0xc(%ebp)
  8001e0:	ff 75 08             	pushl  0x8(%ebp)
  8001e3:	e8 50 fe ff ff       	call   800038 <_main>
  8001e8:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001eb:	e8 05 18 00 00       	call   8019f5 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	68 84 33 80 00       	push   $0x803384
  8001f8:	e8 6d 03 00 00       	call   80056a <cprintf>
  8001fd:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800200:	a1 20 40 80 00       	mov    0x804020,%eax
  800205:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80020b:	a1 20 40 80 00       	mov    0x804020,%eax
  800210:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800216:	83 ec 04             	sub    $0x4,%esp
  800219:	52                   	push   %edx
  80021a:	50                   	push   %eax
  80021b:	68 ac 33 80 00       	push   $0x8033ac
  800220:	e8 45 03 00 00       	call   80056a <cprintf>
  800225:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800228:	a1 20 40 80 00       	mov    0x804020,%eax
  80022d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800233:	a1 20 40 80 00       	mov    0x804020,%eax
  800238:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80023e:	a1 20 40 80 00       	mov    0x804020,%eax
  800243:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800249:	51                   	push   %ecx
  80024a:	52                   	push   %edx
  80024b:	50                   	push   %eax
  80024c:	68 d4 33 80 00       	push   $0x8033d4
  800251:	e8 14 03 00 00       	call   80056a <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800259:	a1 20 40 80 00       	mov    0x804020,%eax
  80025e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	50                   	push   %eax
  800268:	68 2c 34 80 00       	push   $0x80342c
  80026d:	e8 f8 02 00 00       	call   80056a <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	68 84 33 80 00       	push   $0x803384
  80027d:	e8 e8 02 00 00       	call   80056a <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800285:	e8 85 17 00 00       	call   801a0f <sys_enable_interrupt>

	// exit gracefully
	exit();
  80028a:	e8 19 00 00 00       	call   8002a8 <exit>
}
  80028f:	90                   	nop
  800290:	c9                   	leave  
  800291:	c3                   	ret    

00800292 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  800295:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	6a 00                	push   $0x0
  80029d:	e8 12 19 00 00       	call   801bb4 <sys_destroy_env>
  8002a2:	83 c4 10             	add    $0x10,%esp
}
  8002a5:	90                   	nop
  8002a6:	c9                   	leave  
  8002a7:	c3                   	ret    

008002a8 <exit>:

void
exit(void)
{
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002ae:	e8 67 19 00 00       	call   801c1a <sys_exit_env>
}
  8002b3:	90                   	nop
  8002b4:	c9                   	leave  
  8002b5:	c3                   	ret    

008002b6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002b6:	55                   	push   %ebp
  8002b7:	89 e5                	mov    %esp,%ebp
  8002b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002bc:	8d 45 10             	lea    0x10(%ebp),%eax
  8002bf:	83 c0 04             	add    $0x4,%eax
  8002c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002c5:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002ca:	85 c0                	test   %eax,%eax
  8002cc:	74 16                	je     8002e4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002ce:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002d3:	83 ec 08             	sub    $0x8,%esp
  8002d6:	50                   	push   %eax
  8002d7:	68 40 34 80 00       	push   $0x803440
  8002dc:	e8 89 02 00 00       	call   80056a <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002e4:	a1 00 40 80 00       	mov    0x804000,%eax
  8002e9:	ff 75 0c             	pushl  0xc(%ebp)
  8002ec:	ff 75 08             	pushl  0x8(%ebp)
  8002ef:	50                   	push   %eax
  8002f0:	68 45 34 80 00       	push   $0x803445
  8002f5:	e8 70 02 00 00       	call   80056a <cprintf>
  8002fa:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800300:	83 ec 08             	sub    $0x8,%esp
  800303:	ff 75 f4             	pushl  -0xc(%ebp)
  800306:	50                   	push   %eax
  800307:	e8 f3 01 00 00       	call   8004ff <vcprintf>
  80030c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80030f:	83 ec 08             	sub    $0x8,%esp
  800312:	6a 00                	push   $0x0
  800314:	68 61 34 80 00       	push   $0x803461
  800319:	e8 e1 01 00 00       	call   8004ff <vcprintf>
  80031e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800321:	e8 82 ff ff ff       	call   8002a8 <exit>

	// should not return here
	while (1) ;
  800326:	eb fe                	jmp    800326 <_panic+0x70>

00800328 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80032e:	a1 20 40 80 00       	mov    0x804020,%eax
  800333:	8b 50 74             	mov    0x74(%eax),%edx
  800336:	8b 45 0c             	mov    0xc(%ebp),%eax
  800339:	39 c2                	cmp    %eax,%edx
  80033b:	74 14                	je     800351 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	68 64 34 80 00       	push   $0x803464
  800345:	6a 26                	push   $0x26
  800347:	68 b0 34 80 00       	push   $0x8034b0
  80034c:	e8 65 ff ff ff       	call   8002b6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800351:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800358:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80035f:	e9 c2 00 00 00       	jmp    800426 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800367:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036e:	8b 45 08             	mov    0x8(%ebp),%eax
  800371:	01 d0                	add    %edx,%eax
  800373:	8b 00                	mov    (%eax),%eax
  800375:	85 c0                	test   %eax,%eax
  800377:	75 08                	jne    800381 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800379:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80037c:	e9 a2 00 00 00       	jmp    800423 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800381:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800388:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80038f:	eb 69                	jmp    8003fa <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800391:	a1 20 40 80 00       	mov    0x804020,%eax
  800396:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80039c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80039f:	89 d0                	mov    %edx,%eax
  8003a1:	01 c0                	add    %eax,%eax
  8003a3:	01 d0                	add    %edx,%eax
  8003a5:	c1 e0 03             	shl    $0x3,%eax
  8003a8:	01 c8                	add    %ecx,%eax
  8003aa:	8a 40 04             	mov    0x4(%eax),%al
  8003ad:	84 c0                	test   %al,%al
  8003af:	75 46                	jne    8003f7 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b1:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003bf:	89 d0                	mov    %edx,%eax
  8003c1:	01 c0                	add    %eax,%eax
  8003c3:	01 d0                	add    %edx,%eax
  8003c5:	c1 e0 03             	shl    $0x3,%eax
  8003c8:	01 c8                	add    %ecx,%eax
  8003ca:	8b 00                	mov    (%eax),%eax
  8003cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003dc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 c8                	add    %ecx,%eax
  8003e8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ea:	39 c2                	cmp    %eax,%edx
  8003ec:	75 09                	jne    8003f7 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003ee:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003f5:	eb 12                	jmp    800409 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f7:	ff 45 e8             	incl   -0x18(%ebp)
  8003fa:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ff:	8b 50 74             	mov    0x74(%eax),%edx
  800402:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800405:	39 c2                	cmp    %eax,%edx
  800407:	77 88                	ja     800391 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800409:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80040d:	75 14                	jne    800423 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80040f:	83 ec 04             	sub    $0x4,%esp
  800412:	68 bc 34 80 00       	push   $0x8034bc
  800417:	6a 3a                	push   $0x3a
  800419:	68 b0 34 80 00       	push   $0x8034b0
  80041e:	e8 93 fe ff ff       	call   8002b6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800423:	ff 45 f0             	incl   -0x10(%ebp)
  800426:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800429:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80042c:	0f 8c 32 ff ff ff    	jl     800364 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800432:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800439:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800440:	eb 26                	jmp    800468 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800442:	a1 20 40 80 00       	mov    0x804020,%eax
  800447:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80044d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800450:	89 d0                	mov    %edx,%eax
  800452:	01 c0                	add    %eax,%eax
  800454:	01 d0                	add    %edx,%eax
  800456:	c1 e0 03             	shl    $0x3,%eax
  800459:	01 c8                	add    %ecx,%eax
  80045b:	8a 40 04             	mov    0x4(%eax),%al
  80045e:	3c 01                	cmp    $0x1,%al
  800460:	75 03                	jne    800465 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800462:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800465:	ff 45 e0             	incl   -0x20(%ebp)
  800468:	a1 20 40 80 00       	mov    0x804020,%eax
  80046d:	8b 50 74             	mov    0x74(%eax),%edx
  800470:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800473:	39 c2                	cmp    %eax,%edx
  800475:	77 cb                	ja     800442 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80047a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80047d:	74 14                	je     800493 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80047f:	83 ec 04             	sub    $0x4,%esp
  800482:	68 10 35 80 00       	push   $0x803510
  800487:	6a 44                	push   $0x44
  800489:	68 b0 34 80 00       	push   $0x8034b0
  80048e:	e8 23 fe ff ff       	call   8002b6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800493:	90                   	nop
  800494:	c9                   	leave  
  800495:	c3                   	ret    

00800496 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800496:	55                   	push   %ebp
  800497:	89 e5                	mov    %esp,%ebp
  800499:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80049c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	8d 48 01             	lea    0x1(%eax),%ecx
  8004a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a7:	89 0a                	mov    %ecx,(%edx)
  8004a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8004ac:	88 d1                	mov    %dl,%cl
  8004ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004bf:	75 2c                	jne    8004ed <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004c1:	a0 24 40 80 00       	mov    0x804024,%al
  8004c6:	0f b6 c0             	movzbl %al,%eax
  8004c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cc:	8b 12                	mov    (%edx),%edx
  8004ce:	89 d1                	mov    %edx,%ecx
  8004d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d3:	83 c2 08             	add    $0x8,%edx
  8004d6:	83 ec 04             	sub    $0x4,%esp
  8004d9:	50                   	push   %eax
  8004da:	51                   	push   %ecx
  8004db:	52                   	push   %edx
  8004dc:	e8 66 13 00 00       	call   801847 <sys_cputs>
  8004e1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f0:	8b 40 04             	mov    0x4(%eax),%eax
  8004f3:	8d 50 01             	lea    0x1(%eax),%edx
  8004f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004fc:	90                   	nop
  8004fd:	c9                   	leave  
  8004fe:	c3                   	ret    

008004ff <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004ff:	55                   	push   %ebp
  800500:	89 e5                	mov    %esp,%ebp
  800502:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800508:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80050f:	00 00 00 
	b.cnt = 0;
  800512:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800519:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80051c:	ff 75 0c             	pushl  0xc(%ebp)
  80051f:	ff 75 08             	pushl  0x8(%ebp)
  800522:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800528:	50                   	push   %eax
  800529:	68 96 04 80 00       	push   $0x800496
  80052e:	e8 11 02 00 00       	call   800744 <vprintfmt>
  800533:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800536:	a0 24 40 80 00       	mov    0x804024,%al
  80053b:	0f b6 c0             	movzbl %al,%eax
  80053e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800544:	83 ec 04             	sub    $0x4,%esp
  800547:	50                   	push   %eax
  800548:	52                   	push   %edx
  800549:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054f:	83 c0 08             	add    $0x8,%eax
  800552:	50                   	push   %eax
  800553:	e8 ef 12 00 00       	call   801847 <sys_cputs>
  800558:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80055b:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800562:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800568:	c9                   	leave  
  800569:	c3                   	ret    

0080056a <cprintf>:

int cprintf(const char *fmt, ...) {
  80056a:	55                   	push   %ebp
  80056b:	89 e5                	mov    %esp,%ebp
  80056d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800570:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800577:	8d 45 0c             	lea    0xc(%ebp),%eax
  80057a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80057d:	8b 45 08             	mov    0x8(%ebp),%eax
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	ff 75 f4             	pushl  -0xc(%ebp)
  800586:	50                   	push   %eax
  800587:	e8 73 ff ff ff       	call   8004ff <vcprintf>
  80058c:	83 c4 10             	add    $0x10,%esp
  80058f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800592:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800595:	c9                   	leave  
  800596:	c3                   	ret    

00800597 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800597:	55                   	push   %ebp
  800598:	89 e5                	mov    %esp,%ebp
  80059a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80059d:	e8 53 14 00 00       	call   8019f5 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005a2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ab:	83 ec 08             	sub    $0x8,%esp
  8005ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b1:	50                   	push   %eax
  8005b2:	e8 48 ff ff ff       	call   8004ff <vcprintf>
  8005b7:	83 c4 10             	add    $0x10,%esp
  8005ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005bd:	e8 4d 14 00 00       	call   801a0f <sys_enable_interrupt>
	return cnt;
  8005c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c5:	c9                   	leave  
  8005c6:	c3                   	ret    

008005c7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c7:	55                   	push   %ebp
  8005c8:	89 e5                	mov    %esp,%ebp
  8005ca:	53                   	push   %ebx
  8005cb:	83 ec 14             	sub    $0x14,%esp
  8005ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005da:	8b 45 18             	mov    0x18(%ebp),%eax
  8005dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e5:	77 55                	ja     80063c <printnum+0x75>
  8005e7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ea:	72 05                	jb     8005f1 <printnum+0x2a>
  8005ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005ef:	77 4b                	ja     80063c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005f1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f7:	8b 45 18             	mov    0x18(%ebp),%eax
  8005fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ff:	52                   	push   %edx
  800600:	50                   	push   %eax
  800601:	ff 75 f4             	pushl  -0xc(%ebp)
  800604:	ff 75 f0             	pushl  -0x10(%ebp)
  800607:	e8 38 29 00 00       	call   802f44 <__udivdi3>
  80060c:	83 c4 10             	add    $0x10,%esp
  80060f:	83 ec 04             	sub    $0x4,%esp
  800612:	ff 75 20             	pushl  0x20(%ebp)
  800615:	53                   	push   %ebx
  800616:	ff 75 18             	pushl  0x18(%ebp)
  800619:	52                   	push   %edx
  80061a:	50                   	push   %eax
  80061b:	ff 75 0c             	pushl  0xc(%ebp)
  80061e:	ff 75 08             	pushl  0x8(%ebp)
  800621:	e8 a1 ff ff ff       	call   8005c7 <printnum>
  800626:	83 c4 20             	add    $0x20,%esp
  800629:	eb 1a                	jmp    800645 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	ff 75 0c             	pushl  0xc(%ebp)
  800631:	ff 75 20             	pushl  0x20(%ebp)
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	ff d0                	call   *%eax
  800639:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80063c:	ff 4d 1c             	decl   0x1c(%ebp)
  80063f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800643:	7f e6                	jg     80062b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800645:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800648:	bb 00 00 00 00       	mov    $0x0,%ebx
  80064d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800650:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800653:	53                   	push   %ebx
  800654:	51                   	push   %ecx
  800655:	52                   	push   %edx
  800656:	50                   	push   %eax
  800657:	e8 f8 29 00 00       	call   803054 <__umoddi3>
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	05 74 37 80 00       	add    $0x803774,%eax
  800664:	8a 00                	mov    (%eax),%al
  800666:	0f be c0             	movsbl %al,%eax
  800669:	83 ec 08             	sub    $0x8,%esp
  80066c:	ff 75 0c             	pushl  0xc(%ebp)
  80066f:	50                   	push   %eax
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	ff d0                	call   *%eax
  800675:	83 c4 10             	add    $0x10,%esp
}
  800678:	90                   	nop
  800679:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    

0080067e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800681:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800685:	7e 1c                	jle    8006a3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800687:	8b 45 08             	mov    0x8(%ebp),%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	8d 50 08             	lea    0x8(%eax),%edx
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	89 10                	mov    %edx,(%eax)
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	83 e8 08             	sub    $0x8,%eax
  80069c:	8b 50 04             	mov    0x4(%eax),%edx
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	eb 40                	jmp    8006e3 <getuint+0x65>
	else if (lflag)
  8006a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a7:	74 1e                	je     8006c7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	8d 50 04             	lea    0x4(%eax),%edx
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	89 10                	mov    %edx,(%eax)
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	83 e8 04             	sub    $0x4,%eax
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c5:	eb 1c                	jmp    8006e3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	8d 50 04             	lea    0x4(%eax),%edx
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	89 10                	mov    %edx,(%eax)
  8006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	83 e8 04             	sub    $0x4,%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006e3:	5d                   	pop    %ebp
  8006e4:	c3                   	ret    

008006e5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ec:	7e 1c                	jle    80070a <getint+0x25>
		return va_arg(*ap, long long);
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	8d 50 08             	lea    0x8(%eax),%edx
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	89 10                	mov    %edx,(%eax)
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	83 e8 08             	sub    $0x8,%eax
  800703:	8b 50 04             	mov    0x4(%eax),%edx
  800706:	8b 00                	mov    (%eax),%eax
  800708:	eb 38                	jmp    800742 <getint+0x5d>
	else if (lflag)
  80070a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070e:	74 1a                	je     80072a <getint+0x45>
		return va_arg(*ap, long);
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	8b 00                	mov    (%eax),%eax
  800715:	8d 50 04             	lea    0x4(%eax),%edx
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	89 10                	mov    %edx,(%eax)
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	8b 00                	mov    (%eax),%eax
  800722:	83 e8 04             	sub    $0x4,%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	99                   	cltd   
  800728:	eb 18                	jmp    800742 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	8d 50 04             	lea    0x4(%eax),%edx
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	89 10                	mov    %edx,(%eax)
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	83 e8 04             	sub    $0x4,%eax
  80073f:	8b 00                	mov    (%eax),%eax
  800741:	99                   	cltd   
}
  800742:	5d                   	pop    %ebp
  800743:	c3                   	ret    

00800744 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	56                   	push   %esi
  800748:	53                   	push   %ebx
  800749:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80074c:	eb 17                	jmp    800765 <vprintfmt+0x21>
			if (ch == '\0')
  80074e:	85 db                	test   %ebx,%ebx
  800750:	0f 84 af 03 00 00    	je     800b05 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	53                   	push   %ebx
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	ff d0                	call   *%eax
  800762:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800765:	8b 45 10             	mov    0x10(%ebp),%eax
  800768:	8d 50 01             	lea    0x1(%eax),%edx
  80076b:	89 55 10             	mov    %edx,0x10(%ebp)
  80076e:	8a 00                	mov    (%eax),%al
  800770:	0f b6 d8             	movzbl %al,%ebx
  800773:	83 fb 25             	cmp    $0x25,%ebx
  800776:	75 d6                	jne    80074e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800778:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80077c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800783:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80078a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800791:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800798:	8b 45 10             	mov    0x10(%ebp),%eax
  80079b:	8d 50 01             	lea    0x1(%eax),%edx
  80079e:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a1:	8a 00                	mov    (%eax),%al
  8007a3:	0f b6 d8             	movzbl %al,%ebx
  8007a6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a9:	83 f8 55             	cmp    $0x55,%eax
  8007ac:	0f 87 2b 03 00 00    	ja     800add <vprintfmt+0x399>
  8007b2:	8b 04 85 98 37 80 00 	mov    0x803798(,%eax,4),%eax
  8007b9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007bb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007bf:	eb d7                	jmp    800798 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007c1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c5:	eb d1                	jmp    800798 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007d1:	89 d0                	mov    %edx,%eax
  8007d3:	c1 e0 02             	shl    $0x2,%eax
  8007d6:	01 d0                	add    %edx,%eax
  8007d8:	01 c0                	add    %eax,%eax
  8007da:	01 d8                	add    %ebx,%eax
  8007dc:	83 e8 30             	sub    $0x30,%eax
  8007df:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e5:	8a 00                	mov    (%eax),%al
  8007e7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007ea:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ed:	7e 3e                	jle    80082d <vprintfmt+0xe9>
  8007ef:	83 fb 39             	cmp    $0x39,%ebx
  8007f2:	7f 39                	jg     80082d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f7:	eb d5                	jmp    8007ce <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	83 c0 04             	add    $0x4,%eax
  8007ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800802:	8b 45 14             	mov    0x14(%ebp),%eax
  800805:	83 e8 04             	sub    $0x4,%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80080d:	eb 1f                	jmp    80082e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800813:	79 83                	jns    800798 <vprintfmt+0x54>
				width = 0;
  800815:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80081c:	e9 77 ff ff ff       	jmp    800798 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800821:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800828:	e9 6b ff ff ff       	jmp    800798 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80082d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800832:	0f 89 60 ff ff ff    	jns    800798 <vprintfmt+0x54>
				width = precision, precision = -1;
  800838:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80083b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800845:	e9 4e ff ff ff       	jmp    800798 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80084a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80084d:	e9 46 ff ff ff       	jmp    800798 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	83 c0 04             	add    $0x4,%eax
  800858:	89 45 14             	mov    %eax,0x14(%ebp)
  80085b:	8b 45 14             	mov    0x14(%ebp),%eax
  80085e:	83 e8 04             	sub    $0x4,%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	ff 75 0c             	pushl  0xc(%ebp)
  800869:	50                   	push   %eax
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	ff d0                	call   *%eax
  80086f:	83 c4 10             	add    $0x10,%esp
			break;
  800872:	e9 89 02 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	83 c0 04             	add    $0x4,%eax
  80087d:	89 45 14             	mov    %eax,0x14(%ebp)
  800880:	8b 45 14             	mov    0x14(%ebp),%eax
  800883:	83 e8 04             	sub    $0x4,%eax
  800886:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800888:	85 db                	test   %ebx,%ebx
  80088a:	79 02                	jns    80088e <vprintfmt+0x14a>
				err = -err;
  80088c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088e:	83 fb 64             	cmp    $0x64,%ebx
  800891:	7f 0b                	jg     80089e <vprintfmt+0x15a>
  800893:	8b 34 9d e0 35 80 00 	mov    0x8035e0(,%ebx,4),%esi
  80089a:	85 f6                	test   %esi,%esi
  80089c:	75 19                	jne    8008b7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089e:	53                   	push   %ebx
  80089f:	68 85 37 80 00       	push   $0x803785
  8008a4:	ff 75 0c             	pushl  0xc(%ebp)
  8008a7:	ff 75 08             	pushl  0x8(%ebp)
  8008aa:	e8 5e 02 00 00       	call   800b0d <printfmt>
  8008af:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b2:	e9 49 02 00 00       	jmp    800b00 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b7:	56                   	push   %esi
  8008b8:	68 8e 37 80 00       	push   $0x80378e
  8008bd:	ff 75 0c             	pushl  0xc(%ebp)
  8008c0:	ff 75 08             	pushl  0x8(%ebp)
  8008c3:	e8 45 02 00 00       	call   800b0d <printfmt>
  8008c8:	83 c4 10             	add    $0x10,%esp
			break;
  8008cb:	e9 30 02 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d3:	83 c0 04             	add    $0x4,%eax
  8008d6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dc:	83 e8 04             	sub    $0x4,%eax
  8008df:	8b 30                	mov    (%eax),%esi
  8008e1:	85 f6                	test   %esi,%esi
  8008e3:	75 05                	jne    8008ea <vprintfmt+0x1a6>
				p = "(null)";
  8008e5:	be 91 37 80 00       	mov    $0x803791,%esi
			if (width > 0 && padc != '-')
  8008ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ee:	7e 6d                	jle    80095d <vprintfmt+0x219>
  8008f0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f4:	74 67                	je     80095d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f9:	83 ec 08             	sub    $0x8,%esp
  8008fc:	50                   	push   %eax
  8008fd:	56                   	push   %esi
  8008fe:	e8 0c 03 00 00       	call   800c0f <strnlen>
  800903:	83 c4 10             	add    $0x10,%esp
  800906:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800909:	eb 16                	jmp    800921 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80090b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	ff 75 0c             	pushl  0xc(%ebp)
  800915:	50                   	push   %eax
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	ff d0                	call   *%eax
  80091b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091e:	ff 4d e4             	decl   -0x1c(%ebp)
  800921:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800925:	7f e4                	jg     80090b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800927:	eb 34                	jmp    80095d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800929:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80092d:	74 1c                	je     80094b <vprintfmt+0x207>
  80092f:	83 fb 1f             	cmp    $0x1f,%ebx
  800932:	7e 05                	jle    800939 <vprintfmt+0x1f5>
  800934:	83 fb 7e             	cmp    $0x7e,%ebx
  800937:	7e 12                	jle    80094b <vprintfmt+0x207>
					putch('?', putdat);
  800939:	83 ec 08             	sub    $0x8,%esp
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	6a 3f                	push   $0x3f
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	ff d0                	call   *%eax
  800946:	83 c4 10             	add    $0x10,%esp
  800949:	eb 0f                	jmp    80095a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	53                   	push   %ebx
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	ff d0                	call   *%eax
  800957:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80095a:	ff 4d e4             	decl   -0x1c(%ebp)
  80095d:	89 f0                	mov    %esi,%eax
  80095f:	8d 70 01             	lea    0x1(%eax),%esi
  800962:	8a 00                	mov    (%eax),%al
  800964:	0f be d8             	movsbl %al,%ebx
  800967:	85 db                	test   %ebx,%ebx
  800969:	74 24                	je     80098f <vprintfmt+0x24b>
  80096b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096f:	78 b8                	js     800929 <vprintfmt+0x1e5>
  800971:	ff 4d e0             	decl   -0x20(%ebp)
  800974:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800978:	79 af                	jns    800929 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80097a:	eb 13                	jmp    80098f <vprintfmt+0x24b>
				putch(' ', putdat);
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	ff 75 0c             	pushl  0xc(%ebp)
  800982:	6a 20                	push   $0x20
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	ff d0                	call   *%eax
  800989:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80098c:	ff 4d e4             	decl   -0x1c(%ebp)
  80098f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800993:	7f e7                	jg     80097c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800995:	e9 66 01 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80099a:	83 ec 08             	sub    $0x8,%esp
  80099d:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a3:	50                   	push   %eax
  8009a4:	e8 3c fd ff ff       	call   8006e5 <getint>
  8009a9:	83 c4 10             	add    $0x10,%esp
  8009ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009af:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b8:	85 d2                	test   %edx,%edx
  8009ba:	79 23                	jns    8009df <vprintfmt+0x29b>
				putch('-', putdat);
  8009bc:	83 ec 08             	sub    $0x8,%esp
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	6a 2d                	push   $0x2d
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	ff d0                	call   *%eax
  8009c9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d2:	f7 d8                	neg    %eax
  8009d4:	83 d2 00             	adc    $0x0,%edx
  8009d7:	f7 da                	neg    %edx
  8009d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009df:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e6:	e9 bc 00 00 00       	jmp    800aa7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009eb:	83 ec 08             	sub    $0x8,%esp
  8009ee:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f1:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f4:	50                   	push   %eax
  8009f5:	e8 84 fc ff ff       	call   80067e <getuint>
  8009fa:	83 c4 10             	add    $0x10,%esp
  8009fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a00:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a03:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a0a:	e9 98 00 00 00       	jmp    800aa7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	6a 58                	push   $0x58
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	ff d0                	call   *%eax
  800a1c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1f:	83 ec 08             	sub    $0x8,%esp
  800a22:	ff 75 0c             	pushl  0xc(%ebp)
  800a25:	6a 58                	push   $0x58
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	ff d0                	call   *%eax
  800a2c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2f:	83 ec 08             	sub    $0x8,%esp
  800a32:	ff 75 0c             	pushl  0xc(%ebp)
  800a35:	6a 58                	push   $0x58
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	ff d0                	call   *%eax
  800a3c:	83 c4 10             	add    $0x10,%esp
			break;
  800a3f:	e9 bc 00 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	6a 30                	push   $0x30
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	ff d0                	call   *%eax
  800a51:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 0c             	pushl  0xc(%ebp)
  800a5a:	6a 78                	push   $0x78
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	ff d0                	call   *%eax
  800a61:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a64:	8b 45 14             	mov    0x14(%ebp),%eax
  800a67:	83 c0 04             	add    $0x4,%eax
  800a6a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a70:	83 e8 04             	sub    $0x4,%eax
  800a73:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a86:	eb 1f                	jmp    800aa7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a88:	83 ec 08             	sub    $0x8,%esp
  800a8b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a91:	50                   	push   %eax
  800a92:	e8 e7 fb ff ff       	call   80067e <getuint>
  800a97:	83 c4 10             	add    $0x10,%esp
  800a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aa0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aae:	83 ec 04             	sub    $0x4,%esp
  800ab1:	52                   	push   %edx
  800ab2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab5:	50                   	push   %eax
  800ab6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab9:	ff 75 f0             	pushl  -0x10(%ebp)
  800abc:	ff 75 0c             	pushl  0xc(%ebp)
  800abf:	ff 75 08             	pushl  0x8(%ebp)
  800ac2:	e8 00 fb ff ff       	call   8005c7 <printnum>
  800ac7:	83 c4 20             	add    $0x20,%esp
			break;
  800aca:	eb 34                	jmp    800b00 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	ff 75 0c             	pushl  0xc(%ebp)
  800ad2:	53                   	push   %ebx
  800ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad6:	ff d0                	call   *%eax
  800ad8:	83 c4 10             	add    $0x10,%esp
			break;
  800adb:	eb 23                	jmp    800b00 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800add:	83 ec 08             	sub    $0x8,%esp
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	6a 25                	push   $0x25
  800ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae8:	ff d0                	call   *%eax
  800aea:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aed:	ff 4d 10             	decl   0x10(%ebp)
  800af0:	eb 03                	jmp    800af5 <vprintfmt+0x3b1>
  800af2:	ff 4d 10             	decl   0x10(%ebp)
  800af5:	8b 45 10             	mov    0x10(%ebp),%eax
  800af8:	48                   	dec    %eax
  800af9:	8a 00                	mov    (%eax),%al
  800afb:	3c 25                	cmp    $0x25,%al
  800afd:	75 f3                	jne    800af2 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aff:	90                   	nop
		}
	}
  800b00:	e9 47 fc ff ff       	jmp    80074c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b05:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b06:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b09:	5b                   	pop    %ebx
  800b0a:	5e                   	pop    %esi
  800b0b:	5d                   	pop    %ebp
  800b0c:	c3                   	ret    

00800b0d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b13:	8d 45 10             	lea    0x10(%ebp),%eax
  800b16:	83 c0 04             	add    $0x4,%eax
  800b19:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b22:	50                   	push   %eax
  800b23:	ff 75 0c             	pushl  0xc(%ebp)
  800b26:	ff 75 08             	pushl  0x8(%ebp)
  800b29:	e8 16 fc ff ff       	call   800744 <vprintfmt>
  800b2e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b31:	90                   	nop
  800b32:	c9                   	leave  
  800b33:	c3                   	ret    

00800b34 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3a:	8b 40 08             	mov    0x8(%eax),%eax
  800b3d:	8d 50 01             	lea    0x1(%eax),%edx
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b49:	8b 10                	mov    (%eax),%edx
  800b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4e:	8b 40 04             	mov    0x4(%eax),%eax
  800b51:	39 c2                	cmp    %eax,%edx
  800b53:	73 12                	jae    800b67 <sprintputch+0x33>
		*b->buf++ = ch;
  800b55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	8d 48 01             	lea    0x1(%eax),%ecx
  800b5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b60:	89 0a                	mov    %ecx,(%edx)
  800b62:	8b 55 08             	mov    0x8(%ebp),%edx
  800b65:	88 10                	mov    %dl,(%eax)
}
  800b67:	90                   	nop
  800b68:	5d                   	pop    %ebp
  800b69:	c3                   	ret    

00800b6a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b79:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	01 d0                	add    %edx,%eax
  800b81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b8f:	74 06                	je     800b97 <vsnprintf+0x2d>
  800b91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b95:	7f 07                	jg     800b9e <vsnprintf+0x34>
		return -E_INVAL;
  800b97:	b8 03 00 00 00       	mov    $0x3,%eax
  800b9c:	eb 20                	jmp    800bbe <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b9e:	ff 75 14             	pushl  0x14(%ebp)
  800ba1:	ff 75 10             	pushl  0x10(%ebp)
  800ba4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ba7:	50                   	push   %eax
  800ba8:	68 34 0b 80 00       	push   $0x800b34
  800bad:	e8 92 fb ff ff       	call   800744 <vprintfmt>
  800bb2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bb8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bc6:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc9:	83 c0 04             	add    $0x4,%eax
  800bcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd2:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd5:	50                   	push   %eax
  800bd6:	ff 75 0c             	pushl  0xc(%ebp)
  800bd9:	ff 75 08             	pushl  0x8(%ebp)
  800bdc:	e8 89 ff ff ff       	call   800b6a <vsnprintf>
  800be1:	83 c4 10             	add    $0x10,%esp
  800be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf9:	eb 06                	jmp    800c01 <strlen+0x15>
		n++;
  800bfb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bfe:	ff 45 08             	incl   0x8(%ebp)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8a 00                	mov    (%eax),%al
  800c06:	84 c0                	test   %al,%al
  800c08:	75 f1                	jne    800bfb <strlen+0xf>
		n++;
	return n;
  800c0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0d:	c9                   	leave  
  800c0e:	c3                   	ret    

00800c0f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c1c:	eb 09                	jmp    800c27 <strnlen+0x18>
		n++;
  800c1e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c21:	ff 45 08             	incl   0x8(%ebp)
  800c24:	ff 4d 0c             	decl   0xc(%ebp)
  800c27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c2b:	74 09                	je     800c36 <strnlen+0x27>
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	8a 00                	mov    (%eax),%al
  800c32:	84 c0                	test   %al,%al
  800c34:	75 e8                	jne    800c1e <strnlen+0xf>
		n++;
	return n;
  800c36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c39:	c9                   	leave  
  800c3a:	c3                   	ret    

00800c3b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c47:	90                   	nop
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8d 50 01             	lea    0x1(%eax),%edx
  800c4e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c51:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c54:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c57:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c5a:	8a 12                	mov    (%edx),%dl
  800c5c:	88 10                	mov    %dl,(%eax)
  800c5e:	8a 00                	mov    (%eax),%al
  800c60:	84 c0                	test   %al,%al
  800c62:	75 e4                	jne    800c48 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c64:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7c:	eb 1f                	jmp    800c9d <strncpy+0x34>
		*dst++ = *src;
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8d 50 01             	lea    0x1(%eax),%edx
  800c84:	89 55 08             	mov    %edx,0x8(%ebp)
  800c87:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8a:	8a 12                	mov    (%edx),%dl
  800c8c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	84 c0                	test   %al,%al
  800c95:	74 03                	je     800c9a <strncpy+0x31>
			src++;
  800c97:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c9a:	ff 45 fc             	incl   -0x4(%ebp)
  800c9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ca3:	72 d9                	jb     800c7e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ca5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cb6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cba:	74 30                	je     800cec <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cbc:	eb 16                	jmp    800cd4 <strlcpy+0x2a>
			*dst++ = *src++;
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8d 50 01             	lea    0x1(%eax),%edx
  800cc4:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cca:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ccd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd0:	8a 12                	mov    (%edx),%dl
  800cd2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cd4:	ff 4d 10             	decl   0x10(%ebp)
  800cd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cdb:	74 09                	je     800ce6 <strlcpy+0x3c>
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	84 c0                	test   %al,%al
  800ce4:	75 d8                	jne    800cbe <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cec:	8b 55 08             	mov    0x8(%ebp),%edx
  800cef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf2:	29 c2                	sub    %eax,%edx
  800cf4:	89 d0                	mov    %edx,%eax
}
  800cf6:	c9                   	leave  
  800cf7:	c3                   	ret    

00800cf8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cfb:	eb 06                	jmp    800d03 <strcmp+0xb>
		p++, q++;
  800cfd:	ff 45 08             	incl   0x8(%ebp)
  800d00:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	8a 00                	mov    (%eax),%al
  800d08:	84 c0                	test   %al,%al
  800d0a:	74 0e                	je     800d1a <strcmp+0x22>
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8a 10                	mov    (%eax),%dl
  800d11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d14:	8a 00                	mov    (%eax),%al
  800d16:	38 c2                	cmp    %al,%dl
  800d18:	74 e3                	je     800cfd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	0f b6 d0             	movzbl %al,%edx
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	0f b6 c0             	movzbl %al,%eax
  800d2a:	29 c2                	sub    %eax,%edx
  800d2c:	89 d0                	mov    %edx,%eax
}
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    

00800d30 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d33:	eb 09                	jmp    800d3e <strncmp+0xe>
		n--, p++, q++;
  800d35:	ff 4d 10             	decl   0x10(%ebp)
  800d38:	ff 45 08             	incl   0x8(%ebp)
  800d3b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d42:	74 17                	je     800d5b <strncmp+0x2b>
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	84 c0                	test   %al,%al
  800d4b:	74 0e                	je     800d5b <strncmp+0x2b>
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 10                	mov    (%eax),%dl
  800d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	38 c2                	cmp    %al,%dl
  800d59:	74 da                	je     800d35 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5f:	75 07                	jne    800d68 <strncmp+0x38>
		return 0;
  800d61:	b8 00 00 00 00       	mov    $0x0,%eax
  800d66:	eb 14                	jmp    800d7c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	0f b6 d0             	movzbl %al,%edx
  800d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	0f b6 c0             	movzbl %al,%eax
  800d78:	29 c2                	sub    %eax,%edx
  800d7a:	89 d0                	mov    %edx,%eax
}
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    

00800d7e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	83 ec 04             	sub    $0x4,%esp
  800d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d87:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d8a:	eb 12                	jmp    800d9e <strchr+0x20>
		if (*s == c)
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d94:	75 05                	jne    800d9b <strchr+0x1d>
			return (char *) s;
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	eb 11                	jmp    800dac <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d9b:	ff 45 08             	incl   0x8(%ebp)
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8a 00                	mov    (%eax),%al
  800da3:	84 c0                	test   %al,%al
  800da5:	75 e5                	jne    800d8c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800da7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dac:	c9                   	leave  
  800dad:	c3                   	ret    

00800dae <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	83 ec 04             	sub    $0x4,%esp
  800db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dba:	eb 0d                	jmp    800dc9 <strfind+0x1b>
		if (*s == c)
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	8a 00                	mov    (%eax),%al
  800dc1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc4:	74 0e                	je     800dd4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dc6:	ff 45 08             	incl   0x8(%ebp)
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	84 c0                	test   %al,%al
  800dd0:	75 ea                	jne    800dbc <strfind+0xe>
  800dd2:	eb 01                	jmp    800dd5 <strfind+0x27>
		if (*s == c)
			break;
  800dd4:	90                   	nop
	return (char *) s;
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd8:	c9                   	leave  
  800dd9:	c3                   	ret    

00800dda <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800de6:	8b 45 10             	mov    0x10(%ebp),%eax
  800de9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dec:	eb 0e                	jmp    800dfc <memset+0x22>
		*p++ = c;
  800dee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df1:	8d 50 01             	lea    0x1(%eax),%edx
  800df4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800df7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dfa:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dfc:	ff 4d f8             	decl   -0x8(%ebp)
  800dff:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e03:	79 e9                	jns    800dee <memset+0x14>
		*p++ = c;

	return v;
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e08:	c9                   	leave  
  800e09:	c3                   	ret    

00800e0a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e1c:	eb 16                	jmp    800e34 <memcpy+0x2a>
		*d++ = *s++;
  800e1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e21:	8d 50 01             	lea    0x1(%eax),%edx
  800e24:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e27:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e2d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e30:	8a 12                	mov    (%edx),%dl
  800e32:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e34:	8b 45 10             	mov    0x10(%ebp),%eax
  800e37:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e3a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e3d:	85 c0                	test   %eax,%eax
  800e3f:	75 dd                	jne    800e1e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e44:	c9                   	leave  
  800e45:	c3                   	ret    

00800e46 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e5e:	73 50                	jae    800eb0 <memmove+0x6a>
  800e60:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e63:	8b 45 10             	mov    0x10(%ebp),%eax
  800e66:	01 d0                	add    %edx,%eax
  800e68:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e6b:	76 43                	jbe    800eb0 <memmove+0x6a>
		s += n;
  800e6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e70:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e73:	8b 45 10             	mov    0x10(%ebp),%eax
  800e76:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e79:	eb 10                	jmp    800e8b <memmove+0x45>
			*--d = *--s;
  800e7b:	ff 4d f8             	decl   -0x8(%ebp)
  800e7e:	ff 4d fc             	decl   -0x4(%ebp)
  800e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e84:	8a 10                	mov    (%eax),%dl
  800e86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e89:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e91:	89 55 10             	mov    %edx,0x10(%ebp)
  800e94:	85 c0                	test   %eax,%eax
  800e96:	75 e3                	jne    800e7b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e98:	eb 23                	jmp    800ebd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9d:	8d 50 01             	lea    0x1(%eax),%edx
  800ea0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ea3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eac:	8a 12                	mov    (%edx),%dl
  800eae:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb6:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	75 dd                	jne    800e9a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ed4:	eb 2a                	jmp    800f00 <memcmp+0x3e>
		if (*s1 != *s2)
  800ed6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed9:	8a 10                	mov    (%eax),%dl
  800edb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ede:	8a 00                	mov    (%eax),%al
  800ee0:	38 c2                	cmp    %al,%dl
  800ee2:	74 16                	je     800efa <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ee4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	0f b6 d0             	movzbl %al,%edx
  800eec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eef:	8a 00                	mov    (%eax),%al
  800ef1:	0f b6 c0             	movzbl %al,%eax
  800ef4:	29 c2                	sub    %eax,%edx
  800ef6:	89 d0                	mov    %edx,%eax
  800ef8:	eb 18                	jmp    800f12 <memcmp+0x50>
		s1++, s2++;
  800efa:	ff 45 fc             	incl   -0x4(%ebp)
  800efd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f00:	8b 45 10             	mov    0x10(%ebp),%eax
  800f03:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f06:	89 55 10             	mov    %edx,0x10(%ebp)
  800f09:	85 c0                	test   %eax,%eax
  800f0b:	75 c9                	jne    800ed6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f12:	c9                   	leave  
  800f13:	c3                   	ret    

00800f14 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f20:	01 d0                	add    %edx,%eax
  800f22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f25:	eb 15                	jmp    800f3c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	0f b6 d0             	movzbl %al,%edx
  800f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f32:	0f b6 c0             	movzbl %al,%eax
  800f35:	39 c2                	cmp    %eax,%edx
  800f37:	74 0d                	je     800f46 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f39:	ff 45 08             	incl   0x8(%ebp)
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f42:	72 e3                	jb     800f27 <memfind+0x13>
  800f44:	eb 01                	jmp    800f47 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f46:	90                   	nop
	return (void *) s;
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f4a:	c9                   	leave  
  800f4b:	c3                   	ret    

00800f4c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
  800f4f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f59:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f60:	eb 03                	jmp    800f65 <strtol+0x19>
		s++;
  800f62:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	3c 20                	cmp    $0x20,%al
  800f6c:	74 f4                	je     800f62 <strtol+0x16>
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	8a 00                	mov    (%eax),%al
  800f73:	3c 09                	cmp    $0x9,%al
  800f75:	74 eb                	je     800f62 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	3c 2b                	cmp    $0x2b,%al
  800f7e:	75 05                	jne    800f85 <strtol+0x39>
		s++;
  800f80:	ff 45 08             	incl   0x8(%ebp)
  800f83:	eb 13                	jmp    800f98 <strtol+0x4c>
	else if (*s == '-')
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	3c 2d                	cmp    $0x2d,%al
  800f8c:	75 0a                	jne    800f98 <strtol+0x4c>
		s++, neg = 1;
  800f8e:	ff 45 08             	incl   0x8(%ebp)
  800f91:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9c:	74 06                	je     800fa4 <strtol+0x58>
  800f9e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fa2:	75 20                	jne    800fc4 <strtol+0x78>
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	3c 30                	cmp    $0x30,%al
  800fab:	75 17                	jne    800fc4 <strtol+0x78>
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	40                   	inc    %eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	3c 78                	cmp    $0x78,%al
  800fb5:	75 0d                	jne    800fc4 <strtol+0x78>
		s += 2, base = 16;
  800fb7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fbb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fc2:	eb 28                	jmp    800fec <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc8:	75 15                	jne    800fdf <strtol+0x93>
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	3c 30                	cmp    $0x30,%al
  800fd1:	75 0c                	jne    800fdf <strtol+0x93>
		s++, base = 8;
  800fd3:	ff 45 08             	incl   0x8(%ebp)
  800fd6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fdd:	eb 0d                	jmp    800fec <strtol+0xa0>
	else if (base == 0)
  800fdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe3:	75 07                	jne    800fec <strtol+0xa0>
		base = 10;
  800fe5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	3c 2f                	cmp    $0x2f,%al
  800ff3:	7e 19                	jle    80100e <strtol+0xc2>
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	3c 39                	cmp    $0x39,%al
  800ffc:	7f 10                	jg     80100e <strtol+0xc2>
			dig = *s - '0';
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	0f be c0             	movsbl %al,%eax
  801006:	83 e8 30             	sub    $0x30,%eax
  801009:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80100c:	eb 42                	jmp    801050 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	3c 60                	cmp    $0x60,%al
  801015:	7e 19                	jle    801030 <strtol+0xe4>
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	8a 00                	mov    (%eax),%al
  80101c:	3c 7a                	cmp    $0x7a,%al
  80101e:	7f 10                	jg     801030 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	0f be c0             	movsbl %al,%eax
  801028:	83 e8 57             	sub    $0x57,%eax
  80102b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80102e:	eb 20                	jmp    801050 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	3c 40                	cmp    $0x40,%al
  801037:	7e 39                	jle    801072 <strtol+0x126>
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	3c 5a                	cmp    $0x5a,%al
  801040:	7f 30                	jg     801072 <strtol+0x126>
			dig = *s - 'A' + 10;
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	0f be c0             	movsbl %al,%eax
  80104a:	83 e8 37             	sub    $0x37,%eax
  80104d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801053:	3b 45 10             	cmp    0x10(%ebp),%eax
  801056:	7d 19                	jge    801071 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801058:	ff 45 08             	incl   0x8(%ebp)
  80105b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801062:	89 c2                	mov    %eax,%edx
  801064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801067:	01 d0                	add    %edx,%eax
  801069:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80106c:	e9 7b ff ff ff       	jmp    800fec <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801071:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801072:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801076:	74 08                	je     801080 <strtol+0x134>
		*endptr = (char *) s;
  801078:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107b:	8b 55 08             	mov    0x8(%ebp),%edx
  80107e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801080:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801084:	74 07                	je     80108d <strtol+0x141>
  801086:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801089:	f7 d8                	neg    %eax
  80108b:	eb 03                	jmp    801090 <strtol+0x144>
  80108d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801090:	c9                   	leave  
  801091:	c3                   	ret    

00801092 <ltostr>:

void
ltostr(long value, char *str)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801098:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80109f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010aa:	79 13                	jns    8010bf <ltostr+0x2d>
	{
		neg = 1;
  8010ac:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010b9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010bc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010c7:	99                   	cltd   
  8010c8:	f7 f9                	idiv   %ecx
  8010ca:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d0:	8d 50 01             	lea    0x1(%eax),%edx
  8010d3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d6:	89 c2                	mov    %eax,%edx
  8010d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010db:	01 d0                	add    %edx,%eax
  8010dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010e0:	83 c2 30             	add    $0x30,%edx
  8010e3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ed:	f7 e9                	imul   %ecx
  8010ef:	c1 fa 02             	sar    $0x2,%edx
  8010f2:	89 c8                	mov    %ecx,%eax
  8010f4:	c1 f8 1f             	sar    $0x1f,%eax
  8010f7:	29 c2                	sub    %eax,%edx
  8010f9:	89 d0                	mov    %edx,%eax
  8010fb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801101:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801106:	f7 e9                	imul   %ecx
  801108:	c1 fa 02             	sar    $0x2,%edx
  80110b:	89 c8                	mov    %ecx,%eax
  80110d:	c1 f8 1f             	sar    $0x1f,%eax
  801110:	29 c2                	sub    %eax,%edx
  801112:	89 d0                	mov    %edx,%eax
  801114:	c1 e0 02             	shl    $0x2,%eax
  801117:	01 d0                	add    %edx,%eax
  801119:	01 c0                	add    %eax,%eax
  80111b:	29 c1                	sub    %eax,%ecx
  80111d:	89 ca                	mov    %ecx,%edx
  80111f:	85 d2                	test   %edx,%edx
  801121:	75 9c                	jne    8010bf <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801123:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80112a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112d:	48                   	dec    %eax
  80112e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801131:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801135:	74 3d                	je     801174 <ltostr+0xe2>
		start = 1 ;
  801137:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80113e:	eb 34                	jmp    801174 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801140:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801143:	8b 45 0c             	mov    0xc(%ebp),%eax
  801146:	01 d0                	add    %edx,%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80114d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801150:	8b 45 0c             	mov    0xc(%ebp),%eax
  801153:	01 c2                	add    %eax,%edx
  801155:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	01 c8                	add    %ecx,%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801161:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801164:	8b 45 0c             	mov    0xc(%ebp),%eax
  801167:	01 c2                	add    %eax,%edx
  801169:	8a 45 eb             	mov    -0x15(%ebp),%al
  80116c:	88 02                	mov    %al,(%edx)
		start++ ;
  80116e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801171:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801177:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80117a:	7c c4                	jl     801140 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80117c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80117f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801182:	01 d0                	add    %edx,%eax
  801184:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801187:	90                   	nop
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801190:	ff 75 08             	pushl  0x8(%ebp)
  801193:	e8 54 fa ff ff       	call   800bec <strlen>
  801198:	83 c4 04             	add    $0x4,%esp
  80119b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80119e:	ff 75 0c             	pushl  0xc(%ebp)
  8011a1:	e8 46 fa ff ff       	call   800bec <strlen>
  8011a6:	83 c4 04             	add    $0x4,%esp
  8011a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ba:	eb 17                	jmp    8011d3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c2:	01 c2                	add    %eax,%edx
  8011c4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	01 c8                	add    %ecx,%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011d0:	ff 45 fc             	incl   -0x4(%ebp)
  8011d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011d9:	7c e1                	jl     8011bc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011e9:	eb 1f                	jmp    80120a <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ee:	8d 50 01             	lea    0x1(%eax),%edx
  8011f1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f4:	89 c2                	mov    %eax,%edx
  8011f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f9:	01 c2                	add    %eax,%edx
  8011fb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801201:	01 c8                	add    %ecx,%eax
  801203:	8a 00                	mov    (%eax),%al
  801205:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801207:	ff 45 f8             	incl   -0x8(%ebp)
  80120a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801210:	7c d9                	jl     8011eb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801212:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801215:	8b 45 10             	mov    0x10(%ebp),%eax
  801218:	01 d0                	add    %edx,%eax
  80121a:	c6 00 00             	movb   $0x0,(%eax)
}
  80121d:	90                   	nop
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801223:	8b 45 14             	mov    0x14(%ebp),%eax
  801226:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80122c:	8b 45 14             	mov    0x14(%ebp),%eax
  80122f:	8b 00                	mov    (%eax),%eax
  801231:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801238:	8b 45 10             	mov    0x10(%ebp),%eax
  80123b:	01 d0                	add    %edx,%eax
  80123d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801243:	eb 0c                	jmp    801251 <strsplit+0x31>
			*string++ = 0;
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8d 50 01             	lea    0x1(%eax),%edx
  80124b:	89 55 08             	mov    %edx,0x8(%ebp)
  80124e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	8a 00                	mov    (%eax),%al
  801256:	84 c0                	test   %al,%al
  801258:	74 18                	je     801272 <strsplit+0x52>
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	8a 00                	mov    (%eax),%al
  80125f:	0f be c0             	movsbl %al,%eax
  801262:	50                   	push   %eax
  801263:	ff 75 0c             	pushl  0xc(%ebp)
  801266:	e8 13 fb ff ff       	call   800d7e <strchr>
  80126b:	83 c4 08             	add    $0x8,%esp
  80126e:	85 c0                	test   %eax,%eax
  801270:	75 d3                	jne    801245 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	84 c0                	test   %al,%al
  801279:	74 5a                	je     8012d5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80127b:	8b 45 14             	mov    0x14(%ebp),%eax
  80127e:	8b 00                	mov    (%eax),%eax
  801280:	83 f8 0f             	cmp    $0xf,%eax
  801283:	75 07                	jne    80128c <strsplit+0x6c>
		{
			return 0;
  801285:	b8 00 00 00 00       	mov    $0x0,%eax
  80128a:	eb 66                	jmp    8012f2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80128c:	8b 45 14             	mov    0x14(%ebp),%eax
  80128f:	8b 00                	mov    (%eax),%eax
  801291:	8d 48 01             	lea    0x1(%eax),%ecx
  801294:	8b 55 14             	mov    0x14(%ebp),%edx
  801297:	89 0a                	mov    %ecx,(%edx)
  801299:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a3:	01 c2                	add    %eax,%edx
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012aa:	eb 03                	jmp    8012af <strsplit+0x8f>
			string++;
  8012ac:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b2:	8a 00                	mov    (%eax),%al
  8012b4:	84 c0                	test   %al,%al
  8012b6:	74 8b                	je     801243 <strsplit+0x23>
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	0f be c0             	movsbl %al,%eax
  8012c0:	50                   	push   %eax
  8012c1:	ff 75 0c             	pushl  0xc(%ebp)
  8012c4:	e8 b5 fa ff ff       	call   800d7e <strchr>
  8012c9:	83 c4 08             	add    $0x8,%esp
  8012cc:	85 c0                	test   %eax,%eax
  8012ce:	74 dc                	je     8012ac <strsplit+0x8c>
			string++;
	}
  8012d0:	e9 6e ff ff ff       	jmp    801243 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012d5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d9:	8b 00                	mov    (%eax),%eax
  8012db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e5:	01 d0                	add    %edx,%eax
  8012e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012ed:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012fa:	a1 04 40 80 00       	mov    0x804004,%eax
  8012ff:	85 c0                	test   %eax,%eax
  801301:	74 1f                	je     801322 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801303:	e8 1d 00 00 00       	call   801325 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801308:	83 ec 0c             	sub    $0xc,%esp
  80130b:	68 f0 38 80 00       	push   $0x8038f0
  801310:	e8 55 f2 ff ff       	call   80056a <cprintf>
  801315:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801318:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80131f:	00 00 00 
	}
}
  801322:	90                   	nop
  801323:	c9                   	leave  
  801324:	c3                   	ret    

00801325 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
  801328:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  80132b:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801332:	00 00 00 
  801335:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80133c:	00 00 00 
  80133f:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801346:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801349:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801350:	00 00 00 
  801353:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80135a:	00 00 00 
  80135d:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801364:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801367:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80136e:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801371:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80137b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801380:	2d 00 10 00 00       	sub    $0x1000,%eax
  801385:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  80138a:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801391:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801394:	a1 20 41 80 00       	mov    0x804120,%eax
  801399:	0f af c2             	imul   %edx,%eax
  80139c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  80139f:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8013a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013ac:	01 d0                	add    %edx,%eax
  8013ae:	48                   	dec    %eax
  8013af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8013b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ba:	f7 75 e8             	divl   -0x18(%ebp)
  8013bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013c0:	29 d0                	sub    %edx,%eax
  8013c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  8013c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013c8:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  8013cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013d2:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8013d8:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8013de:	83 ec 04             	sub    $0x4,%esp
  8013e1:	6a 06                	push   $0x6
  8013e3:	50                   	push   %eax
  8013e4:	52                   	push   %edx
  8013e5:	e8 a1 05 00 00       	call   80198b <sys_allocate_chunk>
  8013ea:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013ed:	a1 20 41 80 00       	mov    0x804120,%eax
  8013f2:	83 ec 0c             	sub    $0xc,%esp
  8013f5:	50                   	push   %eax
  8013f6:	e8 16 0c 00 00       	call   802011 <initialize_MemBlocksList>
  8013fb:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  8013fe:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801403:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801406:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80140a:	75 14                	jne    801420 <initialize_dyn_block_system+0xfb>
  80140c:	83 ec 04             	sub    $0x4,%esp
  80140f:	68 15 39 80 00       	push   $0x803915
  801414:	6a 2d                	push   $0x2d
  801416:	68 33 39 80 00       	push   $0x803933
  80141b:	e8 96 ee ff ff       	call   8002b6 <_panic>
  801420:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801423:	8b 00                	mov    (%eax),%eax
  801425:	85 c0                	test   %eax,%eax
  801427:	74 10                	je     801439 <initialize_dyn_block_system+0x114>
  801429:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80142c:	8b 00                	mov    (%eax),%eax
  80142e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801431:	8b 52 04             	mov    0x4(%edx),%edx
  801434:	89 50 04             	mov    %edx,0x4(%eax)
  801437:	eb 0b                	jmp    801444 <initialize_dyn_block_system+0x11f>
  801439:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80143c:	8b 40 04             	mov    0x4(%eax),%eax
  80143f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801444:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801447:	8b 40 04             	mov    0x4(%eax),%eax
  80144a:	85 c0                	test   %eax,%eax
  80144c:	74 0f                	je     80145d <initialize_dyn_block_system+0x138>
  80144e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801451:	8b 40 04             	mov    0x4(%eax),%eax
  801454:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801457:	8b 12                	mov    (%edx),%edx
  801459:	89 10                	mov    %edx,(%eax)
  80145b:	eb 0a                	jmp    801467 <initialize_dyn_block_system+0x142>
  80145d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801460:	8b 00                	mov    (%eax),%eax
  801462:	a3 48 41 80 00       	mov    %eax,0x804148
  801467:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80146a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801470:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801473:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80147a:	a1 54 41 80 00       	mov    0x804154,%eax
  80147f:	48                   	dec    %eax
  801480:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801485:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801488:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  80148f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801492:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801499:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80149d:	75 14                	jne    8014b3 <initialize_dyn_block_system+0x18e>
  80149f:	83 ec 04             	sub    $0x4,%esp
  8014a2:	68 40 39 80 00       	push   $0x803940
  8014a7:	6a 30                	push   $0x30
  8014a9:	68 33 39 80 00       	push   $0x803933
  8014ae:	e8 03 ee ff ff       	call   8002b6 <_panic>
  8014b3:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8014b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014bc:	89 50 04             	mov    %edx,0x4(%eax)
  8014bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014c2:	8b 40 04             	mov    0x4(%eax),%eax
  8014c5:	85 c0                	test   %eax,%eax
  8014c7:	74 0c                	je     8014d5 <initialize_dyn_block_system+0x1b0>
  8014c9:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8014ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014d1:	89 10                	mov    %edx,(%eax)
  8014d3:	eb 08                	jmp    8014dd <initialize_dyn_block_system+0x1b8>
  8014d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014d8:	a3 38 41 80 00       	mov    %eax,0x804138
  8014dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014e0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8014e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014ee:	a1 44 41 80 00       	mov    0x804144,%eax
  8014f3:	40                   	inc    %eax
  8014f4:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8014f9:	90                   	nop
  8014fa:	c9                   	leave  
  8014fb:	c3                   	ret    

008014fc <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
  8014ff:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801502:	e8 ed fd ff ff       	call   8012f4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801507:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80150b:	75 07                	jne    801514 <malloc+0x18>
  80150d:	b8 00 00 00 00       	mov    $0x0,%eax
  801512:	eb 67                	jmp    80157b <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801514:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80151b:	8b 55 08             	mov    0x8(%ebp),%edx
  80151e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801521:	01 d0                	add    %edx,%eax
  801523:	48                   	dec    %eax
  801524:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801527:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152a:	ba 00 00 00 00       	mov    $0x0,%edx
  80152f:	f7 75 f4             	divl   -0xc(%ebp)
  801532:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801535:	29 d0                	sub    %edx,%eax
  801537:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80153a:	e8 1a 08 00 00       	call   801d59 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80153f:	85 c0                	test   %eax,%eax
  801541:	74 33                	je     801576 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801543:	83 ec 0c             	sub    $0xc,%esp
  801546:	ff 75 08             	pushl  0x8(%ebp)
  801549:	e8 0c 0e 00 00       	call   80235a <alloc_block_FF>
  80154e:	83 c4 10             	add    $0x10,%esp
  801551:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801554:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801558:	74 1c                	je     801576 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  80155a:	83 ec 0c             	sub    $0xc,%esp
  80155d:	ff 75 ec             	pushl  -0x14(%ebp)
  801560:	e8 07 0c 00 00       	call   80216c <insert_sorted_allocList>
  801565:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801568:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80156b:	8b 40 08             	mov    0x8(%eax),%eax
  80156e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801571:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801574:	eb 05                	jmp    80157b <malloc+0x7f>
		}
	}
	return NULL;
  801576:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    

0080157d <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801589:	83 ec 08             	sub    $0x8,%esp
  80158c:	ff 75 f4             	pushl  -0xc(%ebp)
  80158f:	68 40 40 80 00       	push   $0x804040
  801594:	e8 5b 0b 00 00       	call   8020f4 <find_block>
  801599:	83 c4 10             	add    $0x10,%esp
  80159c:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  80159f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8015a5:	83 ec 08             	sub    $0x8,%esp
  8015a8:	50                   	push   %eax
  8015a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8015ac:	e8 a2 03 00 00       	call   801953 <sys_free_user_mem>
  8015b1:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  8015b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015b8:	75 14                	jne    8015ce <free+0x51>
  8015ba:	83 ec 04             	sub    $0x4,%esp
  8015bd:	68 15 39 80 00       	push   $0x803915
  8015c2:	6a 76                	push   $0x76
  8015c4:	68 33 39 80 00       	push   $0x803933
  8015c9:	e8 e8 ec ff ff       	call   8002b6 <_panic>
  8015ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d1:	8b 00                	mov    (%eax),%eax
  8015d3:	85 c0                	test   %eax,%eax
  8015d5:	74 10                	je     8015e7 <free+0x6a>
  8015d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015da:	8b 00                	mov    (%eax),%eax
  8015dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015df:	8b 52 04             	mov    0x4(%edx),%edx
  8015e2:	89 50 04             	mov    %edx,0x4(%eax)
  8015e5:	eb 0b                	jmp    8015f2 <free+0x75>
  8015e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ea:	8b 40 04             	mov    0x4(%eax),%eax
  8015ed:	a3 44 40 80 00       	mov    %eax,0x804044
  8015f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f5:	8b 40 04             	mov    0x4(%eax),%eax
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	74 0f                	je     80160b <free+0x8e>
  8015fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ff:	8b 40 04             	mov    0x4(%eax),%eax
  801602:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801605:	8b 12                	mov    (%edx),%edx
  801607:	89 10                	mov    %edx,(%eax)
  801609:	eb 0a                	jmp    801615 <free+0x98>
  80160b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160e:	8b 00                	mov    (%eax),%eax
  801610:	a3 40 40 80 00       	mov    %eax,0x804040
  801615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801618:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80161e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801621:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801628:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80162d:	48                   	dec    %eax
  80162e:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  801633:	83 ec 0c             	sub    $0xc,%esp
  801636:	ff 75 f0             	pushl  -0x10(%ebp)
  801639:	e8 0b 14 00 00       	call   802a49 <insert_sorted_with_merge_freeList>
  80163e:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801641:	90                   	nop
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
  801647:	83 ec 28             	sub    $0x28,%esp
  80164a:	8b 45 10             	mov    0x10(%ebp),%eax
  80164d:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801650:	e8 9f fc ff ff       	call   8012f4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801655:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801659:	75 0a                	jne    801665 <smalloc+0x21>
  80165b:	b8 00 00 00 00       	mov    $0x0,%eax
  801660:	e9 8d 00 00 00       	jmp    8016f2 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801665:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80166c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801672:	01 d0                	add    %edx,%eax
  801674:	48                   	dec    %eax
  801675:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801678:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167b:	ba 00 00 00 00       	mov    $0x0,%edx
  801680:	f7 75 f4             	divl   -0xc(%ebp)
  801683:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801686:	29 d0                	sub    %edx,%eax
  801688:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80168b:	e8 c9 06 00 00       	call   801d59 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801690:	85 c0                	test   %eax,%eax
  801692:	74 59                	je     8016ed <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801694:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  80169b:	83 ec 0c             	sub    $0xc,%esp
  80169e:	ff 75 0c             	pushl  0xc(%ebp)
  8016a1:	e8 b4 0c 00 00       	call   80235a <alloc_block_FF>
  8016a6:	83 c4 10             	add    $0x10,%esp
  8016a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  8016ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016b0:	75 07                	jne    8016b9 <smalloc+0x75>
			{
				return NULL;
  8016b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b7:	eb 39                	jmp    8016f2 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  8016b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016bc:	8b 40 08             	mov    0x8(%eax),%eax
  8016bf:	89 c2                	mov    %eax,%edx
  8016c1:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8016c5:	52                   	push   %edx
  8016c6:	50                   	push   %eax
  8016c7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ca:	ff 75 08             	pushl  0x8(%ebp)
  8016cd:	e8 0c 04 00 00       	call   801ade <sys_createSharedObject>
  8016d2:	83 c4 10             	add    $0x10,%esp
  8016d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  8016d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016dc:	78 08                	js     8016e6 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  8016de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e1:	8b 40 08             	mov    0x8(%eax),%eax
  8016e4:	eb 0c                	jmp    8016f2 <smalloc+0xae>
				}
				else
				{
					return NULL;
  8016e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016eb:	eb 05                	jmp    8016f2 <smalloc+0xae>
				}
			}

		}
		return NULL;
  8016ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f2:	c9                   	leave  
  8016f3:	c3                   	ret    

008016f4 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
  8016f7:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016fa:	e8 f5 fb ff ff       	call   8012f4 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016ff:	83 ec 08             	sub    $0x8,%esp
  801702:	ff 75 0c             	pushl  0xc(%ebp)
  801705:	ff 75 08             	pushl  0x8(%ebp)
  801708:	e8 fb 03 00 00       	call   801b08 <sys_getSizeOfSharedObject>
  80170d:	83 c4 10             	add    $0x10,%esp
  801710:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801713:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801717:	75 07                	jne    801720 <sget+0x2c>
	{
		return NULL;
  801719:	b8 00 00 00 00       	mov    $0x0,%eax
  80171e:	eb 64                	jmp    801784 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801720:	e8 34 06 00 00       	call   801d59 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801725:	85 c0                	test   %eax,%eax
  801727:	74 56                	je     80177f <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801729:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801733:	83 ec 0c             	sub    $0xc,%esp
  801736:	50                   	push   %eax
  801737:	e8 1e 0c 00 00       	call   80235a <alloc_block_FF>
  80173c:	83 c4 10             	add    $0x10,%esp
  80173f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801742:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801746:	75 07                	jne    80174f <sget+0x5b>
		{
		return NULL;
  801748:	b8 00 00 00 00       	mov    $0x0,%eax
  80174d:	eb 35                	jmp    801784 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  80174f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801752:	8b 40 08             	mov    0x8(%eax),%eax
  801755:	83 ec 04             	sub    $0x4,%esp
  801758:	50                   	push   %eax
  801759:	ff 75 0c             	pushl  0xc(%ebp)
  80175c:	ff 75 08             	pushl  0x8(%ebp)
  80175f:	e8 c1 03 00 00       	call   801b25 <sys_getSharedObject>
  801764:	83 c4 10             	add    $0x10,%esp
  801767:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  80176a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80176e:	78 08                	js     801778 <sget+0x84>
			{
				return (void*)v1->sva;
  801770:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801773:	8b 40 08             	mov    0x8(%eax),%eax
  801776:	eb 0c                	jmp    801784 <sget+0x90>
			}
			else
			{
				return NULL;
  801778:	b8 00 00 00 00       	mov    $0x0,%eax
  80177d:	eb 05                	jmp    801784 <sget+0x90>
			}
		}
	}
  return NULL;
  80177f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80178c:	e8 63 fb ff ff       	call   8012f4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801791:	83 ec 04             	sub    $0x4,%esp
  801794:	68 64 39 80 00       	push   $0x803964
  801799:	68 0e 01 00 00       	push   $0x10e
  80179e:	68 33 39 80 00       	push   $0x803933
  8017a3:	e8 0e eb ff ff       	call   8002b6 <_panic>

008017a8 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017ae:	83 ec 04             	sub    $0x4,%esp
  8017b1:	68 8c 39 80 00       	push   $0x80398c
  8017b6:	68 22 01 00 00       	push   $0x122
  8017bb:	68 33 39 80 00       	push   $0x803933
  8017c0:	e8 f1 ea ff ff       	call   8002b6 <_panic>

008017c5 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017cb:	83 ec 04             	sub    $0x4,%esp
  8017ce:	68 b0 39 80 00       	push   $0x8039b0
  8017d3:	68 2d 01 00 00       	push   $0x12d
  8017d8:	68 33 39 80 00       	push   $0x803933
  8017dd:	e8 d4 ea ff ff       	call   8002b6 <_panic>

008017e2 <shrink>:

}
void shrink(uint32 newSize)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
  8017e5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e8:	83 ec 04             	sub    $0x4,%esp
  8017eb:	68 b0 39 80 00       	push   $0x8039b0
  8017f0:	68 32 01 00 00       	push   $0x132
  8017f5:	68 33 39 80 00       	push   $0x803933
  8017fa:	e8 b7 ea ff ff       	call   8002b6 <_panic>

008017ff <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801805:	83 ec 04             	sub    $0x4,%esp
  801808:	68 b0 39 80 00       	push   $0x8039b0
  80180d:	68 37 01 00 00       	push   $0x137
  801812:	68 33 39 80 00       	push   $0x803933
  801817:	e8 9a ea ff ff       	call   8002b6 <_panic>

0080181c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	57                   	push   %edi
  801820:	56                   	push   %esi
  801821:	53                   	push   %ebx
  801822:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801825:	8b 45 08             	mov    0x8(%ebp),%eax
  801828:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80182e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801831:	8b 7d 18             	mov    0x18(%ebp),%edi
  801834:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801837:	cd 30                	int    $0x30
  801839:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80183c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80183f:	83 c4 10             	add    $0x10,%esp
  801842:	5b                   	pop    %ebx
  801843:	5e                   	pop    %esi
  801844:	5f                   	pop    %edi
  801845:	5d                   	pop    %ebp
  801846:	c3                   	ret    

00801847 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	83 ec 04             	sub    $0x4,%esp
  80184d:	8b 45 10             	mov    0x10(%ebp),%eax
  801850:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801853:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	52                   	push   %edx
  80185f:	ff 75 0c             	pushl  0xc(%ebp)
  801862:	50                   	push   %eax
  801863:	6a 00                	push   $0x0
  801865:	e8 b2 ff ff ff       	call   80181c <syscall>
  80186a:	83 c4 18             	add    $0x18,%esp
}
  80186d:	90                   	nop
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <sys_cgetc>:

int
sys_cgetc(void)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 01                	push   $0x1
  80187f:	e8 98 ff ff ff       	call   80181c <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80188c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188f:	8b 45 08             	mov    0x8(%ebp),%eax
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	52                   	push   %edx
  801899:	50                   	push   %eax
  80189a:	6a 05                	push   $0x5
  80189c:	e8 7b ff ff ff       	call   80181c <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	56                   	push   %esi
  8018aa:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018ab:	8b 75 18             	mov    0x18(%ebp),%esi
  8018ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	56                   	push   %esi
  8018bb:	53                   	push   %ebx
  8018bc:	51                   	push   %ecx
  8018bd:	52                   	push   %edx
  8018be:	50                   	push   %eax
  8018bf:	6a 06                	push   $0x6
  8018c1:	e8 56 ff ff ff       	call   80181c <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
}
  8018c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018cc:	5b                   	pop    %ebx
  8018cd:	5e                   	pop    %esi
  8018ce:	5d                   	pop    %ebp
  8018cf:	c3                   	ret    

008018d0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	52                   	push   %edx
  8018e0:	50                   	push   %eax
  8018e1:	6a 07                	push   $0x7
  8018e3:	e8 34 ff ff ff       	call   80181c <syscall>
  8018e8:	83 c4 18             	add    $0x18,%esp
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	ff 75 0c             	pushl  0xc(%ebp)
  8018f9:	ff 75 08             	pushl  0x8(%ebp)
  8018fc:	6a 08                	push   $0x8
  8018fe:	e8 19 ff ff ff       	call   80181c <syscall>
  801903:	83 c4 18             	add    $0x18,%esp
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 09                	push   $0x9
  801917:	e8 00 ff ff ff       	call   80181c <syscall>
  80191c:	83 c4 18             	add    $0x18,%esp
}
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 0a                	push   $0xa
  801930:	e8 e7 fe ff ff       	call   80181c <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 0b                	push   $0xb
  801949:	e8 ce fe ff ff       	call   80181c <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	ff 75 0c             	pushl  0xc(%ebp)
  80195f:	ff 75 08             	pushl  0x8(%ebp)
  801962:	6a 0f                	push   $0xf
  801964:	e8 b3 fe ff ff       	call   80181c <syscall>
  801969:	83 c4 18             	add    $0x18,%esp
	return;
  80196c:	90                   	nop
}
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    

0080196f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	ff 75 0c             	pushl  0xc(%ebp)
  80197b:	ff 75 08             	pushl  0x8(%ebp)
  80197e:	6a 10                	push   $0x10
  801980:	e8 97 fe ff ff       	call   80181c <syscall>
  801985:	83 c4 18             	add    $0x18,%esp
	return ;
  801988:	90                   	nop
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	ff 75 10             	pushl  0x10(%ebp)
  801995:	ff 75 0c             	pushl  0xc(%ebp)
  801998:	ff 75 08             	pushl  0x8(%ebp)
  80199b:	6a 11                	push   $0x11
  80199d:	e8 7a fe ff ff       	call   80181c <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a5:	90                   	nop
}
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 0c                	push   $0xc
  8019b7:	e8 60 fe ff ff       	call   80181c <syscall>
  8019bc:	83 c4 18             	add    $0x18,%esp
}
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	ff 75 08             	pushl  0x8(%ebp)
  8019cf:	6a 0d                	push   $0xd
  8019d1:	e8 46 fe ff ff       	call   80181c <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 0e                	push   $0xe
  8019ea:	e8 2d fe ff ff       	call   80181c <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	90                   	nop
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 13                	push   $0x13
  801a04:	e8 13 fe ff ff       	call   80181c <syscall>
  801a09:	83 c4 18             	add    $0x18,%esp
}
  801a0c:	90                   	nop
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 14                	push   $0x14
  801a1e:	e8 f9 fd ff ff       	call   80181c <syscall>
  801a23:	83 c4 18             	add    $0x18,%esp
}
  801a26:	90                   	nop
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
  801a2c:	83 ec 04             	sub    $0x4,%esp
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a35:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	50                   	push   %eax
  801a42:	6a 15                	push   $0x15
  801a44:	e8 d3 fd ff ff       	call   80181c <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
}
  801a4c:	90                   	nop
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 16                	push   $0x16
  801a5e:	e8 b9 fd ff ff       	call   80181c <syscall>
  801a63:	83 c4 18             	add    $0x18,%esp
}
  801a66:	90                   	nop
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	ff 75 0c             	pushl  0xc(%ebp)
  801a78:	50                   	push   %eax
  801a79:	6a 17                	push   $0x17
  801a7b:	e8 9c fd ff ff       	call   80181c <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	52                   	push   %edx
  801a95:	50                   	push   %eax
  801a96:	6a 1a                	push   $0x1a
  801a98:	e8 7f fd ff ff       	call   80181c <syscall>
  801a9d:	83 c4 18             	add    $0x18,%esp
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	52                   	push   %edx
  801ab2:	50                   	push   %eax
  801ab3:	6a 18                	push   $0x18
  801ab5:	e8 62 fd ff ff       	call   80181c <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
}
  801abd:	90                   	nop
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ac3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	52                   	push   %edx
  801ad0:	50                   	push   %eax
  801ad1:	6a 19                	push   $0x19
  801ad3:	e8 44 fd ff ff       	call   80181c <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
}
  801adb:	90                   	nop
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
  801ae1:	83 ec 04             	sub    $0x4,%esp
  801ae4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801aea:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aed:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	6a 00                	push   $0x0
  801af6:	51                   	push   %ecx
  801af7:	52                   	push   %edx
  801af8:	ff 75 0c             	pushl  0xc(%ebp)
  801afb:	50                   	push   %eax
  801afc:	6a 1b                	push   $0x1b
  801afe:	e8 19 fd ff ff       	call   80181c <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	52                   	push   %edx
  801b18:	50                   	push   %eax
  801b19:	6a 1c                	push   $0x1c
  801b1b:	e8 fc fc ff ff       	call   80181c <syscall>
  801b20:	83 c4 18             	add    $0x18,%esp
}
  801b23:	c9                   	leave  
  801b24:	c3                   	ret    

00801b25 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b28:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	51                   	push   %ecx
  801b36:	52                   	push   %edx
  801b37:	50                   	push   %eax
  801b38:	6a 1d                	push   $0x1d
  801b3a:	e8 dd fc ff ff       	call   80181c <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	52                   	push   %edx
  801b54:	50                   	push   %eax
  801b55:	6a 1e                	push   $0x1e
  801b57:	e8 c0 fc ff ff       	call   80181c <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 1f                	push   $0x1f
  801b70:	e8 a7 fc ff ff       	call   80181c <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b80:	6a 00                	push   $0x0
  801b82:	ff 75 14             	pushl  0x14(%ebp)
  801b85:	ff 75 10             	pushl  0x10(%ebp)
  801b88:	ff 75 0c             	pushl  0xc(%ebp)
  801b8b:	50                   	push   %eax
  801b8c:	6a 20                	push   $0x20
  801b8e:	e8 89 fc ff ff       	call   80181c <syscall>
  801b93:	83 c4 18             	add    $0x18,%esp
}
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	50                   	push   %eax
  801ba7:	6a 21                	push   $0x21
  801ba9:	e8 6e fc ff ff       	call   80181c <syscall>
  801bae:	83 c4 18             	add    $0x18,%esp
}
  801bb1:	90                   	nop
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	50                   	push   %eax
  801bc3:	6a 22                	push   $0x22
  801bc5:	e8 52 fc ff ff       	call   80181c <syscall>
  801bca:	83 c4 18             	add    $0x18,%esp
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 02                	push   $0x2
  801bde:	e8 39 fc ff ff       	call   80181c <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 03                	push   $0x3
  801bf7:	e8 20 fc ff ff       	call   80181c <syscall>
  801bfc:	83 c4 18             	add    $0x18,%esp
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 04                	push   $0x4
  801c10:	e8 07 fc ff ff       	call   80181c <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
}
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <sys_exit_env>:


void sys_exit_env(void)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 23                	push   $0x23
  801c29:	e8 ee fb ff ff       	call   80181c <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
}
  801c31:	90                   	nop
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c3a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c3d:	8d 50 04             	lea    0x4(%eax),%edx
  801c40:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	52                   	push   %edx
  801c4a:	50                   	push   %eax
  801c4b:	6a 24                	push   $0x24
  801c4d:	e8 ca fb ff ff       	call   80181c <syscall>
  801c52:	83 c4 18             	add    $0x18,%esp
	return result;
  801c55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c58:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c5b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c5e:	89 01                	mov    %eax,(%ecx)
  801c60:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c63:	8b 45 08             	mov    0x8(%ebp),%eax
  801c66:	c9                   	leave  
  801c67:	c2 04 00             	ret    $0x4

00801c6a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	ff 75 10             	pushl  0x10(%ebp)
  801c74:	ff 75 0c             	pushl  0xc(%ebp)
  801c77:	ff 75 08             	pushl  0x8(%ebp)
  801c7a:	6a 12                	push   $0x12
  801c7c:	e8 9b fb ff ff       	call   80181c <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
	return ;
  801c84:	90                   	nop
}
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 25                	push   $0x25
  801c96:	e8 81 fb ff ff       	call   80181c <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	83 ec 04             	sub    $0x4,%esp
  801ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cac:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	50                   	push   %eax
  801cb9:	6a 26                	push   $0x26
  801cbb:	e8 5c fb ff ff       	call   80181c <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc3:	90                   	nop
}
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <rsttst>:
void rsttst()
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 28                	push   $0x28
  801cd5:	e8 42 fb ff ff       	call   80181c <syscall>
  801cda:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdd:	90                   	nop
}
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
  801ce3:	83 ec 04             	sub    $0x4,%esp
  801ce6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ce9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cec:	8b 55 18             	mov    0x18(%ebp),%edx
  801cef:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cf3:	52                   	push   %edx
  801cf4:	50                   	push   %eax
  801cf5:	ff 75 10             	pushl  0x10(%ebp)
  801cf8:	ff 75 0c             	pushl  0xc(%ebp)
  801cfb:	ff 75 08             	pushl  0x8(%ebp)
  801cfe:	6a 27                	push   $0x27
  801d00:	e8 17 fb ff ff       	call   80181c <syscall>
  801d05:	83 c4 18             	add    $0x18,%esp
	return ;
  801d08:	90                   	nop
}
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <chktst>:
void chktst(uint32 n)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	ff 75 08             	pushl  0x8(%ebp)
  801d19:	6a 29                	push   $0x29
  801d1b:	e8 fc fa ff ff       	call   80181c <syscall>
  801d20:	83 c4 18             	add    $0x18,%esp
	return ;
  801d23:	90                   	nop
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <inctst>:

void inctst()
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 2a                	push   $0x2a
  801d35:	e8 e2 fa ff ff       	call   80181c <syscall>
  801d3a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3d:	90                   	nop
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <gettst>:
uint32 gettst()
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 2b                	push   $0x2b
  801d4f:	e8 c8 fa ff ff       	call   80181c <syscall>
  801d54:	83 c4 18             	add    $0x18,%esp
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
  801d5c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 2c                	push   $0x2c
  801d6b:	e8 ac fa ff ff       	call   80181c <syscall>
  801d70:	83 c4 18             	add    $0x18,%esp
  801d73:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d76:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d7a:	75 07                	jne    801d83 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d7c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d81:	eb 05                	jmp    801d88 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    

00801d8a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
  801d8d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 2c                	push   $0x2c
  801d9c:	e8 7b fa ff ff       	call   80181c <syscall>
  801da1:	83 c4 18             	add    $0x18,%esp
  801da4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801da7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dab:	75 07                	jne    801db4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dad:	b8 01 00 00 00       	mov    $0x1,%eax
  801db2:	eb 05                	jmp    801db9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801db4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
  801dbe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 2c                	push   $0x2c
  801dcd:	e8 4a fa ff ff       	call   80181c <syscall>
  801dd2:	83 c4 18             	add    $0x18,%esp
  801dd5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dd8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ddc:	75 07                	jne    801de5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dde:	b8 01 00 00 00       	mov    $0x1,%eax
  801de3:	eb 05                	jmp    801dea <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801de5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 2c                	push   $0x2c
  801dfe:	e8 19 fa ff ff       	call   80181c <syscall>
  801e03:	83 c4 18             	add    $0x18,%esp
  801e06:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e09:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e0d:	75 07                	jne    801e16 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e0f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e14:	eb 05                	jmp    801e1b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	ff 75 08             	pushl  0x8(%ebp)
  801e2b:	6a 2d                	push   $0x2d
  801e2d:	e8 ea f9 ff ff       	call   80181c <syscall>
  801e32:	83 c4 18             	add    $0x18,%esp
	return ;
  801e35:	90                   	nop
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e3c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e45:	8b 45 08             	mov    0x8(%ebp),%eax
  801e48:	6a 00                	push   $0x0
  801e4a:	53                   	push   %ebx
  801e4b:	51                   	push   %ecx
  801e4c:	52                   	push   %edx
  801e4d:	50                   	push   %eax
  801e4e:	6a 2e                	push   $0x2e
  801e50:	e8 c7 f9 ff ff       	call   80181c <syscall>
  801e55:	83 c4 18             	add    $0x18,%esp
}
  801e58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e63:	8b 45 08             	mov    0x8(%ebp),%eax
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	52                   	push   %edx
  801e6d:	50                   	push   %eax
  801e6e:	6a 2f                	push   $0x2f
  801e70:	e8 a7 f9 ff ff       	call   80181c <syscall>
  801e75:	83 c4 18             	add    $0x18,%esp
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
  801e7d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e80:	83 ec 0c             	sub    $0xc,%esp
  801e83:	68 c0 39 80 00       	push   $0x8039c0
  801e88:	e8 dd e6 ff ff       	call   80056a <cprintf>
  801e8d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e90:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e97:	83 ec 0c             	sub    $0xc,%esp
  801e9a:	68 ec 39 80 00       	push   $0x8039ec
  801e9f:	e8 c6 e6 ff ff       	call   80056a <cprintf>
  801ea4:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ea7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801eab:	a1 38 41 80 00       	mov    0x804138,%eax
  801eb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb3:	eb 56                	jmp    801f0b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801eb5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eb9:	74 1c                	je     801ed7 <print_mem_block_lists+0x5d>
  801ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebe:	8b 50 08             	mov    0x8(%eax),%edx
  801ec1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec4:	8b 48 08             	mov    0x8(%eax),%ecx
  801ec7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eca:	8b 40 0c             	mov    0xc(%eax),%eax
  801ecd:	01 c8                	add    %ecx,%eax
  801ecf:	39 c2                	cmp    %eax,%edx
  801ed1:	73 04                	jae    801ed7 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ed3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eda:	8b 50 08             	mov    0x8(%eax),%edx
  801edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee3:	01 c2                	add    %eax,%edx
  801ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee8:	8b 40 08             	mov    0x8(%eax),%eax
  801eeb:	83 ec 04             	sub    $0x4,%esp
  801eee:	52                   	push   %edx
  801eef:	50                   	push   %eax
  801ef0:	68 01 3a 80 00       	push   $0x803a01
  801ef5:	e8 70 e6 ff ff       	call   80056a <cprintf>
  801efa:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f00:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f03:	a1 40 41 80 00       	mov    0x804140,%eax
  801f08:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f0f:	74 07                	je     801f18 <print_mem_block_lists+0x9e>
  801f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f14:	8b 00                	mov    (%eax),%eax
  801f16:	eb 05                	jmp    801f1d <print_mem_block_lists+0xa3>
  801f18:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1d:	a3 40 41 80 00       	mov    %eax,0x804140
  801f22:	a1 40 41 80 00       	mov    0x804140,%eax
  801f27:	85 c0                	test   %eax,%eax
  801f29:	75 8a                	jne    801eb5 <print_mem_block_lists+0x3b>
  801f2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f2f:	75 84                	jne    801eb5 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f31:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f35:	75 10                	jne    801f47 <print_mem_block_lists+0xcd>
  801f37:	83 ec 0c             	sub    $0xc,%esp
  801f3a:	68 10 3a 80 00       	push   $0x803a10
  801f3f:	e8 26 e6 ff ff       	call   80056a <cprintf>
  801f44:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f47:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f4e:	83 ec 0c             	sub    $0xc,%esp
  801f51:	68 34 3a 80 00       	push   $0x803a34
  801f56:	e8 0f e6 ff ff       	call   80056a <cprintf>
  801f5b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f5e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f62:	a1 40 40 80 00       	mov    0x804040,%eax
  801f67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f6a:	eb 56                	jmp    801fc2 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f70:	74 1c                	je     801f8e <print_mem_block_lists+0x114>
  801f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f75:	8b 50 08             	mov    0x8(%eax),%edx
  801f78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7b:	8b 48 08             	mov    0x8(%eax),%ecx
  801f7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f81:	8b 40 0c             	mov    0xc(%eax),%eax
  801f84:	01 c8                	add    %ecx,%eax
  801f86:	39 c2                	cmp    %eax,%edx
  801f88:	73 04                	jae    801f8e <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f8a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f91:	8b 50 08             	mov    0x8(%eax),%edx
  801f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f97:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9a:	01 c2                	add    %eax,%edx
  801f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9f:	8b 40 08             	mov    0x8(%eax),%eax
  801fa2:	83 ec 04             	sub    $0x4,%esp
  801fa5:	52                   	push   %edx
  801fa6:	50                   	push   %eax
  801fa7:	68 01 3a 80 00       	push   $0x803a01
  801fac:	e8 b9 e5 ff ff       	call   80056a <cprintf>
  801fb1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fba:	a1 48 40 80 00       	mov    0x804048,%eax
  801fbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc6:	74 07                	je     801fcf <print_mem_block_lists+0x155>
  801fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcb:	8b 00                	mov    (%eax),%eax
  801fcd:	eb 05                	jmp    801fd4 <print_mem_block_lists+0x15a>
  801fcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd4:	a3 48 40 80 00       	mov    %eax,0x804048
  801fd9:	a1 48 40 80 00       	mov    0x804048,%eax
  801fde:	85 c0                	test   %eax,%eax
  801fe0:	75 8a                	jne    801f6c <print_mem_block_lists+0xf2>
  801fe2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe6:	75 84                	jne    801f6c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fe8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fec:	75 10                	jne    801ffe <print_mem_block_lists+0x184>
  801fee:	83 ec 0c             	sub    $0xc,%esp
  801ff1:	68 4c 3a 80 00       	push   $0x803a4c
  801ff6:	e8 6f e5 ff ff       	call   80056a <cprintf>
  801ffb:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ffe:	83 ec 0c             	sub    $0xc,%esp
  802001:	68 c0 39 80 00       	push   $0x8039c0
  802006:	e8 5f e5 ff ff       	call   80056a <cprintf>
  80200b:	83 c4 10             	add    $0x10,%esp

}
  80200e:	90                   	nop
  80200f:	c9                   	leave  
  802010:	c3                   	ret    

00802011 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
  802014:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  802017:	8b 45 08             	mov    0x8(%ebp),%eax
  80201a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  80201d:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802024:	00 00 00 
  802027:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80202e:	00 00 00 
  802031:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802038:	00 00 00 
	for(int i = 0; i<n;i++)
  80203b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802042:	e9 9e 00 00 00       	jmp    8020e5 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802047:	a1 50 40 80 00       	mov    0x804050,%eax
  80204c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204f:	c1 e2 04             	shl    $0x4,%edx
  802052:	01 d0                	add    %edx,%eax
  802054:	85 c0                	test   %eax,%eax
  802056:	75 14                	jne    80206c <initialize_MemBlocksList+0x5b>
  802058:	83 ec 04             	sub    $0x4,%esp
  80205b:	68 74 3a 80 00       	push   $0x803a74
  802060:	6a 47                	push   $0x47
  802062:	68 97 3a 80 00       	push   $0x803a97
  802067:	e8 4a e2 ff ff       	call   8002b6 <_panic>
  80206c:	a1 50 40 80 00       	mov    0x804050,%eax
  802071:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802074:	c1 e2 04             	shl    $0x4,%edx
  802077:	01 d0                	add    %edx,%eax
  802079:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80207f:	89 10                	mov    %edx,(%eax)
  802081:	8b 00                	mov    (%eax),%eax
  802083:	85 c0                	test   %eax,%eax
  802085:	74 18                	je     80209f <initialize_MemBlocksList+0x8e>
  802087:	a1 48 41 80 00       	mov    0x804148,%eax
  80208c:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802092:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802095:	c1 e1 04             	shl    $0x4,%ecx
  802098:	01 ca                	add    %ecx,%edx
  80209a:	89 50 04             	mov    %edx,0x4(%eax)
  80209d:	eb 12                	jmp    8020b1 <initialize_MemBlocksList+0xa0>
  80209f:	a1 50 40 80 00       	mov    0x804050,%eax
  8020a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a7:	c1 e2 04             	shl    $0x4,%edx
  8020aa:	01 d0                	add    %edx,%eax
  8020ac:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020b1:	a1 50 40 80 00       	mov    0x804050,%eax
  8020b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b9:	c1 e2 04             	shl    $0x4,%edx
  8020bc:	01 d0                	add    %edx,%eax
  8020be:	a3 48 41 80 00       	mov    %eax,0x804148
  8020c3:	a1 50 40 80 00       	mov    0x804050,%eax
  8020c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020cb:	c1 e2 04             	shl    $0x4,%edx
  8020ce:	01 d0                	add    %edx,%eax
  8020d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020d7:	a1 54 41 80 00       	mov    0x804154,%eax
  8020dc:	40                   	inc    %eax
  8020dd:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8020e2:	ff 45 f4             	incl   -0xc(%ebp)
  8020e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8020eb:	0f 82 56 ff ff ff    	jb     802047 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8020f1:	90                   	nop
  8020f2:	c9                   	leave  
  8020f3:	c3                   	ret    

008020f4 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020f4:	55                   	push   %ebp
  8020f5:	89 e5                	mov    %esp,%ebp
  8020f7:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  8020fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  802100:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802107:	a1 40 40 80 00       	mov    0x804040,%eax
  80210c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80210f:	eb 23                	jmp    802134 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802111:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802114:	8b 40 08             	mov    0x8(%eax),%eax
  802117:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80211a:	75 09                	jne    802125 <find_block+0x31>
		{
			found = 1;
  80211c:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802123:	eb 35                	jmp    80215a <find_block+0x66>
		}
		else
		{
			found = 0;
  802125:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80212c:	a1 48 40 80 00       	mov    0x804048,%eax
  802131:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802134:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802138:	74 07                	je     802141 <find_block+0x4d>
  80213a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80213d:	8b 00                	mov    (%eax),%eax
  80213f:	eb 05                	jmp    802146 <find_block+0x52>
  802141:	b8 00 00 00 00       	mov    $0x0,%eax
  802146:	a3 48 40 80 00       	mov    %eax,0x804048
  80214b:	a1 48 40 80 00       	mov    0x804048,%eax
  802150:	85 c0                	test   %eax,%eax
  802152:	75 bd                	jne    802111 <find_block+0x1d>
  802154:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802158:	75 b7                	jne    802111 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  80215a:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  80215e:	75 05                	jne    802165 <find_block+0x71>
	{
		return blk;
  802160:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802163:	eb 05                	jmp    80216a <find_block+0x76>
	}
	else
	{
		return NULL;
  802165:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
  80216f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802172:	8b 45 08             	mov    0x8(%ebp),%eax
  802175:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802178:	a1 40 40 80 00       	mov    0x804040,%eax
  80217d:	85 c0                	test   %eax,%eax
  80217f:	74 12                	je     802193 <insert_sorted_allocList+0x27>
  802181:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802184:	8b 50 08             	mov    0x8(%eax),%edx
  802187:	a1 40 40 80 00       	mov    0x804040,%eax
  80218c:	8b 40 08             	mov    0x8(%eax),%eax
  80218f:	39 c2                	cmp    %eax,%edx
  802191:	73 65                	jae    8021f8 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802193:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802197:	75 14                	jne    8021ad <insert_sorted_allocList+0x41>
  802199:	83 ec 04             	sub    $0x4,%esp
  80219c:	68 74 3a 80 00       	push   $0x803a74
  8021a1:	6a 7b                	push   $0x7b
  8021a3:	68 97 3a 80 00       	push   $0x803a97
  8021a8:	e8 09 e1 ff ff       	call   8002b6 <_panic>
  8021ad:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b6:	89 10                	mov    %edx,(%eax)
  8021b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021bb:	8b 00                	mov    (%eax),%eax
  8021bd:	85 c0                	test   %eax,%eax
  8021bf:	74 0d                	je     8021ce <insert_sorted_allocList+0x62>
  8021c1:	a1 40 40 80 00       	mov    0x804040,%eax
  8021c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021c9:	89 50 04             	mov    %edx,0x4(%eax)
  8021cc:	eb 08                	jmp    8021d6 <insert_sorted_allocList+0x6a>
  8021ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d1:	a3 44 40 80 00       	mov    %eax,0x804044
  8021d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d9:	a3 40 40 80 00       	mov    %eax,0x804040
  8021de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021e8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021ed:	40                   	inc    %eax
  8021ee:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8021f3:	e9 5f 01 00 00       	jmp    802357 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8021f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fb:	8b 50 08             	mov    0x8(%eax),%edx
  8021fe:	a1 44 40 80 00       	mov    0x804044,%eax
  802203:	8b 40 08             	mov    0x8(%eax),%eax
  802206:	39 c2                	cmp    %eax,%edx
  802208:	76 65                	jbe    80226f <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  80220a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80220e:	75 14                	jne    802224 <insert_sorted_allocList+0xb8>
  802210:	83 ec 04             	sub    $0x4,%esp
  802213:	68 b0 3a 80 00       	push   $0x803ab0
  802218:	6a 7f                	push   $0x7f
  80221a:	68 97 3a 80 00       	push   $0x803a97
  80221f:	e8 92 e0 ff ff       	call   8002b6 <_panic>
  802224:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80222a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222d:	89 50 04             	mov    %edx,0x4(%eax)
  802230:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802233:	8b 40 04             	mov    0x4(%eax),%eax
  802236:	85 c0                	test   %eax,%eax
  802238:	74 0c                	je     802246 <insert_sorted_allocList+0xda>
  80223a:	a1 44 40 80 00       	mov    0x804044,%eax
  80223f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802242:	89 10                	mov    %edx,(%eax)
  802244:	eb 08                	jmp    80224e <insert_sorted_allocList+0xe2>
  802246:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802249:	a3 40 40 80 00       	mov    %eax,0x804040
  80224e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802251:	a3 44 40 80 00       	mov    %eax,0x804044
  802256:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802259:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80225f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802264:	40                   	inc    %eax
  802265:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80226a:	e9 e8 00 00 00       	jmp    802357 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  80226f:	a1 40 40 80 00       	mov    0x804040,%eax
  802274:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802277:	e9 ab 00 00 00       	jmp    802327 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  80227c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227f:	8b 00                	mov    (%eax),%eax
  802281:	85 c0                	test   %eax,%eax
  802283:	0f 84 96 00 00 00    	je     80231f <insert_sorted_allocList+0x1b3>
  802289:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228c:	8b 50 08             	mov    0x8(%eax),%edx
  80228f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802292:	8b 40 08             	mov    0x8(%eax),%eax
  802295:	39 c2                	cmp    %eax,%edx
  802297:	0f 86 82 00 00 00    	jbe    80231f <insert_sorted_allocList+0x1b3>
  80229d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a0:	8b 50 08             	mov    0x8(%eax),%edx
  8022a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a6:	8b 00                	mov    (%eax),%eax
  8022a8:	8b 40 08             	mov    0x8(%eax),%eax
  8022ab:	39 c2                	cmp    %eax,%edx
  8022ad:	73 70                	jae    80231f <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  8022af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b3:	74 06                	je     8022bb <insert_sorted_allocList+0x14f>
  8022b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022b9:	75 17                	jne    8022d2 <insert_sorted_allocList+0x166>
  8022bb:	83 ec 04             	sub    $0x4,%esp
  8022be:	68 d4 3a 80 00       	push   $0x803ad4
  8022c3:	68 87 00 00 00       	push   $0x87
  8022c8:	68 97 3a 80 00       	push   $0x803a97
  8022cd:	e8 e4 df ff ff       	call   8002b6 <_panic>
  8022d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d5:	8b 10                	mov    (%eax),%edx
  8022d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022da:	89 10                	mov    %edx,(%eax)
  8022dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022df:	8b 00                	mov    (%eax),%eax
  8022e1:	85 c0                	test   %eax,%eax
  8022e3:	74 0b                	je     8022f0 <insert_sorted_allocList+0x184>
  8022e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e8:	8b 00                	mov    (%eax),%eax
  8022ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022ed:	89 50 04             	mov    %edx,0x4(%eax)
  8022f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022f6:	89 10                	mov    %edx,(%eax)
  8022f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022fe:	89 50 04             	mov    %edx,0x4(%eax)
  802301:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802304:	8b 00                	mov    (%eax),%eax
  802306:	85 c0                	test   %eax,%eax
  802308:	75 08                	jne    802312 <insert_sorted_allocList+0x1a6>
  80230a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80230d:	a3 44 40 80 00       	mov    %eax,0x804044
  802312:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802317:	40                   	inc    %eax
  802318:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80231d:	eb 38                	jmp    802357 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  80231f:	a1 48 40 80 00       	mov    0x804048,%eax
  802324:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802327:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80232b:	74 07                	je     802334 <insert_sorted_allocList+0x1c8>
  80232d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802330:	8b 00                	mov    (%eax),%eax
  802332:	eb 05                	jmp    802339 <insert_sorted_allocList+0x1cd>
  802334:	b8 00 00 00 00       	mov    $0x0,%eax
  802339:	a3 48 40 80 00       	mov    %eax,0x804048
  80233e:	a1 48 40 80 00       	mov    0x804048,%eax
  802343:	85 c0                	test   %eax,%eax
  802345:	0f 85 31 ff ff ff    	jne    80227c <insert_sorted_allocList+0x110>
  80234b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80234f:	0f 85 27 ff ff ff    	jne    80227c <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802355:	eb 00                	jmp    802357 <insert_sorted_allocList+0x1eb>
  802357:	90                   	nop
  802358:	c9                   	leave  
  802359:	c3                   	ret    

0080235a <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80235a:	55                   	push   %ebp
  80235b:	89 e5                	mov    %esp,%ebp
  80235d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802360:	8b 45 08             	mov    0x8(%ebp),%eax
  802363:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802366:	a1 48 41 80 00       	mov    0x804148,%eax
  80236b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80236e:	a1 38 41 80 00       	mov    0x804138,%eax
  802373:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802376:	e9 77 01 00 00       	jmp    8024f2 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  80237b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237e:	8b 40 0c             	mov    0xc(%eax),%eax
  802381:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802384:	0f 85 8a 00 00 00    	jne    802414 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80238a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238e:	75 17                	jne    8023a7 <alloc_block_FF+0x4d>
  802390:	83 ec 04             	sub    $0x4,%esp
  802393:	68 08 3b 80 00       	push   $0x803b08
  802398:	68 9e 00 00 00       	push   $0x9e
  80239d:	68 97 3a 80 00       	push   $0x803a97
  8023a2:	e8 0f df ff ff       	call   8002b6 <_panic>
  8023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023aa:	8b 00                	mov    (%eax),%eax
  8023ac:	85 c0                	test   %eax,%eax
  8023ae:	74 10                	je     8023c0 <alloc_block_FF+0x66>
  8023b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b3:	8b 00                	mov    (%eax),%eax
  8023b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b8:	8b 52 04             	mov    0x4(%edx),%edx
  8023bb:	89 50 04             	mov    %edx,0x4(%eax)
  8023be:	eb 0b                	jmp    8023cb <alloc_block_FF+0x71>
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	8b 40 04             	mov    0x4(%eax),%eax
  8023c6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ce:	8b 40 04             	mov    0x4(%eax),%eax
  8023d1:	85 c0                	test   %eax,%eax
  8023d3:	74 0f                	je     8023e4 <alloc_block_FF+0x8a>
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	8b 40 04             	mov    0x4(%eax),%eax
  8023db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023de:	8b 12                	mov    (%edx),%edx
  8023e0:	89 10                	mov    %edx,(%eax)
  8023e2:	eb 0a                	jmp    8023ee <alloc_block_FF+0x94>
  8023e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e7:	8b 00                	mov    (%eax),%eax
  8023e9:	a3 38 41 80 00       	mov    %eax,0x804138
  8023ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802401:	a1 44 41 80 00       	mov    0x804144,%eax
  802406:	48                   	dec    %eax
  802407:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  80240c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240f:	e9 11 01 00 00       	jmp    802525 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802417:	8b 40 0c             	mov    0xc(%eax),%eax
  80241a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80241d:	0f 86 c7 00 00 00    	jbe    8024ea <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802423:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802427:	75 17                	jne    802440 <alloc_block_FF+0xe6>
  802429:	83 ec 04             	sub    $0x4,%esp
  80242c:	68 08 3b 80 00       	push   $0x803b08
  802431:	68 a3 00 00 00       	push   $0xa3
  802436:	68 97 3a 80 00       	push   $0x803a97
  80243b:	e8 76 de ff ff       	call   8002b6 <_panic>
  802440:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802443:	8b 00                	mov    (%eax),%eax
  802445:	85 c0                	test   %eax,%eax
  802447:	74 10                	je     802459 <alloc_block_FF+0xff>
  802449:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80244c:	8b 00                	mov    (%eax),%eax
  80244e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802451:	8b 52 04             	mov    0x4(%edx),%edx
  802454:	89 50 04             	mov    %edx,0x4(%eax)
  802457:	eb 0b                	jmp    802464 <alloc_block_FF+0x10a>
  802459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80245c:	8b 40 04             	mov    0x4(%eax),%eax
  80245f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802464:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802467:	8b 40 04             	mov    0x4(%eax),%eax
  80246a:	85 c0                	test   %eax,%eax
  80246c:	74 0f                	je     80247d <alloc_block_FF+0x123>
  80246e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802471:	8b 40 04             	mov    0x4(%eax),%eax
  802474:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802477:	8b 12                	mov    (%edx),%edx
  802479:	89 10                	mov    %edx,(%eax)
  80247b:	eb 0a                	jmp    802487 <alloc_block_FF+0x12d>
  80247d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802480:	8b 00                	mov    (%eax),%eax
  802482:	a3 48 41 80 00       	mov    %eax,0x804148
  802487:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80248a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802490:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802493:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80249a:	a1 54 41 80 00       	mov    0x804154,%eax
  80249f:	48                   	dec    %eax
  8024a0:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8024a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024ab:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8024ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b4:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8024b7:	89 c2                	mov    %eax,%edx
  8024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bc:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8024bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c2:	8b 40 08             	mov    0x8(%eax),%eax
  8024c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8024c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cb:	8b 50 08             	mov    0x8(%eax),%edx
  8024ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d4:	01 c2                	add    %eax,%edx
  8024d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d9:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8024dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024df:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024e2:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8024e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e8:	eb 3b                	jmp    802525 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8024ea:	a1 40 41 80 00       	mov    0x804140,%eax
  8024ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f6:	74 07                	je     8024ff <alloc_block_FF+0x1a5>
  8024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fb:	8b 00                	mov    (%eax),%eax
  8024fd:	eb 05                	jmp    802504 <alloc_block_FF+0x1aa>
  8024ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802504:	a3 40 41 80 00       	mov    %eax,0x804140
  802509:	a1 40 41 80 00       	mov    0x804140,%eax
  80250e:	85 c0                	test   %eax,%eax
  802510:	0f 85 65 fe ff ff    	jne    80237b <alloc_block_FF+0x21>
  802516:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251a:	0f 85 5b fe ff ff    	jne    80237b <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802520:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802525:	c9                   	leave  
  802526:	c3                   	ret    

00802527 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802527:	55                   	push   %ebp
  802528:	89 e5                	mov    %esp,%ebp
  80252a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  80252d:	8b 45 08             	mov    0x8(%ebp),%eax
  802530:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802533:	a1 48 41 80 00       	mov    0x804148,%eax
  802538:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  80253b:	a1 44 41 80 00       	mov    0x804144,%eax
  802540:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802543:	a1 38 41 80 00       	mov    0x804138,%eax
  802548:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80254b:	e9 a1 00 00 00       	jmp    8025f1 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	8b 40 0c             	mov    0xc(%eax),%eax
  802556:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802559:	0f 85 8a 00 00 00    	jne    8025e9 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  80255f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802563:	75 17                	jne    80257c <alloc_block_BF+0x55>
  802565:	83 ec 04             	sub    $0x4,%esp
  802568:	68 08 3b 80 00       	push   $0x803b08
  80256d:	68 c2 00 00 00       	push   $0xc2
  802572:	68 97 3a 80 00       	push   $0x803a97
  802577:	e8 3a dd ff ff       	call   8002b6 <_panic>
  80257c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257f:	8b 00                	mov    (%eax),%eax
  802581:	85 c0                	test   %eax,%eax
  802583:	74 10                	je     802595 <alloc_block_BF+0x6e>
  802585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802588:	8b 00                	mov    (%eax),%eax
  80258a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258d:	8b 52 04             	mov    0x4(%edx),%edx
  802590:	89 50 04             	mov    %edx,0x4(%eax)
  802593:	eb 0b                	jmp    8025a0 <alloc_block_BF+0x79>
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	8b 40 04             	mov    0x4(%eax),%eax
  80259b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	8b 40 04             	mov    0x4(%eax),%eax
  8025a6:	85 c0                	test   %eax,%eax
  8025a8:	74 0f                	je     8025b9 <alloc_block_BF+0x92>
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	8b 40 04             	mov    0x4(%eax),%eax
  8025b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b3:	8b 12                	mov    (%edx),%edx
  8025b5:	89 10                	mov    %edx,(%eax)
  8025b7:	eb 0a                	jmp    8025c3 <alloc_block_BF+0x9c>
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	8b 00                	mov    (%eax),%eax
  8025be:	a3 38 41 80 00       	mov    %eax,0x804138
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d6:	a1 44 41 80 00       	mov    0x804144,%eax
  8025db:	48                   	dec    %eax
  8025dc:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	e9 11 02 00 00       	jmp    8027fa <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025e9:	a1 40 41 80 00       	mov    0x804140,%eax
  8025ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f5:	74 07                	je     8025fe <alloc_block_BF+0xd7>
  8025f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fa:	8b 00                	mov    (%eax),%eax
  8025fc:	eb 05                	jmp    802603 <alloc_block_BF+0xdc>
  8025fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802603:	a3 40 41 80 00       	mov    %eax,0x804140
  802608:	a1 40 41 80 00       	mov    0x804140,%eax
  80260d:	85 c0                	test   %eax,%eax
  80260f:	0f 85 3b ff ff ff    	jne    802550 <alloc_block_BF+0x29>
  802615:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802619:	0f 85 31 ff ff ff    	jne    802550 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80261f:	a1 38 41 80 00       	mov    0x804138,%eax
  802624:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802627:	eb 27                	jmp    802650 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	8b 40 0c             	mov    0xc(%eax),%eax
  80262f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802632:	76 14                	jbe    802648 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802637:	8b 40 0c             	mov    0xc(%eax),%eax
  80263a:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  80263d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802640:	8b 40 08             	mov    0x8(%eax),%eax
  802643:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802646:	eb 2e                	jmp    802676 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802648:	a1 40 41 80 00       	mov    0x804140,%eax
  80264d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802650:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802654:	74 07                	je     80265d <alloc_block_BF+0x136>
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802659:	8b 00                	mov    (%eax),%eax
  80265b:	eb 05                	jmp    802662 <alloc_block_BF+0x13b>
  80265d:	b8 00 00 00 00       	mov    $0x0,%eax
  802662:	a3 40 41 80 00       	mov    %eax,0x804140
  802667:	a1 40 41 80 00       	mov    0x804140,%eax
  80266c:	85 c0                	test   %eax,%eax
  80266e:	75 b9                	jne    802629 <alloc_block_BF+0x102>
  802670:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802674:	75 b3                	jne    802629 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802676:	a1 38 41 80 00       	mov    0x804138,%eax
  80267b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80267e:	eb 30                	jmp    8026b0 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802683:	8b 40 0c             	mov    0xc(%eax),%eax
  802686:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802689:	73 1d                	jae    8026a8 <alloc_block_BF+0x181>
  80268b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268e:	8b 40 0c             	mov    0xc(%eax),%eax
  802691:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802694:	76 12                	jbe    8026a8 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	8b 40 0c             	mov    0xc(%eax),%eax
  80269c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	8b 40 08             	mov    0x8(%eax),%eax
  8026a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026a8:	a1 40 41 80 00       	mov    0x804140,%eax
  8026ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b4:	74 07                	je     8026bd <alloc_block_BF+0x196>
  8026b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b9:	8b 00                	mov    (%eax),%eax
  8026bb:	eb 05                	jmp    8026c2 <alloc_block_BF+0x19b>
  8026bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c2:	a3 40 41 80 00       	mov    %eax,0x804140
  8026c7:	a1 40 41 80 00       	mov    0x804140,%eax
  8026cc:	85 c0                	test   %eax,%eax
  8026ce:	75 b0                	jne    802680 <alloc_block_BF+0x159>
  8026d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d4:	75 aa                	jne    802680 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026d6:	a1 38 41 80 00       	mov    0x804138,%eax
  8026db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026de:	e9 e4 00 00 00       	jmp    8027c7 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  8026e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8026ec:	0f 85 cd 00 00 00    	jne    8027bf <alloc_block_BF+0x298>
  8026f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f5:	8b 40 08             	mov    0x8(%eax),%eax
  8026f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026fb:	0f 85 be 00 00 00    	jne    8027bf <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802701:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802705:	75 17                	jne    80271e <alloc_block_BF+0x1f7>
  802707:	83 ec 04             	sub    $0x4,%esp
  80270a:	68 08 3b 80 00       	push   $0x803b08
  80270f:	68 db 00 00 00       	push   $0xdb
  802714:	68 97 3a 80 00       	push   $0x803a97
  802719:	e8 98 db ff ff       	call   8002b6 <_panic>
  80271e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802721:	8b 00                	mov    (%eax),%eax
  802723:	85 c0                	test   %eax,%eax
  802725:	74 10                	je     802737 <alloc_block_BF+0x210>
  802727:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80272a:	8b 00                	mov    (%eax),%eax
  80272c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80272f:	8b 52 04             	mov    0x4(%edx),%edx
  802732:	89 50 04             	mov    %edx,0x4(%eax)
  802735:	eb 0b                	jmp    802742 <alloc_block_BF+0x21b>
  802737:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80273a:	8b 40 04             	mov    0x4(%eax),%eax
  80273d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802745:	8b 40 04             	mov    0x4(%eax),%eax
  802748:	85 c0                	test   %eax,%eax
  80274a:	74 0f                	je     80275b <alloc_block_BF+0x234>
  80274c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80274f:	8b 40 04             	mov    0x4(%eax),%eax
  802752:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802755:	8b 12                	mov    (%edx),%edx
  802757:	89 10                	mov    %edx,(%eax)
  802759:	eb 0a                	jmp    802765 <alloc_block_BF+0x23e>
  80275b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80275e:	8b 00                	mov    (%eax),%eax
  802760:	a3 48 41 80 00       	mov    %eax,0x804148
  802765:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802768:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80276e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802771:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802778:	a1 54 41 80 00       	mov    0x804154,%eax
  80277d:	48                   	dec    %eax
  80277e:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802783:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802786:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802789:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  80278c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80278f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802792:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802798:	8b 40 0c             	mov    0xc(%eax),%eax
  80279b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80279e:	89 c2                	mov    %eax,%edx
  8027a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a3:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	8b 50 08             	mov    0x8(%eax),%edx
  8027ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027af:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b2:	01 c2                	add    %eax,%edx
  8027b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b7:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8027ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027bd:	eb 3b                	jmp    8027fa <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027bf:	a1 40 41 80 00       	mov    0x804140,%eax
  8027c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027cb:	74 07                	je     8027d4 <alloc_block_BF+0x2ad>
  8027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d0:	8b 00                	mov    (%eax),%eax
  8027d2:	eb 05                	jmp    8027d9 <alloc_block_BF+0x2b2>
  8027d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d9:	a3 40 41 80 00       	mov    %eax,0x804140
  8027de:	a1 40 41 80 00       	mov    0x804140,%eax
  8027e3:	85 c0                	test   %eax,%eax
  8027e5:	0f 85 f8 fe ff ff    	jne    8026e3 <alloc_block_BF+0x1bc>
  8027eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ef:	0f 85 ee fe ff ff    	jne    8026e3 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  8027f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027fa:	c9                   	leave  
  8027fb:	c3                   	ret    

008027fc <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027fc:	55                   	push   %ebp
  8027fd:	89 e5                	mov    %esp,%ebp
  8027ff:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802802:	8b 45 08             	mov    0x8(%ebp),%eax
  802805:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802808:	a1 48 41 80 00       	mov    0x804148,%eax
  80280d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802810:	a1 38 41 80 00       	mov    0x804138,%eax
  802815:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802818:	e9 77 01 00 00       	jmp    802994 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  80281d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802820:	8b 40 0c             	mov    0xc(%eax),%eax
  802823:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802826:	0f 85 8a 00 00 00    	jne    8028b6 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80282c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802830:	75 17                	jne    802849 <alloc_block_NF+0x4d>
  802832:	83 ec 04             	sub    $0x4,%esp
  802835:	68 08 3b 80 00       	push   $0x803b08
  80283a:	68 f7 00 00 00       	push   $0xf7
  80283f:	68 97 3a 80 00       	push   $0x803a97
  802844:	e8 6d da ff ff       	call   8002b6 <_panic>
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	8b 00                	mov    (%eax),%eax
  80284e:	85 c0                	test   %eax,%eax
  802850:	74 10                	je     802862 <alloc_block_NF+0x66>
  802852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802855:	8b 00                	mov    (%eax),%eax
  802857:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80285a:	8b 52 04             	mov    0x4(%edx),%edx
  80285d:	89 50 04             	mov    %edx,0x4(%eax)
  802860:	eb 0b                	jmp    80286d <alloc_block_NF+0x71>
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	8b 40 04             	mov    0x4(%eax),%eax
  802868:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80286d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802870:	8b 40 04             	mov    0x4(%eax),%eax
  802873:	85 c0                	test   %eax,%eax
  802875:	74 0f                	je     802886 <alloc_block_NF+0x8a>
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	8b 40 04             	mov    0x4(%eax),%eax
  80287d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802880:	8b 12                	mov    (%edx),%edx
  802882:	89 10                	mov    %edx,(%eax)
  802884:	eb 0a                	jmp    802890 <alloc_block_NF+0x94>
  802886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802889:	8b 00                	mov    (%eax),%eax
  80288b:	a3 38 41 80 00       	mov    %eax,0x804138
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a3:	a1 44 41 80 00       	mov    0x804144,%eax
  8028a8:	48                   	dec    %eax
  8028a9:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b1:	e9 11 01 00 00       	jmp    8029c7 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8028bc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028bf:	0f 86 c7 00 00 00    	jbe    80298c <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8028c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028c9:	75 17                	jne    8028e2 <alloc_block_NF+0xe6>
  8028cb:	83 ec 04             	sub    $0x4,%esp
  8028ce:	68 08 3b 80 00       	push   $0x803b08
  8028d3:	68 fc 00 00 00       	push   $0xfc
  8028d8:	68 97 3a 80 00       	push   $0x803a97
  8028dd:	e8 d4 d9 ff ff       	call   8002b6 <_panic>
  8028e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e5:	8b 00                	mov    (%eax),%eax
  8028e7:	85 c0                	test   %eax,%eax
  8028e9:	74 10                	je     8028fb <alloc_block_NF+0xff>
  8028eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ee:	8b 00                	mov    (%eax),%eax
  8028f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028f3:	8b 52 04             	mov    0x4(%edx),%edx
  8028f6:	89 50 04             	mov    %edx,0x4(%eax)
  8028f9:	eb 0b                	jmp    802906 <alloc_block_NF+0x10a>
  8028fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fe:	8b 40 04             	mov    0x4(%eax),%eax
  802901:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802906:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802909:	8b 40 04             	mov    0x4(%eax),%eax
  80290c:	85 c0                	test   %eax,%eax
  80290e:	74 0f                	je     80291f <alloc_block_NF+0x123>
  802910:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802913:	8b 40 04             	mov    0x4(%eax),%eax
  802916:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802919:	8b 12                	mov    (%edx),%edx
  80291b:	89 10                	mov    %edx,(%eax)
  80291d:	eb 0a                	jmp    802929 <alloc_block_NF+0x12d>
  80291f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802922:	8b 00                	mov    (%eax),%eax
  802924:	a3 48 41 80 00       	mov    %eax,0x804148
  802929:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802932:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802935:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80293c:	a1 54 41 80 00       	mov    0x804154,%eax
  802941:	48                   	dec    %eax
  802942:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802947:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80294d:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802953:	8b 40 0c             	mov    0xc(%eax),%eax
  802956:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802959:	89 c2                	mov    %eax,%edx
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802964:	8b 40 08             	mov    0x8(%eax),%eax
  802967:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  80296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296d:	8b 50 08             	mov    0x8(%eax),%edx
  802970:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802973:	8b 40 0c             	mov    0xc(%eax),%eax
  802976:	01 c2                	add    %eax,%edx
  802978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297b:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  80297e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802981:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802984:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802987:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298a:	eb 3b                	jmp    8029c7 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80298c:	a1 40 41 80 00       	mov    0x804140,%eax
  802991:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802994:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802998:	74 07                	je     8029a1 <alloc_block_NF+0x1a5>
  80299a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299d:	8b 00                	mov    (%eax),%eax
  80299f:	eb 05                	jmp    8029a6 <alloc_block_NF+0x1aa>
  8029a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a6:	a3 40 41 80 00       	mov    %eax,0x804140
  8029ab:	a1 40 41 80 00       	mov    0x804140,%eax
  8029b0:	85 c0                	test   %eax,%eax
  8029b2:	0f 85 65 fe ff ff    	jne    80281d <alloc_block_NF+0x21>
  8029b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029bc:	0f 85 5b fe ff ff    	jne    80281d <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8029c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029c7:	c9                   	leave  
  8029c8:	c3                   	ret    

008029c9 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  8029c9:	55                   	push   %ebp
  8029ca:	89 e5                	mov    %esp,%ebp
  8029cc:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  8029cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  8029d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  8029e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029e7:	75 17                	jne    802a00 <addToAvailMemBlocksList+0x37>
  8029e9:	83 ec 04             	sub    $0x4,%esp
  8029ec:	68 b0 3a 80 00       	push   $0x803ab0
  8029f1:	68 10 01 00 00       	push   $0x110
  8029f6:	68 97 3a 80 00       	push   $0x803a97
  8029fb:	e8 b6 d8 ff ff       	call   8002b6 <_panic>
  802a00:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802a06:	8b 45 08             	mov    0x8(%ebp),%eax
  802a09:	89 50 04             	mov    %edx,0x4(%eax)
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	8b 40 04             	mov    0x4(%eax),%eax
  802a12:	85 c0                	test   %eax,%eax
  802a14:	74 0c                	je     802a22 <addToAvailMemBlocksList+0x59>
  802a16:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802a1b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a1e:	89 10                	mov    %edx,(%eax)
  802a20:	eb 08                	jmp    802a2a <addToAvailMemBlocksList+0x61>
  802a22:	8b 45 08             	mov    0x8(%ebp),%eax
  802a25:	a3 48 41 80 00       	mov    %eax,0x804148
  802a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a32:	8b 45 08             	mov    0x8(%ebp),%eax
  802a35:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a3b:	a1 54 41 80 00       	mov    0x804154,%eax
  802a40:	40                   	inc    %eax
  802a41:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802a46:	90                   	nop
  802a47:	c9                   	leave  
  802a48:	c3                   	ret    

00802a49 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a49:	55                   	push   %ebp
  802a4a:	89 e5                	mov    %esp,%ebp
  802a4c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802a4f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a54:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802a57:	a1 44 41 80 00       	mov    0x804144,%eax
  802a5c:	85 c0                	test   %eax,%eax
  802a5e:	75 68                	jne    802ac8 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802a60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a64:	75 17                	jne    802a7d <insert_sorted_with_merge_freeList+0x34>
  802a66:	83 ec 04             	sub    $0x4,%esp
  802a69:	68 74 3a 80 00       	push   $0x803a74
  802a6e:	68 1a 01 00 00       	push   $0x11a
  802a73:	68 97 3a 80 00       	push   $0x803a97
  802a78:	e8 39 d8 ff ff       	call   8002b6 <_panic>
  802a7d:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a83:	8b 45 08             	mov    0x8(%ebp),%eax
  802a86:	89 10                	mov    %edx,(%eax)
  802a88:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8b:	8b 00                	mov    (%eax),%eax
  802a8d:	85 c0                	test   %eax,%eax
  802a8f:	74 0d                	je     802a9e <insert_sorted_with_merge_freeList+0x55>
  802a91:	a1 38 41 80 00       	mov    0x804138,%eax
  802a96:	8b 55 08             	mov    0x8(%ebp),%edx
  802a99:	89 50 04             	mov    %edx,0x4(%eax)
  802a9c:	eb 08                	jmp    802aa6 <insert_sorted_with_merge_freeList+0x5d>
  802a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa9:	a3 38 41 80 00       	mov    %eax,0x804138
  802aae:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab8:	a1 44 41 80 00       	mov    0x804144,%eax
  802abd:	40                   	inc    %eax
  802abe:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ac3:	e9 c5 03 00 00       	jmp    802e8d <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acb:	8b 50 08             	mov    0x8(%eax),%edx
  802ace:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad1:	8b 40 08             	mov    0x8(%eax),%eax
  802ad4:	39 c2                	cmp    %eax,%edx
  802ad6:	0f 83 b2 00 00 00    	jae    802b8e <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802adc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802adf:	8b 50 08             	mov    0x8(%eax),%edx
  802ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae8:	01 c2                	add    %eax,%edx
  802aea:	8b 45 08             	mov    0x8(%ebp),%eax
  802aed:	8b 40 08             	mov    0x8(%eax),%eax
  802af0:	39 c2                	cmp    %eax,%edx
  802af2:	75 27                	jne    802b1b <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af7:	8b 50 0c             	mov    0xc(%eax),%edx
  802afa:	8b 45 08             	mov    0x8(%ebp),%eax
  802afd:	8b 40 0c             	mov    0xc(%eax),%eax
  802b00:	01 c2                	add    %eax,%edx
  802b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b05:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802b08:	83 ec 0c             	sub    $0xc,%esp
  802b0b:	ff 75 08             	pushl  0x8(%ebp)
  802b0e:	e8 b6 fe ff ff       	call   8029c9 <addToAvailMemBlocksList>
  802b13:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802b16:	e9 72 03 00 00       	jmp    802e8d <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802b1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b1f:	74 06                	je     802b27 <insert_sorted_with_merge_freeList+0xde>
  802b21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b25:	75 17                	jne    802b3e <insert_sorted_with_merge_freeList+0xf5>
  802b27:	83 ec 04             	sub    $0x4,%esp
  802b2a:	68 d4 3a 80 00       	push   $0x803ad4
  802b2f:	68 24 01 00 00       	push   $0x124
  802b34:	68 97 3a 80 00       	push   $0x803a97
  802b39:	e8 78 d7 ff ff       	call   8002b6 <_panic>
  802b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b41:	8b 10                	mov    (%eax),%edx
  802b43:	8b 45 08             	mov    0x8(%ebp),%eax
  802b46:	89 10                	mov    %edx,(%eax)
  802b48:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4b:	8b 00                	mov    (%eax),%eax
  802b4d:	85 c0                	test   %eax,%eax
  802b4f:	74 0b                	je     802b5c <insert_sorted_with_merge_freeList+0x113>
  802b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b54:	8b 00                	mov    (%eax),%eax
  802b56:	8b 55 08             	mov    0x8(%ebp),%edx
  802b59:	89 50 04             	mov    %edx,0x4(%eax)
  802b5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b62:	89 10                	mov    %edx,(%eax)
  802b64:	8b 45 08             	mov    0x8(%ebp),%eax
  802b67:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b6a:	89 50 04             	mov    %edx,0x4(%eax)
  802b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b70:	8b 00                	mov    (%eax),%eax
  802b72:	85 c0                	test   %eax,%eax
  802b74:	75 08                	jne    802b7e <insert_sorted_with_merge_freeList+0x135>
  802b76:	8b 45 08             	mov    0x8(%ebp),%eax
  802b79:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b7e:	a1 44 41 80 00       	mov    0x804144,%eax
  802b83:	40                   	inc    %eax
  802b84:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802b89:	e9 ff 02 00 00       	jmp    802e8d <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802b8e:	a1 38 41 80 00       	mov    0x804138,%eax
  802b93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b96:	e9 c2 02 00 00       	jmp    802e5d <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9e:	8b 50 08             	mov    0x8(%eax),%edx
  802ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba4:	8b 40 08             	mov    0x8(%eax),%eax
  802ba7:	39 c2                	cmp    %eax,%edx
  802ba9:	0f 86 a6 02 00 00    	jbe    802e55 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	8b 40 04             	mov    0x4(%eax),%eax
  802bb5:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802bb8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bbc:	0f 85 ba 00 00 00    	jne    802c7c <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc5:	8b 50 0c             	mov    0xc(%eax),%edx
  802bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcb:	8b 40 08             	mov    0x8(%eax),%eax
  802bce:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd3:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802bd6:	39 c2                	cmp    %eax,%edx
  802bd8:	75 33                	jne    802c0d <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802bda:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdd:	8b 50 08             	mov    0x8(%eax),%edx
  802be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be3:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be9:	8b 50 0c             	mov    0xc(%eax),%edx
  802bec:	8b 45 08             	mov    0x8(%ebp),%eax
  802bef:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf2:	01 c2                	add    %eax,%edx
  802bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf7:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802bfa:	83 ec 0c             	sub    $0xc,%esp
  802bfd:	ff 75 08             	pushl  0x8(%ebp)
  802c00:	e8 c4 fd ff ff       	call   8029c9 <addToAvailMemBlocksList>
  802c05:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802c08:	e9 80 02 00 00       	jmp    802e8d <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802c0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c11:	74 06                	je     802c19 <insert_sorted_with_merge_freeList+0x1d0>
  802c13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c17:	75 17                	jne    802c30 <insert_sorted_with_merge_freeList+0x1e7>
  802c19:	83 ec 04             	sub    $0x4,%esp
  802c1c:	68 28 3b 80 00       	push   $0x803b28
  802c21:	68 3a 01 00 00       	push   $0x13a
  802c26:	68 97 3a 80 00       	push   $0x803a97
  802c2b:	e8 86 d6 ff ff       	call   8002b6 <_panic>
  802c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c33:	8b 50 04             	mov    0x4(%eax),%edx
  802c36:	8b 45 08             	mov    0x8(%ebp),%eax
  802c39:	89 50 04             	mov    %edx,0x4(%eax)
  802c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c42:	89 10                	mov    %edx,(%eax)
  802c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c47:	8b 40 04             	mov    0x4(%eax),%eax
  802c4a:	85 c0                	test   %eax,%eax
  802c4c:	74 0d                	je     802c5b <insert_sorted_with_merge_freeList+0x212>
  802c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c51:	8b 40 04             	mov    0x4(%eax),%eax
  802c54:	8b 55 08             	mov    0x8(%ebp),%edx
  802c57:	89 10                	mov    %edx,(%eax)
  802c59:	eb 08                	jmp    802c63 <insert_sorted_with_merge_freeList+0x21a>
  802c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5e:	a3 38 41 80 00       	mov    %eax,0x804138
  802c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c66:	8b 55 08             	mov    0x8(%ebp),%edx
  802c69:	89 50 04             	mov    %edx,0x4(%eax)
  802c6c:	a1 44 41 80 00       	mov    0x804144,%eax
  802c71:	40                   	inc    %eax
  802c72:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802c77:	e9 11 02 00 00       	jmp    802e8d <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802c7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7f:	8b 50 08             	mov    0x8(%eax),%edx
  802c82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c85:	8b 40 0c             	mov    0xc(%eax),%eax
  802c88:	01 c2                	add    %eax,%edx
  802c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c90:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c95:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802c98:	39 c2                	cmp    %eax,%edx
  802c9a:	0f 85 bf 00 00 00    	jne    802d5f <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802ca0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca3:	8b 50 0c             	mov    0xc(%eax),%edx
  802ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca9:	8b 40 0c             	mov    0xc(%eax),%eax
  802cac:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb1:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb4:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802cb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb9:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802cbc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc0:	75 17                	jne    802cd9 <insert_sorted_with_merge_freeList+0x290>
  802cc2:	83 ec 04             	sub    $0x4,%esp
  802cc5:	68 08 3b 80 00       	push   $0x803b08
  802cca:	68 43 01 00 00       	push   $0x143
  802ccf:	68 97 3a 80 00       	push   $0x803a97
  802cd4:	e8 dd d5 ff ff       	call   8002b6 <_panic>
  802cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdc:	8b 00                	mov    (%eax),%eax
  802cde:	85 c0                	test   %eax,%eax
  802ce0:	74 10                	je     802cf2 <insert_sorted_with_merge_freeList+0x2a9>
  802ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce5:	8b 00                	mov    (%eax),%eax
  802ce7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cea:	8b 52 04             	mov    0x4(%edx),%edx
  802ced:	89 50 04             	mov    %edx,0x4(%eax)
  802cf0:	eb 0b                	jmp    802cfd <insert_sorted_with_merge_freeList+0x2b4>
  802cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf5:	8b 40 04             	mov    0x4(%eax),%eax
  802cf8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d00:	8b 40 04             	mov    0x4(%eax),%eax
  802d03:	85 c0                	test   %eax,%eax
  802d05:	74 0f                	je     802d16 <insert_sorted_with_merge_freeList+0x2cd>
  802d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0a:	8b 40 04             	mov    0x4(%eax),%eax
  802d0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d10:	8b 12                	mov    (%edx),%edx
  802d12:	89 10                	mov    %edx,(%eax)
  802d14:	eb 0a                	jmp    802d20 <insert_sorted_with_merge_freeList+0x2d7>
  802d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d19:	8b 00                	mov    (%eax),%eax
  802d1b:	a3 38 41 80 00       	mov    %eax,0x804138
  802d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d33:	a1 44 41 80 00       	mov    0x804144,%eax
  802d38:	48                   	dec    %eax
  802d39:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802d3e:	83 ec 0c             	sub    $0xc,%esp
  802d41:	ff 75 08             	pushl  0x8(%ebp)
  802d44:	e8 80 fc ff ff       	call   8029c9 <addToAvailMemBlocksList>
  802d49:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802d4c:	83 ec 0c             	sub    $0xc,%esp
  802d4f:	ff 75 f4             	pushl  -0xc(%ebp)
  802d52:	e8 72 fc ff ff       	call   8029c9 <addToAvailMemBlocksList>
  802d57:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802d5a:	e9 2e 01 00 00       	jmp    802e8d <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802d5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d62:	8b 50 08             	mov    0x8(%eax),%edx
  802d65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d68:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6b:	01 c2                	add    %eax,%edx
  802d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d70:	8b 40 08             	mov    0x8(%eax),%eax
  802d73:	39 c2                	cmp    %eax,%edx
  802d75:	75 27                	jne    802d9e <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802d77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7a:	8b 50 0c             	mov    0xc(%eax),%edx
  802d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d80:	8b 40 0c             	mov    0xc(%eax),%eax
  802d83:	01 c2                	add    %eax,%edx
  802d85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d88:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802d8b:	83 ec 0c             	sub    $0xc,%esp
  802d8e:	ff 75 08             	pushl  0x8(%ebp)
  802d91:	e8 33 fc ff ff       	call   8029c9 <addToAvailMemBlocksList>
  802d96:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802d99:	e9 ef 00 00 00       	jmp    802e8d <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802da1:	8b 50 0c             	mov    0xc(%eax),%edx
  802da4:	8b 45 08             	mov    0x8(%ebp),%eax
  802da7:	8b 40 08             	mov    0x8(%eax),%eax
  802daa:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daf:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802db2:	39 c2                	cmp    %eax,%edx
  802db4:	75 33                	jne    802de9 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802db6:	8b 45 08             	mov    0x8(%ebp),%eax
  802db9:	8b 50 08             	mov    0x8(%eax),%edx
  802dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbf:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc5:	8b 50 0c             	mov    0xc(%eax),%edx
  802dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dce:	01 c2                	add    %eax,%edx
  802dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd3:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802dd6:	83 ec 0c             	sub    $0xc,%esp
  802dd9:	ff 75 08             	pushl  0x8(%ebp)
  802ddc:	e8 e8 fb ff ff       	call   8029c9 <addToAvailMemBlocksList>
  802de1:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802de4:	e9 a4 00 00 00       	jmp    802e8d <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802de9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ded:	74 06                	je     802df5 <insert_sorted_with_merge_freeList+0x3ac>
  802def:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802df3:	75 17                	jne    802e0c <insert_sorted_with_merge_freeList+0x3c3>
  802df5:	83 ec 04             	sub    $0x4,%esp
  802df8:	68 28 3b 80 00       	push   $0x803b28
  802dfd:	68 56 01 00 00       	push   $0x156
  802e02:	68 97 3a 80 00       	push   $0x803a97
  802e07:	e8 aa d4 ff ff       	call   8002b6 <_panic>
  802e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0f:	8b 50 04             	mov    0x4(%eax),%edx
  802e12:	8b 45 08             	mov    0x8(%ebp),%eax
  802e15:	89 50 04             	mov    %edx,0x4(%eax)
  802e18:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e1e:	89 10                	mov    %edx,(%eax)
  802e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e23:	8b 40 04             	mov    0x4(%eax),%eax
  802e26:	85 c0                	test   %eax,%eax
  802e28:	74 0d                	je     802e37 <insert_sorted_with_merge_freeList+0x3ee>
  802e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2d:	8b 40 04             	mov    0x4(%eax),%eax
  802e30:	8b 55 08             	mov    0x8(%ebp),%edx
  802e33:	89 10                	mov    %edx,(%eax)
  802e35:	eb 08                	jmp    802e3f <insert_sorted_with_merge_freeList+0x3f6>
  802e37:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3a:	a3 38 41 80 00       	mov    %eax,0x804138
  802e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e42:	8b 55 08             	mov    0x8(%ebp),%edx
  802e45:	89 50 04             	mov    %edx,0x4(%eax)
  802e48:	a1 44 41 80 00       	mov    0x804144,%eax
  802e4d:	40                   	inc    %eax
  802e4e:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802e53:	eb 38                	jmp    802e8d <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802e55:	a1 40 41 80 00       	mov    0x804140,%eax
  802e5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e61:	74 07                	je     802e6a <insert_sorted_with_merge_freeList+0x421>
  802e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e66:	8b 00                	mov    (%eax),%eax
  802e68:	eb 05                	jmp    802e6f <insert_sorted_with_merge_freeList+0x426>
  802e6a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e6f:	a3 40 41 80 00       	mov    %eax,0x804140
  802e74:	a1 40 41 80 00       	mov    0x804140,%eax
  802e79:	85 c0                	test   %eax,%eax
  802e7b:	0f 85 1a fd ff ff    	jne    802b9b <insert_sorted_with_merge_freeList+0x152>
  802e81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e85:	0f 85 10 fd ff ff    	jne    802b9b <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e8b:	eb 00                	jmp    802e8d <insert_sorted_with_merge_freeList+0x444>
  802e8d:	90                   	nop
  802e8e:	c9                   	leave  
  802e8f:	c3                   	ret    

00802e90 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802e90:	55                   	push   %ebp
  802e91:	89 e5                	mov    %esp,%ebp
  802e93:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802e96:	8b 55 08             	mov    0x8(%ebp),%edx
  802e99:	89 d0                	mov    %edx,%eax
  802e9b:	c1 e0 02             	shl    $0x2,%eax
  802e9e:	01 d0                	add    %edx,%eax
  802ea0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ea7:	01 d0                	add    %edx,%eax
  802ea9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802eb0:	01 d0                	add    %edx,%eax
  802eb2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802eb9:	01 d0                	add    %edx,%eax
  802ebb:	c1 e0 04             	shl    $0x4,%eax
  802ebe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802ec1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802ec8:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802ecb:	83 ec 0c             	sub    $0xc,%esp
  802ece:	50                   	push   %eax
  802ecf:	e8 60 ed ff ff       	call   801c34 <sys_get_virtual_time>
  802ed4:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802ed7:	eb 41                	jmp    802f1a <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802ed9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802edc:	83 ec 0c             	sub    $0xc,%esp
  802edf:	50                   	push   %eax
  802ee0:	e8 4f ed ff ff       	call   801c34 <sys_get_virtual_time>
  802ee5:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802ee8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802eeb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eee:	29 c2                	sub    %eax,%edx
  802ef0:	89 d0                	mov    %edx,%eax
  802ef2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802ef5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ef8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efb:	89 d1                	mov    %edx,%ecx
  802efd:	29 c1                	sub    %eax,%ecx
  802eff:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802f02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f05:	39 c2                	cmp    %eax,%edx
  802f07:	0f 97 c0             	seta   %al
  802f0a:	0f b6 c0             	movzbl %al,%eax
  802f0d:	29 c1                	sub    %eax,%ecx
  802f0f:	89 c8                	mov    %ecx,%eax
  802f11:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802f14:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f17:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f20:	72 b7                	jb     802ed9 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802f22:	90                   	nop
  802f23:	c9                   	leave  
  802f24:	c3                   	ret    

00802f25 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802f25:	55                   	push   %ebp
  802f26:	89 e5                	mov    %esp,%ebp
  802f28:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802f2b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802f32:	eb 03                	jmp    802f37 <busy_wait+0x12>
  802f34:	ff 45 fc             	incl   -0x4(%ebp)
  802f37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f3a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f3d:	72 f5                	jb     802f34 <busy_wait+0xf>
	return i;
  802f3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802f42:	c9                   	leave  
  802f43:	c3                   	ret    

00802f44 <__udivdi3>:
  802f44:	55                   	push   %ebp
  802f45:	57                   	push   %edi
  802f46:	56                   	push   %esi
  802f47:	53                   	push   %ebx
  802f48:	83 ec 1c             	sub    $0x1c,%esp
  802f4b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802f4f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802f53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802f57:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f5b:	89 ca                	mov    %ecx,%edx
  802f5d:	89 f8                	mov    %edi,%eax
  802f5f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802f63:	85 f6                	test   %esi,%esi
  802f65:	75 2d                	jne    802f94 <__udivdi3+0x50>
  802f67:	39 cf                	cmp    %ecx,%edi
  802f69:	77 65                	ja     802fd0 <__udivdi3+0x8c>
  802f6b:	89 fd                	mov    %edi,%ebp
  802f6d:	85 ff                	test   %edi,%edi
  802f6f:	75 0b                	jne    802f7c <__udivdi3+0x38>
  802f71:	b8 01 00 00 00       	mov    $0x1,%eax
  802f76:	31 d2                	xor    %edx,%edx
  802f78:	f7 f7                	div    %edi
  802f7a:	89 c5                	mov    %eax,%ebp
  802f7c:	31 d2                	xor    %edx,%edx
  802f7e:	89 c8                	mov    %ecx,%eax
  802f80:	f7 f5                	div    %ebp
  802f82:	89 c1                	mov    %eax,%ecx
  802f84:	89 d8                	mov    %ebx,%eax
  802f86:	f7 f5                	div    %ebp
  802f88:	89 cf                	mov    %ecx,%edi
  802f8a:	89 fa                	mov    %edi,%edx
  802f8c:	83 c4 1c             	add    $0x1c,%esp
  802f8f:	5b                   	pop    %ebx
  802f90:	5e                   	pop    %esi
  802f91:	5f                   	pop    %edi
  802f92:	5d                   	pop    %ebp
  802f93:	c3                   	ret    
  802f94:	39 ce                	cmp    %ecx,%esi
  802f96:	77 28                	ja     802fc0 <__udivdi3+0x7c>
  802f98:	0f bd fe             	bsr    %esi,%edi
  802f9b:	83 f7 1f             	xor    $0x1f,%edi
  802f9e:	75 40                	jne    802fe0 <__udivdi3+0x9c>
  802fa0:	39 ce                	cmp    %ecx,%esi
  802fa2:	72 0a                	jb     802fae <__udivdi3+0x6a>
  802fa4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802fa8:	0f 87 9e 00 00 00    	ja     80304c <__udivdi3+0x108>
  802fae:	b8 01 00 00 00       	mov    $0x1,%eax
  802fb3:	89 fa                	mov    %edi,%edx
  802fb5:	83 c4 1c             	add    $0x1c,%esp
  802fb8:	5b                   	pop    %ebx
  802fb9:	5e                   	pop    %esi
  802fba:	5f                   	pop    %edi
  802fbb:	5d                   	pop    %ebp
  802fbc:	c3                   	ret    
  802fbd:	8d 76 00             	lea    0x0(%esi),%esi
  802fc0:	31 ff                	xor    %edi,%edi
  802fc2:	31 c0                	xor    %eax,%eax
  802fc4:	89 fa                	mov    %edi,%edx
  802fc6:	83 c4 1c             	add    $0x1c,%esp
  802fc9:	5b                   	pop    %ebx
  802fca:	5e                   	pop    %esi
  802fcb:	5f                   	pop    %edi
  802fcc:	5d                   	pop    %ebp
  802fcd:	c3                   	ret    
  802fce:	66 90                	xchg   %ax,%ax
  802fd0:	89 d8                	mov    %ebx,%eax
  802fd2:	f7 f7                	div    %edi
  802fd4:	31 ff                	xor    %edi,%edi
  802fd6:	89 fa                	mov    %edi,%edx
  802fd8:	83 c4 1c             	add    $0x1c,%esp
  802fdb:	5b                   	pop    %ebx
  802fdc:	5e                   	pop    %esi
  802fdd:	5f                   	pop    %edi
  802fde:	5d                   	pop    %ebp
  802fdf:	c3                   	ret    
  802fe0:	bd 20 00 00 00       	mov    $0x20,%ebp
  802fe5:	89 eb                	mov    %ebp,%ebx
  802fe7:	29 fb                	sub    %edi,%ebx
  802fe9:	89 f9                	mov    %edi,%ecx
  802feb:	d3 e6                	shl    %cl,%esi
  802fed:	89 c5                	mov    %eax,%ebp
  802fef:	88 d9                	mov    %bl,%cl
  802ff1:	d3 ed                	shr    %cl,%ebp
  802ff3:	89 e9                	mov    %ebp,%ecx
  802ff5:	09 f1                	or     %esi,%ecx
  802ff7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802ffb:	89 f9                	mov    %edi,%ecx
  802ffd:	d3 e0                	shl    %cl,%eax
  802fff:	89 c5                	mov    %eax,%ebp
  803001:	89 d6                	mov    %edx,%esi
  803003:	88 d9                	mov    %bl,%cl
  803005:	d3 ee                	shr    %cl,%esi
  803007:	89 f9                	mov    %edi,%ecx
  803009:	d3 e2                	shl    %cl,%edx
  80300b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80300f:	88 d9                	mov    %bl,%cl
  803011:	d3 e8                	shr    %cl,%eax
  803013:	09 c2                	or     %eax,%edx
  803015:	89 d0                	mov    %edx,%eax
  803017:	89 f2                	mov    %esi,%edx
  803019:	f7 74 24 0c          	divl   0xc(%esp)
  80301d:	89 d6                	mov    %edx,%esi
  80301f:	89 c3                	mov    %eax,%ebx
  803021:	f7 e5                	mul    %ebp
  803023:	39 d6                	cmp    %edx,%esi
  803025:	72 19                	jb     803040 <__udivdi3+0xfc>
  803027:	74 0b                	je     803034 <__udivdi3+0xf0>
  803029:	89 d8                	mov    %ebx,%eax
  80302b:	31 ff                	xor    %edi,%edi
  80302d:	e9 58 ff ff ff       	jmp    802f8a <__udivdi3+0x46>
  803032:	66 90                	xchg   %ax,%ax
  803034:	8b 54 24 08          	mov    0x8(%esp),%edx
  803038:	89 f9                	mov    %edi,%ecx
  80303a:	d3 e2                	shl    %cl,%edx
  80303c:	39 c2                	cmp    %eax,%edx
  80303e:	73 e9                	jae    803029 <__udivdi3+0xe5>
  803040:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803043:	31 ff                	xor    %edi,%edi
  803045:	e9 40 ff ff ff       	jmp    802f8a <__udivdi3+0x46>
  80304a:	66 90                	xchg   %ax,%ax
  80304c:	31 c0                	xor    %eax,%eax
  80304e:	e9 37 ff ff ff       	jmp    802f8a <__udivdi3+0x46>
  803053:	90                   	nop

00803054 <__umoddi3>:
  803054:	55                   	push   %ebp
  803055:	57                   	push   %edi
  803056:	56                   	push   %esi
  803057:	53                   	push   %ebx
  803058:	83 ec 1c             	sub    $0x1c,%esp
  80305b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80305f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803063:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803067:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80306b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80306f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803073:	89 f3                	mov    %esi,%ebx
  803075:	89 fa                	mov    %edi,%edx
  803077:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80307b:	89 34 24             	mov    %esi,(%esp)
  80307e:	85 c0                	test   %eax,%eax
  803080:	75 1a                	jne    80309c <__umoddi3+0x48>
  803082:	39 f7                	cmp    %esi,%edi
  803084:	0f 86 a2 00 00 00    	jbe    80312c <__umoddi3+0xd8>
  80308a:	89 c8                	mov    %ecx,%eax
  80308c:	89 f2                	mov    %esi,%edx
  80308e:	f7 f7                	div    %edi
  803090:	89 d0                	mov    %edx,%eax
  803092:	31 d2                	xor    %edx,%edx
  803094:	83 c4 1c             	add    $0x1c,%esp
  803097:	5b                   	pop    %ebx
  803098:	5e                   	pop    %esi
  803099:	5f                   	pop    %edi
  80309a:	5d                   	pop    %ebp
  80309b:	c3                   	ret    
  80309c:	39 f0                	cmp    %esi,%eax
  80309e:	0f 87 ac 00 00 00    	ja     803150 <__umoddi3+0xfc>
  8030a4:	0f bd e8             	bsr    %eax,%ebp
  8030a7:	83 f5 1f             	xor    $0x1f,%ebp
  8030aa:	0f 84 ac 00 00 00    	je     80315c <__umoddi3+0x108>
  8030b0:	bf 20 00 00 00       	mov    $0x20,%edi
  8030b5:	29 ef                	sub    %ebp,%edi
  8030b7:	89 fe                	mov    %edi,%esi
  8030b9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8030bd:	89 e9                	mov    %ebp,%ecx
  8030bf:	d3 e0                	shl    %cl,%eax
  8030c1:	89 d7                	mov    %edx,%edi
  8030c3:	89 f1                	mov    %esi,%ecx
  8030c5:	d3 ef                	shr    %cl,%edi
  8030c7:	09 c7                	or     %eax,%edi
  8030c9:	89 e9                	mov    %ebp,%ecx
  8030cb:	d3 e2                	shl    %cl,%edx
  8030cd:	89 14 24             	mov    %edx,(%esp)
  8030d0:	89 d8                	mov    %ebx,%eax
  8030d2:	d3 e0                	shl    %cl,%eax
  8030d4:	89 c2                	mov    %eax,%edx
  8030d6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030da:	d3 e0                	shl    %cl,%eax
  8030dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030e0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030e4:	89 f1                	mov    %esi,%ecx
  8030e6:	d3 e8                	shr    %cl,%eax
  8030e8:	09 d0                	or     %edx,%eax
  8030ea:	d3 eb                	shr    %cl,%ebx
  8030ec:	89 da                	mov    %ebx,%edx
  8030ee:	f7 f7                	div    %edi
  8030f0:	89 d3                	mov    %edx,%ebx
  8030f2:	f7 24 24             	mull   (%esp)
  8030f5:	89 c6                	mov    %eax,%esi
  8030f7:	89 d1                	mov    %edx,%ecx
  8030f9:	39 d3                	cmp    %edx,%ebx
  8030fb:	0f 82 87 00 00 00    	jb     803188 <__umoddi3+0x134>
  803101:	0f 84 91 00 00 00    	je     803198 <__umoddi3+0x144>
  803107:	8b 54 24 04          	mov    0x4(%esp),%edx
  80310b:	29 f2                	sub    %esi,%edx
  80310d:	19 cb                	sbb    %ecx,%ebx
  80310f:	89 d8                	mov    %ebx,%eax
  803111:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803115:	d3 e0                	shl    %cl,%eax
  803117:	89 e9                	mov    %ebp,%ecx
  803119:	d3 ea                	shr    %cl,%edx
  80311b:	09 d0                	or     %edx,%eax
  80311d:	89 e9                	mov    %ebp,%ecx
  80311f:	d3 eb                	shr    %cl,%ebx
  803121:	89 da                	mov    %ebx,%edx
  803123:	83 c4 1c             	add    $0x1c,%esp
  803126:	5b                   	pop    %ebx
  803127:	5e                   	pop    %esi
  803128:	5f                   	pop    %edi
  803129:	5d                   	pop    %ebp
  80312a:	c3                   	ret    
  80312b:	90                   	nop
  80312c:	89 fd                	mov    %edi,%ebp
  80312e:	85 ff                	test   %edi,%edi
  803130:	75 0b                	jne    80313d <__umoddi3+0xe9>
  803132:	b8 01 00 00 00       	mov    $0x1,%eax
  803137:	31 d2                	xor    %edx,%edx
  803139:	f7 f7                	div    %edi
  80313b:	89 c5                	mov    %eax,%ebp
  80313d:	89 f0                	mov    %esi,%eax
  80313f:	31 d2                	xor    %edx,%edx
  803141:	f7 f5                	div    %ebp
  803143:	89 c8                	mov    %ecx,%eax
  803145:	f7 f5                	div    %ebp
  803147:	89 d0                	mov    %edx,%eax
  803149:	e9 44 ff ff ff       	jmp    803092 <__umoddi3+0x3e>
  80314e:	66 90                	xchg   %ax,%ax
  803150:	89 c8                	mov    %ecx,%eax
  803152:	89 f2                	mov    %esi,%edx
  803154:	83 c4 1c             	add    $0x1c,%esp
  803157:	5b                   	pop    %ebx
  803158:	5e                   	pop    %esi
  803159:	5f                   	pop    %edi
  80315a:	5d                   	pop    %ebp
  80315b:	c3                   	ret    
  80315c:	3b 04 24             	cmp    (%esp),%eax
  80315f:	72 06                	jb     803167 <__umoddi3+0x113>
  803161:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803165:	77 0f                	ja     803176 <__umoddi3+0x122>
  803167:	89 f2                	mov    %esi,%edx
  803169:	29 f9                	sub    %edi,%ecx
  80316b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80316f:	89 14 24             	mov    %edx,(%esp)
  803172:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803176:	8b 44 24 04          	mov    0x4(%esp),%eax
  80317a:	8b 14 24             	mov    (%esp),%edx
  80317d:	83 c4 1c             	add    $0x1c,%esp
  803180:	5b                   	pop    %ebx
  803181:	5e                   	pop    %esi
  803182:	5f                   	pop    %edi
  803183:	5d                   	pop    %ebp
  803184:	c3                   	ret    
  803185:	8d 76 00             	lea    0x0(%esi),%esi
  803188:	2b 04 24             	sub    (%esp),%eax
  80318b:	19 fa                	sbb    %edi,%edx
  80318d:	89 d1                	mov    %edx,%ecx
  80318f:	89 c6                	mov    %eax,%esi
  803191:	e9 71 ff ff ff       	jmp    803107 <__umoddi3+0xb3>
  803196:	66 90                	xchg   %ax,%ax
  803198:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80319c:	72 ea                	jb     803188 <__umoddi3+0x134>
  80319e:	89 d9                	mov    %ebx,%ecx
  8031a0:	e9 62 ff ff ff       	jmp    803107 <__umoddi3+0xb3>
