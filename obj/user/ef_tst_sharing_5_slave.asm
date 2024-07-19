
obj/user/ef_tst_sharing_5_slave:     file format elf32-i386


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
  800031:	e8 e9 00 00 00       	call   80011f <libmain>
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
  80008c:	68 a0 30 80 00       	push   $0x8030a0
  800091:	6a 12                	push   $0x12
  800093:	68 bc 30 80 00       	push   $0x8030bc
  800098:	e8 be 01 00 00       	call   80025b <_panic>
	}

	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  80009d:	e8 04 1b 00 00       	call   801ba6 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 da 30 80 00       	push   $0x8030da
  8000aa:	50                   	push   %eax
  8000ab:	e8 e9 15 00 00       	call   801699 <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000b6:	e8 f2 17 00 00       	call   8018ad <sys_calculate_free_frames>
  8000bb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 dc 30 80 00       	push   $0x8030dc
  8000c6:	e8 44 04 00 00       	call   80050f <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d4:	e8 74 16 00 00       	call   80174d <sfree>
  8000d9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	68 00 31 80 00       	push   $0x803100
  8000e4:	e8 26 04 00 00       	call   80050f <cprintf>
  8000e9:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000ec:	e8 bc 17 00 00       	call   8018ad <sys_calculate_free_frames>
  8000f1:	89 c2                	mov    %eax,%edx
  8000f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f6:	29 c2                	sub    %eax,%edx
  8000f8:	89 d0                	mov    %edx,%eax
  8000fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (diff != 1) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  8000fd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  800101:	74 14                	je     800117 <_main+0xdf>
  800103:	83 ec 04             	sub    $0x4,%esp
  800106:	68 18 31 80 00       	push   $0x803118
  80010b:	6a 1f                	push   $0x1f
  80010d:	68 bc 30 80 00       	push   $0x8030bc
  800112:	e8 44 01 00 00       	call   80025b <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  800117:	e8 af 1b 00 00       	call   801ccb <inctst>

	return;
  80011c:	90                   	nop
}
  80011d:	c9                   	leave  
  80011e:	c3                   	ret    

0080011f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80011f:	55                   	push   %ebp
  800120:	89 e5                	mov    %esp,%ebp
  800122:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800125:	e8 63 1a 00 00       	call   801b8d <sys_getenvindex>
  80012a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80012d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800130:	89 d0                	mov    %edx,%eax
  800132:	c1 e0 03             	shl    $0x3,%eax
  800135:	01 d0                	add    %edx,%eax
  800137:	01 c0                	add    %eax,%eax
  800139:	01 d0                	add    %edx,%eax
  80013b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800142:	01 d0                	add    %edx,%eax
  800144:	c1 e0 04             	shl    $0x4,%eax
  800147:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80014c:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800151:	a1 20 40 80 00       	mov    0x804020,%eax
  800156:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80015c:	84 c0                	test   %al,%al
  80015e:	74 0f                	je     80016f <libmain+0x50>
		binaryname = myEnv->prog_name;
  800160:	a1 20 40 80 00       	mov    0x804020,%eax
  800165:	05 5c 05 00 00       	add    $0x55c,%eax
  80016a:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80016f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800173:	7e 0a                	jle    80017f <libmain+0x60>
		binaryname = argv[0];
  800175:	8b 45 0c             	mov    0xc(%ebp),%eax
  800178:	8b 00                	mov    (%eax),%eax
  80017a:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80017f:	83 ec 08             	sub    $0x8,%esp
  800182:	ff 75 0c             	pushl  0xc(%ebp)
  800185:	ff 75 08             	pushl  0x8(%ebp)
  800188:	e8 ab fe ff ff       	call   800038 <_main>
  80018d:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800190:	e8 05 18 00 00       	call   80199a <sys_disable_interrupt>
	cprintf("**************************************\n");
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	68 bc 31 80 00       	push   $0x8031bc
  80019d:	e8 6d 03 00 00       	call   80050f <cprintf>
  8001a2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8001aa:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001b0:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b5:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001bb:	83 ec 04             	sub    $0x4,%esp
  8001be:	52                   	push   %edx
  8001bf:	50                   	push   %eax
  8001c0:	68 e4 31 80 00       	push   $0x8031e4
  8001c5:	e8 45 03 00 00       	call   80050f <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001cd:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d2:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001d8:	a1 20 40 80 00       	mov    0x804020,%eax
  8001dd:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001e3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e8:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8001ee:	51                   	push   %ecx
  8001ef:	52                   	push   %edx
  8001f0:	50                   	push   %eax
  8001f1:	68 0c 32 80 00       	push   $0x80320c
  8001f6:	e8 14 03 00 00       	call   80050f <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001fe:	a1 20 40 80 00       	mov    0x804020,%eax
  800203:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800209:	83 ec 08             	sub    $0x8,%esp
  80020c:	50                   	push   %eax
  80020d:	68 64 32 80 00       	push   $0x803264
  800212:	e8 f8 02 00 00       	call   80050f <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 bc 31 80 00       	push   $0x8031bc
  800222:	e8 e8 02 00 00       	call   80050f <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80022a:	e8 85 17 00 00       	call   8019b4 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80022f:	e8 19 00 00 00       	call   80024d <exit>
}
  800234:	90                   	nop
  800235:	c9                   	leave  
  800236:	c3                   	ret    

00800237 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800237:	55                   	push   %ebp
  800238:	89 e5                	mov    %esp,%ebp
  80023a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	6a 00                	push   $0x0
  800242:	e8 12 19 00 00       	call   801b59 <sys_destroy_env>
  800247:	83 c4 10             	add    $0x10,%esp
}
  80024a:	90                   	nop
  80024b:	c9                   	leave  
  80024c:	c3                   	ret    

0080024d <exit>:

void
exit(void)
{
  80024d:	55                   	push   %ebp
  80024e:	89 e5                	mov    %esp,%ebp
  800250:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800253:	e8 67 19 00 00       	call   801bbf <sys_exit_env>
}
  800258:	90                   	nop
  800259:	c9                   	leave  
  80025a:	c3                   	ret    

0080025b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80025b:	55                   	push   %ebp
  80025c:	89 e5                	mov    %esp,%ebp
  80025e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800261:	8d 45 10             	lea    0x10(%ebp),%eax
  800264:	83 c0 04             	add    $0x4,%eax
  800267:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80026a:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80026f:	85 c0                	test   %eax,%eax
  800271:	74 16                	je     800289 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800273:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800278:	83 ec 08             	sub    $0x8,%esp
  80027b:	50                   	push   %eax
  80027c:	68 78 32 80 00       	push   $0x803278
  800281:	e8 89 02 00 00       	call   80050f <cprintf>
  800286:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800289:	a1 00 40 80 00       	mov    0x804000,%eax
  80028e:	ff 75 0c             	pushl  0xc(%ebp)
  800291:	ff 75 08             	pushl  0x8(%ebp)
  800294:	50                   	push   %eax
  800295:	68 7d 32 80 00       	push   $0x80327d
  80029a:	e8 70 02 00 00       	call   80050f <cprintf>
  80029f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a5:	83 ec 08             	sub    $0x8,%esp
  8002a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ab:	50                   	push   %eax
  8002ac:	e8 f3 01 00 00       	call   8004a4 <vcprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	6a 00                	push   $0x0
  8002b9:	68 99 32 80 00       	push   $0x803299
  8002be:	e8 e1 01 00 00       	call   8004a4 <vcprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002c6:	e8 82 ff ff ff       	call   80024d <exit>

	// should not return here
	while (1) ;
  8002cb:	eb fe                	jmp    8002cb <_panic+0x70>

008002cd <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002cd:	55                   	push   %ebp
  8002ce:	89 e5                	mov    %esp,%ebp
  8002d0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8002d8:	8b 50 74             	mov    0x74(%eax),%edx
  8002db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002de:	39 c2                	cmp    %eax,%edx
  8002e0:	74 14                	je     8002f6 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002e2:	83 ec 04             	sub    $0x4,%esp
  8002e5:	68 9c 32 80 00       	push   $0x80329c
  8002ea:	6a 26                	push   $0x26
  8002ec:	68 e8 32 80 00       	push   $0x8032e8
  8002f1:	e8 65 ff ff ff       	call   80025b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800304:	e9 c2 00 00 00       	jmp    8003cb <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800309:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80030c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800313:	8b 45 08             	mov    0x8(%ebp),%eax
  800316:	01 d0                	add    %edx,%eax
  800318:	8b 00                	mov    (%eax),%eax
  80031a:	85 c0                	test   %eax,%eax
  80031c:	75 08                	jne    800326 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80031e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800321:	e9 a2 00 00 00       	jmp    8003c8 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800326:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80032d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800334:	eb 69                	jmp    80039f <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800336:	a1 20 40 80 00       	mov    0x804020,%eax
  80033b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800341:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800344:	89 d0                	mov    %edx,%eax
  800346:	01 c0                	add    %eax,%eax
  800348:	01 d0                	add    %edx,%eax
  80034a:	c1 e0 03             	shl    $0x3,%eax
  80034d:	01 c8                	add    %ecx,%eax
  80034f:	8a 40 04             	mov    0x4(%eax),%al
  800352:	84 c0                	test   %al,%al
  800354:	75 46                	jne    80039c <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800356:	a1 20 40 80 00       	mov    0x804020,%eax
  80035b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800361:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800364:	89 d0                	mov    %edx,%eax
  800366:	01 c0                	add    %eax,%eax
  800368:	01 d0                	add    %edx,%eax
  80036a:	c1 e0 03             	shl    $0x3,%eax
  80036d:	01 c8                	add    %ecx,%eax
  80036f:	8b 00                	mov    (%eax),%eax
  800371:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800374:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800377:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80037c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80037e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800381:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 c8                	add    %ecx,%eax
  80038d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80038f:	39 c2                	cmp    %eax,%edx
  800391:	75 09                	jne    80039c <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800393:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80039a:	eb 12                	jmp    8003ae <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80039c:	ff 45 e8             	incl   -0x18(%ebp)
  80039f:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a4:	8b 50 74             	mov    0x74(%eax),%edx
  8003a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003aa:	39 c2                	cmp    %eax,%edx
  8003ac:	77 88                	ja     800336 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003b2:	75 14                	jne    8003c8 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	68 f4 32 80 00       	push   $0x8032f4
  8003bc:	6a 3a                	push   $0x3a
  8003be:	68 e8 32 80 00       	push   $0x8032e8
  8003c3:	e8 93 fe ff ff       	call   80025b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003c8:	ff 45 f0             	incl   -0x10(%ebp)
  8003cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d1:	0f 8c 32 ff ff ff    	jl     800309 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003d7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003de:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003e5:	eb 26                	jmp    80040d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ec:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003f5:	89 d0                	mov    %edx,%eax
  8003f7:	01 c0                	add    %eax,%eax
  8003f9:	01 d0                	add    %edx,%eax
  8003fb:	c1 e0 03             	shl    $0x3,%eax
  8003fe:	01 c8                	add    %ecx,%eax
  800400:	8a 40 04             	mov    0x4(%eax),%al
  800403:	3c 01                	cmp    $0x1,%al
  800405:	75 03                	jne    80040a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800407:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80040a:	ff 45 e0             	incl   -0x20(%ebp)
  80040d:	a1 20 40 80 00       	mov    0x804020,%eax
  800412:	8b 50 74             	mov    0x74(%eax),%edx
  800415:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800418:	39 c2                	cmp    %eax,%edx
  80041a:	77 cb                	ja     8003e7 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80041c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80041f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800422:	74 14                	je     800438 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800424:	83 ec 04             	sub    $0x4,%esp
  800427:	68 48 33 80 00       	push   $0x803348
  80042c:	6a 44                	push   $0x44
  80042e:	68 e8 32 80 00       	push   $0x8032e8
  800433:	e8 23 fe ff ff       	call   80025b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800438:	90                   	nop
  800439:	c9                   	leave  
  80043a:	c3                   	ret    

0080043b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80043b:	55                   	push   %ebp
  80043c:	89 e5                	mov    %esp,%ebp
  80043e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800441:	8b 45 0c             	mov    0xc(%ebp),%eax
  800444:	8b 00                	mov    (%eax),%eax
  800446:	8d 48 01             	lea    0x1(%eax),%ecx
  800449:	8b 55 0c             	mov    0xc(%ebp),%edx
  80044c:	89 0a                	mov    %ecx,(%edx)
  80044e:	8b 55 08             	mov    0x8(%ebp),%edx
  800451:	88 d1                	mov    %dl,%cl
  800453:	8b 55 0c             	mov    0xc(%ebp),%edx
  800456:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80045a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045d:	8b 00                	mov    (%eax),%eax
  80045f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800464:	75 2c                	jne    800492 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800466:	a0 24 40 80 00       	mov    0x804024,%al
  80046b:	0f b6 c0             	movzbl %al,%eax
  80046e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800471:	8b 12                	mov    (%edx),%edx
  800473:	89 d1                	mov    %edx,%ecx
  800475:	8b 55 0c             	mov    0xc(%ebp),%edx
  800478:	83 c2 08             	add    $0x8,%edx
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	50                   	push   %eax
  80047f:	51                   	push   %ecx
  800480:	52                   	push   %edx
  800481:	e8 66 13 00 00       	call   8017ec <sys_cputs>
  800486:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800492:	8b 45 0c             	mov    0xc(%ebp),%eax
  800495:	8b 40 04             	mov    0x4(%eax),%eax
  800498:	8d 50 01             	lea    0x1(%eax),%edx
  80049b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049e:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004a1:	90                   	nop
  8004a2:	c9                   	leave  
  8004a3:	c3                   	ret    

008004a4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004a4:	55                   	push   %ebp
  8004a5:	89 e5                	mov    %esp,%ebp
  8004a7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004ad:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004b4:	00 00 00 
	b.cnt = 0;
  8004b7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004be:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004c1:	ff 75 0c             	pushl  0xc(%ebp)
  8004c4:	ff 75 08             	pushl  0x8(%ebp)
  8004c7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004cd:	50                   	push   %eax
  8004ce:	68 3b 04 80 00       	push   $0x80043b
  8004d3:	e8 11 02 00 00       	call   8006e9 <vprintfmt>
  8004d8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004db:	a0 24 40 80 00       	mov    0x804024,%al
  8004e0:	0f b6 c0             	movzbl %al,%eax
  8004e3:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004e9:	83 ec 04             	sub    $0x4,%esp
  8004ec:	50                   	push   %eax
  8004ed:	52                   	push   %edx
  8004ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f4:	83 c0 08             	add    $0x8,%eax
  8004f7:	50                   	push   %eax
  8004f8:	e8 ef 12 00 00       	call   8017ec <sys_cputs>
  8004fd:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800500:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800507:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80050d:	c9                   	leave  
  80050e:	c3                   	ret    

0080050f <cprintf>:

int cprintf(const char *fmt, ...) {
  80050f:	55                   	push   %ebp
  800510:	89 e5                	mov    %esp,%ebp
  800512:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800515:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80051c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80051f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	83 ec 08             	sub    $0x8,%esp
  800528:	ff 75 f4             	pushl  -0xc(%ebp)
  80052b:	50                   	push   %eax
  80052c:	e8 73 ff ff ff       	call   8004a4 <vcprintf>
  800531:	83 c4 10             	add    $0x10,%esp
  800534:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800537:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    

0080053c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800542:	e8 53 14 00 00       	call   80199a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800547:	8d 45 0c             	lea    0xc(%ebp),%eax
  80054a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80054d:	8b 45 08             	mov    0x8(%ebp),%eax
  800550:	83 ec 08             	sub    $0x8,%esp
  800553:	ff 75 f4             	pushl  -0xc(%ebp)
  800556:	50                   	push   %eax
  800557:	e8 48 ff ff ff       	call   8004a4 <vcprintf>
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800562:	e8 4d 14 00 00       	call   8019b4 <sys_enable_interrupt>
	return cnt;
  800567:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80056a:	c9                   	leave  
  80056b:	c3                   	ret    

0080056c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80056c:	55                   	push   %ebp
  80056d:	89 e5                	mov    %esp,%ebp
  80056f:	53                   	push   %ebx
  800570:	83 ec 14             	sub    $0x14,%esp
  800573:	8b 45 10             	mov    0x10(%ebp),%eax
  800576:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80057f:	8b 45 18             	mov    0x18(%ebp),%eax
  800582:	ba 00 00 00 00       	mov    $0x0,%edx
  800587:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80058a:	77 55                	ja     8005e1 <printnum+0x75>
  80058c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80058f:	72 05                	jb     800596 <printnum+0x2a>
  800591:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800594:	77 4b                	ja     8005e1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800596:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800599:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80059c:	8b 45 18             	mov    0x18(%ebp),%eax
  80059f:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a4:	52                   	push   %edx
  8005a5:	50                   	push   %eax
  8005a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8005ac:	e8 87 28 00 00       	call   802e38 <__udivdi3>
  8005b1:	83 c4 10             	add    $0x10,%esp
  8005b4:	83 ec 04             	sub    $0x4,%esp
  8005b7:	ff 75 20             	pushl  0x20(%ebp)
  8005ba:	53                   	push   %ebx
  8005bb:	ff 75 18             	pushl  0x18(%ebp)
  8005be:	52                   	push   %edx
  8005bf:	50                   	push   %eax
  8005c0:	ff 75 0c             	pushl  0xc(%ebp)
  8005c3:	ff 75 08             	pushl  0x8(%ebp)
  8005c6:	e8 a1 ff ff ff       	call   80056c <printnum>
  8005cb:	83 c4 20             	add    $0x20,%esp
  8005ce:	eb 1a                	jmp    8005ea <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	ff 75 0c             	pushl  0xc(%ebp)
  8005d6:	ff 75 20             	pushl  0x20(%ebp)
  8005d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dc:	ff d0                	call   *%eax
  8005de:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005e1:	ff 4d 1c             	decl   0x1c(%ebp)
  8005e4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005e8:	7f e6                	jg     8005d0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005ea:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005f8:	53                   	push   %ebx
  8005f9:	51                   	push   %ecx
  8005fa:	52                   	push   %edx
  8005fb:	50                   	push   %eax
  8005fc:	e8 47 29 00 00       	call   802f48 <__umoddi3>
  800601:	83 c4 10             	add    $0x10,%esp
  800604:	05 b4 35 80 00       	add    $0x8035b4,%eax
  800609:	8a 00                	mov    (%eax),%al
  80060b:	0f be c0             	movsbl %al,%eax
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	ff 75 0c             	pushl  0xc(%ebp)
  800614:	50                   	push   %eax
  800615:	8b 45 08             	mov    0x8(%ebp),%eax
  800618:	ff d0                	call   *%eax
  80061a:	83 c4 10             	add    $0x10,%esp
}
  80061d:	90                   	nop
  80061e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800621:	c9                   	leave  
  800622:	c3                   	ret    

00800623 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800623:	55                   	push   %ebp
  800624:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800626:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80062a:	7e 1c                	jle    800648 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80062c:	8b 45 08             	mov    0x8(%ebp),%eax
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	8d 50 08             	lea    0x8(%eax),%edx
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	89 10                	mov    %edx,(%eax)
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	83 e8 08             	sub    $0x8,%eax
  800641:	8b 50 04             	mov    0x4(%eax),%edx
  800644:	8b 00                	mov    (%eax),%eax
  800646:	eb 40                	jmp    800688 <getuint+0x65>
	else if (lflag)
  800648:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80064c:	74 1e                	je     80066c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	8b 00                	mov    (%eax),%eax
  800653:	8d 50 04             	lea    0x4(%eax),%edx
  800656:	8b 45 08             	mov    0x8(%ebp),%eax
  800659:	89 10                	mov    %edx,(%eax)
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	83 e8 04             	sub    $0x4,%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	ba 00 00 00 00       	mov    $0x0,%edx
  80066a:	eb 1c                	jmp    800688 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80066c:	8b 45 08             	mov    0x8(%ebp),%eax
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	8d 50 04             	lea    0x4(%eax),%edx
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	89 10                	mov    %edx,(%eax)
  800679:	8b 45 08             	mov    0x8(%ebp),%eax
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	83 e8 04             	sub    $0x4,%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800688:	5d                   	pop    %ebp
  800689:	c3                   	ret    

0080068a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80068a:	55                   	push   %ebp
  80068b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80068d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800691:	7e 1c                	jle    8006af <getint+0x25>
		return va_arg(*ap, long long);
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	8d 50 08             	lea    0x8(%eax),%edx
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	89 10                	mov    %edx,(%eax)
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	83 e8 08             	sub    $0x8,%eax
  8006a8:	8b 50 04             	mov    0x4(%eax),%edx
  8006ab:	8b 00                	mov    (%eax),%eax
  8006ad:	eb 38                	jmp    8006e7 <getint+0x5d>
	else if (lflag)
  8006af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006b3:	74 1a                	je     8006cf <getint+0x45>
		return va_arg(*ap, long);
  8006b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	8d 50 04             	lea    0x4(%eax),%edx
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	89 10                	mov    %edx,(%eax)
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	83 e8 04             	sub    $0x4,%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	99                   	cltd   
  8006cd:	eb 18                	jmp    8006e7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	8d 50 04             	lea    0x4(%eax),%edx
  8006d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006da:	89 10                	mov    %edx,(%eax)
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	83 e8 04             	sub    $0x4,%eax
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	99                   	cltd   
}
  8006e7:	5d                   	pop    %ebp
  8006e8:	c3                   	ret    

008006e9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
  8006ec:	56                   	push   %esi
  8006ed:	53                   	push   %ebx
  8006ee:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f1:	eb 17                	jmp    80070a <vprintfmt+0x21>
			if (ch == '\0')
  8006f3:	85 db                	test   %ebx,%ebx
  8006f5:	0f 84 af 03 00 00    	je     800aaa <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8006fb:	83 ec 08             	sub    $0x8,%esp
  8006fe:	ff 75 0c             	pushl  0xc(%ebp)
  800701:	53                   	push   %ebx
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	ff d0                	call   *%eax
  800707:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070a:	8b 45 10             	mov    0x10(%ebp),%eax
  80070d:	8d 50 01             	lea    0x1(%eax),%edx
  800710:	89 55 10             	mov    %edx,0x10(%ebp)
  800713:	8a 00                	mov    (%eax),%al
  800715:	0f b6 d8             	movzbl %al,%ebx
  800718:	83 fb 25             	cmp    $0x25,%ebx
  80071b:	75 d6                	jne    8006f3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80071d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800721:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800728:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80072f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800736:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80073d:	8b 45 10             	mov    0x10(%ebp),%eax
  800740:	8d 50 01             	lea    0x1(%eax),%edx
  800743:	89 55 10             	mov    %edx,0x10(%ebp)
  800746:	8a 00                	mov    (%eax),%al
  800748:	0f b6 d8             	movzbl %al,%ebx
  80074b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80074e:	83 f8 55             	cmp    $0x55,%eax
  800751:	0f 87 2b 03 00 00    	ja     800a82 <vprintfmt+0x399>
  800757:	8b 04 85 d8 35 80 00 	mov    0x8035d8(,%eax,4),%eax
  80075e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800760:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800764:	eb d7                	jmp    80073d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800766:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80076a:	eb d1                	jmp    80073d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80076c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800773:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800776:	89 d0                	mov    %edx,%eax
  800778:	c1 e0 02             	shl    $0x2,%eax
  80077b:	01 d0                	add    %edx,%eax
  80077d:	01 c0                	add    %eax,%eax
  80077f:	01 d8                	add    %ebx,%eax
  800781:	83 e8 30             	sub    $0x30,%eax
  800784:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800787:	8b 45 10             	mov    0x10(%ebp),%eax
  80078a:	8a 00                	mov    (%eax),%al
  80078c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80078f:	83 fb 2f             	cmp    $0x2f,%ebx
  800792:	7e 3e                	jle    8007d2 <vprintfmt+0xe9>
  800794:	83 fb 39             	cmp    $0x39,%ebx
  800797:	7f 39                	jg     8007d2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800799:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80079c:	eb d5                	jmp    800773 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	83 c0 04             	add    $0x4,%eax
  8007a4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	83 e8 04             	sub    $0x4,%eax
  8007ad:	8b 00                	mov    (%eax),%eax
  8007af:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007b2:	eb 1f                	jmp    8007d3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007b8:	79 83                	jns    80073d <vprintfmt+0x54>
				width = 0;
  8007ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007c1:	e9 77 ff ff ff       	jmp    80073d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007c6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007cd:	e9 6b ff ff ff       	jmp    80073d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007d2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d7:	0f 89 60 ff ff ff    	jns    80073d <vprintfmt+0x54>
				width = precision, precision = -1;
  8007dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007e3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007ea:	e9 4e ff ff ff       	jmp    80073d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007ef:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007f2:	e9 46 ff ff ff       	jmp    80073d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	83 c0 04             	add    $0x4,%eax
  8007fd:	89 45 14             	mov    %eax,0x14(%ebp)
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	83 e8 04             	sub    $0x4,%eax
  800806:	8b 00                	mov    (%eax),%eax
  800808:	83 ec 08             	sub    $0x8,%esp
  80080b:	ff 75 0c             	pushl  0xc(%ebp)
  80080e:	50                   	push   %eax
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	ff d0                	call   *%eax
  800814:	83 c4 10             	add    $0x10,%esp
			break;
  800817:	e9 89 02 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	83 c0 04             	add    $0x4,%eax
  800822:	89 45 14             	mov    %eax,0x14(%ebp)
  800825:	8b 45 14             	mov    0x14(%ebp),%eax
  800828:	83 e8 04             	sub    $0x4,%eax
  80082b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80082d:	85 db                	test   %ebx,%ebx
  80082f:	79 02                	jns    800833 <vprintfmt+0x14a>
				err = -err;
  800831:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800833:	83 fb 64             	cmp    $0x64,%ebx
  800836:	7f 0b                	jg     800843 <vprintfmt+0x15a>
  800838:	8b 34 9d 20 34 80 00 	mov    0x803420(,%ebx,4),%esi
  80083f:	85 f6                	test   %esi,%esi
  800841:	75 19                	jne    80085c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800843:	53                   	push   %ebx
  800844:	68 c5 35 80 00       	push   $0x8035c5
  800849:	ff 75 0c             	pushl  0xc(%ebp)
  80084c:	ff 75 08             	pushl  0x8(%ebp)
  80084f:	e8 5e 02 00 00       	call   800ab2 <printfmt>
  800854:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800857:	e9 49 02 00 00       	jmp    800aa5 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80085c:	56                   	push   %esi
  80085d:	68 ce 35 80 00       	push   $0x8035ce
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	ff 75 08             	pushl  0x8(%ebp)
  800868:	e8 45 02 00 00       	call   800ab2 <printfmt>
  80086d:	83 c4 10             	add    $0x10,%esp
			break;
  800870:	e9 30 02 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	83 c0 04             	add    $0x4,%eax
  80087b:	89 45 14             	mov    %eax,0x14(%ebp)
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 e8 04             	sub    $0x4,%eax
  800884:	8b 30                	mov    (%eax),%esi
  800886:	85 f6                	test   %esi,%esi
  800888:	75 05                	jne    80088f <vprintfmt+0x1a6>
				p = "(null)";
  80088a:	be d1 35 80 00       	mov    $0x8035d1,%esi
			if (width > 0 && padc != '-')
  80088f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800893:	7e 6d                	jle    800902 <vprintfmt+0x219>
  800895:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800899:	74 67                	je     800902 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80089b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089e:	83 ec 08             	sub    $0x8,%esp
  8008a1:	50                   	push   %eax
  8008a2:	56                   	push   %esi
  8008a3:	e8 0c 03 00 00       	call   800bb4 <strnlen>
  8008a8:	83 c4 10             	add    $0x10,%esp
  8008ab:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008ae:	eb 16                	jmp    8008c6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008b0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ba:	50                   	push   %eax
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	ff d0                	call   *%eax
  8008c0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c3:	ff 4d e4             	decl   -0x1c(%ebp)
  8008c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ca:	7f e4                	jg     8008b0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008cc:	eb 34                	jmp    800902 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ce:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008d2:	74 1c                	je     8008f0 <vprintfmt+0x207>
  8008d4:	83 fb 1f             	cmp    $0x1f,%ebx
  8008d7:	7e 05                	jle    8008de <vprintfmt+0x1f5>
  8008d9:	83 fb 7e             	cmp    $0x7e,%ebx
  8008dc:	7e 12                	jle    8008f0 <vprintfmt+0x207>
					putch('?', putdat);
  8008de:	83 ec 08             	sub    $0x8,%esp
  8008e1:	ff 75 0c             	pushl  0xc(%ebp)
  8008e4:	6a 3f                	push   $0x3f
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	ff d0                	call   *%eax
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	eb 0f                	jmp    8008ff <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008f0:	83 ec 08             	sub    $0x8,%esp
  8008f3:	ff 75 0c             	pushl  0xc(%ebp)
  8008f6:	53                   	push   %ebx
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	ff d0                	call   *%eax
  8008fc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008ff:	ff 4d e4             	decl   -0x1c(%ebp)
  800902:	89 f0                	mov    %esi,%eax
  800904:	8d 70 01             	lea    0x1(%eax),%esi
  800907:	8a 00                	mov    (%eax),%al
  800909:	0f be d8             	movsbl %al,%ebx
  80090c:	85 db                	test   %ebx,%ebx
  80090e:	74 24                	je     800934 <vprintfmt+0x24b>
  800910:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800914:	78 b8                	js     8008ce <vprintfmt+0x1e5>
  800916:	ff 4d e0             	decl   -0x20(%ebp)
  800919:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80091d:	79 af                	jns    8008ce <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80091f:	eb 13                	jmp    800934 <vprintfmt+0x24b>
				putch(' ', putdat);
  800921:	83 ec 08             	sub    $0x8,%esp
  800924:	ff 75 0c             	pushl  0xc(%ebp)
  800927:	6a 20                	push   $0x20
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	ff d0                	call   *%eax
  80092e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800931:	ff 4d e4             	decl   -0x1c(%ebp)
  800934:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800938:	7f e7                	jg     800921 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80093a:	e9 66 01 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80093f:	83 ec 08             	sub    $0x8,%esp
  800942:	ff 75 e8             	pushl  -0x18(%ebp)
  800945:	8d 45 14             	lea    0x14(%ebp),%eax
  800948:	50                   	push   %eax
  800949:	e8 3c fd ff ff       	call   80068a <getint>
  80094e:	83 c4 10             	add    $0x10,%esp
  800951:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800954:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800957:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80095a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80095d:	85 d2                	test   %edx,%edx
  80095f:	79 23                	jns    800984 <vprintfmt+0x29b>
				putch('-', putdat);
  800961:	83 ec 08             	sub    $0x8,%esp
  800964:	ff 75 0c             	pushl  0xc(%ebp)
  800967:	6a 2d                	push   $0x2d
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	ff d0                	call   *%eax
  80096e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800971:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800974:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800977:	f7 d8                	neg    %eax
  800979:	83 d2 00             	adc    $0x0,%edx
  80097c:	f7 da                	neg    %edx
  80097e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800981:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800984:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80098b:	e9 bc 00 00 00       	jmp    800a4c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800990:	83 ec 08             	sub    $0x8,%esp
  800993:	ff 75 e8             	pushl  -0x18(%ebp)
  800996:	8d 45 14             	lea    0x14(%ebp),%eax
  800999:	50                   	push   %eax
  80099a:	e8 84 fc ff ff       	call   800623 <getuint>
  80099f:	83 c4 10             	add    $0x10,%esp
  8009a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009a8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009af:	e9 98 00 00 00       	jmp    800a4c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ba:	6a 58                	push   $0x58
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	ff d0                	call   *%eax
  8009c1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ca:	6a 58                	push   $0x58
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	ff d0                	call   *%eax
  8009d1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009d4:	83 ec 08             	sub    $0x8,%esp
  8009d7:	ff 75 0c             	pushl  0xc(%ebp)
  8009da:	6a 58                	push   $0x58
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	ff d0                	call   *%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
			break;
  8009e4:	e9 bc 00 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	6a 30                	push   $0x30
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	ff d0                	call   *%eax
  8009f6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	6a 78                	push   $0x78
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	ff d0                	call   *%eax
  800a06:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a09:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0c:	83 c0 04             	add    $0x4,%eax
  800a0f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a12:	8b 45 14             	mov    0x14(%ebp),%eax
  800a15:	83 e8 04             	sub    $0x4,%eax
  800a18:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a24:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a2b:	eb 1f                	jmp    800a4c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a2d:	83 ec 08             	sub    $0x8,%esp
  800a30:	ff 75 e8             	pushl  -0x18(%ebp)
  800a33:	8d 45 14             	lea    0x14(%ebp),%eax
  800a36:	50                   	push   %eax
  800a37:	e8 e7 fb ff ff       	call   800623 <getuint>
  800a3c:	83 c4 10             	add    $0x10,%esp
  800a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a42:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a45:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a4c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a53:	83 ec 04             	sub    $0x4,%esp
  800a56:	52                   	push   %edx
  800a57:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a5a:	50                   	push   %eax
  800a5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a5e:	ff 75 f0             	pushl  -0x10(%ebp)
  800a61:	ff 75 0c             	pushl  0xc(%ebp)
  800a64:	ff 75 08             	pushl  0x8(%ebp)
  800a67:	e8 00 fb ff ff       	call   80056c <printnum>
  800a6c:	83 c4 20             	add    $0x20,%esp
			break;
  800a6f:	eb 34                	jmp    800aa5 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a71:	83 ec 08             	sub    $0x8,%esp
  800a74:	ff 75 0c             	pushl  0xc(%ebp)
  800a77:	53                   	push   %ebx
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	ff d0                	call   *%eax
  800a7d:	83 c4 10             	add    $0x10,%esp
			break;
  800a80:	eb 23                	jmp    800aa5 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	6a 25                	push   $0x25
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	ff d0                	call   *%eax
  800a8f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a92:	ff 4d 10             	decl   0x10(%ebp)
  800a95:	eb 03                	jmp    800a9a <vprintfmt+0x3b1>
  800a97:	ff 4d 10             	decl   0x10(%ebp)
  800a9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9d:	48                   	dec    %eax
  800a9e:	8a 00                	mov    (%eax),%al
  800aa0:	3c 25                	cmp    $0x25,%al
  800aa2:	75 f3                	jne    800a97 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aa4:	90                   	nop
		}
	}
  800aa5:	e9 47 fc ff ff       	jmp    8006f1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800aaa:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800aab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aae:	5b                   	pop    %ebx
  800aaf:	5e                   	pop    %esi
  800ab0:	5d                   	pop    %ebp
  800ab1:	c3                   	ret    

00800ab2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ab8:	8d 45 10             	lea    0x10(%ebp),%eax
  800abb:	83 c0 04             	add    $0x4,%eax
  800abe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ac1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac7:	50                   	push   %eax
  800ac8:	ff 75 0c             	pushl  0xc(%ebp)
  800acb:	ff 75 08             	pushl  0x8(%ebp)
  800ace:	e8 16 fc ff ff       	call   8006e9 <vprintfmt>
  800ad3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ad6:	90                   	nop
  800ad7:	c9                   	leave  
  800ad8:	c3                   	ret    

00800ad9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adf:	8b 40 08             	mov    0x8(%eax),%eax
  800ae2:	8d 50 01             	lea    0x1(%eax),%edx
  800ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aee:	8b 10                	mov    (%eax),%edx
  800af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af3:	8b 40 04             	mov    0x4(%eax),%eax
  800af6:	39 c2                	cmp    %eax,%edx
  800af8:	73 12                	jae    800b0c <sprintputch+0x33>
		*b->buf++ = ch;
  800afa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afd:	8b 00                	mov    (%eax),%eax
  800aff:	8d 48 01             	lea    0x1(%eax),%ecx
  800b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b05:	89 0a                	mov    %ecx,(%edx)
  800b07:	8b 55 08             	mov    0x8(%ebp),%edx
  800b0a:	88 10                	mov    %dl,(%eax)
}
  800b0c:	90                   	nop
  800b0d:	5d                   	pop    %ebp
  800b0e:	c3                   	ret    

00800b0f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	01 d0                	add    %edx,%eax
  800b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b29:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b34:	74 06                	je     800b3c <vsnprintf+0x2d>
  800b36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b3a:	7f 07                	jg     800b43 <vsnprintf+0x34>
		return -E_INVAL;
  800b3c:	b8 03 00 00 00       	mov    $0x3,%eax
  800b41:	eb 20                	jmp    800b63 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b43:	ff 75 14             	pushl  0x14(%ebp)
  800b46:	ff 75 10             	pushl  0x10(%ebp)
  800b49:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b4c:	50                   	push   %eax
  800b4d:	68 d9 0a 80 00       	push   $0x800ad9
  800b52:	e8 92 fb ff ff       	call   8006e9 <vprintfmt>
  800b57:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b5d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b63:	c9                   	leave  
  800b64:	c3                   	ret    

00800b65 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b6b:	8d 45 10             	lea    0x10(%ebp),%eax
  800b6e:	83 c0 04             	add    $0x4,%eax
  800b71:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b74:	8b 45 10             	mov    0x10(%ebp),%eax
  800b77:	ff 75 f4             	pushl  -0xc(%ebp)
  800b7a:	50                   	push   %eax
  800b7b:	ff 75 0c             	pushl  0xc(%ebp)
  800b7e:	ff 75 08             	pushl  0x8(%ebp)
  800b81:	e8 89 ff ff ff       	call   800b0f <vsnprintf>
  800b86:	83 c4 10             	add    $0x10,%esp
  800b89:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b8f:	c9                   	leave  
  800b90:	c3                   	ret    

00800b91 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b9e:	eb 06                	jmp    800ba6 <strlen+0x15>
		n++;
  800ba0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba3:	ff 45 08             	incl   0x8(%ebp)
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	8a 00                	mov    (%eax),%al
  800bab:	84 c0                	test   %al,%al
  800bad:	75 f1                	jne    800ba0 <strlen+0xf>
		n++;
	return n;
  800baf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bb2:	c9                   	leave  
  800bb3:	c3                   	ret    

00800bb4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc1:	eb 09                	jmp    800bcc <strnlen+0x18>
		n++;
  800bc3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bc6:	ff 45 08             	incl   0x8(%ebp)
  800bc9:	ff 4d 0c             	decl   0xc(%ebp)
  800bcc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd0:	74 09                	je     800bdb <strnlen+0x27>
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	8a 00                	mov    (%eax),%al
  800bd7:	84 c0                	test   %al,%al
  800bd9:	75 e8                	jne    800bc3 <strnlen+0xf>
		n++;
	return n;
  800bdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bde:	c9                   	leave  
  800bdf:	c3                   	ret    

00800be0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bec:	90                   	nop
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	8d 50 01             	lea    0x1(%eax),%edx
  800bf3:	89 55 08             	mov    %edx,0x8(%ebp)
  800bf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bfc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bff:	8a 12                	mov    (%edx),%dl
  800c01:	88 10                	mov    %dl,(%eax)
  800c03:	8a 00                	mov    (%eax),%al
  800c05:	84 c0                	test   %al,%al
  800c07:	75 e4                	jne    800bed <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c09:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    

00800c0e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c21:	eb 1f                	jmp    800c42 <strncpy+0x34>
		*dst++ = *src;
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	8d 50 01             	lea    0x1(%eax),%edx
  800c29:	89 55 08             	mov    %edx,0x8(%ebp)
  800c2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2f:	8a 12                	mov    (%edx),%dl
  800c31:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c36:	8a 00                	mov    (%eax),%al
  800c38:	84 c0                	test   %al,%al
  800c3a:	74 03                	je     800c3f <strncpy+0x31>
			src++;
  800c3c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c3f:	ff 45 fc             	incl   -0x4(%ebp)
  800c42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c45:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c48:	72 d9                	jb     800c23 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c4d:	c9                   	leave  
  800c4e:	c3                   	ret    

00800c4f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c5f:	74 30                	je     800c91 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c61:	eb 16                	jmp    800c79 <strlcpy+0x2a>
			*dst++ = *src++;
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	8d 50 01             	lea    0x1(%eax),%edx
  800c69:	89 55 08             	mov    %edx,0x8(%ebp)
  800c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c72:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c75:	8a 12                	mov    (%edx),%dl
  800c77:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c79:	ff 4d 10             	decl   0x10(%ebp)
  800c7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c80:	74 09                	je     800c8b <strlcpy+0x3c>
  800c82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c85:	8a 00                	mov    (%eax),%al
  800c87:	84 c0                	test   %al,%al
  800c89:	75 d8                	jne    800c63 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c91:	8b 55 08             	mov    0x8(%ebp),%edx
  800c94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c97:	29 c2                	sub    %eax,%edx
  800c99:	89 d0                	mov    %edx,%eax
}
  800c9b:	c9                   	leave  
  800c9c:	c3                   	ret    

00800c9d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ca0:	eb 06                	jmp    800ca8 <strcmp+0xb>
		p++, q++;
  800ca2:	ff 45 08             	incl   0x8(%ebp)
  800ca5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8a 00                	mov    (%eax),%al
  800cad:	84 c0                	test   %al,%al
  800caf:	74 0e                	je     800cbf <strcmp+0x22>
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	8a 10                	mov    (%eax),%dl
  800cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb9:	8a 00                	mov    (%eax),%al
  800cbb:	38 c2                	cmp    %al,%dl
  800cbd:	74 e3                	je     800ca2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	8a 00                	mov    (%eax),%al
  800cc4:	0f b6 d0             	movzbl %al,%edx
  800cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	0f b6 c0             	movzbl %al,%eax
  800ccf:	29 c2                	sub    %eax,%edx
  800cd1:	89 d0                	mov    %edx,%eax
}
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    

00800cd5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cd8:	eb 09                	jmp    800ce3 <strncmp+0xe>
		n--, p++, q++;
  800cda:	ff 4d 10             	decl   0x10(%ebp)
  800cdd:	ff 45 08             	incl   0x8(%ebp)
  800ce0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ce3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce7:	74 17                	je     800d00 <strncmp+0x2b>
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	8a 00                	mov    (%eax),%al
  800cee:	84 c0                	test   %al,%al
  800cf0:	74 0e                	je     800d00 <strncmp+0x2b>
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	8a 10                	mov    (%eax),%dl
  800cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfa:	8a 00                	mov    (%eax),%al
  800cfc:	38 c2                	cmp    %al,%dl
  800cfe:	74 da                	je     800cda <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d04:	75 07                	jne    800d0d <strncmp+0x38>
		return 0;
  800d06:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0b:	eb 14                	jmp    800d21 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	0f b6 d0             	movzbl %al,%edx
  800d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d18:	8a 00                	mov    (%eax),%al
  800d1a:	0f b6 c0             	movzbl %al,%eax
  800d1d:	29 c2                	sub    %eax,%edx
  800d1f:	89 d0                	mov    %edx,%eax
}
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    

00800d23 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	83 ec 04             	sub    $0x4,%esp
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d2f:	eb 12                	jmp    800d43 <strchr+0x20>
		if (*s == c)
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d39:	75 05                	jne    800d40 <strchr+0x1d>
			return (char *) s;
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	eb 11                	jmp    800d51 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d40:	ff 45 08             	incl   0x8(%ebp)
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	84 c0                	test   %al,%al
  800d4a:	75 e5                	jne    800d31 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d51:	c9                   	leave  
  800d52:	c3                   	ret    

00800d53 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	83 ec 04             	sub    $0x4,%esp
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d5f:	eb 0d                	jmp    800d6e <strfind+0x1b>
		if (*s == c)
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	8a 00                	mov    (%eax),%al
  800d66:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d69:	74 0e                	je     800d79 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d6b:	ff 45 08             	incl   0x8(%ebp)
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	8a 00                	mov    (%eax),%al
  800d73:	84 c0                	test   %al,%al
  800d75:	75 ea                	jne    800d61 <strfind+0xe>
  800d77:	eb 01                	jmp    800d7a <strfind+0x27>
		if (*s == c)
			break;
  800d79:	90                   	nop
	return (char *) s;
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d7d:	c9                   	leave  
  800d7e:	c3                   	ret    

00800d7f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d7f:	55                   	push   %ebp
  800d80:	89 e5                	mov    %esp,%ebp
  800d82:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d91:	eb 0e                	jmp    800da1 <memset+0x22>
		*p++ = c;
  800d93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d96:	8d 50 01             	lea    0x1(%eax),%edx
  800d99:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800da1:	ff 4d f8             	decl   -0x8(%ebp)
  800da4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800da8:	79 e9                	jns    800d93 <memset+0x14>
		*p++ = c;

	return v;
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dad:	c9                   	leave  
  800dae:	c3                   	ret    

00800daf <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800db5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dc1:	eb 16                	jmp    800dd9 <memcpy+0x2a>
		*d++ = *s++;
  800dc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc6:	8d 50 01             	lea    0x1(%eax),%edx
  800dc9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dcc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dcf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dd2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dd5:	8a 12                	mov    (%edx),%dl
  800dd7:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ddc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ddf:	89 55 10             	mov    %edx,0x10(%ebp)
  800de2:	85 c0                	test   %eax,%eax
  800de4:	75 dd                	jne    800dc3 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de9:	c9                   	leave  
  800dea:	c3                   	ret    

00800deb <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e00:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e03:	73 50                	jae    800e55 <memmove+0x6a>
  800e05:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e08:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0b:	01 d0                	add    %edx,%eax
  800e0d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e10:	76 43                	jbe    800e55 <memmove+0x6a>
		s += n;
  800e12:	8b 45 10             	mov    0x10(%ebp),%eax
  800e15:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e18:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e1e:	eb 10                	jmp    800e30 <memmove+0x45>
			*--d = *--s;
  800e20:	ff 4d f8             	decl   -0x8(%ebp)
  800e23:	ff 4d fc             	decl   -0x4(%ebp)
  800e26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e29:	8a 10                	mov    (%eax),%dl
  800e2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e2e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e30:	8b 45 10             	mov    0x10(%ebp),%eax
  800e33:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e36:	89 55 10             	mov    %edx,0x10(%ebp)
  800e39:	85 c0                	test   %eax,%eax
  800e3b:	75 e3                	jne    800e20 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e3d:	eb 23                	jmp    800e62 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e42:	8d 50 01             	lea    0x1(%eax),%edx
  800e45:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e48:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e4b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e4e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e51:	8a 12                	mov    (%edx),%dl
  800e53:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e55:	8b 45 10             	mov    0x10(%ebp),%eax
  800e58:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5e:	85 c0                	test   %eax,%eax
  800e60:	75 dd                	jne    800e3f <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e65:	c9                   	leave  
  800e66:	c3                   	ret    

00800e67 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e76:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e79:	eb 2a                	jmp    800ea5 <memcmp+0x3e>
		if (*s1 != *s2)
  800e7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7e:	8a 10                	mov    (%eax),%dl
  800e80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e83:	8a 00                	mov    (%eax),%al
  800e85:	38 c2                	cmp    %al,%dl
  800e87:	74 16                	je     800e9f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	0f b6 d0             	movzbl %al,%edx
  800e91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	0f b6 c0             	movzbl %al,%eax
  800e99:	29 c2                	sub    %eax,%edx
  800e9b:	89 d0                	mov    %edx,%eax
  800e9d:	eb 18                	jmp    800eb7 <memcmp+0x50>
		s1++, s2++;
  800e9f:	ff 45 fc             	incl   -0x4(%ebp)
  800ea2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ea5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eab:	89 55 10             	mov    %edx,0x10(%ebp)
  800eae:	85 c0                	test   %eax,%eax
  800eb0:	75 c9                	jne    800e7b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800eb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eb7:	c9                   	leave  
  800eb8:	c3                   	ret    

00800eb9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec5:	01 d0                	add    %edx,%eax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eca:	eb 15                	jmp    800ee1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	8a 00                	mov    (%eax),%al
  800ed1:	0f b6 d0             	movzbl %al,%edx
  800ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed7:	0f b6 c0             	movzbl %al,%eax
  800eda:	39 c2                	cmp    %eax,%edx
  800edc:	74 0d                	je     800eeb <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ede:	ff 45 08             	incl   0x8(%ebp)
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ee7:	72 e3                	jb     800ecc <memfind+0x13>
  800ee9:	eb 01                	jmp    800eec <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800eeb:	90                   	nop
	return (void *) s;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eef:	c9                   	leave  
  800ef0:	c3                   	ret    

00800ef1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ef7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800efe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f05:	eb 03                	jmp    800f0a <strtol+0x19>
		s++;
  800f07:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	3c 20                	cmp    $0x20,%al
  800f11:	74 f4                	je     800f07 <strtol+0x16>
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	3c 09                	cmp    $0x9,%al
  800f1a:	74 eb                	je     800f07 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8a 00                	mov    (%eax),%al
  800f21:	3c 2b                	cmp    $0x2b,%al
  800f23:	75 05                	jne    800f2a <strtol+0x39>
		s++;
  800f25:	ff 45 08             	incl   0x8(%ebp)
  800f28:	eb 13                	jmp    800f3d <strtol+0x4c>
	else if (*s == '-')
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	3c 2d                	cmp    $0x2d,%al
  800f31:	75 0a                	jne    800f3d <strtol+0x4c>
		s++, neg = 1;
  800f33:	ff 45 08             	incl   0x8(%ebp)
  800f36:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f41:	74 06                	je     800f49 <strtol+0x58>
  800f43:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f47:	75 20                	jne    800f69 <strtol+0x78>
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	3c 30                	cmp    $0x30,%al
  800f50:	75 17                	jne    800f69 <strtol+0x78>
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	40                   	inc    %eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	3c 78                	cmp    $0x78,%al
  800f5a:	75 0d                	jne    800f69 <strtol+0x78>
		s += 2, base = 16;
  800f5c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f60:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f67:	eb 28                	jmp    800f91 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6d:	75 15                	jne    800f84 <strtol+0x93>
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	3c 30                	cmp    $0x30,%al
  800f76:	75 0c                	jne    800f84 <strtol+0x93>
		s++, base = 8;
  800f78:	ff 45 08             	incl   0x8(%ebp)
  800f7b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f82:	eb 0d                	jmp    800f91 <strtol+0xa0>
	else if (base == 0)
  800f84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f88:	75 07                	jne    800f91 <strtol+0xa0>
		base = 10;
  800f8a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	3c 2f                	cmp    $0x2f,%al
  800f98:	7e 19                	jle    800fb3 <strtol+0xc2>
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	8a 00                	mov    (%eax),%al
  800f9f:	3c 39                	cmp    $0x39,%al
  800fa1:	7f 10                	jg     800fb3 <strtol+0xc2>
			dig = *s - '0';
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	0f be c0             	movsbl %al,%eax
  800fab:	83 e8 30             	sub    $0x30,%eax
  800fae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fb1:	eb 42                	jmp    800ff5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	3c 60                	cmp    $0x60,%al
  800fba:	7e 19                	jle    800fd5 <strtol+0xe4>
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	8a 00                	mov    (%eax),%al
  800fc1:	3c 7a                	cmp    $0x7a,%al
  800fc3:	7f 10                	jg     800fd5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	8a 00                	mov    (%eax),%al
  800fca:	0f be c0             	movsbl %al,%eax
  800fcd:	83 e8 57             	sub    $0x57,%eax
  800fd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd3:	eb 20                	jmp    800ff5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	3c 40                	cmp    $0x40,%al
  800fdc:	7e 39                	jle    801017 <strtol+0x126>
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	3c 5a                	cmp    $0x5a,%al
  800fe5:	7f 30                	jg     801017 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	0f be c0             	movsbl %al,%eax
  800fef:	83 e8 37             	sub    $0x37,%eax
  800ff2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ffb:	7d 19                	jge    801016 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ffd:	ff 45 08             	incl   0x8(%ebp)
  801000:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801003:	0f af 45 10          	imul   0x10(%ebp),%eax
  801007:	89 c2                	mov    %eax,%edx
  801009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100c:	01 d0                	add    %edx,%eax
  80100e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801011:	e9 7b ff ff ff       	jmp    800f91 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801016:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801017:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80101b:	74 08                	je     801025 <strtol+0x134>
		*endptr = (char *) s;
  80101d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801020:	8b 55 08             	mov    0x8(%ebp),%edx
  801023:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801025:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801029:	74 07                	je     801032 <strtol+0x141>
  80102b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102e:	f7 d8                	neg    %eax
  801030:	eb 03                	jmp    801035 <strtol+0x144>
  801032:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801035:	c9                   	leave  
  801036:	c3                   	ret    

00801037 <ltostr>:

void
ltostr(long value, char *str)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80103d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801044:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80104b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80104f:	79 13                	jns    801064 <ltostr+0x2d>
	{
		neg = 1;
  801051:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801058:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80105e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801061:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80106c:	99                   	cltd   
  80106d:	f7 f9                	idiv   %ecx
  80106f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801072:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801075:	8d 50 01             	lea    0x1(%eax),%edx
  801078:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80107b:	89 c2                	mov    %eax,%edx
  80107d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801080:	01 d0                	add    %edx,%eax
  801082:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801085:	83 c2 30             	add    $0x30,%edx
  801088:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80108a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80108d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801092:	f7 e9                	imul   %ecx
  801094:	c1 fa 02             	sar    $0x2,%edx
  801097:	89 c8                	mov    %ecx,%eax
  801099:	c1 f8 1f             	sar    $0x1f,%eax
  80109c:	29 c2                	sub    %eax,%edx
  80109e:	89 d0                	mov    %edx,%eax
  8010a0:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ab:	f7 e9                	imul   %ecx
  8010ad:	c1 fa 02             	sar    $0x2,%edx
  8010b0:	89 c8                	mov    %ecx,%eax
  8010b2:	c1 f8 1f             	sar    $0x1f,%eax
  8010b5:	29 c2                	sub    %eax,%edx
  8010b7:	89 d0                	mov    %edx,%eax
  8010b9:	c1 e0 02             	shl    $0x2,%eax
  8010bc:	01 d0                	add    %edx,%eax
  8010be:	01 c0                	add    %eax,%eax
  8010c0:	29 c1                	sub    %eax,%ecx
  8010c2:	89 ca                	mov    %ecx,%edx
  8010c4:	85 d2                	test   %edx,%edx
  8010c6:	75 9c                	jne    801064 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d2:	48                   	dec    %eax
  8010d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010da:	74 3d                	je     801119 <ltostr+0xe2>
		start = 1 ;
  8010dc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010e3:	eb 34                	jmp    801119 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	01 d0                	add    %edx,%eax
  8010ed:	8a 00                	mov    (%eax),%al
  8010ef:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f8:	01 c2                	add    %eax,%edx
  8010fa:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801100:	01 c8                	add    %ecx,%eax
  801102:	8a 00                	mov    (%eax),%al
  801104:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801106:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	01 c2                	add    %eax,%edx
  80110e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801111:	88 02                	mov    %al,(%edx)
		start++ ;
  801113:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801116:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80111f:	7c c4                	jl     8010e5 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801121:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	01 d0                	add    %edx,%eax
  801129:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80112c:	90                   	nop
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    

0080112f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801135:	ff 75 08             	pushl  0x8(%ebp)
  801138:	e8 54 fa ff ff       	call   800b91 <strlen>
  80113d:	83 c4 04             	add    $0x4,%esp
  801140:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801143:	ff 75 0c             	pushl  0xc(%ebp)
  801146:	e8 46 fa ff ff       	call   800b91 <strlen>
  80114b:	83 c4 04             	add    $0x4,%esp
  80114e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801151:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801158:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80115f:	eb 17                	jmp    801178 <strcconcat+0x49>
		final[s] = str1[s] ;
  801161:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801164:	8b 45 10             	mov    0x10(%ebp),%eax
  801167:	01 c2                	add    %eax,%edx
  801169:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	01 c8                	add    %ecx,%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801175:	ff 45 fc             	incl   -0x4(%ebp)
  801178:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80117e:	7c e1                	jl     801161 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801180:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801187:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80118e:	eb 1f                	jmp    8011af <strcconcat+0x80>
		final[s++] = str2[i] ;
  801190:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801193:	8d 50 01             	lea    0x1(%eax),%edx
  801196:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801199:	89 c2                	mov    %eax,%edx
  80119b:	8b 45 10             	mov    0x10(%ebp),%eax
  80119e:	01 c2                	add    %eax,%edx
  8011a0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a6:	01 c8                	add    %ecx,%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011ac:	ff 45 f8             	incl   -0x8(%ebp)
  8011af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011b5:	7c d9                	jl     801190 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bd:	01 d0                	add    %edx,%eax
  8011bf:	c6 00 00             	movb   $0x0,(%eax)
}
  8011c2:	90                   	nop
  8011c3:	c9                   	leave  
  8011c4:	c3                   	ret    

008011c5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d4:	8b 00                	mov    (%eax),%eax
  8011d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e0:	01 d0                	add    %edx,%eax
  8011e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011e8:	eb 0c                	jmp    8011f6 <strsplit+0x31>
			*string++ = 0;
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8d 50 01             	lea    0x1(%eax),%edx
  8011f0:	89 55 08             	mov    %edx,0x8(%ebp)
  8011f3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f9:	8a 00                	mov    (%eax),%al
  8011fb:	84 c0                	test   %al,%al
  8011fd:	74 18                	je     801217 <strsplit+0x52>
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	0f be c0             	movsbl %al,%eax
  801207:	50                   	push   %eax
  801208:	ff 75 0c             	pushl  0xc(%ebp)
  80120b:	e8 13 fb ff ff       	call   800d23 <strchr>
  801210:	83 c4 08             	add    $0x8,%esp
  801213:	85 c0                	test   %eax,%eax
  801215:	75 d3                	jne    8011ea <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	84 c0                	test   %al,%al
  80121e:	74 5a                	je     80127a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801220:	8b 45 14             	mov    0x14(%ebp),%eax
  801223:	8b 00                	mov    (%eax),%eax
  801225:	83 f8 0f             	cmp    $0xf,%eax
  801228:	75 07                	jne    801231 <strsplit+0x6c>
		{
			return 0;
  80122a:	b8 00 00 00 00       	mov    $0x0,%eax
  80122f:	eb 66                	jmp    801297 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801231:	8b 45 14             	mov    0x14(%ebp),%eax
  801234:	8b 00                	mov    (%eax),%eax
  801236:	8d 48 01             	lea    0x1(%eax),%ecx
  801239:	8b 55 14             	mov    0x14(%ebp),%edx
  80123c:	89 0a                	mov    %ecx,(%edx)
  80123e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801245:	8b 45 10             	mov    0x10(%ebp),%eax
  801248:	01 c2                	add    %eax,%edx
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80124f:	eb 03                	jmp    801254 <strsplit+0x8f>
			string++;
  801251:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	84 c0                	test   %al,%al
  80125b:	74 8b                	je     8011e8 <strsplit+0x23>
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8a 00                	mov    (%eax),%al
  801262:	0f be c0             	movsbl %al,%eax
  801265:	50                   	push   %eax
  801266:	ff 75 0c             	pushl  0xc(%ebp)
  801269:	e8 b5 fa ff ff       	call   800d23 <strchr>
  80126e:	83 c4 08             	add    $0x8,%esp
  801271:	85 c0                	test   %eax,%eax
  801273:	74 dc                	je     801251 <strsplit+0x8c>
			string++;
	}
  801275:	e9 6e ff ff ff       	jmp    8011e8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80127a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80127b:	8b 45 14             	mov    0x14(%ebp),%eax
  80127e:	8b 00                	mov    (%eax),%eax
  801280:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801287:	8b 45 10             	mov    0x10(%ebp),%eax
  80128a:	01 d0                	add    %edx,%eax
  80128c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801292:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801297:	c9                   	leave  
  801298:	c3                   	ret    

00801299 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80129f:	a1 04 40 80 00       	mov    0x804004,%eax
  8012a4:	85 c0                	test   %eax,%eax
  8012a6:	74 1f                	je     8012c7 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012a8:	e8 1d 00 00 00       	call   8012ca <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012ad:	83 ec 0c             	sub    $0xc,%esp
  8012b0:	68 30 37 80 00       	push   $0x803730
  8012b5:	e8 55 f2 ff ff       	call   80050f <cprintf>
  8012ba:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012bd:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012c4:	00 00 00 
	}
}
  8012c7:	90                   	nop
  8012c8:	c9                   	leave  
  8012c9:	c3                   	ret    

008012ca <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  8012d0:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8012d7:	00 00 00 
  8012da:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8012e1:	00 00 00 
  8012e4:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8012eb:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8012ee:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8012f5:	00 00 00 
  8012f8:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8012ff:	00 00 00 
  801302:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801309:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  80130c:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801313:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801316:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80131d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801320:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801325:	2d 00 10 00 00       	sub    $0x1000,%eax
  80132a:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  80132f:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801336:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801339:	a1 20 41 80 00       	mov    0x804120,%eax
  80133e:	0f af c2             	imul   %edx,%eax
  801341:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801344:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  80134b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80134e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801351:	01 d0                	add    %edx,%eax
  801353:	48                   	dec    %eax
  801354:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801357:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80135a:	ba 00 00 00 00       	mov    $0x0,%edx
  80135f:	f7 75 e8             	divl   -0x18(%ebp)
  801362:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801365:	29 d0                	sub    %edx,%eax
  801367:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  80136a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80136d:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801374:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801377:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80137d:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801383:	83 ec 04             	sub    $0x4,%esp
  801386:	6a 06                	push   $0x6
  801388:	50                   	push   %eax
  801389:	52                   	push   %edx
  80138a:	e8 a1 05 00 00       	call   801930 <sys_allocate_chunk>
  80138f:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801392:	a1 20 41 80 00       	mov    0x804120,%eax
  801397:	83 ec 0c             	sub    $0xc,%esp
  80139a:	50                   	push   %eax
  80139b:	e8 16 0c 00 00       	call   801fb6 <initialize_MemBlocksList>
  8013a0:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  8013a3:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8013a8:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  8013ab:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8013af:	75 14                	jne    8013c5 <initialize_dyn_block_system+0xfb>
  8013b1:	83 ec 04             	sub    $0x4,%esp
  8013b4:	68 55 37 80 00       	push   $0x803755
  8013b9:	6a 2d                	push   $0x2d
  8013bb:	68 73 37 80 00       	push   $0x803773
  8013c0:	e8 96 ee ff ff       	call   80025b <_panic>
  8013c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013c8:	8b 00                	mov    (%eax),%eax
  8013ca:	85 c0                	test   %eax,%eax
  8013cc:	74 10                	je     8013de <initialize_dyn_block_system+0x114>
  8013ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013d1:	8b 00                	mov    (%eax),%eax
  8013d3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8013d6:	8b 52 04             	mov    0x4(%edx),%edx
  8013d9:	89 50 04             	mov    %edx,0x4(%eax)
  8013dc:	eb 0b                	jmp    8013e9 <initialize_dyn_block_system+0x11f>
  8013de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013e1:	8b 40 04             	mov    0x4(%eax),%eax
  8013e4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8013e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013ec:	8b 40 04             	mov    0x4(%eax),%eax
  8013ef:	85 c0                	test   %eax,%eax
  8013f1:	74 0f                	je     801402 <initialize_dyn_block_system+0x138>
  8013f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013f6:	8b 40 04             	mov    0x4(%eax),%eax
  8013f9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8013fc:	8b 12                	mov    (%edx),%edx
  8013fe:	89 10                	mov    %edx,(%eax)
  801400:	eb 0a                	jmp    80140c <initialize_dyn_block_system+0x142>
  801402:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801405:	8b 00                	mov    (%eax),%eax
  801407:	a3 48 41 80 00       	mov    %eax,0x804148
  80140c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80140f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801415:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801418:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80141f:	a1 54 41 80 00       	mov    0x804154,%eax
  801424:	48                   	dec    %eax
  801425:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  80142a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80142d:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801434:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801437:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  80143e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801442:	75 14                	jne    801458 <initialize_dyn_block_system+0x18e>
  801444:	83 ec 04             	sub    $0x4,%esp
  801447:	68 80 37 80 00       	push   $0x803780
  80144c:	6a 30                	push   $0x30
  80144e:	68 73 37 80 00       	push   $0x803773
  801453:	e8 03 ee ff ff       	call   80025b <_panic>
  801458:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80145e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801461:	89 50 04             	mov    %edx,0x4(%eax)
  801464:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801467:	8b 40 04             	mov    0x4(%eax),%eax
  80146a:	85 c0                	test   %eax,%eax
  80146c:	74 0c                	je     80147a <initialize_dyn_block_system+0x1b0>
  80146e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  801473:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801476:	89 10                	mov    %edx,(%eax)
  801478:	eb 08                	jmp    801482 <initialize_dyn_block_system+0x1b8>
  80147a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80147d:	a3 38 41 80 00       	mov    %eax,0x804138
  801482:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801485:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80148a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80148d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801493:	a1 44 41 80 00       	mov    0x804144,%eax
  801498:	40                   	inc    %eax
  801499:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80149e:	90                   	nop
  80149f:	c9                   	leave  
  8014a0:	c3                   	ret    

008014a1 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
  8014a4:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014a7:	e8 ed fd ff ff       	call   801299 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014b0:	75 07                	jne    8014b9 <malloc+0x18>
  8014b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b7:	eb 67                	jmp    801520 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  8014b9:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c6:	01 d0                	add    %edx,%eax
  8014c8:	48                   	dec    %eax
  8014c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d4:	f7 75 f4             	divl   -0xc(%ebp)
  8014d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014da:	29 d0                	sub    %edx,%eax
  8014dc:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014df:	e8 1a 08 00 00       	call   801cfe <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014e4:	85 c0                	test   %eax,%eax
  8014e6:	74 33                	je     80151b <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  8014e8:	83 ec 0c             	sub    $0xc,%esp
  8014eb:	ff 75 08             	pushl  0x8(%ebp)
  8014ee:	e8 0c 0e 00 00       	call   8022ff <alloc_block_FF>
  8014f3:	83 c4 10             	add    $0x10,%esp
  8014f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  8014f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014fd:	74 1c                	je     80151b <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  8014ff:	83 ec 0c             	sub    $0xc,%esp
  801502:	ff 75 ec             	pushl  -0x14(%ebp)
  801505:	e8 07 0c 00 00       	call   802111 <insert_sorted_allocList>
  80150a:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  80150d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801510:	8b 40 08             	mov    0x8(%eax),%eax
  801513:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801516:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801519:	eb 05                	jmp    801520 <malloc+0x7f>
		}
	}
	return NULL;
  80151b:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801520:	c9                   	leave  
  801521:	c3                   	ret    

00801522 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801522:	55                   	push   %ebp
  801523:	89 e5                	mov    %esp,%ebp
  801525:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
  80152b:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  80152e:	83 ec 08             	sub    $0x8,%esp
  801531:	ff 75 f4             	pushl  -0xc(%ebp)
  801534:	68 40 40 80 00       	push   $0x804040
  801539:	e8 5b 0b 00 00       	call   802099 <find_block>
  80153e:	83 c4 10             	add    $0x10,%esp
  801541:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801544:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801547:	8b 40 0c             	mov    0xc(%eax),%eax
  80154a:	83 ec 08             	sub    $0x8,%esp
  80154d:	50                   	push   %eax
  80154e:	ff 75 f4             	pushl  -0xc(%ebp)
  801551:	e8 a2 03 00 00       	call   8018f8 <sys_free_user_mem>
  801556:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801559:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80155d:	75 14                	jne    801573 <free+0x51>
  80155f:	83 ec 04             	sub    $0x4,%esp
  801562:	68 55 37 80 00       	push   $0x803755
  801567:	6a 76                	push   $0x76
  801569:	68 73 37 80 00       	push   $0x803773
  80156e:	e8 e8 ec ff ff       	call   80025b <_panic>
  801573:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801576:	8b 00                	mov    (%eax),%eax
  801578:	85 c0                	test   %eax,%eax
  80157a:	74 10                	je     80158c <free+0x6a>
  80157c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157f:	8b 00                	mov    (%eax),%eax
  801581:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801584:	8b 52 04             	mov    0x4(%edx),%edx
  801587:	89 50 04             	mov    %edx,0x4(%eax)
  80158a:	eb 0b                	jmp    801597 <free+0x75>
  80158c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158f:	8b 40 04             	mov    0x4(%eax),%eax
  801592:	a3 44 40 80 00       	mov    %eax,0x804044
  801597:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159a:	8b 40 04             	mov    0x4(%eax),%eax
  80159d:	85 c0                	test   %eax,%eax
  80159f:	74 0f                	je     8015b0 <free+0x8e>
  8015a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a4:	8b 40 04             	mov    0x4(%eax),%eax
  8015a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015aa:	8b 12                	mov    (%edx),%edx
  8015ac:	89 10                	mov    %edx,(%eax)
  8015ae:	eb 0a                	jmp    8015ba <free+0x98>
  8015b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b3:	8b 00                	mov    (%eax),%eax
  8015b5:	a3 40 40 80 00       	mov    %eax,0x804040
  8015ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015cd:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015d2:	48                   	dec    %eax
  8015d3:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  8015d8:	83 ec 0c             	sub    $0xc,%esp
  8015db:	ff 75 f0             	pushl  -0x10(%ebp)
  8015de:	e8 0b 14 00 00       	call   8029ee <insert_sorted_with_merge_freeList>
  8015e3:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8015e6:	90                   	nop
  8015e7:	c9                   	leave  
  8015e8:	c3                   	ret    

008015e9 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
  8015ec:	83 ec 28             	sub    $0x28,%esp
  8015ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f2:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015f5:	e8 9f fc ff ff       	call   801299 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015fe:	75 0a                	jne    80160a <smalloc+0x21>
  801600:	b8 00 00 00 00       	mov    $0x0,%eax
  801605:	e9 8d 00 00 00       	jmp    801697 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  80160a:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801611:	8b 55 0c             	mov    0xc(%ebp),%edx
  801614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801617:	01 d0                	add    %edx,%eax
  801619:	48                   	dec    %eax
  80161a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80161d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801620:	ba 00 00 00 00       	mov    $0x0,%edx
  801625:	f7 75 f4             	divl   -0xc(%ebp)
  801628:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162b:	29 d0                	sub    %edx,%eax
  80162d:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801630:	e8 c9 06 00 00       	call   801cfe <sys_isUHeapPlacementStrategyFIRSTFIT>
  801635:	85 c0                	test   %eax,%eax
  801637:	74 59                	je     801692 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801639:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801640:	83 ec 0c             	sub    $0xc,%esp
  801643:	ff 75 0c             	pushl  0xc(%ebp)
  801646:	e8 b4 0c 00 00       	call   8022ff <alloc_block_FF>
  80164b:	83 c4 10             	add    $0x10,%esp
  80164e:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801651:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801655:	75 07                	jne    80165e <smalloc+0x75>
			{
				return NULL;
  801657:	b8 00 00 00 00       	mov    $0x0,%eax
  80165c:	eb 39                	jmp    801697 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  80165e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801661:	8b 40 08             	mov    0x8(%eax),%eax
  801664:	89 c2                	mov    %eax,%edx
  801666:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80166a:	52                   	push   %edx
  80166b:	50                   	push   %eax
  80166c:	ff 75 0c             	pushl  0xc(%ebp)
  80166f:	ff 75 08             	pushl  0x8(%ebp)
  801672:	e8 0c 04 00 00       	call   801a83 <sys_createSharedObject>
  801677:	83 c4 10             	add    $0x10,%esp
  80167a:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  80167d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801681:	78 08                	js     80168b <smalloc+0xa2>
				{
					return (void*)v1->sva;
  801683:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801686:	8b 40 08             	mov    0x8(%eax),%eax
  801689:	eb 0c                	jmp    801697 <smalloc+0xae>
				}
				else
				{
					return NULL;
  80168b:	b8 00 00 00 00       	mov    $0x0,%eax
  801690:	eb 05                	jmp    801697 <smalloc+0xae>
				}
			}

		}
		return NULL;
  801692:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801697:	c9                   	leave  
  801698:	c3                   	ret    

00801699 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
  80169c:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80169f:	e8 f5 fb ff ff       	call   801299 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016a4:	83 ec 08             	sub    $0x8,%esp
  8016a7:	ff 75 0c             	pushl  0xc(%ebp)
  8016aa:	ff 75 08             	pushl  0x8(%ebp)
  8016ad:	e8 fb 03 00 00       	call   801aad <sys_getSizeOfSharedObject>
  8016b2:	83 c4 10             	add    $0x10,%esp
  8016b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  8016b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016bc:	75 07                	jne    8016c5 <sget+0x2c>
	{
		return NULL;
  8016be:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c3:	eb 64                	jmp    801729 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016c5:	e8 34 06 00 00       	call   801cfe <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016ca:	85 c0                	test   %eax,%eax
  8016cc:	74 56                	je     801724 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  8016ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  8016d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d8:	83 ec 0c             	sub    $0xc,%esp
  8016db:	50                   	push   %eax
  8016dc:	e8 1e 0c 00 00       	call   8022ff <alloc_block_FF>
  8016e1:	83 c4 10             	add    $0x10,%esp
  8016e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  8016e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016eb:	75 07                	jne    8016f4 <sget+0x5b>
		{
		return NULL;
  8016ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f2:	eb 35                	jmp    801729 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  8016f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f7:	8b 40 08             	mov    0x8(%eax),%eax
  8016fa:	83 ec 04             	sub    $0x4,%esp
  8016fd:	50                   	push   %eax
  8016fe:	ff 75 0c             	pushl  0xc(%ebp)
  801701:	ff 75 08             	pushl  0x8(%ebp)
  801704:	e8 c1 03 00 00       	call   801aca <sys_getSharedObject>
  801709:	83 c4 10             	add    $0x10,%esp
  80170c:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  80170f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801713:	78 08                	js     80171d <sget+0x84>
			{
				return (void*)v1->sva;
  801715:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801718:	8b 40 08             	mov    0x8(%eax),%eax
  80171b:	eb 0c                	jmp    801729 <sget+0x90>
			}
			else
			{
				return NULL;
  80171d:	b8 00 00 00 00       	mov    $0x0,%eax
  801722:	eb 05                	jmp    801729 <sget+0x90>
			}
		}
	}
  return NULL;
  801724:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
  80172e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801731:	e8 63 fb ff ff       	call   801299 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801736:	83 ec 04             	sub    $0x4,%esp
  801739:	68 a4 37 80 00       	push   $0x8037a4
  80173e:	68 0e 01 00 00       	push   $0x10e
  801743:	68 73 37 80 00       	push   $0x803773
  801748:	e8 0e eb ff ff       	call   80025b <_panic>

0080174d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
  801750:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801753:	83 ec 04             	sub    $0x4,%esp
  801756:	68 cc 37 80 00       	push   $0x8037cc
  80175b:	68 22 01 00 00       	push   $0x122
  801760:	68 73 37 80 00       	push   $0x803773
  801765:	e8 f1 ea ff ff       	call   80025b <_panic>

0080176a <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
  80176d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801770:	83 ec 04             	sub    $0x4,%esp
  801773:	68 f0 37 80 00       	push   $0x8037f0
  801778:	68 2d 01 00 00       	push   $0x12d
  80177d:	68 73 37 80 00       	push   $0x803773
  801782:	e8 d4 ea ff ff       	call   80025b <_panic>

00801787 <shrink>:

}
void shrink(uint32 newSize)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
  80178a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80178d:	83 ec 04             	sub    $0x4,%esp
  801790:	68 f0 37 80 00       	push   $0x8037f0
  801795:	68 32 01 00 00       	push   $0x132
  80179a:	68 73 37 80 00       	push   $0x803773
  80179f:	e8 b7 ea ff ff       	call   80025b <_panic>

008017a4 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017aa:	83 ec 04             	sub    $0x4,%esp
  8017ad:	68 f0 37 80 00       	push   $0x8037f0
  8017b2:	68 37 01 00 00       	push   $0x137
  8017b7:	68 73 37 80 00       	push   $0x803773
  8017bc:	e8 9a ea ff ff       	call   80025b <_panic>

008017c1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	57                   	push   %edi
  8017c5:	56                   	push   %esi
  8017c6:	53                   	push   %ebx
  8017c7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017d3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017d6:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017d9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017dc:	cd 30                	int    $0x30
  8017de:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017e4:	83 c4 10             	add    $0x10,%esp
  8017e7:	5b                   	pop    %ebx
  8017e8:	5e                   	pop    %esi
  8017e9:	5f                   	pop    %edi
  8017ea:	5d                   	pop    %ebp
  8017eb:	c3                   	ret    

008017ec <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	83 ec 04             	sub    $0x4,%esp
  8017f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017f8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	52                   	push   %edx
  801804:	ff 75 0c             	pushl  0xc(%ebp)
  801807:	50                   	push   %eax
  801808:	6a 00                	push   $0x0
  80180a:	e8 b2 ff ff ff       	call   8017c1 <syscall>
  80180f:	83 c4 18             	add    $0x18,%esp
}
  801812:	90                   	nop
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <sys_cgetc>:

int
sys_cgetc(void)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 01                	push   $0x1
  801824:	e8 98 ff ff ff       	call   8017c1 <syscall>
  801829:	83 c4 18             	add    $0x18,%esp
}
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801831:	8b 55 0c             	mov    0xc(%ebp),%edx
  801834:	8b 45 08             	mov    0x8(%ebp),%eax
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	52                   	push   %edx
  80183e:	50                   	push   %eax
  80183f:	6a 05                	push   $0x5
  801841:	e8 7b ff ff ff       	call   8017c1 <syscall>
  801846:	83 c4 18             	add    $0x18,%esp
}
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	56                   	push   %esi
  80184f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801850:	8b 75 18             	mov    0x18(%ebp),%esi
  801853:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801856:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801859:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185c:	8b 45 08             	mov    0x8(%ebp),%eax
  80185f:	56                   	push   %esi
  801860:	53                   	push   %ebx
  801861:	51                   	push   %ecx
  801862:	52                   	push   %edx
  801863:	50                   	push   %eax
  801864:	6a 06                	push   $0x6
  801866:	e8 56 ff ff ff       	call   8017c1 <syscall>
  80186b:	83 c4 18             	add    $0x18,%esp
}
  80186e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801871:	5b                   	pop    %ebx
  801872:	5e                   	pop    %esi
  801873:	5d                   	pop    %ebp
  801874:	c3                   	ret    

00801875 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801878:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	52                   	push   %edx
  801885:	50                   	push   %eax
  801886:	6a 07                	push   $0x7
  801888:	e8 34 ff ff ff       	call   8017c1 <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	ff 75 0c             	pushl  0xc(%ebp)
  80189e:	ff 75 08             	pushl  0x8(%ebp)
  8018a1:	6a 08                	push   $0x8
  8018a3:	e8 19 ff ff ff       	call   8017c1 <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp
}
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    

008018ad <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 09                	push   $0x9
  8018bc:	e8 00 ff ff ff       	call   8017c1 <syscall>
  8018c1:	83 c4 18             	add    $0x18,%esp
}
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 0a                	push   $0xa
  8018d5:	e8 e7 fe ff ff       	call   8017c1 <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 0b                	push   $0xb
  8018ee:	e8 ce fe ff ff       	call   8017c1 <syscall>
  8018f3:	83 c4 18             	add    $0x18,%esp
}
  8018f6:	c9                   	leave  
  8018f7:	c3                   	ret    

008018f8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	ff 75 0c             	pushl  0xc(%ebp)
  801904:	ff 75 08             	pushl  0x8(%ebp)
  801907:	6a 0f                	push   $0xf
  801909:	e8 b3 fe ff ff       	call   8017c1 <syscall>
  80190e:	83 c4 18             	add    $0x18,%esp
	return;
  801911:	90                   	nop
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	ff 75 0c             	pushl  0xc(%ebp)
  801920:	ff 75 08             	pushl  0x8(%ebp)
  801923:	6a 10                	push   $0x10
  801925:	e8 97 fe ff ff       	call   8017c1 <syscall>
  80192a:	83 c4 18             	add    $0x18,%esp
	return ;
  80192d:	90                   	nop
}
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	ff 75 10             	pushl  0x10(%ebp)
  80193a:	ff 75 0c             	pushl  0xc(%ebp)
  80193d:	ff 75 08             	pushl  0x8(%ebp)
  801940:	6a 11                	push   $0x11
  801942:	e8 7a fe ff ff       	call   8017c1 <syscall>
  801947:	83 c4 18             	add    $0x18,%esp
	return ;
  80194a:	90                   	nop
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 0c                	push   $0xc
  80195c:	e8 60 fe ff ff       	call   8017c1 <syscall>
  801961:	83 c4 18             	add    $0x18,%esp
}
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	ff 75 08             	pushl  0x8(%ebp)
  801974:	6a 0d                	push   $0xd
  801976:	e8 46 fe ff ff       	call   8017c1 <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 0e                	push   $0xe
  80198f:	e8 2d fe ff ff       	call   8017c1 <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
}
  801997:	90                   	nop
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 13                	push   $0x13
  8019a9:	e8 13 fe ff ff       	call   8017c1 <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	90                   	nop
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 14                	push   $0x14
  8019c3:	e8 f9 fd ff ff       	call   8017c1 <syscall>
  8019c8:	83 c4 18             	add    $0x18,%esp
}
  8019cb:	90                   	nop
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <sys_cputc>:


void
sys_cputc(const char c)
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
  8019d1:	83 ec 04             	sub    $0x4,%esp
  8019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019da:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	50                   	push   %eax
  8019e7:	6a 15                	push   $0x15
  8019e9:	e8 d3 fd ff ff       	call   8017c1 <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
}
  8019f1:	90                   	nop
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 16                	push   $0x16
  801a03:	e8 b9 fd ff ff       	call   8017c1 <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
}
  801a0b:	90                   	nop
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a11:	8b 45 08             	mov    0x8(%ebp),%eax
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	ff 75 0c             	pushl  0xc(%ebp)
  801a1d:	50                   	push   %eax
  801a1e:	6a 17                	push   $0x17
  801a20:	e8 9c fd ff ff       	call   8017c1 <syscall>
  801a25:	83 c4 18             	add    $0x18,%esp
}
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	52                   	push   %edx
  801a3a:	50                   	push   %eax
  801a3b:	6a 1a                	push   $0x1a
  801a3d:	e8 7f fd ff ff       	call   8017c1 <syscall>
  801a42:	83 c4 18             	add    $0x18,%esp
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	52                   	push   %edx
  801a57:	50                   	push   %eax
  801a58:	6a 18                	push   $0x18
  801a5a:	e8 62 fd ff ff       	call   8017c1 <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
}
  801a62:	90                   	nop
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	52                   	push   %edx
  801a75:	50                   	push   %eax
  801a76:	6a 19                	push   $0x19
  801a78:	e8 44 fd ff ff       	call   8017c1 <syscall>
  801a7d:	83 c4 18             	add    $0x18,%esp
}
  801a80:	90                   	nop
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	83 ec 04             	sub    $0x4,%esp
  801a89:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a8f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a92:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	6a 00                	push   $0x0
  801a9b:	51                   	push   %ecx
  801a9c:	52                   	push   %edx
  801a9d:	ff 75 0c             	pushl  0xc(%ebp)
  801aa0:	50                   	push   %eax
  801aa1:	6a 1b                	push   $0x1b
  801aa3:	e8 19 fd ff ff       	call   8017c1 <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	52                   	push   %edx
  801abd:	50                   	push   %eax
  801abe:	6a 1c                	push   $0x1c
  801ac0:	e8 fc fc ff ff       	call   8017c1 <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
}
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801acd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ad0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	51                   	push   %ecx
  801adb:	52                   	push   %edx
  801adc:	50                   	push   %eax
  801add:	6a 1d                	push   $0x1d
  801adf:	e8 dd fc ff ff       	call   8017c1 <syscall>
  801ae4:	83 c4 18             	add    $0x18,%esp
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801aec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	52                   	push   %edx
  801af9:	50                   	push   %eax
  801afa:	6a 1e                	push   $0x1e
  801afc:	e8 c0 fc ff ff       	call   8017c1 <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
}
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 1f                	push   $0x1f
  801b15:	e8 a7 fc ff ff       	call   8017c1 <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b22:	8b 45 08             	mov    0x8(%ebp),%eax
  801b25:	6a 00                	push   $0x0
  801b27:	ff 75 14             	pushl  0x14(%ebp)
  801b2a:	ff 75 10             	pushl  0x10(%ebp)
  801b2d:	ff 75 0c             	pushl  0xc(%ebp)
  801b30:	50                   	push   %eax
  801b31:	6a 20                	push   $0x20
  801b33:	e8 89 fc ff ff       	call   8017c1 <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b40:	8b 45 08             	mov    0x8(%ebp),%eax
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	50                   	push   %eax
  801b4c:	6a 21                	push   $0x21
  801b4e:	e8 6e fc ff ff       	call   8017c1 <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
}
  801b56:	90                   	nop
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	50                   	push   %eax
  801b68:	6a 22                	push   $0x22
  801b6a:	e8 52 fc ff ff       	call   8017c1 <syscall>
  801b6f:	83 c4 18             	add    $0x18,%esp
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 02                	push   $0x2
  801b83:	e8 39 fc ff ff       	call   8017c1 <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
}
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 03                	push   $0x3
  801b9c:	e8 20 fc ff ff       	call   8017c1 <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 04                	push   $0x4
  801bb5:	e8 07 fc ff ff       	call   8017c1 <syscall>
  801bba:	83 c4 18             	add    $0x18,%esp
}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <sys_exit_env>:


void sys_exit_env(void)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 23                	push   $0x23
  801bce:	e8 ee fb ff ff       	call   8017c1 <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
}
  801bd6:	90                   	nop
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
  801bdc:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bdf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801be2:	8d 50 04             	lea    0x4(%eax),%edx
  801be5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	52                   	push   %edx
  801bef:	50                   	push   %eax
  801bf0:	6a 24                	push   $0x24
  801bf2:	e8 ca fb ff ff       	call   8017c1 <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
	return result;
  801bfa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bfd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c00:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c03:	89 01                	mov    %eax,(%ecx)
  801c05:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c08:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0b:	c9                   	leave  
  801c0c:	c2 04 00             	ret    $0x4

00801c0f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	ff 75 10             	pushl  0x10(%ebp)
  801c19:	ff 75 0c             	pushl  0xc(%ebp)
  801c1c:	ff 75 08             	pushl  0x8(%ebp)
  801c1f:	6a 12                	push   $0x12
  801c21:	e8 9b fb ff ff       	call   8017c1 <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
	return ;
  801c29:	90                   	nop
}
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <sys_rcr2>:
uint32 sys_rcr2()
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 25                	push   $0x25
  801c3b:	e8 81 fb ff ff       	call   8017c1 <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	83 ec 04             	sub    $0x4,%esp
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c51:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	50                   	push   %eax
  801c5e:	6a 26                	push   $0x26
  801c60:	e8 5c fb ff ff       	call   8017c1 <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
	return ;
  801c68:	90                   	nop
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <rsttst>:
void rsttst()
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 28                	push   $0x28
  801c7a:	e8 42 fb ff ff       	call   8017c1 <syscall>
  801c7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c82:	90                   	nop
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	83 ec 04             	sub    $0x4,%esp
  801c8b:	8b 45 14             	mov    0x14(%ebp),%eax
  801c8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c91:	8b 55 18             	mov    0x18(%ebp),%edx
  801c94:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c98:	52                   	push   %edx
  801c99:	50                   	push   %eax
  801c9a:	ff 75 10             	pushl  0x10(%ebp)
  801c9d:	ff 75 0c             	pushl  0xc(%ebp)
  801ca0:	ff 75 08             	pushl  0x8(%ebp)
  801ca3:	6a 27                	push   $0x27
  801ca5:	e8 17 fb ff ff       	call   8017c1 <syscall>
  801caa:	83 c4 18             	add    $0x18,%esp
	return ;
  801cad:	90                   	nop
}
  801cae:	c9                   	leave  
  801caf:	c3                   	ret    

00801cb0 <chktst>:
void chktst(uint32 n)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	ff 75 08             	pushl  0x8(%ebp)
  801cbe:	6a 29                	push   $0x29
  801cc0:	e8 fc fa ff ff       	call   8017c1 <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc8:	90                   	nop
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <inctst>:

void inctst()
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 2a                	push   $0x2a
  801cda:	e8 e2 fa ff ff       	call   8017c1 <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce2:	90                   	nop
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <gettst>:
uint32 gettst()
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 2b                	push   $0x2b
  801cf4:	e8 c8 fa ff ff       	call   8017c1 <syscall>
  801cf9:	83 c4 18             	add    $0x18,%esp
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 2c                	push   $0x2c
  801d10:	e8 ac fa ff ff       	call   8017c1 <syscall>
  801d15:	83 c4 18             	add    $0x18,%esp
  801d18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d1b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d1f:	75 07                	jne    801d28 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d21:	b8 01 00 00 00       	mov    $0x1,%eax
  801d26:	eb 05                	jmp    801d2d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
  801d32:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 2c                	push   $0x2c
  801d41:	e8 7b fa ff ff       	call   8017c1 <syscall>
  801d46:	83 c4 18             	add    $0x18,%esp
  801d49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d4c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d50:	75 07                	jne    801d59 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d52:	b8 01 00 00 00       	mov    $0x1,%eax
  801d57:	eb 05                	jmp    801d5e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d5e:	c9                   	leave  
  801d5f:	c3                   	ret    

00801d60 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
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
  801d72:	e8 4a fa ff ff       	call   8017c1 <syscall>
  801d77:	83 c4 18             	add    $0x18,%esp
  801d7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d7d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d81:	75 07                	jne    801d8a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d83:	b8 01 00 00 00       	mov    $0x1,%eax
  801d88:	eb 05                	jmp    801d8f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  801da3:	e8 19 fa ff ff       	call   8017c1 <syscall>
  801da8:	83 c4 18             	add    $0x18,%esp
  801dab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dae:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801db2:	75 07                	jne    801dbb <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801db4:	b8 01 00 00 00       	mov    $0x1,%eax
  801db9:	eb 05                	jmp    801dc0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	ff 75 08             	pushl  0x8(%ebp)
  801dd0:	6a 2d                	push   $0x2d
  801dd2:	e8 ea f9 ff ff       	call   8017c1 <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dda:	90                   	nop
}
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
  801de0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801de1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801de4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801de7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ded:	6a 00                	push   $0x0
  801def:	53                   	push   %ebx
  801df0:	51                   	push   %ecx
  801df1:	52                   	push   %edx
  801df2:	50                   	push   %eax
  801df3:	6a 2e                	push   $0x2e
  801df5:	e8 c7 f9 ff ff       	call   8017c1 <syscall>
  801dfa:	83 c4 18             	add    $0x18,%esp
}
  801dfd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e08:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	52                   	push   %edx
  801e12:	50                   	push   %eax
  801e13:	6a 2f                	push   $0x2f
  801e15:	e8 a7 f9 ff ff       	call   8017c1 <syscall>
  801e1a:	83 c4 18             	add    $0x18,%esp
}
  801e1d:	c9                   	leave  
  801e1e:	c3                   	ret    

00801e1f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
  801e22:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e25:	83 ec 0c             	sub    $0xc,%esp
  801e28:	68 00 38 80 00       	push   $0x803800
  801e2d:	e8 dd e6 ff ff       	call   80050f <cprintf>
  801e32:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e35:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e3c:	83 ec 0c             	sub    $0xc,%esp
  801e3f:	68 2c 38 80 00       	push   $0x80382c
  801e44:	e8 c6 e6 ff ff       	call   80050f <cprintf>
  801e49:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e4c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e50:	a1 38 41 80 00       	mov    0x804138,%eax
  801e55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e58:	eb 56                	jmp    801eb0 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e5e:	74 1c                	je     801e7c <print_mem_block_lists+0x5d>
  801e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e63:	8b 50 08             	mov    0x8(%eax),%edx
  801e66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e69:	8b 48 08             	mov    0x8(%eax),%ecx
  801e6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e6f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e72:	01 c8                	add    %ecx,%eax
  801e74:	39 c2                	cmp    %eax,%edx
  801e76:	73 04                	jae    801e7c <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e78:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7f:	8b 50 08             	mov    0x8(%eax),%edx
  801e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e85:	8b 40 0c             	mov    0xc(%eax),%eax
  801e88:	01 c2                	add    %eax,%edx
  801e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8d:	8b 40 08             	mov    0x8(%eax),%eax
  801e90:	83 ec 04             	sub    $0x4,%esp
  801e93:	52                   	push   %edx
  801e94:	50                   	push   %eax
  801e95:	68 41 38 80 00       	push   $0x803841
  801e9a:	e8 70 e6 ff ff       	call   80050f <cprintf>
  801e9f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ea8:	a1 40 41 80 00       	mov    0x804140,%eax
  801ead:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eb4:	74 07                	je     801ebd <print_mem_block_lists+0x9e>
  801eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb9:	8b 00                	mov    (%eax),%eax
  801ebb:	eb 05                	jmp    801ec2 <print_mem_block_lists+0xa3>
  801ebd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec2:	a3 40 41 80 00       	mov    %eax,0x804140
  801ec7:	a1 40 41 80 00       	mov    0x804140,%eax
  801ecc:	85 c0                	test   %eax,%eax
  801ece:	75 8a                	jne    801e5a <print_mem_block_lists+0x3b>
  801ed0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ed4:	75 84                	jne    801e5a <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ed6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801eda:	75 10                	jne    801eec <print_mem_block_lists+0xcd>
  801edc:	83 ec 0c             	sub    $0xc,%esp
  801edf:	68 50 38 80 00       	push   $0x803850
  801ee4:	e8 26 e6 ff ff       	call   80050f <cprintf>
  801ee9:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801eec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801ef3:	83 ec 0c             	sub    $0xc,%esp
  801ef6:	68 74 38 80 00       	push   $0x803874
  801efb:	e8 0f e6 ff ff       	call   80050f <cprintf>
  801f00:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f03:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f07:	a1 40 40 80 00       	mov    0x804040,%eax
  801f0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f0f:	eb 56                	jmp    801f67 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f11:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f15:	74 1c                	je     801f33 <print_mem_block_lists+0x114>
  801f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1a:	8b 50 08             	mov    0x8(%eax),%edx
  801f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f20:	8b 48 08             	mov    0x8(%eax),%ecx
  801f23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f26:	8b 40 0c             	mov    0xc(%eax),%eax
  801f29:	01 c8                	add    %ecx,%eax
  801f2b:	39 c2                	cmp    %eax,%edx
  801f2d:	73 04                	jae    801f33 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f2f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f36:	8b 50 08             	mov    0x8(%eax),%edx
  801f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f3f:	01 c2                	add    %eax,%edx
  801f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f44:	8b 40 08             	mov    0x8(%eax),%eax
  801f47:	83 ec 04             	sub    $0x4,%esp
  801f4a:	52                   	push   %edx
  801f4b:	50                   	push   %eax
  801f4c:	68 41 38 80 00       	push   $0x803841
  801f51:	e8 b9 e5 ff ff       	call   80050f <cprintf>
  801f56:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f5f:	a1 48 40 80 00       	mov    0x804048,%eax
  801f64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f6b:	74 07                	je     801f74 <print_mem_block_lists+0x155>
  801f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f70:	8b 00                	mov    (%eax),%eax
  801f72:	eb 05                	jmp    801f79 <print_mem_block_lists+0x15a>
  801f74:	b8 00 00 00 00       	mov    $0x0,%eax
  801f79:	a3 48 40 80 00       	mov    %eax,0x804048
  801f7e:	a1 48 40 80 00       	mov    0x804048,%eax
  801f83:	85 c0                	test   %eax,%eax
  801f85:	75 8a                	jne    801f11 <print_mem_block_lists+0xf2>
  801f87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f8b:	75 84                	jne    801f11 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f8d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f91:	75 10                	jne    801fa3 <print_mem_block_lists+0x184>
  801f93:	83 ec 0c             	sub    $0xc,%esp
  801f96:	68 8c 38 80 00       	push   $0x80388c
  801f9b:	e8 6f e5 ff ff       	call   80050f <cprintf>
  801fa0:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fa3:	83 ec 0c             	sub    $0xc,%esp
  801fa6:	68 00 38 80 00       	push   $0x803800
  801fab:	e8 5f e5 ff ff       	call   80050f <cprintf>
  801fb0:	83 c4 10             	add    $0x10,%esp

}
  801fb3:	90                   	nop
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  801fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbf:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  801fc2:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801fc9:	00 00 00 
  801fcc:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801fd3:	00 00 00 
  801fd6:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801fdd:	00 00 00 
	for(int i = 0; i<n;i++)
  801fe0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801fe7:	e9 9e 00 00 00       	jmp    80208a <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  801fec:	a1 50 40 80 00       	mov    0x804050,%eax
  801ff1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff4:	c1 e2 04             	shl    $0x4,%edx
  801ff7:	01 d0                	add    %edx,%eax
  801ff9:	85 c0                	test   %eax,%eax
  801ffb:	75 14                	jne    802011 <initialize_MemBlocksList+0x5b>
  801ffd:	83 ec 04             	sub    $0x4,%esp
  802000:	68 b4 38 80 00       	push   $0x8038b4
  802005:	6a 47                	push   $0x47
  802007:	68 d7 38 80 00       	push   $0x8038d7
  80200c:	e8 4a e2 ff ff       	call   80025b <_panic>
  802011:	a1 50 40 80 00       	mov    0x804050,%eax
  802016:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802019:	c1 e2 04             	shl    $0x4,%edx
  80201c:	01 d0                	add    %edx,%eax
  80201e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802024:	89 10                	mov    %edx,(%eax)
  802026:	8b 00                	mov    (%eax),%eax
  802028:	85 c0                	test   %eax,%eax
  80202a:	74 18                	je     802044 <initialize_MemBlocksList+0x8e>
  80202c:	a1 48 41 80 00       	mov    0x804148,%eax
  802031:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802037:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80203a:	c1 e1 04             	shl    $0x4,%ecx
  80203d:	01 ca                	add    %ecx,%edx
  80203f:	89 50 04             	mov    %edx,0x4(%eax)
  802042:	eb 12                	jmp    802056 <initialize_MemBlocksList+0xa0>
  802044:	a1 50 40 80 00       	mov    0x804050,%eax
  802049:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204c:	c1 e2 04             	shl    $0x4,%edx
  80204f:	01 d0                	add    %edx,%eax
  802051:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802056:	a1 50 40 80 00       	mov    0x804050,%eax
  80205b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80205e:	c1 e2 04             	shl    $0x4,%edx
  802061:	01 d0                	add    %edx,%eax
  802063:	a3 48 41 80 00       	mov    %eax,0x804148
  802068:	a1 50 40 80 00       	mov    0x804050,%eax
  80206d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802070:	c1 e2 04             	shl    $0x4,%edx
  802073:	01 d0                	add    %edx,%eax
  802075:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80207c:	a1 54 41 80 00       	mov    0x804154,%eax
  802081:	40                   	inc    %eax
  802082:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  802087:	ff 45 f4             	incl   -0xc(%ebp)
  80208a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802090:	0f 82 56 ff ff ff    	jb     801fec <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  802096:	90                   	nop
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  80209f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  8020a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8020ac:	a1 40 40 80 00       	mov    0x804040,%eax
  8020b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020b4:	eb 23                	jmp    8020d9 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  8020b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020b9:	8b 40 08             	mov    0x8(%eax),%eax
  8020bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8020bf:	75 09                	jne    8020ca <find_block+0x31>
		{
			found = 1;
  8020c1:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  8020c8:	eb 35                	jmp    8020ff <find_block+0x66>
		}
		else
		{
			found = 0;
  8020ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8020d1:	a1 48 40 80 00       	mov    0x804048,%eax
  8020d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020dd:	74 07                	je     8020e6 <find_block+0x4d>
  8020df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020e2:	8b 00                	mov    (%eax),%eax
  8020e4:	eb 05                	jmp    8020eb <find_block+0x52>
  8020e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020eb:	a3 48 40 80 00       	mov    %eax,0x804048
  8020f0:	a1 48 40 80 00       	mov    0x804048,%eax
  8020f5:	85 c0                	test   %eax,%eax
  8020f7:	75 bd                	jne    8020b6 <find_block+0x1d>
  8020f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020fd:	75 b7                	jne    8020b6 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  8020ff:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802103:	75 05                	jne    80210a <find_block+0x71>
	{
		return blk;
  802105:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802108:	eb 05                	jmp    80210f <find_block+0x76>
	}
	else
	{
		return NULL;
  80210a:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
  802114:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  80211d:	a1 40 40 80 00       	mov    0x804040,%eax
  802122:	85 c0                	test   %eax,%eax
  802124:	74 12                	je     802138 <insert_sorted_allocList+0x27>
  802126:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802129:	8b 50 08             	mov    0x8(%eax),%edx
  80212c:	a1 40 40 80 00       	mov    0x804040,%eax
  802131:	8b 40 08             	mov    0x8(%eax),%eax
  802134:	39 c2                	cmp    %eax,%edx
  802136:	73 65                	jae    80219d <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802138:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80213c:	75 14                	jne    802152 <insert_sorted_allocList+0x41>
  80213e:	83 ec 04             	sub    $0x4,%esp
  802141:	68 b4 38 80 00       	push   $0x8038b4
  802146:	6a 7b                	push   $0x7b
  802148:	68 d7 38 80 00       	push   $0x8038d7
  80214d:	e8 09 e1 ff ff       	call   80025b <_panic>
  802152:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802158:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215b:	89 10                	mov    %edx,(%eax)
  80215d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802160:	8b 00                	mov    (%eax),%eax
  802162:	85 c0                	test   %eax,%eax
  802164:	74 0d                	je     802173 <insert_sorted_allocList+0x62>
  802166:	a1 40 40 80 00       	mov    0x804040,%eax
  80216b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80216e:	89 50 04             	mov    %edx,0x4(%eax)
  802171:	eb 08                	jmp    80217b <insert_sorted_allocList+0x6a>
  802173:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802176:	a3 44 40 80 00       	mov    %eax,0x804044
  80217b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217e:	a3 40 40 80 00       	mov    %eax,0x804040
  802183:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802186:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80218d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802192:	40                   	inc    %eax
  802193:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802198:	e9 5f 01 00 00       	jmp    8022fc <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  80219d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a0:	8b 50 08             	mov    0x8(%eax),%edx
  8021a3:	a1 44 40 80 00       	mov    0x804044,%eax
  8021a8:	8b 40 08             	mov    0x8(%eax),%eax
  8021ab:	39 c2                	cmp    %eax,%edx
  8021ad:	76 65                	jbe    802214 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  8021af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021b3:	75 14                	jne    8021c9 <insert_sorted_allocList+0xb8>
  8021b5:	83 ec 04             	sub    $0x4,%esp
  8021b8:	68 f0 38 80 00       	push   $0x8038f0
  8021bd:	6a 7f                	push   $0x7f
  8021bf:	68 d7 38 80 00       	push   $0x8038d7
  8021c4:	e8 92 e0 ff ff       	call   80025b <_panic>
  8021c9:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d2:	89 50 04             	mov    %edx,0x4(%eax)
  8021d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d8:	8b 40 04             	mov    0x4(%eax),%eax
  8021db:	85 c0                	test   %eax,%eax
  8021dd:	74 0c                	je     8021eb <insert_sorted_allocList+0xda>
  8021df:	a1 44 40 80 00       	mov    0x804044,%eax
  8021e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021e7:	89 10                	mov    %edx,(%eax)
  8021e9:	eb 08                	jmp    8021f3 <insert_sorted_allocList+0xe2>
  8021eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ee:	a3 40 40 80 00       	mov    %eax,0x804040
  8021f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f6:	a3 44 40 80 00       	mov    %eax,0x804044
  8021fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802204:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802209:	40                   	inc    %eax
  80220a:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80220f:	e9 e8 00 00 00       	jmp    8022fc <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802214:	a1 40 40 80 00       	mov    0x804040,%eax
  802219:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80221c:	e9 ab 00 00 00       	jmp    8022cc <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802221:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802224:	8b 00                	mov    (%eax),%eax
  802226:	85 c0                	test   %eax,%eax
  802228:	0f 84 96 00 00 00    	je     8022c4 <insert_sorted_allocList+0x1b3>
  80222e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802231:	8b 50 08             	mov    0x8(%eax),%edx
  802234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802237:	8b 40 08             	mov    0x8(%eax),%eax
  80223a:	39 c2                	cmp    %eax,%edx
  80223c:	0f 86 82 00 00 00    	jbe    8022c4 <insert_sorted_allocList+0x1b3>
  802242:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802245:	8b 50 08             	mov    0x8(%eax),%edx
  802248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224b:	8b 00                	mov    (%eax),%eax
  80224d:	8b 40 08             	mov    0x8(%eax),%eax
  802250:	39 c2                	cmp    %eax,%edx
  802252:	73 70                	jae    8022c4 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802254:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802258:	74 06                	je     802260 <insert_sorted_allocList+0x14f>
  80225a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80225e:	75 17                	jne    802277 <insert_sorted_allocList+0x166>
  802260:	83 ec 04             	sub    $0x4,%esp
  802263:	68 14 39 80 00       	push   $0x803914
  802268:	68 87 00 00 00       	push   $0x87
  80226d:	68 d7 38 80 00       	push   $0x8038d7
  802272:	e8 e4 df ff ff       	call   80025b <_panic>
  802277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227a:	8b 10                	mov    (%eax),%edx
  80227c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227f:	89 10                	mov    %edx,(%eax)
  802281:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802284:	8b 00                	mov    (%eax),%eax
  802286:	85 c0                	test   %eax,%eax
  802288:	74 0b                	je     802295 <insert_sorted_allocList+0x184>
  80228a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228d:	8b 00                	mov    (%eax),%eax
  80228f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802292:	89 50 04             	mov    %edx,0x4(%eax)
  802295:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802298:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80229b:	89 10                	mov    %edx,(%eax)
  80229d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a3:	89 50 04             	mov    %edx,0x4(%eax)
  8022a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a9:	8b 00                	mov    (%eax),%eax
  8022ab:	85 c0                	test   %eax,%eax
  8022ad:	75 08                	jne    8022b7 <insert_sorted_allocList+0x1a6>
  8022af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b2:	a3 44 40 80 00       	mov    %eax,0x804044
  8022b7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022bc:	40                   	inc    %eax
  8022bd:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8022c2:	eb 38                	jmp    8022fc <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8022c4:	a1 48 40 80 00       	mov    0x804048,%eax
  8022c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d0:	74 07                	je     8022d9 <insert_sorted_allocList+0x1c8>
  8022d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d5:	8b 00                	mov    (%eax),%eax
  8022d7:	eb 05                	jmp    8022de <insert_sorted_allocList+0x1cd>
  8022d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022de:	a3 48 40 80 00       	mov    %eax,0x804048
  8022e3:	a1 48 40 80 00       	mov    0x804048,%eax
  8022e8:	85 c0                	test   %eax,%eax
  8022ea:	0f 85 31 ff ff ff    	jne    802221 <insert_sorted_allocList+0x110>
  8022f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f4:	0f 85 27 ff ff ff    	jne    802221 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  8022fa:	eb 00                	jmp    8022fc <insert_sorted_allocList+0x1eb>
  8022fc:	90                   	nop
  8022fd:	c9                   	leave  
  8022fe:	c3                   	ret    

008022ff <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
  802302:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  80230b:	a1 48 41 80 00       	mov    0x804148,%eax
  802310:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802313:	a1 38 41 80 00       	mov    0x804138,%eax
  802318:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80231b:	e9 77 01 00 00       	jmp    802497 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802323:	8b 40 0c             	mov    0xc(%eax),%eax
  802326:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802329:	0f 85 8a 00 00 00    	jne    8023b9 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80232f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802333:	75 17                	jne    80234c <alloc_block_FF+0x4d>
  802335:	83 ec 04             	sub    $0x4,%esp
  802338:	68 48 39 80 00       	push   $0x803948
  80233d:	68 9e 00 00 00       	push   $0x9e
  802342:	68 d7 38 80 00       	push   $0x8038d7
  802347:	e8 0f df ff ff       	call   80025b <_panic>
  80234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234f:	8b 00                	mov    (%eax),%eax
  802351:	85 c0                	test   %eax,%eax
  802353:	74 10                	je     802365 <alloc_block_FF+0x66>
  802355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802358:	8b 00                	mov    (%eax),%eax
  80235a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80235d:	8b 52 04             	mov    0x4(%edx),%edx
  802360:	89 50 04             	mov    %edx,0x4(%eax)
  802363:	eb 0b                	jmp    802370 <alloc_block_FF+0x71>
  802365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802368:	8b 40 04             	mov    0x4(%eax),%eax
  80236b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802373:	8b 40 04             	mov    0x4(%eax),%eax
  802376:	85 c0                	test   %eax,%eax
  802378:	74 0f                	je     802389 <alloc_block_FF+0x8a>
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	8b 40 04             	mov    0x4(%eax),%eax
  802380:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802383:	8b 12                	mov    (%edx),%edx
  802385:	89 10                	mov    %edx,(%eax)
  802387:	eb 0a                	jmp    802393 <alloc_block_FF+0x94>
  802389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238c:	8b 00                	mov    (%eax),%eax
  80238e:	a3 38 41 80 00       	mov    %eax,0x804138
  802393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802396:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80239c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023a6:	a1 44 41 80 00       	mov    0x804144,%eax
  8023ab:	48                   	dec    %eax
  8023ac:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8023b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b4:	e9 11 01 00 00       	jmp    8024ca <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  8023b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8023bf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8023c2:	0f 86 c7 00 00 00    	jbe    80248f <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8023c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023cc:	75 17                	jne    8023e5 <alloc_block_FF+0xe6>
  8023ce:	83 ec 04             	sub    $0x4,%esp
  8023d1:	68 48 39 80 00       	push   $0x803948
  8023d6:	68 a3 00 00 00       	push   $0xa3
  8023db:	68 d7 38 80 00       	push   $0x8038d7
  8023e0:	e8 76 de ff ff       	call   80025b <_panic>
  8023e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e8:	8b 00                	mov    (%eax),%eax
  8023ea:	85 c0                	test   %eax,%eax
  8023ec:	74 10                	je     8023fe <alloc_block_FF+0xff>
  8023ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f1:	8b 00                	mov    (%eax),%eax
  8023f3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023f6:	8b 52 04             	mov    0x4(%edx),%edx
  8023f9:	89 50 04             	mov    %edx,0x4(%eax)
  8023fc:	eb 0b                	jmp    802409 <alloc_block_FF+0x10a>
  8023fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802401:	8b 40 04             	mov    0x4(%eax),%eax
  802404:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802409:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80240c:	8b 40 04             	mov    0x4(%eax),%eax
  80240f:	85 c0                	test   %eax,%eax
  802411:	74 0f                	je     802422 <alloc_block_FF+0x123>
  802413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802416:	8b 40 04             	mov    0x4(%eax),%eax
  802419:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80241c:	8b 12                	mov    (%edx),%edx
  80241e:	89 10                	mov    %edx,(%eax)
  802420:	eb 0a                	jmp    80242c <alloc_block_FF+0x12d>
  802422:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802425:	8b 00                	mov    (%eax),%eax
  802427:	a3 48 41 80 00       	mov    %eax,0x804148
  80242c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80242f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802435:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802438:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80243f:	a1 54 41 80 00       	mov    0x804154,%eax
  802444:	48                   	dec    %eax
  802445:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  80244a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80244d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802450:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802456:	8b 40 0c             	mov    0xc(%eax),%eax
  802459:	2b 45 f0             	sub    -0x10(%ebp),%eax
  80245c:	89 c2                	mov    %eax,%edx
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	8b 40 08             	mov    0x8(%eax),%eax
  80246a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  80246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802470:	8b 50 08             	mov    0x8(%eax),%edx
  802473:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802476:	8b 40 0c             	mov    0xc(%eax),%eax
  802479:	01 c2                	add    %eax,%edx
  80247b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247e:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802481:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802484:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802487:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  80248a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80248d:	eb 3b                	jmp    8024ca <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80248f:	a1 40 41 80 00       	mov    0x804140,%eax
  802494:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802497:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249b:	74 07                	je     8024a4 <alloc_block_FF+0x1a5>
  80249d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a0:	8b 00                	mov    (%eax),%eax
  8024a2:	eb 05                	jmp    8024a9 <alloc_block_FF+0x1aa>
  8024a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a9:	a3 40 41 80 00       	mov    %eax,0x804140
  8024ae:	a1 40 41 80 00       	mov    0x804140,%eax
  8024b3:	85 c0                	test   %eax,%eax
  8024b5:	0f 85 65 fe ff ff    	jne    802320 <alloc_block_FF+0x21>
  8024bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024bf:	0f 85 5b fe ff ff    	jne    802320 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8024c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ca:	c9                   	leave  
  8024cb:	c3                   	ret    

008024cc <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
  8024cf:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  8024d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  8024d8:	a1 48 41 80 00       	mov    0x804148,%eax
  8024dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  8024e0:	a1 44 41 80 00       	mov    0x804144,%eax
  8024e5:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024e8:	a1 38 41 80 00       	mov    0x804138,%eax
  8024ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024f0:	e9 a1 00 00 00       	jmp    802596 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  8024f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8024fb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8024fe:	0f 85 8a 00 00 00    	jne    80258e <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802504:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802508:	75 17                	jne    802521 <alloc_block_BF+0x55>
  80250a:	83 ec 04             	sub    $0x4,%esp
  80250d:	68 48 39 80 00       	push   $0x803948
  802512:	68 c2 00 00 00       	push   $0xc2
  802517:	68 d7 38 80 00       	push   $0x8038d7
  80251c:	e8 3a dd ff ff       	call   80025b <_panic>
  802521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802524:	8b 00                	mov    (%eax),%eax
  802526:	85 c0                	test   %eax,%eax
  802528:	74 10                	je     80253a <alloc_block_BF+0x6e>
  80252a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252d:	8b 00                	mov    (%eax),%eax
  80252f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802532:	8b 52 04             	mov    0x4(%edx),%edx
  802535:	89 50 04             	mov    %edx,0x4(%eax)
  802538:	eb 0b                	jmp    802545 <alloc_block_BF+0x79>
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	8b 40 04             	mov    0x4(%eax),%eax
  802540:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	8b 40 04             	mov    0x4(%eax),%eax
  80254b:	85 c0                	test   %eax,%eax
  80254d:	74 0f                	je     80255e <alloc_block_BF+0x92>
  80254f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802552:	8b 40 04             	mov    0x4(%eax),%eax
  802555:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802558:	8b 12                	mov    (%edx),%edx
  80255a:	89 10                	mov    %edx,(%eax)
  80255c:	eb 0a                	jmp    802568 <alloc_block_BF+0x9c>
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	8b 00                	mov    (%eax),%eax
  802563:	a3 38 41 80 00       	mov    %eax,0x804138
  802568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802574:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80257b:	a1 44 41 80 00       	mov    0x804144,%eax
  802580:	48                   	dec    %eax
  802581:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802589:	e9 11 02 00 00       	jmp    80279f <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  80258e:	a1 40 41 80 00       	mov    0x804140,%eax
  802593:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802596:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80259a:	74 07                	je     8025a3 <alloc_block_BF+0xd7>
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	8b 00                	mov    (%eax),%eax
  8025a1:	eb 05                	jmp    8025a8 <alloc_block_BF+0xdc>
  8025a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a8:	a3 40 41 80 00       	mov    %eax,0x804140
  8025ad:	a1 40 41 80 00       	mov    0x804140,%eax
  8025b2:	85 c0                	test   %eax,%eax
  8025b4:	0f 85 3b ff ff ff    	jne    8024f5 <alloc_block_BF+0x29>
  8025ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025be:	0f 85 31 ff ff ff    	jne    8024f5 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025c4:	a1 38 41 80 00       	mov    0x804138,%eax
  8025c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025cc:	eb 27                	jmp    8025f5 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  8025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8025d7:	76 14                	jbe    8025ed <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025df:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  8025e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e5:	8b 40 08             	mov    0x8(%eax),%eax
  8025e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  8025eb:	eb 2e                	jmp    80261b <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025ed:	a1 40 41 80 00       	mov    0x804140,%eax
  8025f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f9:	74 07                	je     802602 <alloc_block_BF+0x136>
  8025fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fe:	8b 00                	mov    (%eax),%eax
  802600:	eb 05                	jmp    802607 <alloc_block_BF+0x13b>
  802602:	b8 00 00 00 00       	mov    $0x0,%eax
  802607:	a3 40 41 80 00       	mov    %eax,0x804140
  80260c:	a1 40 41 80 00       	mov    0x804140,%eax
  802611:	85 c0                	test   %eax,%eax
  802613:	75 b9                	jne    8025ce <alloc_block_BF+0x102>
  802615:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802619:	75 b3                	jne    8025ce <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80261b:	a1 38 41 80 00       	mov    0x804138,%eax
  802620:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802623:	eb 30                	jmp    802655 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802628:	8b 40 0c             	mov    0xc(%eax),%eax
  80262b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80262e:	73 1d                	jae    80264d <alloc_block_BF+0x181>
  802630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802633:	8b 40 0c             	mov    0xc(%eax),%eax
  802636:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802639:	76 12                	jbe    80264d <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  80263b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263e:	8b 40 0c             	mov    0xc(%eax),%eax
  802641:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802647:	8b 40 08             	mov    0x8(%eax),%eax
  80264a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80264d:	a1 40 41 80 00       	mov    0x804140,%eax
  802652:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802655:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802659:	74 07                	je     802662 <alloc_block_BF+0x196>
  80265b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265e:	8b 00                	mov    (%eax),%eax
  802660:	eb 05                	jmp    802667 <alloc_block_BF+0x19b>
  802662:	b8 00 00 00 00       	mov    $0x0,%eax
  802667:	a3 40 41 80 00       	mov    %eax,0x804140
  80266c:	a1 40 41 80 00       	mov    0x804140,%eax
  802671:	85 c0                	test   %eax,%eax
  802673:	75 b0                	jne    802625 <alloc_block_BF+0x159>
  802675:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802679:	75 aa                	jne    802625 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80267b:	a1 38 41 80 00       	mov    0x804138,%eax
  802680:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802683:	e9 e4 00 00 00       	jmp    80276c <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268b:	8b 40 0c             	mov    0xc(%eax),%eax
  80268e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802691:	0f 85 cd 00 00 00    	jne    802764 <alloc_block_BF+0x298>
  802697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269a:	8b 40 08             	mov    0x8(%eax),%eax
  80269d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026a0:	0f 85 be 00 00 00    	jne    802764 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  8026a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026aa:	75 17                	jne    8026c3 <alloc_block_BF+0x1f7>
  8026ac:	83 ec 04             	sub    $0x4,%esp
  8026af:	68 48 39 80 00       	push   $0x803948
  8026b4:	68 db 00 00 00       	push   $0xdb
  8026b9:	68 d7 38 80 00       	push   $0x8038d7
  8026be:	e8 98 db ff ff       	call   80025b <_panic>
  8026c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c6:	8b 00                	mov    (%eax),%eax
  8026c8:	85 c0                	test   %eax,%eax
  8026ca:	74 10                	je     8026dc <alloc_block_BF+0x210>
  8026cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026cf:	8b 00                	mov    (%eax),%eax
  8026d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026d4:	8b 52 04             	mov    0x4(%edx),%edx
  8026d7:	89 50 04             	mov    %edx,0x4(%eax)
  8026da:	eb 0b                	jmp    8026e7 <alloc_block_BF+0x21b>
  8026dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026df:	8b 40 04             	mov    0x4(%eax),%eax
  8026e2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ea:	8b 40 04             	mov    0x4(%eax),%eax
  8026ed:	85 c0                	test   %eax,%eax
  8026ef:	74 0f                	je     802700 <alloc_block_BF+0x234>
  8026f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f4:	8b 40 04             	mov    0x4(%eax),%eax
  8026f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026fa:	8b 12                	mov    (%edx),%edx
  8026fc:	89 10                	mov    %edx,(%eax)
  8026fe:	eb 0a                	jmp    80270a <alloc_block_BF+0x23e>
  802700:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802703:	8b 00                	mov    (%eax),%eax
  802705:	a3 48 41 80 00       	mov    %eax,0x804148
  80270a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80270d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802713:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802716:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80271d:	a1 54 41 80 00       	mov    0x804154,%eax
  802722:	48                   	dec    %eax
  802723:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80272b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80272e:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802731:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802734:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802737:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	8b 40 0c             	mov    0xc(%eax),%eax
  802740:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802743:	89 c2                	mov    %eax,%edx
  802745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802748:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  80274b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274e:	8b 50 08             	mov    0x8(%eax),%edx
  802751:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802754:	8b 40 0c             	mov    0xc(%eax),%eax
  802757:	01 c2                	add    %eax,%edx
  802759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275c:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  80275f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802762:	eb 3b                	jmp    80279f <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802764:	a1 40 41 80 00       	mov    0x804140,%eax
  802769:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80276c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802770:	74 07                	je     802779 <alloc_block_BF+0x2ad>
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	8b 00                	mov    (%eax),%eax
  802777:	eb 05                	jmp    80277e <alloc_block_BF+0x2b2>
  802779:	b8 00 00 00 00       	mov    $0x0,%eax
  80277e:	a3 40 41 80 00       	mov    %eax,0x804140
  802783:	a1 40 41 80 00       	mov    0x804140,%eax
  802788:	85 c0                	test   %eax,%eax
  80278a:	0f 85 f8 fe ff ff    	jne    802688 <alloc_block_BF+0x1bc>
  802790:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802794:	0f 85 ee fe ff ff    	jne    802688 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  80279a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80279f:	c9                   	leave  
  8027a0:	c3                   	ret    

008027a1 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027a1:	55                   	push   %ebp
  8027a2:	89 e5                	mov    %esp,%ebp
  8027a4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  8027a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8027ad:	a1 48 41 80 00       	mov    0x804148,%eax
  8027b2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8027b5:	a1 38 41 80 00       	mov    0x804138,%eax
  8027ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027bd:	e9 77 01 00 00       	jmp    802939 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  8027c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027cb:	0f 85 8a 00 00 00    	jne    80285b <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8027d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d5:	75 17                	jne    8027ee <alloc_block_NF+0x4d>
  8027d7:	83 ec 04             	sub    $0x4,%esp
  8027da:	68 48 39 80 00       	push   $0x803948
  8027df:	68 f7 00 00 00       	push   $0xf7
  8027e4:	68 d7 38 80 00       	push   $0x8038d7
  8027e9:	e8 6d da ff ff       	call   80025b <_panic>
  8027ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f1:	8b 00                	mov    (%eax),%eax
  8027f3:	85 c0                	test   %eax,%eax
  8027f5:	74 10                	je     802807 <alloc_block_NF+0x66>
  8027f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fa:	8b 00                	mov    (%eax),%eax
  8027fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ff:	8b 52 04             	mov    0x4(%edx),%edx
  802802:	89 50 04             	mov    %edx,0x4(%eax)
  802805:	eb 0b                	jmp    802812 <alloc_block_NF+0x71>
  802807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280a:	8b 40 04             	mov    0x4(%eax),%eax
  80280d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802815:	8b 40 04             	mov    0x4(%eax),%eax
  802818:	85 c0                	test   %eax,%eax
  80281a:	74 0f                	je     80282b <alloc_block_NF+0x8a>
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	8b 40 04             	mov    0x4(%eax),%eax
  802822:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802825:	8b 12                	mov    (%edx),%edx
  802827:	89 10                	mov    %edx,(%eax)
  802829:	eb 0a                	jmp    802835 <alloc_block_NF+0x94>
  80282b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282e:	8b 00                	mov    (%eax),%eax
  802830:	a3 38 41 80 00       	mov    %eax,0x804138
  802835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802838:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802841:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802848:	a1 44 41 80 00       	mov    0x804144,%eax
  80284d:	48                   	dec    %eax
  80284e:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802856:	e9 11 01 00 00       	jmp    80296c <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  80285b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285e:	8b 40 0c             	mov    0xc(%eax),%eax
  802861:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802864:	0f 86 c7 00 00 00    	jbe    802931 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  80286a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80286e:	75 17                	jne    802887 <alloc_block_NF+0xe6>
  802870:	83 ec 04             	sub    $0x4,%esp
  802873:	68 48 39 80 00       	push   $0x803948
  802878:	68 fc 00 00 00       	push   $0xfc
  80287d:	68 d7 38 80 00       	push   $0x8038d7
  802882:	e8 d4 d9 ff ff       	call   80025b <_panic>
  802887:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288a:	8b 00                	mov    (%eax),%eax
  80288c:	85 c0                	test   %eax,%eax
  80288e:	74 10                	je     8028a0 <alloc_block_NF+0xff>
  802890:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802893:	8b 00                	mov    (%eax),%eax
  802895:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802898:	8b 52 04             	mov    0x4(%edx),%edx
  80289b:	89 50 04             	mov    %edx,0x4(%eax)
  80289e:	eb 0b                	jmp    8028ab <alloc_block_NF+0x10a>
  8028a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a3:	8b 40 04             	mov    0x4(%eax),%eax
  8028a6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ae:	8b 40 04             	mov    0x4(%eax),%eax
  8028b1:	85 c0                	test   %eax,%eax
  8028b3:	74 0f                	je     8028c4 <alloc_block_NF+0x123>
  8028b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b8:	8b 40 04             	mov    0x4(%eax),%eax
  8028bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028be:	8b 12                	mov    (%edx),%edx
  8028c0:	89 10                	mov    %edx,(%eax)
  8028c2:	eb 0a                	jmp    8028ce <alloc_block_NF+0x12d>
  8028c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c7:	8b 00                	mov    (%eax),%eax
  8028c9:	a3 48 41 80 00       	mov    %eax,0x804148
  8028ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e1:	a1 54 41 80 00       	mov    0x804154,%eax
  8028e6:	48                   	dec    %eax
  8028e7:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8028ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028f2:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028fb:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8028fe:	89 c2                	mov    %eax,%edx
  802900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802903:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802909:	8b 40 08             	mov    0x8(%eax),%eax
  80290c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  80290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802912:	8b 50 08             	mov    0x8(%eax),%edx
  802915:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802918:	8b 40 0c             	mov    0xc(%eax),%eax
  80291b:	01 c2                	add    %eax,%edx
  80291d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802920:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802923:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802926:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802929:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  80292c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292f:	eb 3b                	jmp    80296c <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802931:	a1 40 41 80 00       	mov    0x804140,%eax
  802936:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802939:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80293d:	74 07                	je     802946 <alloc_block_NF+0x1a5>
  80293f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802942:	8b 00                	mov    (%eax),%eax
  802944:	eb 05                	jmp    80294b <alloc_block_NF+0x1aa>
  802946:	b8 00 00 00 00       	mov    $0x0,%eax
  80294b:	a3 40 41 80 00       	mov    %eax,0x804140
  802950:	a1 40 41 80 00       	mov    0x804140,%eax
  802955:	85 c0                	test   %eax,%eax
  802957:	0f 85 65 fe ff ff    	jne    8027c2 <alloc_block_NF+0x21>
  80295d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802961:	0f 85 5b fe ff ff    	jne    8027c2 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802967:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80296c:	c9                   	leave  
  80296d:	c3                   	ret    

0080296e <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  80296e:	55                   	push   %ebp
  80296f:	89 e5                	mov    %esp,%ebp
  802971:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802974:	8b 45 08             	mov    0x8(%ebp),%eax
  802977:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  80297e:	8b 45 08             	mov    0x8(%ebp),%eax
  802981:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802988:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80298c:	75 17                	jne    8029a5 <addToAvailMemBlocksList+0x37>
  80298e:	83 ec 04             	sub    $0x4,%esp
  802991:	68 f0 38 80 00       	push   $0x8038f0
  802996:	68 10 01 00 00       	push   $0x110
  80299b:	68 d7 38 80 00       	push   $0x8038d7
  8029a0:	e8 b6 d8 ff ff       	call   80025b <_panic>
  8029a5:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  8029ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ae:	89 50 04             	mov    %edx,0x4(%eax)
  8029b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b4:	8b 40 04             	mov    0x4(%eax),%eax
  8029b7:	85 c0                	test   %eax,%eax
  8029b9:	74 0c                	je     8029c7 <addToAvailMemBlocksList+0x59>
  8029bb:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8029c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c3:	89 10                	mov    %edx,(%eax)
  8029c5:	eb 08                	jmp    8029cf <addToAvailMemBlocksList+0x61>
  8029c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ca:	a3 48 41 80 00       	mov    %eax,0x804148
  8029cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029e0:	a1 54 41 80 00       	mov    0x804154,%eax
  8029e5:	40                   	inc    %eax
  8029e6:	a3 54 41 80 00       	mov    %eax,0x804154
}
  8029eb:	90                   	nop
  8029ec:	c9                   	leave  
  8029ed:	c3                   	ret    

008029ee <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8029ee:	55                   	push   %ebp
  8029ef:	89 e5                	mov    %esp,%ebp
  8029f1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  8029f4:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  8029fc:	a1 44 41 80 00       	mov    0x804144,%eax
  802a01:	85 c0                	test   %eax,%eax
  802a03:	75 68                	jne    802a6d <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802a05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a09:	75 17                	jne    802a22 <insert_sorted_with_merge_freeList+0x34>
  802a0b:	83 ec 04             	sub    $0x4,%esp
  802a0e:	68 b4 38 80 00       	push   $0x8038b4
  802a13:	68 1a 01 00 00       	push   $0x11a
  802a18:	68 d7 38 80 00       	push   $0x8038d7
  802a1d:	e8 39 d8 ff ff       	call   80025b <_panic>
  802a22:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a28:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2b:	89 10                	mov    %edx,(%eax)
  802a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a30:	8b 00                	mov    (%eax),%eax
  802a32:	85 c0                	test   %eax,%eax
  802a34:	74 0d                	je     802a43 <insert_sorted_with_merge_freeList+0x55>
  802a36:	a1 38 41 80 00       	mov    0x804138,%eax
  802a3b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a3e:	89 50 04             	mov    %edx,0x4(%eax)
  802a41:	eb 08                	jmp    802a4b <insert_sorted_with_merge_freeList+0x5d>
  802a43:	8b 45 08             	mov    0x8(%ebp),%eax
  802a46:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4e:	a3 38 41 80 00       	mov    %eax,0x804138
  802a53:	8b 45 08             	mov    0x8(%ebp),%eax
  802a56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a5d:	a1 44 41 80 00       	mov    0x804144,%eax
  802a62:	40                   	inc    %eax
  802a63:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802a68:	e9 c5 03 00 00       	jmp    802e32 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a70:	8b 50 08             	mov    0x8(%eax),%edx
  802a73:	8b 45 08             	mov    0x8(%ebp),%eax
  802a76:	8b 40 08             	mov    0x8(%eax),%eax
  802a79:	39 c2                	cmp    %eax,%edx
  802a7b:	0f 83 b2 00 00 00    	jae    802b33 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802a81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a84:	8b 50 08             	mov    0x8(%eax),%edx
  802a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a8d:	01 c2                	add    %eax,%edx
  802a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a92:	8b 40 08             	mov    0x8(%eax),%eax
  802a95:	39 c2                	cmp    %eax,%edx
  802a97:	75 27                	jne    802ac0 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9c:	8b 50 0c             	mov    0xc(%eax),%edx
  802a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa2:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa5:	01 c2                	add    %eax,%edx
  802aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aaa:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802aad:	83 ec 0c             	sub    $0xc,%esp
  802ab0:	ff 75 08             	pushl  0x8(%ebp)
  802ab3:	e8 b6 fe ff ff       	call   80296e <addToAvailMemBlocksList>
  802ab8:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802abb:	e9 72 03 00 00       	jmp    802e32 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802ac0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ac4:	74 06                	je     802acc <insert_sorted_with_merge_freeList+0xde>
  802ac6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aca:	75 17                	jne    802ae3 <insert_sorted_with_merge_freeList+0xf5>
  802acc:	83 ec 04             	sub    $0x4,%esp
  802acf:	68 14 39 80 00       	push   $0x803914
  802ad4:	68 24 01 00 00       	push   $0x124
  802ad9:	68 d7 38 80 00       	push   $0x8038d7
  802ade:	e8 78 d7 ff ff       	call   80025b <_panic>
  802ae3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae6:	8b 10                	mov    (%eax),%edx
  802ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  802aeb:	89 10                	mov    %edx,(%eax)
  802aed:	8b 45 08             	mov    0x8(%ebp),%eax
  802af0:	8b 00                	mov    (%eax),%eax
  802af2:	85 c0                	test   %eax,%eax
  802af4:	74 0b                	je     802b01 <insert_sorted_with_merge_freeList+0x113>
  802af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af9:	8b 00                	mov    (%eax),%eax
  802afb:	8b 55 08             	mov    0x8(%ebp),%edx
  802afe:	89 50 04             	mov    %edx,0x4(%eax)
  802b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b04:	8b 55 08             	mov    0x8(%ebp),%edx
  802b07:	89 10                	mov    %edx,(%eax)
  802b09:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b0f:	89 50 04             	mov    %edx,0x4(%eax)
  802b12:	8b 45 08             	mov    0x8(%ebp),%eax
  802b15:	8b 00                	mov    (%eax),%eax
  802b17:	85 c0                	test   %eax,%eax
  802b19:	75 08                	jne    802b23 <insert_sorted_with_merge_freeList+0x135>
  802b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b23:	a1 44 41 80 00       	mov    0x804144,%eax
  802b28:	40                   	inc    %eax
  802b29:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802b2e:	e9 ff 02 00 00       	jmp    802e32 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802b33:	a1 38 41 80 00       	mov    0x804138,%eax
  802b38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b3b:	e9 c2 02 00 00       	jmp    802e02 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b43:	8b 50 08             	mov    0x8(%eax),%edx
  802b46:	8b 45 08             	mov    0x8(%ebp),%eax
  802b49:	8b 40 08             	mov    0x8(%eax),%eax
  802b4c:	39 c2                	cmp    %eax,%edx
  802b4e:	0f 86 a6 02 00 00    	jbe    802dfa <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b57:	8b 40 04             	mov    0x4(%eax),%eax
  802b5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802b5d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b61:	0f 85 ba 00 00 00    	jne    802c21 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802b67:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6a:	8b 50 0c             	mov    0xc(%eax),%edx
  802b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b70:	8b 40 08             	mov    0x8(%eax),%eax
  802b73:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b78:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802b7b:	39 c2                	cmp    %eax,%edx
  802b7d:	75 33                	jne    802bb2 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b82:	8b 50 08             	mov    0x8(%eax),%edx
  802b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b88:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	8b 50 0c             	mov    0xc(%eax),%edx
  802b91:	8b 45 08             	mov    0x8(%ebp),%eax
  802b94:	8b 40 0c             	mov    0xc(%eax),%eax
  802b97:	01 c2                	add    %eax,%edx
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9c:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802b9f:	83 ec 0c             	sub    $0xc,%esp
  802ba2:	ff 75 08             	pushl  0x8(%ebp)
  802ba5:	e8 c4 fd ff ff       	call   80296e <addToAvailMemBlocksList>
  802baa:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802bad:	e9 80 02 00 00       	jmp    802e32 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802bb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb6:	74 06                	je     802bbe <insert_sorted_with_merge_freeList+0x1d0>
  802bb8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bbc:	75 17                	jne    802bd5 <insert_sorted_with_merge_freeList+0x1e7>
  802bbe:	83 ec 04             	sub    $0x4,%esp
  802bc1:	68 68 39 80 00       	push   $0x803968
  802bc6:	68 3a 01 00 00       	push   $0x13a
  802bcb:	68 d7 38 80 00       	push   $0x8038d7
  802bd0:	e8 86 d6 ff ff       	call   80025b <_panic>
  802bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd8:	8b 50 04             	mov    0x4(%eax),%edx
  802bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bde:	89 50 04             	mov    %edx,0x4(%eax)
  802be1:	8b 45 08             	mov    0x8(%ebp),%eax
  802be4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be7:	89 10                	mov    %edx,(%eax)
  802be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bec:	8b 40 04             	mov    0x4(%eax),%eax
  802bef:	85 c0                	test   %eax,%eax
  802bf1:	74 0d                	je     802c00 <insert_sorted_with_merge_freeList+0x212>
  802bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf6:	8b 40 04             	mov    0x4(%eax),%eax
  802bf9:	8b 55 08             	mov    0x8(%ebp),%edx
  802bfc:	89 10                	mov    %edx,(%eax)
  802bfe:	eb 08                	jmp    802c08 <insert_sorted_with_merge_freeList+0x21a>
  802c00:	8b 45 08             	mov    0x8(%ebp),%eax
  802c03:	a3 38 41 80 00       	mov    %eax,0x804138
  802c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c0e:	89 50 04             	mov    %edx,0x4(%eax)
  802c11:	a1 44 41 80 00       	mov    0x804144,%eax
  802c16:	40                   	inc    %eax
  802c17:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802c1c:	e9 11 02 00 00       	jmp    802e32 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802c21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c24:	8b 50 08             	mov    0x8(%eax),%edx
  802c27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2d:	01 c2                	add    %eax,%edx
  802c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c32:	8b 40 0c             	mov    0xc(%eax),%eax
  802c35:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3a:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802c3d:	39 c2                	cmp    %eax,%edx
  802c3f:	0f 85 bf 00 00 00    	jne    802d04 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802c45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c48:	8b 50 0c             	mov    0xc(%eax),%edx
  802c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c51:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c56:	8b 40 0c             	mov    0xc(%eax),%eax
  802c59:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802c5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5e:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802c61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c65:	75 17                	jne    802c7e <insert_sorted_with_merge_freeList+0x290>
  802c67:	83 ec 04             	sub    $0x4,%esp
  802c6a:	68 48 39 80 00       	push   $0x803948
  802c6f:	68 43 01 00 00       	push   $0x143
  802c74:	68 d7 38 80 00       	push   $0x8038d7
  802c79:	e8 dd d5 ff ff       	call   80025b <_panic>
  802c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c81:	8b 00                	mov    (%eax),%eax
  802c83:	85 c0                	test   %eax,%eax
  802c85:	74 10                	je     802c97 <insert_sorted_with_merge_freeList+0x2a9>
  802c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8a:	8b 00                	mov    (%eax),%eax
  802c8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c8f:	8b 52 04             	mov    0x4(%edx),%edx
  802c92:	89 50 04             	mov    %edx,0x4(%eax)
  802c95:	eb 0b                	jmp    802ca2 <insert_sorted_with_merge_freeList+0x2b4>
  802c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9a:	8b 40 04             	mov    0x4(%eax),%eax
  802c9d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca5:	8b 40 04             	mov    0x4(%eax),%eax
  802ca8:	85 c0                	test   %eax,%eax
  802caa:	74 0f                	je     802cbb <insert_sorted_with_merge_freeList+0x2cd>
  802cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caf:	8b 40 04             	mov    0x4(%eax),%eax
  802cb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb5:	8b 12                	mov    (%edx),%edx
  802cb7:	89 10                	mov    %edx,(%eax)
  802cb9:	eb 0a                	jmp    802cc5 <insert_sorted_with_merge_freeList+0x2d7>
  802cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbe:	8b 00                	mov    (%eax),%eax
  802cc0:	a3 38 41 80 00       	mov    %eax,0x804138
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd8:	a1 44 41 80 00       	mov    0x804144,%eax
  802cdd:	48                   	dec    %eax
  802cde:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802ce3:	83 ec 0c             	sub    $0xc,%esp
  802ce6:	ff 75 08             	pushl  0x8(%ebp)
  802ce9:	e8 80 fc ff ff       	call   80296e <addToAvailMemBlocksList>
  802cee:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802cf1:	83 ec 0c             	sub    $0xc,%esp
  802cf4:	ff 75 f4             	pushl  -0xc(%ebp)
  802cf7:	e8 72 fc ff ff       	call   80296e <addToAvailMemBlocksList>
  802cfc:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802cff:	e9 2e 01 00 00       	jmp    802e32 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802d04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d07:	8b 50 08             	mov    0x8(%eax),%edx
  802d0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d10:	01 c2                	add    %eax,%edx
  802d12:	8b 45 08             	mov    0x8(%ebp),%eax
  802d15:	8b 40 08             	mov    0x8(%eax),%eax
  802d18:	39 c2                	cmp    %eax,%edx
  802d1a:	75 27                	jne    802d43 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802d1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1f:	8b 50 0c             	mov    0xc(%eax),%edx
  802d22:	8b 45 08             	mov    0x8(%ebp),%eax
  802d25:	8b 40 0c             	mov    0xc(%eax),%eax
  802d28:	01 c2                	add    %eax,%edx
  802d2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2d:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802d30:	83 ec 0c             	sub    $0xc,%esp
  802d33:	ff 75 08             	pushl  0x8(%ebp)
  802d36:	e8 33 fc ff ff       	call   80296e <addToAvailMemBlocksList>
  802d3b:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802d3e:	e9 ef 00 00 00       	jmp    802e32 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802d43:	8b 45 08             	mov    0x8(%ebp),%eax
  802d46:	8b 50 0c             	mov    0xc(%eax),%edx
  802d49:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4c:	8b 40 08             	mov    0x8(%eax),%eax
  802d4f:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d54:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802d57:	39 c2                	cmp    %eax,%edx
  802d59:	75 33                	jne    802d8e <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5e:	8b 50 08             	mov    0x8(%eax),%edx
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6a:	8b 50 0c             	mov    0xc(%eax),%edx
  802d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d70:	8b 40 0c             	mov    0xc(%eax),%eax
  802d73:	01 c2                	add    %eax,%edx
  802d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d78:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802d7b:	83 ec 0c             	sub    $0xc,%esp
  802d7e:	ff 75 08             	pushl  0x8(%ebp)
  802d81:	e8 e8 fb ff ff       	call   80296e <addToAvailMemBlocksList>
  802d86:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802d89:	e9 a4 00 00 00       	jmp    802e32 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802d8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d92:	74 06                	je     802d9a <insert_sorted_with_merge_freeList+0x3ac>
  802d94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d98:	75 17                	jne    802db1 <insert_sorted_with_merge_freeList+0x3c3>
  802d9a:	83 ec 04             	sub    $0x4,%esp
  802d9d:	68 68 39 80 00       	push   $0x803968
  802da2:	68 56 01 00 00       	push   $0x156
  802da7:	68 d7 38 80 00       	push   $0x8038d7
  802dac:	e8 aa d4 ff ff       	call   80025b <_panic>
  802db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db4:	8b 50 04             	mov    0x4(%eax),%edx
  802db7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dba:	89 50 04             	mov    %edx,0x4(%eax)
  802dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dc3:	89 10                	mov    %edx,(%eax)
  802dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc8:	8b 40 04             	mov    0x4(%eax),%eax
  802dcb:	85 c0                	test   %eax,%eax
  802dcd:	74 0d                	je     802ddc <insert_sorted_with_merge_freeList+0x3ee>
  802dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd2:	8b 40 04             	mov    0x4(%eax),%eax
  802dd5:	8b 55 08             	mov    0x8(%ebp),%edx
  802dd8:	89 10                	mov    %edx,(%eax)
  802dda:	eb 08                	jmp    802de4 <insert_sorted_with_merge_freeList+0x3f6>
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	a3 38 41 80 00       	mov    %eax,0x804138
  802de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de7:	8b 55 08             	mov    0x8(%ebp),%edx
  802dea:	89 50 04             	mov    %edx,0x4(%eax)
  802ded:	a1 44 41 80 00       	mov    0x804144,%eax
  802df2:	40                   	inc    %eax
  802df3:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802df8:	eb 38                	jmp    802e32 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802dfa:	a1 40 41 80 00       	mov    0x804140,%eax
  802dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e06:	74 07                	je     802e0f <insert_sorted_with_merge_freeList+0x421>
  802e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0b:	8b 00                	mov    (%eax),%eax
  802e0d:	eb 05                	jmp    802e14 <insert_sorted_with_merge_freeList+0x426>
  802e0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e14:	a3 40 41 80 00       	mov    %eax,0x804140
  802e19:	a1 40 41 80 00       	mov    0x804140,%eax
  802e1e:	85 c0                	test   %eax,%eax
  802e20:	0f 85 1a fd ff ff    	jne    802b40 <insert_sorted_with_merge_freeList+0x152>
  802e26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e2a:	0f 85 10 fd ff ff    	jne    802b40 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e30:	eb 00                	jmp    802e32 <insert_sorted_with_merge_freeList+0x444>
  802e32:	90                   	nop
  802e33:	c9                   	leave  
  802e34:	c3                   	ret    
  802e35:	66 90                	xchg   %ax,%ax
  802e37:	90                   	nop

00802e38 <__udivdi3>:
  802e38:	55                   	push   %ebp
  802e39:	57                   	push   %edi
  802e3a:	56                   	push   %esi
  802e3b:	53                   	push   %ebx
  802e3c:	83 ec 1c             	sub    $0x1c,%esp
  802e3f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802e43:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802e47:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802e4b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802e4f:	89 ca                	mov    %ecx,%edx
  802e51:	89 f8                	mov    %edi,%eax
  802e53:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802e57:	85 f6                	test   %esi,%esi
  802e59:	75 2d                	jne    802e88 <__udivdi3+0x50>
  802e5b:	39 cf                	cmp    %ecx,%edi
  802e5d:	77 65                	ja     802ec4 <__udivdi3+0x8c>
  802e5f:	89 fd                	mov    %edi,%ebp
  802e61:	85 ff                	test   %edi,%edi
  802e63:	75 0b                	jne    802e70 <__udivdi3+0x38>
  802e65:	b8 01 00 00 00       	mov    $0x1,%eax
  802e6a:	31 d2                	xor    %edx,%edx
  802e6c:	f7 f7                	div    %edi
  802e6e:	89 c5                	mov    %eax,%ebp
  802e70:	31 d2                	xor    %edx,%edx
  802e72:	89 c8                	mov    %ecx,%eax
  802e74:	f7 f5                	div    %ebp
  802e76:	89 c1                	mov    %eax,%ecx
  802e78:	89 d8                	mov    %ebx,%eax
  802e7a:	f7 f5                	div    %ebp
  802e7c:	89 cf                	mov    %ecx,%edi
  802e7e:	89 fa                	mov    %edi,%edx
  802e80:	83 c4 1c             	add    $0x1c,%esp
  802e83:	5b                   	pop    %ebx
  802e84:	5e                   	pop    %esi
  802e85:	5f                   	pop    %edi
  802e86:	5d                   	pop    %ebp
  802e87:	c3                   	ret    
  802e88:	39 ce                	cmp    %ecx,%esi
  802e8a:	77 28                	ja     802eb4 <__udivdi3+0x7c>
  802e8c:	0f bd fe             	bsr    %esi,%edi
  802e8f:	83 f7 1f             	xor    $0x1f,%edi
  802e92:	75 40                	jne    802ed4 <__udivdi3+0x9c>
  802e94:	39 ce                	cmp    %ecx,%esi
  802e96:	72 0a                	jb     802ea2 <__udivdi3+0x6a>
  802e98:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802e9c:	0f 87 9e 00 00 00    	ja     802f40 <__udivdi3+0x108>
  802ea2:	b8 01 00 00 00       	mov    $0x1,%eax
  802ea7:	89 fa                	mov    %edi,%edx
  802ea9:	83 c4 1c             	add    $0x1c,%esp
  802eac:	5b                   	pop    %ebx
  802ead:	5e                   	pop    %esi
  802eae:	5f                   	pop    %edi
  802eaf:	5d                   	pop    %ebp
  802eb0:	c3                   	ret    
  802eb1:	8d 76 00             	lea    0x0(%esi),%esi
  802eb4:	31 ff                	xor    %edi,%edi
  802eb6:	31 c0                	xor    %eax,%eax
  802eb8:	89 fa                	mov    %edi,%edx
  802eba:	83 c4 1c             	add    $0x1c,%esp
  802ebd:	5b                   	pop    %ebx
  802ebe:	5e                   	pop    %esi
  802ebf:	5f                   	pop    %edi
  802ec0:	5d                   	pop    %ebp
  802ec1:	c3                   	ret    
  802ec2:	66 90                	xchg   %ax,%ax
  802ec4:	89 d8                	mov    %ebx,%eax
  802ec6:	f7 f7                	div    %edi
  802ec8:	31 ff                	xor    %edi,%edi
  802eca:	89 fa                	mov    %edi,%edx
  802ecc:	83 c4 1c             	add    $0x1c,%esp
  802ecf:	5b                   	pop    %ebx
  802ed0:	5e                   	pop    %esi
  802ed1:	5f                   	pop    %edi
  802ed2:	5d                   	pop    %ebp
  802ed3:	c3                   	ret    
  802ed4:	bd 20 00 00 00       	mov    $0x20,%ebp
  802ed9:	89 eb                	mov    %ebp,%ebx
  802edb:	29 fb                	sub    %edi,%ebx
  802edd:	89 f9                	mov    %edi,%ecx
  802edf:	d3 e6                	shl    %cl,%esi
  802ee1:	89 c5                	mov    %eax,%ebp
  802ee3:	88 d9                	mov    %bl,%cl
  802ee5:	d3 ed                	shr    %cl,%ebp
  802ee7:	89 e9                	mov    %ebp,%ecx
  802ee9:	09 f1                	or     %esi,%ecx
  802eeb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802eef:	89 f9                	mov    %edi,%ecx
  802ef1:	d3 e0                	shl    %cl,%eax
  802ef3:	89 c5                	mov    %eax,%ebp
  802ef5:	89 d6                	mov    %edx,%esi
  802ef7:	88 d9                	mov    %bl,%cl
  802ef9:	d3 ee                	shr    %cl,%esi
  802efb:	89 f9                	mov    %edi,%ecx
  802efd:	d3 e2                	shl    %cl,%edx
  802eff:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f03:	88 d9                	mov    %bl,%cl
  802f05:	d3 e8                	shr    %cl,%eax
  802f07:	09 c2                	or     %eax,%edx
  802f09:	89 d0                	mov    %edx,%eax
  802f0b:	89 f2                	mov    %esi,%edx
  802f0d:	f7 74 24 0c          	divl   0xc(%esp)
  802f11:	89 d6                	mov    %edx,%esi
  802f13:	89 c3                	mov    %eax,%ebx
  802f15:	f7 e5                	mul    %ebp
  802f17:	39 d6                	cmp    %edx,%esi
  802f19:	72 19                	jb     802f34 <__udivdi3+0xfc>
  802f1b:	74 0b                	je     802f28 <__udivdi3+0xf0>
  802f1d:	89 d8                	mov    %ebx,%eax
  802f1f:	31 ff                	xor    %edi,%edi
  802f21:	e9 58 ff ff ff       	jmp    802e7e <__udivdi3+0x46>
  802f26:	66 90                	xchg   %ax,%ax
  802f28:	8b 54 24 08          	mov    0x8(%esp),%edx
  802f2c:	89 f9                	mov    %edi,%ecx
  802f2e:	d3 e2                	shl    %cl,%edx
  802f30:	39 c2                	cmp    %eax,%edx
  802f32:	73 e9                	jae    802f1d <__udivdi3+0xe5>
  802f34:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802f37:	31 ff                	xor    %edi,%edi
  802f39:	e9 40 ff ff ff       	jmp    802e7e <__udivdi3+0x46>
  802f3e:	66 90                	xchg   %ax,%ax
  802f40:	31 c0                	xor    %eax,%eax
  802f42:	e9 37 ff ff ff       	jmp    802e7e <__udivdi3+0x46>
  802f47:	90                   	nop

00802f48 <__umoddi3>:
  802f48:	55                   	push   %ebp
  802f49:	57                   	push   %edi
  802f4a:	56                   	push   %esi
  802f4b:	53                   	push   %ebx
  802f4c:	83 ec 1c             	sub    $0x1c,%esp
  802f4f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802f53:	8b 74 24 34          	mov    0x34(%esp),%esi
  802f57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802f5b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802f5f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802f63:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802f67:	89 f3                	mov    %esi,%ebx
  802f69:	89 fa                	mov    %edi,%edx
  802f6b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802f6f:	89 34 24             	mov    %esi,(%esp)
  802f72:	85 c0                	test   %eax,%eax
  802f74:	75 1a                	jne    802f90 <__umoddi3+0x48>
  802f76:	39 f7                	cmp    %esi,%edi
  802f78:	0f 86 a2 00 00 00    	jbe    803020 <__umoddi3+0xd8>
  802f7e:	89 c8                	mov    %ecx,%eax
  802f80:	89 f2                	mov    %esi,%edx
  802f82:	f7 f7                	div    %edi
  802f84:	89 d0                	mov    %edx,%eax
  802f86:	31 d2                	xor    %edx,%edx
  802f88:	83 c4 1c             	add    $0x1c,%esp
  802f8b:	5b                   	pop    %ebx
  802f8c:	5e                   	pop    %esi
  802f8d:	5f                   	pop    %edi
  802f8e:	5d                   	pop    %ebp
  802f8f:	c3                   	ret    
  802f90:	39 f0                	cmp    %esi,%eax
  802f92:	0f 87 ac 00 00 00    	ja     803044 <__umoddi3+0xfc>
  802f98:	0f bd e8             	bsr    %eax,%ebp
  802f9b:	83 f5 1f             	xor    $0x1f,%ebp
  802f9e:	0f 84 ac 00 00 00    	je     803050 <__umoddi3+0x108>
  802fa4:	bf 20 00 00 00       	mov    $0x20,%edi
  802fa9:	29 ef                	sub    %ebp,%edi
  802fab:	89 fe                	mov    %edi,%esi
  802fad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802fb1:	89 e9                	mov    %ebp,%ecx
  802fb3:	d3 e0                	shl    %cl,%eax
  802fb5:	89 d7                	mov    %edx,%edi
  802fb7:	89 f1                	mov    %esi,%ecx
  802fb9:	d3 ef                	shr    %cl,%edi
  802fbb:	09 c7                	or     %eax,%edi
  802fbd:	89 e9                	mov    %ebp,%ecx
  802fbf:	d3 e2                	shl    %cl,%edx
  802fc1:	89 14 24             	mov    %edx,(%esp)
  802fc4:	89 d8                	mov    %ebx,%eax
  802fc6:	d3 e0                	shl    %cl,%eax
  802fc8:	89 c2                	mov    %eax,%edx
  802fca:	8b 44 24 08          	mov    0x8(%esp),%eax
  802fce:	d3 e0                	shl    %cl,%eax
  802fd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802fd4:	8b 44 24 08          	mov    0x8(%esp),%eax
  802fd8:	89 f1                	mov    %esi,%ecx
  802fda:	d3 e8                	shr    %cl,%eax
  802fdc:	09 d0                	or     %edx,%eax
  802fde:	d3 eb                	shr    %cl,%ebx
  802fe0:	89 da                	mov    %ebx,%edx
  802fe2:	f7 f7                	div    %edi
  802fe4:	89 d3                	mov    %edx,%ebx
  802fe6:	f7 24 24             	mull   (%esp)
  802fe9:	89 c6                	mov    %eax,%esi
  802feb:	89 d1                	mov    %edx,%ecx
  802fed:	39 d3                	cmp    %edx,%ebx
  802fef:	0f 82 87 00 00 00    	jb     80307c <__umoddi3+0x134>
  802ff5:	0f 84 91 00 00 00    	je     80308c <__umoddi3+0x144>
  802ffb:	8b 54 24 04          	mov    0x4(%esp),%edx
  802fff:	29 f2                	sub    %esi,%edx
  803001:	19 cb                	sbb    %ecx,%ebx
  803003:	89 d8                	mov    %ebx,%eax
  803005:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803009:	d3 e0                	shl    %cl,%eax
  80300b:	89 e9                	mov    %ebp,%ecx
  80300d:	d3 ea                	shr    %cl,%edx
  80300f:	09 d0                	or     %edx,%eax
  803011:	89 e9                	mov    %ebp,%ecx
  803013:	d3 eb                	shr    %cl,%ebx
  803015:	89 da                	mov    %ebx,%edx
  803017:	83 c4 1c             	add    $0x1c,%esp
  80301a:	5b                   	pop    %ebx
  80301b:	5e                   	pop    %esi
  80301c:	5f                   	pop    %edi
  80301d:	5d                   	pop    %ebp
  80301e:	c3                   	ret    
  80301f:	90                   	nop
  803020:	89 fd                	mov    %edi,%ebp
  803022:	85 ff                	test   %edi,%edi
  803024:	75 0b                	jne    803031 <__umoddi3+0xe9>
  803026:	b8 01 00 00 00       	mov    $0x1,%eax
  80302b:	31 d2                	xor    %edx,%edx
  80302d:	f7 f7                	div    %edi
  80302f:	89 c5                	mov    %eax,%ebp
  803031:	89 f0                	mov    %esi,%eax
  803033:	31 d2                	xor    %edx,%edx
  803035:	f7 f5                	div    %ebp
  803037:	89 c8                	mov    %ecx,%eax
  803039:	f7 f5                	div    %ebp
  80303b:	89 d0                	mov    %edx,%eax
  80303d:	e9 44 ff ff ff       	jmp    802f86 <__umoddi3+0x3e>
  803042:	66 90                	xchg   %ax,%ax
  803044:	89 c8                	mov    %ecx,%eax
  803046:	89 f2                	mov    %esi,%edx
  803048:	83 c4 1c             	add    $0x1c,%esp
  80304b:	5b                   	pop    %ebx
  80304c:	5e                   	pop    %esi
  80304d:	5f                   	pop    %edi
  80304e:	5d                   	pop    %ebp
  80304f:	c3                   	ret    
  803050:	3b 04 24             	cmp    (%esp),%eax
  803053:	72 06                	jb     80305b <__umoddi3+0x113>
  803055:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803059:	77 0f                	ja     80306a <__umoddi3+0x122>
  80305b:	89 f2                	mov    %esi,%edx
  80305d:	29 f9                	sub    %edi,%ecx
  80305f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803063:	89 14 24             	mov    %edx,(%esp)
  803066:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80306a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80306e:	8b 14 24             	mov    (%esp),%edx
  803071:	83 c4 1c             	add    $0x1c,%esp
  803074:	5b                   	pop    %ebx
  803075:	5e                   	pop    %esi
  803076:	5f                   	pop    %edi
  803077:	5d                   	pop    %ebp
  803078:	c3                   	ret    
  803079:	8d 76 00             	lea    0x0(%esi),%esi
  80307c:	2b 04 24             	sub    (%esp),%eax
  80307f:	19 fa                	sbb    %edi,%edx
  803081:	89 d1                	mov    %edx,%ecx
  803083:	89 c6                	mov    %eax,%esi
  803085:	e9 71 ff ff ff       	jmp    802ffb <__umoddi3+0xb3>
  80308a:	66 90                	xchg   %ax,%ax
  80308c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803090:	72 ea                	jb     80307c <__umoddi3+0x134>
  803092:	89 d9                	mov    %ebx,%ecx
  803094:	e9 62 ff ff ff       	jmp    802ffb <__umoddi3+0xb3>
