
obj/user/ef_tst_sharing_5_slaveB1:     file format elf32-i386


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
  800031:	e8 05 01 00 00       	call   80013b <libmain>
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
  80003b:	83 ec 18             	sub    $0x18,%esp
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
  80008c:	68 80 31 80 00       	push   $0x803180
  800091:	6a 12                	push   $0x12
  800093:	68 9c 31 80 00       	push   $0x80319c
  800098:	e8 da 01 00 00       	call   800277 <_panic>
	}
	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  80009d:	e8 20 1b 00 00       	call   801bc2 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 bc 31 80 00       	push   $0x8031bc
  8000aa:	50                   	push   %eax
  8000ab:	e8 05 16 00 00       	call   8016b5 <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 c0 31 80 00       	push   $0x8031c0
  8000be:	e8 68 04 00 00       	call   80052b <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B1 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 e8 31 80 00       	push   $0x8031e8
  8000ce:	e8 58 04 00 00       	call   80052b <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(6000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 70 17 00 00       	push   $0x1770
  8000de:	e8 6e 2d 00 00       	call   802e51 <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 de 17 00 00       	call   8018c9 <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(x);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 70 16 00 00       	call   801769 <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 08 32 80 00       	push   $0x803208
  800104:	e8 22 04 00 00       	call   80052b <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  80010c:	e8 b8 17 00 00       	call   8018c9 <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 20 32 80 00       	push   $0x803220
  800127:	6a 20                	push   $0x20
  800129:	68 9c 31 80 00       	push   $0x80319c
  80012e:	e8 44 01 00 00       	call   800277 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800133:	e8 af 1b 00 00       	call   801ce7 <inctst>
	return;
  800138:	90                   	nop
}
  800139:	c9                   	leave  
  80013a:	c3                   	ret    

0080013b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800141:	e8 63 1a 00 00       	call   801ba9 <sys_getenvindex>
  800146:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80014c:	89 d0                	mov    %edx,%eax
  80014e:	c1 e0 03             	shl    $0x3,%eax
  800151:	01 d0                	add    %edx,%eax
  800153:	01 c0                	add    %eax,%eax
  800155:	01 d0                	add    %edx,%eax
  800157:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80015e:	01 d0                	add    %edx,%eax
  800160:	c1 e0 04             	shl    $0x4,%eax
  800163:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800168:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016d:	a1 20 40 80 00       	mov    0x804020,%eax
  800172:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800178:	84 c0                	test   %al,%al
  80017a:	74 0f                	je     80018b <libmain+0x50>
		binaryname = myEnv->prog_name;
  80017c:	a1 20 40 80 00       	mov    0x804020,%eax
  800181:	05 5c 05 00 00       	add    $0x55c,%eax
  800186:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80018b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80018f:	7e 0a                	jle    80019b <libmain+0x60>
		binaryname = argv[0];
  800191:	8b 45 0c             	mov    0xc(%ebp),%eax
  800194:	8b 00                	mov    (%eax),%eax
  800196:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80019b:	83 ec 08             	sub    $0x8,%esp
  80019e:	ff 75 0c             	pushl  0xc(%ebp)
  8001a1:	ff 75 08             	pushl  0x8(%ebp)
  8001a4:	e8 8f fe ff ff       	call   800038 <_main>
  8001a9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001ac:	e8 05 18 00 00       	call   8019b6 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	68 e0 32 80 00       	push   $0x8032e0
  8001b9:	e8 6d 03 00 00       	call   80052b <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d1:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001d7:	83 ec 04             	sub    $0x4,%esp
  8001da:	52                   	push   %edx
  8001db:	50                   	push   %eax
  8001dc:	68 08 33 80 00       	push   $0x803308
  8001e1:	e8 45 03 00 00       	call   80052b <cprintf>
  8001e6:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ee:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001f4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f9:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001ff:	a1 20 40 80 00       	mov    0x804020,%eax
  800204:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80020a:	51                   	push   %ecx
  80020b:	52                   	push   %edx
  80020c:	50                   	push   %eax
  80020d:	68 30 33 80 00       	push   $0x803330
  800212:	e8 14 03 00 00       	call   80052b <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80021a:	a1 20 40 80 00       	mov    0x804020,%eax
  80021f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	50                   	push   %eax
  800229:	68 88 33 80 00       	push   $0x803388
  80022e:	e8 f8 02 00 00       	call   80052b <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 e0 32 80 00       	push   $0x8032e0
  80023e:	e8 e8 02 00 00       	call   80052b <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800246:	e8 85 17 00 00       	call   8019d0 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80024b:	e8 19 00 00 00       	call   800269 <exit>
}
  800250:	90                   	nop
  800251:	c9                   	leave  
  800252:	c3                   	ret    

00800253 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800253:	55                   	push   %ebp
  800254:	89 e5                	mov    %esp,%ebp
  800256:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	6a 00                	push   $0x0
  80025e:	e8 12 19 00 00       	call   801b75 <sys_destroy_env>
  800263:	83 c4 10             	add    $0x10,%esp
}
  800266:	90                   	nop
  800267:	c9                   	leave  
  800268:	c3                   	ret    

00800269 <exit>:

void
exit(void)
{
  800269:	55                   	push   %ebp
  80026a:	89 e5                	mov    %esp,%ebp
  80026c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80026f:	e8 67 19 00 00       	call   801bdb <sys_exit_env>
}
  800274:	90                   	nop
  800275:	c9                   	leave  
  800276:	c3                   	ret    

00800277 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800277:	55                   	push   %ebp
  800278:	89 e5                	mov    %esp,%ebp
  80027a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80027d:	8d 45 10             	lea    0x10(%ebp),%eax
  800280:	83 c0 04             	add    $0x4,%eax
  800283:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800286:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80028b:	85 c0                	test   %eax,%eax
  80028d:	74 16                	je     8002a5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80028f:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800294:	83 ec 08             	sub    $0x8,%esp
  800297:	50                   	push   %eax
  800298:	68 9c 33 80 00       	push   $0x80339c
  80029d:	e8 89 02 00 00       	call   80052b <cprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002a5:	a1 00 40 80 00       	mov    0x804000,%eax
  8002aa:	ff 75 0c             	pushl  0xc(%ebp)
  8002ad:	ff 75 08             	pushl  0x8(%ebp)
  8002b0:	50                   	push   %eax
  8002b1:	68 a1 33 80 00       	push   $0x8033a1
  8002b6:	e8 70 02 00 00       	call   80052b <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002be:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8002c7:	50                   	push   %eax
  8002c8:	e8 f3 01 00 00       	call   8004c0 <vcprintf>
  8002cd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002d0:	83 ec 08             	sub    $0x8,%esp
  8002d3:	6a 00                	push   $0x0
  8002d5:	68 bd 33 80 00       	push   $0x8033bd
  8002da:	e8 e1 01 00 00       	call   8004c0 <vcprintf>
  8002df:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002e2:	e8 82 ff ff ff       	call   800269 <exit>

	// should not return here
	while (1) ;
  8002e7:	eb fe                	jmp    8002e7 <_panic+0x70>

008002e9 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002ef:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f4:	8b 50 74             	mov    0x74(%eax),%edx
  8002f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fa:	39 c2                	cmp    %eax,%edx
  8002fc:	74 14                	je     800312 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 c0 33 80 00       	push   $0x8033c0
  800306:	6a 26                	push   $0x26
  800308:	68 0c 34 80 00       	push   $0x80340c
  80030d:	e8 65 ff ff ff       	call   800277 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800312:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800319:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800320:	e9 c2 00 00 00       	jmp    8003e7 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800328:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032f:	8b 45 08             	mov    0x8(%ebp),%eax
  800332:	01 d0                	add    %edx,%eax
  800334:	8b 00                	mov    (%eax),%eax
  800336:	85 c0                	test   %eax,%eax
  800338:	75 08                	jne    800342 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80033a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80033d:	e9 a2 00 00 00       	jmp    8003e4 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800342:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800349:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800350:	eb 69                	jmp    8003bb <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800352:	a1 20 40 80 00       	mov    0x804020,%eax
  800357:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80035d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800360:	89 d0                	mov    %edx,%eax
  800362:	01 c0                	add    %eax,%eax
  800364:	01 d0                	add    %edx,%eax
  800366:	c1 e0 03             	shl    $0x3,%eax
  800369:	01 c8                	add    %ecx,%eax
  80036b:	8a 40 04             	mov    0x4(%eax),%al
  80036e:	84 c0                	test   %al,%al
  800370:	75 46                	jne    8003b8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800372:	a1 20 40 80 00       	mov    0x804020,%eax
  800377:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80037d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800380:	89 d0                	mov    %edx,%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	01 d0                	add    %edx,%eax
  800386:	c1 e0 03             	shl    $0x3,%eax
  800389:	01 c8                	add    %ecx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800390:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800398:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80039a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a7:	01 c8                	add    %ecx,%eax
  8003a9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ab:	39 c2                	cmp    %eax,%edx
  8003ad:	75 09                	jne    8003b8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003af:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003b6:	eb 12                	jmp    8003ca <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003b8:	ff 45 e8             	incl   -0x18(%ebp)
  8003bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c0:	8b 50 74             	mov    0x74(%eax),%edx
  8003c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003c6:	39 c2                	cmp    %eax,%edx
  8003c8:	77 88                	ja     800352 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003ce:	75 14                	jne    8003e4 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003d0:	83 ec 04             	sub    $0x4,%esp
  8003d3:	68 18 34 80 00       	push   $0x803418
  8003d8:	6a 3a                	push   $0x3a
  8003da:	68 0c 34 80 00       	push   $0x80340c
  8003df:	e8 93 fe ff ff       	call   800277 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003e4:	ff 45 f0             	incl   -0x10(%ebp)
  8003e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003ed:	0f 8c 32 ff ff ff    	jl     800325 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800401:	eb 26                	jmp    800429 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800403:	a1 20 40 80 00       	mov    0x804020,%eax
  800408:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80040e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800411:	89 d0                	mov    %edx,%eax
  800413:	01 c0                	add    %eax,%eax
  800415:	01 d0                	add    %edx,%eax
  800417:	c1 e0 03             	shl    $0x3,%eax
  80041a:	01 c8                	add    %ecx,%eax
  80041c:	8a 40 04             	mov    0x4(%eax),%al
  80041f:	3c 01                	cmp    $0x1,%al
  800421:	75 03                	jne    800426 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800423:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800426:	ff 45 e0             	incl   -0x20(%ebp)
  800429:	a1 20 40 80 00       	mov    0x804020,%eax
  80042e:	8b 50 74             	mov    0x74(%eax),%edx
  800431:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800434:	39 c2                	cmp    %eax,%edx
  800436:	77 cb                	ja     800403 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80043b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80043e:	74 14                	je     800454 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800440:	83 ec 04             	sub    $0x4,%esp
  800443:	68 6c 34 80 00       	push   $0x80346c
  800448:	6a 44                	push   $0x44
  80044a:	68 0c 34 80 00       	push   $0x80340c
  80044f:	e8 23 fe ff ff       	call   800277 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800454:	90                   	nop
  800455:	c9                   	leave  
  800456:	c3                   	ret    

00800457 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800457:	55                   	push   %ebp
  800458:	89 e5                	mov    %esp,%ebp
  80045a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80045d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800460:	8b 00                	mov    (%eax),%eax
  800462:	8d 48 01             	lea    0x1(%eax),%ecx
  800465:	8b 55 0c             	mov    0xc(%ebp),%edx
  800468:	89 0a                	mov    %ecx,(%edx)
  80046a:	8b 55 08             	mov    0x8(%ebp),%edx
  80046d:	88 d1                	mov    %dl,%cl
  80046f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800472:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800476:	8b 45 0c             	mov    0xc(%ebp),%eax
  800479:	8b 00                	mov    (%eax),%eax
  80047b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800480:	75 2c                	jne    8004ae <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800482:	a0 24 40 80 00       	mov    0x804024,%al
  800487:	0f b6 c0             	movzbl %al,%eax
  80048a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048d:	8b 12                	mov    (%edx),%edx
  80048f:	89 d1                	mov    %edx,%ecx
  800491:	8b 55 0c             	mov    0xc(%ebp),%edx
  800494:	83 c2 08             	add    $0x8,%edx
  800497:	83 ec 04             	sub    $0x4,%esp
  80049a:	50                   	push   %eax
  80049b:	51                   	push   %ecx
  80049c:	52                   	push   %edx
  80049d:	e8 66 13 00 00       	call   801808 <sys_cputs>
  8004a2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b1:	8b 40 04             	mov    0x4(%eax),%eax
  8004b4:	8d 50 01             	lea    0x1(%eax),%edx
  8004b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ba:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004bd:	90                   	nop
  8004be:	c9                   	leave  
  8004bf:	c3                   	ret    

008004c0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004c9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004d0:	00 00 00 
	b.cnt = 0;
  8004d3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004da:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004dd:	ff 75 0c             	pushl  0xc(%ebp)
  8004e0:	ff 75 08             	pushl  0x8(%ebp)
  8004e3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e9:	50                   	push   %eax
  8004ea:	68 57 04 80 00       	push   $0x800457
  8004ef:	e8 11 02 00 00       	call   800705 <vprintfmt>
  8004f4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004f7:	a0 24 40 80 00       	mov    0x804024,%al
  8004fc:	0f b6 c0             	movzbl %al,%eax
  8004ff:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800505:	83 ec 04             	sub    $0x4,%esp
  800508:	50                   	push   %eax
  800509:	52                   	push   %edx
  80050a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800510:	83 c0 08             	add    $0x8,%eax
  800513:	50                   	push   %eax
  800514:	e8 ef 12 00 00       	call   801808 <sys_cputs>
  800519:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80051c:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800523:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800529:	c9                   	leave  
  80052a:	c3                   	ret    

0080052b <cprintf>:

int cprintf(const char *fmt, ...) {
  80052b:	55                   	push   %ebp
  80052c:	89 e5                	mov    %esp,%ebp
  80052e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800531:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800538:	8d 45 0c             	lea    0xc(%ebp),%eax
  80053b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	83 ec 08             	sub    $0x8,%esp
  800544:	ff 75 f4             	pushl  -0xc(%ebp)
  800547:	50                   	push   %eax
  800548:	e8 73 ff ff ff       	call   8004c0 <vcprintf>
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800553:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800556:	c9                   	leave  
  800557:	c3                   	ret    

00800558 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800558:	55                   	push   %ebp
  800559:	89 e5                	mov    %esp,%ebp
  80055b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80055e:	e8 53 14 00 00       	call   8019b6 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800563:	8d 45 0c             	lea    0xc(%ebp),%eax
  800566:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	83 ec 08             	sub    $0x8,%esp
  80056f:	ff 75 f4             	pushl  -0xc(%ebp)
  800572:	50                   	push   %eax
  800573:	e8 48 ff ff ff       	call   8004c0 <vcprintf>
  800578:	83 c4 10             	add    $0x10,%esp
  80057b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80057e:	e8 4d 14 00 00       	call   8019d0 <sys_enable_interrupt>
	return cnt;
  800583:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800586:	c9                   	leave  
  800587:	c3                   	ret    

00800588 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800588:	55                   	push   %ebp
  800589:	89 e5                	mov    %esp,%ebp
  80058b:	53                   	push   %ebx
  80058c:	83 ec 14             	sub    $0x14,%esp
  80058f:	8b 45 10             	mov    0x10(%ebp),%eax
  800592:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80059b:	8b 45 18             	mov    0x18(%ebp),%eax
  80059e:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a6:	77 55                	ja     8005fd <printnum+0x75>
  8005a8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ab:	72 05                	jb     8005b2 <printnum+0x2a>
  8005ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005b0:	77 4b                	ja     8005fd <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005b5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005b8:	8b 45 18             	mov    0x18(%ebp),%eax
  8005bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c0:	52                   	push   %edx
  8005c1:	50                   	push   %eax
  8005c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c5:	ff 75 f0             	pushl  -0x10(%ebp)
  8005c8:	e8 3b 29 00 00       	call   802f08 <__udivdi3>
  8005cd:	83 c4 10             	add    $0x10,%esp
  8005d0:	83 ec 04             	sub    $0x4,%esp
  8005d3:	ff 75 20             	pushl  0x20(%ebp)
  8005d6:	53                   	push   %ebx
  8005d7:	ff 75 18             	pushl  0x18(%ebp)
  8005da:	52                   	push   %edx
  8005db:	50                   	push   %eax
  8005dc:	ff 75 0c             	pushl  0xc(%ebp)
  8005df:	ff 75 08             	pushl  0x8(%ebp)
  8005e2:	e8 a1 ff ff ff       	call   800588 <printnum>
  8005e7:	83 c4 20             	add    $0x20,%esp
  8005ea:	eb 1a                	jmp    800606 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005ec:	83 ec 08             	sub    $0x8,%esp
  8005ef:	ff 75 0c             	pushl  0xc(%ebp)
  8005f2:	ff 75 20             	pushl  0x20(%ebp)
  8005f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f8:	ff d0                	call   *%eax
  8005fa:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005fd:	ff 4d 1c             	decl   0x1c(%ebp)
  800600:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800604:	7f e6                	jg     8005ec <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800606:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800609:	bb 00 00 00 00       	mov    $0x0,%ebx
  80060e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800611:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800614:	53                   	push   %ebx
  800615:	51                   	push   %ecx
  800616:	52                   	push   %edx
  800617:	50                   	push   %eax
  800618:	e8 fb 29 00 00       	call   803018 <__umoddi3>
  80061d:	83 c4 10             	add    $0x10,%esp
  800620:	05 d4 36 80 00       	add    $0x8036d4,%eax
  800625:	8a 00                	mov    (%eax),%al
  800627:	0f be c0             	movsbl %al,%eax
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	ff 75 0c             	pushl  0xc(%ebp)
  800630:	50                   	push   %eax
  800631:	8b 45 08             	mov    0x8(%ebp),%eax
  800634:	ff d0                	call   *%eax
  800636:	83 c4 10             	add    $0x10,%esp
}
  800639:	90                   	nop
  80063a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80063d:	c9                   	leave  
  80063e:	c3                   	ret    

0080063f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80063f:	55                   	push   %ebp
  800640:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800642:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800646:	7e 1c                	jle    800664 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	8b 00                	mov    (%eax),%eax
  80064d:	8d 50 08             	lea    0x8(%eax),%edx
  800650:	8b 45 08             	mov    0x8(%ebp),%eax
  800653:	89 10                	mov    %edx,(%eax)
  800655:	8b 45 08             	mov    0x8(%ebp),%eax
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	83 e8 08             	sub    $0x8,%eax
  80065d:	8b 50 04             	mov    0x4(%eax),%edx
  800660:	8b 00                	mov    (%eax),%eax
  800662:	eb 40                	jmp    8006a4 <getuint+0x65>
	else if (lflag)
  800664:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800668:	74 1e                	je     800688 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80066a:	8b 45 08             	mov    0x8(%ebp),%eax
  80066d:	8b 00                	mov    (%eax),%eax
  80066f:	8d 50 04             	lea    0x4(%eax),%edx
  800672:	8b 45 08             	mov    0x8(%ebp),%eax
  800675:	89 10                	mov    %edx,(%eax)
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	83 e8 04             	sub    $0x4,%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	ba 00 00 00 00       	mov    $0x0,%edx
  800686:	eb 1c                	jmp    8006a4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	8d 50 04             	lea    0x4(%eax),%edx
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	89 10                	mov    %edx,(%eax)
  800695:	8b 45 08             	mov    0x8(%ebp),%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	83 e8 04             	sub    $0x4,%eax
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006a4:	5d                   	pop    %ebp
  8006a5:	c3                   	ret    

008006a6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006a6:	55                   	push   %ebp
  8006a7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ad:	7e 1c                	jle    8006cb <getint+0x25>
		return va_arg(*ap, long long);
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	8d 50 08             	lea    0x8(%eax),%edx
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	89 10                	mov    %edx,(%eax)
  8006bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	83 e8 08             	sub    $0x8,%eax
  8006c4:	8b 50 04             	mov    0x4(%eax),%edx
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	eb 38                	jmp    800703 <getint+0x5d>
	else if (lflag)
  8006cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006cf:	74 1a                	je     8006eb <getint+0x45>
		return va_arg(*ap, long);
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	8d 50 04             	lea    0x4(%eax),%edx
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	89 10                	mov    %edx,(%eax)
  8006de:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	83 e8 04             	sub    $0x4,%eax
  8006e6:	8b 00                	mov    (%eax),%eax
  8006e8:	99                   	cltd   
  8006e9:	eb 18                	jmp    800703 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	8d 50 04             	lea    0x4(%eax),%edx
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	89 10                	mov    %edx,(%eax)
  8006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	83 e8 04             	sub    $0x4,%eax
  800700:	8b 00                	mov    (%eax),%eax
  800702:	99                   	cltd   
}
  800703:	5d                   	pop    %ebp
  800704:	c3                   	ret    

00800705 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800705:	55                   	push   %ebp
  800706:	89 e5                	mov    %esp,%ebp
  800708:	56                   	push   %esi
  800709:	53                   	push   %ebx
  80070a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070d:	eb 17                	jmp    800726 <vprintfmt+0x21>
			if (ch == '\0')
  80070f:	85 db                	test   %ebx,%ebx
  800711:	0f 84 af 03 00 00    	je     800ac6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	ff 75 0c             	pushl  0xc(%ebp)
  80071d:	53                   	push   %ebx
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	ff d0                	call   *%eax
  800723:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800726:	8b 45 10             	mov    0x10(%ebp),%eax
  800729:	8d 50 01             	lea    0x1(%eax),%edx
  80072c:	89 55 10             	mov    %edx,0x10(%ebp)
  80072f:	8a 00                	mov    (%eax),%al
  800731:	0f b6 d8             	movzbl %al,%ebx
  800734:	83 fb 25             	cmp    $0x25,%ebx
  800737:	75 d6                	jne    80070f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800739:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80073d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800744:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80074b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800752:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800759:	8b 45 10             	mov    0x10(%ebp),%eax
  80075c:	8d 50 01             	lea    0x1(%eax),%edx
  80075f:	89 55 10             	mov    %edx,0x10(%ebp)
  800762:	8a 00                	mov    (%eax),%al
  800764:	0f b6 d8             	movzbl %al,%ebx
  800767:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80076a:	83 f8 55             	cmp    $0x55,%eax
  80076d:	0f 87 2b 03 00 00    	ja     800a9e <vprintfmt+0x399>
  800773:	8b 04 85 f8 36 80 00 	mov    0x8036f8(,%eax,4),%eax
  80077a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80077c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800780:	eb d7                	jmp    800759 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800782:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800786:	eb d1                	jmp    800759 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800788:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80078f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800792:	89 d0                	mov    %edx,%eax
  800794:	c1 e0 02             	shl    $0x2,%eax
  800797:	01 d0                	add    %edx,%eax
  800799:	01 c0                	add    %eax,%eax
  80079b:	01 d8                	add    %ebx,%eax
  80079d:	83 e8 30             	sub    $0x30,%eax
  8007a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a6:	8a 00                	mov    (%eax),%al
  8007a8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007ab:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ae:	7e 3e                	jle    8007ee <vprintfmt+0xe9>
  8007b0:	83 fb 39             	cmp    $0x39,%ebx
  8007b3:	7f 39                	jg     8007ee <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007b5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007b8:	eb d5                	jmp    80078f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bd:	83 c0 04             	add    $0x4,%eax
  8007c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	83 e8 04             	sub    $0x4,%eax
  8007c9:	8b 00                	mov    (%eax),%eax
  8007cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007ce:	eb 1f                	jmp    8007ef <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d4:	79 83                	jns    800759 <vprintfmt+0x54>
				width = 0;
  8007d6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007dd:	e9 77 ff ff ff       	jmp    800759 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007e2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007e9:	e9 6b ff ff ff       	jmp    800759 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007ee:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f3:	0f 89 60 ff ff ff    	jns    800759 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007ff:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800806:	e9 4e ff ff ff       	jmp    800759 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80080b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80080e:	e9 46 ff ff ff       	jmp    800759 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	83 c0 04             	add    $0x4,%eax
  800819:	89 45 14             	mov    %eax,0x14(%ebp)
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	83 e8 04             	sub    $0x4,%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	83 ec 08             	sub    $0x8,%esp
  800827:	ff 75 0c             	pushl  0xc(%ebp)
  80082a:	50                   	push   %eax
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	ff d0                	call   *%eax
  800830:	83 c4 10             	add    $0x10,%esp
			break;
  800833:	e9 89 02 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	83 c0 04             	add    $0x4,%eax
  80083e:	89 45 14             	mov    %eax,0x14(%ebp)
  800841:	8b 45 14             	mov    0x14(%ebp),%eax
  800844:	83 e8 04             	sub    $0x4,%eax
  800847:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800849:	85 db                	test   %ebx,%ebx
  80084b:	79 02                	jns    80084f <vprintfmt+0x14a>
				err = -err;
  80084d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80084f:	83 fb 64             	cmp    $0x64,%ebx
  800852:	7f 0b                	jg     80085f <vprintfmt+0x15a>
  800854:	8b 34 9d 40 35 80 00 	mov    0x803540(,%ebx,4),%esi
  80085b:	85 f6                	test   %esi,%esi
  80085d:	75 19                	jne    800878 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80085f:	53                   	push   %ebx
  800860:	68 e5 36 80 00       	push   $0x8036e5
  800865:	ff 75 0c             	pushl  0xc(%ebp)
  800868:	ff 75 08             	pushl  0x8(%ebp)
  80086b:	e8 5e 02 00 00       	call   800ace <printfmt>
  800870:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800873:	e9 49 02 00 00       	jmp    800ac1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800878:	56                   	push   %esi
  800879:	68 ee 36 80 00       	push   $0x8036ee
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	ff 75 08             	pushl  0x8(%ebp)
  800884:	e8 45 02 00 00       	call   800ace <printfmt>
  800889:	83 c4 10             	add    $0x10,%esp
			break;
  80088c:	e9 30 02 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	83 c0 04             	add    $0x4,%eax
  800897:	89 45 14             	mov    %eax,0x14(%ebp)
  80089a:	8b 45 14             	mov    0x14(%ebp),%eax
  80089d:	83 e8 04             	sub    $0x4,%eax
  8008a0:	8b 30                	mov    (%eax),%esi
  8008a2:	85 f6                	test   %esi,%esi
  8008a4:	75 05                	jne    8008ab <vprintfmt+0x1a6>
				p = "(null)";
  8008a6:	be f1 36 80 00       	mov    $0x8036f1,%esi
			if (width > 0 && padc != '-')
  8008ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008af:	7e 6d                	jle    80091e <vprintfmt+0x219>
  8008b1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008b5:	74 67                	je     80091e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	50                   	push   %eax
  8008be:	56                   	push   %esi
  8008bf:	e8 0c 03 00 00       	call   800bd0 <strnlen>
  8008c4:	83 c4 10             	add    $0x10,%esp
  8008c7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008ca:	eb 16                	jmp    8008e2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008cc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008d0:	83 ec 08             	sub    $0x8,%esp
  8008d3:	ff 75 0c             	pushl  0xc(%ebp)
  8008d6:	50                   	push   %eax
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	ff d0                	call   *%eax
  8008dc:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008df:	ff 4d e4             	decl   -0x1c(%ebp)
  8008e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e6:	7f e4                	jg     8008cc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e8:	eb 34                	jmp    80091e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ea:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008ee:	74 1c                	je     80090c <vprintfmt+0x207>
  8008f0:	83 fb 1f             	cmp    $0x1f,%ebx
  8008f3:	7e 05                	jle    8008fa <vprintfmt+0x1f5>
  8008f5:	83 fb 7e             	cmp    $0x7e,%ebx
  8008f8:	7e 12                	jle    80090c <vprintfmt+0x207>
					putch('?', putdat);
  8008fa:	83 ec 08             	sub    $0x8,%esp
  8008fd:	ff 75 0c             	pushl  0xc(%ebp)
  800900:	6a 3f                	push   $0x3f
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	ff d0                	call   *%eax
  800907:	83 c4 10             	add    $0x10,%esp
  80090a:	eb 0f                	jmp    80091b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80090c:	83 ec 08             	sub    $0x8,%esp
  80090f:	ff 75 0c             	pushl  0xc(%ebp)
  800912:	53                   	push   %ebx
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	ff d0                	call   *%eax
  800918:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80091b:	ff 4d e4             	decl   -0x1c(%ebp)
  80091e:	89 f0                	mov    %esi,%eax
  800920:	8d 70 01             	lea    0x1(%eax),%esi
  800923:	8a 00                	mov    (%eax),%al
  800925:	0f be d8             	movsbl %al,%ebx
  800928:	85 db                	test   %ebx,%ebx
  80092a:	74 24                	je     800950 <vprintfmt+0x24b>
  80092c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800930:	78 b8                	js     8008ea <vprintfmt+0x1e5>
  800932:	ff 4d e0             	decl   -0x20(%ebp)
  800935:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800939:	79 af                	jns    8008ea <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80093b:	eb 13                	jmp    800950 <vprintfmt+0x24b>
				putch(' ', putdat);
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 0c             	pushl  0xc(%ebp)
  800943:	6a 20                	push   $0x20
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	ff d0                	call   *%eax
  80094a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80094d:	ff 4d e4             	decl   -0x1c(%ebp)
  800950:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800954:	7f e7                	jg     80093d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800956:	e9 66 01 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	ff 75 e8             	pushl  -0x18(%ebp)
  800961:	8d 45 14             	lea    0x14(%ebp),%eax
  800964:	50                   	push   %eax
  800965:	e8 3c fd ff ff       	call   8006a6 <getint>
  80096a:	83 c4 10             	add    $0x10,%esp
  80096d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800970:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800973:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800976:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800979:	85 d2                	test   %edx,%edx
  80097b:	79 23                	jns    8009a0 <vprintfmt+0x29b>
				putch('-', putdat);
  80097d:	83 ec 08             	sub    $0x8,%esp
  800980:	ff 75 0c             	pushl  0xc(%ebp)
  800983:	6a 2d                	push   $0x2d
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	ff d0                	call   *%eax
  80098a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80098d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800990:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800993:	f7 d8                	neg    %eax
  800995:	83 d2 00             	adc    $0x0,%edx
  800998:	f7 da                	neg    %edx
  80099a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009a0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009a7:	e9 bc 00 00 00       	jmp    800a68 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009ac:	83 ec 08             	sub    $0x8,%esp
  8009af:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b2:	8d 45 14             	lea    0x14(%ebp),%eax
  8009b5:	50                   	push   %eax
  8009b6:	e8 84 fc ff ff       	call   80063f <getuint>
  8009bb:	83 c4 10             	add    $0x10,%esp
  8009be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009c4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009cb:	e9 98 00 00 00       	jmp    800a68 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d0:	83 ec 08             	sub    $0x8,%esp
  8009d3:	ff 75 0c             	pushl  0xc(%ebp)
  8009d6:	6a 58                	push   $0x58
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	ff d0                	call   *%eax
  8009dd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	ff 75 0c             	pushl  0xc(%ebp)
  8009e6:	6a 58                	push   $0x58
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	ff d0                	call   *%eax
  8009ed:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 0c             	pushl  0xc(%ebp)
  8009f6:	6a 58                	push   $0x58
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	ff d0                	call   *%eax
  8009fd:	83 c4 10             	add    $0x10,%esp
			break;
  800a00:	e9 bc 00 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a05:	83 ec 08             	sub    $0x8,%esp
  800a08:	ff 75 0c             	pushl  0xc(%ebp)
  800a0b:	6a 30                	push   $0x30
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	ff d0                	call   *%eax
  800a12:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a15:	83 ec 08             	sub    $0x8,%esp
  800a18:	ff 75 0c             	pushl  0xc(%ebp)
  800a1b:	6a 78                	push   $0x78
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	ff d0                	call   *%eax
  800a22:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	83 c0 04             	add    $0x4,%eax
  800a2b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	83 e8 04             	sub    $0x4,%eax
  800a34:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a40:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a47:	eb 1f                	jmp    800a68 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a49:	83 ec 08             	sub    $0x8,%esp
  800a4c:	ff 75 e8             	pushl  -0x18(%ebp)
  800a4f:	8d 45 14             	lea    0x14(%ebp),%eax
  800a52:	50                   	push   %eax
  800a53:	e8 e7 fb ff ff       	call   80063f <getuint>
  800a58:	83 c4 10             	add    $0x10,%esp
  800a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a61:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a68:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a6f:	83 ec 04             	sub    $0x4,%esp
  800a72:	52                   	push   %edx
  800a73:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a76:	50                   	push   %eax
  800a77:	ff 75 f4             	pushl  -0xc(%ebp)
  800a7a:	ff 75 f0             	pushl  -0x10(%ebp)
  800a7d:	ff 75 0c             	pushl  0xc(%ebp)
  800a80:	ff 75 08             	pushl  0x8(%ebp)
  800a83:	e8 00 fb ff ff       	call   800588 <printnum>
  800a88:	83 c4 20             	add    $0x20,%esp
			break;
  800a8b:	eb 34                	jmp    800ac1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a8d:	83 ec 08             	sub    $0x8,%esp
  800a90:	ff 75 0c             	pushl  0xc(%ebp)
  800a93:	53                   	push   %ebx
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	ff d0                	call   *%eax
  800a99:	83 c4 10             	add    $0x10,%esp
			break;
  800a9c:	eb 23                	jmp    800ac1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a9e:	83 ec 08             	sub    $0x8,%esp
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	6a 25                	push   $0x25
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aae:	ff 4d 10             	decl   0x10(%ebp)
  800ab1:	eb 03                	jmp    800ab6 <vprintfmt+0x3b1>
  800ab3:	ff 4d 10             	decl   0x10(%ebp)
  800ab6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab9:	48                   	dec    %eax
  800aba:	8a 00                	mov    (%eax),%al
  800abc:	3c 25                	cmp    $0x25,%al
  800abe:	75 f3                	jne    800ab3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ac0:	90                   	nop
		}
	}
  800ac1:	e9 47 fc ff ff       	jmp    80070d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ac6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ac7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aca:	5b                   	pop    %ebx
  800acb:	5e                   	pop    %esi
  800acc:	5d                   	pop    %ebp
  800acd:	c3                   	ret    

00800ace <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ace:	55                   	push   %ebp
  800acf:	89 e5                	mov    %esp,%ebp
  800ad1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ad4:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad7:	83 c0 04             	add    $0x4,%eax
  800ada:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800add:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae3:	50                   	push   %eax
  800ae4:	ff 75 0c             	pushl  0xc(%ebp)
  800ae7:	ff 75 08             	pushl  0x8(%ebp)
  800aea:	e8 16 fc ff ff       	call   800705 <vprintfmt>
  800aef:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800af2:	90                   	nop
  800af3:	c9                   	leave  
  800af4:	c3                   	ret    

00800af5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afb:	8b 40 08             	mov    0x8(%eax),%eax
  800afe:	8d 50 01             	lea    0x1(%eax),%edx
  800b01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b04:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0a:	8b 10                	mov    (%eax),%edx
  800b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0f:	8b 40 04             	mov    0x4(%eax),%eax
  800b12:	39 c2                	cmp    %eax,%edx
  800b14:	73 12                	jae    800b28 <sprintputch+0x33>
		*b->buf++ = ch;
  800b16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b19:	8b 00                	mov    (%eax),%eax
  800b1b:	8d 48 01             	lea    0x1(%eax),%ecx
  800b1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b21:	89 0a                	mov    %ecx,(%edx)
  800b23:	8b 55 08             	mov    0x8(%ebp),%edx
  800b26:	88 10                	mov    %dl,(%eax)
}
  800b28:	90                   	nop
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    

00800b2b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	01 d0                	add    %edx,%eax
  800b42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b50:	74 06                	je     800b58 <vsnprintf+0x2d>
  800b52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b56:	7f 07                	jg     800b5f <vsnprintf+0x34>
		return -E_INVAL;
  800b58:	b8 03 00 00 00       	mov    $0x3,%eax
  800b5d:	eb 20                	jmp    800b7f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b5f:	ff 75 14             	pushl  0x14(%ebp)
  800b62:	ff 75 10             	pushl  0x10(%ebp)
  800b65:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b68:	50                   	push   %eax
  800b69:	68 f5 0a 80 00       	push   $0x800af5
  800b6e:	e8 92 fb ff ff       	call   800705 <vprintfmt>
  800b73:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b79:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b7f:	c9                   	leave  
  800b80:	c3                   	ret    

00800b81 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b81:	55                   	push   %ebp
  800b82:	89 e5                	mov    %esp,%ebp
  800b84:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b87:	8d 45 10             	lea    0x10(%ebp),%eax
  800b8a:	83 c0 04             	add    $0x4,%eax
  800b8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b90:	8b 45 10             	mov    0x10(%ebp),%eax
  800b93:	ff 75 f4             	pushl  -0xc(%ebp)
  800b96:	50                   	push   %eax
  800b97:	ff 75 0c             	pushl  0xc(%ebp)
  800b9a:	ff 75 08             	pushl  0x8(%ebp)
  800b9d:	e8 89 ff ff ff       	call   800b2b <vsnprintf>
  800ba2:	83 c4 10             	add    $0x10,%esp
  800ba5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bab:	c9                   	leave  
  800bac:	c3                   	ret    

00800bad <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bba:	eb 06                	jmp    800bc2 <strlen+0x15>
		n++;
  800bbc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbf:	ff 45 08             	incl   0x8(%ebp)
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	8a 00                	mov    (%eax),%al
  800bc7:	84 c0                	test   %al,%al
  800bc9:	75 f1                	jne    800bbc <strlen+0xf>
		n++;
	return n;
  800bcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bce:	c9                   	leave  
  800bcf:	c3                   	ret    

00800bd0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bdd:	eb 09                	jmp    800be8 <strnlen+0x18>
		n++;
  800bdf:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be2:	ff 45 08             	incl   0x8(%ebp)
  800be5:	ff 4d 0c             	decl   0xc(%ebp)
  800be8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bec:	74 09                	je     800bf7 <strnlen+0x27>
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	8a 00                	mov    (%eax),%al
  800bf3:	84 c0                	test   %al,%al
  800bf5:	75 e8                	jne    800bdf <strnlen+0xf>
		n++;
	return n;
  800bf7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c08:	90                   	nop
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	8d 50 01             	lea    0x1(%eax),%edx
  800c0f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c15:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c18:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c1b:	8a 12                	mov    (%edx),%dl
  800c1d:	88 10                	mov    %dl,(%eax)
  800c1f:	8a 00                	mov    (%eax),%al
  800c21:	84 c0                	test   %al,%al
  800c23:	75 e4                	jne    800c09 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c25:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c28:	c9                   	leave  
  800c29:	c3                   	ret    

00800c2a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c3d:	eb 1f                	jmp    800c5e <strncpy+0x34>
		*dst++ = *src;
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	8d 50 01             	lea    0x1(%eax),%edx
  800c45:	89 55 08             	mov    %edx,0x8(%ebp)
  800c48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4b:	8a 12                	mov    (%edx),%dl
  800c4d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c52:	8a 00                	mov    (%eax),%al
  800c54:	84 c0                	test   %al,%al
  800c56:	74 03                	je     800c5b <strncpy+0x31>
			src++;
  800c58:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c5b:	ff 45 fc             	incl   -0x4(%ebp)
  800c5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c61:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c64:	72 d9                	jb     800c3f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c66:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c69:	c9                   	leave  
  800c6a:	c3                   	ret    

00800c6b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c7b:	74 30                	je     800cad <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c7d:	eb 16                	jmp    800c95 <strlcpy+0x2a>
			*dst++ = *src++;
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	8d 50 01             	lea    0x1(%eax),%edx
  800c85:	89 55 08             	mov    %edx,0x8(%ebp)
  800c88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c8e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c91:	8a 12                	mov    (%edx),%dl
  800c93:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c95:	ff 4d 10             	decl   0x10(%ebp)
  800c98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c9c:	74 09                	je     800ca7 <strlcpy+0x3c>
  800c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca1:	8a 00                	mov    (%eax),%al
  800ca3:	84 c0                	test   %al,%al
  800ca5:	75 d8                	jne    800c7f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cad:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb3:	29 c2                	sub    %eax,%edx
  800cb5:	89 d0                	mov    %edx,%eax
}
  800cb7:	c9                   	leave  
  800cb8:	c3                   	ret    

00800cb9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cbc:	eb 06                	jmp    800cc4 <strcmp+0xb>
		p++, q++;
  800cbe:	ff 45 08             	incl   0x8(%ebp)
  800cc1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8a 00                	mov    (%eax),%al
  800cc9:	84 c0                	test   %al,%al
  800ccb:	74 0e                	je     800cdb <strcmp+0x22>
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	8a 10                	mov    (%eax),%dl
  800cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd5:	8a 00                	mov    (%eax),%al
  800cd7:	38 c2                	cmp    %al,%dl
  800cd9:	74 e3                	je     800cbe <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	8a 00                	mov    (%eax),%al
  800ce0:	0f b6 d0             	movzbl %al,%edx
  800ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce6:	8a 00                	mov    (%eax),%al
  800ce8:	0f b6 c0             	movzbl %al,%eax
  800ceb:	29 c2                	sub    %eax,%edx
  800ced:	89 d0                	mov    %edx,%eax
}
  800cef:	5d                   	pop    %ebp
  800cf0:	c3                   	ret    

00800cf1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cf4:	eb 09                	jmp    800cff <strncmp+0xe>
		n--, p++, q++;
  800cf6:	ff 4d 10             	decl   0x10(%ebp)
  800cf9:	ff 45 08             	incl   0x8(%ebp)
  800cfc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d03:	74 17                	je     800d1c <strncmp+0x2b>
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	84 c0                	test   %al,%al
  800d0c:	74 0e                	je     800d1c <strncmp+0x2b>
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	8a 10                	mov    (%eax),%dl
  800d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	38 c2                	cmp    %al,%dl
  800d1a:	74 da                	je     800cf6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d20:	75 07                	jne    800d29 <strncmp+0x38>
		return 0;
  800d22:	b8 00 00 00 00       	mov    $0x0,%eax
  800d27:	eb 14                	jmp    800d3d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	0f b6 d0             	movzbl %al,%edx
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	0f b6 c0             	movzbl %al,%eax
  800d39:	29 c2                	sub    %eax,%edx
  800d3b:	89 d0                	mov    %edx,%eax
}
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    

00800d3f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	83 ec 04             	sub    $0x4,%esp
  800d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d48:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d4b:	eb 12                	jmp    800d5f <strchr+0x20>
		if (*s == c)
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d55:	75 05                	jne    800d5c <strchr+0x1d>
			return (char *) s;
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	eb 11                	jmp    800d6d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d5c:	ff 45 08             	incl   0x8(%ebp)
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	84 c0                	test   %al,%al
  800d66:	75 e5                	jne    800d4d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d6d:	c9                   	leave  
  800d6e:	c3                   	ret    

00800d6f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	83 ec 04             	sub    $0x4,%esp
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d7b:	eb 0d                	jmp    800d8a <strfind+0x1b>
		if (*s == c)
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	8a 00                	mov    (%eax),%al
  800d82:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d85:	74 0e                	je     800d95 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d87:	ff 45 08             	incl   0x8(%ebp)
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	84 c0                	test   %al,%al
  800d91:	75 ea                	jne    800d7d <strfind+0xe>
  800d93:	eb 01                	jmp    800d96 <strfind+0x27>
		if (*s == c)
			break;
  800d95:	90                   	nop
	return (char *) s;
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d99:	c9                   	leave  
  800d9a:	c3                   	ret    

00800d9b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
  800da4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800da7:	8b 45 10             	mov    0x10(%ebp),%eax
  800daa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dad:	eb 0e                	jmp    800dbd <memset+0x22>
		*p++ = c;
  800daf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db2:	8d 50 01             	lea    0x1(%eax),%edx
  800db5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800db8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dbb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dbd:	ff 4d f8             	decl   -0x8(%ebp)
  800dc0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dc4:	79 e9                	jns    800daf <memset+0x14>
		*p++ = c;

	return v;
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc9:	c9                   	leave  
  800dca:	c3                   	ret    

00800dcb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ddd:	eb 16                	jmp    800df5 <memcpy+0x2a>
		*d++ = *s++;
  800ddf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de2:	8d 50 01             	lea    0x1(%eax),%edx
  800de5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800deb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dee:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800df1:	8a 12                	mov    (%edx),%dl
  800df3:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800df5:	8b 45 10             	mov    0x10(%ebp),%eax
  800df8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dfb:	89 55 10             	mov    %edx,0x10(%ebp)
  800dfe:	85 c0                	test   %eax,%eax
  800e00:	75 dd                	jne    800ddf <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e05:	c9                   	leave  
  800e06:	c3                   	ret    

00800e07 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e07:	55                   	push   %ebp
  800e08:	89 e5                	mov    %esp,%ebp
  800e0a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e19:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e1c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e1f:	73 50                	jae    800e71 <memmove+0x6a>
  800e21:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e24:	8b 45 10             	mov    0x10(%ebp),%eax
  800e27:	01 d0                	add    %edx,%eax
  800e29:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e2c:	76 43                	jbe    800e71 <memmove+0x6a>
		s += n;
  800e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e31:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e34:	8b 45 10             	mov    0x10(%ebp),%eax
  800e37:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e3a:	eb 10                	jmp    800e4c <memmove+0x45>
			*--d = *--s;
  800e3c:	ff 4d f8             	decl   -0x8(%ebp)
  800e3f:	ff 4d fc             	decl   -0x4(%ebp)
  800e42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e45:	8a 10                	mov    (%eax),%dl
  800e47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e4a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e52:	89 55 10             	mov    %edx,0x10(%ebp)
  800e55:	85 c0                	test   %eax,%eax
  800e57:	75 e3                	jne    800e3c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e59:	eb 23                	jmp    800e7e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5e:	8d 50 01             	lea    0x1(%eax),%edx
  800e61:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e64:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e67:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e6a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e6d:	8a 12                	mov    (%edx),%dl
  800e6f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e71:	8b 45 10             	mov    0x10(%ebp),%eax
  800e74:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e77:	89 55 10             	mov    %edx,0x10(%ebp)
  800e7a:	85 c0                	test   %eax,%eax
  800e7c:	75 dd                	jne    800e5b <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e81:	c9                   	leave  
  800e82:	c3                   	ret    

00800e83 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e92:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e95:	eb 2a                	jmp    800ec1 <memcmp+0x3e>
		if (*s1 != *s2)
  800e97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9a:	8a 10                	mov    (%eax),%dl
  800e9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9f:	8a 00                	mov    (%eax),%al
  800ea1:	38 c2                	cmp    %al,%dl
  800ea3:	74 16                	je     800ebb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ea5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea8:	8a 00                	mov    (%eax),%al
  800eaa:	0f b6 d0             	movzbl %al,%edx
  800ead:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb0:	8a 00                	mov    (%eax),%al
  800eb2:	0f b6 c0             	movzbl %al,%eax
  800eb5:	29 c2                	sub    %eax,%edx
  800eb7:	89 d0                	mov    %edx,%eax
  800eb9:	eb 18                	jmp    800ed3 <memcmp+0x50>
		s1++, s2++;
  800ebb:	ff 45 fc             	incl   -0x4(%ebp)
  800ebe:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ec1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec7:	89 55 10             	mov    %edx,0x10(%ebp)
  800eca:	85 c0                	test   %eax,%eax
  800ecc:	75 c9                	jne    800e97 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ece:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ed3:	c9                   	leave  
  800ed4:	c3                   	ret    

00800ed5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ed5:	55                   	push   %ebp
  800ed6:	89 e5                	mov    %esp,%ebp
  800ed8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800edb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ede:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee1:	01 d0                	add    %edx,%eax
  800ee3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ee6:	eb 15                	jmp    800efd <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	0f b6 d0             	movzbl %al,%edx
  800ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef3:	0f b6 c0             	movzbl %al,%eax
  800ef6:	39 c2                	cmp    %eax,%edx
  800ef8:	74 0d                	je     800f07 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800efa:	ff 45 08             	incl   0x8(%ebp)
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f03:	72 e3                	jb     800ee8 <memfind+0x13>
  800f05:	eb 01                	jmp    800f08 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f07:	90                   	nop
	return (void *) s;
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0b:	c9                   	leave  
  800f0c:	c3                   	ret    

00800f0d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f1a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f21:	eb 03                	jmp    800f26 <strtol+0x19>
		s++;
  800f23:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	3c 20                	cmp    $0x20,%al
  800f2d:	74 f4                	je     800f23 <strtol+0x16>
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	3c 09                	cmp    $0x9,%al
  800f36:	74 eb                	je     800f23 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	3c 2b                	cmp    $0x2b,%al
  800f3f:	75 05                	jne    800f46 <strtol+0x39>
		s++;
  800f41:	ff 45 08             	incl   0x8(%ebp)
  800f44:	eb 13                	jmp    800f59 <strtol+0x4c>
	else if (*s == '-')
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	3c 2d                	cmp    $0x2d,%al
  800f4d:	75 0a                	jne    800f59 <strtol+0x4c>
		s++, neg = 1;
  800f4f:	ff 45 08             	incl   0x8(%ebp)
  800f52:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5d:	74 06                	je     800f65 <strtol+0x58>
  800f5f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f63:	75 20                	jne    800f85 <strtol+0x78>
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	3c 30                	cmp    $0x30,%al
  800f6c:	75 17                	jne    800f85 <strtol+0x78>
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	40                   	inc    %eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	3c 78                	cmp    $0x78,%al
  800f76:	75 0d                	jne    800f85 <strtol+0x78>
		s += 2, base = 16;
  800f78:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f7c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f83:	eb 28                	jmp    800fad <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f85:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f89:	75 15                	jne    800fa0 <strtol+0x93>
  800f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8e:	8a 00                	mov    (%eax),%al
  800f90:	3c 30                	cmp    $0x30,%al
  800f92:	75 0c                	jne    800fa0 <strtol+0x93>
		s++, base = 8;
  800f94:	ff 45 08             	incl   0x8(%ebp)
  800f97:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f9e:	eb 0d                	jmp    800fad <strtol+0xa0>
	else if (base == 0)
  800fa0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa4:	75 07                	jne    800fad <strtol+0xa0>
		base = 10;
  800fa6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	3c 2f                	cmp    $0x2f,%al
  800fb4:	7e 19                	jle    800fcf <strtol+0xc2>
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	3c 39                	cmp    $0x39,%al
  800fbd:	7f 10                	jg     800fcf <strtol+0xc2>
			dig = *s - '0';
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	0f be c0             	movsbl %al,%eax
  800fc7:	83 e8 30             	sub    $0x30,%eax
  800fca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fcd:	eb 42                	jmp    801011 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	3c 60                	cmp    $0x60,%al
  800fd6:	7e 19                	jle    800ff1 <strtol+0xe4>
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	3c 7a                	cmp    $0x7a,%al
  800fdf:	7f 10                	jg     800ff1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	0f be c0             	movsbl %al,%eax
  800fe9:	83 e8 57             	sub    $0x57,%eax
  800fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fef:	eb 20                	jmp    801011 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 40                	cmp    $0x40,%al
  800ff8:	7e 39                	jle    801033 <strtol+0x126>
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	3c 5a                	cmp    $0x5a,%al
  801001:	7f 30                	jg     801033 <strtol+0x126>
			dig = *s - 'A' + 10;
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	0f be c0             	movsbl %al,%eax
  80100b:	83 e8 37             	sub    $0x37,%eax
  80100e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801014:	3b 45 10             	cmp    0x10(%ebp),%eax
  801017:	7d 19                	jge    801032 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801019:	ff 45 08             	incl   0x8(%ebp)
  80101c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801023:	89 c2                	mov    %eax,%edx
  801025:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801028:	01 d0                	add    %edx,%eax
  80102a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80102d:	e9 7b ff ff ff       	jmp    800fad <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801032:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801033:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801037:	74 08                	je     801041 <strtol+0x134>
		*endptr = (char *) s;
  801039:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103c:	8b 55 08             	mov    0x8(%ebp),%edx
  80103f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801041:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801045:	74 07                	je     80104e <strtol+0x141>
  801047:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104a:	f7 d8                	neg    %eax
  80104c:	eb 03                	jmp    801051 <strtol+0x144>
  80104e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801051:	c9                   	leave  
  801052:	c3                   	ret    

00801053 <ltostr>:

void
ltostr(long value, char *str)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801059:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801060:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801067:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80106b:	79 13                	jns    801080 <ltostr+0x2d>
	{
		neg = 1;
  80106d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801074:	8b 45 0c             	mov    0xc(%ebp),%eax
  801077:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80107a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80107d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
  801083:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801088:	99                   	cltd   
  801089:	f7 f9                	idiv   %ecx
  80108b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80108e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801091:	8d 50 01             	lea    0x1(%eax),%edx
  801094:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801097:	89 c2                	mov    %eax,%edx
  801099:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109c:	01 d0                	add    %edx,%eax
  80109e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010a1:	83 c2 30             	add    $0x30,%edx
  8010a4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ae:	f7 e9                	imul   %ecx
  8010b0:	c1 fa 02             	sar    $0x2,%edx
  8010b3:	89 c8                	mov    %ecx,%eax
  8010b5:	c1 f8 1f             	sar    $0x1f,%eax
  8010b8:	29 c2                	sub    %eax,%edx
  8010ba:	89 d0                	mov    %edx,%eax
  8010bc:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c7:	f7 e9                	imul   %ecx
  8010c9:	c1 fa 02             	sar    $0x2,%edx
  8010cc:	89 c8                	mov    %ecx,%eax
  8010ce:	c1 f8 1f             	sar    $0x1f,%eax
  8010d1:	29 c2                	sub    %eax,%edx
  8010d3:	89 d0                	mov    %edx,%eax
  8010d5:	c1 e0 02             	shl    $0x2,%eax
  8010d8:	01 d0                	add    %edx,%eax
  8010da:	01 c0                	add    %eax,%eax
  8010dc:	29 c1                	sub    %eax,%ecx
  8010de:	89 ca                	mov    %ecx,%edx
  8010e0:	85 d2                	test   %edx,%edx
  8010e2:	75 9c                	jne    801080 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ee:	48                   	dec    %eax
  8010ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f6:	74 3d                	je     801135 <ltostr+0xe2>
		start = 1 ;
  8010f8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010ff:	eb 34                	jmp    801135 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801101:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801104:	8b 45 0c             	mov    0xc(%ebp),%eax
  801107:	01 d0                	add    %edx,%eax
  801109:	8a 00                	mov    (%eax),%al
  80110b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80110e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801111:	8b 45 0c             	mov    0xc(%ebp),%eax
  801114:	01 c2                	add    %eax,%edx
  801116:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111c:	01 c8                	add    %ecx,%eax
  80111e:	8a 00                	mov    (%eax),%al
  801120:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801122:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801125:	8b 45 0c             	mov    0xc(%ebp),%eax
  801128:	01 c2                	add    %eax,%edx
  80112a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80112d:	88 02                	mov    %al,(%edx)
		start++ ;
  80112f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801132:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801138:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80113b:	7c c4                	jl     801101 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80113d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801140:	8b 45 0c             	mov    0xc(%ebp),%eax
  801143:	01 d0                	add    %edx,%eax
  801145:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801148:	90                   	nop
  801149:	c9                   	leave  
  80114a:	c3                   	ret    

0080114b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80114b:	55                   	push   %ebp
  80114c:	89 e5                	mov    %esp,%ebp
  80114e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801151:	ff 75 08             	pushl  0x8(%ebp)
  801154:	e8 54 fa ff ff       	call   800bad <strlen>
  801159:	83 c4 04             	add    $0x4,%esp
  80115c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80115f:	ff 75 0c             	pushl  0xc(%ebp)
  801162:	e8 46 fa ff ff       	call   800bad <strlen>
  801167:	83 c4 04             	add    $0x4,%esp
  80116a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80116d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801174:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80117b:	eb 17                	jmp    801194 <strcconcat+0x49>
		final[s] = str1[s] ;
  80117d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801180:	8b 45 10             	mov    0x10(%ebp),%eax
  801183:	01 c2                	add    %eax,%edx
  801185:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	01 c8                	add    %ecx,%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801191:	ff 45 fc             	incl   -0x4(%ebp)
  801194:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801197:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80119a:	7c e1                	jl     80117d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80119c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011aa:	eb 1f                	jmp    8011cb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011af:	8d 50 01             	lea    0x1(%eax),%edx
  8011b2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011b5:	89 c2                	mov    %eax,%edx
  8011b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ba:	01 c2                	add    %eax,%edx
  8011bc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c2:	01 c8                	add    %ecx,%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011c8:	ff 45 f8             	incl   -0x8(%ebp)
  8011cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ce:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d1:	7c d9                	jl     8011ac <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d9:	01 d0                	add    %edx,%eax
  8011db:	c6 00 00             	movb   $0x0,(%eax)
}
  8011de:	90                   	nop
  8011df:	c9                   	leave  
  8011e0:	c3                   	ret    

008011e1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f0:	8b 00                	mov    (%eax),%eax
  8011f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fc:	01 d0                	add    %edx,%eax
  8011fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801204:	eb 0c                	jmp    801212 <strsplit+0x31>
			*string++ = 0;
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8d 50 01             	lea    0x1(%eax),%edx
  80120c:	89 55 08             	mov    %edx,0x8(%ebp)
  80120f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	84 c0                	test   %al,%al
  801219:	74 18                	je     801233 <strsplit+0x52>
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	0f be c0             	movsbl %al,%eax
  801223:	50                   	push   %eax
  801224:	ff 75 0c             	pushl  0xc(%ebp)
  801227:	e8 13 fb ff ff       	call   800d3f <strchr>
  80122c:	83 c4 08             	add    $0x8,%esp
  80122f:	85 c0                	test   %eax,%eax
  801231:	75 d3                	jne    801206 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	84 c0                	test   %al,%al
  80123a:	74 5a                	je     801296 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80123c:	8b 45 14             	mov    0x14(%ebp),%eax
  80123f:	8b 00                	mov    (%eax),%eax
  801241:	83 f8 0f             	cmp    $0xf,%eax
  801244:	75 07                	jne    80124d <strsplit+0x6c>
		{
			return 0;
  801246:	b8 00 00 00 00       	mov    $0x0,%eax
  80124b:	eb 66                	jmp    8012b3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80124d:	8b 45 14             	mov    0x14(%ebp),%eax
  801250:	8b 00                	mov    (%eax),%eax
  801252:	8d 48 01             	lea    0x1(%eax),%ecx
  801255:	8b 55 14             	mov    0x14(%ebp),%edx
  801258:	89 0a                	mov    %ecx,(%edx)
  80125a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801261:	8b 45 10             	mov    0x10(%ebp),%eax
  801264:	01 c2                	add    %eax,%edx
  801266:	8b 45 08             	mov    0x8(%ebp),%eax
  801269:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80126b:	eb 03                	jmp    801270 <strsplit+0x8f>
			string++;
  80126d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	84 c0                	test   %al,%al
  801277:	74 8b                	je     801204 <strsplit+0x23>
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	0f be c0             	movsbl %al,%eax
  801281:	50                   	push   %eax
  801282:	ff 75 0c             	pushl  0xc(%ebp)
  801285:	e8 b5 fa ff ff       	call   800d3f <strchr>
  80128a:	83 c4 08             	add    $0x8,%esp
  80128d:	85 c0                	test   %eax,%eax
  80128f:	74 dc                	je     80126d <strsplit+0x8c>
			string++;
	}
  801291:	e9 6e ff ff ff       	jmp    801204 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801296:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801297:	8b 45 14             	mov    0x14(%ebp),%eax
  80129a:	8b 00                	mov    (%eax),%eax
  80129c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a6:	01 d0                	add    %edx,%eax
  8012a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012ae:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012b3:	c9                   	leave  
  8012b4:	c3                   	ret    

008012b5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012b5:	55                   	push   %ebp
  8012b6:	89 e5                	mov    %esp,%ebp
  8012b8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012bb:	a1 04 40 80 00       	mov    0x804004,%eax
  8012c0:	85 c0                	test   %eax,%eax
  8012c2:	74 1f                	je     8012e3 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012c4:	e8 1d 00 00 00       	call   8012e6 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012c9:	83 ec 0c             	sub    $0xc,%esp
  8012cc:	68 50 38 80 00       	push   $0x803850
  8012d1:	e8 55 f2 ff ff       	call   80052b <cprintf>
  8012d6:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012d9:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012e0:	00 00 00 
	}
}
  8012e3:	90                   	nop
  8012e4:	c9                   	leave  
  8012e5:	c3                   	ret    

008012e6 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
  8012e9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  8012ec:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8012f3:	00 00 00 
  8012f6:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8012fd:	00 00 00 
  801300:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801307:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80130a:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801311:	00 00 00 
  801314:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80131b:	00 00 00 
  80131e:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801325:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801328:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80132f:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801332:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801341:	2d 00 10 00 00       	sub    $0x1000,%eax
  801346:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  80134b:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801352:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801355:	a1 20 41 80 00       	mov    0x804120,%eax
  80135a:	0f af c2             	imul   %edx,%eax
  80135d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801360:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801367:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80136a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80136d:	01 d0                	add    %edx,%eax
  80136f:	48                   	dec    %eax
  801370:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801373:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801376:	ba 00 00 00 00       	mov    $0x0,%edx
  80137b:	f7 75 e8             	divl   -0x18(%ebp)
  80137e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801381:	29 d0                	sub    %edx,%eax
  801383:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801386:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801389:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801390:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801393:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801399:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  80139f:	83 ec 04             	sub    $0x4,%esp
  8013a2:	6a 06                	push   $0x6
  8013a4:	50                   	push   %eax
  8013a5:	52                   	push   %edx
  8013a6:	e8 a1 05 00 00       	call   80194c <sys_allocate_chunk>
  8013ab:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013ae:	a1 20 41 80 00       	mov    0x804120,%eax
  8013b3:	83 ec 0c             	sub    $0xc,%esp
  8013b6:	50                   	push   %eax
  8013b7:	e8 16 0c 00 00       	call   801fd2 <initialize_MemBlocksList>
  8013bc:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  8013bf:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8013c4:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  8013c7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8013cb:	75 14                	jne    8013e1 <initialize_dyn_block_system+0xfb>
  8013cd:	83 ec 04             	sub    $0x4,%esp
  8013d0:	68 75 38 80 00       	push   $0x803875
  8013d5:	6a 2d                	push   $0x2d
  8013d7:	68 93 38 80 00       	push   $0x803893
  8013dc:	e8 96 ee ff ff       	call   800277 <_panic>
  8013e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013e4:	8b 00                	mov    (%eax),%eax
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	74 10                	je     8013fa <initialize_dyn_block_system+0x114>
  8013ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013ed:	8b 00                	mov    (%eax),%eax
  8013ef:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8013f2:	8b 52 04             	mov    0x4(%edx),%edx
  8013f5:	89 50 04             	mov    %edx,0x4(%eax)
  8013f8:	eb 0b                	jmp    801405 <initialize_dyn_block_system+0x11f>
  8013fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013fd:	8b 40 04             	mov    0x4(%eax),%eax
  801400:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801405:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801408:	8b 40 04             	mov    0x4(%eax),%eax
  80140b:	85 c0                	test   %eax,%eax
  80140d:	74 0f                	je     80141e <initialize_dyn_block_system+0x138>
  80140f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801412:	8b 40 04             	mov    0x4(%eax),%eax
  801415:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801418:	8b 12                	mov    (%edx),%edx
  80141a:	89 10                	mov    %edx,(%eax)
  80141c:	eb 0a                	jmp    801428 <initialize_dyn_block_system+0x142>
  80141e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801421:	8b 00                	mov    (%eax),%eax
  801423:	a3 48 41 80 00       	mov    %eax,0x804148
  801428:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80142b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801431:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801434:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80143b:	a1 54 41 80 00       	mov    0x804154,%eax
  801440:	48                   	dec    %eax
  801441:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801446:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801449:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801450:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801453:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  80145a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80145e:	75 14                	jne    801474 <initialize_dyn_block_system+0x18e>
  801460:	83 ec 04             	sub    $0x4,%esp
  801463:	68 a0 38 80 00       	push   $0x8038a0
  801468:	6a 30                	push   $0x30
  80146a:	68 93 38 80 00       	push   $0x803893
  80146f:	e8 03 ee ff ff       	call   800277 <_panic>
  801474:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80147a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80147d:	89 50 04             	mov    %edx,0x4(%eax)
  801480:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801483:	8b 40 04             	mov    0x4(%eax),%eax
  801486:	85 c0                	test   %eax,%eax
  801488:	74 0c                	je     801496 <initialize_dyn_block_system+0x1b0>
  80148a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80148f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801492:	89 10                	mov    %edx,(%eax)
  801494:	eb 08                	jmp    80149e <initialize_dyn_block_system+0x1b8>
  801496:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801499:	a3 38 41 80 00       	mov    %eax,0x804138
  80149e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014a1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8014a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014af:	a1 44 41 80 00       	mov    0x804144,%eax
  8014b4:	40                   	inc    %eax
  8014b5:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8014ba:	90                   	nop
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    

008014bd <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014c3:	e8 ed fd ff ff       	call   8012b5 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014cc:	75 07                	jne    8014d5 <malloc+0x18>
  8014ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d3:	eb 67                	jmp    80153c <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  8014d5:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8014df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e2:	01 d0                	add    %edx,%eax
  8014e4:	48                   	dec    %eax
  8014e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f0:	f7 75 f4             	divl   -0xc(%ebp)
  8014f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f6:	29 d0                	sub    %edx,%eax
  8014f8:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014fb:	e8 1a 08 00 00       	call   801d1a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801500:	85 c0                	test   %eax,%eax
  801502:	74 33                	je     801537 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801504:	83 ec 0c             	sub    $0xc,%esp
  801507:	ff 75 08             	pushl  0x8(%ebp)
  80150a:	e8 0c 0e 00 00       	call   80231b <alloc_block_FF>
  80150f:	83 c4 10             	add    $0x10,%esp
  801512:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801515:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801519:	74 1c                	je     801537 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  80151b:	83 ec 0c             	sub    $0xc,%esp
  80151e:	ff 75 ec             	pushl  -0x14(%ebp)
  801521:	e8 07 0c 00 00       	call   80212d <insert_sorted_allocList>
  801526:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801529:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80152c:	8b 40 08             	mov    0x8(%eax),%eax
  80152f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801532:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801535:	eb 05                	jmp    80153c <malloc+0x7f>
		}
	}
	return NULL;
  801537:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80153c:	c9                   	leave  
  80153d:	c3                   	ret    

0080153e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
  801541:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  80154a:	83 ec 08             	sub    $0x8,%esp
  80154d:	ff 75 f4             	pushl  -0xc(%ebp)
  801550:	68 40 40 80 00       	push   $0x804040
  801555:	e8 5b 0b 00 00       	call   8020b5 <find_block>
  80155a:	83 c4 10             	add    $0x10,%esp
  80155d:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801560:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801563:	8b 40 0c             	mov    0xc(%eax),%eax
  801566:	83 ec 08             	sub    $0x8,%esp
  801569:	50                   	push   %eax
  80156a:	ff 75 f4             	pushl  -0xc(%ebp)
  80156d:	e8 a2 03 00 00       	call   801914 <sys_free_user_mem>
  801572:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801575:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801579:	75 14                	jne    80158f <free+0x51>
  80157b:	83 ec 04             	sub    $0x4,%esp
  80157e:	68 75 38 80 00       	push   $0x803875
  801583:	6a 76                	push   $0x76
  801585:	68 93 38 80 00       	push   $0x803893
  80158a:	e8 e8 ec ff ff       	call   800277 <_panic>
  80158f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801592:	8b 00                	mov    (%eax),%eax
  801594:	85 c0                	test   %eax,%eax
  801596:	74 10                	je     8015a8 <free+0x6a>
  801598:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159b:	8b 00                	mov    (%eax),%eax
  80159d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015a0:	8b 52 04             	mov    0x4(%edx),%edx
  8015a3:	89 50 04             	mov    %edx,0x4(%eax)
  8015a6:	eb 0b                	jmp    8015b3 <free+0x75>
  8015a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ab:	8b 40 04             	mov    0x4(%eax),%eax
  8015ae:	a3 44 40 80 00       	mov    %eax,0x804044
  8015b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b6:	8b 40 04             	mov    0x4(%eax),%eax
  8015b9:	85 c0                	test   %eax,%eax
  8015bb:	74 0f                	je     8015cc <free+0x8e>
  8015bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c0:	8b 40 04             	mov    0x4(%eax),%eax
  8015c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015c6:	8b 12                	mov    (%edx),%edx
  8015c8:	89 10                	mov    %edx,(%eax)
  8015ca:	eb 0a                	jmp    8015d6 <free+0x98>
  8015cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cf:	8b 00                	mov    (%eax),%eax
  8015d1:	a3 40 40 80 00       	mov    %eax,0x804040
  8015d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015e9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015ee:	48                   	dec    %eax
  8015ef:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  8015f4:	83 ec 0c             	sub    $0xc,%esp
  8015f7:	ff 75 f0             	pushl  -0x10(%ebp)
  8015fa:	e8 0b 14 00 00       	call   802a0a <insert_sorted_with_merge_freeList>
  8015ff:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801602:	90                   	nop
  801603:	c9                   	leave  
  801604:	c3                   	ret    

00801605 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
  801608:	83 ec 28             	sub    $0x28,%esp
  80160b:	8b 45 10             	mov    0x10(%ebp),%eax
  80160e:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801611:	e8 9f fc ff ff       	call   8012b5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801616:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80161a:	75 0a                	jne    801626 <smalloc+0x21>
  80161c:	b8 00 00 00 00       	mov    $0x0,%eax
  801621:	e9 8d 00 00 00       	jmp    8016b3 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801626:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80162d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801633:	01 d0                	add    %edx,%eax
  801635:	48                   	dec    %eax
  801636:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801639:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163c:	ba 00 00 00 00       	mov    $0x0,%edx
  801641:	f7 75 f4             	divl   -0xc(%ebp)
  801644:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801647:	29 d0                	sub    %edx,%eax
  801649:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80164c:	e8 c9 06 00 00       	call   801d1a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801651:	85 c0                	test   %eax,%eax
  801653:	74 59                	je     8016ae <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801655:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  80165c:	83 ec 0c             	sub    $0xc,%esp
  80165f:	ff 75 0c             	pushl  0xc(%ebp)
  801662:	e8 b4 0c 00 00       	call   80231b <alloc_block_FF>
  801667:	83 c4 10             	add    $0x10,%esp
  80166a:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  80166d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801671:	75 07                	jne    80167a <smalloc+0x75>
			{
				return NULL;
  801673:	b8 00 00 00 00       	mov    $0x0,%eax
  801678:	eb 39                	jmp    8016b3 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  80167a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80167d:	8b 40 08             	mov    0x8(%eax),%eax
  801680:	89 c2                	mov    %eax,%edx
  801682:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801686:	52                   	push   %edx
  801687:	50                   	push   %eax
  801688:	ff 75 0c             	pushl  0xc(%ebp)
  80168b:	ff 75 08             	pushl  0x8(%ebp)
  80168e:	e8 0c 04 00 00       	call   801a9f <sys_createSharedObject>
  801693:	83 c4 10             	add    $0x10,%esp
  801696:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  801699:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80169d:	78 08                	js     8016a7 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  80169f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a2:	8b 40 08             	mov    0x8(%eax),%eax
  8016a5:	eb 0c                	jmp    8016b3 <smalloc+0xae>
				}
				else
				{
					return NULL;
  8016a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ac:	eb 05                	jmp    8016b3 <smalloc+0xae>
				}
			}

		}
		return NULL;
  8016ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
  8016b8:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016bb:	e8 f5 fb ff ff       	call   8012b5 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016c0:	83 ec 08             	sub    $0x8,%esp
  8016c3:	ff 75 0c             	pushl  0xc(%ebp)
  8016c6:	ff 75 08             	pushl  0x8(%ebp)
  8016c9:	e8 fb 03 00 00       	call   801ac9 <sys_getSizeOfSharedObject>
  8016ce:	83 c4 10             	add    $0x10,%esp
  8016d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  8016d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016d8:	75 07                	jne    8016e1 <sget+0x2c>
	{
		return NULL;
  8016da:	b8 00 00 00 00       	mov    $0x0,%eax
  8016df:	eb 64                	jmp    801745 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016e1:	e8 34 06 00 00       	call   801d1a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016e6:	85 c0                	test   %eax,%eax
  8016e8:	74 56                	je     801740 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  8016ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  8016f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f4:	83 ec 0c             	sub    $0xc,%esp
  8016f7:	50                   	push   %eax
  8016f8:	e8 1e 0c 00 00       	call   80231b <alloc_block_FF>
  8016fd:	83 c4 10             	add    $0x10,%esp
  801700:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801703:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801707:	75 07                	jne    801710 <sget+0x5b>
		{
		return NULL;
  801709:	b8 00 00 00 00       	mov    $0x0,%eax
  80170e:	eb 35                	jmp    801745 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801710:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801713:	8b 40 08             	mov    0x8(%eax),%eax
  801716:	83 ec 04             	sub    $0x4,%esp
  801719:	50                   	push   %eax
  80171a:	ff 75 0c             	pushl  0xc(%ebp)
  80171d:	ff 75 08             	pushl  0x8(%ebp)
  801720:	e8 c1 03 00 00       	call   801ae6 <sys_getSharedObject>
  801725:	83 c4 10             	add    $0x10,%esp
  801728:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  80172b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80172f:	78 08                	js     801739 <sget+0x84>
			{
				return (void*)v1->sva;
  801731:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801734:	8b 40 08             	mov    0x8(%eax),%eax
  801737:	eb 0c                	jmp    801745 <sget+0x90>
			}
			else
			{
				return NULL;
  801739:	b8 00 00 00 00       	mov    $0x0,%eax
  80173e:	eb 05                	jmp    801745 <sget+0x90>
			}
		}
	}
  return NULL;
  801740:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80174d:	e8 63 fb ff ff       	call   8012b5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801752:	83 ec 04             	sub    $0x4,%esp
  801755:	68 c4 38 80 00       	push   $0x8038c4
  80175a:	68 0e 01 00 00       	push   $0x10e
  80175f:	68 93 38 80 00       	push   $0x803893
  801764:	e8 0e eb ff ff       	call   800277 <_panic>

00801769 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
  80176c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80176f:	83 ec 04             	sub    $0x4,%esp
  801772:	68 ec 38 80 00       	push   $0x8038ec
  801777:	68 22 01 00 00       	push   $0x122
  80177c:	68 93 38 80 00       	push   $0x803893
  801781:	e8 f1 ea ff ff       	call   800277 <_panic>

00801786 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80178c:	83 ec 04             	sub    $0x4,%esp
  80178f:	68 10 39 80 00       	push   $0x803910
  801794:	68 2d 01 00 00       	push   $0x12d
  801799:	68 93 38 80 00       	push   $0x803893
  80179e:	e8 d4 ea ff ff       	call   800277 <_panic>

008017a3 <shrink>:

}
void shrink(uint32 newSize)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017a9:	83 ec 04             	sub    $0x4,%esp
  8017ac:	68 10 39 80 00       	push   $0x803910
  8017b1:	68 32 01 00 00       	push   $0x132
  8017b6:	68 93 38 80 00       	push   $0x803893
  8017bb:	e8 b7 ea ff ff       	call   800277 <_panic>

008017c0 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c6:	83 ec 04             	sub    $0x4,%esp
  8017c9:	68 10 39 80 00       	push   $0x803910
  8017ce:	68 37 01 00 00       	push   $0x137
  8017d3:	68 93 38 80 00       	push   $0x803893
  8017d8:	e8 9a ea ff ff       	call   800277 <_panic>

008017dd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
  8017e0:	57                   	push   %edi
  8017e1:	56                   	push   %esi
  8017e2:	53                   	push   %ebx
  8017e3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ef:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017f2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017f5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017f8:	cd 30                	int    $0x30
  8017fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801800:	83 c4 10             	add    $0x10,%esp
  801803:	5b                   	pop    %ebx
  801804:	5e                   	pop    %esi
  801805:	5f                   	pop    %edi
  801806:	5d                   	pop    %ebp
  801807:	c3                   	ret    

00801808 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
  80180b:	83 ec 04             	sub    $0x4,%esp
  80180e:	8b 45 10             	mov    0x10(%ebp),%eax
  801811:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801814:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801818:	8b 45 08             	mov    0x8(%ebp),%eax
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	52                   	push   %edx
  801820:	ff 75 0c             	pushl  0xc(%ebp)
  801823:	50                   	push   %eax
  801824:	6a 00                	push   $0x0
  801826:	e8 b2 ff ff ff       	call   8017dd <syscall>
  80182b:	83 c4 18             	add    $0x18,%esp
}
  80182e:	90                   	nop
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sys_cgetc>:

int
sys_cgetc(void)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 01                	push   $0x1
  801840:	e8 98 ff ff ff       	call   8017dd <syscall>
  801845:	83 c4 18             	add    $0x18,%esp
}
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80184d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	52                   	push   %edx
  80185a:	50                   	push   %eax
  80185b:	6a 05                	push   $0x5
  80185d:	e8 7b ff ff ff       	call   8017dd <syscall>
  801862:	83 c4 18             	add    $0x18,%esp
}
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	56                   	push   %esi
  80186b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80186c:	8b 75 18             	mov    0x18(%ebp),%esi
  80186f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801872:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801875:	8b 55 0c             	mov    0xc(%ebp),%edx
  801878:	8b 45 08             	mov    0x8(%ebp),%eax
  80187b:	56                   	push   %esi
  80187c:	53                   	push   %ebx
  80187d:	51                   	push   %ecx
  80187e:	52                   	push   %edx
  80187f:	50                   	push   %eax
  801880:	6a 06                	push   $0x6
  801882:	e8 56 ff ff ff       	call   8017dd <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
}
  80188a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80188d:	5b                   	pop    %ebx
  80188e:	5e                   	pop    %esi
  80188f:	5d                   	pop    %ebp
  801890:	c3                   	ret    

00801891 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801894:	8b 55 0c             	mov    0xc(%ebp),%edx
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	52                   	push   %edx
  8018a1:	50                   	push   %eax
  8018a2:	6a 07                	push   $0x7
  8018a4:	e8 34 ff ff ff       	call   8017dd <syscall>
  8018a9:	83 c4 18             	add    $0x18,%esp
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ba:	ff 75 08             	pushl  0x8(%ebp)
  8018bd:	6a 08                	push   $0x8
  8018bf:	e8 19 ff ff ff       	call   8017dd <syscall>
  8018c4:	83 c4 18             	add    $0x18,%esp
}
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 09                	push   $0x9
  8018d8:	e8 00 ff ff ff       	call   8017dd <syscall>
  8018dd:	83 c4 18             	add    $0x18,%esp
}
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 0a                	push   $0xa
  8018f1:	e8 e7 fe ff ff       	call   8017dd <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 0b                	push   $0xb
  80190a:	e8 ce fe ff ff       	call   8017dd <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	ff 75 0c             	pushl  0xc(%ebp)
  801920:	ff 75 08             	pushl  0x8(%ebp)
  801923:	6a 0f                	push   $0xf
  801925:	e8 b3 fe ff ff       	call   8017dd <syscall>
  80192a:	83 c4 18             	add    $0x18,%esp
	return;
  80192d:	90                   	nop
}
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	ff 75 0c             	pushl  0xc(%ebp)
  80193c:	ff 75 08             	pushl  0x8(%ebp)
  80193f:	6a 10                	push   $0x10
  801941:	e8 97 fe ff ff       	call   8017dd <syscall>
  801946:	83 c4 18             	add    $0x18,%esp
	return ;
  801949:	90                   	nop
}
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	ff 75 10             	pushl  0x10(%ebp)
  801956:	ff 75 0c             	pushl  0xc(%ebp)
  801959:	ff 75 08             	pushl  0x8(%ebp)
  80195c:	6a 11                	push   $0x11
  80195e:	e8 7a fe ff ff       	call   8017dd <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
	return ;
  801966:	90                   	nop
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 0c                	push   $0xc
  801978:	e8 60 fe ff ff       	call   8017dd <syscall>
  80197d:	83 c4 18             	add    $0x18,%esp
}
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	ff 75 08             	pushl  0x8(%ebp)
  801990:	6a 0d                	push   $0xd
  801992:	e8 46 fe ff ff       	call   8017dd <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 0e                	push   $0xe
  8019ab:	e8 2d fe ff ff       	call   8017dd <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
}
  8019b3:	90                   	nop
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 13                	push   $0x13
  8019c5:	e8 13 fe ff ff       	call   8017dd <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
}
  8019cd:	90                   	nop
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 14                	push   $0x14
  8019df:	e8 f9 fd ff ff       	call   8017dd <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
}
  8019e7:	90                   	nop
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_cputc>:


void
sys_cputc(const char c)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	83 ec 04             	sub    $0x4,%esp
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019f6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	50                   	push   %eax
  801a03:	6a 15                	push   $0x15
  801a05:	e8 d3 fd ff ff       	call   8017dd <syscall>
  801a0a:	83 c4 18             	add    $0x18,%esp
}
  801a0d:	90                   	nop
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 16                	push   $0x16
  801a1f:	e8 b9 fd ff ff       	call   8017dd <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	90                   	nop
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	ff 75 0c             	pushl  0xc(%ebp)
  801a39:	50                   	push   %eax
  801a3a:	6a 17                	push   $0x17
  801a3c:	e8 9c fd ff ff       	call   8017dd <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	52                   	push   %edx
  801a56:	50                   	push   %eax
  801a57:	6a 1a                	push   $0x1a
  801a59:	e8 7f fd ff ff       	call   8017dd <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	52                   	push   %edx
  801a73:	50                   	push   %eax
  801a74:	6a 18                	push   $0x18
  801a76:	e8 62 fd ff ff       	call   8017dd <syscall>
  801a7b:	83 c4 18             	add    $0x18,%esp
}
  801a7e:	90                   	nop
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	52                   	push   %edx
  801a91:	50                   	push   %eax
  801a92:	6a 19                	push   $0x19
  801a94:	e8 44 fd ff ff       	call   8017dd <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
}
  801a9c:	90                   	nop
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
  801aa2:	83 ec 04             	sub    $0x4,%esp
  801aa5:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801aab:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aae:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab5:	6a 00                	push   $0x0
  801ab7:	51                   	push   %ecx
  801ab8:	52                   	push   %edx
  801ab9:	ff 75 0c             	pushl  0xc(%ebp)
  801abc:	50                   	push   %eax
  801abd:	6a 1b                	push   $0x1b
  801abf:	e8 19 fd ff ff       	call   8017dd <syscall>
  801ac4:	83 c4 18             	add    $0x18,%esp
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801acc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	52                   	push   %edx
  801ad9:	50                   	push   %eax
  801ada:	6a 1c                	push   $0x1c
  801adc:	e8 fc fc ff ff       	call   8017dd <syscall>
  801ae1:	83 c4 18             	add    $0x18,%esp
}
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ae9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	51                   	push   %ecx
  801af7:	52                   	push   %edx
  801af8:	50                   	push   %eax
  801af9:	6a 1d                	push   $0x1d
  801afb:	e8 dd fc ff ff       	call   8017dd <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	52                   	push   %edx
  801b15:	50                   	push   %eax
  801b16:	6a 1e                	push   $0x1e
  801b18:	e8 c0 fc ff ff       	call   8017dd <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
}
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 1f                	push   $0x1f
  801b31:	e8 a7 fc ff ff       	call   8017dd <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	6a 00                	push   $0x0
  801b43:	ff 75 14             	pushl  0x14(%ebp)
  801b46:	ff 75 10             	pushl  0x10(%ebp)
  801b49:	ff 75 0c             	pushl  0xc(%ebp)
  801b4c:	50                   	push   %eax
  801b4d:	6a 20                	push   $0x20
  801b4f:	e8 89 fc ff ff       	call   8017dd <syscall>
  801b54:	83 c4 18             	add    $0x18,%esp
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	50                   	push   %eax
  801b68:	6a 21                	push   $0x21
  801b6a:	e8 6e fc ff ff       	call   8017dd <syscall>
  801b6f:	83 c4 18             	add    $0x18,%esp
}
  801b72:	90                   	nop
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b78:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	50                   	push   %eax
  801b84:	6a 22                	push   $0x22
  801b86:	e8 52 fc ff ff       	call   8017dd <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 02                	push   $0x2
  801b9f:	e8 39 fc ff ff       	call   8017dd <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 03                	push   $0x3
  801bb8:	e8 20 fc ff ff       	call   8017dd <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
}
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 04                	push   $0x4
  801bd1:	e8 07 fc ff ff       	call   8017dd <syscall>
  801bd6:	83 c4 18             	add    $0x18,%esp
}
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <sys_exit_env>:


void sys_exit_env(void)
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 23                	push   $0x23
  801bea:	e8 ee fb ff ff       	call   8017dd <syscall>
  801bef:	83 c4 18             	add    $0x18,%esp
}
  801bf2:	90                   	nop
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
  801bf8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bfb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bfe:	8d 50 04             	lea    0x4(%eax),%edx
  801c01:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	52                   	push   %edx
  801c0b:	50                   	push   %eax
  801c0c:	6a 24                	push   $0x24
  801c0e:	e8 ca fb ff ff       	call   8017dd <syscall>
  801c13:	83 c4 18             	add    $0x18,%esp
	return result;
  801c16:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c19:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c1c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c1f:	89 01                	mov    %eax,(%ecx)
  801c21:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	c9                   	leave  
  801c28:	c2 04 00             	ret    $0x4

00801c2b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	ff 75 10             	pushl  0x10(%ebp)
  801c35:	ff 75 0c             	pushl  0xc(%ebp)
  801c38:	ff 75 08             	pushl  0x8(%ebp)
  801c3b:	6a 12                	push   $0x12
  801c3d:	e8 9b fb ff ff       	call   8017dd <syscall>
  801c42:	83 c4 18             	add    $0x18,%esp
	return ;
  801c45:	90                   	nop
}
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 25                	push   $0x25
  801c57:	e8 81 fb ff ff       	call   8017dd <syscall>
  801c5c:	83 c4 18             	add    $0x18,%esp
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
  801c64:	83 ec 04             	sub    $0x4,%esp
  801c67:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c6d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	50                   	push   %eax
  801c7a:	6a 26                	push   $0x26
  801c7c:	e8 5c fb ff ff       	call   8017dd <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
	return ;
  801c84:	90                   	nop
}
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <rsttst>:
void rsttst()
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 28                	push   $0x28
  801c96:	e8 42 fb ff ff       	call   8017dd <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9e:	90                   	nop
}
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
  801ca4:	83 ec 04             	sub    $0x4,%esp
  801ca7:	8b 45 14             	mov    0x14(%ebp),%eax
  801caa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cad:	8b 55 18             	mov    0x18(%ebp),%edx
  801cb0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cb4:	52                   	push   %edx
  801cb5:	50                   	push   %eax
  801cb6:	ff 75 10             	pushl  0x10(%ebp)
  801cb9:	ff 75 0c             	pushl  0xc(%ebp)
  801cbc:	ff 75 08             	pushl  0x8(%ebp)
  801cbf:	6a 27                	push   $0x27
  801cc1:	e8 17 fb ff ff       	call   8017dd <syscall>
  801cc6:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc9:	90                   	nop
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <chktst>:
void chktst(uint32 n)
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	ff 75 08             	pushl  0x8(%ebp)
  801cda:	6a 29                	push   $0x29
  801cdc:	e8 fc fa ff ff       	call   8017dd <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce4:	90                   	nop
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <inctst>:

void inctst()
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 2a                	push   $0x2a
  801cf6:	e8 e2 fa ff ff       	call   8017dd <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfe:	90                   	nop
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <gettst>:
uint32 gettst()
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 2b                	push   $0x2b
  801d10:	e8 c8 fa ff ff       	call   8017dd <syscall>
  801d15:	83 c4 18             	add    $0x18,%esp
}
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
  801d1d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 2c                	push   $0x2c
  801d2c:	e8 ac fa ff ff       	call   8017dd <syscall>
  801d31:	83 c4 18             	add    $0x18,%esp
  801d34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d37:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d3b:	75 07                	jne    801d44 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d3d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d42:	eb 05                	jmp    801d49 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 2c                	push   $0x2c
  801d5d:	e8 7b fa ff ff       	call   8017dd <syscall>
  801d62:	83 c4 18             	add    $0x18,%esp
  801d65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d68:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d6c:	75 07                	jne    801d75 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d73:	eb 05                	jmp    801d7a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 2c                	push   $0x2c
  801d8e:	e8 4a fa ff ff       	call   8017dd <syscall>
  801d93:	83 c4 18             	add    $0x18,%esp
  801d96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d99:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d9d:	75 07                	jne    801da6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d9f:	b8 01 00 00 00       	mov    $0x1,%eax
  801da4:	eb 05                	jmp    801dab <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801da6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dab:	c9                   	leave  
  801dac:	c3                   	ret    

00801dad <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
  801db0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 2c                	push   $0x2c
  801dbf:	e8 19 fa ff ff       	call   8017dd <syscall>
  801dc4:	83 c4 18             	add    $0x18,%esp
  801dc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dca:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dce:	75 07                	jne    801dd7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dd0:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd5:	eb 05                	jmp    801ddc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ddc:	c9                   	leave  
  801ddd:	c3                   	ret    

00801dde <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	ff 75 08             	pushl  0x8(%ebp)
  801dec:	6a 2d                	push   $0x2d
  801dee:	e8 ea f9 ff ff       	call   8017dd <syscall>
  801df3:	83 c4 18             	add    $0x18,%esp
	return ;
  801df6:	90                   	nop
}
  801df7:	c9                   	leave  
  801df8:	c3                   	ret    

00801df9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
  801dfc:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801dfd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e00:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e06:	8b 45 08             	mov    0x8(%ebp),%eax
  801e09:	6a 00                	push   $0x0
  801e0b:	53                   	push   %ebx
  801e0c:	51                   	push   %ecx
  801e0d:	52                   	push   %edx
  801e0e:	50                   	push   %eax
  801e0f:	6a 2e                	push   $0x2e
  801e11:	e8 c7 f9 ff ff       	call   8017dd <syscall>
  801e16:	83 c4 18             	add    $0x18,%esp
}
  801e19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e24:	8b 45 08             	mov    0x8(%ebp),%eax
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	52                   	push   %edx
  801e2e:	50                   	push   %eax
  801e2f:	6a 2f                	push   $0x2f
  801e31:	e8 a7 f9 ff ff       	call   8017dd <syscall>
  801e36:	83 c4 18             	add    $0x18,%esp
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e41:	83 ec 0c             	sub    $0xc,%esp
  801e44:	68 20 39 80 00       	push   $0x803920
  801e49:	e8 dd e6 ff ff       	call   80052b <cprintf>
  801e4e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e51:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e58:	83 ec 0c             	sub    $0xc,%esp
  801e5b:	68 4c 39 80 00       	push   $0x80394c
  801e60:	e8 c6 e6 ff ff       	call   80052b <cprintf>
  801e65:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e68:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e6c:	a1 38 41 80 00       	mov    0x804138,%eax
  801e71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e74:	eb 56                	jmp    801ecc <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e7a:	74 1c                	je     801e98 <print_mem_block_lists+0x5d>
  801e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7f:	8b 50 08             	mov    0x8(%eax),%edx
  801e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e85:	8b 48 08             	mov    0x8(%eax),%ecx
  801e88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e8b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e8e:	01 c8                	add    %ecx,%eax
  801e90:	39 c2                	cmp    %eax,%edx
  801e92:	73 04                	jae    801e98 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e94:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9b:	8b 50 08             	mov    0x8(%eax),%edx
  801e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea4:	01 c2                	add    %eax,%edx
  801ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea9:	8b 40 08             	mov    0x8(%eax),%eax
  801eac:	83 ec 04             	sub    $0x4,%esp
  801eaf:	52                   	push   %edx
  801eb0:	50                   	push   %eax
  801eb1:	68 61 39 80 00       	push   $0x803961
  801eb6:	e8 70 e6 ff ff       	call   80052b <cprintf>
  801ebb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ec4:	a1 40 41 80 00       	mov    0x804140,%eax
  801ec9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ecc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ed0:	74 07                	je     801ed9 <print_mem_block_lists+0x9e>
  801ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed5:	8b 00                	mov    (%eax),%eax
  801ed7:	eb 05                	jmp    801ede <print_mem_block_lists+0xa3>
  801ed9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ede:	a3 40 41 80 00       	mov    %eax,0x804140
  801ee3:	a1 40 41 80 00       	mov    0x804140,%eax
  801ee8:	85 c0                	test   %eax,%eax
  801eea:	75 8a                	jne    801e76 <print_mem_block_lists+0x3b>
  801eec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef0:	75 84                	jne    801e76 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ef2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ef6:	75 10                	jne    801f08 <print_mem_block_lists+0xcd>
  801ef8:	83 ec 0c             	sub    $0xc,%esp
  801efb:	68 70 39 80 00       	push   $0x803970
  801f00:	e8 26 e6 ff ff       	call   80052b <cprintf>
  801f05:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f08:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f0f:	83 ec 0c             	sub    $0xc,%esp
  801f12:	68 94 39 80 00       	push   $0x803994
  801f17:	e8 0f e6 ff ff       	call   80052b <cprintf>
  801f1c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f1f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f23:	a1 40 40 80 00       	mov    0x804040,%eax
  801f28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f2b:	eb 56                	jmp    801f83 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f31:	74 1c                	je     801f4f <print_mem_block_lists+0x114>
  801f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f36:	8b 50 08             	mov    0x8(%eax),%edx
  801f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3c:	8b 48 08             	mov    0x8(%eax),%ecx
  801f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f42:	8b 40 0c             	mov    0xc(%eax),%eax
  801f45:	01 c8                	add    %ecx,%eax
  801f47:	39 c2                	cmp    %eax,%edx
  801f49:	73 04                	jae    801f4f <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f4b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f52:	8b 50 08             	mov    0x8(%eax),%edx
  801f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f58:	8b 40 0c             	mov    0xc(%eax),%eax
  801f5b:	01 c2                	add    %eax,%edx
  801f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f60:	8b 40 08             	mov    0x8(%eax),%eax
  801f63:	83 ec 04             	sub    $0x4,%esp
  801f66:	52                   	push   %edx
  801f67:	50                   	push   %eax
  801f68:	68 61 39 80 00       	push   $0x803961
  801f6d:	e8 b9 e5 ff ff       	call   80052b <cprintf>
  801f72:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f78:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f7b:	a1 48 40 80 00       	mov    0x804048,%eax
  801f80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f87:	74 07                	je     801f90 <print_mem_block_lists+0x155>
  801f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8c:	8b 00                	mov    (%eax),%eax
  801f8e:	eb 05                	jmp    801f95 <print_mem_block_lists+0x15a>
  801f90:	b8 00 00 00 00       	mov    $0x0,%eax
  801f95:	a3 48 40 80 00       	mov    %eax,0x804048
  801f9a:	a1 48 40 80 00       	mov    0x804048,%eax
  801f9f:	85 c0                	test   %eax,%eax
  801fa1:	75 8a                	jne    801f2d <print_mem_block_lists+0xf2>
  801fa3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa7:	75 84                	jne    801f2d <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fa9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fad:	75 10                	jne    801fbf <print_mem_block_lists+0x184>
  801faf:	83 ec 0c             	sub    $0xc,%esp
  801fb2:	68 ac 39 80 00       	push   $0x8039ac
  801fb7:	e8 6f e5 ff ff       	call   80052b <cprintf>
  801fbc:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fbf:	83 ec 0c             	sub    $0xc,%esp
  801fc2:	68 20 39 80 00       	push   $0x803920
  801fc7:	e8 5f e5 ff ff       	call   80052b <cprintf>
  801fcc:	83 c4 10             	add    $0x10,%esp

}
  801fcf:	90                   	nop
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  801fde:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801fe5:	00 00 00 
  801fe8:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801fef:	00 00 00 
  801ff2:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801ff9:	00 00 00 
	for(int i = 0; i<n;i++)
  801ffc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802003:	e9 9e 00 00 00       	jmp    8020a6 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802008:	a1 50 40 80 00       	mov    0x804050,%eax
  80200d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802010:	c1 e2 04             	shl    $0x4,%edx
  802013:	01 d0                	add    %edx,%eax
  802015:	85 c0                	test   %eax,%eax
  802017:	75 14                	jne    80202d <initialize_MemBlocksList+0x5b>
  802019:	83 ec 04             	sub    $0x4,%esp
  80201c:	68 d4 39 80 00       	push   $0x8039d4
  802021:	6a 47                	push   $0x47
  802023:	68 f7 39 80 00       	push   $0x8039f7
  802028:	e8 4a e2 ff ff       	call   800277 <_panic>
  80202d:	a1 50 40 80 00       	mov    0x804050,%eax
  802032:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802035:	c1 e2 04             	shl    $0x4,%edx
  802038:	01 d0                	add    %edx,%eax
  80203a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802040:	89 10                	mov    %edx,(%eax)
  802042:	8b 00                	mov    (%eax),%eax
  802044:	85 c0                	test   %eax,%eax
  802046:	74 18                	je     802060 <initialize_MemBlocksList+0x8e>
  802048:	a1 48 41 80 00       	mov    0x804148,%eax
  80204d:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802053:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802056:	c1 e1 04             	shl    $0x4,%ecx
  802059:	01 ca                	add    %ecx,%edx
  80205b:	89 50 04             	mov    %edx,0x4(%eax)
  80205e:	eb 12                	jmp    802072 <initialize_MemBlocksList+0xa0>
  802060:	a1 50 40 80 00       	mov    0x804050,%eax
  802065:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802068:	c1 e2 04             	shl    $0x4,%edx
  80206b:	01 d0                	add    %edx,%eax
  80206d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802072:	a1 50 40 80 00       	mov    0x804050,%eax
  802077:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80207a:	c1 e2 04             	shl    $0x4,%edx
  80207d:	01 d0                	add    %edx,%eax
  80207f:	a3 48 41 80 00       	mov    %eax,0x804148
  802084:	a1 50 40 80 00       	mov    0x804050,%eax
  802089:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80208c:	c1 e2 04             	shl    $0x4,%edx
  80208f:	01 d0                	add    %edx,%eax
  802091:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802098:	a1 54 41 80 00       	mov    0x804154,%eax
  80209d:	40                   	inc    %eax
  80209e:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8020a3:	ff 45 f4             	incl   -0xc(%ebp)
  8020a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8020ac:	0f 82 56 ff ff ff    	jb     802008 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8020b2:	90                   	nop
  8020b3:	c9                   	leave  
  8020b4:	c3                   	ret    

008020b5 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
  8020b8:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  8020bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  8020c1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8020c8:	a1 40 40 80 00       	mov    0x804040,%eax
  8020cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020d0:	eb 23                	jmp    8020f5 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  8020d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d5:	8b 40 08             	mov    0x8(%eax),%eax
  8020d8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8020db:	75 09                	jne    8020e6 <find_block+0x31>
		{
			found = 1;
  8020dd:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  8020e4:	eb 35                	jmp    80211b <find_block+0x66>
		}
		else
		{
			found = 0;
  8020e6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8020ed:	a1 48 40 80 00       	mov    0x804048,%eax
  8020f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020f9:	74 07                	je     802102 <find_block+0x4d>
  8020fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020fe:	8b 00                	mov    (%eax),%eax
  802100:	eb 05                	jmp    802107 <find_block+0x52>
  802102:	b8 00 00 00 00       	mov    $0x0,%eax
  802107:	a3 48 40 80 00       	mov    %eax,0x804048
  80210c:	a1 48 40 80 00       	mov    0x804048,%eax
  802111:	85 c0                	test   %eax,%eax
  802113:	75 bd                	jne    8020d2 <find_block+0x1d>
  802115:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802119:	75 b7                	jne    8020d2 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  80211b:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  80211f:	75 05                	jne    802126 <find_block+0x71>
	{
		return blk;
  802121:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802124:	eb 05                	jmp    80212b <find_block+0x76>
	}
	else
	{
		return NULL;
  802126:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  80212b:	c9                   	leave  
  80212c:	c3                   	ret    

0080212d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80212d:	55                   	push   %ebp
  80212e:	89 e5                	mov    %esp,%ebp
  802130:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802133:	8b 45 08             	mov    0x8(%ebp),%eax
  802136:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802139:	a1 40 40 80 00       	mov    0x804040,%eax
  80213e:	85 c0                	test   %eax,%eax
  802140:	74 12                	je     802154 <insert_sorted_allocList+0x27>
  802142:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802145:	8b 50 08             	mov    0x8(%eax),%edx
  802148:	a1 40 40 80 00       	mov    0x804040,%eax
  80214d:	8b 40 08             	mov    0x8(%eax),%eax
  802150:	39 c2                	cmp    %eax,%edx
  802152:	73 65                	jae    8021b9 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802154:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802158:	75 14                	jne    80216e <insert_sorted_allocList+0x41>
  80215a:	83 ec 04             	sub    $0x4,%esp
  80215d:	68 d4 39 80 00       	push   $0x8039d4
  802162:	6a 7b                	push   $0x7b
  802164:	68 f7 39 80 00       	push   $0x8039f7
  802169:	e8 09 e1 ff ff       	call   800277 <_panic>
  80216e:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802174:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802177:	89 10                	mov    %edx,(%eax)
  802179:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217c:	8b 00                	mov    (%eax),%eax
  80217e:	85 c0                	test   %eax,%eax
  802180:	74 0d                	je     80218f <insert_sorted_allocList+0x62>
  802182:	a1 40 40 80 00       	mov    0x804040,%eax
  802187:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80218a:	89 50 04             	mov    %edx,0x4(%eax)
  80218d:	eb 08                	jmp    802197 <insert_sorted_allocList+0x6a>
  80218f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802192:	a3 44 40 80 00       	mov    %eax,0x804044
  802197:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219a:	a3 40 40 80 00       	mov    %eax,0x804040
  80219f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021a9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021ae:	40                   	inc    %eax
  8021af:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8021b4:	e9 5f 01 00 00       	jmp    802318 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8021b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021bc:	8b 50 08             	mov    0x8(%eax),%edx
  8021bf:	a1 44 40 80 00       	mov    0x804044,%eax
  8021c4:	8b 40 08             	mov    0x8(%eax),%eax
  8021c7:	39 c2                	cmp    %eax,%edx
  8021c9:	76 65                	jbe    802230 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  8021cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021cf:	75 14                	jne    8021e5 <insert_sorted_allocList+0xb8>
  8021d1:	83 ec 04             	sub    $0x4,%esp
  8021d4:	68 10 3a 80 00       	push   $0x803a10
  8021d9:	6a 7f                	push   $0x7f
  8021db:	68 f7 39 80 00       	push   $0x8039f7
  8021e0:	e8 92 e0 ff ff       	call   800277 <_panic>
  8021e5:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ee:	89 50 04             	mov    %edx,0x4(%eax)
  8021f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f4:	8b 40 04             	mov    0x4(%eax),%eax
  8021f7:	85 c0                	test   %eax,%eax
  8021f9:	74 0c                	je     802207 <insert_sorted_allocList+0xda>
  8021fb:	a1 44 40 80 00       	mov    0x804044,%eax
  802200:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802203:	89 10                	mov    %edx,(%eax)
  802205:	eb 08                	jmp    80220f <insert_sorted_allocList+0xe2>
  802207:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220a:	a3 40 40 80 00       	mov    %eax,0x804040
  80220f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802212:	a3 44 40 80 00       	mov    %eax,0x804044
  802217:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802220:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802225:	40                   	inc    %eax
  802226:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80222b:	e9 e8 00 00 00       	jmp    802318 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802230:	a1 40 40 80 00       	mov    0x804040,%eax
  802235:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802238:	e9 ab 00 00 00       	jmp    8022e8 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  80223d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802240:	8b 00                	mov    (%eax),%eax
  802242:	85 c0                	test   %eax,%eax
  802244:	0f 84 96 00 00 00    	je     8022e0 <insert_sorted_allocList+0x1b3>
  80224a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80224d:	8b 50 08             	mov    0x8(%eax),%edx
  802250:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802253:	8b 40 08             	mov    0x8(%eax),%eax
  802256:	39 c2                	cmp    %eax,%edx
  802258:	0f 86 82 00 00 00    	jbe    8022e0 <insert_sorted_allocList+0x1b3>
  80225e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802261:	8b 50 08             	mov    0x8(%eax),%edx
  802264:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802267:	8b 00                	mov    (%eax),%eax
  802269:	8b 40 08             	mov    0x8(%eax),%eax
  80226c:	39 c2                	cmp    %eax,%edx
  80226e:	73 70                	jae    8022e0 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802270:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802274:	74 06                	je     80227c <insert_sorted_allocList+0x14f>
  802276:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80227a:	75 17                	jne    802293 <insert_sorted_allocList+0x166>
  80227c:	83 ec 04             	sub    $0x4,%esp
  80227f:	68 34 3a 80 00       	push   $0x803a34
  802284:	68 87 00 00 00       	push   $0x87
  802289:	68 f7 39 80 00       	push   $0x8039f7
  80228e:	e8 e4 df ff ff       	call   800277 <_panic>
  802293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802296:	8b 10                	mov    (%eax),%edx
  802298:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229b:	89 10                	mov    %edx,(%eax)
  80229d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a0:	8b 00                	mov    (%eax),%eax
  8022a2:	85 c0                	test   %eax,%eax
  8022a4:	74 0b                	je     8022b1 <insert_sorted_allocList+0x184>
  8022a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a9:	8b 00                	mov    (%eax),%eax
  8022ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022ae:	89 50 04             	mov    %edx,0x4(%eax)
  8022b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022b7:	89 10                	mov    %edx,(%eax)
  8022b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022bf:	89 50 04             	mov    %edx,0x4(%eax)
  8022c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c5:	8b 00                	mov    (%eax),%eax
  8022c7:	85 c0                	test   %eax,%eax
  8022c9:	75 08                	jne    8022d3 <insert_sorted_allocList+0x1a6>
  8022cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ce:	a3 44 40 80 00       	mov    %eax,0x804044
  8022d3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022d8:	40                   	inc    %eax
  8022d9:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8022de:	eb 38                	jmp    802318 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8022e0:	a1 48 40 80 00       	mov    0x804048,%eax
  8022e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ec:	74 07                	je     8022f5 <insert_sorted_allocList+0x1c8>
  8022ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f1:	8b 00                	mov    (%eax),%eax
  8022f3:	eb 05                	jmp    8022fa <insert_sorted_allocList+0x1cd>
  8022f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fa:	a3 48 40 80 00       	mov    %eax,0x804048
  8022ff:	a1 48 40 80 00       	mov    0x804048,%eax
  802304:	85 c0                	test   %eax,%eax
  802306:	0f 85 31 ff ff ff    	jne    80223d <insert_sorted_allocList+0x110>
  80230c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802310:	0f 85 27 ff ff ff    	jne    80223d <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802316:	eb 00                	jmp    802318 <insert_sorted_allocList+0x1eb>
  802318:	90                   	nop
  802319:	c9                   	leave  
  80231a:	c3                   	ret    

0080231b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
  80231e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802321:	8b 45 08             	mov    0x8(%ebp),%eax
  802324:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802327:	a1 48 41 80 00       	mov    0x804148,%eax
  80232c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80232f:	a1 38 41 80 00       	mov    0x804138,%eax
  802334:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802337:	e9 77 01 00 00       	jmp    8024b3 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  80233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233f:	8b 40 0c             	mov    0xc(%eax),%eax
  802342:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802345:	0f 85 8a 00 00 00    	jne    8023d5 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80234b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80234f:	75 17                	jne    802368 <alloc_block_FF+0x4d>
  802351:	83 ec 04             	sub    $0x4,%esp
  802354:	68 68 3a 80 00       	push   $0x803a68
  802359:	68 9e 00 00 00       	push   $0x9e
  80235e:	68 f7 39 80 00       	push   $0x8039f7
  802363:	e8 0f df ff ff       	call   800277 <_panic>
  802368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236b:	8b 00                	mov    (%eax),%eax
  80236d:	85 c0                	test   %eax,%eax
  80236f:	74 10                	je     802381 <alloc_block_FF+0x66>
  802371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802374:	8b 00                	mov    (%eax),%eax
  802376:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802379:	8b 52 04             	mov    0x4(%edx),%edx
  80237c:	89 50 04             	mov    %edx,0x4(%eax)
  80237f:	eb 0b                	jmp    80238c <alloc_block_FF+0x71>
  802381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802384:	8b 40 04             	mov    0x4(%eax),%eax
  802387:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80238c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238f:	8b 40 04             	mov    0x4(%eax),%eax
  802392:	85 c0                	test   %eax,%eax
  802394:	74 0f                	je     8023a5 <alloc_block_FF+0x8a>
  802396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802399:	8b 40 04             	mov    0x4(%eax),%eax
  80239c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80239f:	8b 12                	mov    (%edx),%edx
  8023a1:	89 10                	mov    %edx,(%eax)
  8023a3:	eb 0a                	jmp    8023af <alloc_block_FF+0x94>
  8023a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a8:	8b 00                	mov    (%eax),%eax
  8023aa:	a3 38 41 80 00       	mov    %eax,0x804138
  8023af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023c2:	a1 44 41 80 00       	mov    0x804144,%eax
  8023c7:	48                   	dec    %eax
  8023c8:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8023cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d0:	e9 11 01 00 00       	jmp    8024e6 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8023db:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8023de:	0f 86 c7 00 00 00    	jbe    8024ab <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8023e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023e8:	75 17                	jne    802401 <alloc_block_FF+0xe6>
  8023ea:	83 ec 04             	sub    $0x4,%esp
  8023ed:	68 68 3a 80 00       	push   $0x803a68
  8023f2:	68 a3 00 00 00       	push   $0xa3
  8023f7:	68 f7 39 80 00       	push   $0x8039f7
  8023fc:	e8 76 de ff ff       	call   800277 <_panic>
  802401:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802404:	8b 00                	mov    (%eax),%eax
  802406:	85 c0                	test   %eax,%eax
  802408:	74 10                	je     80241a <alloc_block_FF+0xff>
  80240a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80240d:	8b 00                	mov    (%eax),%eax
  80240f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802412:	8b 52 04             	mov    0x4(%edx),%edx
  802415:	89 50 04             	mov    %edx,0x4(%eax)
  802418:	eb 0b                	jmp    802425 <alloc_block_FF+0x10a>
  80241a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80241d:	8b 40 04             	mov    0x4(%eax),%eax
  802420:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802425:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802428:	8b 40 04             	mov    0x4(%eax),%eax
  80242b:	85 c0                	test   %eax,%eax
  80242d:	74 0f                	je     80243e <alloc_block_FF+0x123>
  80242f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802432:	8b 40 04             	mov    0x4(%eax),%eax
  802435:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802438:	8b 12                	mov    (%edx),%edx
  80243a:	89 10                	mov    %edx,(%eax)
  80243c:	eb 0a                	jmp    802448 <alloc_block_FF+0x12d>
  80243e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802441:	8b 00                	mov    (%eax),%eax
  802443:	a3 48 41 80 00       	mov    %eax,0x804148
  802448:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80244b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802451:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802454:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80245b:	a1 54 41 80 00       	mov    0x804154,%eax
  802460:	48                   	dec    %eax
  802461:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802466:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802469:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80246c:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	8b 40 0c             	mov    0xc(%eax),%eax
  802475:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802478:	89 c2                	mov    %eax,%edx
  80247a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247d:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802483:	8b 40 08             	mov    0x8(%eax),%eax
  802486:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248c:	8b 50 08             	mov    0x8(%eax),%edx
  80248f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802492:	8b 40 0c             	mov    0xc(%eax),%eax
  802495:	01 c2                	add    %eax,%edx
  802497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249a:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  80249d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024a3:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8024a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a9:	eb 3b                	jmp    8024e6 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8024ab:	a1 40 41 80 00       	mov    0x804140,%eax
  8024b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b7:	74 07                	je     8024c0 <alloc_block_FF+0x1a5>
  8024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bc:	8b 00                	mov    (%eax),%eax
  8024be:	eb 05                	jmp    8024c5 <alloc_block_FF+0x1aa>
  8024c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c5:	a3 40 41 80 00       	mov    %eax,0x804140
  8024ca:	a1 40 41 80 00       	mov    0x804140,%eax
  8024cf:	85 c0                	test   %eax,%eax
  8024d1:	0f 85 65 fe ff ff    	jne    80233c <alloc_block_FF+0x21>
  8024d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024db:	0f 85 5b fe ff ff    	jne    80233c <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8024e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e6:	c9                   	leave  
  8024e7:	c3                   	ret    

008024e8 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024e8:	55                   	push   %ebp
  8024e9:	89 e5                	mov    %esp,%ebp
  8024eb:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  8024ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  8024f4:	a1 48 41 80 00       	mov    0x804148,%eax
  8024f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  8024fc:	a1 44 41 80 00       	mov    0x804144,%eax
  802501:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802504:	a1 38 41 80 00       	mov    0x804138,%eax
  802509:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80250c:	e9 a1 00 00 00       	jmp    8025b2 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802514:	8b 40 0c             	mov    0xc(%eax),%eax
  802517:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80251a:	0f 85 8a 00 00 00    	jne    8025aa <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802520:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802524:	75 17                	jne    80253d <alloc_block_BF+0x55>
  802526:	83 ec 04             	sub    $0x4,%esp
  802529:	68 68 3a 80 00       	push   $0x803a68
  80252e:	68 c2 00 00 00       	push   $0xc2
  802533:	68 f7 39 80 00       	push   $0x8039f7
  802538:	e8 3a dd ff ff       	call   800277 <_panic>
  80253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802540:	8b 00                	mov    (%eax),%eax
  802542:	85 c0                	test   %eax,%eax
  802544:	74 10                	je     802556 <alloc_block_BF+0x6e>
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	8b 00                	mov    (%eax),%eax
  80254b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254e:	8b 52 04             	mov    0x4(%edx),%edx
  802551:	89 50 04             	mov    %edx,0x4(%eax)
  802554:	eb 0b                	jmp    802561 <alloc_block_BF+0x79>
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	8b 40 04             	mov    0x4(%eax),%eax
  80255c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	8b 40 04             	mov    0x4(%eax),%eax
  802567:	85 c0                	test   %eax,%eax
  802569:	74 0f                	je     80257a <alloc_block_BF+0x92>
  80256b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256e:	8b 40 04             	mov    0x4(%eax),%eax
  802571:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802574:	8b 12                	mov    (%edx),%edx
  802576:	89 10                	mov    %edx,(%eax)
  802578:	eb 0a                	jmp    802584 <alloc_block_BF+0x9c>
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	8b 00                	mov    (%eax),%eax
  80257f:	a3 38 41 80 00       	mov    %eax,0x804138
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802597:	a1 44 41 80 00       	mov    0x804144,%eax
  80259c:	48                   	dec    %eax
  80259d:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a5:	e9 11 02 00 00       	jmp    8027bb <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025aa:	a1 40 41 80 00       	mov    0x804140,%eax
  8025af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b6:	74 07                	je     8025bf <alloc_block_BF+0xd7>
  8025b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bb:	8b 00                	mov    (%eax),%eax
  8025bd:	eb 05                	jmp    8025c4 <alloc_block_BF+0xdc>
  8025bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c4:	a3 40 41 80 00       	mov    %eax,0x804140
  8025c9:	a1 40 41 80 00       	mov    0x804140,%eax
  8025ce:	85 c0                	test   %eax,%eax
  8025d0:	0f 85 3b ff ff ff    	jne    802511 <alloc_block_BF+0x29>
  8025d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025da:	0f 85 31 ff ff ff    	jne    802511 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025e0:	a1 38 41 80 00       	mov    0x804138,%eax
  8025e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e8:	eb 27                	jmp    802611 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  8025ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8025f3:	76 14                	jbe    802609 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  8025f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	8b 40 08             	mov    0x8(%eax),%eax
  802604:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802607:	eb 2e                	jmp    802637 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802609:	a1 40 41 80 00       	mov    0x804140,%eax
  80260e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802611:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802615:	74 07                	je     80261e <alloc_block_BF+0x136>
  802617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261a:	8b 00                	mov    (%eax),%eax
  80261c:	eb 05                	jmp    802623 <alloc_block_BF+0x13b>
  80261e:	b8 00 00 00 00       	mov    $0x0,%eax
  802623:	a3 40 41 80 00       	mov    %eax,0x804140
  802628:	a1 40 41 80 00       	mov    0x804140,%eax
  80262d:	85 c0                	test   %eax,%eax
  80262f:	75 b9                	jne    8025ea <alloc_block_BF+0x102>
  802631:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802635:	75 b3                	jne    8025ea <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802637:	a1 38 41 80 00       	mov    0x804138,%eax
  80263c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80263f:	eb 30                	jmp    802671 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802644:	8b 40 0c             	mov    0xc(%eax),%eax
  802647:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80264a:	73 1d                	jae    802669 <alloc_block_BF+0x181>
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	8b 40 0c             	mov    0xc(%eax),%eax
  802652:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802655:	76 12                	jbe    802669 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	8b 40 0c             	mov    0xc(%eax),%eax
  80265d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802663:	8b 40 08             	mov    0x8(%eax),%eax
  802666:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802669:	a1 40 41 80 00       	mov    0x804140,%eax
  80266e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802671:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802675:	74 07                	je     80267e <alloc_block_BF+0x196>
  802677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267a:	8b 00                	mov    (%eax),%eax
  80267c:	eb 05                	jmp    802683 <alloc_block_BF+0x19b>
  80267e:	b8 00 00 00 00       	mov    $0x0,%eax
  802683:	a3 40 41 80 00       	mov    %eax,0x804140
  802688:	a1 40 41 80 00       	mov    0x804140,%eax
  80268d:	85 c0                	test   %eax,%eax
  80268f:	75 b0                	jne    802641 <alloc_block_BF+0x159>
  802691:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802695:	75 aa                	jne    802641 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802697:	a1 38 41 80 00       	mov    0x804138,%eax
  80269c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80269f:	e9 e4 00 00 00       	jmp    802788 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  8026a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026aa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8026ad:	0f 85 cd 00 00 00    	jne    802780 <alloc_block_BF+0x298>
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	8b 40 08             	mov    0x8(%eax),%eax
  8026b9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026bc:	0f 85 be 00 00 00    	jne    802780 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  8026c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026c6:	75 17                	jne    8026df <alloc_block_BF+0x1f7>
  8026c8:	83 ec 04             	sub    $0x4,%esp
  8026cb:	68 68 3a 80 00       	push   $0x803a68
  8026d0:	68 db 00 00 00       	push   $0xdb
  8026d5:	68 f7 39 80 00       	push   $0x8039f7
  8026da:	e8 98 db ff ff       	call   800277 <_panic>
  8026df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e2:	8b 00                	mov    (%eax),%eax
  8026e4:	85 c0                	test   %eax,%eax
  8026e6:	74 10                	je     8026f8 <alloc_block_BF+0x210>
  8026e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026eb:	8b 00                	mov    (%eax),%eax
  8026ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026f0:	8b 52 04             	mov    0x4(%edx),%edx
  8026f3:	89 50 04             	mov    %edx,0x4(%eax)
  8026f6:	eb 0b                	jmp    802703 <alloc_block_BF+0x21b>
  8026f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026fb:	8b 40 04             	mov    0x4(%eax),%eax
  8026fe:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802703:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802706:	8b 40 04             	mov    0x4(%eax),%eax
  802709:	85 c0                	test   %eax,%eax
  80270b:	74 0f                	je     80271c <alloc_block_BF+0x234>
  80270d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802710:	8b 40 04             	mov    0x4(%eax),%eax
  802713:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802716:	8b 12                	mov    (%edx),%edx
  802718:	89 10                	mov    %edx,(%eax)
  80271a:	eb 0a                	jmp    802726 <alloc_block_BF+0x23e>
  80271c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80271f:	8b 00                	mov    (%eax),%eax
  802721:	a3 48 41 80 00       	mov    %eax,0x804148
  802726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802729:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80272f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802732:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802739:	a1 54 41 80 00       	mov    0x804154,%eax
  80273e:	48                   	dec    %eax
  80273f:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802744:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802747:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80274a:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  80274d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802750:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802753:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802759:	8b 40 0c             	mov    0xc(%eax),%eax
  80275c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80275f:	89 c2                	mov    %eax,%edx
  802761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802764:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 50 08             	mov    0x8(%eax),%edx
  80276d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802770:	8b 40 0c             	mov    0xc(%eax),%eax
  802773:	01 c2                	add    %eax,%edx
  802775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802778:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  80277b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80277e:	eb 3b                	jmp    8027bb <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802780:	a1 40 41 80 00       	mov    0x804140,%eax
  802785:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802788:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278c:	74 07                	je     802795 <alloc_block_BF+0x2ad>
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	8b 00                	mov    (%eax),%eax
  802793:	eb 05                	jmp    80279a <alloc_block_BF+0x2b2>
  802795:	b8 00 00 00 00       	mov    $0x0,%eax
  80279a:	a3 40 41 80 00       	mov    %eax,0x804140
  80279f:	a1 40 41 80 00       	mov    0x804140,%eax
  8027a4:	85 c0                	test   %eax,%eax
  8027a6:	0f 85 f8 fe ff ff    	jne    8026a4 <alloc_block_BF+0x1bc>
  8027ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b0:	0f 85 ee fe ff ff    	jne    8026a4 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  8027b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027bb:	c9                   	leave  
  8027bc:	c3                   	ret    

008027bd <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027bd:	55                   	push   %ebp
  8027be:	89 e5                	mov    %esp,%ebp
  8027c0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  8027c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8027c9:	a1 48 41 80 00       	mov    0x804148,%eax
  8027ce:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8027d1:	a1 38 41 80 00       	mov    0x804138,%eax
  8027d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d9:	e9 77 01 00 00       	jmp    802955 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  8027de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027e7:	0f 85 8a 00 00 00    	jne    802877 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8027ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f1:	75 17                	jne    80280a <alloc_block_NF+0x4d>
  8027f3:	83 ec 04             	sub    $0x4,%esp
  8027f6:	68 68 3a 80 00       	push   $0x803a68
  8027fb:	68 f7 00 00 00       	push   $0xf7
  802800:	68 f7 39 80 00       	push   $0x8039f7
  802805:	e8 6d da ff ff       	call   800277 <_panic>
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	8b 00                	mov    (%eax),%eax
  80280f:	85 c0                	test   %eax,%eax
  802811:	74 10                	je     802823 <alloc_block_NF+0x66>
  802813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802816:	8b 00                	mov    (%eax),%eax
  802818:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80281b:	8b 52 04             	mov    0x4(%edx),%edx
  80281e:	89 50 04             	mov    %edx,0x4(%eax)
  802821:	eb 0b                	jmp    80282e <alloc_block_NF+0x71>
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	8b 40 04             	mov    0x4(%eax),%eax
  802829:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802831:	8b 40 04             	mov    0x4(%eax),%eax
  802834:	85 c0                	test   %eax,%eax
  802836:	74 0f                	je     802847 <alloc_block_NF+0x8a>
  802838:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283b:	8b 40 04             	mov    0x4(%eax),%eax
  80283e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802841:	8b 12                	mov    (%edx),%edx
  802843:	89 10                	mov    %edx,(%eax)
  802845:	eb 0a                	jmp    802851 <alloc_block_NF+0x94>
  802847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284a:	8b 00                	mov    (%eax),%eax
  80284c:	a3 38 41 80 00       	mov    %eax,0x804138
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802864:	a1 44 41 80 00       	mov    0x804144,%eax
  802869:	48                   	dec    %eax
  80286a:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  80286f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802872:	e9 11 01 00 00       	jmp    802988 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	8b 40 0c             	mov    0xc(%eax),%eax
  80287d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802880:	0f 86 c7 00 00 00    	jbe    80294d <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802886:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80288a:	75 17                	jne    8028a3 <alloc_block_NF+0xe6>
  80288c:	83 ec 04             	sub    $0x4,%esp
  80288f:	68 68 3a 80 00       	push   $0x803a68
  802894:	68 fc 00 00 00       	push   $0xfc
  802899:	68 f7 39 80 00       	push   $0x8039f7
  80289e:	e8 d4 d9 ff ff       	call   800277 <_panic>
  8028a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a6:	8b 00                	mov    (%eax),%eax
  8028a8:	85 c0                	test   %eax,%eax
  8028aa:	74 10                	je     8028bc <alloc_block_NF+0xff>
  8028ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028af:	8b 00                	mov    (%eax),%eax
  8028b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028b4:	8b 52 04             	mov    0x4(%edx),%edx
  8028b7:	89 50 04             	mov    %edx,0x4(%eax)
  8028ba:	eb 0b                	jmp    8028c7 <alloc_block_NF+0x10a>
  8028bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028bf:	8b 40 04             	mov    0x4(%eax),%eax
  8028c2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ca:	8b 40 04             	mov    0x4(%eax),%eax
  8028cd:	85 c0                	test   %eax,%eax
  8028cf:	74 0f                	je     8028e0 <alloc_block_NF+0x123>
  8028d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d4:	8b 40 04             	mov    0x4(%eax),%eax
  8028d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028da:	8b 12                	mov    (%edx),%edx
  8028dc:	89 10                	mov    %edx,(%eax)
  8028de:	eb 0a                	jmp    8028ea <alloc_block_NF+0x12d>
  8028e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e3:	8b 00                	mov    (%eax),%eax
  8028e5:	a3 48 41 80 00       	mov    %eax,0x804148
  8028ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028fd:	a1 54 41 80 00       	mov    0x804154,%eax
  802902:	48                   	dec    %eax
  802903:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802908:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80290e:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802914:	8b 40 0c             	mov    0xc(%eax),%eax
  802917:	2b 45 f0             	sub    -0x10(%ebp),%eax
  80291a:	89 c2                	mov    %eax,%edx
  80291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291f:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802925:	8b 40 08             	mov    0x8(%eax),%eax
  802928:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  80292b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292e:	8b 50 08             	mov    0x8(%eax),%edx
  802931:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802934:	8b 40 0c             	mov    0xc(%eax),%eax
  802937:	01 c2                	add    %eax,%edx
  802939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293c:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  80293f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802942:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802945:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802948:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294b:	eb 3b                	jmp    802988 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80294d:	a1 40 41 80 00       	mov    0x804140,%eax
  802952:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802955:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802959:	74 07                	je     802962 <alloc_block_NF+0x1a5>
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	8b 00                	mov    (%eax),%eax
  802960:	eb 05                	jmp    802967 <alloc_block_NF+0x1aa>
  802962:	b8 00 00 00 00       	mov    $0x0,%eax
  802967:	a3 40 41 80 00       	mov    %eax,0x804140
  80296c:	a1 40 41 80 00       	mov    0x804140,%eax
  802971:	85 c0                	test   %eax,%eax
  802973:	0f 85 65 fe ff ff    	jne    8027de <alloc_block_NF+0x21>
  802979:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297d:	0f 85 5b fe ff ff    	jne    8027de <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802983:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802988:	c9                   	leave  
  802989:	c3                   	ret    

0080298a <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  80298a:	55                   	push   %ebp
  80298b:	89 e5                	mov    %esp,%ebp
  80298d:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802990:	8b 45 08             	mov    0x8(%ebp),%eax
  802993:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  80299a:	8b 45 08             	mov    0x8(%ebp),%eax
  80299d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  8029a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029a8:	75 17                	jne    8029c1 <addToAvailMemBlocksList+0x37>
  8029aa:	83 ec 04             	sub    $0x4,%esp
  8029ad:	68 10 3a 80 00       	push   $0x803a10
  8029b2:	68 10 01 00 00       	push   $0x110
  8029b7:	68 f7 39 80 00       	push   $0x8039f7
  8029bc:	e8 b6 d8 ff ff       	call   800277 <_panic>
  8029c1:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  8029c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ca:	89 50 04             	mov    %edx,0x4(%eax)
  8029cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d0:	8b 40 04             	mov    0x4(%eax),%eax
  8029d3:	85 c0                	test   %eax,%eax
  8029d5:	74 0c                	je     8029e3 <addToAvailMemBlocksList+0x59>
  8029d7:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8029dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8029df:	89 10                	mov    %edx,(%eax)
  8029e1:	eb 08                	jmp    8029eb <addToAvailMemBlocksList+0x61>
  8029e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e6:	a3 48 41 80 00       	mov    %eax,0x804148
  8029eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ee:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029fc:	a1 54 41 80 00       	mov    0x804154,%eax
  802a01:	40                   	inc    %eax
  802a02:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802a07:	90                   	nop
  802a08:	c9                   	leave  
  802a09:	c3                   	ret    

00802a0a <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a0a:	55                   	push   %ebp
  802a0b:	89 e5                	mov    %esp,%ebp
  802a0d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802a10:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a15:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802a18:	a1 44 41 80 00       	mov    0x804144,%eax
  802a1d:	85 c0                	test   %eax,%eax
  802a1f:	75 68                	jne    802a89 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802a21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a25:	75 17                	jne    802a3e <insert_sorted_with_merge_freeList+0x34>
  802a27:	83 ec 04             	sub    $0x4,%esp
  802a2a:	68 d4 39 80 00       	push   $0x8039d4
  802a2f:	68 1a 01 00 00       	push   $0x11a
  802a34:	68 f7 39 80 00       	push   $0x8039f7
  802a39:	e8 39 d8 ff ff       	call   800277 <_panic>
  802a3e:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a44:	8b 45 08             	mov    0x8(%ebp),%eax
  802a47:	89 10                	mov    %edx,(%eax)
  802a49:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4c:	8b 00                	mov    (%eax),%eax
  802a4e:	85 c0                	test   %eax,%eax
  802a50:	74 0d                	je     802a5f <insert_sorted_with_merge_freeList+0x55>
  802a52:	a1 38 41 80 00       	mov    0x804138,%eax
  802a57:	8b 55 08             	mov    0x8(%ebp),%edx
  802a5a:	89 50 04             	mov    %edx,0x4(%eax)
  802a5d:	eb 08                	jmp    802a67 <insert_sorted_with_merge_freeList+0x5d>
  802a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a62:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a67:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6a:	a3 38 41 80 00       	mov    %eax,0x804138
  802a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a79:	a1 44 41 80 00       	mov    0x804144,%eax
  802a7e:	40                   	inc    %eax
  802a7f:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802a84:	e9 c5 03 00 00       	jmp    802e4e <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8c:	8b 50 08             	mov    0x8(%eax),%edx
  802a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a92:	8b 40 08             	mov    0x8(%eax),%eax
  802a95:	39 c2                	cmp    %eax,%edx
  802a97:	0f 83 b2 00 00 00    	jae    802b4f <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa0:	8b 50 08             	mov    0x8(%eax),%edx
  802aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa6:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa9:	01 c2                	add    %eax,%edx
  802aab:	8b 45 08             	mov    0x8(%ebp),%eax
  802aae:	8b 40 08             	mov    0x8(%eax),%eax
  802ab1:	39 c2                	cmp    %eax,%edx
  802ab3:	75 27                	jne    802adc <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab8:	8b 50 0c             	mov    0xc(%eax),%edx
  802abb:	8b 45 08             	mov    0x8(%ebp),%eax
  802abe:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac1:	01 c2                	add    %eax,%edx
  802ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac6:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802ac9:	83 ec 0c             	sub    $0xc,%esp
  802acc:	ff 75 08             	pushl  0x8(%ebp)
  802acf:	e8 b6 fe ff ff       	call   80298a <addToAvailMemBlocksList>
  802ad4:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ad7:	e9 72 03 00 00       	jmp    802e4e <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802adc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ae0:	74 06                	je     802ae8 <insert_sorted_with_merge_freeList+0xde>
  802ae2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ae6:	75 17                	jne    802aff <insert_sorted_with_merge_freeList+0xf5>
  802ae8:	83 ec 04             	sub    $0x4,%esp
  802aeb:	68 34 3a 80 00       	push   $0x803a34
  802af0:	68 24 01 00 00       	push   $0x124
  802af5:	68 f7 39 80 00       	push   $0x8039f7
  802afa:	e8 78 d7 ff ff       	call   800277 <_panic>
  802aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b02:	8b 10                	mov    (%eax),%edx
  802b04:	8b 45 08             	mov    0x8(%ebp),%eax
  802b07:	89 10                	mov    %edx,(%eax)
  802b09:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0c:	8b 00                	mov    (%eax),%eax
  802b0e:	85 c0                	test   %eax,%eax
  802b10:	74 0b                	je     802b1d <insert_sorted_with_merge_freeList+0x113>
  802b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b15:	8b 00                	mov    (%eax),%eax
  802b17:	8b 55 08             	mov    0x8(%ebp),%edx
  802b1a:	89 50 04             	mov    %edx,0x4(%eax)
  802b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b20:	8b 55 08             	mov    0x8(%ebp),%edx
  802b23:	89 10                	mov    %edx,(%eax)
  802b25:	8b 45 08             	mov    0x8(%ebp),%eax
  802b28:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b2b:	89 50 04             	mov    %edx,0x4(%eax)
  802b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b31:	8b 00                	mov    (%eax),%eax
  802b33:	85 c0                	test   %eax,%eax
  802b35:	75 08                	jne    802b3f <insert_sorted_with_merge_freeList+0x135>
  802b37:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b3f:	a1 44 41 80 00       	mov    0x804144,%eax
  802b44:	40                   	inc    %eax
  802b45:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802b4a:	e9 ff 02 00 00       	jmp    802e4e <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802b4f:	a1 38 41 80 00       	mov    0x804138,%eax
  802b54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b57:	e9 c2 02 00 00       	jmp    802e1e <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5f:	8b 50 08             	mov    0x8(%eax),%edx
  802b62:	8b 45 08             	mov    0x8(%ebp),%eax
  802b65:	8b 40 08             	mov    0x8(%eax),%eax
  802b68:	39 c2                	cmp    %eax,%edx
  802b6a:	0f 86 a6 02 00 00    	jbe    802e16 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	8b 40 04             	mov    0x4(%eax),%eax
  802b76:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802b79:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b7d:	0f 85 ba 00 00 00    	jne    802c3d <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802b83:	8b 45 08             	mov    0x8(%ebp),%eax
  802b86:	8b 50 0c             	mov    0xc(%eax),%edx
  802b89:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8c:	8b 40 08             	mov    0x8(%eax),%eax
  802b8f:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b94:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802b97:	39 c2                	cmp    %eax,%edx
  802b99:	75 33                	jne    802bce <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9e:	8b 50 08             	mov    0x8(%eax),%edx
  802ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba4:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	8b 50 0c             	mov    0xc(%eax),%edx
  802bad:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb0:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb3:	01 c2                	add    %eax,%edx
  802bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb8:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802bbb:	83 ec 0c             	sub    $0xc,%esp
  802bbe:	ff 75 08             	pushl  0x8(%ebp)
  802bc1:	e8 c4 fd ff ff       	call   80298a <addToAvailMemBlocksList>
  802bc6:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802bc9:	e9 80 02 00 00       	jmp    802e4e <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802bce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd2:	74 06                	je     802bda <insert_sorted_with_merge_freeList+0x1d0>
  802bd4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bd8:	75 17                	jne    802bf1 <insert_sorted_with_merge_freeList+0x1e7>
  802bda:	83 ec 04             	sub    $0x4,%esp
  802bdd:	68 88 3a 80 00       	push   $0x803a88
  802be2:	68 3a 01 00 00       	push   $0x13a
  802be7:	68 f7 39 80 00       	push   $0x8039f7
  802bec:	e8 86 d6 ff ff       	call   800277 <_panic>
  802bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf4:	8b 50 04             	mov    0x4(%eax),%edx
  802bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfa:	89 50 04             	mov    %edx,0x4(%eax)
  802bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802c00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c03:	89 10                	mov    %edx,(%eax)
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	8b 40 04             	mov    0x4(%eax),%eax
  802c0b:	85 c0                	test   %eax,%eax
  802c0d:	74 0d                	je     802c1c <insert_sorted_with_merge_freeList+0x212>
  802c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c12:	8b 40 04             	mov    0x4(%eax),%eax
  802c15:	8b 55 08             	mov    0x8(%ebp),%edx
  802c18:	89 10                	mov    %edx,(%eax)
  802c1a:	eb 08                	jmp    802c24 <insert_sorted_with_merge_freeList+0x21a>
  802c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1f:	a3 38 41 80 00       	mov    %eax,0x804138
  802c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c27:	8b 55 08             	mov    0x8(%ebp),%edx
  802c2a:	89 50 04             	mov    %edx,0x4(%eax)
  802c2d:	a1 44 41 80 00       	mov    0x804144,%eax
  802c32:	40                   	inc    %eax
  802c33:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802c38:	e9 11 02 00 00       	jmp    802e4e <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802c3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c40:	8b 50 08             	mov    0x8(%eax),%edx
  802c43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c46:	8b 40 0c             	mov    0xc(%eax),%eax
  802c49:	01 c2                	add    %eax,%edx
  802c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c51:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c56:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802c59:	39 c2                	cmp    %eax,%edx
  802c5b:	0f 85 bf 00 00 00    	jne    802d20 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802c61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c64:	8b 50 0c             	mov    0xc(%eax),%edx
  802c67:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6d:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c72:	8b 40 0c             	mov    0xc(%eax),%eax
  802c75:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802c77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7a:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802c7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c81:	75 17                	jne    802c9a <insert_sorted_with_merge_freeList+0x290>
  802c83:	83 ec 04             	sub    $0x4,%esp
  802c86:	68 68 3a 80 00       	push   $0x803a68
  802c8b:	68 43 01 00 00       	push   $0x143
  802c90:	68 f7 39 80 00       	push   $0x8039f7
  802c95:	e8 dd d5 ff ff       	call   800277 <_panic>
  802c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9d:	8b 00                	mov    (%eax),%eax
  802c9f:	85 c0                	test   %eax,%eax
  802ca1:	74 10                	je     802cb3 <insert_sorted_with_merge_freeList+0x2a9>
  802ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca6:	8b 00                	mov    (%eax),%eax
  802ca8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cab:	8b 52 04             	mov    0x4(%edx),%edx
  802cae:	89 50 04             	mov    %edx,0x4(%eax)
  802cb1:	eb 0b                	jmp    802cbe <insert_sorted_with_merge_freeList+0x2b4>
  802cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb6:	8b 40 04             	mov    0x4(%eax),%eax
  802cb9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc1:	8b 40 04             	mov    0x4(%eax),%eax
  802cc4:	85 c0                	test   %eax,%eax
  802cc6:	74 0f                	je     802cd7 <insert_sorted_with_merge_freeList+0x2cd>
  802cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccb:	8b 40 04             	mov    0x4(%eax),%eax
  802cce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd1:	8b 12                	mov    (%edx),%edx
  802cd3:	89 10                	mov    %edx,(%eax)
  802cd5:	eb 0a                	jmp    802ce1 <insert_sorted_with_merge_freeList+0x2d7>
  802cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cda:	8b 00                	mov    (%eax),%eax
  802cdc:	a3 38 41 80 00       	mov    %eax,0x804138
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ced:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf4:	a1 44 41 80 00       	mov    0x804144,%eax
  802cf9:	48                   	dec    %eax
  802cfa:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802cff:	83 ec 0c             	sub    $0xc,%esp
  802d02:	ff 75 08             	pushl  0x8(%ebp)
  802d05:	e8 80 fc ff ff       	call   80298a <addToAvailMemBlocksList>
  802d0a:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802d0d:	83 ec 0c             	sub    $0xc,%esp
  802d10:	ff 75 f4             	pushl  -0xc(%ebp)
  802d13:	e8 72 fc ff ff       	call   80298a <addToAvailMemBlocksList>
  802d18:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802d1b:	e9 2e 01 00 00       	jmp    802e4e <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802d20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d23:	8b 50 08             	mov    0x8(%eax),%edx
  802d26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d29:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2c:	01 c2                	add    %eax,%edx
  802d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d31:	8b 40 08             	mov    0x8(%eax),%eax
  802d34:	39 c2                	cmp    %eax,%edx
  802d36:	75 27                	jne    802d5f <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802d38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3b:	8b 50 0c             	mov    0xc(%eax),%edx
  802d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d41:	8b 40 0c             	mov    0xc(%eax),%eax
  802d44:	01 c2                	add    %eax,%edx
  802d46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d49:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802d4c:	83 ec 0c             	sub    $0xc,%esp
  802d4f:	ff 75 08             	pushl  0x8(%ebp)
  802d52:	e8 33 fc ff ff       	call   80298a <addToAvailMemBlocksList>
  802d57:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802d5a:	e9 ef 00 00 00       	jmp    802e4e <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d62:	8b 50 0c             	mov    0xc(%eax),%edx
  802d65:	8b 45 08             	mov    0x8(%ebp),%eax
  802d68:	8b 40 08             	mov    0x8(%eax),%eax
  802d6b:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d70:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802d73:	39 c2                	cmp    %eax,%edx
  802d75:	75 33                	jne    802daa <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802d77:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7a:	8b 50 08             	mov    0x8(%eax),%edx
  802d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d80:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d86:	8b 50 0c             	mov    0xc(%eax),%edx
  802d89:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8f:	01 c2                	add    %eax,%edx
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802d97:	83 ec 0c             	sub    $0xc,%esp
  802d9a:	ff 75 08             	pushl  0x8(%ebp)
  802d9d:	e8 e8 fb ff ff       	call   80298a <addToAvailMemBlocksList>
  802da2:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802da5:	e9 a4 00 00 00       	jmp    802e4e <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802daa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dae:	74 06                	je     802db6 <insert_sorted_with_merge_freeList+0x3ac>
  802db0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db4:	75 17                	jne    802dcd <insert_sorted_with_merge_freeList+0x3c3>
  802db6:	83 ec 04             	sub    $0x4,%esp
  802db9:	68 88 3a 80 00       	push   $0x803a88
  802dbe:	68 56 01 00 00       	push   $0x156
  802dc3:	68 f7 39 80 00       	push   $0x8039f7
  802dc8:	e8 aa d4 ff ff       	call   800277 <_panic>
  802dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd0:	8b 50 04             	mov    0x4(%eax),%edx
  802dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd6:	89 50 04             	mov    %edx,0x4(%eax)
  802dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ddf:	89 10                	mov    %edx,(%eax)
  802de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de4:	8b 40 04             	mov    0x4(%eax),%eax
  802de7:	85 c0                	test   %eax,%eax
  802de9:	74 0d                	je     802df8 <insert_sorted_with_merge_freeList+0x3ee>
  802deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dee:	8b 40 04             	mov    0x4(%eax),%eax
  802df1:	8b 55 08             	mov    0x8(%ebp),%edx
  802df4:	89 10                	mov    %edx,(%eax)
  802df6:	eb 08                	jmp    802e00 <insert_sorted_with_merge_freeList+0x3f6>
  802df8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfb:	a3 38 41 80 00       	mov    %eax,0x804138
  802e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e03:	8b 55 08             	mov    0x8(%ebp),%edx
  802e06:	89 50 04             	mov    %edx,0x4(%eax)
  802e09:	a1 44 41 80 00       	mov    0x804144,%eax
  802e0e:	40                   	inc    %eax
  802e0f:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802e14:	eb 38                	jmp    802e4e <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802e16:	a1 40 41 80 00       	mov    0x804140,%eax
  802e1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e22:	74 07                	je     802e2b <insert_sorted_with_merge_freeList+0x421>
  802e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e27:	8b 00                	mov    (%eax),%eax
  802e29:	eb 05                	jmp    802e30 <insert_sorted_with_merge_freeList+0x426>
  802e2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802e30:	a3 40 41 80 00       	mov    %eax,0x804140
  802e35:	a1 40 41 80 00       	mov    0x804140,%eax
  802e3a:	85 c0                	test   %eax,%eax
  802e3c:	0f 85 1a fd ff ff    	jne    802b5c <insert_sorted_with_merge_freeList+0x152>
  802e42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e46:	0f 85 10 fd ff ff    	jne    802b5c <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e4c:	eb 00                	jmp    802e4e <insert_sorted_with_merge_freeList+0x444>
  802e4e:	90                   	nop
  802e4f:	c9                   	leave  
  802e50:	c3                   	ret    

00802e51 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802e51:	55                   	push   %ebp
  802e52:	89 e5                	mov    %esp,%ebp
  802e54:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802e57:	8b 55 08             	mov    0x8(%ebp),%edx
  802e5a:	89 d0                	mov    %edx,%eax
  802e5c:	c1 e0 02             	shl    $0x2,%eax
  802e5f:	01 d0                	add    %edx,%eax
  802e61:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e68:	01 d0                	add    %edx,%eax
  802e6a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e71:	01 d0                	add    %edx,%eax
  802e73:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e7a:	01 d0                	add    %edx,%eax
  802e7c:	c1 e0 04             	shl    $0x4,%eax
  802e7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802e82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802e89:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802e8c:	83 ec 0c             	sub    $0xc,%esp
  802e8f:	50                   	push   %eax
  802e90:	e8 60 ed ff ff       	call   801bf5 <sys_get_virtual_time>
  802e95:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802e98:	eb 41                	jmp    802edb <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802e9a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802e9d:	83 ec 0c             	sub    $0xc,%esp
  802ea0:	50                   	push   %eax
  802ea1:	e8 4f ed ff ff       	call   801bf5 <sys_get_virtual_time>
  802ea6:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802ea9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802eac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eaf:	29 c2                	sub    %eax,%edx
  802eb1:	89 d0                	mov    %edx,%eax
  802eb3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802eb6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802eb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ebc:	89 d1                	mov    %edx,%ecx
  802ebe:	29 c1                	sub    %eax,%ecx
  802ec0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802ec3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ec6:	39 c2                	cmp    %eax,%edx
  802ec8:	0f 97 c0             	seta   %al
  802ecb:	0f b6 c0             	movzbl %al,%eax
  802ece:	29 c1                	sub    %eax,%ecx
  802ed0:	89 c8                	mov    %ecx,%eax
  802ed2:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802ed5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ede:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ee1:	72 b7                	jb     802e9a <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802ee3:	90                   	nop
  802ee4:	c9                   	leave  
  802ee5:	c3                   	ret    

00802ee6 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802ee6:	55                   	push   %ebp
  802ee7:	89 e5                	mov    %esp,%ebp
  802ee9:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802eec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802ef3:	eb 03                	jmp    802ef8 <busy_wait+0x12>
  802ef5:	ff 45 fc             	incl   -0x4(%ebp)
  802ef8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802efb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802efe:	72 f5                	jb     802ef5 <busy_wait+0xf>
	return i;
  802f00:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802f03:	c9                   	leave  
  802f04:	c3                   	ret    
  802f05:	66 90                	xchg   %ax,%ax
  802f07:	90                   	nop

00802f08 <__udivdi3>:
  802f08:	55                   	push   %ebp
  802f09:	57                   	push   %edi
  802f0a:	56                   	push   %esi
  802f0b:	53                   	push   %ebx
  802f0c:	83 ec 1c             	sub    $0x1c,%esp
  802f0f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802f13:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802f17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802f1b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f1f:	89 ca                	mov    %ecx,%edx
  802f21:	89 f8                	mov    %edi,%eax
  802f23:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802f27:	85 f6                	test   %esi,%esi
  802f29:	75 2d                	jne    802f58 <__udivdi3+0x50>
  802f2b:	39 cf                	cmp    %ecx,%edi
  802f2d:	77 65                	ja     802f94 <__udivdi3+0x8c>
  802f2f:	89 fd                	mov    %edi,%ebp
  802f31:	85 ff                	test   %edi,%edi
  802f33:	75 0b                	jne    802f40 <__udivdi3+0x38>
  802f35:	b8 01 00 00 00       	mov    $0x1,%eax
  802f3a:	31 d2                	xor    %edx,%edx
  802f3c:	f7 f7                	div    %edi
  802f3e:	89 c5                	mov    %eax,%ebp
  802f40:	31 d2                	xor    %edx,%edx
  802f42:	89 c8                	mov    %ecx,%eax
  802f44:	f7 f5                	div    %ebp
  802f46:	89 c1                	mov    %eax,%ecx
  802f48:	89 d8                	mov    %ebx,%eax
  802f4a:	f7 f5                	div    %ebp
  802f4c:	89 cf                	mov    %ecx,%edi
  802f4e:	89 fa                	mov    %edi,%edx
  802f50:	83 c4 1c             	add    $0x1c,%esp
  802f53:	5b                   	pop    %ebx
  802f54:	5e                   	pop    %esi
  802f55:	5f                   	pop    %edi
  802f56:	5d                   	pop    %ebp
  802f57:	c3                   	ret    
  802f58:	39 ce                	cmp    %ecx,%esi
  802f5a:	77 28                	ja     802f84 <__udivdi3+0x7c>
  802f5c:	0f bd fe             	bsr    %esi,%edi
  802f5f:	83 f7 1f             	xor    $0x1f,%edi
  802f62:	75 40                	jne    802fa4 <__udivdi3+0x9c>
  802f64:	39 ce                	cmp    %ecx,%esi
  802f66:	72 0a                	jb     802f72 <__udivdi3+0x6a>
  802f68:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802f6c:	0f 87 9e 00 00 00    	ja     803010 <__udivdi3+0x108>
  802f72:	b8 01 00 00 00       	mov    $0x1,%eax
  802f77:	89 fa                	mov    %edi,%edx
  802f79:	83 c4 1c             	add    $0x1c,%esp
  802f7c:	5b                   	pop    %ebx
  802f7d:	5e                   	pop    %esi
  802f7e:	5f                   	pop    %edi
  802f7f:	5d                   	pop    %ebp
  802f80:	c3                   	ret    
  802f81:	8d 76 00             	lea    0x0(%esi),%esi
  802f84:	31 ff                	xor    %edi,%edi
  802f86:	31 c0                	xor    %eax,%eax
  802f88:	89 fa                	mov    %edi,%edx
  802f8a:	83 c4 1c             	add    $0x1c,%esp
  802f8d:	5b                   	pop    %ebx
  802f8e:	5e                   	pop    %esi
  802f8f:	5f                   	pop    %edi
  802f90:	5d                   	pop    %ebp
  802f91:	c3                   	ret    
  802f92:	66 90                	xchg   %ax,%ax
  802f94:	89 d8                	mov    %ebx,%eax
  802f96:	f7 f7                	div    %edi
  802f98:	31 ff                	xor    %edi,%edi
  802f9a:	89 fa                	mov    %edi,%edx
  802f9c:	83 c4 1c             	add    $0x1c,%esp
  802f9f:	5b                   	pop    %ebx
  802fa0:	5e                   	pop    %esi
  802fa1:	5f                   	pop    %edi
  802fa2:	5d                   	pop    %ebp
  802fa3:	c3                   	ret    
  802fa4:	bd 20 00 00 00       	mov    $0x20,%ebp
  802fa9:	89 eb                	mov    %ebp,%ebx
  802fab:	29 fb                	sub    %edi,%ebx
  802fad:	89 f9                	mov    %edi,%ecx
  802faf:	d3 e6                	shl    %cl,%esi
  802fb1:	89 c5                	mov    %eax,%ebp
  802fb3:	88 d9                	mov    %bl,%cl
  802fb5:	d3 ed                	shr    %cl,%ebp
  802fb7:	89 e9                	mov    %ebp,%ecx
  802fb9:	09 f1                	or     %esi,%ecx
  802fbb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802fbf:	89 f9                	mov    %edi,%ecx
  802fc1:	d3 e0                	shl    %cl,%eax
  802fc3:	89 c5                	mov    %eax,%ebp
  802fc5:	89 d6                	mov    %edx,%esi
  802fc7:	88 d9                	mov    %bl,%cl
  802fc9:	d3 ee                	shr    %cl,%esi
  802fcb:	89 f9                	mov    %edi,%ecx
  802fcd:	d3 e2                	shl    %cl,%edx
  802fcf:	8b 44 24 08          	mov    0x8(%esp),%eax
  802fd3:	88 d9                	mov    %bl,%cl
  802fd5:	d3 e8                	shr    %cl,%eax
  802fd7:	09 c2                	or     %eax,%edx
  802fd9:	89 d0                	mov    %edx,%eax
  802fdb:	89 f2                	mov    %esi,%edx
  802fdd:	f7 74 24 0c          	divl   0xc(%esp)
  802fe1:	89 d6                	mov    %edx,%esi
  802fe3:	89 c3                	mov    %eax,%ebx
  802fe5:	f7 e5                	mul    %ebp
  802fe7:	39 d6                	cmp    %edx,%esi
  802fe9:	72 19                	jb     803004 <__udivdi3+0xfc>
  802feb:	74 0b                	je     802ff8 <__udivdi3+0xf0>
  802fed:	89 d8                	mov    %ebx,%eax
  802fef:	31 ff                	xor    %edi,%edi
  802ff1:	e9 58 ff ff ff       	jmp    802f4e <__udivdi3+0x46>
  802ff6:	66 90                	xchg   %ax,%ax
  802ff8:	8b 54 24 08          	mov    0x8(%esp),%edx
  802ffc:	89 f9                	mov    %edi,%ecx
  802ffe:	d3 e2                	shl    %cl,%edx
  803000:	39 c2                	cmp    %eax,%edx
  803002:	73 e9                	jae    802fed <__udivdi3+0xe5>
  803004:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803007:	31 ff                	xor    %edi,%edi
  803009:	e9 40 ff ff ff       	jmp    802f4e <__udivdi3+0x46>
  80300e:	66 90                	xchg   %ax,%ax
  803010:	31 c0                	xor    %eax,%eax
  803012:	e9 37 ff ff ff       	jmp    802f4e <__udivdi3+0x46>
  803017:	90                   	nop

00803018 <__umoddi3>:
  803018:	55                   	push   %ebp
  803019:	57                   	push   %edi
  80301a:	56                   	push   %esi
  80301b:	53                   	push   %ebx
  80301c:	83 ec 1c             	sub    $0x1c,%esp
  80301f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803023:	8b 74 24 34          	mov    0x34(%esp),%esi
  803027:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80302b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80302f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803033:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803037:	89 f3                	mov    %esi,%ebx
  803039:	89 fa                	mov    %edi,%edx
  80303b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80303f:	89 34 24             	mov    %esi,(%esp)
  803042:	85 c0                	test   %eax,%eax
  803044:	75 1a                	jne    803060 <__umoddi3+0x48>
  803046:	39 f7                	cmp    %esi,%edi
  803048:	0f 86 a2 00 00 00    	jbe    8030f0 <__umoddi3+0xd8>
  80304e:	89 c8                	mov    %ecx,%eax
  803050:	89 f2                	mov    %esi,%edx
  803052:	f7 f7                	div    %edi
  803054:	89 d0                	mov    %edx,%eax
  803056:	31 d2                	xor    %edx,%edx
  803058:	83 c4 1c             	add    $0x1c,%esp
  80305b:	5b                   	pop    %ebx
  80305c:	5e                   	pop    %esi
  80305d:	5f                   	pop    %edi
  80305e:	5d                   	pop    %ebp
  80305f:	c3                   	ret    
  803060:	39 f0                	cmp    %esi,%eax
  803062:	0f 87 ac 00 00 00    	ja     803114 <__umoddi3+0xfc>
  803068:	0f bd e8             	bsr    %eax,%ebp
  80306b:	83 f5 1f             	xor    $0x1f,%ebp
  80306e:	0f 84 ac 00 00 00    	je     803120 <__umoddi3+0x108>
  803074:	bf 20 00 00 00       	mov    $0x20,%edi
  803079:	29 ef                	sub    %ebp,%edi
  80307b:	89 fe                	mov    %edi,%esi
  80307d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803081:	89 e9                	mov    %ebp,%ecx
  803083:	d3 e0                	shl    %cl,%eax
  803085:	89 d7                	mov    %edx,%edi
  803087:	89 f1                	mov    %esi,%ecx
  803089:	d3 ef                	shr    %cl,%edi
  80308b:	09 c7                	or     %eax,%edi
  80308d:	89 e9                	mov    %ebp,%ecx
  80308f:	d3 e2                	shl    %cl,%edx
  803091:	89 14 24             	mov    %edx,(%esp)
  803094:	89 d8                	mov    %ebx,%eax
  803096:	d3 e0                	shl    %cl,%eax
  803098:	89 c2                	mov    %eax,%edx
  80309a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80309e:	d3 e0                	shl    %cl,%eax
  8030a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030a4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030a8:	89 f1                	mov    %esi,%ecx
  8030aa:	d3 e8                	shr    %cl,%eax
  8030ac:	09 d0                	or     %edx,%eax
  8030ae:	d3 eb                	shr    %cl,%ebx
  8030b0:	89 da                	mov    %ebx,%edx
  8030b2:	f7 f7                	div    %edi
  8030b4:	89 d3                	mov    %edx,%ebx
  8030b6:	f7 24 24             	mull   (%esp)
  8030b9:	89 c6                	mov    %eax,%esi
  8030bb:	89 d1                	mov    %edx,%ecx
  8030bd:	39 d3                	cmp    %edx,%ebx
  8030bf:	0f 82 87 00 00 00    	jb     80314c <__umoddi3+0x134>
  8030c5:	0f 84 91 00 00 00    	je     80315c <__umoddi3+0x144>
  8030cb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8030cf:	29 f2                	sub    %esi,%edx
  8030d1:	19 cb                	sbb    %ecx,%ebx
  8030d3:	89 d8                	mov    %ebx,%eax
  8030d5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8030d9:	d3 e0                	shl    %cl,%eax
  8030db:	89 e9                	mov    %ebp,%ecx
  8030dd:	d3 ea                	shr    %cl,%edx
  8030df:	09 d0                	or     %edx,%eax
  8030e1:	89 e9                	mov    %ebp,%ecx
  8030e3:	d3 eb                	shr    %cl,%ebx
  8030e5:	89 da                	mov    %ebx,%edx
  8030e7:	83 c4 1c             	add    $0x1c,%esp
  8030ea:	5b                   	pop    %ebx
  8030eb:	5e                   	pop    %esi
  8030ec:	5f                   	pop    %edi
  8030ed:	5d                   	pop    %ebp
  8030ee:	c3                   	ret    
  8030ef:	90                   	nop
  8030f0:	89 fd                	mov    %edi,%ebp
  8030f2:	85 ff                	test   %edi,%edi
  8030f4:	75 0b                	jne    803101 <__umoddi3+0xe9>
  8030f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8030fb:	31 d2                	xor    %edx,%edx
  8030fd:	f7 f7                	div    %edi
  8030ff:	89 c5                	mov    %eax,%ebp
  803101:	89 f0                	mov    %esi,%eax
  803103:	31 d2                	xor    %edx,%edx
  803105:	f7 f5                	div    %ebp
  803107:	89 c8                	mov    %ecx,%eax
  803109:	f7 f5                	div    %ebp
  80310b:	89 d0                	mov    %edx,%eax
  80310d:	e9 44 ff ff ff       	jmp    803056 <__umoddi3+0x3e>
  803112:	66 90                	xchg   %ax,%ax
  803114:	89 c8                	mov    %ecx,%eax
  803116:	89 f2                	mov    %esi,%edx
  803118:	83 c4 1c             	add    $0x1c,%esp
  80311b:	5b                   	pop    %ebx
  80311c:	5e                   	pop    %esi
  80311d:	5f                   	pop    %edi
  80311e:	5d                   	pop    %ebp
  80311f:	c3                   	ret    
  803120:	3b 04 24             	cmp    (%esp),%eax
  803123:	72 06                	jb     80312b <__umoddi3+0x113>
  803125:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803129:	77 0f                	ja     80313a <__umoddi3+0x122>
  80312b:	89 f2                	mov    %esi,%edx
  80312d:	29 f9                	sub    %edi,%ecx
  80312f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803133:	89 14 24             	mov    %edx,(%esp)
  803136:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80313a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80313e:	8b 14 24             	mov    (%esp),%edx
  803141:	83 c4 1c             	add    $0x1c,%esp
  803144:	5b                   	pop    %ebx
  803145:	5e                   	pop    %esi
  803146:	5f                   	pop    %edi
  803147:	5d                   	pop    %ebp
  803148:	c3                   	ret    
  803149:	8d 76 00             	lea    0x0(%esi),%esi
  80314c:	2b 04 24             	sub    (%esp),%eax
  80314f:	19 fa                	sbb    %edi,%edx
  803151:	89 d1                	mov    %edx,%ecx
  803153:	89 c6                	mov    %eax,%esi
  803155:	e9 71 ff ff ff       	jmp    8030cb <__umoddi3+0xb3>
  80315a:	66 90                	xchg   %ax,%ax
  80315c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803160:	72 ea                	jb     80314c <__umoddi3+0x134>
  803162:	89 d9                	mov    %ebx,%ecx
  803164:	e9 62 ff ff ff       	jmp    8030cb <__umoddi3+0xb3>
