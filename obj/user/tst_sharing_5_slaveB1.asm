
obj/user/tst_sharing_5_slaveB1:     file format elf32-i386


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
  800031:	e8 1e 01 00 00       	call   800154 <libmain>
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
  80008c:	68 a0 31 80 00       	push   $0x8031a0
  800091:	6a 12                	push   $0x12
  800093:	68 bc 31 80 00       	push   $0x8031bc
  800098:	e8 f3 01 00 00       	call   800290 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 2f 14 00 00       	call   8014d6 <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  8000aa:	e8 2c 1b 00 00       	call   801bdb <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 d9 31 80 00       	push   $0x8031d9
  8000b7:	50                   	push   %eax
  8000b8:	e8 11 16 00 00       	call   8016ce <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 dc 31 80 00       	push   $0x8031dc
  8000cb:	e8 74 04 00 00       	call   800544 <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got x
	inctst();
  8000d3:	e8 28 1c 00 00       	call   801d00 <inctst>
	cprintf("Slave B1 please be patient ...\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 04 32 80 00       	push   $0x803204
  8000e0:	e8 5f 04 00 00       	call   800544 <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(6000);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 70 17 00 00       	push   $0x1770
  8000f0:	e8 75 2d 00 00       	call   802e6a <env_sleep>
  8000f5:	83 c4 10             	add    $0x10,%esp

	int freeFrames = sys_calculate_free_frames() ;
  8000f8:	e8 e5 17 00 00       	call   8018e2 <sys_calculate_free_frames>
  8000fd:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(x);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 ec             	pushl  -0x14(%ebp)
  800106:	e8 77 16 00 00       	call   801782 <sfree>
  80010b:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	68 24 32 80 00       	push   $0x803224
  800116:	e8 29 04 00 00       	call   800544 <cprintf>
  80011b:	83 c4 10             	add    $0x10,%esp
	int expected = (1+1) + (1+1);
  80011e:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  800125:	e8 b8 17 00 00       	call   8018e2 <sys_calculate_free_frames>
  80012a:	89 c2                	mov    %eax,%edx
  80012c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80012f:	29 c2                	sub    %eax,%edx
  800131:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800134:	39 c2                	cmp    %eax,%edx
  800136:	74 14                	je     80014c <_main+0x114>
  800138:	83 ec 04             	sub    $0x4,%esp
  80013b:	68 3c 32 80 00       	push   $0x80323c
  800140:	6a 27                	push   $0x27
  800142:	68 bc 31 80 00       	push   $0x8031bc
  800147:	e8 44 01 00 00       	call   800290 <_panic>

	//To indicate that it's completed successfully
	inctst();
  80014c:	e8 af 1b 00 00       	call   801d00 <inctst>
	return;
  800151:	90                   	nop
}
  800152:	c9                   	leave  
  800153:	c3                   	ret    

00800154 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80015a:	e8 63 1a 00 00       	call   801bc2 <sys_getenvindex>
  80015f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800162:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800165:	89 d0                	mov    %edx,%eax
  800167:	c1 e0 03             	shl    $0x3,%eax
  80016a:	01 d0                	add    %edx,%eax
  80016c:	01 c0                	add    %eax,%eax
  80016e:	01 d0                	add    %edx,%eax
  800170:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800177:	01 d0                	add    %edx,%eax
  800179:	c1 e0 04             	shl    $0x4,%eax
  80017c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800181:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800186:	a1 20 40 80 00       	mov    0x804020,%eax
  80018b:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800191:	84 c0                	test   %al,%al
  800193:	74 0f                	je     8001a4 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800195:	a1 20 40 80 00       	mov    0x804020,%eax
  80019a:	05 5c 05 00 00       	add    $0x55c,%eax
  80019f:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001a8:	7e 0a                	jle    8001b4 <libmain+0x60>
		binaryname = argv[0];
  8001aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ad:	8b 00                	mov    (%eax),%eax
  8001af:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001b4:	83 ec 08             	sub    $0x8,%esp
  8001b7:	ff 75 0c             	pushl  0xc(%ebp)
  8001ba:	ff 75 08             	pushl  0x8(%ebp)
  8001bd:	e8 76 fe ff ff       	call   800038 <_main>
  8001c2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001c5:	e8 05 18 00 00       	call   8019cf <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 fc 32 80 00       	push   $0x8032fc
  8001d2:	e8 6d 03 00 00       	call   800544 <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001da:	a1 20 40 80 00       	mov    0x804020,%eax
  8001df:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001e5:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ea:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001f0:	83 ec 04             	sub    $0x4,%esp
  8001f3:	52                   	push   %edx
  8001f4:	50                   	push   %eax
  8001f5:	68 24 33 80 00       	push   $0x803324
  8001fa:	e8 45 03 00 00       	call   800544 <cprintf>
  8001ff:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800202:	a1 20 40 80 00       	mov    0x804020,%eax
  800207:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80020d:	a1 20 40 80 00       	mov    0x804020,%eax
  800212:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800218:	a1 20 40 80 00       	mov    0x804020,%eax
  80021d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800223:	51                   	push   %ecx
  800224:	52                   	push   %edx
  800225:	50                   	push   %eax
  800226:	68 4c 33 80 00       	push   $0x80334c
  80022b:	e8 14 03 00 00       	call   800544 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800233:	a1 20 40 80 00       	mov    0x804020,%eax
  800238:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80023e:	83 ec 08             	sub    $0x8,%esp
  800241:	50                   	push   %eax
  800242:	68 a4 33 80 00       	push   $0x8033a4
  800247:	e8 f8 02 00 00       	call   800544 <cprintf>
  80024c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	68 fc 32 80 00       	push   $0x8032fc
  800257:	e8 e8 02 00 00       	call   800544 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80025f:	e8 85 17 00 00       	call   8019e9 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800264:	e8 19 00 00 00       	call   800282 <exit>
}
  800269:	90                   	nop
  80026a:	c9                   	leave  
  80026b:	c3                   	ret    

0080026c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	6a 00                	push   $0x0
  800277:	e8 12 19 00 00       	call   801b8e <sys_destroy_env>
  80027c:	83 c4 10             	add    $0x10,%esp
}
  80027f:	90                   	nop
  800280:	c9                   	leave  
  800281:	c3                   	ret    

00800282 <exit>:

void
exit(void)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800288:	e8 67 19 00 00       	call   801bf4 <sys_exit_env>
}
  80028d:	90                   	nop
  80028e:	c9                   	leave  
  80028f:	c3                   	ret    

00800290 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800296:	8d 45 10             	lea    0x10(%ebp),%eax
  800299:	83 c0 04             	add    $0x4,%eax
  80029c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80029f:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002a4:	85 c0                	test   %eax,%eax
  8002a6:	74 16                	je     8002be <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002a8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002ad:	83 ec 08             	sub    $0x8,%esp
  8002b0:	50                   	push   %eax
  8002b1:	68 b8 33 80 00       	push   $0x8033b8
  8002b6:	e8 89 02 00 00       	call   800544 <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002be:	a1 00 40 80 00       	mov    0x804000,%eax
  8002c3:	ff 75 0c             	pushl  0xc(%ebp)
  8002c6:	ff 75 08             	pushl  0x8(%ebp)
  8002c9:	50                   	push   %eax
  8002ca:	68 bd 33 80 00       	push   $0x8033bd
  8002cf:	e8 70 02 00 00       	call   800544 <cprintf>
  8002d4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8002e0:	50                   	push   %eax
  8002e1:	e8 f3 01 00 00       	call   8004d9 <vcprintf>
  8002e6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002e9:	83 ec 08             	sub    $0x8,%esp
  8002ec:	6a 00                	push   $0x0
  8002ee:	68 d9 33 80 00       	push   $0x8033d9
  8002f3:	e8 e1 01 00 00       	call   8004d9 <vcprintf>
  8002f8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002fb:	e8 82 ff ff ff       	call   800282 <exit>

	// should not return here
	while (1) ;
  800300:	eb fe                	jmp    800300 <_panic+0x70>

00800302 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800308:	a1 20 40 80 00       	mov    0x804020,%eax
  80030d:	8b 50 74             	mov    0x74(%eax),%edx
  800310:	8b 45 0c             	mov    0xc(%ebp),%eax
  800313:	39 c2                	cmp    %eax,%edx
  800315:	74 14                	je     80032b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800317:	83 ec 04             	sub    $0x4,%esp
  80031a:	68 dc 33 80 00       	push   $0x8033dc
  80031f:	6a 26                	push   $0x26
  800321:	68 28 34 80 00       	push   $0x803428
  800326:	e8 65 ff ff ff       	call   800290 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80032b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800332:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800339:	e9 c2 00 00 00       	jmp    800400 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80033e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800341:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800348:	8b 45 08             	mov    0x8(%ebp),%eax
  80034b:	01 d0                	add    %edx,%eax
  80034d:	8b 00                	mov    (%eax),%eax
  80034f:	85 c0                	test   %eax,%eax
  800351:	75 08                	jne    80035b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800353:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800356:	e9 a2 00 00 00       	jmp    8003fd <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80035b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800362:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800369:	eb 69                	jmp    8003d4 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80036b:	a1 20 40 80 00       	mov    0x804020,%eax
  800370:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800376:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800379:	89 d0                	mov    %edx,%eax
  80037b:	01 c0                	add    %eax,%eax
  80037d:	01 d0                	add    %edx,%eax
  80037f:	c1 e0 03             	shl    $0x3,%eax
  800382:	01 c8                	add    %ecx,%eax
  800384:	8a 40 04             	mov    0x4(%eax),%al
  800387:	84 c0                	test   %al,%al
  800389:	75 46                	jne    8003d1 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80038b:	a1 20 40 80 00       	mov    0x804020,%eax
  800390:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800396:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800399:	89 d0                	mov    %edx,%eax
  80039b:	01 c0                	add    %eax,%eax
  80039d:	01 d0                	add    %edx,%eax
  80039f:	c1 e0 03             	shl    $0x3,%eax
  8003a2:	01 c8                	add    %ecx,%eax
  8003a4:	8b 00                	mov    (%eax),%eax
  8003a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003b1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c0:	01 c8                	add    %ecx,%eax
  8003c2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003c4:	39 c2                	cmp    %eax,%edx
  8003c6:	75 09                	jne    8003d1 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003c8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003cf:	eb 12                	jmp    8003e3 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d1:	ff 45 e8             	incl   -0x18(%ebp)
  8003d4:	a1 20 40 80 00       	mov    0x804020,%eax
  8003d9:	8b 50 74             	mov    0x74(%eax),%edx
  8003dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003df:	39 c2                	cmp    %eax,%edx
  8003e1:	77 88                	ja     80036b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003e7:	75 14                	jne    8003fd <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003e9:	83 ec 04             	sub    $0x4,%esp
  8003ec:	68 34 34 80 00       	push   $0x803434
  8003f1:	6a 3a                	push   $0x3a
  8003f3:	68 28 34 80 00       	push   $0x803428
  8003f8:	e8 93 fe ff ff       	call   800290 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003fd:	ff 45 f0             	incl   -0x10(%ebp)
  800400:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800403:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800406:	0f 8c 32 ff ff ff    	jl     80033e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80040c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800413:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80041a:	eb 26                	jmp    800442 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80041c:	a1 20 40 80 00       	mov    0x804020,%eax
  800421:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800427:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80042a:	89 d0                	mov    %edx,%eax
  80042c:	01 c0                	add    %eax,%eax
  80042e:	01 d0                	add    %edx,%eax
  800430:	c1 e0 03             	shl    $0x3,%eax
  800433:	01 c8                	add    %ecx,%eax
  800435:	8a 40 04             	mov    0x4(%eax),%al
  800438:	3c 01                	cmp    $0x1,%al
  80043a:	75 03                	jne    80043f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80043c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043f:	ff 45 e0             	incl   -0x20(%ebp)
  800442:	a1 20 40 80 00       	mov    0x804020,%eax
  800447:	8b 50 74             	mov    0x74(%eax),%edx
  80044a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80044d:	39 c2                	cmp    %eax,%edx
  80044f:	77 cb                	ja     80041c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800454:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800457:	74 14                	je     80046d <CheckWSWithoutLastIndex+0x16b>
		panic(
  800459:	83 ec 04             	sub    $0x4,%esp
  80045c:	68 88 34 80 00       	push   $0x803488
  800461:	6a 44                	push   $0x44
  800463:	68 28 34 80 00       	push   $0x803428
  800468:	e8 23 fe ff ff       	call   800290 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80046d:	90                   	nop
  80046e:	c9                   	leave  
  80046f:	c3                   	ret    

00800470 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800470:	55                   	push   %ebp
  800471:	89 e5                	mov    %esp,%ebp
  800473:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800476:	8b 45 0c             	mov    0xc(%ebp),%eax
  800479:	8b 00                	mov    (%eax),%eax
  80047b:	8d 48 01             	lea    0x1(%eax),%ecx
  80047e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800481:	89 0a                	mov    %ecx,(%edx)
  800483:	8b 55 08             	mov    0x8(%ebp),%edx
  800486:	88 d1                	mov    %dl,%cl
  800488:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80048f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	3d ff 00 00 00       	cmp    $0xff,%eax
  800499:	75 2c                	jne    8004c7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80049b:	a0 24 40 80 00       	mov    0x804024,%al
  8004a0:	0f b6 c0             	movzbl %al,%eax
  8004a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a6:	8b 12                	mov    (%edx),%edx
  8004a8:	89 d1                	mov    %edx,%ecx
  8004aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ad:	83 c2 08             	add    $0x8,%edx
  8004b0:	83 ec 04             	sub    $0x4,%esp
  8004b3:	50                   	push   %eax
  8004b4:	51                   	push   %ecx
  8004b5:	52                   	push   %edx
  8004b6:	e8 66 13 00 00       	call   801821 <sys_cputs>
  8004bb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ca:	8b 40 04             	mov    0x4(%eax),%eax
  8004cd:	8d 50 01             	lea    0x1(%eax),%edx
  8004d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004d6:	90                   	nop
  8004d7:	c9                   	leave  
  8004d8:	c3                   	ret    

008004d9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004d9:	55                   	push   %ebp
  8004da:	89 e5                	mov    %esp,%ebp
  8004dc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004e9:	00 00 00 
	b.cnt = 0;
  8004ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004f3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004f6:	ff 75 0c             	pushl  0xc(%ebp)
  8004f9:	ff 75 08             	pushl  0x8(%ebp)
  8004fc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800502:	50                   	push   %eax
  800503:	68 70 04 80 00       	push   $0x800470
  800508:	e8 11 02 00 00       	call   80071e <vprintfmt>
  80050d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800510:	a0 24 40 80 00       	mov    0x804024,%al
  800515:	0f b6 c0             	movzbl %al,%eax
  800518:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80051e:	83 ec 04             	sub    $0x4,%esp
  800521:	50                   	push   %eax
  800522:	52                   	push   %edx
  800523:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800529:	83 c0 08             	add    $0x8,%eax
  80052c:	50                   	push   %eax
  80052d:	e8 ef 12 00 00       	call   801821 <sys_cputs>
  800532:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800535:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80053c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800542:	c9                   	leave  
  800543:	c3                   	ret    

00800544 <cprintf>:

int cprintf(const char *fmt, ...) {
  800544:	55                   	push   %ebp
  800545:	89 e5                	mov    %esp,%ebp
  800547:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80054a:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800551:	8d 45 0c             	lea    0xc(%ebp),%eax
  800554:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800557:	8b 45 08             	mov    0x8(%ebp),%eax
  80055a:	83 ec 08             	sub    $0x8,%esp
  80055d:	ff 75 f4             	pushl  -0xc(%ebp)
  800560:	50                   	push   %eax
  800561:	e8 73 ff ff ff       	call   8004d9 <vcprintf>
  800566:	83 c4 10             	add    $0x10,%esp
  800569:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80056c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80056f:	c9                   	leave  
  800570:	c3                   	ret    

00800571 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
  800574:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800577:	e8 53 14 00 00       	call   8019cf <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80057c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80057f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800582:	8b 45 08             	mov    0x8(%ebp),%eax
  800585:	83 ec 08             	sub    $0x8,%esp
  800588:	ff 75 f4             	pushl  -0xc(%ebp)
  80058b:	50                   	push   %eax
  80058c:	e8 48 ff ff ff       	call   8004d9 <vcprintf>
  800591:	83 c4 10             	add    $0x10,%esp
  800594:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800597:	e8 4d 14 00 00       	call   8019e9 <sys_enable_interrupt>
	return cnt;
  80059c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80059f:	c9                   	leave  
  8005a0:	c3                   	ret    

008005a1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005a1:	55                   	push   %ebp
  8005a2:	89 e5                	mov    %esp,%ebp
  8005a4:	53                   	push   %ebx
  8005a5:	83 ec 14             	sub    $0x14,%esp
  8005a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005b4:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005bf:	77 55                	ja     800616 <printnum+0x75>
  8005c1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005c4:	72 05                	jb     8005cb <printnum+0x2a>
  8005c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005c9:	77 4b                	ja     800616 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005cb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005ce:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8005d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d9:	52                   	push   %edx
  8005da:	50                   	push   %eax
  8005db:	ff 75 f4             	pushl  -0xc(%ebp)
  8005de:	ff 75 f0             	pushl  -0x10(%ebp)
  8005e1:	e8 3a 29 00 00       	call   802f20 <__udivdi3>
  8005e6:	83 c4 10             	add    $0x10,%esp
  8005e9:	83 ec 04             	sub    $0x4,%esp
  8005ec:	ff 75 20             	pushl  0x20(%ebp)
  8005ef:	53                   	push   %ebx
  8005f0:	ff 75 18             	pushl  0x18(%ebp)
  8005f3:	52                   	push   %edx
  8005f4:	50                   	push   %eax
  8005f5:	ff 75 0c             	pushl  0xc(%ebp)
  8005f8:	ff 75 08             	pushl  0x8(%ebp)
  8005fb:	e8 a1 ff ff ff       	call   8005a1 <printnum>
  800600:	83 c4 20             	add    $0x20,%esp
  800603:	eb 1a                	jmp    80061f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800605:	83 ec 08             	sub    $0x8,%esp
  800608:	ff 75 0c             	pushl  0xc(%ebp)
  80060b:	ff 75 20             	pushl  0x20(%ebp)
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	ff d0                	call   *%eax
  800613:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800616:	ff 4d 1c             	decl   0x1c(%ebp)
  800619:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80061d:	7f e6                	jg     800605 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80061f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800622:	bb 00 00 00 00       	mov    $0x0,%ebx
  800627:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80062d:	53                   	push   %ebx
  80062e:	51                   	push   %ecx
  80062f:	52                   	push   %edx
  800630:	50                   	push   %eax
  800631:	e8 fa 29 00 00       	call   803030 <__umoddi3>
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	05 f4 36 80 00       	add    $0x8036f4,%eax
  80063e:	8a 00                	mov    (%eax),%al
  800640:	0f be c0             	movsbl %al,%eax
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	ff 75 0c             	pushl  0xc(%ebp)
  800649:	50                   	push   %eax
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	ff d0                	call   *%eax
  80064f:	83 c4 10             	add    $0x10,%esp
}
  800652:	90                   	nop
  800653:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800656:	c9                   	leave  
  800657:	c3                   	ret    

00800658 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800658:	55                   	push   %ebp
  800659:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80065b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80065f:	7e 1c                	jle    80067d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800661:	8b 45 08             	mov    0x8(%ebp),%eax
  800664:	8b 00                	mov    (%eax),%eax
  800666:	8d 50 08             	lea    0x8(%eax),%edx
  800669:	8b 45 08             	mov    0x8(%ebp),%eax
  80066c:	89 10                	mov    %edx,(%eax)
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	8b 00                	mov    (%eax),%eax
  800673:	83 e8 08             	sub    $0x8,%eax
  800676:	8b 50 04             	mov    0x4(%eax),%edx
  800679:	8b 00                	mov    (%eax),%eax
  80067b:	eb 40                	jmp    8006bd <getuint+0x65>
	else if (lflag)
  80067d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800681:	74 1e                	je     8006a1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	8d 50 04             	lea    0x4(%eax),%edx
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	89 10                	mov    %edx,(%eax)
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	83 e8 04             	sub    $0x4,%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	ba 00 00 00 00       	mov    $0x0,%edx
  80069f:	eb 1c                	jmp    8006bd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	8d 50 04             	lea    0x4(%eax),%edx
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	89 10                	mov    %edx,(%eax)
  8006ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b1:	8b 00                	mov    (%eax),%eax
  8006b3:	83 e8 04             	sub    $0x4,%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006bd:	5d                   	pop    %ebp
  8006be:	c3                   	ret    

008006bf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006c2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006c6:	7e 1c                	jle    8006e4 <getint+0x25>
		return va_arg(*ap, long long);
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	8d 50 08             	lea    0x8(%eax),%edx
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	89 10                	mov    %edx,(%eax)
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	83 e8 08             	sub    $0x8,%eax
  8006dd:	8b 50 04             	mov    0x4(%eax),%edx
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	eb 38                	jmp    80071c <getint+0x5d>
	else if (lflag)
  8006e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006e8:	74 1a                	je     800704 <getint+0x45>
		return va_arg(*ap, long);
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	8d 50 04             	lea    0x4(%eax),%edx
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	89 10                	mov    %edx,(%eax)
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	83 e8 04             	sub    $0x4,%eax
  8006ff:	8b 00                	mov    (%eax),%eax
  800701:	99                   	cltd   
  800702:	eb 18                	jmp    80071c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	8d 50 04             	lea    0x4(%eax),%edx
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	89 10                	mov    %edx,(%eax)
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	83 e8 04             	sub    $0x4,%eax
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	99                   	cltd   
}
  80071c:	5d                   	pop    %ebp
  80071d:	c3                   	ret    

0080071e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	56                   	push   %esi
  800722:	53                   	push   %ebx
  800723:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800726:	eb 17                	jmp    80073f <vprintfmt+0x21>
			if (ch == '\0')
  800728:	85 db                	test   %ebx,%ebx
  80072a:	0f 84 af 03 00 00    	je     800adf <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	ff 75 0c             	pushl  0xc(%ebp)
  800736:	53                   	push   %ebx
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	ff d0                	call   *%eax
  80073c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80073f:	8b 45 10             	mov    0x10(%ebp),%eax
  800742:	8d 50 01             	lea    0x1(%eax),%edx
  800745:	89 55 10             	mov    %edx,0x10(%ebp)
  800748:	8a 00                	mov    (%eax),%al
  80074a:	0f b6 d8             	movzbl %al,%ebx
  80074d:	83 fb 25             	cmp    $0x25,%ebx
  800750:	75 d6                	jne    800728 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800752:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800756:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80075d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800764:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80076b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800772:	8b 45 10             	mov    0x10(%ebp),%eax
  800775:	8d 50 01             	lea    0x1(%eax),%edx
  800778:	89 55 10             	mov    %edx,0x10(%ebp)
  80077b:	8a 00                	mov    (%eax),%al
  80077d:	0f b6 d8             	movzbl %al,%ebx
  800780:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800783:	83 f8 55             	cmp    $0x55,%eax
  800786:	0f 87 2b 03 00 00    	ja     800ab7 <vprintfmt+0x399>
  80078c:	8b 04 85 18 37 80 00 	mov    0x803718(,%eax,4),%eax
  800793:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800795:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800799:	eb d7                	jmp    800772 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80079b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80079f:	eb d1                	jmp    800772 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007ab:	89 d0                	mov    %edx,%eax
  8007ad:	c1 e0 02             	shl    $0x2,%eax
  8007b0:	01 d0                	add    %edx,%eax
  8007b2:	01 c0                	add    %eax,%eax
  8007b4:	01 d8                	add    %ebx,%eax
  8007b6:	83 e8 30             	sub    $0x30,%eax
  8007b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8007bf:	8a 00                	mov    (%eax),%al
  8007c1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007c4:	83 fb 2f             	cmp    $0x2f,%ebx
  8007c7:	7e 3e                	jle    800807 <vprintfmt+0xe9>
  8007c9:	83 fb 39             	cmp    $0x39,%ebx
  8007cc:	7f 39                	jg     800807 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ce:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007d1:	eb d5                	jmp    8007a8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	83 c0 04             	add    $0x4,%eax
  8007d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007df:	83 e8 04             	sub    $0x4,%eax
  8007e2:	8b 00                	mov    (%eax),%eax
  8007e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007e7:	eb 1f                	jmp    800808 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ed:	79 83                	jns    800772 <vprintfmt+0x54>
				width = 0;
  8007ef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007f6:	e9 77 ff ff ff       	jmp    800772 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007fb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800802:	e9 6b ff ff ff       	jmp    800772 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800807:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800808:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080c:	0f 89 60 ff ff ff    	jns    800772 <vprintfmt+0x54>
				width = precision, precision = -1;
  800812:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800818:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80081f:	e9 4e ff ff ff       	jmp    800772 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800824:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800827:	e9 46 ff ff ff       	jmp    800772 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	83 c0 04             	add    $0x4,%eax
  800832:	89 45 14             	mov    %eax,0x14(%ebp)
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	83 e8 04             	sub    $0x4,%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	50                   	push   %eax
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	ff d0                	call   *%eax
  800849:	83 c4 10             	add    $0x10,%esp
			break;
  80084c:	e9 89 02 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	83 c0 04             	add    $0x4,%eax
  800857:	89 45 14             	mov    %eax,0x14(%ebp)
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	83 e8 04             	sub    $0x4,%eax
  800860:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800862:	85 db                	test   %ebx,%ebx
  800864:	79 02                	jns    800868 <vprintfmt+0x14a>
				err = -err;
  800866:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800868:	83 fb 64             	cmp    $0x64,%ebx
  80086b:	7f 0b                	jg     800878 <vprintfmt+0x15a>
  80086d:	8b 34 9d 60 35 80 00 	mov    0x803560(,%ebx,4),%esi
  800874:	85 f6                	test   %esi,%esi
  800876:	75 19                	jne    800891 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800878:	53                   	push   %ebx
  800879:	68 05 37 80 00       	push   $0x803705
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	ff 75 08             	pushl  0x8(%ebp)
  800884:	e8 5e 02 00 00       	call   800ae7 <printfmt>
  800889:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80088c:	e9 49 02 00 00       	jmp    800ada <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800891:	56                   	push   %esi
  800892:	68 0e 37 80 00       	push   $0x80370e
  800897:	ff 75 0c             	pushl  0xc(%ebp)
  80089a:	ff 75 08             	pushl  0x8(%ebp)
  80089d:	e8 45 02 00 00       	call   800ae7 <printfmt>
  8008a2:	83 c4 10             	add    $0x10,%esp
			break;
  8008a5:	e9 30 02 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	83 c0 04             	add    $0x4,%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	83 e8 04             	sub    $0x4,%eax
  8008b9:	8b 30                	mov    (%eax),%esi
  8008bb:	85 f6                	test   %esi,%esi
  8008bd:	75 05                	jne    8008c4 <vprintfmt+0x1a6>
				p = "(null)";
  8008bf:	be 11 37 80 00       	mov    $0x803711,%esi
			if (width > 0 && padc != '-')
  8008c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c8:	7e 6d                	jle    800937 <vprintfmt+0x219>
  8008ca:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008ce:	74 67                	je     800937 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	50                   	push   %eax
  8008d7:	56                   	push   %esi
  8008d8:	e8 0c 03 00 00       	call   800be9 <strnlen>
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008e3:	eb 16                	jmp    8008fb <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008e5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	ff 75 0c             	pushl  0xc(%ebp)
  8008ef:	50                   	push   %eax
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	ff d0                	call   *%eax
  8008f5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f8:	ff 4d e4             	decl   -0x1c(%ebp)
  8008fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ff:	7f e4                	jg     8008e5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800901:	eb 34                	jmp    800937 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800903:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800907:	74 1c                	je     800925 <vprintfmt+0x207>
  800909:	83 fb 1f             	cmp    $0x1f,%ebx
  80090c:	7e 05                	jle    800913 <vprintfmt+0x1f5>
  80090e:	83 fb 7e             	cmp    $0x7e,%ebx
  800911:	7e 12                	jle    800925 <vprintfmt+0x207>
					putch('?', putdat);
  800913:	83 ec 08             	sub    $0x8,%esp
  800916:	ff 75 0c             	pushl  0xc(%ebp)
  800919:	6a 3f                	push   $0x3f
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	ff d0                	call   *%eax
  800920:	83 c4 10             	add    $0x10,%esp
  800923:	eb 0f                	jmp    800934 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800925:	83 ec 08             	sub    $0x8,%esp
  800928:	ff 75 0c             	pushl  0xc(%ebp)
  80092b:	53                   	push   %ebx
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	ff d0                	call   *%eax
  800931:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800934:	ff 4d e4             	decl   -0x1c(%ebp)
  800937:	89 f0                	mov    %esi,%eax
  800939:	8d 70 01             	lea    0x1(%eax),%esi
  80093c:	8a 00                	mov    (%eax),%al
  80093e:	0f be d8             	movsbl %al,%ebx
  800941:	85 db                	test   %ebx,%ebx
  800943:	74 24                	je     800969 <vprintfmt+0x24b>
  800945:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800949:	78 b8                	js     800903 <vprintfmt+0x1e5>
  80094b:	ff 4d e0             	decl   -0x20(%ebp)
  80094e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800952:	79 af                	jns    800903 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800954:	eb 13                	jmp    800969 <vprintfmt+0x24b>
				putch(' ', putdat);
  800956:	83 ec 08             	sub    $0x8,%esp
  800959:	ff 75 0c             	pushl  0xc(%ebp)
  80095c:	6a 20                	push   $0x20
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	ff d0                	call   *%eax
  800963:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800966:	ff 4d e4             	decl   -0x1c(%ebp)
  800969:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096d:	7f e7                	jg     800956 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80096f:	e9 66 01 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800974:	83 ec 08             	sub    $0x8,%esp
  800977:	ff 75 e8             	pushl  -0x18(%ebp)
  80097a:	8d 45 14             	lea    0x14(%ebp),%eax
  80097d:	50                   	push   %eax
  80097e:	e8 3c fd ff ff       	call   8006bf <getint>
  800983:	83 c4 10             	add    $0x10,%esp
  800986:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800989:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80098c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80098f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800992:	85 d2                	test   %edx,%edx
  800994:	79 23                	jns    8009b9 <vprintfmt+0x29b>
				putch('-', putdat);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	ff 75 0c             	pushl  0xc(%ebp)
  80099c:	6a 2d                	push   $0x2d
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	ff d0                	call   *%eax
  8009a3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ac:	f7 d8                	neg    %eax
  8009ae:	83 d2 00             	adc    $0x0,%edx
  8009b1:	f7 da                	neg    %edx
  8009b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009b9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c0:	e9 bc 00 00 00       	jmp    800a81 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009c5:	83 ec 08             	sub    $0x8,%esp
  8009c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8009cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ce:	50                   	push   %eax
  8009cf:	e8 84 fc ff ff       	call   800658 <getuint>
  8009d4:	83 c4 10             	add    $0x10,%esp
  8009d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009dd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e4:	e9 98 00 00 00       	jmp    800a81 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	6a 58                	push   $0x58
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	ff d0                	call   *%eax
  8009f6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	6a 58                	push   $0x58
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	ff d0                	call   *%eax
  800a06:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a09:	83 ec 08             	sub    $0x8,%esp
  800a0c:	ff 75 0c             	pushl  0xc(%ebp)
  800a0f:	6a 58                	push   $0x58
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	ff d0                	call   *%eax
  800a16:	83 c4 10             	add    $0x10,%esp
			break;
  800a19:	e9 bc 00 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 0c             	pushl  0xc(%ebp)
  800a24:	6a 30                	push   $0x30
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	ff d0                	call   *%eax
  800a2b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a2e:	83 ec 08             	sub    $0x8,%esp
  800a31:	ff 75 0c             	pushl  0xc(%ebp)
  800a34:	6a 78                	push   $0x78
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	ff d0                	call   *%eax
  800a3b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 c0 04             	add    $0x4,%eax
  800a44:	89 45 14             	mov    %eax,0x14(%ebp)
  800a47:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4a:	83 e8 04             	sub    $0x4,%eax
  800a4d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a59:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a60:	eb 1f                	jmp    800a81 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 e8             	pushl  -0x18(%ebp)
  800a68:	8d 45 14             	lea    0x14(%ebp),%eax
  800a6b:	50                   	push   %eax
  800a6c:	e8 e7 fb ff ff       	call   800658 <getuint>
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a7a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a81:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a88:	83 ec 04             	sub    $0x4,%esp
  800a8b:	52                   	push   %edx
  800a8c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a8f:	50                   	push   %eax
  800a90:	ff 75 f4             	pushl  -0xc(%ebp)
  800a93:	ff 75 f0             	pushl  -0x10(%ebp)
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	ff 75 08             	pushl  0x8(%ebp)
  800a9c:	e8 00 fb ff ff       	call   8005a1 <printnum>
  800aa1:	83 c4 20             	add    $0x20,%esp
			break;
  800aa4:	eb 34                	jmp    800ada <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	53                   	push   %ebx
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	ff d0                	call   *%eax
  800ab2:	83 c4 10             	add    $0x10,%esp
			break;
  800ab5:	eb 23                	jmp    800ada <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ab7:	83 ec 08             	sub    $0x8,%esp
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	6a 25                	push   $0x25
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	ff d0                	call   *%eax
  800ac4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ac7:	ff 4d 10             	decl   0x10(%ebp)
  800aca:	eb 03                	jmp    800acf <vprintfmt+0x3b1>
  800acc:	ff 4d 10             	decl   0x10(%ebp)
  800acf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad2:	48                   	dec    %eax
  800ad3:	8a 00                	mov    (%eax),%al
  800ad5:	3c 25                	cmp    $0x25,%al
  800ad7:	75 f3                	jne    800acc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ad9:	90                   	nop
		}
	}
  800ada:	e9 47 fc ff ff       	jmp    800726 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800adf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ae0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ae3:	5b                   	pop    %ebx
  800ae4:	5e                   	pop    %esi
  800ae5:	5d                   	pop    %ebp
  800ae6:	c3                   	ret    

00800ae7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800aed:	8d 45 10             	lea    0x10(%ebp),%eax
  800af0:	83 c0 04             	add    $0x4,%eax
  800af3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800af6:	8b 45 10             	mov    0x10(%ebp),%eax
  800af9:	ff 75 f4             	pushl  -0xc(%ebp)
  800afc:	50                   	push   %eax
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	ff 75 08             	pushl  0x8(%ebp)
  800b03:	e8 16 fc ff ff       	call   80071e <vprintfmt>
  800b08:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b0b:	90                   	nop
  800b0c:	c9                   	leave  
  800b0d:	c3                   	ret    

00800b0e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b14:	8b 40 08             	mov    0x8(%eax),%eax
  800b17:	8d 50 01             	lea    0x1(%eax),%edx
  800b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b23:	8b 10                	mov    (%eax),%edx
  800b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b28:	8b 40 04             	mov    0x4(%eax),%eax
  800b2b:	39 c2                	cmp    %eax,%edx
  800b2d:	73 12                	jae    800b41 <sprintputch+0x33>
		*b->buf++ = ch;
  800b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b32:	8b 00                	mov    (%eax),%eax
  800b34:	8d 48 01             	lea    0x1(%eax),%ecx
  800b37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3a:	89 0a                	mov    %ecx,(%edx)
  800b3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3f:	88 10                	mov    %dl,(%eax)
}
  800b41:	90                   	nop
  800b42:	5d                   	pop    %ebp
  800b43:	c3                   	ret    

00800b44 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b53:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	01 d0                	add    %edx,%eax
  800b5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b69:	74 06                	je     800b71 <vsnprintf+0x2d>
  800b6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b6f:	7f 07                	jg     800b78 <vsnprintf+0x34>
		return -E_INVAL;
  800b71:	b8 03 00 00 00       	mov    $0x3,%eax
  800b76:	eb 20                	jmp    800b98 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b78:	ff 75 14             	pushl  0x14(%ebp)
  800b7b:	ff 75 10             	pushl  0x10(%ebp)
  800b7e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b81:	50                   	push   %eax
  800b82:	68 0e 0b 80 00       	push   $0x800b0e
  800b87:	e8 92 fb ff ff       	call   80071e <vprintfmt>
  800b8c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b92:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b98:	c9                   	leave  
  800b99:	c3                   	ret    

00800b9a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ba0:	8d 45 10             	lea    0x10(%ebp),%eax
  800ba3:	83 c0 04             	add    $0x4,%eax
  800ba6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ba9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bac:	ff 75 f4             	pushl  -0xc(%ebp)
  800baf:	50                   	push   %eax
  800bb0:	ff 75 0c             	pushl  0xc(%ebp)
  800bb3:	ff 75 08             	pushl  0x8(%ebp)
  800bb6:	e8 89 ff ff ff       	call   800b44 <vsnprintf>
  800bbb:	83 c4 10             	add    $0x10,%esp
  800bbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bc4:	c9                   	leave  
  800bc5:	c3                   	ret    

00800bc6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bcc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd3:	eb 06                	jmp    800bdb <strlen+0x15>
		n++;
  800bd5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd8:	ff 45 08             	incl   0x8(%ebp)
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	84 c0                	test   %al,%al
  800be2:	75 f1                	jne    800bd5 <strlen+0xf>
		n++;
	return n;
  800be4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be7:	c9                   	leave  
  800be8:	c3                   	ret    

00800be9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf6:	eb 09                	jmp    800c01 <strnlen+0x18>
		n++;
  800bf8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bfb:	ff 45 08             	incl   0x8(%ebp)
  800bfe:	ff 4d 0c             	decl   0xc(%ebp)
  800c01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c05:	74 09                	je     800c10 <strnlen+0x27>
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	8a 00                	mov    (%eax),%al
  800c0c:	84 c0                	test   %al,%al
  800c0e:	75 e8                	jne    800bf8 <strnlen+0xf>
		n++;
	return n;
  800c10:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c13:	c9                   	leave  
  800c14:	c3                   	ret    

00800c15 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
  800c18:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c21:	90                   	nop
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	8d 50 01             	lea    0x1(%eax),%edx
  800c28:	89 55 08             	mov    %edx,0x8(%ebp)
  800c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c31:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c34:	8a 12                	mov    (%edx),%dl
  800c36:	88 10                	mov    %dl,(%eax)
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	84 c0                	test   %al,%al
  800c3c:	75 e4                	jne    800c22 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c41:	c9                   	leave  
  800c42:	c3                   	ret    

00800c43 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c56:	eb 1f                	jmp    800c77 <strncpy+0x34>
		*dst++ = *src;
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8d 50 01             	lea    0x1(%eax),%edx
  800c5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c64:	8a 12                	mov    (%edx),%dl
  800c66:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6b:	8a 00                	mov    (%eax),%al
  800c6d:	84 c0                	test   %al,%al
  800c6f:	74 03                	je     800c74 <strncpy+0x31>
			src++;
  800c71:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c74:	ff 45 fc             	incl   -0x4(%ebp)
  800c77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c7a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c7d:	72 d9                	jb     800c58 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    

00800c84 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c94:	74 30                	je     800cc6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c96:	eb 16                	jmp    800cae <strlcpy+0x2a>
			*dst++ = *src++;
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	8d 50 01             	lea    0x1(%eax),%edx
  800c9e:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ca7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800caa:	8a 12                	mov    (%edx),%dl
  800cac:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cae:	ff 4d 10             	decl   0x10(%ebp)
  800cb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb5:	74 09                	je     800cc0 <strlcpy+0x3c>
  800cb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cba:	8a 00                	mov    (%eax),%al
  800cbc:	84 c0                	test   %al,%al
  800cbe:	75 d8                	jne    800c98 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ccc:	29 c2                	sub    %eax,%edx
  800cce:	89 d0                	mov    %edx,%eax
}
  800cd0:	c9                   	leave  
  800cd1:	c3                   	ret    

00800cd2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cd5:	eb 06                	jmp    800cdd <strcmp+0xb>
		p++, q++;
  800cd7:	ff 45 08             	incl   0x8(%ebp)
  800cda:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	84 c0                	test   %al,%al
  800ce4:	74 0e                	je     800cf4 <strcmp+0x22>
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8a 10                	mov    (%eax),%dl
  800ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cee:	8a 00                	mov    (%eax),%al
  800cf0:	38 c2                	cmp    %al,%dl
  800cf2:	74 e3                	je     800cd7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8a 00                	mov    (%eax),%al
  800cf9:	0f b6 d0             	movzbl %al,%edx
  800cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cff:	8a 00                	mov    (%eax),%al
  800d01:	0f b6 c0             	movzbl %al,%eax
  800d04:	29 c2                	sub    %eax,%edx
  800d06:	89 d0                	mov    %edx,%eax
}
  800d08:	5d                   	pop    %ebp
  800d09:	c3                   	ret    

00800d0a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d0d:	eb 09                	jmp    800d18 <strncmp+0xe>
		n--, p++, q++;
  800d0f:	ff 4d 10             	decl   0x10(%ebp)
  800d12:	ff 45 08             	incl   0x8(%ebp)
  800d15:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1c:	74 17                	je     800d35 <strncmp+0x2b>
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	84 c0                	test   %al,%al
  800d25:	74 0e                	je     800d35 <strncmp+0x2b>
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8a 10                	mov    (%eax),%dl
  800d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	38 c2                	cmp    %al,%dl
  800d33:	74 da                	je     800d0f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d39:	75 07                	jne    800d42 <strncmp+0x38>
		return 0;
  800d3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d40:	eb 14                	jmp    800d56 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	0f b6 d0             	movzbl %al,%edx
  800d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4d:	8a 00                	mov    (%eax),%al
  800d4f:	0f b6 c0             	movzbl %al,%eax
  800d52:	29 c2                	sub    %eax,%edx
  800d54:	89 d0                	mov    %edx,%eax
}
  800d56:	5d                   	pop    %ebp
  800d57:	c3                   	ret    

00800d58 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	83 ec 04             	sub    $0x4,%esp
  800d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d61:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d64:	eb 12                	jmp    800d78 <strchr+0x20>
		if (*s == c)
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8a 00                	mov    (%eax),%al
  800d6b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d6e:	75 05                	jne    800d75 <strchr+0x1d>
			return (char *) s;
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	eb 11                	jmp    800d86 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d75:	ff 45 08             	incl   0x8(%ebp)
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	84 c0                	test   %al,%al
  800d7f:	75 e5                	jne    800d66 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d86:	c9                   	leave  
  800d87:	c3                   	ret    

00800d88 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	83 ec 04             	sub    $0x4,%esp
  800d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d91:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d94:	eb 0d                	jmp    800da3 <strfind+0x1b>
		if (*s == c)
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d9e:	74 0e                	je     800dae <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800da0:	ff 45 08             	incl   0x8(%ebp)
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	84 c0                	test   %al,%al
  800daa:	75 ea                	jne    800d96 <strfind+0xe>
  800dac:	eb 01                	jmp    800daf <strfind+0x27>
		if (*s == c)
			break;
  800dae:	90                   	nop
	return (char *) s;
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db2:	c9                   	leave  
  800db3:	c3                   	ret    

00800db4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dc6:	eb 0e                	jmp    800dd6 <memset+0x22>
		*p++ = c;
  800dc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcb:	8d 50 01             	lea    0x1(%eax),%edx
  800dce:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dd6:	ff 4d f8             	decl   -0x8(%ebp)
  800dd9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ddd:	79 e9                	jns    800dc8 <memset+0x14>
		*p++ = c;

	return v;
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de2:	c9                   	leave  
  800de3:	c3                   	ret    

00800de4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800df6:	eb 16                	jmp    800e0e <memcpy+0x2a>
		*d++ = *s++;
  800df8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dfb:	8d 50 01             	lea    0x1(%eax),%edx
  800dfe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e07:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e0a:	8a 12                	mov    (%edx),%dl
  800e0c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e11:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e14:	89 55 10             	mov    %edx,0x10(%ebp)
  800e17:	85 c0                	test   %eax,%eax
  800e19:	75 dd                	jne    800df8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e1e:	c9                   	leave  
  800e1f:	c3                   	ret    

00800e20 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e35:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e38:	73 50                	jae    800e8a <memmove+0x6a>
  800e3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e40:	01 d0                	add    %edx,%eax
  800e42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e45:	76 43                	jbe    800e8a <memmove+0x6a>
		s += n;
  800e47:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e50:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e53:	eb 10                	jmp    800e65 <memmove+0x45>
			*--d = *--s;
  800e55:	ff 4d f8             	decl   -0x8(%ebp)
  800e58:	ff 4d fc             	decl   -0x4(%ebp)
  800e5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5e:	8a 10                	mov    (%eax),%dl
  800e60:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e63:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e65:	8b 45 10             	mov    0x10(%ebp),%eax
  800e68:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6e:	85 c0                	test   %eax,%eax
  800e70:	75 e3                	jne    800e55 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e72:	eb 23                	jmp    800e97 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e77:	8d 50 01             	lea    0x1(%eax),%edx
  800e7a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e80:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e83:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e86:	8a 12                	mov    (%edx),%dl
  800e88:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e90:	89 55 10             	mov    %edx,0x10(%ebp)
  800e93:	85 c0                	test   %eax,%eax
  800e95:	75 dd                	jne    800e74 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e9a:	c9                   	leave  
  800e9b:	c3                   	ret    

00800e9c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eae:	eb 2a                	jmp    800eda <memcmp+0x3e>
		if (*s1 != *s2)
  800eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb3:	8a 10                	mov    (%eax),%dl
  800eb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	38 c2                	cmp    %al,%dl
  800ebc:	74 16                	je     800ed4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec1:	8a 00                	mov    (%eax),%al
  800ec3:	0f b6 d0             	movzbl %al,%edx
  800ec6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	0f b6 c0             	movzbl %al,%eax
  800ece:	29 c2                	sub    %eax,%edx
  800ed0:	89 d0                	mov    %edx,%eax
  800ed2:	eb 18                	jmp    800eec <memcmp+0x50>
		s1++, s2++;
  800ed4:	ff 45 fc             	incl   -0x4(%ebp)
  800ed7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eda:	8b 45 10             	mov    0x10(%ebp),%eax
  800edd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ee3:	85 c0                	test   %eax,%eax
  800ee5:	75 c9                	jne    800eb0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ee7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eec:	c9                   	leave  
  800eed:	c3                   	ret    

00800eee <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eee:	55                   	push   %ebp
  800eef:	89 e5                	mov    %esp,%ebp
  800ef1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ef4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef7:	8b 45 10             	mov    0x10(%ebp),%eax
  800efa:	01 d0                	add    %edx,%eax
  800efc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eff:	eb 15                	jmp    800f16 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	8a 00                	mov    (%eax),%al
  800f06:	0f b6 d0             	movzbl %al,%edx
  800f09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0c:	0f b6 c0             	movzbl %al,%eax
  800f0f:	39 c2                	cmp    %eax,%edx
  800f11:	74 0d                	je     800f20 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f13:	ff 45 08             	incl   0x8(%ebp)
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f1c:	72 e3                	jb     800f01 <memfind+0x13>
  800f1e:	eb 01                	jmp    800f21 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f20:	90                   	nop
	return (void *) s;
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f24:	c9                   	leave  
  800f25:	c3                   	ret    

00800f26 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f33:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f3a:	eb 03                	jmp    800f3f <strtol+0x19>
		s++;
  800f3c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	3c 20                	cmp    $0x20,%al
  800f46:	74 f4                	je     800f3c <strtol+0x16>
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	3c 09                	cmp    $0x9,%al
  800f4f:	74 eb                	je     800f3c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	3c 2b                	cmp    $0x2b,%al
  800f58:	75 05                	jne    800f5f <strtol+0x39>
		s++;
  800f5a:	ff 45 08             	incl   0x8(%ebp)
  800f5d:	eb 13                	jmp    800f72 <strtol+0x4c>
	else if (*s == '-')
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	3c 2d                	cmp    $0x2d,%al
  800f66:	75 0a                	jne    800f72 <strtol+0x4c>
		s++, neg = 1;
  800f68:	ff 45 08             	incl   0x8(%ebp)
  800f6b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f76:	74 06                	je     800f7e <strtol+0x58>
  800f78:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f7c:	75 20                	jne    800f9e <strtol+0x78>
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	3c 30                	cmp    $0x30,%al
  800f85:	75 17                	jne    800f9e <strtol+0x78>
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	40                   	inc    %eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	3c 78                	cmp    $0x78,%al
  800f8f:	75 0d                	jne    800f9e <strtol+0x78>
		s += 2, base = 16;
  800f91:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f95:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f9c:	eb 28                	jmp    800fc6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa2:	75 15                	jne    800fb9 <strtol+0x93>
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	3c 30                	cmp    $0x30,%al
  800fab:	75 0c                	jne    800fb9 <strtol+0x93>
		s++, base = 8;
  800fad:	ff 45 08             	incl   0x8(%ebp)
  800fb0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fb7:	eb 0d                	jmp    800fc6 <strtol+0xa0>
	else if (base == 0)
  800fb9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fbd:	75 07                	jne    800fc6 <strtol+0xa0>
		base = 10;
  800fbf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 2f                	cmp    $0x2f,%al
  800fcd:	7e 19                	jle    800fe8 <strtol+0xc2>
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	3c 39                	cmp    $0x39,%al
  800fd6:	7f 10                	jg     800fe8 <strtol+0xc2>
			dig = *s - '0';
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	0f be c0             	movsbl %al,%eax
  800fe0:	83 e8 30             	sub    $0x30,%eax
  800fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe6:	eb 42                	jmp    80102a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	3c 60                	cmp    $0x60,%al
  800fef:	7e 19                	jle    80100a <strtol+0xe4>
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 7a                	cmp    $0x7a,%al
  800ff8:	7f 10                	jg     80100a <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	0f be c0             	movsbl %al,%eax
  801002:	83 e8 57             	sub    $0x57,%eax
  801005:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801008:	eb 20                	jmp    80102a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	3c 40                	cmp    $0x40,%al
  801011:	7e 39                	jle    80104c <strtol+0x126>
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	3c 5a                	cmp    $0x5a,%al
  80101a:	7f 30                	jg     80104c <strtol+0x126>
			dig = *s - 'A' + 10;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	8a 00                	mov    (%eax),%al
  801021:	0f be c0             	movsbl %al,%eax
  801024:	83 e8 37             	sub    $0x37,%eax
  801027:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80102a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80102d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801030:	7d 19                	jge    80104b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801032:	ff 45 08             	incl   0x8(%ebp)
  801035:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801038:	0f af 45 10          	imul   0x10(%ebp),%eax
  80103c:	89 c2                	mov    %eax,%edx
  80103e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801041:	01 d0                	add    %edx,%eax
  801043:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801046:	e9 7b ff ff ff       	jmp    800fc6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80104b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80104c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801050:	74 08                	je     80105a <strtol+0x134>
		*endptr = (char *) s;
  801052:	8b 45 0c             	mov    0xc(%ebp),%eax
  801055:	8b 55 08             	mov    0x8(%ebp),%edx
  801058:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80105a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80105e:	74 07                	je     801067 <strtol+0x141>
  801060:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801063:	f7 d8                	neg    %eax
  801065:	eb 03                	jmp    80106a <strtol+0x144>
  801067:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80106a:	c9                   	leave  
  80106b:	c3                   	ret    

0080106c <ltostr>:

void
ltostr(long value, char *str)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801072:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801079:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801080:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801084:	79 13                	jns    801099 <ltostr+0x2d>
	{
		neg = 1;
  801086:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80108d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801090:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801093:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801096:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010a1:	99                   	cltd   
  8010a2:	f7 f9                	idiv   %ecx
  8010a4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010aa:	8d 50 01             	lea    0x1(%eax),%edx
  8010ad:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b0:	89 c2                	mov    %eax,%edx
  8010b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b5:	01 d0                	add    %edx,%eax
  8010b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010ba:	83 c2 30             	add    $0x30,%edx
  8010bd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c7:	f7 e9                	imul   %ecx
  8010c9:	c1 fa 02             	sar    $0x2,%edx
  8010cc:	89 c8                	mov    %ecx,%eax
  8010ce:	c1 f8 1f             	sar    $0x1f,%eax
  8010d1:	29 c2                	sub    %eax,%edx
  8010d3:	89 d0                	mov    %edx,%eax
  8010d5:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010db:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010e0:	f7 e9                	imul   %ecx
  8010e2:	c1 fa 02             	sar    $0x2,%edx
  8010e5:	89 c8                	mov    %ecx,%eax
  8010e7:	c1 f8 1f             	sar    $0x1f,%eax
  8010ea:	29 c2                	sub    %eax,%edx
  8010ec:	89 d0                	mov    %edx,%eax
  8010ee:	c1 e0 02             	shl    $0x2,%eax
  8010f1:	01 d0                	add    %edx,%eax
  8010f3:	01 c0                	add    %eax,%eax
  8010f5:	29 c1                	sub    %eax,%ecx
  8010f7:	89 ca                	mov    %ecx,%edx
  8010f9:	85 d2                	test   %edx,%edx
  8010fb:	75 9c                	jne    801099 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801104:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801107:	48                   	dec    %eax
  801108:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80110b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80110f:	74 3d                	je     80114e <ltostr+0xe2>
		start = 1 ;
  801111:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801118:	eb 34                	jmp    80114e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80111a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801120:	01 d0                	add    %edx,%eax
  801122:	8a 00                	mov    (%eax),%al
  801124:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801127:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80112a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112d:	01 c2                	add    %eax,%edx
  80112f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	01 c8                	add    %ecx,%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80113b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80113e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801141:	01 c2                	add    %eax,%edx
  801143:	8a 45 eb             	mov    -0x15(%ebp),%al
  801146:	88 02                	mov    %al,(%edx)
		start++ ;
  801148:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80114b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80114e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801151:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801154:	7c c4                	jl     80111a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801156:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801159:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115c:	01 d0                	add    %edx,%eax
  80115e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801161:	90                   	nop
  801162:	c9                   	leave  
  801163:	c3                   	ret    

00801164 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801164:	55                   	push   %ebp
  801165:	89 e5                	mov    %esp,%ebp
  801167:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80116a:	ff 75 08             	pushl  0x8(%ebp)
  80116d:	e8 54 fa ff ff       	call   800bc6 <strlen>
  801172:	83 c4 04             	add    $0x4,%esp
  801175:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801178:	ff 75 0c             	pushl  0xc(%ebp)
  80117b:	e8 46 fa ff ff       	call   800bc6 <strlen>
  801180:	83 c4 04             	add    $0x4,%esp
  801183:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801186:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80118d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801194:	eb 17                	jmp    8011ad <strcconcat+0x49>
		final[s] = str1[s] ;
  801196:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801199:	8b 45 10             	mov    0x10(%ebp),%eax
  80119c:	01 c2                	add    %eax,%edx
  80119e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	01 c8                	add    %ecx,%eax
  8011a6:	8a 00                	mov    (%eax),%al
  8011a8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011aa:	ff 45 fc             	incl   -0x4(%ebp)
  8011ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011b3:	7c e1                	jl     801196 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011c3:	eb 1f                	jmp    8011e4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c8:	8d 50 01             	lea    0x1(%eax),%edx
  8011cb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011ce:	89 c2                	mov    %eax,%edx
  8011d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d3:	01 c2                	add    %eax,%edx
  8011d5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011db:	01 c8                	add    %ecx,%eax
  8011dd:	8a 00                	mov    (%eax),%al
  8011df:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011e1:	ff 45 f8             	incl   -0x8(%ebp)
  8011e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ea:	7c d9                	jl     8011c5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f2:	01 d0                	add    %edx,%eax
  8011f4:	c6 00 00             	movb   $0x0,(%eax)
}
  8011f7:	90                   	nop
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    

008011fa <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801200:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801206:	8b 45 14             	mov    0x14(%ebp),%eax
  801209:	8b 00                	mov    (%eax),%eax
  80120b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801212:	8b 45 10             	mov    0x10(%ebp),%eax
  801215:	01 d0                	add    %edx,%eax
  801217:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80121d:	eb 0c                	jmp    80122b <strsplit+0x31>
			*string++ = 0;
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	8d 50 01             	lea    0x1(%eax),%edx
  801225:	89 55 08             	mov    %edx,0x8(%ebp)
  801228:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	8a 00                	mov    (%eax),%al
  801230:	84 c0                	test   %al,%al
  801232:	74 18                	je     80124c <strsplit+0x52>
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
  801237:	8a 00                	mov    (%eax),%al
  801239:	0f be c0             	movsbl %al,%eax
  80123c:	50                   	push   %eax
  80123d:	ff 75 0c             	pushl  0xc(%ebp)
  801240:	e8 13 fb ff ff       	call   800d58 <strchr>
  801245:	83 c4 08             	add    $0x8,%esp
  801248:	85 c0                	test   %eax,%eax
  80124a:	75 d3                	jne    80121f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8a 00                	mov    (%eax),%al
  801251:	84 c0                	test   %al,%al
  801253:	74 5a                	je     8012af <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801255:	8b 45 14             	mov    0x14(%ebp),%eax
  801258:	8b 00                	mov    (%eax),%eax
  80125a:	83 f8 0f             	cmp    $0xf,%eax
  80125d:	75 07                	jne    801266 <strsplit+0x6c>
		{
			return 0;
  80125f:	b8 00 00 00 00       	mov    $0x0,%eax
  801264:	eb 66                	jmp    8012cc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801266:	8b 45 14             	mov    0x14(%ebp),%eax
  801269:	8b 00                	mov    (%eax),%eax
  80126b:	8d 48 01             	lea    0x1(%eax),%ecx
  80126e:	8b 55 14             	mov    0x14(%ebp),%edx
  801271:	89 0a                	mov    %ecx,(%edx)
  801273:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80127a:	8b 45 10             	mov    0x10(%ebp),%eax
  80127d:	01 c2                	add    %eax,%edx
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801284:	eb 03                	jmp    801289 <strsplit+0x8f>
			string++;
  801286:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	84 c0                	test   %al,%al
  801290:	74 8b                	je     80121d <strsplit+0x23>
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	0f be c0             	movsbl %al,%eax
  80129a:	50                   	push   %eax
  80129b:	ff 75 0c             	pushl  0xc(%ebp)
  80129e:	e8 b5 fa ff ff       	call   800d58 <strchr>
  8012a3:	83 c4 08             	add    $0x8,%esp
  8012a6:	85 c0                	test   %eax,%eax
  8012a8:	74 dc                	je     801286 <strsplit+0x8c>
			string++;
	}
  8012aa:	e9 6e ff ff ff       	jmp    80121d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012af:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b3:	8b 00                	mov    (%eax),%eax
  8012b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bf:	01 d0                	add    %edx,%eax
  8012c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012c7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012d4:	a1 04 40 80 00       	mov    0x804004,%eax
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	74 1f                	je     8012fc <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012dd:	e8 1d 00 00 00       	call   8012ff <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012e2:	83 ec 0c             	sub    $0xc,%esp
  8012e5:	68 70 38 80 00       	push   $0x803870
  8012ea:	e8 55 f2 ff ff       	call   800544 <cprintf>
  8012ef:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012f2:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012f9:	00 00 00 
	}
}
  8012fc:	90                   	nop
  8012fd:	c9                   	leave  
  8012fe:	c3                   	ret    

008012ff <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
  801302:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801305:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80130c:	00 00 00 
  80130f:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801316:	00 00 00 
  801319:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801320:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801323:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80132a:	00 00 00 
  80132d:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801334:	00 00 00 
  801337:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80133e:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801341:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801348:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  80134b:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801352:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801355:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80135a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80135f:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  801364:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  80136b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80136e:	a1 20 41 80 00       	mov    0x804120,%eax
  801373:	0f af c2             	imul   %edx,%eax
  801376:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801379:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801380:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801383:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801386:	01 d0                	add    %edx,%eax
  801388:	48                   	dec    %eax
  801389:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80138c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80138f:	ba 00 00 00 00       	mov    $0x0,%edx
  801394:	f7 75 e8             	divl   -0x18(%ebp)
  801397:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80139a:	29 d0                	sub    %edx,%eax
  80139c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  80139f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013a2:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  8013a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013ac:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8013b2:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8013b8:	83 ec 04             	sub    $0x4,%esp
  8013bb:	6a 06                	push   $0x6
  8013bd:	50                   	push   %eax
  8013be:	52                   	push   %edx
  8013bf:	e8 a1 05 00 00       	call   801965 <sys_allocate_chunk>
  8013c4:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013c7:	a1 20 41 80 00       	mov    0x804120,%eax
  8013cc:	83 ec 0c             	sub    $0xc,%esp
  8013cf:	50                   	push   %eax
  8013d0:	e8 16 0c 00 00       	call   801feb <initialize_MemBlocksList>
  8013d5:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  8013d8:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8013dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  8013e0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8013e4:	75 14                	jne    8013fa <initialize_dyn_block_system+0xfb>
  8013e6:	83 ec 04             	sub    $0x4,%esp
  8013e9:	68 95 38 80 00       	push   $0x803895
  8013ee:	6a 2d                	push   $0x2d
  8013f0:	68 b3 38 80 00       	push   $0x8038b3
  8013f5:	e8 96 ee ff ff       	call   800290 <_panic>
  8013fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013fd:	8b 00                	mov    (%eax),%eax
  8013ff:	85 c0                	test   %eax,%eax
  801401:	74 10                	je     801413 <initialize_dyn_block_system+0x114>
  801403:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801406:	8b 00                	mov    (%eax),%eax
  801408:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80140b:	8b 52 04             	mov    0x4(%edx),%edx
  80140e:	89 50 04             	mov    %edx,0x4(%eax)
  801411:	eb 0b                	jmp    80141e <initialize_dyn_block_system+0x11f>
  801413:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801416:	8b 40 04             	mov    0x4(%eax),%eax
  801419:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80141e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801421:	8b 40 04             	mov    0x4(%eax),%eax
  801424:	85 c0                	test   %eax,%eax
  801426:	74 0f                	je     801437 <initialize_dyn_block_system+0x138>
  801428:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80142b:	8b 40 04             	mov    0x4(%eax),%eax
  80142e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801431:	8b 12                	mov    (%edx),%edx
  801433:	89 10                	mov    %edx,(%eax)
  801435:	eb 0a                	jmp    801441 <initialize_dyn_block_system+0x142>
  801437:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80143a:	8b 00                	mov    (%eax),%eax
  80143c:	a3 48 41 80 00       	mov    %eax,0x804148
  801441:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801444:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80144a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80144d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801454:	a1 54 41 80 00       	mov    0x804154,%eax
  801459:	48                   	dec    %eax
  80145a:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  80145f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801462:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801469:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80146c:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801473:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801477:	75 14                	jne    80148d <initialize_dyn_block_system+0x18e>
  801479:	83 ec 04             	sub    $0x4,%esp
  80147c:	68 c0 38 80 00       	push   $0x8038c0
  801481:	6a 30                	push   $0x30
  801483:	68 b3 38 80 00       	push   $0x8038b3
  801488:	e8 03 ee ff ff       	call   800290 <_panic>
  80148d:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  801493:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801496:	89 50 04             	mov    %edx,0x4(%eax)
  801499:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80149c:	8b 40 04             	mov    0x4(%eax),%eax
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	74 0c                	je     8014af <initialize_dyn_block_system+0x1b0>
  8014a3:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8014a8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014ab:	89 10                	mov    %edx,(%eax)
  8014ad:	eb 08                	jmp    8014b7 <initialize_dyn_block_system+0x1b8>
  8014af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014b2:	a3 38 41 80 00       	mov    %eax,0x804138
  8014b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014ba:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8014bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014c8:	a1 44 41 80 00       	mov    0x804144,%eax
  8014cd:	40                   	inc    %eax
  8014ce:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8014d3:	90                   	nop
  8014d4:	c9                   	leave  
  8014d5:	c3                   	ret    

008014d6 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
  8014d9:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014dc:	e8 ed fd ff ff       	call   8012ce <InitializeUHeap>
	if (size == 0) return NULL ;
  8014e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014e5:	75 07                	jne    8014ee <malloc+0x18>
  8014e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ec:	eb 67                	jmp    801555 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  8014ee:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014fb:	01 d0                	add    %edx,%eax
  8014fd:	48                   	dec    %eax
  8014fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801501:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801504:	ba 00 00 00 00       	mov    $0x0,%edx
  801509:	f7 75 f4             	divl   -0xc(%ebp)
  80150c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150f:	29 d0                	sub    %edx,%eax
  801511:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801514:	e8 1a 08 00 00       	call   801d33 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801519:	85 c0                	test   %eax,%eax
  80151b:	74 33                	je     801550 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  80151d:	83 ec 0c             	sub    $0xc,%esp
  801520:	ff 75 08             	pushl  0x8(%ebp)
  801523:	e8 0c 0e 00 00       	call   802334 <alloc_block_FF>
  801528:	83 c4 10             	add    $0x10,%esp
  80152b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  80152e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801532:	74 1c                	je     801550 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801534:	83 ec 0c             	sub    $0xc,%esp
  801537:	ff 75 ec             	pushl  -0x14(%ebp)
  80153a:	e8 07 0c 00 00       	call   802146 <insert_sorted_allocList>
  80153f:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801542:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801545:	8b 40 08             	mov    0x8(%eax),%eax
  801548:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  80154b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80154e:	eb 05                	jmp    801555 <malloc+0x7f>
		}
	}
	return NULL;
  801550:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801555:	c9                   	leave  
  801556:	c3                   	ret    

00801557 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
  80155a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801563:	83 ec 08             	sub    $0x8,%esp
  801566:	ff 75 f4             	pushl  -0xc(%ebp)
  801569:	68 40 40 80 00       	push   $0x804040
  80156e:	e8 5b 0b 00 00       	call   8020ce <find_block>
  801573:	83 c4 10             	add    $0x10,%esp
  801576:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801579:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157c:	8b 40 0c             	mov    0xc(%eax),%eax
  80157f:	83 ec 08             	sub    $0x8,%esp
  801582:	50                   	push   %eax
  801583:	ff 75 f4             	pushl  -0xc(%ebp)
  801586:	e8 a2 03 00 00       	call   80192d <sys_free_user_mem>
  80158b:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  80158e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801592:	75 14                	jne    8015a8 <free+0x51>
  801594:	83 ec 04             	sub    $0x4,%esp
  801597:	68 95 38 80 00       	push   $0x803895
  80159c:	6a 76                	push   $0x76
  80159e:	68 b3 38 80 00       	push   $0x8038b3
  8015a3:	e8 e8 ec ff ff       	call   800290 <_panic>
  8015a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ab:	8b 00                	mov    (%eax),%eax
  8015ad:	85 c0                	test   %eax,%eax
  8015af:	74 10                	je     8015c1 <free+0x6a>
  8015b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b4:	8b 00                	mov    (%eax),%eax
  8015b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015b9:	8b 52 04             	mov    0x4(%edx),%edx
  8015bc:	89 50 04             	mov    %edx,0x4(%eax)
  8015bf:	eb 0b                	jmp    8015cc <free+0x75>
  8015c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c4:	8b 40 04             	mov    0x4(%eax),%eax
  8015c7:	a3 44 40 80 00       	mov    %eax,0x804044
  8015cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cf:	8b 40 04             	mov    0x4(%eax),%eax
  8015d2:	85 c0                	test   %eax,%eax
  8015d4:	74 0f                	je     8015e5 <free+0x8e>
  8015d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d9:	8b 40 04             	mov    0x4(%eax),%eax
  8015dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015df:	8b 12                	mov    (%edx),%edx
  8015e1:	89 10                	mov    %edx,(%eax)
  8015e3:	eb 0a                	jmp    8015ef <free+0x98>
  8015e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e8:	8b 00                	mov    (%eax),%eax
  8015ea:	a3 40 40 80 00       	mov    %eax,0x804040
  8015ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801602:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801607:	48                   	dec    %eax
  801608:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  80160d:	83 ec 0c             	sub    $0xc,%esp
  801610:	ff 75 f0             	pushl  -0x10(%ebp)
  801613:	e8 0b 14 00 00       	call   802a23 <insert_sorted_with_merge_freeList>
  801618:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80161b:	90                   	nop
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	83 ec 28             	sub    $0x28,%esp
  801624:	8b 45 10             	mov    0x10(%ebp),%eax
  801627:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80162a:	e8 9f fc ff ff       	call   8012ce <InitializeUHeap>
	if (size == 0) return NULL ;
  80162f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801633:	75 0a                	jne    80163f <smalloc+0x21>
  801635:	b8 00 00 00 00       	mov    $0x0,%eax
  80163a:	e9 8d 00 00 00       	jmp    8016cc <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  80163f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801646:	8b 55 0c             	mov    0xc(%ebp),%edx
  801649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164c:	01 d0                	add    %edx,%eax
  80164e:	48                   	dec    %eax
  80164f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801652:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801655:	ba 00 00 00 00       	mov    $0x0,%edx
  80165a:	f7 75 f4             	divl   -0xc(%ebp)
  80165d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801660:	29 d0                	sub    %edx,%eax
  801662:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801665:	e8 c9 06 00 00       	call   801d33 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80166a:	85 c0                	test   %eax,%eax
  80166c:	74 59                	je     8016c7 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  80166e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801675:	83 ec 0c             	sub    $0xc,%esp
  801678:	ff 75 0c             	pushl  0xc(%ebp)
  80167b:	e8 b4 0c 00 00       	call   802334 <alloc_block_FF>
  801680:	83 c4 10             	add    $0x10,%esp
  801683:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801686:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80168a:	75 07                	jne    801693 <smalloc+0x75>
			{
				return NULL;
  80168c:	b8 00 00 00 00       	mov    $0x0,%eax
  801691:	eb 39                	jmp    8016cc <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801693:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801696:	8b 40 08             	mov    0x8(%eax),%eax
  801699:	89 c2                	mov    %eax,%edx
  80169b:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80169f:	52                   	push   %edx
  8016a0:	50                   	push   %eax
  8016a1:	ff 75 0c             	pushl  0xc(%ebp)
  8016a4:	ff 75 08             	pushl  0x8(%ebp)
  8016a7:	e8 0c 04 00 00       	call   801ab8 <sys_createSharedObject>
  8016ac:	83 c4 10             	add    $0x10,%esp
  8016af:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  8016b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016b6:	78 08                	js     8016c0 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  8016b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016bb:	8b 40 08             	mov    0x8(%eax),%eax
  8016be:	eb 0c                	jmp    8016cc <smalloc+0xae>
				}
				else
				{
					return NULL;
  8016c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c5:	eb 05                	jmp    8016cc <smalloc+0xae>
				}
			}

		}
		return NULL;
  8016c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016cc:	c9                   	leave  
  8016cd:	c3                   	ret    

008016ce <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016d4:	e8 f5 fb ff ff       	call   8012ce <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016d9:	83 ec 08             	sub    $0x8,%esp
  8016dc:	ff 75 0c             	pushl  0xc(%ebp)
  8016df:	ff 75 08             	pushl  0x8(%ebp)
  8016e2:	e8 fb 03 00 00       	call   801ae2 <sys_getSizeOfSharedObject>
  8016e7:	83 c4 10             	add    $0x10,%esp
  8016ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  8016ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016f1:	75 07                	jne    8016fa <sget+0x2c>
	{
		return NULL;
  8016f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f8:	eb 64                	jmp    80175e <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016fa:	e8 34 06 00 00       	call   801d33 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016ff:	85 c0                	test   %eax,%eax
  801701:	74 56                	je     801759 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801703:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  80170a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80170d:	83 ec 0c             	sub    $0xc,%esp
  801710:	50                   	push   %eax
  801711:	e8 1e 0c 00 00       	call   802334 <alloc_block_FF>
  801716:	83 c4 10             	add    $0x10,%esp
  801719:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  80171c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801720:	75 07                	jne    801729 <sget+0x5b>
		{
		return NULL;
  801722:	b8 00 00 00 00       	mov    $0x0,%eax
  801727:	eb 35                	jmp    80175e <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801729:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172c:	8b 40 08             	mov    0x8(%eax),%eax
  80172f:	83 ec 04             	sub    $0x4,%esp
  801732:	50                   	push   %eax
  801733:	ff 75 0c             	pushl  0xc(%ebp)
  801736:	ff 75 08             	pushl  0x8(%ebp)
  801739:	e8 c1 03 00 00       	call   801aff <sys_getSharedObject>
  80173e:	83 c4 10             	add    $0x10,%esp
  801741:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801744:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801748:	78 08                	js     801752 <sget+0x84>
			{
				return (void*)v1->sva;
  80174a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80174d:	8b 40 08             	mov    0x8(%eax),%eax
  801750:	eb 0c                	jmp    80175e <sget+0x90>
			}
			else
			{
				return NULL;
  801752:	b8 00 00 00 00       	mov    $0x0,%eax
  801757:	eb 05                	jmp    80175e <sget+0x90>
			}
		}
	}
  return NULL;
  801759:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801766:	e8 63 fb ff ff       	call   8012ce <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80176b:	83 ec 04             	sub    $0x4,%esp
  80176e:	68 e4 38 80 00       	push   $0x8038e4
  801773:	68 0e 01 00 00       	push   $0x10e
  801778:	68 b3 38 80 00       	push   $0x8038b3
  80177d:	e8 0e eb ff ff       	call   800290 <_panic>

00801782 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801788:	83 ec 04             	sub    $0x4,%esp
  80178b:	68 0c 39 80 00       	push   $0x80390c
  801790:	68 22 01 00 00       	push   $0x122
  801795:	68 b3 38 80 00       	push   $0x8038b3
  80179a:	e8 f1 ea ff ff       	call   800290 <_panic>

0080179f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
  8017a2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017a5:	83 ec 04             	sub    $0x4,%esp
  8017a8:	68 30 39 80 00       	push   $0x803930
  8017ad:	68 2d 01 00 00       	push   $0x12d
  8017b2:	68 b3 38 80 00       	push   $0x8038b3
  8017b7:	e8 d4 ea ff ff       	call   800290 <_panic>

008017bc <shrink>:

}
void shrink(uint32 newSize)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
  8017bf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c2:	83 ec 04             	sub    $0x4,%esp
  8017c5:	68 30 39 80 00       	push   $0x803930
  8017ca:	68 32 01 00 00       	push   $0x132
  8017cf:	68 b3 38 80 00       	push   $0x8038b3
  8017d4:	e8 b7 ea ff ff       	call   800290 <_panic>

008017d9 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
  8017dc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017df:	83 ec 04             	sub    $0x4,%esp
  8017e2:	68 30 39 80 00       	push   $0x803930
  8017e7:	68 37 01 00 00       	push   $0x137
  8017ec:	68 b3 38 80 00       	push   $0x8038b3
  8017f1:	e8 9a ea ff ff       	call   800290 <_panic>

008017f6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	57                   	push   %edi
  8017fa:	56                   	push   %esi
  8017fb:	53                   	push   %ebx
  8017fc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801802:	8b 55 0c             	mov    0xc(%ebp),%edx
  801805:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801808:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80180b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80180e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801811:	cd 30                	int    $0x30
  801813:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801816:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801819:	83 c4 10             	add    $0x10,%esp
  80181c:	5b                   	pop    %ebx
  80181d:	5e                   	pop    %esi
  80181e:	5f                   	pop    %edi
  80181f:	5d                   	pop    %ebp
  801820:	c3                   	ret    

00801821 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	83 ec 04             	sub    $0x4,%esp
  801827:	8b 45 10             	mov    0x10(%ebp),%eax
  80182a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80182d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801831:	8b 45 08             	mov    0x8(%ebp),%eax
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	52                   	push   %edx
  801839:	ff 75 0c             	pushl  0xc(%ebp)
  80183c:	50                   	push   %eax
  80183d:	6a 00                	push   $0x0
  80183f:	e8 b2 ff ff ff       	call   8017f6 <syscall>
  801844:	83 c4 18             	add    $0x18,%esp
}
  801847:	90                   	nop
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <sys_cgetc>:

int
sys_cgetc(void)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 01                	push   $0x1
  801859:	e8 98 ff ff ff       	call   8017f6 <syscall>
  80185e:	83 c4 18             	add    $0x18,%esp
}
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801866:	8b 55 0c             	mov    0xc(%ebp),%edx
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	52                   	push   %edx
  801873:	50                   	push   %eax
  801874:	6a 05                	push   $0x5
  801876:	e8 7b ff ff ff       	call   8017f6 <syscall>
  80187b:	83 c4 18             	add    $0x18,%esp
}
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	56                   	push   %esi
  801884:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801885:	8b 75 18             	mov    0x18(%ebp),%esi
  801888:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80188b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80188e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801891:	8b 45 08             	mov    0x8(%ebp),%eax
  801894:	56                   	push   %esi
  801895:	53                   	push   %ebx
  801896:	51                   	push   %ecx
  801897:	52                   	push   %edx
  801898:	50                   	push   %eax
  801899:	6a 06                	push   $0x6
  80189b:	e8 56 ff ff ff       	call   8017f6 <syscall>
  8018a0:	83 c4 18             	add    $0x18,%esp
}
  8018a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a6:	5b                   	pop    %ebx
  8018a7:	5e                   	pop    %esi
  8018a8:	5d                   	pop    %ebp
  8018a9:	c3                   	ret    

008018aa <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	52                   	push   %edx
  8018ba:	50                   	push   %eax
  8018bb:	6a 07                	push   $0x7
  8018bd:	e8 34 ff ff ff       	call   8017f6 <syscall>
  8018c2:	83 c4 18             	add    $0x18,%esp
}
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	ff 75 0c             	pushl  0xc(%ebp)
  8018d3:	ff 75 08             	pushl  0x8(%ebp)
  8018d6:	6a 08                	push   $0x8
  8018d8:	e8 19 ff ff ff       	call   8017f6 <syscall>
  8018dd:	83 c4 18             	add    $0x18,%esp
}
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 09                	push   $0x9
  8018f1:	e8 00 ff ff ff       	call   8017f6 <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 0a                	push   $0xa
  80190a:	e8 e7 fe ff ff       	call   8017f6 <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 0b                	push   $0xb
  801923:	e8 ce fe ff ff       	call   8017f6 <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
}
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	ff 75 0c             	pushl  0xc(%ebp)
  801939:	ff 75 08             	pushl  0x8(%ebp)
  80193c:	6a 0f                	push   $0xf
  80193e:	e8 b3 fe ff ff       	call   8017f6 <syscall>
  801943:	83 c4 18             	add    $0x18,%esp
	return;
  801946:	90                   	nop
}
  801947:	c9                   	leave  
  801948:	c3                   	ret    

00801949 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	ff 75 0c             	pushl  0xc(%ebp)
  801955:	ff 75 08             	pushl  0x8(%ebp)
  801958:	6a 10                	push   $0x10
  80195a:	e8 97 fe ff ff       	call   8017f6 <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
	return ;
  801962:	90                   	nop
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	ff 75 10             	pushl  0x10(%ebp)
  80196f:	ff 75 0c             	pushl  0xc(%ebp)
  801972:	ff 75 08             	pushl  0x8(%ebp)
  801975:	6a 11                	push   $0x11
  801977:	e8 7a fe ff ff       	call   8017f6 <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
	return ;
  80197f:	90                   	nop
}
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 0c                	push   $0xc
  801991:	e8 60 fe ff ff       	call   8017f6 <syscall>
  801996:	83 c4 18             	add    $0x18,%esp
}
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	ff 75 08             	pushl  0x8(%ebp)
  8019a9:	6a 0d                	push   $0xd
  8019ab:	e8 46 fe ff ff       	call   8017f6 <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 0e                	push   $0xe
  8019c4:	e8 2d fe ff ff       	call   8017f6 <syscall>
  8019c9:	83 c4 18             	add    $0x18,%esp
}
  8019cc:	90                   	nop
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 13                	push   $0x13
  8019de:	e8 13 fe ff ff       	call   8017f6 <syscall>
  8019e3:	83 c4 18             	add    $0x18,%esp
}
  8019e6:	90                   	nop
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 14                	push   $0x14
  8019f8:	e8 f9 fd ff ff       	call   8017f6 <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	90                   	nop
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
  801a06:	83 ec 04             	sub    $0x4,%esp
  801a09:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a0f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	50                   	push   %eax
  801a1c:	6a 15                	push   $0x15
  801a1e:	e8 d3 fd ff ff       	call   8017f6 <syscall>
  801a23:	83 c4 18             	add    $0x18,%esp
}
  801a26:	90                   	nop
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 16                	push   $0x16
  801a38:	e8 b9 fd ff ff       	call   8017f6 <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
}
  801a40:	90                   	nop
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	ff 75 0c             	pushl  0xc(%ebp)
  801a52:	50                   	push   %eax
  801a53:	6a 17                	push   $0x17
  801a55:	e8 9c fd ff ff       	call   8017f6 <syscall>
  801a5a:	83 c4 18             	add    $0x18,%esp
}
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a65:	8b 45 08             	mov    0x8(%ebp),%eax
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	52                   	push   %edx
  801a6f:	50                   	push   %eax
  801a70:	6a 1a                	push   $0x1a
  801a72:	e8 7f fd ff ff       	call   8017f6 <syscall>
  801a77:	83 c4 18             	add    $0x18,%esp
}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a82:	8b 45 08             	mov    0x8(%ebp),%eax
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	52                   	push   %edx
  801a8c:	50                   	push   %eax
  801a8d:	6a 18                	push   $0x18
  801a8f:	e8 62 fd ff ff       	call   8017f6 <syscall>
  801a94:	83 c4 18             	add    $0x18,%esp
}
  801a97:	90                   	nop
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	52                   	push   %edx
  801aaa:	50                   	push   %eax
  801aab:	6a 19                	push   $0x19
  801aad:	e8 44 fd ff ff       	call   8017f6 <syscall>
  801ab2:	83 c4 18             	add    $0x18,%esp
}
  801ab5:	90                   	nop
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
  801abb:	83 ec 04             	sub    $0x4,%esp
  801abe:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ac4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ac7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801acb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ace:	6a 00                	push   $0x0
  801ad0:	51                   	push   %ecx
  801ad1:	52                   	push   %edx
  801ad2:	ff 75 0c             	pushl  0xc(%ebp)
  801ad5:	50                   	push   %eax
  801ad6:	6a 1b                	push   $0x1b
  801ad8:	e8 19 fd ff ff       	call   8017f6 <syscall>
  801add:	83 c4 18             	add    $0x18,%esp
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ae5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	52                   	push   %edx
  801af2:	50                   	push   %eax
  801af3:	6a 1c                	push   $0x1c
  801af5:	e8 fc fc ff ff       	call   8017f6 <syscall>
  801afa:	83 c4 18             	add    $0x18,%esp
}
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b02:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b08:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	51                   	push   %ecx
  801b10:	52                   	push   %edx
  801b11:	50                   	push   %eax
  801b12:	6a 1d                	push   $0x1d
  801b14:	e8 dd fc ff ff       	call   8017f6 <syscall>
  801b19:	83 c4 18             	add    $0x18,%esp
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b24:	8b 45 08             	mov    0x8(%ebp),%eax
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	52                   	push   %edx
  801b2e:	50                   	push   %eax
  801b2f:	6a 1e                	push   $0x1e
  801b31:	e8 c0 fc ff ff       	call   8017f6 <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 1f                	push   $0x1f
  801b4a:	e8 a7 fc ff ff       	call   8017f6 <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b57:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5a:	6a 00                	push   $0x0
  801b5c:	ff 75 14             	pushl  0x14(%ebp)
  801b5f:	ff 75 10             	pushl  0x10(%ebp)
  801b62:	ff 75 0c             	pushl  0xc(%ebp)
  801b65:	50                   	push   %eax
  801b66:	6a 20                	push   $0x20
  801b68:	e8 89 fc ff ff       	call   8017f6 <syscall>
  801b6d:	83 c4 18             	add    $0x18,%esp
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b75:	8b 45 08             	mov    0x8(%ebp),%eax
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	50                   	push   %eax
  801b81:	6a 21                	push   $0x21
  801b83:	e8 6e fc ff ff       	call   8017f6 <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
}
  801b8b:	90                   	nop
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	50                   	push   %eax
  801b9d:	6a 22                	push   $0x22
  801b9f:	e8 52 fc ff ff       	call   8017f6 <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 02                	push   $0x2
  801bb8:	e8 39 fc ff ff       	call   8017f6 <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
}
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 03                	push   $0x3
  801bd1:	e8 20 fc ff ff       	call   8017f6 <syscall>
  801bd6:	83 c4 18             	add    $0x18,%esp
}
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 04                	push   $0x4
  801bea:	e8 07 fc ff ff       	call   8017f6 <syscall>
  801bef:	83 c4 18             	add    $0x18,%esp
}
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <sys_exit_env>:


void sys_exit_env(void)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 23                	push   $0x23
  801c03:	e8 ee fb ff ff       	call   8017f6 <syscall>
  801c08:	83 c4 18             	add    $0x18,%esp
}
  801c0b:	90                   	nop
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    

00801c0e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c14:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c17:	8d 50 04             	lea    0x4(%eax),%edx
  801c1a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	52                   	push   %edx
  801c24:	50                   	push   %eax
  801c25:	6a 24                	push   $0x24
  801c27:	e8 ca fb ff ff       	call   8017f6 <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
	return result;
  801c2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c32:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c35:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c38:	89 01                	mov    %eax,(%ecx)
  801c3a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	c9                   	leave  
  801c41:	c2 04 00             	ret    $0x4

00801c44 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	ff 75 10             	pushl  0x10(%ebp)
  801c4e:	ff 75 0c             	pushl  0xc(%ebp)
  801c51:	ff 75 08             	pushl  0x8(%ebp)
  801c54:	6a 12                	push   $0x12
  801c56:	e8 9b fb ff ff       	call   8017f6 <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5e:	90                   	nop
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 25                	push   $0x25
  801c70:	e8 81 fb ff ff       	call   8017f6 <syscall>
  801c75:	83 c4 18             	add    $0x18,%esp
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	83 ec 04             	sub    $0x4,%esp
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c86:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	50                   	push   %eax
  801c93:	6a 26                	push   $0x26
  801c95:	e8 5c fb ff ff       	call   8017f6 <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9d:	90                   	nop
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <rsttst>:
void rsttst()
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 28                	push   $0x28
  801caf:	e8 42 fb ff ff       	call   8017f6 <syscall>
  801cb4:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb7:	90                   	nop
}
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	83 ec 04             	sub    $0x4,%esp
  801cc0:	8b 45 14             	mov    0x14(%ebp),%eax
  801cc3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cc6:	8b 55 18             	mov    0x18(%ebp),%edx
  801cc9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ccd:	52                   	push   %edx
  801cce:	50                   	push   %eax
  801ccf:	ff 75 10             	pushl  0x10(%ebp)
  801cd2:	ff 75 0c             	pushl  0xc(%ebp)
  801cd5:	ff 75 08             	pushl  0x8(%ebp)
  801cd8:	6a 27                	push   $0x27
  801cda:	e8 17 fb ff ff       	call   8017f6 <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce2:	90                   	nop
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <chktst>:
void chktst(uint32 n)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	ff 75 08             	pushl  0x8(%ebp)
  801cf3:	6a 29                	push   $0x29
  801cf5:	e8 fc fa ff ff       	call   8017f6 <syscall>
  801cfa:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfd:	90                   	nop
}
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    

00801d00 <inctst>:

void inctst()
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 2a                	push   $0x2a
  801d0f:	e8 e2 fa ff ff       	call   8017f6 <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
	return ;
  801d17:	90                   	nop
}
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <gettst>:
uint32 gettst()
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 2b                	push   $0x2b
  801d29:	e8 c8 fa ff ff       	call   8017f6 <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
}
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 2c                	push   $0x2c
  801d45:	e8 ac fa ff ff       	call   8017f6 <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
  801d4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d50:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d54:	75 07                	jne    801d5d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d56:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5b:	eb 05                	jmp    801d62 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
  801d67:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 2c                	push   $0x2c
  801d76:	e8 7b fa ff ff       	call   8017f6 <syscall>
  801d7b:	83 c4 18             	add    $0x18,%esp
  801d7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d81:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d85:	75 07                	jne    801d8e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d87:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8c:	eb 05                	jmp    801d93 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 2c                	push   $0x2c
  801da7:	e8 4a fa ff ff       	call   8017f6 <syscall>
  801dac:	83 c4 18             	add    $0x18,%esp
  801daf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801db2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801db6:	75 07                	jne    801dbf <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801db8:	b8 01 00 00 00       	mov    $0x1,%eax
  801dbd:	eb 05                	jmp    801dc4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc4:	c9                   	leave  
  801dc5:	c3                   	ret    

00801dc6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
  801dc9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 2c                	push   $0x2c
  801dd8:	e8 19 fa ff ff       	call   8017f6 <syscall>
  801ddd:	83 c4 18             	add    $0x18,%esp
  801de0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801de3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801de7:	75 07                	jne    801df0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801de9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dee:	eb 05                	jmp    801df5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801df0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	ff 75 08             	pushl  0x8(%ebp)
  801e05:	6a 2d                	push   $0x2d
  801e07:	e8 ea f9 ff ff       	call   8017f6 <syscall>
  801e0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0f:	90                   	nop
}
  801e10:	c9                   	leave  
  801e11:	c3                   	ret    

00801e12 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e16:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e19:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e22:	6a 00                	push   $0x0
  801e24:	53                   	push   %ebx
  801e25:	51                   	push   %ecx
  801e26:	52                   	push   %edx
  801e27:	50                   	push   %eax
  801e28:	6a 2e                	push   $0x2e
  801e2a:	e8 c7 f9 ff ff       	call   8017f6 <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
}
  801e32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e35:	c9                   	leave  
  801e36:	c3                   	ret    

00801e37 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	52                   	push   %edx
  801e47:	50                   	push   %eax
  801e48:	6a 2f                	push   $0x2f
  801e4a:	e8 a7 f9 ff ff       	call   8017f6 <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e5a:	83 ec 0c             	sub    $0xc,%esp
  801e5d:	68 40 39 80 00       	push   $0x803940
  801e62:	e8 dd e6 ff ff       	call   800544 <cprintf>
  801e67:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e6a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e71:	83 ec 0c             	sub    $0xc,%esp
  801e74:	68 6c 39 80 00       	push   $0x80396c
  801e79:	e8 c6 e6 ff ff       	call   800544 <cprintf>
  801e7e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e81:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e85:	a1 38 41 80 00       	mov    0x804138,%eax
  801e8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e8d:	eb 56                	jmp    801ee5 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e8f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e93:	74 1c                	je     801eb1 <print_mem_block_lists+0x5d>
  801e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e98:	8b 50 08             	mov    0x8(%eax),%edx
  801e9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e9e:	8b 48 08             	mov    0x8(%eax),%ecx
  801ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea4:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea7:	01 c8                	add    %ecx,%eax
  801ea9:	39 c2                	cmp    %eax,%edx
  801eab:	73 04                	jae    801eb1 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ead:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb4:	8b 50 08             	mov    0x8(%eax),%edx
  801eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eba:	8b 40 0c             	mov    0xc(%eax),%eax
  801ebd:	01 c2                	add    %eax,%edx
  801ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec2:	8b 40 08             	mov    0x8(%eax),%eax
  801ec5:	83 ec 04             	sub    $0x4,%esp
  801ec8:	52                   	push   %edx
  801ec9:	50                   	push   %eax
  801eca:	68 81 39 80 00       	push   $0x803981
  801ecf:	e8 70 e6 ff ff       	call   800544 <cprintf>
  801ed4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eda:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801edd:	a1 40 41 80 00       	mov    0x804140,%eax
  801ee2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ee9:	74 07                	je     801ef2 <print_mem_block_lists+0x9e>
  801eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eee:	8b 00                	mov    (%eax),%eax
  801ef0:	eb 05                	jmp    801ef7 <print_mem_block_lists+0xa3>
  801ef2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef7:	a3 40 41 80 00       	mov    %eax,0x804140
  801efc:	a1 40 41 80 00       	mov    0x804140,%eax
  801f01:	85 c0                	test   %eax,%eax
  801f03:	75 8a                	jne    801e8f <print_mem_block_lists+0x3b>
  801f05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f09:	75 84                	jne    801e8f <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f0b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f0f:	75 10                	jne    801f21 <print_mem_block_lists+0xcd>
  801f11:	83 ec 0c             	sub    $0xc,%esp
  801f14:	68 90 39 80 00       	push   $0x803990
  801f19:	e8 26 e6 ff ff       	call   800544 <cprintf>
  801f1e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f21:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f28:	83 ec 0c             	sub    $0xc,%esp
  801f2b:	68 b4 39 80 00       	push   $0x8039b4
  801f30:	e8 0f e6 ff ff       	call   800544 <cprintf>
  801f35:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f38:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f3c:	a1 40 40 80 00       	mov    0x804040,%eax
  801f41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f44:	eb 56                	jmp    801f9c <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f4a:	74 1c                	je     801f68 <print_mem_block_lists+0x114>
  801f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4f:	8b 50 08             	mov    0x8(%eax),%edx
  801f52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f55:	8b 48 08             	mov    0x8(%eax),%ecx
  801f58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5b:	8b 40 0c             	mov    0xc(%eax),%eax
  801f5e:	01 c8                	add    %ecx,%eax
  801f60:	39 c2                	cmp    %eax,%edx
  801f62:	73 04                	jae    801f68 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f64:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6b:	8b 50 08             	mov    0x8(%eax),%edx
  801f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f71:	8b 40 0c             	mov    0xc(%eax),%eax
  801f74:	01 c2                	add    %eax,%edx
  801f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f79:	8b 40 08             	mov    0x8(%eax),%eax
  801f7c:	83 ec 04             	sub    $0x4,%esp
  801f7f:	52                   	push   %edx
  801f80:	50                   	push   %eax
  801f81:	68 81 39 80 00       	push   $0x803981
  801f86:	e8 b9 e5 ff ff       	call   800544 <cprintf>
  801f8b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f91:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f94:	a1 48 40 80 00       	mov    0x804048,%eax
  801f99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa0:	74 07                	je     801fa9 <print_mem_block_lists+0x155>
  801fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa5:	8b 00                	mov    (%eax),%eax
  801fa7:	eb 05                	jmp    801fae <print_mem_block_lists+0x15a>
  801fa9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fae:	a3 48 40 80 00       	mov    %eax,0x804048
  801fb3:	a1 48 40 80 00       	mov    0x804048,%eax
  801fb8:	85 c0                	test   %eax,%eax
  801fba:	75 8a                	jne    801f46 <print_mem_block_lists+0xf2>
  801fbc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc0:	75 84                	jne    801f46 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fc2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fc6:	75 10                	jne    801fd8 <print_mem_block_lists+0x184>
  801fc8:	83 ec 0c             	sub    $0xc,%esp
  801fcb:	68 cc 39 80 00       	push   $0x8039cc
  801fd0:	e8 6f e5 ff ff       	call   800544 <cprintf>
  801fd5:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fd8:	83 ec 0c             	sub    $0xc,%esp
  801fdb:	68 40 39 80 00       	push   $0x803940
  801fe0:	e8 5f e5 ff ff       	call   800544 <cprintf>
  801fe5:	83 c4 10             	add    $0x10,%esp

}
  801fe8:	90                   	nop
  801fe9:	c9                   	leave  
  801fea:	c3                   	ret    

00801feb <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
  801fee:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  801ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff4:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  801ff7:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801ffe:	00 00 00 
  802001:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802008:	00 00 00 
  80200b:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802012:	00 00 00 
	for(int i = 0; i<n;i++)
  802015:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80201c:	e9 9e 00 00 00       	jmp    8020bf <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802021:	a1 50 40 80 00       	mov    0x804050,%eax
  802026:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802029:	c1 e2 04             	shl    $0x4,%edx
  80202c:	01 d0                	add    %edx,%eax
  80202e:	85 c0                	test   %eax,%eax
  802030:	75 14                	jne    802046 <initialize_MemBlocksList+0x5b>
  802032:	83 ec 04             	sub    $0x4,%esp
  802035:	68 f4 39 80 00       	push   $0x8039f4
  80203a:	6a 47                	push   $0x47
  80203c:	68 17 3a 80 00       	push   $0x803a17
  802041:	e8 4a e2 ff ff       	call   800290 <_panic>
  802046:	a1 50 40 80 00       	mov    0x804050,%eax
  80204b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204e:	c1 e2 04             	shl    $0x4,%edx
  802051:	01 d0                	add    %edx,%eax
  802053:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802059:	89 10                	mov    %edx,(%eax)
  80205b:	8b 00                	mov    (%eax),%eax
  80205d:	85 c0                	test   %eax,%eax
  80205f:	74 18                	je     802079 <initialize_MemBlocksList+0x8e>
  802061:	a1 48 41 80 00       	mov    0x804148,%eax
  802066:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80206c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80206f:	c1 e1 04             	shl    $0x4,%ecx
  802072:	01 ca                	add    %ecx,%edx
  802074:	89 50 04             	mov    %edx,0x4(%eax)
  802077:	eb 12                	jmp    80208b <initialize_MemBlocksList+0xa0>
  802079:	a1 50 40 80 00       	mov    0x804050,%eax
  80207e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802081:	c1 e2 04             	shl    $0x4,%edx
  802084:	01 d0                	add    %edx,%eax
  802086:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80208b:	a1 50 40 80 00       	mov    0x804050,%eax
  802090:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802093:	c1 e2 04             	shl    $0x4,%edx
  802096:	01 d0                	add    %edx,%eax
  802098:	a3 48 41 80 00       	mov    %eax,0x804148
  80209d:	a1 50 40 80 00       	mov    0x804050,%eax
  8020a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a5:	c1 e2 04             	shl    $0x4,%edx
  8020a8:	01 d0                	add    %edx,%eax
  8020aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020b1:	a1 54 41 80 00       	mov    0x804154,%eax
  8020b6:	40                   	inc    %eax
  8020b7:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8020bc:	ff 45 f4             	incl   -0xc(%ebp)
  8020bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8020c5:	0f 82 56 ff ff ff    	jb     802021 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8020cb:	90                   	nop
  8020cc:	c9                   	leave  
  8020cd:	c3                   	ret    

008020ce <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020ce:	55                   	push   %ebp
  8020cf:	89 e5                	mov    %esp,%ebp
  8020d1:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  8020d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  8020da:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8020e1:	a1 40 40 80 00       	mov    0x804040,%eax
  8020e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020e9:	eb 23                	jmp    80210e <find_block+0x40>
	{
		if(blk->sva == virAddress)
  8020eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ee:	8b 40 08             	mov    0x8(%eax),%eax
  8020f1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8020f4:	75 09                	jne    8020ff <find_block+0x31>
		{
			found = 1;
  8020f6:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  8020fd:	eb 35                	jmp    802134 <find_block+0x66>
		}
		else
		{
			found = 0;
  8020ff:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802106:	a1 48 40 80 00       	mov    0x804048,%eax
  80210b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80210e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802112:	74 07                	je     80211b <find_block+0x4d>
  802114:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802117:	8b 00                	mov    (%eax),%eax
  802119:	eb 05                	jmp    802120 <find_block+0x52>
  80211b:	b8 00 00 00 00       	mov    $0x0,%eax
  802120:	a3 48 40 80 00       	mov    %eax,0x804048
  802125:	a1 48 40 80 00       	mov    0x804048,%eax
  80212a:	85 c0                	test   %eax,%eax
  80212c:	75 bd                	jne    8020eb <find_block+0x1d>
  80212e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802132:	75 b7                	jne    8020eb <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802134:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802138:	75 05                	jne    80213f <find_block+0x71>
	{
		return blk;
  80213a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80213d:	eb 05                	jmp    802144 <find_block+0x76>
	}
	else
	{
		return NULL;
  80213f:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802144:	c9                   	leave  
  802145:	c3                   	ret    

00802146 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
  802149:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
  80214f:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802152:	a1 40 40 80 00       	mov    0x804040,%eax
  802157:	85 c0                	test   %eax,%eax
  802159:	74 12                	je     80216d <insert_sorted_allocList+0x27>
  80215b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215e:	8b 50 08             	mov    0x8(%eax),%edx
  802161:	a1 40 40 80 00       	mov    0x804040,%eax
  802166:	8b 40 08             	mov    0x8(%eax),%eax
  802169:	39 c2                	cmp    %eax,%edx
  80216b:	73 65                	jae    8021d2 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  80216d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802171:	75 14                	jne    802187 <insert_sorted_allocList+0x41>
  802173:	83 ec 04             	sub    $0x4,%esp
  802176:	68 f4 39 80 00       	push   $0x8039f4
  80217b:	6a 7b                	push   $0x7b
  80217d:	68 17 3a 80 00       	push   $0x803a17
  802182:	e8 09 e1 ff ff       	call   800290 <_panic>
  802187:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80218d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802190:	89 10                	mov    %edx,(%eax)
  802192:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802195:	8b 00                	mov    (%eax),%eax
  802197:	85 c0                	test   %eax,%eax
  802199:	74 0d                	je     8021a8 <insert_sorted_allocList+0x62>
  80219b:	a1 40 40 80 00       	mov    0x804040,%eax
  8021a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021a3:	89 50 04             	mov    %edx,0x4(%eax)
  8021a6:	eb 08                	jmp    8021b0 <insert_sorted_allocList+0x6a>
  8021a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ab:	a3 44 40 80 00       	mov    %eax,0x804044
  8021b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b3:	a3 40 40 80 00       	mov    %eax,0x804040
  8021b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021c2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021c7:	40                   	inc    %eax
  8021c8:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8021cd:	e9 5f 01 00 00       	jmp    802331 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8021d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d5:	8b 50 08             	mov    0x8(%eax),%edx
  8021d8:	a1 44 40 80 00       	mov    0x804044,%eax
  8021dd:	8b 40 08             	mov    0x8(%eax),%eax
  8021e0:	39 c2                	cmp    %eax,%edx
  8021e2:	76 65                	jbe    802249 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  8021e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021e8:	75 14                	jne    8021fe <insert_sorted_allocList+0xb8>
  8021ea:	83 ec 04             	sub    $0x4,%esp
  8021ed:	68 30 3a 80 00       	push   $0x803a30
  8021f2:	6a 7f                	push   $0x7f
  8021f4:	68 17 3a 80 00       	push   $0x803a17
  8021f9:	e8 92 e0 ff ff       	call   800290 <_panic>
  8021fe:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802204:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802207:	89 50 04             	mov    %edx,0x4(%eax)
  80220a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220d:	8b 40 04             	mov    0x4(%eax),%eax
  802210:	85 c0                	test   %eax,%eax
  802212:	74 0c                	je     802220 <insert_sorted_allocList+0xda>
  802214:	a1 44 40 80 00       	mov    0x804044,%eax
  802219:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80221c:	89 10                	mov    %edx,(%eax)
  80221e:	eb 08                	jmp    802228 <insert_sorted_allocList+0xe2>
  802220:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802223:	a3 40 40 80 00       	mov    %eax,0x804040
  802228:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222b:	a3 44 40 80 00       	mov    %eax,0x804044
  802230:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802233:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802239:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80223e:	40                   	inc    %eax
  80223f:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802244:	e9 e8 00 00 00       	jmp    802331 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802249:	a1 40 40 80 00       	mov    0x804040,%eax
  80224e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802251:	e9 ab 00 00 00       	jmp    802301 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802259:	8b 00                	mov    (%eax),%eax
  80225b:	85 c0                	test   %eax,%eax
  80225d:	0f 84 96 00 00 00    	je     8022f9 <insert_sorted_allocList+0x1b3>
  802263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802266:	8b 50 08             	mov    0x8(%eax),%edx
  802269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226c:	8b 40 08             	mov    0x8(%eax),%eax
  80226f:	39 c2                	cmp    %eax,%edx
  802271:	0f 86 82 00 00 00    	jbe    8022f9 <insert_sorted_allocList+0x1b3>
  802277:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227a:	8b 50 08             	mov    0x8(%eax),%edx
  80227d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802280:	8b 00                	mov    (%eax),%eax
  802282:	8b 40 08             	mov    0x8(%eax),%eax
  802285:	39 c2                	cmp    %eax,%edx
  802287:	73 70                	jae    8022f9 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802289:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80228d:	74 06                	je     802295 <insert_sorted_allocList+0x14f>
  80228f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802293:	75 17                	jne    8022ac <insert_sorted_allocList+0x166>
  802295:	83 ec 04             	sub    $0x4,%esp
  802298:	68 54 3a 80 00       	push   $0x803a54
  80229d:	68 87 00 00 00       	push   $0x87
  8022a2:	68 17 3a 80 00       	push   $0x803a17
  8022a7:	e8 e4 df ff ff       	call   800290 <_panic>
  8022ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022af:	8b 10                	mov    (%eax),%edx
  8022b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b4:	89 10                	mov    %edx,(%eax)
  8022b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b9:	8b 00                	mov    (%eax),%eax
  8022bb:	85 c0                	test   %eax,%eax
  8022bd:	74 0b                	je     8022ca <insert_sorted_allocList+0x184>
  8022bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c2:	8b 00                	mov    (%eax),%eax
  8022c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022c7:	89 50 04             	mov    %edx,0x4(%eax)
  8022ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022d0:	89 10                	mov    %edx,(%eax)
  8022d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d8:	89 50 04             	mov    %edx,0x4(%eax)
  8022db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022de:	8b 00                	mov    (%eax),%eax
  8022e0:	85 c0                	test   %eax,%eax
  8022e2:	75 08                	jne    8022ec <insert_sorted_allocList+0x1a6>
  8022e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e7:	a3 44 40 80 00       	mov    %eax,0x804044
  8022ec:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022f1:	40                   	inc    %eax
  8022f2:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8022f7:	eb 38                	jmp    802331 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8022f9:	a1 48 40 80 00       	mov    0x804048,%eax
  8022fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802301:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802305:	74 07                	je     80230e <insert_sorted_allocList+0x1c8>
  802307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230a:	8b 00                	mov    (%eax),%eax
  80230c:	eb 05                	jmp    802313 <insert_sorted_allocList+0x1cd>
  80230e:	b8 00 00 00 00       	mov    $0x0,%eax
  802313:	a3 48 40 80 00       	mov    %eax,0x804048
  802318:	a1 48 40 80 00       	mov    0x804048,%eax
  80231d:	85 c0                	test   %eax,%eax
  80231f:	0f 85 31 ff ff ff    	jne    802256 <insert_sorted_allocList+0x110>
  802325:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802329:	0f 85 27 ff ff ff    	jne    802256 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80232f:	eb 00                	jmp    802331 <insert_sorted_allocList+0x1eb>
  802331:	90                   	nop
  802332:	c9                   	leave  
  802333:	c3                   	ret    

00802334 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802334:	55                   	push   %ebp
  802335:	89 e5                	mov    %esp,%ebp
  802337:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802340:	a1 48 41 80 00       	mov    0x804148,%eax
  802345:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802348:	a1 38 41 80 00       	mov    0x804138,%eax
  80234d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802350:	e9 77 01 00 00       	jmp    8024cc <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802358:	8b 40 0c             	mov    0xc(%eax),%eax
  80235b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80235e:	0f 85 8a 00 00 00    	jne    8023ee <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802364:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802368:	75 17                	jne    802381 <alloc_block_FF+0x4d>
  80236a:	83 ec 04             	sub    $0x4,%esp
  80236d:	68 88 3a 80 00       	push   $0x803a88
  802372:	68 9e 00 00 00       	push   $0x9e
  802377:	68 17 3a 80 00       	push   $0x803a17
  80237c:	e8 0f df ff ff       	call   800290 <_panic>
  802381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802384:	8b 00                	mov    (%eax),%eax
  802386:	85 c0                	test   %eax,%eax
  802388:	74 10                	je     80239a <alloc_block_FF+0x66>
  80238a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238d:	8b 00                	mov    (%eax),%eax
  80238f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802392:	8b 52 04             	mov    0x4(%edx),%edx
  802395:	89 50 04             	mov    %edx,0x4(%eax)
  802398:	eb 0b                	jmp    8023a5 <alloc_block_FF+0x71>
  80239a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239d:	8b 40 04             	mov    0x4(%eax),%eax
  8023a0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a8:	8b 40 04             	mov    0x4(%eax),%eax
  8023ab:	85 c0                	test   %eax,%eax
  8023ad:	74 0f                	je     8023be <alloc_block_FF+0x8a>
  8023af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b2:	8b 40 04             	mov    0x4(%eax),%eax
  8023b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b8:	8b 12                	mov    (%edx),%edx
  8023ba:	89 10                	mov    %edx,(%eax)
  8023bc:	eb 0a                	jmp    8023c8 <alloc_block_FF+0x94>
  8023be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c1:	8b 00                	mov    (%eax),%eax
  8023c3:	a3 38 41 80 00       	mov    %eax,0x804138
  8023c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023db:	a1 44 41 80 00       	mov    0x804144,%eax
  8023e0:	48                   	dec    %eax
  8023e1:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8023e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e9:	e9 11 01 00 00       	jmp    8024ff <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  8023ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8023f7:	0f 86 c7 00 00 00    	jbe    8024c4 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8023fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802401:	75 17                	jne    80241a <alloc_block_FF+0xe6>
  802403:	83 ec 04             	sub    $0x4,%esp
  802406:	68 88 3a 80 00       	push   $0x803a88
  80240b:	68 a3 00 00 00       	push   $0xa3
  802410:	68 17 3a 80 00       	push   $0x803a17
  802415:	e8 76 de ff ff       	call   800290 <_panic>
  80241a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80241d:	8b 00                	mov    (%eax),%eax
  80241f:	85 c0                	test   %eax,%eax
  802421:	74 10                	je     802433 <alloc_block_FF+0xff>
  802423:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802426:	8b 00                	mov    (%eax),%eax
  802428:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80242b:	8b 52 04             	mov    0x4(%edx),%edx
  80242e:	89 50 04             	mov    %edx,0x4(%eax)
  802431:	eb 0b                	jmp    80243e <alloc_block_FF+0x10a>
  802433:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802436:	8b 40 04             	mov    0x4(%eax),%eax
  802439:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80243e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802441:	8b 40 04             	mov    0x4(%eax),%eax
  802444:	85 c0                	test   %eax,%eax
  802446:	74 0f                	je     802457 <alloc_block_FF+0x123>
  802448:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80244b:	8b 40 04             	mov    0x4(%eax),%eax
  80244e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802451:	8b 12                	mov    (%edx),%edx
  802453:	89 10                	mov    %edx,(%eax)
  802455:	eb 0a                	jmp    802461 <alloc_block_FF+0x12d>
  802457:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80245a:	8b 00                	mov    (%eax),%eax
  80245c:	a3 48 41 80 00       	mov    %eax,0x804148
  802461:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802464:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80246a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80246d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802474:	a1 54 41 80 00       	mov    0x804154,%eax
  802479:	48                   	dec    %eax
  80247a:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  80247f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802482:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802485:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	8b 40 0c             	mov    0xc(%eax),%eax
  80248e:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802491:	89 c2                	mov    %eax,%edx
  802493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802496:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	8b 40 08             	mov    0x8(%eax),%eax
  80249f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8024a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a5:	8b 50 08             	mov    0x8(%eax),%edx
  8024a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ae:	01 c2                	add    %eax,%edx
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8024b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024bc:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8024bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c2:	eb 3b                	jmp    8024ff <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8024c4:	a1 40 41 80 00       	mov    0x804140,%eax
  8024c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d0:	74 07                	je     8024d9 <alloc_block_FF+0x1a5>
  8024d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d5:	8b 00                	mov    (%eax),%eax
  8024d7:	eb 05                	jmp    8024de <alloc_block_FF+0x1aa>
  8024d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024de:	a3 40 41 80 00       	mov    %eax,0x804140
  8024e3:	a1 40 41 80 00       	mov    0x804140,%eax
  8024e8:	85 c0                	test   %eax,%eax
  8024ea:	0f 85 65 fe ff ff    	jne    802355 <alloc_block_FF+0x21>
  8024f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f4:	0f 85 5b fe ff ff    	jne    802355 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8024fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ff:	c9                   	leave  
  802500:	c3                   	ret    

00802501 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802501:	55                   	push   %ebp
  802502:	89 e5                	mov    %esp,%ebp
  802504:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802507:	8b 45 08             	mov    0x8(%ebp),%eax
  80250a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  80250d:	a1 48 41 80 00       	mov    0x804148,%eax
  802512:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802515:	a1 44 41 80 00       	mov    0x804144,%eax
  80251a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  80251d:	a1 38 41 80 00       	mov    0x804138,%eax
  802522:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802525:	e9 a1 00 00 00       	jmp    8025cb <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  80252a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252d:	8b 40 0c             	mov    0xc(%eax),%eax
  802530:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802533:	0f 85 8a 00 00 00    	jne    8025c3 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802539:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253d:	75 17                	jne    802556 <alloc_block_BF+0x55>
  80253f:	83 ec 04             	sub    $0x4,%esp
  802542:	68 88 3a 80 00       	push   $0x803a88
  802547:	68 c2 00 00 00       	push   $0xc2
  80254c:	68 17 3a 80 00       	push   $0x803a17
  802551:	e8 3a dd ff ff       	call   800290 <_panic>
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	8b 00                	mov    (%eax),%eax
  80255b:	85 c0                	test   %eax,%eax
  80255d:	74 10                	je     80256f <alloc_block_BF+0x6e>
  80255f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802562:	8b 00                	mov    (%eax),%eax
  802564:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802567:	8b 52 04             	mov    0x4(%edx),%edx
  80256a:	89 50 04             	mov    %edx,0x4(%eax)
  80256d:	eb 0b                	jmp    80257a <alloc_block_BF+0x79>
  80256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802572:	8b 40 04             	mov    0x4(%eax),%eax
  802575:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	8b 40 04             	mov    0x4(%eax),%eax
  802580:	85 c0                	test   %eax,%eax
  802582:	74 0f                	je     802593 <alloc_block_BF+0x92>
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	8b 40 04             	mov    0x4(%eax),%eax
  80258a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258d:	8b 12                	mov    (%edx),%edx
  80258f:	89 10                	mov    %edx,(%eax)
  802591:	eb 0a                	jmp    80259d <alloc_block_BF+0x9c>
  802593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802596:	8b 00                	mov    (%eax),%eax
  802598:	a3 38 41 80 00       	mov    %eax,0x804138
  80259d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025b0:	a1 44 41 80 00       	mov    0x804144,%eax
  8025b5:	48                   	dec    %eax
  8025b6:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8025bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025be:	e9 11 02 00 00       	jmp    8027d4 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025c3:	a1 40 41 80 00       	mov    0x804140,%eax
  8025c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025cf:	74 07                	je     8025d8 <alloc_block_BF+0xd7>
  8025d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d4:	8b 00                	mov    (%eax),%eax
  8025d6:	eb 05                	jmp    8025dd <alloc_block_BF+0xdc>
  8025d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025dd:	a3 40 41 80 00       	mov    %eax,0x804140
  8025e2:	a1 40 41 80 00       	mov    0x804140,%eax
  8025e7:	85 c0                	test   %eax,%eax
  8025e9:	0f 85 3b ff ff ff    	jne    80252a <alloc_block_BF+0x29>
  8025ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f3:	0f 85 31 ff ff ff    	jne    80252a <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025f9:	a1 38 41 80 00       	mov    0x804138,%eax
  8025fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802601:	eb 27                	jmp    80262a <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802606:	8b 40 0c             	mov    0xc(%eax),%eax
  802609:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80260c:	76 14                	jbe    802622 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  80260e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802611:	8b 40 0c             	mov    0xc(%eax),%eax
  802614:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261a:	8b 40 08             	mov    0x8(%eax),%eax
  80261d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802620:	eb 2e                	jmp    802650 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802622:	a1 40 41 80 00       	mov    0x804140,%eax
  802627:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80262a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262e:	74 07                	je     802637 <alloc_block_BF+0x136>
  802630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802633:	8b 00                	mov    (%eax),%eax
  802635:	eb 05                	jmp    80263c <alloc_block_BF+0x13b>
  802637:	b8 00 00 00 00       	mov    $0x0,%eax
  80263c:	a3 40 41 80 00       	mov    %eax,0x804140
  802641:	a1 40 41 80 00       	mov    0x804140,%eax
  802646:	85 c0                	test   %eax,%eax
  802648:	75 b9                	jne    802603 <alloc_block_BF+0x102>
  80264a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264e:	75 b3                	jne    802603 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802650:	a1 38 41 80 00       	mov    0x804138,%eax
  802655:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802658:	eb 30                	jmp    80268a <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	8b 40 0c             	mov    0xc(%eax),%eax
  802660:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802663:	73 1d                	jae    802682 <alloc_block_BF+0x181>
  802665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802668:	8b 40 0c             	mov    0xc(%eax),%eax
  80266b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80266e:	76 12                	jbe    802682 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	8b 40 0c             	mov    0xc(%eax),%eax
  802676:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267c:	8b 40 08             	mov    0x8(%eax),%eax
  80267f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802682:	a1 40 41 80 00       	mov    0x804140,%eax
  802687:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80268a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80268e:	74 07                	je     802697 <alloc_block_BF+0x196>
  802690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802693:	8b 00                	mov    (%eax),%eax
  802695:	eb 05                	jmp    80269c <alloc_block_BF+0x19b>
  802697:	b8 00 00 00 00       	mov    $0x0,%eax
  80269c:	a3 40 41 80 00       	mov    %eax,0x804140
  8026a1:	a1 40 41 80 00       	mov    0x804140,%eax
  8026a6:	85 c0                	test   %eax,%eax
  8026a8:	75 b0                	jne    80265a <alloc_block_BF+0x159>
  8026aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ae:	75 aa                	jne    80265a <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026b0:	a1 38 41 80 00       	mov    0x804138,%eax
  8026b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b8:	e9 e4 00 00 00       	jmp    8027a1 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8026c6:	0f 85 cd 00 00 00    	jne    802799 <alloc_block_BF+0x298>
  8026cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cf:	8b 40 08             	mov    0x8(%eax),%eax
  8026d2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026d5:	0f 85 be 00 00 00    	jne    802799 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  8026db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026df:	75 17                	jne    8026f8 <alloc_block_BF+0x1f7>
  8026e1:	83 ec 04             	sub    $0x4,%esp
  8026e4:	68 88 3a 80 00       	push   $0x803a88
  8026e9:	68 db 00 00 00       	push   $0xdb
  8026ee:	68 17 3a 80 00       	push   $0x803a17
  8026f3:	e8 98 db ff ff       	call   800290 <_panic>
  8026f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026fb:	8b 00                	mov    (%eax),%eax
  8026fd:	85 c0                	test   %eax,%eax
  8026ff:	74 10                	je     802711 <alloc_block_BF+0x210>
  802701:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802704:	8b 00                	mov    (%eax),%eax
  802706:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802709:	8b 52 04             	mov    0x4(%edx),%edx
  80270c:	89 50 04             	mov    %edx,0x4(%eax)
  80270f:	eb 0b                	jmp    80271c <alloc_block_BF+0x21b>
  802711:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802714:	8b 40 04             	mov    0x4(%eax),%eax
  802717:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80271c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80271f:	8b 40 04             	mov    0x4(%eax),%eax
  802722:	85 c0                	test   %eax,%eax
  802724:	74 0f                	je     802735 <alloc_block_BF+0x234>
  802726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802729:	8b 40 04             	mov    0x4(%eax),%eax
  80272c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80272f:	8b 12                	mov    (%edx),%edx
  802731:	89 10                	mov    %edx,(%eax)
  802733:	eb 0a                	jmp    80273f <alloc_block_BF+0x23e>
  802735:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802738:	8b 00                	mov    (%eax),%eax
  80273a:	a3 48 41 80 00       	mov    %eax,0x804148
  80273f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802742:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80274b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802752:	a1 54 41 80 00       	mov    0x804154,%eax
  802757:	48                   	dec    %eax
  802758:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  80275d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802760:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802763:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802766:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802769:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80276c:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  80276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802772:	8b 40 0c             	mov    0xc(%eax),%eax
  802775:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802778:	89 c2                	mov    %eax,%edx
  80277a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277d:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802783:	8b 50 08             	mov    0x8(%eax),%edx
  802786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802789:	8b 40 0c             	mov    0xc(%eax),%eax
  80278c:	01 c2                	add    %eax,%edx
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802794:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802797:	eb 3b                	jmp    8027d4 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802799:	a1 40 41 80 00       	mov    0x804140,%eax
  80279e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a5:	74 07                	je     8027ae <alloc_block_BF+0x2ad>
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	8b 00                	mov    (%eax),%eax
  8027ac:	eb 05                	jmp    8027b3 <alloc_block_BF+0x2b2>
  8027ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b3:	a3 40 41 80 00       	mov    %eax,0x804140
  8027b8:	a1 40 41 80 00       	mov    0x804140,%eax
  8027bd:	85 c0                	test   %eax,%eax
  8027bf:	0f 85 f8 fe ff ff    	jne    8026bd <alloc_block_BF+0x1bc>
  8027c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c9:	0f 85 ee fe ff ff    	jne    8026bd <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  8027cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027d4:	c9                   	leave  
  8027d5:	c3                   	ret    

008027d6 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027d6:	55                   	push   %ebp
  8027d7:	89 e5                	mov    %esp,%ebp
  8027d9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  8027dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027df:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8027e2:	a1 48 41 80 00       	mov    0x804148,%eax
  8027e7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8027ea:	a1 38 41 80 00       	mov    0x804138,%eax
  8027ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f2:	e9 77 01 00 00       	jmp    80296e <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  8027f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8027fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802800:	0f 85 8a 00 00 00    	jne    802890 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802806:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280a:	75 17                	jne    802823 <alloc_block_NF+0x4d>
  80280c:	83 ec 04             	sub    $0x4,%esp
  80280f:	68 88 3a 80 00       	push   $0x803a88
  802814:	68 f7 00 00 00       	push   $0xf7
  802819:	68 17 3a 80 00       	push   $0x803a17
  80281e:	e8 6d da ff ff       	call   800290 <_panic>
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	8b 00                	mov    (%eax),%eax
  802828:	85 c0                	test   %eax,%eax
  80282a:	74 10                	je     80283c <alloc_block_NF+0x66>
  80282c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282f:	8b 00                	mov    (%eax),%eax
  802831:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802834:	8b 52 04             	mov    0x4(%edx),%edx
  802837:	89 50 04             	mov    %edx,0x4(%eax)
  80283a:	eb 0b                	jmp    802847 <alloc_block_NF+0x71>
  80283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283f:	8b 40 04             	mov    0x4(%eax),%eax
  802842:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284a:	8b 40 04             	mov    0x4(%eax),%eax
  80284d:	85 c0                	test   %eax,%eax
  80284f:	74 0f                	je     802860 <alloc_block_NF+0x8a>
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	8b 40 04             	mov    0x4(%eax),%eax
  802857:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80285a:	8b 12                	mov    (%edx),%edx
  80285c:	89 10                	mov    %edx,(%eax)
  80285e:	eb 0a                	jmp    80286a <alloc_block_NF+0x94>
  802860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802863:	8b 00                	mov    (%eax),%eax
  802865:	a3 38 41 80 00       	mov    %eax,0x804138
  80286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802876:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80287d:	a1 44 41 80 00       	mov    0x804144,%eax
  802882:	48                   	dec    %eax
  802883:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	e9 11 01 00 00       	jmp    8029a1 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	8b 40 0c             	mov    0xc(%eax),%eax
  802896:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802899:	0f 86 c7 00 00 00    	jbe    802966 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  80289f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028a3:	75 17                	jne    8028bc <alloc_block_NF+0xe6>
  8028a5:	83 ec 04             	sub    $0x4,%esp
  8028a8:	68 88 3a 80 00       	push   $0x803a88
  8028ad:	68 fc 00 00 00       	push   $0xfc
  8028b2:	68 17 3a 80 00       	push   $0x803a17
  8028b7:	e8 d4 d9 ff ff       	call   800290 <_panic>
  8028bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028bf:	8b 00                	mov    (%eax),%eax
  8028c1:	85 c0                	test   %eax,%eax
  8028c3:	74 10                	je     8028d5 <alloc_block_NF+0xff>
  8028c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c8:	8b 00                	mov    (%eax),%eax
  8028ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028cd:	8b 52 04             	mov    0x4(%edx),%edx
  8028d0:	89 50 04             	mov    %edx,0x4(%eax)
  8028d3:	eb 0b                	jmp    8028e0 <alloc_block_NF+0x10a>
  8028d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d8:	8b 40 04             	mov    0x4(%eax),%eax
  8028db:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e3:	8b 40 04             	mov    0x4(%eax),%eax
  8028e6:	85 c0                	test   %eax,%eax
  8028e8:	74 0f                	je     8028f9 <alloc_block_NF+0x123>
  8028ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ed:	8b 40 04             	mov    0x4(%eax),%eax
  8028f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028f3:	8b 12                	mov    (%edx),%edx
  8028f5:	89 10                	mov    %edx,(%eax)
  8028f7:	eb 0a                	jmp    802903 <alloc_block_NF+0x12d>
  8028f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fc:	8b 00                	mov    (%eax),%eax
  8028fe:	a3 48 41 80 00       	mov    %eax,0x804148
  802903:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802906:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80290c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802916:	a1 54 41 80 00       	mov    0x804154,%eax
  80291b:	48                   	dec    %eax
  80291c:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802921:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802924:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802927:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	8b 40 0c             	mov    0xc(%eax),%eax
  802930:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802933:	89 c2                	mov    %eax,%edx
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  80293b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293e:	8b 40 08             	mov    0x8(%eax),%eax
  802941:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802947:	8b 50 08             	mov    0x8(%eax),%edx
  80294a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294d:	8b 40 0c             	mov    0xc(%eax),%eax
  802950:	01 c2                	add    %eax,%edx
  802952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802955:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802958:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80295e:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802961:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802964:	eb 3b                	jmp    8029a1 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802966:	a1 40 41 80 00       	mov    0x804140,%eax
  80296b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80296e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802972:	74 07                	je     80297b <alloc_block_NF+0x1a5>
  802974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802977:	8b 00                	mov    (%eax),%eax
  802979:	eb 05                	jmp    802980 <alloc_block_NF+0x1aa>
  80297b:	b8 00 00 00 00       	mov    $0x0,%eax
  802980:	a3 40 41 80 00       	mov    %eax,0x804140
  802985:	a1 40 41 80 00       	mov    0x804140,%eax
  80298a:	85 c0                	test   %eax,%eax
  80298c:	0f 85 65 fe ff ff    	jne    8027f7 <alloc_block_NF+0x21>
  802992:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802996:	0f 85 5b fe ff ff    	jne    8027f7 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  80299c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029a1:	c9                   	leave  
  8029a2:	c3                   	ret    

008029a3 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  8029a3:	55                   	push   %ebp
  8029a4:	89 e5                	mov    %esp,%ebp
  8029a6:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  8029a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  8029b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  8029bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029c1:	75 17                	jne    8029da <addToAvailMemBlocksList+0x37>
  8029c3:	83 ec 04             	sub    $0x4,%esp
  8029c6:	68 30 3a 80 00       	push   $0x803a30
  8029cb:	68 10 01 00 00       	push   $0x110
  8029d0:	68 17 3a 80 00       	push   $0x803a17
  8029d5:	e8 b6 d8 ff ff       	call   800290 <_panic>
  8029da:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  8029e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e3:	89 50 04             	mov    %edx,0x4(%eax)
  8029e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e9:	8b 40 04             	mov    0x4(%eax),%eax
  8029ec:	85 c0                	test   %eax,%eax
  8029ee:	74 0c                	je     8029fc <addToAvailMemBlocksList+0x59>
  8029f0:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8029f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f8:	89 10                	mov    %edx,(%eax)
  8029fa:	eb 08                	jmp    802a04 <addToAvailMemBlocksList+0x61>
  8029fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ff:	a3 48 41 80 00       	mov    %eax,0x804148
  802a04:	8b 45 08             	mov    0x8(%ebp),%eax
  802a07:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a15:	a1 54 41 80 00       	mov    0x804154,%eax
  802a1a:	40                   	inc    %eax
  802a1b:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802a20:	90                   	nop
  802a21:	c9                   	leave  
  802a22:	c3                   	ret    

00802a23 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a23:	55                   	push   %ebp
  802a24:	89 e5                	mov    %esp,%ebp
  802a26:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802a29:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802a31:	a1 44 41 80 00       	mov    0x804144,%eax
  802a36:	85 c0                	test   %eax,%eax
  802a38:	75 68                	jne    802aa2 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802a3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a3e:	75 17                	jne    802a57 <insert_sorted_with_merge_freeList+0x34>
  802a40:	83 ec 04             	sub    $0x4,%esp
  802a43:	68 f4 39 80 00       	push   $0x8039f4
  802a48:	68 1a 01 00 00       	push   $0x11a
  802a4d:	68 17 3a 80 00       	push   $0x803a17
  802a52:	e8 39 d8 ff ff       	call   800290 <_panic>
  802a57:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a60:	89 10                	mov    %edx,(%eax)
  802a62:	8b 45 08             	mov    0x8(%ebp),%eax
  802a65:	8b 00                	mov    (%eax),%eax
  802a67:	85 c0                	test   %eax,%eax
  802a69:	74 0d                	je     802a78 <insert_sorted_with_merge_freeList+0x55>
  802a6b:	a1 38 41 80 00       	mov    0x804138,%eax
  802a70:	8b 55 08             	mov    0x8(%ebp),%edx
  802a73:	89 50 04             	mov    %edx,0x4(%eax)
  802a76:	eb 08                	jmp    802a80 <insert_sorted_with_merge_freeList+0x5d>
  802a78:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a80:	8b 45 08             	mov    0x8(%ebp),%eax
  802a83:	a3 38 41 80 00       	mov    %eax,0x804138
  802a88:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a92:	a1 44 41 80 00       	mov    0x804144,%eax
  802a97:	40                   	inc    %eax
  802a98:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802a9d:	e9 c5 03 00 00       	jmp    802e67 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa5:	8b 50 08             	mov    0x8(%eax),%edx
  802aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  802aab:	8b 40 08             	mov    0x8(%eax),%eax
  802aae:	39 c2                	cmp    %eax,%edx
  802ab0:	0f 83 b2 00 00 00    	jae    802b68 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab9:	8b 50 08             	mov    0x8(%eax),%edx
  802abc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac2:	01 c2                	add    %eax,%edx
  802ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac7:	8b 40 08             	mov    0x8(%eax),%eax
  802aca:	39 c2                	cmp    %eax,%edx
  802acc:	75 27                	jne    802af5 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad1:	8b 50 0c             	mov    0xc(%eax),%edx
  802ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad7:	8b 40 0c             	mov    0xc(%eax),%eax
  802ada:	01 c2                	add    %eax,%edx
  802adc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802adf:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802ae2:	83 ec 0c             	sub    $0xc,%esp
  802ae5:	ff 75 08             	pushl  0x8(%ebp)
  802ae8:	e8 b6 fe ff ff       	call   8029a3 <addToAvailMemBlocksList>
  802aed:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802af0:	e9 72 03 00 00       	jmp    802e67 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802af5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802af9:	74 06                	je     802b01 <insert_sorted_with_merge_freeList+0xde>
  802afb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aff:	75 17                	jne    802b18 <insert_sorted_with_merge_freeList+0xf5>
  802b01:	83 ec 04             	sub    $0x4,%esp
  802b04:	68 54 3a 80 00       	push   $0x803a54
  802b09:	68 24 01 00 00       	push   $0x124
  802b0e:	68 17 3a 80 00       	push   $0x803a17
  802b13:	e8 78 d7 ff ff       	call   800290 <_panic>
  802b18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1b:	8b 10                	mov    (%eax),%edx
  802b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b20:	89 10                	mov    %edx,(%eax)
  802b22:	8b 45 08             	mov    0x8(%ebp),%eax
  802b25:	8b 00                	mov    (%eax),%eax
  802b27:	85 c0                	test   %eax,%eax
  802b29:	74 0b                	je     802b36 <insert_sorted_with_merge_freeList+0x113>
  802b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2e:	8b 00                	mov    (%eax),%eax
  802b30:	8b 55 08             	mov    0x8(%ebp),%edx
  802b33:	89 50 04             	mov    %edx,0x4(%eax)
  802b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b39:	8b 55 08             	mov    0x8(%ebp),%edx
  802b3c:	89 10                	mov    %edx,(%eax)
  802b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b41:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b44:	89 50 04             	mov    %edx,0x4(%eax)
  802b47:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4a:	8b 00                	mov    (%eax),%eax
  802b4c:	85 c0                	test   %eax,%eax
  802b4e:	75 08                	jne    802b58 <insert_sorted_with_merge_freeList+0x135>
  802b50:	8b 45 08             	mov    0x8(%ebp),%eax
  802b53:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b58:	a1 44 41 80 00       	mov    0x804144,%eax
  802b5d:	40                   	inc    %eax
  802b5e:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802b63:	e9 ff 02 00 00       	jmp    802e67 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802b68:	a1 38 41 80 00       	mov    0x804138,%eax
  802b6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b70:	e9 c2 02 00 00       	jmp    802e37 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b78:	8b 50 08             	mov    0x8(%eax),%edx
  802b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7e:	8b 40 08             	mov    0x8(%eax),%eax
  802b81:	39 c2                	cmp    %eax,%edx
  802b83:	0f 86 a6 02 00 00    	jbe    802e2f <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	8b 40 04             	mov    0x4(%eax),%eax
  802b8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802b92:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b96:	0f 85 ba 00 00 00    	jne    802c56 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9f:	8b 50 0c             	mov    0xc(%eax),%edx
  802ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba5:	8b 40 08             	mov    0x8(%eax),%eax
  802ba8:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bad:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802bb0:	39 c2                	cmp    %eax,%edx
  802bb2:	75 33                	jne    802be7 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb7:	8b 50 08             	mov    0x8(%eax),%edx
  802bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbd:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	8b 50 0c             	mov    0xc(%eax),%edx
  802bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc9:	8b 40 0c             	mov    0xc(%eax),%eax
  802bcc:	01 c2                	add    %eax,%edx
  802bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd1:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802bd4:	83 ec 0c             	sub    $0xc,%esp
  802bd7:	ff 75 08             	pushl  0x8(%ebp)
  802bda:	e8 c4 fd ff ff       	call   8029a3 <addToAvailMemBlocksList>
  802bdf:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802be2:	e9 80 02 00 00       	jmp    802e67 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802be7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802beb:	74 06                	je     802bf3 <insert_sorted_with_merge_freeList+0x1d0>
  802bed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bf1:	75 17                	jne    802c0a <insert_sorted_with_merge_freeList+0x1e7>
  802bf3:	83 ec 04             	sub    $0x4,%esp
  802bf6:	68 a8 3a 80 00       	push   $0x803aa8
  802bfb:	68 3a 01 00 00       	push   $0x13a
  802c00:	68 17 3a 80 00       	push   $0x803a17
  802c05:	e8 86 d6 ff ff       	call   800290 <_panic>
  802c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0d:	8b 50 04             	mov    0x4(%eax),%edx
  802c10:	8b 45 08             	mov    0x8(%ebp),%eax
  802c13:	89 50 04             	mov    %edx,0x4(%eax)
  802c16:	8b 45 08             	mov    0x8(%ebp),%eax
  802c19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c1c:	89 10                	mov    %edx,(%eax)
  802c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c21:	8b 40 04             	mov    0x4(%eax),%eax
  802c24:	85 c0                	test   %eax,%eax
  802c26:	74 0d                	je     802c35 <insert_sorted_with_merge_freeList+0x212>
  802c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2b:	8b 40 04             	mov    0x4(%eax),%eax
  802c2e:	8b 55 08             	mov    0x8(%ebp),%edx
  802c31:	89 10                	mov    %edx,(%eax)
  802c33:	eb 08                	jmp    802c3d <insert_sorted_with_merge_freeList+0x21a>
  802c35:	8b 45 08             	mov    0x8(%ebp),%eax
  802c38:	a3 38 41 80 00       	mov    %eax,0x804138
  802c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c40:	8b 55 08             	mov    0x8(%ebp),%edx
  802c43:	89 50 04             	mov    %edx,0x4(%eax)
  802c46:	a1 44 41 80 00       	mov    0x804144,%eax
  802c4b:	40                   	inc    %eax
  802c4c:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802c51:	e9 11 02 00 00       	jmp    802e67 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802c56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c59:	8b 50 08             	mov    0x8(%eax),%edx
  802c5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c62:	01 c2                	add    %eax,%edx
  802c64:	8b 45 08             	mov    0x8(%ebp),%eax
  802c67:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6a:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6f:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802c72:	39 c2                	cmp    %eax,%edx
  802c74:	0f 85 bf 00 00 00    	jne    802d39 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802c7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7d:	8b 50 0c             	mov    0xc(%eax),%edx
  802c80:	8b 45 08             	mov    0x8(%ebp),%eax
  802c83:	8b 40 0c             	mov    0xc(%eax),%eax
  802c86:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8e:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802c90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c93:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802c96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c9a:	75 17                	jne    802cb3 <insert_sorted_with_merge_freeList+0x290>
  802c9c:	83 ec 04             	sub    $0x4,%esp
  802c9f:	68 88 3a 80 00       	push   $0x803a88
  802ca4:	68 43 01 00 00       	push   $0x143
  802ca9:	68 17 3a 80 00       	push   $0x803a17
  802cae:	e8 dd d5 ff ff       	call   800290 <_panic>
  802cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb6:	8b 00                	mov    (%eax),%eax
  802cb8:	85 c0                	test   %eax,%eax
  802cba:	74 10                	je     802ccc <insert_sorted_with_merge_freeList+0x2a9>
  802cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbf:	8b 00                	mov    (%eax),%eax
  802cc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc4:	8b 52 04             	mov    0x4(%edx),%edx
  802cc7:	89 50 04             	mov    %edx,0x4(%eax)
  802cca:	eb 0b                	jmp    802cd7 <insert_sorted_with_merge_freeList+0x2b4>
  802ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccf:	8b 40 04             	mov    0x4(%eax),%eax
  802cd2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cda:	8b 40 04             	mov    0x4(%eax),%eax
  802cdd:	85 c0                	test   %eax,%eax
  802cdf:	74 0f                	je     802cf0 <insert_sorted_with_merge_freeList+0x2cd>
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	8b 40 04             	mov    0x4(%eax),%eax
  802ce7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cea:	8b 12                	mov    (%edx),%edx
  802cec:	89 10                	mov    %edx,(%eax)
  802cee:	eb 0a                	jmp    802cfa <insert_sorted_with_merge_freeList+0x2d7>
  802cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf3:	8b 00                	mov    (%eax),%eax
  802cf5:	a3 38 41 80 00       	mov    %eax,0x804138
  802cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d06:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d0d:	a1 44 41 80 00       	mov    0x804144,%eax
  802d12:	48                   	dec    %eax
  802d13:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802d18:	83 ec 0c             	sub    $0xc,%esp
  802d1b:	ff 75 08             	pushl  0x8(%ebp)
  802d1e:	e8 80 fc ff ff       	call   8029a3 <addToAvailMemBlocksList>
  802d23:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802d26:	83 ec 0c             	sub    $0xc,%esp
  802d29:	ff 75 f4             	pushl  -0xc(%ebp)
  802d2c:	e8 72 fc ff ff       	call   8029a3 <addToAvailMemBlocksList>
  802d31:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802d34:	e9 2e 01 00 00       	jmp    802e67 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802d39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3c:	8b 50 08             	mov    0x8(%eax),%edx
  802d3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d42:	8b 40 0c             	mov    0xc(%eax),%eax
  802d45:	01 c2                	add    %eax,%edx
  802d47:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4a:	8b 40 08             	mov    0x8(%eax),%eax
  802d4d:	39 c2                	cmp    %eax,%edx
  802d4f:	75 27                	jne    802d78 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802d51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d54:	8b 50 0c             	mov    0xc(%eax),%edx
  802d57:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d5d:	01 c2                	add    %eax,%edx
  802d5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d62:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802d65:	83 ec 0c             	sub    $0xc,%esp
  802d68:	ff 75 08             	pushl  0x8(%ebp)
  802d6b:	e8 33 fc ff ff       	call   8029a3 <addToAvailMemBlocksList>
  802d70:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802d73:	e9 ef 00 00 00       	jmp    802e67 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802d78:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7b:	8b 50 0c             	mov    0xc(%eax),%edx
  802d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d81:	8b 40 08             	mov    0x8(%eax),%eax
  802d84:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d89:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802d8c:	39 c2                	cmp    %eax,%edx
  802d8e:	75 33                	jne    802dc3 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802d90:	8b 45 08             	mov    0x8(%ebp),%eax
  802d93:	8b 50 08             	mov    0x8(%eax),%edx
  802d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d99:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	8b 50 0c             	mov    0xc(%eax),%edx
  802da2:	8b 45 08             	mov    0x8(%ebp),%eax
  802da5:	8b 40 0c             	mov    0xc(%eax),%eax
  802da8:	01 c2                	add    %eax,%edx
  802daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dad:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802db0:	83 ec 0c             	sub    $0xc,%esp
  802db3:	ff 75 08             	pushl  0x8(%ebp)
  802db6:	e8 e8 fb ff ff       	call   8029a3 <addToAvailMemBlocksList>
  802dbb:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802dbe:	e9 a4 00 00 00       	jmp    802e67 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802dc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc7:	74 06                	je     802dcf <insert_sorted_with_merge_freeList+0x3ac>
  802dc9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dcd:	75 17                	jne    802de6 <insert_sorted_with_merge_freeList+0x3c3>
  802dcf:	83 ec 04             	sub    $0x4,%esp
  802dd2:	68 a8 3a 80 00       	push   $0x803aa8
  802dd7:	68 56 01 00 00       	push   $0x156
  802ddc:	68 17 3a 80 00       	push   $0x803a17
  802de1:	e8 aa d4 ff ff       	call   800290 <_panic>
  802de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de9:	8b 50 04             	mov    0x4(%eax),%edx
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	89 50 04             	mov    %edx,0x4(%eax)
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802df8:	89 10                	mov    %edx,(%eax)
  802dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfd:	8b 40 04             	mov    0x4(%eax),%eax
  802e00:	85 c0                	test   %eax,%eax
  802e02:	74 0d                	je     802e11 <insert_sorted_with_merge_freeList+0x3ee>
  802e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e07:	8b 40 04             	mov    0x4(%eax),%eax
  802e0a:	8b 55 08             	mov    0x8(%ebp),%edx
  802e0d:	89 10                	mov    %edx,(%eax)
  802e0f:	eb 08                	jmp    802e19 <insert_sorted_with_merge_freeList+0x3f6>
  802e11:	8b 45 08             	mov    0x8(%ebp),%eax
  802e14:	a3 38 41 80 00       	mov    %eax,0x804138
  802e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e1f:	89 50 04             	mov    %edx,0x4(%eax)
  802e22:	a1 44 41 80 00       	mov    0x804144,%eax
  802e27:	40                   	inc    %eax
  802e28:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802e2d:	eb 38                	jmp    802e67 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802e2f:	a1 40 41 80 00       	mov    0x804140,%eax
  802e34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e3b:	74 07                	je     802e44 <insert_sorted_with_merge_freeList+0x421>
  802e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e40:	8b 00                	mov    (%eax),%eax
  802e42:	eb 05                	jmp    802e49 <insert_sorted_with_merge_freeList+0x426>
  802e44:	b8 00 00 00 00       	mov    $0x0,%eax
  802e49:	a3 40 41 80 00       	mov    %eax,0x804140
  802e4e:	a1 40 41 80 00       	mov    0x804140,%eax
  802e53:	85 c0                	test   %eax,%eax
  802e55:	0f 85 1a fd ff ff    	jne    802b75 <insert_sorted_with_merge_freeList+0x152>
  802e5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e5f:	0f 85 10 fd ff ff    	jne    802b75 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e65:	eb 00                	jmp    802e67 <insert_sorted_with_merge_freeList+0x444>
  802e67:	90                   	nop
  802e68:	c9                   	leave  
  802e69:	c3                   	ret    

00802e6a <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802e6a:	55                   	push   %ebp
  802e6b:	89 e5                	mov    %esp,%ebp
  802e6d:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802e70:	8b 55 08             	mov    0x8(%ebp),%edx
  802e73:	89 d0                	mov    %edx,%eax
  802e75:	c1 e0 02             	shl    $0x2,%eax
  802e78:	01 d0                	add    %edx,%eax
  802e7a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e81:	01 d0                	add    %edx,%eax
  802e83:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e8a:	01 d0                	add    %edx,%eax
  802e8c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e93:	01 d0                	add    %edx,%eax
  802e95:	c1 e0 04             	shl    $0x4,%eax
  802e98:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802e9b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802ea2:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802ea5:	83 ec 0c             	sub    $0xc,%esp
  802ea8:	50                   	push   %eax
  802ea9:	e8 60 ed ff ff       	call   801c0e <sys_get_virtual_time>
  802eae:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802eb1:	eb 41                	jmp    802ef4 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802eb3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802eb6:	83 ec 0c             	sub    $0xc,%esp
  802eb9:	50                   	push   %eax
  802eba:	e8 4f ed ff ff       	call   801c0e <sys_get_virtual_time>
  802ebf:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802ec2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ec5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec8:	29 c2                	sub    %eax,%edx
  802eca:	89 d0                	mov    %edx,%eax
  802ecc:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802ecf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ed2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed5:	89 d1                	mov    %edx,%ecx
  802ed7:	29 c1                	sub    %eax,%ecx
  802ed9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802edc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802edf:	39 c2                	cmp    %eax,%edx
  802ee1:	0f 97 c0             	seta   %al
  802ee4:	0f b6 c0             	movzbl %al,%eax
  802ee7:	29 c1                	sub    %eax,%ecx
  802ee9:	89 c8                	mov    %ecx,%eax
  802eeb:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802eee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ef1:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802efa:	72 b7                	jb     802eb3 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802efc:	90                   	nop
  802efd:	c9                   	leave  
  802efe:	c3                   	ret    

00802eff <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802eff:	55                   	push   %ebp
  802f00:	89 e5                	mov    %esp,%ebp
  802f02:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802f05:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802f0c:	eb 03                	jmp    802f11 <busy_wait+0x12>
  802f0e:	ff 45 fc             	incl   -0x4(%ebp)
  802f11:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f14:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f17:	72 f5                	jb     802f0e <busy_wait+0xf>
	return i;
  802f19:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802f1c:	c9                   	leave  
  802f1d:	c3                   	ret    
  802f1e:	66 90                	xchg   %ax,%ax

00802f20 <__udivdi3>:
  802f20:	55                   	push   %ebp
  802f21:	57                   	push   %edi
  802f22:	56                   	push   %esi
  802f23:	53                   	push   %ebx
  802f24:	83 ec 1c             	sub    $0x1c,%esp
  802f27:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802f2b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802f2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802f33:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f37:	89 ca                	mov    %ecx,%edx
  802f39:	89 f8                	mov    %edi,%eax
  802f3b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802f3f:	85 f6                	test   %esi,%esi
  802f41:	75 2d                	jne    802f70 <__udivdi3+0x50>
  802f43:	39 cf                	cmp    %ecx,%edi
  802f45:	77 65                	ja     802fac <__udivdi3+0x8c>
  802f47:	89 fd                	mov    %edi,%ebp
  802f49:	85 ff                	test   %edi,%edi
  802f4b:	75 0b                	jne    802f58 <__udivdi3+0x38>
  802f4d:	b8 01 00 00 00       	mov    $0x1,%eax
  802f52:	31 d2                	xor    %edx,%edx
  802f54:	f7 f7                	div    %edi
  802f56:	89 c5                	mov    %eax,%ebp
  802f58:	31 d2                	xor    %edx,%edx
  802f5a:	89 c8                	mov    %ecx,%eax
  802f5c:	f7 f5                	div    %ebp
  802f5e:	89 c1                	mov    %eax,%ecx
  802f60:	89 d8                	mov    %ebx,%eax
  802f62:	f7 f5                	div    %ebp
  802f64:	89 cf                	mov    %ecx,%edi
  802f66:	89 fa                	mov    %edi,%edx
  802f68:	83 c4 1c             	add    $0x1c,%esp
  802f6b:	5b                   	pop    %ebx
  802f6c:	5e                   	pop    %esi
  802f6d:	5f                   	pop    %edi
  802f6e:	5d                   	pop    %ebp
  802f6f:	c3                   	ret    
  802f70:	39 ce                	cmp    %ecx,%esi
  802f72:	77 28                	ja     802f9c <__udivdi3+0x7c>
  802f74:	0f bd fe             	bsr    %esi,%edi
  802f77:	83 f7 1f             	xor    $0x1f,%edi
  802f7a:	75 40                	jne    802fbc <__udivdi3+0x9c>
  802f7c:	39 ce                	cmp    %ecx,%esi
  802f7e:	72 0a                	jb     802f8a <__udivdi3+0x6a>
  802f80:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802f84:	0f 87 9e 00 00 00    	ja     803028 <__udivdi3+0x108>
  802f8a:	b8 01 00 00 00       	mov    $0x1,%eax
  802f8f:	89 fa                	mov    %edi,%edx
  802f91:	83 c4 1c             	add    $0x1c,%esp
  802f94:	5b                   	pop    %ebx
  802f95:	5e                   	pop    %esi
  802f96:	5f                   	pop    %edi
  802f97:	5d                   	pop    %ebp
  802f98:	c3                   	ret    
  802f99:	8d 76 00             	lea    0x0(%esi),%esi
  802f9c:	31 ff                	xor    %edi,%edi
  802f9e:	31 c0                	xor    %eax,%eax
  802fa0:	89 fa                	mov    %edi,%edx
  802fa2:	83 c4 1c             	add    $0x1c,%esp
  802fa5:	5b                   	pop    %ebx
  802fa6:	5e                   	pop    %esi
  802fa7:	5f                   	pop    %edi
  802fa8:	5d                   	pop    %ebp
  802fa9:	c3                   	ret    
  802faa:	66 90                	xchg   %ax,%ax
  802fac:	89 d8                	mov    %ebx,%eax
  802fae:	f7 f7                	div    %edi
  802fb0:	31 ff                	xor    %edi,%edi
  802fb2:	89 fa                	mov    %edi,%edx
  802fb4:	83 c4 1c             	add    $0x1c,%esp
  802fb7:	5b                   	pop    %ebx
  802fb8:	5e                   	pop    %esi
  802fb9:	5f                   	pop    %edi
  802fba:	5d                   	pop    %ebp
  802fbb:	c3                   	ret    
  802fbc:	bd 20 00 00 00       	mov    $0x20,%ebp
  802fc1:	89 eb                	mov    %ebp,%ebx
  802fc3:	29 fb                	sub    %edi,%ebx
  802fc5:	89 f9                	mov    %edi,%ecx
  802fc7:	d3 e6                	shl    %cl,%esi
  802fc9:	89 c5                	mov    %eax,%ebp
  802fcb:	88 d9                	mov    %bl,%cl
  802fcd:	d3 ed                	shr    %cl,%ebp
  802fcf:	89 e9                	mov    %ebp,%ecx
  802fd1:	09 f1                	or     %esi,%ecx
  802fd3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802fd7:	89 f9                	mov    %edi,%ecx
  802fd9:	d3 e0                	shl    %cl,%eax
  802fdb:	89 c5                	mov    %eax,%ebp
  802fdd:	89 d6                	mov    %edx,%esi
  802fdf:	88 d9                	mov    %bl,%cl
  802fe1:	d3 ee                	shr    %cl,%esi
  802fe3:	89 f9                	mov    %edi,%ecx
  802fe5:	d3 e2                	shl    %cl,%edx
  802fe7:	8b 44 24 08          	mov    0x8(%esp),%eax
  802feb:	88 d9                	mov    %bl,%cl
  802fed:	d3 e8                	shr    %cl,%eax
  802fef:	09 c2                	or     %eax,%edx
  802ff1:	89 d0                	mov    %edx,%eax
  802ff3:	89 f2                	mov    %esi,%edx
  802ff5:	f7 74 24 0c          	divl   0xc(%esp)
  802ff9:	89 d6                	mov    %edx,%esi
  802ffb:	89 c3                	mov    %eax,%ebx
  802ffd:	f7 e5                	mul    %ebp
  802fff:	39 d6                	cmp    %edx,%esi
  803001:	72 19                	jb     80301c <__udivdi3+0xfc>
  803003:	74 0b                	je     803010 <__udivdi3+0xf0>
  803005:	89 d8                	mov    %ebx,%eax
  803007:	31 ff                	xor    %edi,%edi
  803009:	e9 58 ff ff ff       	jmp    802f66 <__udivdi3+0x46>
  80300e:	66 90                	xchg   %ax,%ax
  803010:	8b 54 24 08          	mov    0x8(%esp),%edx
  803014:	89 f9                	mov    %edi,%ecx
  803016:	d3 e2                	shl    %cl,%edx
  803018:	39 c2                	cmp    %eax,%edx
  80301a:	73 e9                	jae    803005 <__udivdi3+0xe5>
  80301c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80301f:	31 ff                	xor    %edi,%edi
  803021:	e9 40 ff ff ff       	jmp    802f66 <__udivdi3+0x46>
  803026:	66 90                	xchg   %ax,%ax
  803028:	31 c0                	xor    %eax,%eax
  80302a:	e9 37 ff ff ff       	jmp    802f66 <__udivdi3+0x46>
  80302f:	90                   	nop

00803030 <__umoddi3>:
  803030:	55                   	push   %ebp
  803031:	57                   	push   %edi
  803032:	56                   	push   %esi
  803033:	53                   	push   %ebx
  803034:	83 ec 1c             	sub    $0x1c,%esp
  803037:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80303b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80303f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803043:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803047:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80304b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80304f:	89 f3                	mov    %esi,%ebx
  803051:	89 fa                	mov    %edi,%edx
  803053:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803057:	89 34 24             	mov    %esi,(%esp)
  80305a:	85 c0                	test   %eax,%eax
  80305c:	75 1a                	jne    803078 <__umoddi3+0x48>
  80305e:	39 f7                	cmp    %esi,%edi
  803060:	0f 86 a2 00 00 00    	jbe    803108 <__umoddi3+0xd8>
  803066:	89 c8                	mov    %ecx,%eax
  803068:	89 f2                	mov    %esi,%edx
  80306a:	f7 f7                	div    %edi
  80306c:	89 d0                	mov    %edx,%eax
  80306e:	31 d2                	xor    %edx,%edx
  803070:	83 c4 1c             	add    $0x1c,%esp
  803073:	5b                   	pop    %ebx
  803074:	5e                   	pop    %esi
  803075:	5f                   	pop    %edi
  803076:	5d                   	pop    %ebp
  803077:	c3                   	ret    
  803078:	39 f0                	cmp    %esi,%eax
  80307a:	0f 87 ac 00 00 00    	ja     80312c <__umoddi3+0xfc>
  803080:	0f bd e8             	bsr    %eax,%ebp
  803083:	83 f5 1f             	xor    $0x1f,%ebp
  803086:	0f 84 ac 00 00 00    	je     803138 <__umoddi3+0x108>
  80308c:	bf 20 00 00 00       	mov    $0x20,%edi
  803091:	29 ef                	sub    %ebp,%edi
  803093:	89 fe                	mov    %edi,%esi
  803095:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803099:	89 e9                	mov    %ebp,%ecx
  80309b:	d3 e0                	shl    %cl,%eax
  80309d:	89 d7                	mov    %edx,%edi
  80309f:	89 f1                	mov    %esi,%ecx
  8030a1:	d3 ef                	shr    %cl,%edi
  8030a3:	09 c7                	or     %eax,%edi
  8030a5:	89 e9                	mov    %ebp,%ecx
  8030a7:	d3 e2                	shl    %cl,%edx
  8030a9:	89 14 24             	mov    %edx,(%esp)
  8030ac:	89 d8                	mov    %ebx,%eax
  8030ae:	d3 e0                	shl    %cl,%eax
  8030b0:	89 c2                	mov    %eax,%edx
  8030b2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030b6:	d3 e0                	shl    %cl,%eax
  8030b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030bc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030c0:	89 f1                	mov    %esi,%ecx
  8030c2:	d3 e8                	shr    %cl,%eax
  8030c4:	09 d0                	or     %edx,%eax
  8030c6:	d3 eb                	shr    %cl,%ebx
  8030c8:	89 da                	mov    %ebx,%edx
  8030ca:	f7 f7                	div    %edi
  8030cc:	89 d3                	mov    %edx,%ebx
  8030ce:	f7 24 24             	mull   (%esp)
  8030d1:	89 c6                	mov    %eax,%esi
  8030d3:	89 d1                	mov    %edx,%ecx
  8030d5:	39 d3                	cmp    %edx,%ebx
  8030d7:	0f 82 87 00 00 00    	jb     803164 <__umoddi3+0x134>
  8030dd:	0f 84 91 00 00 00    	je     803174 <__umoddi3+0x144>
  8030e3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8030e7:	29 f2                	sub    %esi,%edx
  8030e9:	19 cb                	sbb    %ecx,%ebx
  8030eb:	89 d8                	mov    %ebx,%eax
  8030ed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8030f1:	d3 e0                	shl    %cl,%eax
  8030f3:	89 e9                	mov    %ebp,%ecx
  8030f5:	d3 ea                	shr    %cl,%edx
  8030f7:	09 d0                	or     %edx,%eax
  8030f9:	89 e9                	mov    %ebp,%ecx
  8030fb:	d3 eb                	shr    %cl,%ebx
  8030fd:	89 da                	mov    %ebx,%edx
  8030ff:	83 c4 1c             	add    $0x1c,%esp
  803102:	5b                   	pop    %ebx
  803103:	5e                   	pop    %esi
  803104:	5f                   	pop    %edi
  803105:	5d                   	pop    %ebp
  803106:	c3                   	ret    
  803107:	90                   	nop
  803108:	89 fd                	mov    %edi,%ebp
  80310a:	85 ff                	test   %edi,%edi
  80310c:	75 0b                	jne    803119 <__umoddi3+0xe9>
  80310e:	b8 01 00 00 00       	mov    $0x1,%eax
  803113:	31 d2                	xor    %edx,%edx
  803115:	f7 f7                	div    %edi
  803117:	89 c5                	mov    %eax,%ebp
  803119:	89 f0                	mov    %esi,%eax
  80311b:	31 d2                	xor    %edx,%edx
  80311d:	f7 f5                	div    %ebp
  80311f:	89 c8                	mov    %ecx,%eax
  803121:	f7 f5                	div    %ebp
  803123:	89 d0                	mov    %edx,%eax
  803125:	e9 44 ff ff ff       	jmp    80306e <__umoddi3+0x3e>
  80312a:	66 90                	xchg   %ax,%ax
  80312c:	89 c8                	mov    %ecx,%eax
  80312e:	89 f2                	mov    %esi,%edx
  803130:	83 c4 1c             	add    $0x1c,%esp
  803133:	5b                   	pop    %ebx
  803134:	5e                   	pop    %esi
  803135:	5f                   	pop    %edi
  803136:	5d                   	pop    %ebp
  803137:	c3                   	ret    
  803138:	3b 04 24             	cmp    (%esp),%eax
  80313b:	72 06                	jb     803143 <__umoddi3+0x113>
  80313d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803141:	77 0f                	ja     803152 <__umoddi3+0x122>
  803143:	89 f2                	mov    %esi,%edx
  803145:	29 f9                	sub    %edi,%ecx
  803147:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80314b:	89 14 24             	mov    %edx,(%esp)
  80314e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803152:	8b 44 24 04          	mov    0x4(%esp),%eax
  803156:	8b 14 24             	mov    (%esp),%edx
  803159:	83 c4 1c             	add    $0x1c,%esp
  80315c:	5b                   	pop    %ebx
  80315d:	5e                   	pop    %esi
  80315e:	5f                   	pop    %edi
  80315f:	5d                   	pop    %ebp
  803160:	c3                   	ret    
  803161:	8d 76 00             	lea    0x0(%esi),%esi
  803164:	2b 04 24             	sub    (%esp),%eax
  803167:	19 fa                	sbb    %edi,%edx
  803169:	89 d1                	mov    %edx,%ecx
  80316b:	89 c6                	mov    %eax,%esi
  80316d:	e9 71 ff ff ff       	jmp    8030e3 <__umoddi3+0xb3>
  803172:	66 90                	xchg   %ax,%ax
  803174:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803178:	72 ea                	jb     803164 <__umoddi3+0x134>
  80317a:	89 d9                	mov    %ebx,%ecx
  80317c:	e9 62 ff ff ff       	jmp    8030e3 <__umoddi3+0xb3>
