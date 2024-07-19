
obj/user/tst_sharing_5_slave:     file format elf32-i386


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
  800031:	e8 ff 00 00 00       	call   800135 <libmain>
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
  80008c:	68 c0 30 80 00       	push   $0x8030c0
  800091:	6a 12                	push   $0x12
  800093:	68 dc 30 80 00       	push   $0x8030dc
  800098:	e8 d4 01 00 00       	call   800271 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 10 14 00 00       	call   8014b7 <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int expected;
	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  8000aa:	e8 0d 1b 00 00       	call   801bbc <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 f7 30 80 00       	push   $0x8030f7
  8000b7:	50                   	push   %eax
  8000b8:	e8 f2 15 00 00       	call   8016af <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000c3:	e8 fb 17 00 00       	call   8018c3 <sys_calculate_free_frames>
  8000c8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 fc 30 80 00       	push   $0x8030fc
  8000d3:	e8 4d 04 00 00       	call   800525 <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	ff 75 ec             	pushl  -0x14(%ebp)
  8000e1:	e8 7d 16 00 00       	call   801763 <sfree>
  8000e6:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000e9:	83 ec 0c             	sub    $0xc,%esp
  8000ec:	68 20 31 80 00       	push   $0x803120
  8000f1:	e8 2f 04 00 00       	call   800525 <cprintf>
  8000f6:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000f9:	e8 c5 17 00 00       	call   8018c3 <sys_calculate_free_frames>
  8000fe:	89 c2                	mov    %eax,%edx
  800100:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800103:	29 c2                	sub    %eax,%edx
  800105:	89 d0                	mov    %edx,%eax
  800107:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	expected = 1;
  80010a:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	if (diff != expected) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  800111:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800114:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800117:	74 14                	je     80012d <_main+0xf5>
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	68 38 31 80 00       	push   $0x803138
  800121:	6a 24                	push   $0x24
  800123:	68 dc 30 80 00       	push   $0x8030dc
  800128:	e8 44 01 00 00       	call   800271 <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  80012d:	e8 af 1b 00 00       	call   801ce1 <inctst>

	return;
  800132:	90                   	nop
}
  800133:	c9                   	leave  
  800134:	c3                   	ret    

00800135 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800135:	55                   	push   %ebp
  800136:	89 e5                	mov    %esp,%ebp
  800138:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80013b:	e8 63 1a 00 00       	call   801ba3 <sys_getenvindex>
  800140:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800143:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800146:	89 d0                	mov    %edx,%eax
  800148:	c1 e0 03             	shl    $0x3,%eax
  80014b:	01 d0                	add    %edx,%eax
  80014d:	01 c0                	add    %eax,%eax
  80014f:	01 d0                	add    %edx,%eax
  800151:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800158:	01 d0                	add    %edx,%eax
  80015a:	c1 e0 04             	shl    $0x4,%eax
  80015d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800162:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800167:	a1 20 40 80 00       	mov    0x804020,%eax
  80016c:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800172:	84 c0                	test   %al,%al
  800174:	74 0f                	je     800185 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800176:	a1 20 40 80 00       	mov    0x804020,%eax
  80017b:	05 5c 05 00 00       	add    $0x55c,%eax
  800180:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800185:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800189:	7e 0a                	jle    800195 <libmain+0x60>
		binaryname = argv[0];
  80018b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018e:	8b 00                	mov    (%eax),%eax
  800190:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800195:	83 ec 08             	sub    $0x8,%esp
  800198:	ff 75 0c             	pushl  0xc(%ebp)
  80019b:	ff 75 08             	pushl  0x8(%ebp)
  80019e:	e8 95 fe ff ff       	call   800038 <_main>
  8001a3:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001a6:	e8 05 18 00 00       	call   8019b0 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	68 dc 31 80 00       	push   $0x8031dc
  8001b3:	e8 6d 03 00 00       	call   800525 <cprintf>
  8001b8:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c0:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001c6:	a1 20 40 80 00       	mov    0x804020,%eax
  8001cb:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001d1:	83 ec 04             	sub    $0x4,%esp
  8001d4:	52                   	push   %edx
  8001d5:	50                   	push   %eax
  8001d6:	68 04 32 80 00       	push   $0x803204
  8001db:	e8 45 03 00 00       	call   800525 <cprintf>
  8001e0:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e8:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001ee:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f3:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001f9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001fe:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800204:	51                   	push   %ecx
  800205:	52                   	push   %edx
  800206:	50                   	push   %eax
  800207:	68 2c 32 80 00       	push   $0x80322c
  80020c:	e8 14 03 00 00       	call   800525 <cprintf>
  800211:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800214:	a1 20 40 80 00       	mov    0x804020,%eax
  800219:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80021f:	83 ec 08             	sub    $0x8,%esp
  800222:	50                   	push   %eax
  800223:	68 84 32 80 00       	push   $0x803284
  800228:	e8 f8 02 00 00       	call   800525 <cprintf>
  80022d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	68 dc 31 80 00       	push   $0x8031dc
  800238:	e8 e8 02 00 00       	call   800525 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800240:	e8 85 17 00 00       	call   8019ca <sys_enable_interrupt>

	// exit gracefully
	exit();
  800245:	e8 19 00 00 00       	call   800263 <exit>
}
  80024a:	90                   	nop
  80024b:	c9                   	leave  
  80024c:	c3                   	ret    

0080024d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80024d:	55                   	push   %ebp
  80024e:	89 e5                	mov    %esp,%ebp
  800250:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800253:	83 ec 0c             	sub    $0xc,%esp
  800256:	6a 00                	push   $0x0
  800258:	e8 12 19 00 00       	call   801b6f <sys_destroy_env>
  80025d:	83 c4 10             	add    $0x10,%esp
}
  800260:	90                   	nop
  800261:	c9                   	leave  
  800262:	c3                   	ret    

00800263 <exit>:

void
exit(void)
{
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800269:	e8 67 19 00 00       	call   801bd5 <sys_exit_env>
}
  80026e:	90                   	nop
  80026f:	c9                   	leave  
  800270:	c3                   	ret    

00800271 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800277:	8d 45 10             	lea    0x10(%ebp),%eax
  80027a:	83 c0 04             	add    $0x4,%eax
  80027d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800280:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800285:	85 c0                	test   %eax,%eax
  800287:	74 16                	je     80029f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800289:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80028e:	83 ec 08             	sub    $0x8,%esp
  800291:	50                   	push   %eax
  800292:	68 98 32 80 00       	push   $0x803298
  800297:	e8 89 02 00 00       	call   800525 <cprintf>
  80029c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80029f:	a1 00 40 80 00       	mov    0x804000,%eax
  8002a4:	ff 75 0c             	pushl  0xc(%ebp)
  8002a7:	ff 75 08             	pushl  0x8(%ebp)
  8002aa:	50                   	push   %eax
  8002ab:	68 9d 32 80 00       	push   $0x80329d
  8002b0:	e8 70 02 00 00       	call   800525 <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bb:	83 ec 08             	sub    $0x8,%esp
  8002be:	ff 75 f4             	pushl  -0xc(%ebp)
  8002c1:	50                   	push   %eax
  8002c2:	e8 f3 01 00 00       	call   8004ba <vcprintf>
  8002c7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002ca:	83 ec 08             	sub    $0x8,%esp
  8002cd:	6a 00                	push   $0x0
  8002cf:	68 b9 32 80 00       	push   $0x8032b9
  8002d4:	e8 e1 01 00 00       	call   8004ba <vcprintf>
  8002d9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002dc:	e8 82 ff ff ff       	call   800263 <exit>

	// should not return here
	while (1) ;
  8002e1:	eb fe                	jmp    8002e1 <_panic+0x70>

008002e3 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002e9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ee:	8b 50 74             	mov    0x74(%eax),%edx
  8002f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f4:	39 c2                	cmp    %eax,%edx
  8002f6:	74 14                	je     80030c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002f8:	83 ec 04             	sub    $0x4,%esp
  8002fb:	68 bc 32 80 00       	push   $0x8032bc
  800300:	6a 26                	push   $0x26
  800302:	68 08 33 80 00       	push   $0x803308
  800307:	e8 65 ff ff ff       	call   800271 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80030c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800313:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80031a:	e9 c2 00 00 00       	jmp    8003e1 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80031f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800322:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800329:	8b 45 08             	mov    0x8(%ebp),%eax
  80032c:	01 d0                	add    %edx,%eax
  80032e:	8b 00                	mov    (%eax),%eax
  800330:	85 c0                	test   %eax,%eax
  800332:	75 08                	jne    80033c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800334:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800337:	e9 a2 00 00 00       	jmp    8003de <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80033c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800343:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80034a:	eb 69                	jmp    8003b5 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80034c:	a1 20 40 80 00       	mov    0x804020,%eax
  800351:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800357:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80035a:	89 d0                	mov    %edx,%eax
  80035c:	01 c0                	add    %eax,%eax
  80035e:	01 d0                	add    %edx,%eax
  800360:	c1 e0 03             	shl    $0x3,%eax
  800363:	01 c8                	add    %ecx,%eax
  800365:	8a 40 04             	mov    0x4(%eax),%al
  800368:	84 c0                	test   %al,%al
  80036a:	75 46                	jne    8003b2 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80036c:	a1 20 40 80 00       	mov    0x804020,%eax
  800371:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800377:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80037a:	89 d0                	mov    %edx,%eax
  80037c:	01 c0                	add    %eax,%eax
  80037e:	01 d0                	add    %edx,%eax
  800380:	c1 e0 03             	shl    $0x3,%eax
  800383:	01 c8                	add    %ecx,%eax
  800385:	8b 00                	mov    (%eax),%eax
  800387:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80038a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80038d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800392:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800397:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80039e:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a1:	01 c8                	add    %ecx,%eax
  8003a3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003a5:	39 c2                	cmp    %eax,%edx
  8003a7:	75 09                	jne    8003b2 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003a9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003b0:	eb 12                	jmp    8003c4 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003b2:	ff 45 e8             	incl   -0x18(%ebp)
  8003b5:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ba:	8b 50 74             	mov    0x74(%eax),%edx
  8003bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003c0:	39 c2                	cmp    %eax,%edx
  8003c2:	77 88                	ja     80034c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003c8:	75 14                	jne    8003de <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003ca:	83 ec 04             	sub    $0x4,%esp
  8003cd:	68 14 33 80 00       	push   $0x803314
  8003d2:	6a 3a                	push   $0x3a
  8003d4:	68 08 33 80 00       	push   $0x803308
  8003d9:	e8 93 fe ff ff       	call   800271 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003de:	ff 45 f0             	incl   -0x10(%ebp)
  8003e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003e7:	0f 8c 32 ff ff ff    	jl     80031f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003ed:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003fb:	eb 26                	jmp    800423 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003fd:	a1 20 40 80 00       	mov    0x804020,%eax
  800402:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800408:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80040b:	89 d0                	mov    %edx,%eax
  80040d:	01 c0                	add    %eax,%eax
  80040f:	01 d0                	add    %edx,%eax
  800411:	c1 e0 03             	shl    $0x3,%eax
  800414:	01 c8                	add    %ecx,%eax
  800416:	8a 40 04             	mov    0x4(%eax),%al
  800419:	3c 01                	cmp    $0x1,%al
  80041b:	75 03                	jne    800420 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80041d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800420:	ff 45 e0             	incl   -0x20(%ebp)
  800423:	a1 20 40 80 00       	mov    0x804020,%eax
  800428:	8b 50 74             	mov    0x74(%eax),%edx
  80042b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042e:	39 c2                	cmp    %eax,%edx
  800430:	77 cb                	ja     8003fd <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800435:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800438:	74 14                	je     80044e <CheckWSWithoutLastIndex+0x16b>
		panic(
  80043a:	83 ec 04             	sub    $0x4,%esp
  80043d:	68 68 33 80 00       	push   $0x803368
  800442:	6a 44                	push   $0x44
  800444:	68 08 33 80 00       	push   $0x803308
  800449:	e8 23 fe ff ff       	call   800271 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80044e:	90                   	nop
  80044f:	c9                   	leave  
  800450:	c3                   	ret    

00800451 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800451:	55                   	push   %ebp
  800452:	89 e5                	mov    %esp,%ebp
  800454:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045a:	8b 00                	mov    (%eax),%eax
  80045c:	8d 48 01             	lea    0x1(%eax),%ecx
  80045f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800462:	89 0a                	mov    %ecx,(%edx)
  800464:	8b 55 08             	mov    0x8(%ebp),%edx
  800467:	88 d1                	mov    %dl,%cl
  800469:	8b 55 0c             	mov    0xc(%ebp),%edx
  80046c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800470:	8b 45 0c             	mov    0xc(%ebp),%eax
  800473:	8b 00                	mov    (%eax),%eax
  800475:	3d ff 00 00 00       	cmp    $0xff,%eax
  80047a:	75 2c                	jne    8004a8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80047c:	a0 24 40 80 00       	mov    0x804024,%al
  800481:	0f b6 c0             	movzbl %al,%eax
  800484:	8b 55 0c             	mov    0xc(%ebp),%edx
  800487:	8b 12                	mov    (%edx),%edx
  800489:	89 d1                	mov    %edx,%ecx
  80048b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048e:	83 c2 08             	add    $0x8,%edx
  800491:	83 ec 04             	sub    $0x4,%esp
  800494:	50                   	push   %eax
  800495:	51                   	push   %ecx
  800496:	52                   	push   %edx
  800497:	e8 66 13 00 00       	call   801802 <sys_cputs>
  80049c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80049f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ab:	8b 40 04             	mov    0x4(%eax),%eax
  8004ae:	8d 50 01             	lea    0x1(%eax),%edx
  8004b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004b7:	90                   	nop
  8004b8:	c9                   	leave  
  8004b9:	c3                   	ret    

008004ba <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004ba:	55                   	push   %ebp
  8004bb:	89 e5                	mov    %esp,%ebp
  8004bd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004c3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004ca:	00 00 00 
	b.cnt = 0;
  8004cd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004d4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004d7:	ff 75 0c             	pushl  0xc(%ebp)
  8004da:	ff 75 08             	pushl  0x8(%ebp)
  8004dd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e3:	50                   	push   %eax
  8004e4:	68 51 04 80 00       	push   $0x800451
  8004e9:	e8 11 02 00 00       	call   8006ff <vprintfmt>
  8004ee:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004f1:	a0 24 40 80 00       	mov    0x804024,%al
  8004f6:	0f b6 c0             	movzbl %al,%eax
  8004f9:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004ff:	83 ec 04             	sub    $0x4,%esp
  800502:	50                   	push   %eax
  800503:	52                   	push   %edx
  800504:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80050a:	83 c0 08             	add    $0x8,%eax
  80050d:	50                   	push   %eax
  80050e:	e8 ef 12 00 00       	call   801802 <sys_cputs>
  800513:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800516:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80051d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800523:	c9                   	leave  
  800524:	c3                   	ret    

00800525 <cprintf>:

int cprintf(const char *fmt, ...) {
  800525:	55                   	push   %ebp
  800526:	89 e5                	mov    %esp,%ebp
  800528:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80052b:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800532:	8d 45 0c             	lea    0xc(%ebp),%eax
  800535:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800538:	8b 45 08             	mov    0x8(%ebp),%eax
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	ff 75 f4             	pushl  -0xc(%ebp)
  800541:	50                   	push   %eax
  800542:	e8 73 ff ff ff       	call   8004ba <vcprintf>
  800547:	83 c4 10             	add    $0x10,%esp
  80054a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80054d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800550:	c9                   	leave  
  800551:	c3                   	ret    

00800552 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800552:	55                   	push   %ebp
  800553:	89 e5                	mov    %esp,%ebp
  800555:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800558:	e8 53 14 00 00       	call   8019b0 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80055d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800560:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800563:	8b 45 08             	mov    0x8(%ebp),%eax
  800566:	83 ec 08             	sub    $0x8,%esp
  800569:	ff 75 f4             	pushl  -0xc(%ebp)
  80056c:	50                   	push   %eax
  80056d:	e8 48 ff ff ff       	call   8004ba <vcprintf>
  800572:	83 c4 10             	add    $0x10,%esp
  800575:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800578:	e8 4d 14 00 00       	call   8019ca <sys_enable_interrupt>
	return cnt;
  80057d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800580:	c9                   	leave  
  800581:	c3                   	ret    

00800582 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
  800585:	53                   	push   %ebx
  800586:	83 ec 14             	sub    $0x14,%esp
  800589:	8b 45 10             	mov    0x10(%ebp),%eax
  80058c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80058f:	8b 45 14             	mov    0x14(%ebp),%eax
  800592:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800595:	8b 45 18             	mov    0x18(%ebp),%eax
  800598:	ba 00 00 00 00       	mov    $0x0,%edx
  80059d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a0:	77 55                	ja     8005f7 <printnum+0x75>
  8005a2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a5:	72 05                	jb     8005ac <printnum+0x2a>
  8005a7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005aa:	77 4b                	ja     8005f7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ac:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005af:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005b2:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ba:	52                   	push   %edx
  8005bb:	50                   	push   %eax
  8005bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8005bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8005c2:	e8 85 28 00 00       	call   802e4c <__udivdi3>
  8005c7:	83 c4 10             	add    $0x10,%esp
  8005ca:	83 ec 04             	sub    $0x4,%esp
  8005cd:	ff 75 20             	pushl  0x20(%ebp)
  8005d0:	53                   	push   %ebx
  8005d1:	ff 75 18             	pushl  0x18(%ebp)
  8005d4:	52                   	push   %edx
  8005d5:	50                   	push   %eax
  8005d6:	ff 75 0c             	pushl  0xc(%ebp)
  8005d9:	ff 75 08             	pushl  0x8(%ebp)
  8005dc:	e8 a1 ff ff ff       	call   800582 <printnum>
  8005e1:	83 c4 20             	add    $0x20,%esp
  8005e4:	eb 1a                	jmp    800600 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005e6:	83 ec 08             	sub    $0x8,%esp
  8005e9:	ff 75 0c             	pushl  0xc(%ebp)
  8005ec:	ff 75 20             	pushl  0x20(%ebp)
  8005ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f2:	ff d0                	call   *%eax
  8005f4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f7:	ff 4d 1c             	decl   0x1c(%ebp)
  8005fa:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005fe:	7f e6                	jg     8005e6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800600:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800603:	bb 00 00 00 00       	mov    $0x0,%ebx
  800608:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80060e:	53                   	push   %ebx
  80060f:	51                   	push   %ecx
  800610:	52                   	push   %edx
  800611:	50                   	push   %eax
  800612:	e8 45 29 00 00       	call   802f5c <__umoddi3>
  800617:	83 c4 10             	add    $0x10,%esp
  80061a:	05 d4 35 80 00       	add    $0x8035d4,%eax
  80061f:	8a 00                	mov    (%eax),%al
  800621:	0f be c0             	movsbl %al,%eax
  800624:	83 ec 08             	sub    $0x8,%esp
  800627:	ff 75 0c             	pushl  0xc(%ebp)
  80062a:	50                   	push   %eax
  80062b:	8b 45 08             	mov    0x8(%ebp),%eax
  80062e:	ff d0                	call   *%eax
  800630:	83 c4 10             	add    $0x10,%esp
}
  800633:	90                   	nop
  800634:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800637:	c9                   	leave  
  800638:	c3                   	ret    

00800639 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800639:	55                   	push   %ebp
  80063a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80063c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800640:	7e 1c                	jle    80065e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800642:	8b 45 08             	mov    0x8(%ebp),%eax
  800645:	8b 00                	mov    (%eax),%eax
  800647:	8d 50 08             	lea    0x8(%eax),%edx
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	89 10                	mov    %edx,(%eax)
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	8b 00                	mov    (%eax),%eax
  800654:	83 e8 08             	sub    $0x8,%eax
  800657:	8b 50 04             	mov    0x4(%eax),%edx
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	eb 40                	jmp    80069e <getuint+0x65>
	else if (lflag)
  80065e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800662:	74 1e                	je     800682 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	8b 00                	mov    (%eax),%eax
  800669:	8d 50 04             	lea    0x4(%eax),%edx
  80066c:	8b 45 08             	mov    0x8(%ebp),%eax
  80066f:	89 10                	mov    %edx,(%eax)
  800671:	8b 45 08             	mov    0x8(%ebp),%eax
  800674:	8b 00                	mov    (%eax),%eax
  800676:	83 e8 04             	sub    $0x4,%eax
  800679:	8b 00                	mov    (%eax),%eax
  80067b:	ba 00 00 00 00       	mov    $0x0,%edx
  800680:	eb 1c                	jmp    80069e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	8d 50 04             	lea    0x4(%eax),%edx
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	89 10                	mov    %edx,(%eax)
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	8b 00                	mov    (%eax),%eax
  800694:	83 e8 04             	sub    $0x4,%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80069e:	5d                   	pop    %ebp
  80069f:	c3                   	ret    

008006a0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006a0:	55                   	push   %ebp
  8006a1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a7:	7e 1c                	jle    8006c5 <getint+0x25>
		return va_arg(*ap, long long);
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	8d 50 08             	lea    0x8(%eax),%edx
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	89 10                	mov    %edx,(%eax)
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	83 e8 08             	sub    $0x8,%eax
  8006be:	8b 50 04             	mov    0x4(%eax),%edx
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	eb 38                	jmp    8006fd <getint+0x5d>
	else if (lflag)
  8006c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c9:	74 1a                	je     8006e5 <getint+0x45>
		return va_arg(*ap, long);
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	8b 00                	mov    (%eax),%eax
  8006d0:	8d 50 04             	lea    0x4(%eax),%edx
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	89 10                	mov    %edx,(%eax)
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	83 e8 04             	sub    $0x4,%eax
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	99                   	cltd   
  8006e3:	eb 18                	jmp    8006fd <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e8:	8b 00                	mov    (%eax),%eax
  8006ea:	8d 50 04             	lea    0x4(%eax),%edx
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	89 10                	mov    %edx,(%eax)
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	83 e8 04             	sub    $0x4,%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	99                   	cltd   
}
  8006fd:	5d                   	pop    %ebp
  8006fe:	c3                   	ret    

008006ff <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006ff:	55                   	push   %ebp
  800700:	89 e5                	mov    %esp,%ebp
  800702:	56                   	push   %esi
  800703:	53                   	push   %ebx
  800704:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800707:	eb 17                	jmp    800720 <vprintfmt+0x21>
			if (ch == '\0')
  800709:	85 db                	test   %ebx,%ebx
  80070b:	0f 84 af 03 00 00    	je     800ac0 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	53                   	push   %ebx
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	ff d0                	call   *%eax
  80071d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800720:	8b 45 10             	mov    0x10(%ebp),%eax
  800723:	8d 50 01             	lea    0x1(%eax),%edx
  800726:	89 55 10             	mov    %edx,0x10(%ebp)
  800729:	8a 00                	mov    (%eax),%al
  80072b:	0f b6 d8             	movzbl %al,%ebx
  80072e:	83 fb 25             	cmp    $0x25,%ebx
  800731:	75 d6                	jne    800709 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800733:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800737:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80073e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800745:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80074c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800753:	8b 45 10             	mov    0x10(%ebp),%eax
  800756:	8d 50 01             	lea    0x1(%eax),%edx
  800759:	89 55 10             	mov    %edx,0x10(%ebp)
  80075c:	8a 00                	mov    (%eax),%al
  80075e:	0f b6 d8             	movzbl %al,%ebx
  800761:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800764:	83 f8 55             	cmp    $0x55,%eax
  800767:	0f 87 2b 03 00 00    	ja     800a98 <vprintfmt+0x399>
  80076d:	8b 04 85 f8 35 80 00 	mov    0x8035f8(,%eax,4),%eax
  800774:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800776:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80077a:	eb d7                	jmp    800753 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80077c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800780:	eb d1                	jmp    800753 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800782:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800789:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80078c:	89 d0                	mov    %edx,%eax
  80078e:	c1 e0 02             	shl    $0x2,%eax
  800791:	01 d0                	add    %edx,%eax
  800793:	01 c0                	add    %eax,%eax
  800795:	01 d8                	add    %ebx,%eax
  800797:	83 e8 30             	sub    $0x30,%eax
  80079a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80079d:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a0:	8a 00                	mov    (%eax),%al
  8007a2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007a5:	83 fb 2f             	cmp    $0x2f,%ebx
  8007a8:	7e 3e                	jle    8007e8 <vprintfmt+0xe9>
  8007aa:	83 fb 39             	cmp    $0x39,%ebx
  8007ad:	7f 39                	jg     8007e8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007af:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007b2:	eb d5                	jmp    800789 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	83 c0 04             	add    $0x4,%eax
  8007ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	83 e8 04             	sub    $0x4,%eax
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007c8:	eb 1f                	jmp    8007e9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ce:	79 83                	jns    800753 <vprintfmt+0x54>
				width = 0;
  8007d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007d7:	e9 77 ff ff ff       	jmp    800753 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007dc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007e3:	e9 6b ff ff ff       	jmp    800753 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007e8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ed:	0f 89 60 ff ff ff    	jns    800753 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800800:	e9 4e ff ff ff       	jmp    800753 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800805:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800808:	e9 46 ff ff ff       	jmp    800753 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	83 c0 04             	add    $0x4,%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
  800816:	8b 45 14             	mov    0x14(%ebp),%eax
  800819:	83 e8 04             	sub    $0x4,%eax
  80081c:	8b 00                	mov    (%eax),%eax
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	ff 75 0c             	pushl  0xc(%ebp)
  800824:	50                   	push   %eax
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
			break;
  80082d:	e9 89 02 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	83 c0 04             	add    $0x4,%eax
  800838:	89 45 14             	mov    %eax,0x14(%ebp)
  80083b:	8b 45 14             	mov    0x14(%ebp),%eax
  80083e:	83 e8 04             	sub    $0x4,%eax
  800841:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800843:	85 db                	test   %ebx,%ebx
  800845:	79 02                	jns    800849 <vprintfmt+0x14a>
				err = -err;
  800847:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800849:	83 fb 64             	cmp    $0x64,%ebx
  80084c:	7f 0b                	jg     800859 <vprintfmt+0x15a>
  80084e:	8b 34 9d 40 34 80 00 	mov    0x803440(,%ebx,4),%esi
  800855:	85 f6                	test   %esi,%esi
  800857:	75 19                	jne    800872 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800859:	53                   	push   %ebx
  80085a:	68 e5 35 80 00       	push   $0x8035e5
  80085f:	ff 75 0c             	pushl  0xc(%ebp)
  800862:	ff 75 08             	pushl  0x8(%ebp)
  800865:	e8 5e 02 00 00       	call   800ac8 <printfmt>
  80086a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80086d:	e9 49 02 00 00       	jmp    800abb <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800872:	56                   	push   %esi
  800873:	68 ee 35 80 00       	push   $0x8035ee
  800878:	ff 75 0c             	pushl  0xc(%ebp)
  80087b:	ff 75 08             	pushl  0x8(%ebp)
  80087e:	e8 45 02 00 00       	call   800ac8 <printfmt>
  800883:	83 c4 10             	add    $0x10,%esp
			break;
  800886:	e9 30 02 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80088b:	8b 45 14             	mov    0x14(%ebp),%eax
  80088e:	83 c0 04             	add    $0x4,%eax
  800891:	89 45 14             	mov    %eax,0x14(%ebp)
  800894:	8b 45 14             	mov    0x14(%ebp),%eax
  800897:	83 e8 04             	sub    $0x4,%eax
  80089a:	8b 30                	mov    (%eax),%esi
  80089c:	85 f6                	test   %esi,%esi
  80089e:	75 05                	jne    8008a5 <vprintfmt+0x1a6>
				p = "(null)";
  8008a0:	be f1 35 80 00       	mov    $0x8035f1,%esi
			if (width > 0 && padc != '-')
  8008a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a9:	7e 6d                	jle    800918 <vprintfmt+0x219>
  8008ab:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008af:	74 67                	je     800918 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	50                   	push   %eax
  8008b8:	56                   	push   %esi
  8008b9:	e8 0c 03 00 00       	call   800bca <strnlen>
  8008be:	83 c4 10             	add    $0x10,%esp
  8008c1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008c4:	eb 16                	jmp    8008dc <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008c6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008ca:	83 ec 08             	sub    $0x8,%esp
  8008cd:	ff 75 0c             	pushl  0xc(%ebp)
  8008d0:	50                   	push   %eax
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	ff d0                	call   *%eax
  8008d6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d9:	ff 4d e4             	decl   -0x1c(%ebp)
  8008dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e0:	7f e4                	jg     8008c6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e2:	eb 34                	jmp    800918 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008e8:	74 1c                	je     800906 <vprintfmt+0x207>
  8008ea:	83 fb 1f             	cmp    $0x1f,%ebx
  8008ed:	7e 05                	jle    8008f4 <vprintfmt+0x1f5>
  8008ef:	83 fb 7e             	cmp    $0x7e,%ebx
  8008f2:	7e 12                	jle    800906 <vprintfmt+0x207>
					putch('?', putdat);
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	ff 75 0c             	pushl  0xc(%ebp)
  8008fa:	6a 3f                	push   $0x3f
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	ff d0                	call   *%eax
  800901:	83 c4 10             	add    $0x10,%esp
  800904:	eb 0f                	jmp    800915 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800906:	83 ec 08             	sub    $0x8,%esp
  800909:	ff 75 0c             	pushl  0xc(%ebp)
  80090c:	53                   	push   %ebx
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	ff d0                	call   *%eax
  800912:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800915:	ff 4d e4             	decl   -0x1c(%ebp)
  800918:	89 f0                	mov    %esi,%eax
  80091a:	8d 70 01             	lea    0x1(%eax),%esi
  80091d:	8a 00                	mov    (%eax),%al
  80091f:	0f be d8             	movsbl %al,%ebx
  800922:	85 db                	test   %ebx,%ebx
  800924:	74 24                	je     80094a <vprintfmt+0x24b>
  800926:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80092a:	78 b8                	js     8008e4 <vprintfmt+0x1e5>
  80092c:	ff 4d e0             	decl   -0x20(%ebp)
  80092f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800933:	79 af                	jns    8008e4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800935:	eb 13                	jmp    80094a <vprintfmt+0x24b>
				putch(' ', putdat);
  800937:	83 ec 08             	sub    $0x8,%esp
  80093a:	ff 75 0c             	pushl  0xc(%ebp)
  80093d:	6a 20                	push   $0x20
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	ff d0                	call   *%eax
  800944:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800947:	ff 4d e4             	decl   -0x1c(%ebp)
  80094a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094e:	7f e7                	jg     800937 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800950:	e9 66 01 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800955:	83 ec 08             	sub    $0x8,%esp
  800958:	ff 75 e8             	pushl  -0x18(%ebp)
  80095b:	8d 45 14             	lea    0x14(%ebp),%eax
  80095e:	50                   	push   %eax
  80095f:	e8 3c fd ff ff       	call   8006a0 <getint>
  800964:	83 c4 10             	add    $0x10,%esp
  800967:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80096a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80096d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800970:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800973:	85 d2                	test   %edx,%edx
  800975:	79 23                	jns    80099a <vprintfmt+0x29b>
				putch('-', putdat);
  800977:	83 ec 08             	sub    $0x8,%esp
  80097a:	ff 75 0c             	pushl  0xc(%ebp)
  80097d:	6a 2d                	push   $0x2d
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	ff d0                	call   *%eax
  800984:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80098a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80098d:	f7 d8                	neg    %eax
  80098f:	83 d2 00             	adc    $0x0,%edx
  800992:	f7 da                	neg    %edx
  800994:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800997:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80099a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009a1:	e9 bc 00 00 00       	jmp    800a62 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009a6:	83 ec 08             	sub    $0x8,%esp
  8009a9:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ac:	8d 45 14             	lea    0x14(%ebp),%eax
  8009af:	50                   	push   %eax
  8009b0:	e8 84 fc ff ff       	call   800639 <getuint>
  8009b5:	83 c4 10             	add    $0x10,%esp
  8009b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009be:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c5:	e9 98 00 00 00       	jmp    800a62 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	6a 58                	push   $0x58
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	ff d0                	call   *%eax
  8009d7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009da:	83 ec 08             	sub    $0x8,%esp
  8009dd:	ff 75 0c             	pushl  0xc(%ebp)
  8009e0:	6a 58                	push   $0x58
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	ff d0                	call   *%eax
  8009e7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	6a 58                	push   $0x58
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	ff d0                	call   *%eax
  8009f7:	83 c4 10             	add    $0x10,%esp
			break;
  8009fa:	e9 bc 00 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	6a 30                	push   $0x30
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	ff d0                	call   *%eax
  800a0c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	6a 78                	push   $0x78
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	ff d0                	call   *%eax
  800a1c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a22:	83 c0 04             	add    $0x4,%eax
  800a25:	89 45 14             	mov    %eax,0x14(%ebp)
  800a28:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2b:	83 e8 04             	sub    $0x4,%eax
  800a2e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a3a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a41:	eb 1f                	jmp    800a62 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a43:	83 ec 08             	sub    $0x8,%esp
  800a46:	ff 75 e8             	pushl  -0x18(%ebp)
  800a49:	8d 45 14             	lea    0x14(%ebp),%eax
  800a4c:	50                   	push   %eax
  800a4d:	e8 e7 fb ff ff       	call   800639 <getuint>
  800a52:	83 c4 10             	add    $0x10,%esp
  800a55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a58:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a5b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a62:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a69:	83 ec 04             	sub    $0x4,%esp
  800a6c:	52                   	push   %edx
  800a6d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a70:	50                   	push   %eax
  800a71:	ff 75 f4             	pushl  -0xc(%ebp)
  800a74:	ff 75 f0             	pushl  -0x10(%ebp)
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	ff 75 08             	pushl  0x8(%ebp)
  800a7d:	e8 00 fb ff ff       	call   800582 <printnum>
  800a82:	83 c4 20             	add    $0x20,%esp
			break;
  800a85:	eb 34                	jmp    800abb <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 0c             	pushl  0xc(%ebp)
  800a8d:	53                   	push   %ebx
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	ff d0                	call   *%eax
  800a93:	83 c4 10             	add    $0x10,%esp
			break;
  800a96:	eb 23                	jmp    800abb <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a98:	83 ec 08             	sub    $0x8,%esp
  800a9b:	ff 75 0c             	pushl  0xc(%ebp)
  800a9e:	6a 25                	push   $0x25
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	ff d0                	call   *%eax
  800aa5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aa8:	ff 4d 10             	decl   0x10(%ebp)
  800aab:	eb 03                	jmp    800ab0 <vprintfmt+0x3b1>
  800aad:	ff 4d 10             	decl   0x10(%ebp)
  800ab0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab3:	48                   	dec    %eax
  800ab4:	8a 00                	mov    (%eax),%al
  800ab6:	3c 25                	cmp    $0x25,%al
  800ab8:	75 f3                	jne    800aad <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aba:	90                   	nop
		}
	}
  800abb:	e9 47 fc ff ff       	jmp    800707 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ac0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ac1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ac4:	5b                   	pop    %ebx
  800ac5:	5e                   	pop    %esi
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    

00800ac8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ace:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad1:	83 c0 04             	add    $0x4,%eax
  800ad4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ad7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ada:	ff 75 f4             	pushl  -0xc(%ebp)
  800add:	50                   	push   %eax
  800ade:	ff 75 0c             	pushl  0xc(%ebp)
  800ae1:	ff 75 08             	pushl  0x8(%ebp)
  800ae4:	e8 16 fc ff ff       	call   8006ff <vprintfmt>
  800ae9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800aec:	90                   	nop
  800aed:	c9                   	leave  
  800aee:	c3                   	ret    

00800aef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	8b 40 08             	mov    0x8(%eax),%eax
  800af8:	8d 50 01             	lea    0x1(%eax),%edx
  800afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afe:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b04:	8b 10                	mov    (%eax),%edx
  800b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b09:	8b 40 04             	mov    0x4(%eax),%eax
  800b0c:	39 c2                	cmp    %eax,%edx
  800b0e:	73 12                	jae    800b22 <sprintputch+0x33>
		*b->buf++ = ch;
  800b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b13:	8b 00                	mov    (%eax),%eax
  800b15:	8d 48 01             	lea    0x1(%eax),%ecx
  800b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1b:	89 0a                	mov    %ecx,(%edx)
  800b1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b20:	88 10                	mov    %dl,(%eax)
}
  800b22:	90                   	nop
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	01 d0                	add    %edx,%eax
  800b3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b4a:	74 06                	je     800b52 <vsnprintf+0x2d>
  800b4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b50:	7f 07                	jg     800b59 <vsnprintf+0x34>
		return -E_INVAL;
  800b52:	b8 03 00 00 00       	mov    $0x3,%eax
  800b57:	eb 20                	jmp    800b79 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b59:	ff 75 14             	pushl  0x14(%ebp)
  800b5c:	ff 75 10             	pushl  0x10(%ebp)
  800b5f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b62:	50                   	push   %eax
  800b63:	68 ef 0a 80 00       	push   $0x800aef
  800b68:	e8 92 fb ff ff       	call   8006ff <vprintfmt>
  800b6d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b73:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b79:	c9                   	leave  
  800b7a:	c3                   	ret    

00800b7b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b81:	8d 45 10             	lea    0x10(%ebp),%eax
  800b84:	83 c0 04             	add    $0x4,%eax
  800b87:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b90:	50                   	push   %eax
  800b91:	ff 75 0c             	pushl  0xc(%ebp)
  800b94:	ff 75 08             	pushl  0x8(%ebp)
  800b97:	e8 89 ff ff ff       	call   800b25 <vsnprintf>
  800b9c:	83 c4 10             	add    $0x10,%esp
  800b9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ba5:	c9                   	leave  
  800ba6:	c3                   	ret    

00800ba7 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb4:	eb 06                	jmp    800bbc <strlen+0x15>
		n++;
  800bb6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb9:	ff 45 08             	incl   0x8(%ebp)
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8a 00                	mov    (%eax),%al
  800bc1:	84 c0                	test   %al,%al
  800bc3:	75 f1                	jne    800bb6 <strlen+0xf>
		n++;
	return n;
  800bc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bc8:	c9                   	leave  
  800bc9:	c3                   	ret    

00800bca <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd7:	eb 09                	jmp    800be2 <strnlen+0x18>
		n++;
  800bd9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bdc:	ff 45 08             	incl   0x8(%ebp)
  800bdf:	ff 4d 0c             	decl   0xc(%ebp)
  800be2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be6:	74 09                	je     800bf1 <strnlen+0x27>
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	8a 00                	mov    (%eax),%al
  800bed:	84 c0                	test   %al,%al
  800bef:	75 e8                	jne    800bd9 <strnlen+0xf>
		n++;
	return n;
  800bf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf4:	c9                   	leave  
  800bf5:	c3                   	ret    

00800bf6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c02:	90                   	nop
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	8d 50 01             	lea    0x1(%eax),%edx
  800c09:	89 55 08             	mov    %edx,0x8(%ebp)
  800c0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c12:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c15:	8a 12                	mov    (%edx),%dl
  800c17:	88 10                	mov    %dl,(%eax)
  800c19:	8a 00                	mov    (%eax),%al
  800c1b:	84 c0                	test   %al,%al
  800c1d:	75 e4                	jne    800c03 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c37:	eb 1f                	jmp    800c58 <strncpy+0x34>
		*dst++ = *src;
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	8d 50 01             	lea    0x1(%eax),%edx
  800c3f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c45:	8a 12                	mov    (%edx),%dl
  800c47:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4c:	8a 00                	mov    (%eax),%al
  800c4e:	84 c0                	test   %al,%al
  800c50:	74 03                	je     800c55 <strncpy+0x31>
			src++;
  800c52:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c55:	ff 45 fc             	incl   -0x4(%ebp)
  800c58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c5b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c5e:	72 d9                	jb     800c39 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c60:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c75:	74 30                	je     800ca7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c77:	eb 16                	jmp    800c8f <strlcpy+0x2a>
			*dst++ = *src++;
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	8d 50 01             	lea    0x1(%eax),%edx
  800c7f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c82:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c85:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c88:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c8b:	8a 12                	mov    (%edx),%dl
  800c8d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c8f:	ff 4d 10             	decl   0x10(%ebp)
  800c92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c96:	74 09                	je     800ca1 <strlcpy+0x3c>
  800c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9b:	8a 00                	mov    (%eax),%al
  800c9d:	84 c0                	test   %al,%al
  800c9f:	75 d8                	jne    800c79 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ca7:	8b 55 08             	mov    0x8(%ebp),%edx
  800caa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cad:	29 c2                	sub    %eax,%edx
  800caf:	89 d0                	mov    %edx,%eax
}
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cb6:	eb 06                	jmp    800cbe <strcmp+0xb>
		p++, q++;
  800cb8:	ff 45 08             	incl   0x8(%ebp)
  800cbb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8a 00                	mov    (%eax),%al
  800cc3:	84 c0                	test   %al,%al
  800cc5:	74 0e                	je     800cd5 <strcmp+0x22>
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8a 10                	mov    (%eax),%dl
  800ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	38 c2                	cmp    %al,%dl
  800cd3:	74 e3                	je     800cb8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8a 00                	mov    (%eax),%al
  800cda:	0f b6 d0             	movzbl %al,%edx
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	0f b6 c0             	movzbl %al,%eax
  800ce5:	29 c2                	sub    %eax,%edx
  800ce7:	89 d0                	mov    %edx,%eax
}
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    

00800ceb <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cee:	eb 09                	jmp    800cf9 <strncmp+0xe>
		n--, p++, q++;
  800cf0:	ff 4d 10             	decl   0x10(%ebp)
  800cf3:	ff 45 08             	incl   0x8(%ebp)
  800cf6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cf9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cfd:	74 17                	je     800d16 <strncmp+0x2b>
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8a 00                	mov    (%eax),%al
  800d04:	84 c0                	test   %al,%al
  800d06:	74 0e                	je     800d16 <strncmp+0x2b>
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8a 10                	mov    (%eax),%dl
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	38 c2                	cmp    %al,%dl
  800d14:	74 da                	je     800cf0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d16:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1a:	75 07                	jne    800d23 <strncmp+0x38>
		return 0;
  800d1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d21:	eb 14                	jmp    800d37 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	0f b6 d0             	movzbl %al,%edx
  800d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	0f b6 c0             	movzbl %al,%eax
  800d33:	29 c2                	sub    %eax,%edx
  800d35:	89 d0                	mov    %edx,%eax
}
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    

00800d39 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	83 ec 04             	sub    $0x4,%esp
  800d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d42:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d45:	eb 12                	jmp    800d59 <strchr+0x20>
		if (*s == c)
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d4f:	75 05                	jne    800d56 <strchr+0x1d>
			return (char *) s;
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	eb 11                	jmp    800d67 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d56:	ff 45 08             	incl   0x8(%ebp)
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	84 c0                	test   %al,%al
  800d60:	75 e5                	jne    800d47 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d67:	c9                   	leave  
  800d68:	c3                   	ret    

00800d69 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	83 ec 04             	sub    $0x4,%esp
  800d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d72:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d75:	eb 0d                	jmp    800d84 <strfind+0x1b>
		if (*s == c)
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d7f:	74 0e                	je     800d8f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d81:	ff 45 08             	incl   0x8(%ebp)
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	8a 00                	mov    (%eax),%al
  800d89:	84 c0                	test   %al,%al
  800d8b:	75 ea                	jne    800d77 <strfind+0xe>
  800d8d:	eb 01                	jmp    800d90 <strfind+0x27>
		if (*s == c)
			break;
  800d8f:	90                   	nop
	return (char *) s;
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d93:	c9                   	leave  
  800d94:	c3                   	ret    

00800d95 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800da1:	8b 45 10             	mov    0x10(%ebp),%eax
  800da4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800da7:	eb 0e                	jmp    800db7 <memset+0x22>
		*p++ = c;
  800da9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dac:	8d 50 01             	lea    0x1(%eax),%edx
  800daf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800db2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800db7:	ff 4d f8             	decl   -0x8(%ebp)
  800dba:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dbe:	79 e9                	jns    800da9 <memset+0x14>
		*p++ = c;

	return v;
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dd7:	eb 16                	jmp    800def <memcpy+0x2a>
		*d++ = *s++;
  800dd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ddc:	8d 50 01             	lea    0x1(%eax),%edx
  800ddf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800de5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800deb:	8a 12                	mov    (%edx),%dl
  800ded:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800def:	8b 45 10             	mov    0x10(%ebp),%eax
  800df2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df5:	89 55 10             	mov    %edx,0x10(%ebp)
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	75 dd                	jne    800dd9 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dff:	c9                   	leave  
  800e00:	c3                   	ret    

00800e01 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e16:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e19:	73 50                	jae    800e6b <memmove+0x6a>
  800e1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e21:	01 d0                	add    %edx,%eax
  800e23:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e26:	76 43                	jbe    800e6b <memmove+0x6a>
		s += n;
  800e28:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e31:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e34:	eb 10                	jmp    800e46 <memmove+0x45>
			*--d = *--s;
  800e36:	ff 4d f8             	decl   -0x8(%ebp)
  800e39:	ff 4d fc             	decl   -0x4(%ebp)
  800e3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3f:	8a 10                	mov    (%eax),%dl
  800e41:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e44:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e46:	8b 45 10             	mov    0x10(%ebp),%eax
  800e49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	75 e3                	jne    800e36 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e53:	eb 23                	jmp    800e78 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e58:	8d 50 01             	lea    0x1(%eax),%edx
  800e5b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e5e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e61:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e64:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e67:	8a 12                	mov    (%edx),%dl
  800e69:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e71:	89 55 10             	mov    %edx,0x10(%ebp)
  800e74:	85 c0                	test   %eax,%eax
  800e76:	75 dd                	jne    800e55 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e8f:	eb 2a                	jmp    800ebb <memcmp+0x3e>
		if (*s1 != *s2)
  800e91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e94:	8a 10                	mov    (%eax),%dl
  800e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	38 c2                	cmp    %al,%dl
  800e9d:	74 16                	je     800eb5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea2:	8a 00                	mov    (%eax),%al
  800ea4:	0f b6 d0             	movzbl %al,%edx
  800ea7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	0f b6 c0             	movzbl %al,%eax
  800eaf:	29 c2                	sub    %eax,%edx
  800eb1:	89 d0                	mov    %edx,%eax
  800eb3:	eb 18                	jmp    800ecd <memcmp+0x50>
		s1++, s2++;
  800eb5:	ff 45 fc             	incl   -0x4(%ebp)
  800eb8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ebb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	75 c9                	jne    800e91 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ec8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ecd:	c9                   	leave  
  800ece:	c3                   	ret    

00800ecf <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ed5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed8:	8b 45 10             	mov    0x10(%ebp),%eax
  800edb:	01 d0                	add    %edx,%eax
  800edd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ee0:	eb 15                	jmp    800ef7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	0f b6 d0             	movzbl %al,%edx
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	0f b6 c0             	movzbl %al,%eax
  800ef0:	39 c2                	cmp    %eax,%edx
  800ef2:	74 0d                	je     800f01 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ef4:	ff 45 08             	incl   0x8(%ebp)
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800efd:	72 e3                	jb     800ee2 <memfind+0x13>
  800eff:	eb 01                	jmp    800f02 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f01:	90                   	nop
	return (void *) s;
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f05:	c9                   	leave  
  800f06:	c3                   	ret    

00800f07 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f14:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f1b:	eb 03                	jmp    800f20 <strtol+0x19>
		s++;
  800f1d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	3c 20                	cmp    $0x20,%al
  800f27:	74 f4                	je     800f1d <strtol+0x16>
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	3c 09                	cmp    $0x9,%al
  800f30:	74 eb                	je     800f1d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	3c 2b                	cmp    $0x2b,%al
  800f39:	75 05                	jne    800f40 <strtol+0x39>
		s++;
  800f3b:	ff 45 08             	incl   0x8(%ebp)
  800f3e:	eb 13                	jmp    800f53 <strtol+0x4c>
	else if (*s == '-')
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	3c 2d                	cmp    $0x2d,%al
  800f47:	75 0a                	jne    800f53 <strtol+0x4c>
		s++, neg = 1;
  800f49:	ff 45 08             	incl   0x8(%ebp)
  800f4c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f53:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f57:	74 06                	je     800f5f <strtol+0x58>
  800f59:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f5d:	75 20                	jne    800f7f <strtol+0x78>
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	3c 30                	cmp    $0x30,%al
  800f66:	75 17                	jne    800f7f <strtol+0x78>
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	40                   	inc    %eax
  800f6c:	8a 00                	mov    (%eax),%al
  800f6e:	3c 78                	cmp    $0x78,%al
  800f70:	75 0d                	jne    800f7f <strtol+0x78>
		s += 2, base = 16;
  800f72:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f76:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f7d:	eb 28                	jmp    800fa7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f83:	75 15                	jne    800f9a <strtol+0x93>
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	3c 30                	cmp    $0x30,%al
  800f8c:	75 0c                	jne    800f9a <strtol+0x93>
		s++, base = 8;
  800f8e:	ff 45 08             	incl   0x8(%ebp)
  800f91:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f98:	eb 0d                	jmp    800fa7 <strtol+0xa0>
	else if (base == 0)
  800f9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9e:	75 07                	jne    800fa7 <strtol+0xa0>
		base = 10;
  800fa0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	8a 00                	mov    (%eax),%al
  800fac:	3c 2f                	cmp    $0x2f,%al
  800fae:	7e 19                	jle    800fc9 <strtol+0xc2>
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	8a 00                	mov    (%eax),%al
  800fb5:	3c 39                	cmp    $0x39,%al
  800fb7:	7f 10                	jg     800fc9 <strtol+0xc2>
			dig = *s - '0';
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	8a 00                	mov    (%eax),%al
  800fbe:	0f be c0             	movsbl %al,%eax
  800fc1:	83 e8 30             	sub    $0x30,%eax
  800fc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc7:	eb 42                	jmp    80100b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	3c 60                	cmp    $0x60,%al
  800fd0:	7e 19                	jle    800feb <strtol+0xe4>
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	3c 7a                	cmp    $0x7a,%al
  800fd9:	7f 10                	jg     800feb <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	0f be c0             	movsbl %al,%eax
  800fe3:	83 e8 57             	sub    $0x57,%eax
  800fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe9:	eb 20                	jmp    80100b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	8a 00                	mov    (%eax),%al
  800ff0:	3c 40                	cmp    $0x40,%al
  800ff2:	7e 39                	jle    80102d <strtol+0x126>
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	3c 5a                	cmp    $0x5a,%al
  800ffb:	7f 30                	jg     80102d <strtol+0x126>
			dig = *s - 'A' + 10;
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	0f be c0             	movsbl %al,%eax
  801005:	83 e8 37             	sub    $0x37,%eax
  801008:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80100b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801011:	7d 19                	jge    80102c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801013:	ff 45 08             	incl   0x8(%ebp)
  801016:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801019:	0f af 45 10          	imul   0x10(%ebp),%eax
  80101d:	89 c2                	mov    %eax,%edx
  80101f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801022:	01 d0                	add    %edx,%eax
  801024:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801027:	e9 7b ff ff ff       	jmp    800fa7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80102c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80102d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801031:	74 08                	je     80103b <strtol+0x134>
		*endptr = (char *) s;
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	8b 55 08             	mov    0x8(%ebp),%edx
  801039:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80103b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80103f:	74 07                	je     801048 <strtol+0x141>
  801041:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801044:	f7 d8                	neg    %eax
  801046:	eb 03                	jmp    80104b <strtol+0x144>
  801048:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80104b:	c9                   	leave  
  80104c:	c3                   	ret    

0080104d <ltostr>:

void
ltostr(long value, char *str)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801053:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80105a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801061:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801065:	79 13                	jns    80107a <ltostr+0x2d>
	{
		neg = 1;
  801067:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80106e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801071:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801074:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801077:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801082:	99                   	cltd   
  801083:	f7 f9                	idiv   %ecx
  801085:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801088:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108b:	8d 50 01             	lea    0x1(%eax),%edx
  80108e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801091:	89 c2                	mov    %eax,%edx
  801093:	8b 45 0c             	mov    0xc(%ebp),%eax
  801096:	01 d0                	add    %edx,%eax
  801098:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80109b:	83 c2 30             	add    $0x30,%edx
  80109e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010a8:	f7 e9                	imul   %ecx
  8010aa:	c1 fa 02             	sar    $0x2,%edx
  8010ad:	89 c8                	mov    %ecx,%eax
  8010af:	c1 f8 1f             	sar    $0x1f,%eax
  8010b2:	29 c2                	sub    %eax,%edx
  8010b4:	89 d0                	mov    %edx,%eax
  8010b6:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010bc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c1:	f7 e9                	imul   %ecx
  8010c3:	c1 fa 02             	sar    $0x2,%edx
  8010c6:	89 c8                	mov    %ecx,%eax
  8010c8:	c1 f8 1f             	sar    $0x1f,%eax
  8010cb:	29 c2                	sub    %eax,%edx
  8010cd:	89 d0                	mov    %edx,%eax
  8010cf:	c1 e0 02             	shl    $0x2,%eax
  8010d2:	01 d0                	add    %edx,%eax
  8010d4:	01 c0                	add    %eax,%eax
  8010d6:	29 c1                	sub    %eax,%ecx
  8010d8:	89 ca                	mov    %ecx,%edx
  8010da:	85 d2                	test   %edx,%edx
  8010dc:	75 9c                	jne    80107a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e8:	48                   	dec    %eax
  8010e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f0:	74 3d                	je     80112f <ltostr+0xe2>
		start = 1 ;
  8010f2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010f9:	eb 34                	jmp    80112f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801101:	01 d0                	add    %edx,%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801108:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110e:	01 c2                	add    %eax,%edx
  801110:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801113:	8b 45 0c             	mov    0xc(%ebp),%eax
  801116:	01 c8                	add    %ecx,%eax
  801118:	8a 00                	mov    (%eax),%al
  80111a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80111c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80111f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801122:	01 c2                	add    %eax,%edx
  801124:	8a 45 eb             	mov    -0x15(%ebp),%al
  801127:	88 02                	mov    %al,(%edx)
		start++ ;
  801129:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80112c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80112f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801132:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801135:	7c c4                	jl     8010fb <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801137:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80113a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113d:	01 d0                	add    %edx,%eax
  80113f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801142:	90                   	nop
  801143:	c9                   	leave  
  801144:	c3                   	ret    

00801145 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80114b:	ff 75 08             	pushl  0x8(%ebp)
  80114e:	e8 54 fa ff ff       	call   800ba7 <strlen>
  801153:	83 c4 04             	add    $0x4,%esp
  801156:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801159:	ff 75 0c             	pushl  0xc(%ebp)
  80115c:	e8 46 fa ff ff       	call   800ba7 <strlen>
  801161:	83 c4 04             	add    $0x4,%esp
  801164:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801167:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80116e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801175:	eb 17                	jmp    80118e <strcconcat+0x49>
		final[s] = str1[s] ;
  801177:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80117a:	8b 45 10             	mov    0x10(%ebp),%eax
  80117d:	01 c2                	add    %eax,%edx
  80117f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	01 c8                	add    %ecx,%eax
  801187:	8a 00                	mov    (%eax),%al
  801189:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80118b:	ff 45 fc             	incl   -0x4(%ebp)
  80118e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801191:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801194:	7c e1                	jl     801177 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801196:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80119d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011a4:	eb 1f                	jmp    8011c5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a9:	8d 50 01             	lea    0x1(%eax),%edx
  8011ac:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011af:	89 c2                	mov    %eax,%edx
  8011b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b4:	01 c2                	add    %eax,%edx
  8011b6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bc:	01 c8                	add    %ecx,%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011c2:	ff 45 f8             	incl   -0x8(%ebp)
  8011c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011cb:	7c d9                	jl     8011a6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d3:	01 d0                	add    %edx,%eax
  8011d5:	c6 00 00             	movb   $0x0,(%eax)
}
  8011d8:	90                   	nop
  8011d9:	c9                   	leave  
  8011da:	c3                   	ret    

008011db <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011de:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ea:	8b 00                	mov    (%eax),%eax
  8011ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f6:	01 d0                	add    %edx,%eax
  8011f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011fe:	eb 0c                	jmp    80120c <strsplit+0x31>
			*string++ = 0;
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	8d 50 01             	lea    0x1(%eax),%edx
  801206:	89 55 08             	mov    %edx,0x8(%ebp)
  801209:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	84 c0                	test   %al,%al
  801213:	74 18                	je     80122d <strsplit+0x52>
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	0f be c0             	movsbl %al,%eax
  80121d:	50                   	push   %eax
  80121e:	ff 75 0c             	pushl  0xc(%ebp)
  801221:	e8 13 fb ff ff       	call   800d39 <strchr>
  801226:	83 c4 08             	add    $0x8,%esp
  801229:	85 c0                	test   %eax,%eax
  80122b:	75 d3                	jne    801200 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	8a 00                	mov    (%eax),%al
  801232:	84 c0                	test   %al,%al
  801234:	74 5a                	je     801290 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801236:	8b 45 14             	mov    0x14(%ebp),%eax
  801239:	8b 00                	mov    (%eax),%eax
  80123b:	83 f8 0f             	cmp    $0xf,%eax
  80123e:	75 07                	jne    801247 <strsplit+0x6c>
		{
			return 0;
  801240:	b8 00 00 00 00       	mov    $0x0,%eax
  801245:	eb 66                	jmp    8012ad <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	8d 48 01             	lea    0x1(%eax),%ecx
  80124f:	8b 55 14             	mov    0x14(%ebp),%edx
  801252:	89 0a                	mov    %ecx,(%edx)
  801254:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80125b:	8b 45 10             	mov    0x10(%ebp),%eax
  80125e:	01 c2                	add    %eax,%edx
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801265:	eb 03                	jmp    80126a <strsplit+0x8f>
			string++;
  801267:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	84 c0                	test   %al,%al
  801271:	74 8b                	je     8011fe <strsplit+0x23>
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	0f be c0             	movsbl %al,%eax
  80127b:	50                   	push   %eax
  80127c:	ff 75 0c             	pushl  0xc(%ebp)
  80127f:	e8 b5 fa ff ff       	call   800d39 <strchr>
  801284:	83 c4 08             	add    $0x8,%esp
  801287:	85 c0                	test   %eax,%eax
  801289:	74 dc                	je     801267 <strsplit+0x8c>
			string++;
	}
  80128b:	e9 6e ff ff ff       	jmp    8011fe <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801290:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801291:	8b 45 14             	mov    0x14(%ebp),%eax
  801294:	8b 00                	mov    (%eax),%eax
  801296:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129d:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a0:	01 d0                	add    %edx,%eax
  8012a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012a8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012ad:	c9                   	leave  
  8012ae:	c3                   	ret    

008012af <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
  8012b2:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012b5:	a1 04 40 80 00       	mov    0x804004,%eax
  8012ba:	85 c0                	test   %eax,%eax
  8012bc:	74 1f                	je     8012dd <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012be:	e8 1d 00 00 00       	call   8012e0 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012c3:	83 ec 0c             	sub    $0xc,%esp
  8012c6:	68 50 37 80 00       	push   $0x803750
  8012cb:	e8 55 f2 ff ff       	call   800525 <cprintf>
  8012d0:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012d3:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012da:	00 00 00 
	}
}
  8012dd:	90                   	nop
  8012de:	c9                   	leave  
  8012df:	c3                   	ret    

008012e0 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  8012e6:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8012ed:	00 00 00 
  8012f0:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8012f7:	00 00 00 
  8012fa:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801301:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801304:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80130b:	00 00 00 
  80130e:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801315:	00 00 00 
  801318:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80131f:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801322:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801329:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  80132c:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801336:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80133b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801340:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  801345:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  80134c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80134f:	a1 20 41 80 00       	mov    0x804120,%eax
  801354:	0f af c2             	imul   %edx,%eax
  801357:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  80135a:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801361:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801364:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801367:	01 d0                	add    %edx,%eax
  801369:	48                   	dec    %eax
  80136a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80136d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801370:	ba 00 00 00 00       	mov    $0x0,%edx
  801375:	f7 75 e8             	divl   -0x18(%ebp)
  801378:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80137b:	29 d0                	sub    %edx,%eax
  80137d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801380:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801383:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  80138a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80138d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801393:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801399:	83 ec 04             	sub    $0x4,%esp
  80139c:	6a 06                	push   $0x6
  80139e:	50                   	push   %eax
  80139f:	52                   	push   %edx
  8013a0:	e8 a1 05 00 00       	call   801946 <sys_allocate_chunk>
  8013a5:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013a8:	a1 20 41 80 00       	mov    0x804120,%eax
  8013ad:	83 ec 0c             	sub    $0xc,%esp
  8013b0:	50                   	push   %eax
  8013b1:	e8 16 0c 00 00       	call   801fcc <initialize_MemBlocksList>
  8013b6:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  8013b9:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8013be:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  8013c1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8013c5:	75 14                	jne    8013db <initialize_dyn_block_system+0xfb>
  8013c7:	83 ec 04             	sub    $0x4,%esp
  8013ca:	68 75 37 80 00       	push   $0x803775
  8013cf:	6a 2d                	push   $0x2d
  8013d1:	68 93 37 80 00       	push   $0x803793
  8013d6:	e8 96 ee ff ff       	call   800271 <_panic>
  8013db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013de:	8b 00                	mov    (%eax),%eax
  8013e0:	85 c0                	test   %eax,%eax
  8013e2:	74 10                	je     8013f4 <initialize_dyn_block_system+0x114>
  8013e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013e7:	8b 00                	mov    (%eax),%eax
  8013e9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8013ec:	8b 52 04             	mov    0x4(%edx),%edx
  8013ef:	89 50 04             	mov    %edx,0x4(%eax)
  8013f2:	eb 0b                	jmp    8013ff <initialize_dyn_block_system+0x11f>
  8013f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013f7:	8b 40 04             	mov    0x4(%eax),%eax
  8013fa:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8013ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801402:	8b 40 04             	mov    0x4(%eax),%eax
  801405:	85 c0                	test   %eax,%eax
  801407:	74 0f                	je     801418 <initialize_dyn_block_system+0x138>
  801409:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80140c:	8b 40 04             	mov    0x4(%eax),%eax
  80140f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801412:	8b 12                	mov    (%edx),%edx
  801414:	89 10                	mov    %edx,(%eax)
  801416:	eb 0a                	jmp    801422 <initialize_dyn_block_system+0x142>
  801418:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80141b:	8b 00                	mov    (%eax),%eax
  80141d:	a3 48 41 80 00       	mov    %eax,0x804148
  801422:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801425:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80142b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80142e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801435:	a1 54 41 80 00       	mov    0x804154,%eax
  80143a:	48                   	dec    %eax
  80143b:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801440:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801443:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  80144a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80144d:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801454:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801458:	75 14                	jne    80146e <initialize_dyn_block_system+0x18e>
  80145a:	83 ec 04             	sub    $0x4,%esp
  80145d:	68 a0 37 80 00       	push   $0x8037a0
  801462:	6a 30                	push   $0x30
  801464:	68 93 37 80 00       	push   $0x803793
  801469:	e8 03 ee ff ff       	call   800271 <_panic>
  80146e:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  801474:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801477:	89 50 04             	mov    %edx,0x4(%eax)
  80147a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80147d:	8b 40 04             	mov    0x4(%eax),%eax
  801480:	85 c0                	test   %eax,%eax
  801482:	74 0c                	je     801490 <initialize_dyn_block_system+0x1b0>
  801484:	a1 3c 41 80 00       	mov    0x80413c,%eax
  801489:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80148c:	89 10                	mov    %edx,(%eax)
  80148e:	eb 08                	jmp    801498 <initialize_dyn_block_system+0x1b8>
  801490:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801493:	a3 38 41 80 00       	mov    %eax,0x804138
  801498:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80149b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8014a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014a9:	a1 44 41 80 00       	mov    0x804144,%eax
  8014ae:	40                   	inc    %eax
  8014af:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8014b4:	90                   	nop
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    

008014b7 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
  8014ba:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014bd:	e8 ed fd ff ff       	call   8012af <InitializeUHeap>
	if (size == 0) return NULL ;
  8014c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014c6:	75 07                	jne    8014cf <malloc+0x18>
  8014c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014cd:	eb 67                	jmp    801536 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  8014cf:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014dc:	01 d0                	add    %edx,%eax
  8014de:	48                   	dec    %eax
  8014df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ea:	f7 75 f4             	divl   -0xc(%ebp)
  8014ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f0:	29 d0                	sub    %edx,%eax
  8014f2:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014f5:	e8 1a 08 00 00       	call   801d14 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014fa:	85 c0                	test   %eax,%eax
  8014fc:	74 33                	je     801531 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  8014fe:	83 ec 0c             	sub    $0xc,%esp
  801501:	ff 75 08             	pushl  0x8(%ebp)
  801504:	e8 0c 0e 00 00       	call   802315 <alloc_block_FF>
  801509:	83 c4 10             	add    $0x10,%esp
  80150c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  80150f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801513:	74 1c                	je     801531 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801515:	83 ec 0c             	sub    $0xc,%esp
  801518:	ff 75 ec             	pushl  -0x14(%ebp)
  80151b:	e8 07 0c 00 00       	call   802127 <insert_sorted_allocList>
  801520:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801523:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801526:	8b 40 08             	mov    0x8(%eax),%eax
  801529:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  80152c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80152f:	eb 05                	jmp    801536 <malloc+0x7f>
		}
	}
	return NULL;
  801531:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801544:	83 ec 08             	sub    $0x8,%esp
  801547:	ff 75 f4             	pushl  -0xc(%ebp)
  80154a:	68 40 40 80 00       	push   $0x804040
  80154f:	e8 5b 0b 00 00       	call   8020af <find_block>
  801554:	83 c4 10             	add    $0x10,%esp
  801557:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  80155a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155d:	8b 40 0c             	mov    0xc(%eax),%eax
  801560:	83 ec 08             	sub    $0x8,%esp
  801563:	50                   	push   %eax
  801564:	ff 75 f4             	pushl  -0xc(%ebp)
  801567:	e8 a2 03 00 00       	call   80190e <sys_free_user_mem>
  80156c:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  80156f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801573:	75 14                	jne    801589 <free+0x51>
  801575:	83 ec 04             	sub    $0x4,%esp
  801578:	68 75 37 80 00       	push   $0x803775
  80157d:	6a 76                	push   $0x76
  80157f:	68 93 37 80 00       	push   $0x803793
  801584:	e8 e8 ec ff ff       	call   800271 <_panic>
  801589:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158c:	8b 00                	mov    (%eax),%eax
  80158e:	85 c0                	test   %eax,%eax
  801590:	74 10                	je     8015a2 <free+0x6a>
  801592:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801595:	8b 00                	mov    (%eax),%eax
  801597:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80159a:	8b 52 04             	mov    0x4(%edx),%edx
  80159d:	89 50 04             	mov    %edx,0x4(%eax)
  8015a0:	eb 0b                	jmp    8015ad <free+0x75>
  8015a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a5:	8b 40 04             	mov    0x4(%eax),%eax
  8015a8:	a3 44 40 80 00       	mov    %eax,0x804044
  8015ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b0:	8b 40 04             	mov    0x4(%eax),%eax
  8015b3:	85 c0                	test   %eax,%eax
  8015b5:	74 0f                	je     8015c6 <free+0x8e>
  8015b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ba:	8b 40 04             	mov    0x4(%eax),%eax
  8015bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015c0:	8b 12                	mov    (%edx),%edx
  8015c2:	89 10                	mov    %edx,(%eax)
  8015c4:	eb 0a                	jmp    8015d0 <free+0x98>
  8015c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c9:	8b 00                	mov    (%eax),%eax
  8015cb:	a3 40 40 80 00       	mov    %eax,0x804040
  8015d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015e3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015e8:	48                   	dec    %eax
  8015e9:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  8015ee:	83 ec 0c             	sub    $0xc,%esp
  8015f1:	ff 75 f0             	pushl  -0x10(%ebp)
  8015f4:	e8 0b 14 00 00       	call   802a04 <insert_sorted_with_merge_freeList>
  8015f9:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8015fc:	90                   	nop
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 28             	sub    $0x28,%esp
  801605:	8b 45 10             	mov    0x10(%ebp),%eax
  801608:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80160b:	e8 9f fc ff ff       	call   8012af <InitializeUHeap>
	if (size == 0) return NULL ;
  801610:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801614:	75 0a                	jne    801620 <smalloc+0x21>
  801616:	b8 00 00 00 00       	mov    $0x0,%eax
  80161b:	e9 8d 00 00 00       	jmp    8016ad <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801620:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801627:	8b 55 0c             	mov    0xc(%ebp),%edx
  80162a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162d:	01 d0                	add    %edx,%eax
  80162f:	48                   	dec    %eax
  801630:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801633:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801636:	ba 00 00 00 00       	mov    $0x0,%edx
  80163b:	f7 75 f4             	divl   -0xc(%ebp)
  80163e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801641:	29 d0                	sub    %edx,%eax
  801643:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801646:	e8 c9 06 00 00       	call   801d14 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80164b:	85 c0                	test   %eax,%eax
  80164d:	74 59                	je     8016a8 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  80164f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801656:	83 ec 0c             	sub    $0xc,%esp
  801659:	ff 75 0c             	pushl  0xc(%ebp)
  80165c:	e8 b4 0c 00 00       	call   802315 <alloc_block_FF>
  801661:	83 c4 10             	add    $0x10,%esp
  801664:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801667:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80166b:	75 07                	jne    801674 <smalloc+0x75>
			{
				return NULL;
  80166d:	b8 00 00 00 00       	mov    $0x0,%eax
  801672:	eb 39                	jmp    8016ad <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801674:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801677:	8b 40 08             	mov    0x8(%eax),%eax
  80167a:	89 c2                	mov    %eax,%edx
  80167c:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801680:	52                   	push   %edx
  801681:	50                   	push   %eax
  801682:	ff 75 0c             	pushl  0xc(%ebp)
  801685:	ff 75 08             	pushl  0x8(%ebp)
  801688:	e8 0c 04 00 00       	call   801a99 <sys_createSharedObject>
  80168d:	83 c4 10             	add    $0x10,%esp
  801690:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  801693:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801697:	78 08                	js     8016a1 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  801699:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80169c:	8b 40 08             	mov    0x8(%eax),%eax
  80169f:	eb 0c                	jmp    8016ad <smalloc+0xae>
				}
				else
				{
					return NULL;
  8016a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a6:	eb 05                	jmp    8016ad <smalloc+0xae>
				}
			}

		}
		return NULL;
  8016a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016b5:	e8 f5 fb ff ff       	call   8012af <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016ba:	83 ec 08             	sub    $0x8,%esp
  8016bd:	ff 75 0c             	pushl  0xc(%ebp)
  8016c0:	ff 75 08             	pushl  0x8(%ebp)
  8016c3:	e8 fb 03 00 00       	call   801ac3 <sys_getSizeOfSharedObject>
  8016c8:	83 c4 10             	add    $0x10,%esp
  8016cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  8016ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016d2:	75 07                	jne    8016db <sget+0x2c>
	{
		return NULL;
  8016d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d9:	eb 64                	jmp    80173f <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016db:	e8 34 06 00 00       	call   801d14 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016e0:	85 c0                	test   %eax,%eax
  8016e2:	74 56                	je     80173a <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  8016e4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  8016eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ee:	83 ec 0c             	sub    $0xc,%esp
  8016f1:	50                   	push   %eax
  8016f2:	e8 1e 0c 00 00       	call   802315 <alloc_block_FF>
  8016f7:	83 c4 10             	add    $0x10,%esp
  8016fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  8016fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801701:	75 07                	jne    80170a <sget+0x5b>
		{
		return NULL;
  801703:	b8 00 00 00 00       	mov    $0x0,%eax
  801708:	eb 35                	jmp    80173f <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  80170a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170d:	8b 40 08             	mov    0x8(%eax),%eax
  801710:	83 ec 04             	sub    $0x4,%esp
  801713:	50                   	push   %eax
  801714:	ff 75 0c             	pushl  0xc(%ebp)
  801717:	ff 75 08             	pushl  0x8(%ebp)
  80171a:	e8 c1 03 00 00       	call   801ae0 <sys_getSharedObject>
  80171f:	83 c4 10             	add    $0x10,%esp
  801722:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801725:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801729:	78 08                	js     801733 <sget+0x84>
			{
				return (void*)v1->sva;
  80172b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172e:	8b 40 08             	mov    0x8(%eax),%eax
  801731:	eb 0c                	jmp    80173f <sget+0x90>
			}
			else
			{
				return NULL;
  801733:	b8 00 00 00 00       	mov    $0x0,%eax
  801738:	eb 05                	jmp    80173f <sget+0x90>
			}
		}
	}
  return NULL;
  80173a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
  801744:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801747:	e8 63 fb ff ff       	call   8012af <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80174c:	83 ec 04             	sub    $0x4,%esp
  80174f:	68 c4 37 80 00       	push   $0x8037c4
  801754:	68 0e 01 00 00       	push   $0x10e
  801759:	68 93 37 80 00       	push   $0x803793
  80175e:	e8 0e eb ff ff       	call   800271 <_panic>

00801763 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
  801766:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801769:	83 ec 04             	sub    $0x4,%esp
  80176c:	68 ec 37 80 00       	push   $0x8037ec
  801771:	68 22 01 00 00       	push   $0x122
  801776:	68 93 37 80 00       	push   $0x803793
  80177b:	e8 f1 ea ff ff       	call   800271 <_panic>

00801780 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801786:	83 ec 04             	sub    $0x4,%esp
  801789:	68 10 38 80 00       	push   $0x803810
  80178e:	68 2d 01 00 00       	push   $0x12d
  801793:	68 93 37 80 00       	push   $0x803793
  801798:	e8 d4 ea ff ff       	call   800271 <_panic>

0080179d <shrink>:

}
void shrink(uint32 newSize)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
  8017a0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017a3:	83 ec 04             	sub    $0x4,%esp
  8017a6:	68 10 38 80 00       	push   $0x803810
  8017ab:	68 32 01 00 00       	push   $0x132
  8017b0:	68 93 37 80 00       	push   $0x803793
  8017b5:	e8 b7 ea ff ff       	call   800271 <_panic>

008017ba <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c0:	83 ec 04             	sub    $0x4,%esp
  8017c3:	68 10 38 80 00       	push   $0x803810
  8017c8:	68 37 01 00 00       	push   $0x137
  8017cd:	68 93 37 80 00       	push   $0x803793
  8017d2:	e8 9a ea ff ff       	call   800271 <_panic>

008017d7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
  8017da:	57                   	push   %edi
  8017db:	56                   	push   %esi
  8017dc:	53                   	push   %ebx
  8017dd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017ec:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017ef:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017f2:	cd 30                	int    $0x30
  8017f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017fa:	83 c4 10             	add    $0x10,%esp
  8017fd:	5b                   	pop    %ebx
  8017fe:	5e                   	pop    %esi
  8017ff:	5f                   	pop    %edi
  801800:	5d                   	pop    %ebp
  801801:	c3                   	ret    

00801802 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
  801805:	83 ec 04             	sub    $0x4,%esp
  801808:	8b 45 10             	mov    0x10(%ebp),%eax
  80180b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80180e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	52                   	push   %edx
  80181a:	ff 75 0c             	pushl  0xc(%ebp)
  80181d:	50                   	push   %eax
  80181e:	6a 00                	push   $0x0
  801820:	e8 b2 ff ff ff       	call   8017d7 <syscall>
  801825:	83 c4 18             	add    $0x18,%esp
}
  801828:	90                   	nop
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <sys_cgetc>:

int
sys_cgetc(void)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 01                	push   $0x1
  80183a:	e8 98 ff ff ff       	call   8017d7 <syscall>
  80183f:	83 c4 18             	add    $0x18,%esp
}
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801847:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	52                   	push   %edx
  801854:	50                   	push   %eax
  801855:	6a 05                	push   $0x5
  801857:	e8 7b ff ff ff       	call   8017d7 <syscall>
  80185c:	83 c4 18             	add    $0x18,%esp
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
  801864:	56                   	push   %esi
  801865:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801866:	8b 75 18             	mov    0x18(%ebp),%esi
  801869:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80186c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80186f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	56                   	push   %esi
  801876:	53                   	push   %ebx
  801877:	51                   	push   %ecx
  801878:	52                   	push   %edx
  801879:	50                   	push   %eax
  80187a:	6a 06                	push   $0x6
  80187c:	e8 56 ff ff ff       	call   8017d7 <syscall>
  801881:	83 c4 18             	add    $0x18,%esp
}
  801884:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801887:	5b                   	pop    %ebx
  801888:	5e                   	pop    %esi
  801889:	5d                   	pop    %ebp
  80188a:	c3                   	ret    

0080188b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80188e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801891:	8b 45 08             	mov    0x8(%ebp),%eax
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	52                   	push   %edx
  80189b:	50                   	push   %eax
  80189c:	6a 07                	push   $0x7
  80189e:	e8 34 ff ff ff       	call   8017d7 <syscall>
  8018a3:	83 c4 18             	add    $0x18,%esp
}
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	ff 75 0c             	pushl  0xc(%ebp)
  8018b4:	ff 75 08             	pushl  0x8(%ebp)
  8018b7:	6a 08                	push   $0x8
  8018b9:	e8 19 ff ff ff       	call   8017d7 <syscall>
  8018be:	83 c4 18             	add    $0x18,%esp
}
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 09                	push   $0x9
  8018d2:	e8 00 ff ff ff       	call   8017d7 <syscall>
  8018d7:	83 c4 18             	add    $0x18,%esp
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 0a                	push   $0xa
  8018eb:	e8 e7 fe ff ff       	call   8017d7 <syscall>
  8018f0:	83 c4 18             	add    $0x18,%esp
}
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 0b                	push   $0xb
  801904:	e8 ce fe ff ff       	call   8017d7 <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	ff 75 0c             	pushl  0xc(%ebp)
  80191a:	ff 75 08             	pushl  0x8(%ebp)
  80191d:	6a 0f                	push   $0xf
  80191f:	e8 b3 fe ff ff       	call   8017d7 <syscall>
  801924:	83 c4 18             	add    $0x18,%esp
	return;
  801927:	90                   	nop
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	ff 75 08             	pushl  0x8(%ebp)
  801939:	6a 10                	push   $0x10
  80193b:	e8 97 fe ff ff       	call   8017d7 <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
	return ;
  801943:	90                   	nop
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	ff 75 10             	pushl  0x10(%ebp)
  801950:	ff 75 0c             	pushl  0xc(%ebp)
  801953:	ff 75 08             	pushl  0x8(%ebp)
  801956:	6a 11                	push   $0x11
  801958:	e8 7a fe ff ff       	call   8017d7 <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
	return ;
  801960:	90                   	nop
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 0c                	push   $0xc
  801972:	e8 60 fe ff ff       	call   8017d7 <syscall>
  801977:	83 c4 18             	add    $0x18,%esp
}
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	ff 75 08             	pushl  0x8(%ebp)
  80198a:	6a 0d                	push   $0xd
  80198c:	e8 46 fe ff ff       	call   8017d7 <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 0e                	push   $0xe
  8019a5:	e8 2d fe ff ff       	call   8017d7 <syscall>
  8019aa:	83 c4 18             	add    $0x18,%esp
}
  8019ad:	90                   	nop
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 13                	push   $0x13
  8019bf:	e8 13 fe ff ff       	call   8017d7 <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
}
  8019c7:	90                   	nop
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 14                	push   $0x14
  8019d9:	e8 f9 fd ff ff       	call   8017d7 <syscall>
  8019de:	83 c4 18             	add    $0x18,%esp
}
  8019e1:	90                   	nop
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	83 ec 04             	sub    $0x4,%esp
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019f0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	50                   	push   %eax
  8019fd:	6a 15                	push   $0x15
  8019ff:	e8 d3 fd ff ff       	call   8017d7 <syscall>
  801a04:	83 c4 18             	add    $0x18,%esp
}
  801a07:	90                   	nop
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 16                	push   $0x16
  801a19:	e8 b9 fd ff ff       	call   8017d7 <syscall>
  801a1e:	83 c4 18             	add    $0x18,%esp
}
  801a21:	90                   	nop
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a27:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	ff 75 0c             	pushl  0xc(%ebp)
  801a33:	50                   	push   %eax
  801a34:	6a 17                	push   $0x17
  801a36:	e8 9c fd ff ff       	call   8017d7 <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	52                   	push   %edx
  801a50:	50                   	push   %eax
  801a51:	6a 1a                	push   $0x1a
  801a53:	e8 7f fd ff ff       	call   8017d7 <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a63:	8b 45 08             	mov    0x8(%ebp),%eax
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	52                   	push   %edx
  801a6d:	50                   	push   %eax
  801a6e:	6a 18                	push   $0x18
  801a70:	e8 62 fd ff ff       	call   8017d7 <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
}
  801a78:	90                   	nop
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	52                   	push   %edx
  801a8b:	50                   	push   %eax
  801a8c:	6a 19                	push   $0x19
  801a8e:	e8 44 fd ff ff       	call   8017d7 <syscall>
  801a93:	83 c4 18             	add    $0x18,%esp
}
  801a96:	90                   	nop
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	83 ec 04             	sub    $0x4,%esp
  801a9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801aa5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aa8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	6a 00                	push   $0x0
  801ab1:	51                   	push   %ecx
  801ab2:	52                   	push   %edx
  801ab3:	ff 75 0c             	pushl  0xc(%ebp)
  801ab6:	50                   	push   %eax
  801ab7:	6a 1b                	push   $0x1b
  801ab9:	e8 19 fd ff ff       	call   8017d7 <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	52                   	push   %edx
  801ad3:	50                   	push   %eax
  801ad4:	6a 1c                	push   $0x1c
  801ad6:	e8 fc fc ff ff       	call   8017d7 <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ae3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ae6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	51                   	push   %ecx
  801af1:	52                   	push   %edx
  801af2:	50                   	push   %eax
  801af3:	6a 1d                	push   $0x1d
  801af5:	e8 dd fc ff ff       	call   8017d7 <syscall>
  801afa:	83 c4 18             	add    $0x18,%esp
}
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b05:	8b 45 08             	mov    0x8(%ebp),%eax
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	52                   	push   %edx
  801b0f:	50                   	push   %eax
  801b10:	6a 1e                	push   $0x1e
  801b12:	e8 c0 fc ff ff       	call   8017d7 <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
}
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 1f                	push   $0x1f
  801b2b:	e8 a7 fc ff ff       	call   8017d7 <syscall>
  801b30:	83 c4 18             	add    $0x18,%esp
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b38:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3b:	6a 00                	push   $0x0
  801b3d:	ff 75 14             	pushl  0x14(%ebp)
  801b40:	ff 75 10             	pushl  0x10(%ebp)
  801b43:	ff 75 0c             	pushl  0xc(%ebp)
  801b46:	50                   	push   %eax
  801b47:	6a 20                	push   $0x20
  801b49:	e8 89 fc ff ff       	call   8017d7 <syscall>
  801b4e:	83 c4 18             	add    $0x18,%esp
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b56:	8b 45 08             	mov    0x8(%ebp),%eax
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	50                   	push   %eax
  801b62:	6a 21                	push   $0x21
  801b64:	e8 6e fc ff ff       	call   8017d7 <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
}
  801b6c:	90                   	nop
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b72:	8b 45 08             	mov    0x8(%ebp),%eax
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	50                   	push   %eax
  801b7e:	6a 22                	push   $0x22
  801b80:	e8 52 fc ff ff       	call   8017d7 <syscall>
  801b85:	83 c4 18             	add    $0x18,%esp
}
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 02                	push   $0x2
  801b99:	e8 39 fc ff ff       	call   8017d7 <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
}
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 03                	push   $0x3
  801bb2:	e8 20 fc ff ff       	call   8017d7 <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
}
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 04                	push   $0x4
  801bcb:	e8 07 fc ff ff       	call   8017d7 <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
}
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <sys_exit_env>:


void sys_exit_env(void)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 23                	push   $0x23
  801be4:	e8 ee fb ff ff       	call   8017d7 <syscall>
  801be9:	83 c4 18             	add    $0x18,%esp
}
  801bec:	90                   	nop
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
  801bf2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bf5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bf8:	8d 50 04             	lea    0x4(%eax),%edx
  801bfb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	52                   	push   %edx
  801c05:	50                   	push   %eax
  801c06:	6a 24                	push   $0x24
  801c08:	e8 ca fb ff ff       	call   8017d7 <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
	return result;
  801c10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c13:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c16:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c19:	89 01                	mov    %eax,(%ecx)
  801c1b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c21:	c9                   	leave  
  801c22:	c2 04 00             	ret    $0x4

00801c25 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	ff 75 10             	pushl  0x10(%ebp)
  801c2f:	ff 75 0c             	pushl  0xc(%ebp)
  801c32:	ff 75 08             	pushl  0x8(%ebp)
  801c35:	6a 12                	push   $0x12
  801c37:	e8 9b fb ff ff       	call   8017d7 <syscall>
  801c3c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3f:	90                   	nop
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 25                	push   $0x25
  801c51:	e8 81 fb ff ff       	call   8017d7 <syscall>
  801c56:	83 c4 18             	add    $0x18,%esp
}
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
  801c5e:	83 ec 04             	sub    $0x4,%esp
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c67:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	50                   	push   %eax
  801c74:	6a 26                	push   $0x26
  801c76:	e8 5c fb ff ff       	call   8017d7 <syscall>
  801c7b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7e:	90                   	nop
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <rsttst>:
void rsttst()
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 28                	push   $0x28
  801c90:	e8 42 fb ff ff       	call   8017d7 <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
	return ;
  801c98:	90                   	nop
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	83 ec 04             	sub    $0x4,%esp
  801ca1:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ca7:	8b 55 18             	mov    0x18(%ebp),%edx
  801caa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cae:	52                   	push   %edx
  801caf:	50                   	push   %eax
  801cb0:	ff 75 10             	pushl  0x10(%ebp)
  801cb3:	ff 75 0c             	pushl  0xc(%ebp)
  801cb6:	ff 75 08             	pushl  0x8(%ebp)
  801cb9:	6a 27                	push   $0x27
  801cbb:	e8 17 fb ff ff       	call   8017d7 <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc3:	90                   	nop
}
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <chktst>:
void chktst(uint32 n)
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	ff 75 08             	pushl  0x8(%ebp)
  801cd4:	6a 29                	push   $0x29
  801cd6:	e8 fc fa ff ff       	call   8017d7 <syscall>
  801cdb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cde:	90                   	nop
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <inctst>:

void inctst()
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 2a                	push   $0x2a
  801cf0:	e8 e2 fa ff ff       	call   8017d7 <syscall>
  801cf5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf8:	90                   	nop
}
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <gettst>:
uint32 gettst()
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 2b                	push   $0x2b
  801d0a:	e8 c8 fa ff ff       	call   8017d7 <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 2c                	push   $0x2c
  801d26:	e8 ac fa ff ff       	call   8017d7 <syscall>
  801d2b:	83 c4 18             	add    $0x18,%esp
  801d2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d31:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d35:	75 07                	jne    801d3e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d37:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3c:	eb 05                	jmp    801d43 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
  801d48:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 2c                	push   $0x2c
  801d57:	e8 7b fa ff ff       	call   8017d7 <syscall>
  801d5c:	83 c4 18             	add    $0x18,%esp
  801d5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d62:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d66:	75 07                	jne    801d6f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d68:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6d:	eb 05                	jmp    801d74 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
  801d79:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 2c                	push   $0x2c
  801d88:	e8 4a fa ff ff       	call   8017d7 <syscall>
  801d8d:	83 c4 18             	add    $0x18,%esp
  801d90:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d93:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d97:	75 07                	jne    801da0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d99:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9e:	eb 05                	jmp    801da5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801da0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
  801daa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 2c                	push   $0x2c
  801db9:	e8 19 fa ff ff       	call   8017d7 <syscall>
  801dbe:	83 c4 18             	add    $0x18,%esp
  801dc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dc4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dc8:	75 07                	jne    801dd1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dca:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcf:	eb 05                	jmp    801dd6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dd1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd6:	c9                   	leave  
  801dd7:	c3                   	ret    

00801dd8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	ff 75 08             	pushl  0x8(%ebp)
  801de6:	6a 2d                	push   $0x2d
  801de8:	e8 ea f9 ff ff       	call   8017d7 <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
	return ;
  801df0:	90                   	nop
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801df7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dfa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e00:	8b 45 08             	mov    0x8(%ebp),%eax
  801e03:	6a 00                	push   $0x0
  801e05:	53                   	push   %ebx
  801e06:	51                   	push   %ecx
  801e07:	52                   	push   %edx
  801e08:	50                   	push   %eax
  801e09:	6a 2e                	push   $0x2e
  801e0b:	e8 c7 f9 ff ff       	call   8017d7 <syscall>
  801e10:	83 c4 18             	add    $0x18,%esp
}
  801e13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	52                   	push   %edx
  801e28:	50                   	push   %eax
  801e29:	6a 2f                	push   $0x2f
  801e2b:	e8 a7 f9 ff ff       	call   8017d7 <syscall>
  801e30:	83 c4 18             	add    $0x18,%esp
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
  801e38:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e3b:	83 ec 0c             	sub    $0xc,%esp
  801e3e:	68 20 38 80 00       	push   $0x803820
  801e43:	e8 dd e6 ff ff       	call   800525 <cprintf>
  801e48:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e4b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e52:	83 ec 0c             	sub    $0xc,%esp
  801e55:	68 4c 38 80 00       	push   $0x80384c
  801e5a:	e8 c6 e6 ff ff       	call   800525 <cprintf>
  801e5f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e62:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e66:	a1 38 41 80 00       	mov    0x804138,%eax
  801e6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e6e:	eb 56                	jmp    801ec6 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e70:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e74:	74 1c                	je     801e92 <print_mem_block_lists+0x5d>
  801e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e79:	8b 50 08             	mov    0x8(%eax),%edx
  801e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7f:	8b 48 08             	mov    0x8(%eax),%ecx
  801e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e85:	8b 40 0c             	mov    0xc(%eax),%eax
  801e88:	01 c8                	add    %ecx,%eax
  801e8a:	39 c2                	cmp    %eax,%edx
  801e8c:	73 04                	jae    801e92 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e8e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e95:	8b 50 08             	mov    0x8(%eax),%edx
  801e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e9e:	01 c2                	add    %eax,%edx
  801ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea3:	8b 40 08             	mov    0x8(%eax),%eax
  801ea6:	83 ec 04             	sub    $0x4,%esp
  801ea9:	52                   	push   %edx
  801eaa:	50                   	push   %eax
  801eab:	68 61 38 80 00       	push   $0x803861
  801eb0:	e8 70 e6 ff ff       	call   800525 <cprintf>
  801eb5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ebe:	a1 40 41 80 00       	mov    0x804140,%eax
  801ec3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ec6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eca:	74 07                	je     801ed3 <print_mem_block_lists+0x9e>
  801ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecf:	8b 00                	mov    (%eax),%eax
  801ed1:	eb 05                	jmp    801ed8 <print_mem_block_lists+0xa3>
  801ed3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed8:	a3 40 41 80 00       	mov    %eax,0x804140
  801edd:	a1 40 41 80 00       	mov    0x804140,%eax
  801ee2:	85 c0                	test   %eax,%eax
  801ee4:	75 8a                	jne    801e70 <print_mem_block_lists+0x3b>
  801ee6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eea:	75 84                	jne    801e70 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801eec:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ef0:	75 10                	jne    801f02 <print_mem_block_lists+0xcd>
  801ef2:	83 ec 0c             	sub    $0xc,%esp
  801ef5:	68 70 38 80 00       	push   $0x803870
  801efa:	e8 26 e6 ff ff       	call   800525 <cprintf>
  801eff:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f02:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f09:	83 ec 0c             	sub    $0xc,%esp
  801f0c:	68 94 38 80 00       	push   $0x803894
  801f11:	e8 0f e6 ff ff       	call   800525 <cprintf>
  801f16:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f19:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f1d:	a1 40 40 80 00       	mov    0x804040,%eax
  801f22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f25:	eb 56                	jmp    801f7d <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f2b:	74 1c                	je     801f49 <print_mem_block_lists+0x114>
  801f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f30:	8b 50 08             	mov    0x8(%eax),%edx
  801f33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f36:	8b 48 08             	mov    0x8(%eax),%ecx
  801f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f3f:	01 c8                	add    %ecx,%eax
  801f41:	39 c2                	cmp    %eax,%edx
  801f43:	73 04                	jae    801f49 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f45:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4c:	8b 50 08             	mov    0x8(%eax),%edx
  801f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f52:	8b 40 0c             	mov    0xc(%eax),%eax
  801f55:	01 c2                	add    %eax,%edx
  801f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5a:	8b 40 08             	mov    0x8(%eax),%eax
  801f5d:	83 ec 04             	sub    $0x4,%esp
  801f60:	52                   	push   %edx
  801f61:	50                   	push   %eax
  801f62:	68 61 38 80 00       	push   $0x803861
  801f67:	e8 b9 e5 ff ff       	call   800525 <cprintf>
  801f6c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f72:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f75:	a1 48 40 80 00       	mov    0x804048,%eax
  801f7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f81:	74 07                	je     801f8a <print_mem_block_lists+0x155>
  801f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f86:	8b 00                	mov    (%eax),%eax
  801f88:	eb 05                	jmp    801f8f <print_mem_block_lists+0x15a>
  801f8a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8f:	a3 48 40 80 00       	mov    %eax,0x804048
  801f94:	a1 48 40 80 00       	mov    0x804048,%eax
  801f99:	85 c0                	test   %eax,%eax
  801f9b:	75 8a                	jne    801f27 <print_mem_block_lists+0xf2>
  801f9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa1:	75 84                	jne    801f27 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fa3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fa7:	75 10                	jne    801fb9 <print_mem_block_lists+0x184>
  801fa9:	83 ec 0c             	sub    $0xc,%esp
  801fac:	68 ac 38 80 00       	push   $0x8038ac
  801fb1:	e8 6f e5 ff ff       	call   800525 <cprintf>
  801fb6:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fb9:	83 ec 0c             	sub    $0xc,%esp
  801fbc:	68 20 38 80 00       	push   $0x803820
  801fc1:	e8 5f e5 ff ff       	call   800525 <cprintf>
  801fc6:	83 c4 10             	add    $0x10,%esp

}
  801fc9:	90                   	nop
  801fca:	c9                   	leave  
  801fcb:	c3                   	ret    

00801fcc <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
  801fcf:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  801fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd5:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  801fd8:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801fdf:	00 00 00 
  801fe2:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801fe9:	00 00 00 
  801fec:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801ff3:	00 00 00 
	for(int i = 0; i<n;i++)
  801ff6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ffd:	e9 9e 00 00 00       	jmp    8020a0 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802002:	a1 50 40 80 00       	mov    0x804050,%eax
  802007:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80200a:	c1 e2 04             	shl    $0x4,%edx
  80200d:	01 d0                	add    %edx,%eax
  80200f:	85 c0                	test   %eax,%eax
  802011:	75 14                	jne    802027 <initialize_MemBlocksList+0x5b>
  802013:	83 ec 04             	sub    $0x4,%esp
  802016:	68 d4 38 80 00       	push   $0x8038d4
  80201b:	6a 47                	push   $0x47
  80201d:	68 f7 38 80 00       	push   $0x8038f7
  802022:	e8 4a e2 ff ff       	call   800271 <_panic>
  802027:	a1 50 40 80 00       	mov    0x804050,%eax
  80202c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80202f:	c1 e2 04             	shl    $0x4,%edx
  802032:	01 d0                	add    %edx,%eax
  802034:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80203a:	89 10                	mov    %edx,(%eax)
  80203c:	8b 00                	mov    (%eax),%eax
  80203e:	85 c0                	test   %eax,%eax
  802040:	74 18                	je     80205a <initialize_MemBlocksList+0x8e>
  802042:	a1 48 41 80 00       	mov    0x804148,%eax
  802047:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80204d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802050:	c1 e1 04             	shl    $0x4,%ecx
  802053:	01 ca                	add    %ecx,%edx
  802055:	89 50 04             	mov    %edx,0x4(%eax)
  802058:	eb 12                	jmp    80206c <initialize_MemBlocksList+0xa0>
  80205a:	a1 50 40 80 00       	mov    0x804050,%eax
  80205f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802062:	c1 e2 04             	shl    $0x4,%edx
  802065:	01 d0                	add    %edx,%eax
  802067:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80206c:	a1 50 40 80 00       	mov    0x804050,%eax
  802071:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802074:	c1 e2 04             	shl    $0x4,%edx
  802077:	01 d0                	add    %edx,%eax
  802079:	a3 48 41 80 00       	mov    %eax,0x804148
  80207e:	a1 50 40 80 00       	mov    0x804050,%eax
  802083:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802086:	c1 e2 04             	shl    $0x4,%edx
  802089:	01 d0                	add    %edx,%eax
  80208b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802092:	a1 54 41 80 00       	mov    0x804154,%eax
  802097:	40                   	inc    %eax
  802098:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  80209d:	ff 45 f4             	incl   -0xc(%ebp)
  8020a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8020a6:	0f 82 56 ff ff ff    	jb     802002 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8020ac:	90                   	nop
  8020ad:	c9                   	leave  
  8020ae:	c3                   	ret    

008020af <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
  8020b2:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  8020b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  8020bb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8020c2:	a1 40 40 80 00       	mov    0x804040,%eax
  8020c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020ca:	eb 23                	jmp    8020ef <find_block+0x40>
	{
		if(blk->sva == virAddress)
  8020cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020cf:	8b 40 08             	mov    0x8(%eax),%eax
  8020d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8020d5:	75 09                	jne    8020e0 <find_block+0x31>
		{
			found = 1;
  8020d7:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  8020de:	eb 35                	jmp    802115 <find_block+0x66>
		}
		else
		{
			found = 0;
  8020e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8020e7:	a1 48 40 80 00       	mov    0x804048,%eax
  8020ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020f3:	74 07                	je     8020fc <find_block+0x4d>
  8020f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020f8:	8b 00                	mov    (%eax),%eax
  8020fa:	eb 05                	jmp    802101 <find_block+0x52>
  8020fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802101:	a3 48 40 80 00       	mov    %eax,0x804048
  802106:	a1 48 40 80 00       	mov    0x804048,%eax
  80210b:	85 c0                	test   %eax,%eax
  80210d:	75 bd                	jne    8020cc <find_block+0x1d>
  80210f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802113:	75 b7                	jne    8020cc <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802115:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802119:	75 05                	jne    802120 <find_block+0x71>
	{
		return blk;
  80211b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80211e:	eb 05                	jmp    802125 <find_block+0x76>
	}
	else
	{
		return NULL;
  802120:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
  80212a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  80212d:	8b 45 08             	mov    0x8(%ebp),%eax
  802130:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802133:	a1 40 40 80 00       	mov    0x804040,%eax
  802138:	85 c0                	test   %eax,%eax
  80213a:	74 12                	je     80214e <insert_sorted_allocList+0x27>
  80213c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213f:	8b 50 08             	mov    0x8(%eax),%edx
  802142:	a1 40 40 80 00       	mov    0x804040,%eax
  802147:	8b 40 08             	mov    0x8(%eax),%eax
  80214a:	39 c2                	cmp    %eax,%edx
  80214c:	73 65                	jae    8021b3 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  80214e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802152:	75 14                	jne    802168 <insert_sorted_allocList+0x41>
  802154:	83 ec 04             	sub    $0x4,%esp
  802157:	68 d4 38 80 00       	push   $0x8038d4
  80215c:	6a 7b                	push   $0x7b
  80215e:	68 f7 38 80 00       	push   $0x8038f7
  802163:	e8 09 e1 ff ff       	call   800271 <_panic>
  802168:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80216e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802171:	89 10                	mov    %edx,(%eax)
  802173:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802176:	8b 00                	mov    (%eax),%eax
  802178:	85 c0                	test   %eax,%eax
  80217a:	74 0d                	je     802189 <insert_sorted_allocList+0x62>
  80217c:	a1 40 40 80 00       	mov    0x804040,%eax
  802181:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802184:	89 50 04             	mov    %edx,0x4(%eax)
  802187:	eb 08                	jmp    802191 <insert_sorted_allocList+0x6a>
  802189:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80218c:	a3 44 40 80 00       	mov    %eax,0x804044
  802191:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802194:	a3 40 40 80 00       	mov    %eax,0x804040
  802199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021a3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021a8:	40                   	inc    %eax
  8021a9:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8021ae:	e9 5f 01 00 00       	jmp    802312 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8021b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b6:	8b 50 08             	mov    0x8(%eax),%edx
  8021b9:	a1 44 40 80 00       	mov    0x804044,%eax
  8021be:	8b 40 08             	mov    0x8(%eax),%eax
  8021c1:	39 c2                	cmp    %eax,%edx
  8021c3:	76 65                	jbe    80222a <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  8021c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021c9:	75 14                	jne    8021df <insert_sorted_allocList+0xb8>
  8021cb:	83 ec 04             	sub    $0x4,%esp
  8021ce:	68 10 39 80 00       	push   $0x803910
  8021d3:	6a 7f                	push   $0x7f
  8021d5:	68 f7 38 80 00       	push   $0x8038f7
  8021da:	e8 92 e0 ff ff       	call   800271 <_panic>
  8021df:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e8:	89 50 04             	mov    %edx,0x4(%eax)
  8021eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ee:	8b 40 04             	mov    0x4(%eax),%eax
  8021f1:	85 c0                	test   %eax,%eax
  8021f3:	74 0c                	je     802201 <insert_sorted_allocList+0xda>
  8021f5:	a1 44 40 80 00       	mov    0x804044,%eax
  8021fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021fd:	89 10                	mov    %edx,(%eax)
  8021ff:	eb 08                	jmp    802209 <insert_sorted_allocList+0xe2>
  802201:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802204:	a3 40 40 80 00       	mov    %eax,0x804040
  802209:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220c:	a3 44 40 80 00       	mov    %eax,0x804044
  802211:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802214:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80221a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80221f:	40                   	inc    %eax
  802220:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802225:	e9 e8 00 00 00       	jmp    802312 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  80222a:	a1 40 40 80 00       	mov    0x804040,%eax
  80222f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802232:	e9 ab 00 00 00       	jmp    8022e2 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223a:	8b 00                	mov    (%eax),%eax
  80223c:	85 c0                	test   %eax,%eax
  80223e:	0f 84 96 00 00 00    	je     8022da <insert_sorted_allocList+0x1b3>
  802244:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802247:	8b 50 08             	mov    0x8(%eax),%edx
  80224a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224d:	8b 40 08             	mov    0x8(%eax),%eax
  802250:	39 c2                	cmp    %eax,%edx
  802252:	0f 86 82 00 00 00    	jbe    8022da <insert_sorted_allocList+0x1b3>
  802258:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225b:	8b 50 08             	mov    0x8(%eax),%edx
  80225e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802261:	8b 00                	mov    (%eax),%eax
  802263:	8b 40 08             	mov    0x8(%eax),%eax
  802266:	39 c2                	cmp    %eax,%edx
  802268:	73 70                	jae    8022da <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  80226a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80226e:	74 06                	je     802276 <insert_sorted_allocList+0x14f>
  802270:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802274:	75 17                	jne    80228d <insert_sorted_allocList+0x166>
  802276:	83 ec 04             	sub    $0x4,%esp
  802279:	68 34 39 80 00       	push   $0x803934
  80227e:	68 87 00 00 00       	push   $0x87
  802283:	68 f7 38 80 00       	push   $0x8038f7
  802288:	e8 e4 df ff ff       	call   800271 <_panic>
  80228d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802290:	8b 10                	mov    (%eax),%edx
  802292:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802295:	89 10                	mov    %edx,(%eax)
  802297:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229a:	8b 00                	mov    (%eax),%eax
  80229c:	85 c0                	test   %eax,%eax
  80229e:	74 0b                	je     8022ab <insert_sorted_allocList+0x184>
  8022a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a3:	8b 00                	mov    (%eax),%eax
  8022a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022a8:	89 50 04             	mov    %edx,0x4(%eax)
  8022ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022b1:	89 10                	mov    %edx,(%eax)
  8022b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b9:	89 50 04             	mov    %edx,0x4(%eax)
  8022bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022bf:	8b 00                	mov    (%eax),%eax
  8022c1:	85 c0                	test   %eax,%eax
  8022c3:	75 08                	jne    8022cd <insert_sorted_allocList+0x1a6>
  8022c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c8:	a3 44 40 80 00       	mov    %eax,0x804044
  8022cd:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022d2:	40                   	inc    %eax
  8022d3:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8022d8:	eb 38                	jmp    802312 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8022da:	a1 48 40 80 00       	mov    0x804048,%eax
  8022df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e6:	74 07                	je     8022ef <insert_sorted_allocList+0x1c8>
  8022e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022eb:	8b 00                	mov    (%eax),%eax
  8022ed:	eb 05                	jmp    8022f4 <insert_sorted_allocList+0x1cd>
  8022ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f4:	a3 48 40 80 00       	mov    %eax,0x804048
  8022f9:	a1 48 40 80 00       	mov    0x804048,%eax
  8022fe:	85 c0                	test   %eax,%eax
  802300:	0f 85 31 ff ff ff    	jne    802237 <insert_sorted_allocList+0x110>
  802306:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80230a:	0f 85 27 ff ff ff    	jne    802237 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802310:	eb 00                	jmp    802312 <insert_sorted_allocList+0x1eb>
  802312:	90                   	nop
  802313:	c9                   	leave  
  802314:	c3                   	ret    

00802315 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
  802318:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802321:	a1 48 41 80 00       	mov    0x804148,%eax
  802326:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802329:	a1 38 41 80 00       	mov    0x804138,%eax
  80232e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802331:	e9 77 01 00 00       	jmp    8024ad <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802339:	8b 40 0c             	mov    0xc(%eax),%eax
  80233c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80233f:	0f 85 8a 00 00 00    	jne    8023cf <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802345:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802349:	75 17                	jne    802362 <alloc_block_FF+0x4d>
  80234b:	83 ec 04             	sub    $0x4,%esp
  80234e:	68 68 39 80 00       	push   $0x803968
  802353:	68 9e 00 00 00       	push   $0x9e
  802358:	68 f7 38 80 00       	push   $0x8038f7
  80235d:	e8 0f df ff ff       	call   800271 <_panic>
  802362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802365:	8b 00                	mov    (%eax),%eax
  802367:	85 c0                	test   %eax,%eax
  802369:	74 10                	je     80237b <alloc_block_FF+0x66>
  80236b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236e:	8b 00                	mov    (%eax),%eax
  802370:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802373:	8b 52 04             	mov    0x4(%edx),%edx
  802376:	89 50 04             	mov    %edx,0x4(%eax)
  802379:	eb 0b                	jmp    802386 <alloc_block_FF+0x71>
  80237b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237e:	8b 40 04             	mov    0x4(%eax),%eax
  802381:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802389:	8b 40 04             	mov    0x4(%eax),%eax
  80238c:	85 c0                	test   %eax,%eax
  80238e:	74 0f                	je     80239f <alloc_block_FF+0x8a>
  802390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802393:	8b 40 04             	mov    0x4(%eax),%eax
  802396:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802399:	8b 12                	mov    (%edx),%edx
  80239b:	89 10                	mov    %edx,(%eax)
  80239d:	eb 0a                	jmp    8023a9 <alloc_block_FF+0x94>
  80239f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a2:	8b 00                	mov    (%eax),%eax
  8023a4:	a3 38 41 80 00       	mov    %eax,0x804138
  8023a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023bc:	a1 44 41 80 00       	mov    0x804144,%eax
  8023c1:	48                   	dec    %eax
  8023c2:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ca:	e9 11 01 00 00       	jmp    8024e0 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  8023cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8023d8:	0f 86 c7 00 00 00    	jbe    8024a5 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8023de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023e2:	75 17                	jne    8023fb <alloc_block_FF+0xe6>
  8023e4:	83 ec 04             	sub    $0x4,%esp
  8023e7:	68 68 39 80 00       	push   $0x803968
  8023ec:	68 a3 00 00 00       	push   $0xa3
  8023f1:	68 f7 38 80 00       	push   $0x8038f7
  8023f6:	e8 76 de ff ff       	call   800271 <_panic>
  8023fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023fe:	8b 00                	mov    (%eax),%eax
  802400:	85 c0                	test   %eax,%eax
  802402:	74 10                	je     802414 <alloc_block_FF+0xff>
  802404:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802407:	8b 00                	mov    (%eax),%eax
  802409:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80240c:	8b 52 04             	mov    0x4(%edx),%edx
  80240f:	89 50 04             	mov    %edx,0x4(%eax)
  802412:	eb 0b                	jmp    80241f <alloc_block_FF+0x10a>
  802414:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802417:	8b 40 04             	mov    0x4(%eax),%eax
  80241a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80241f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802422:	8b 40 04             	mov    0x4(%eax),%eax
  802425:	85 c0                	test   %eax,%eax
  802427:	74 0f                	je     802438 <alloc_block_FF+0x123>
  802429:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80242c:	8b 40 04             	mov    0x4(%eax),%eax
  80242f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802432:	8b 12                	mov    (%edx),%edx
  802434:	89 10                	mov    %edx,(%eax)
  802436:	eb 0a                	jmp    802442 <alloc_block_FF+0x12d>
  802438:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80243b:	8b 00                	mov    (%eax),%eax
  80243d:	a3 48 41 80 00       	mov    %eax,0x804148
  802442:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802445:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80244b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80244e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802455:	a1 54 41 80 00       	mov    0x804154,%eax
  80245a:	48                   	dec    %eax
  80245b:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802460:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802463:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802466:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246c:	8b 40 0c             	mov    0xc(%eax),%eax
  80246f:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802472:	89 c2                	mov    %eax,%edx
  802474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802477:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  80247a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247d:	8b 40 08             	mov    0x8(%eax),%eax
  802480:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802486:	8b 50 08             	mov    0x8(%eax),%edx
  802489:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80248c:	8b 40 0c             	mov    0xc(%eax),%eax
  80248f:	01 c2                	add    %eax,%edx
  802491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802494:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802497:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80249a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80249d:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8024a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a3:	eb 3b                	jmp    8024e0 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8024a5:	a1 40 41 80 00       	mov    0x804140,%eax
  8024aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b1:	74 07                	je     8024ba <alloc_block_FF+0x1a5>
  8024b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b6:	8b 00                	mov    (%eax),%eax
  8024b8:	eb 05                	jmp    8024bf <alloc_block_FF+0x1aa>
  8024ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bf:	a3 40 41 80 00       	mov    %eax,0x804140
  8024c4:	a1 40 41 80 00       	mov    0x804140,%eax
  8024c9:	85 c0                	test   %eax,%eax
  8024cb:	0f 85 65 fe ff ff    	jne    802336 <alloc_block_FF+0x21>
  8024d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d5:	0f 85 5b fe ff ff    	jne    802336 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8024db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e0:	c9                   	leave  
  8024e1:	c3                   	ret    

008024e2 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024e2:	55                   	push   %ebp
  8024e3:	89 e5                	mov    %esp,%ebp
  8024e5:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  8024e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  8024ee:	a1 48 41 80 00       	mov    0x804148,%eax
  8024f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  8024f6:	a1 44 41 80 00       	mov    0x804144,%eax
  8024fb:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024fe:	a1 38 41 80 00       	mov    0x804138,%eax
  802503:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802506:	e9 a1 00 00 00       	jmp    8025ac <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  80250b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250e:	8b 40 0c             	mov    0xc(%eax),%eax
  802511:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802514:	0f 85 8a 00 00 00    	jne    8025a4 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  80251a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251e:	75 17                	jne    802537 <alloc_block_BF+0x55>
  802520:	83 ec 04             	sub    $0x4,%esp
  802523:	68 68 39 80 00       	push   $0x803968
  802528:	68 c2 00 00 00       	push   $0xc2
  80252d:	68 f7 38 80 00       	push   $0x8038f7
  802532:	e8 3a dd ff ff       	call   800271 <_panic>
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	8b 00                	mov    (%eax),%eax
  80253c:	85 c0                	test   %eax,%eax
  80253e:	74 10                	je     802550 <alloc_block_BF+0x6e>
  802540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802543:	8b 00                	mov    (%eax),%eax
  802545:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802548:	8b 52 04             	mov    0x4(%edx),%edx
  80254b:	89 50 04             	mov    %edx,0x4(%eax)
  80254e:	eb 0b                	jmp    80255b <alloc_block_BF+0x79>
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	8b 40 04             	mov    0x4(%eax),%eax
  802556:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80255b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255e:	8b 40 04             	mov    0x4(%eax),%eax
  802561:	85 c0                	test   %eax,%eax
  802563:	74 0f                	je     802574 <alloc_block_BF+0x92>
  802565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802568:	8b 40 04             	mov    0x4(%eax),%eax
  80256b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256e:	8b 12                	mov    (%edx),%edx
  802570:	89 10                	mov    %edx,(%eax)
  802572:	eb 0a                	jmp    80257e <alloc_block_BF+0x9c>
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	8b 00                	mov    (%eax),%eax
  802579:	a3 38 41 80 00       	mov    %eax,0x804138
  80257e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802581:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802591:	a1 44 41 80 00       	mov    0x804144,%eax
  802596:	48                   	dec    %eax
  802597:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	e9 11 02 00 00       	jmp    8027b5 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025a4:	a1 40 41 80 00       	mov    0x804140,%eax
  8025a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b0:	74 07                	je     8025b9 <alloc_block_BF+0xd7>
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	8b 00                	mov    (%eax),%eax
  8025b7:	eb 05                	jmp    8025be <alloc_block_BF+0xdc>
  8025b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025be:	a3 40 41 80 00       	mov    %eax,0x804140
  8025c3:	a1 40 41 80 00       	mov    0x804140,%eax
  8025c8:	85 c0                	test   %eax,%eax
  8025ca:	0f 85 3b ff ff ff    	jne    80250b <alloc_block_BF+0x29>
  8025d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d4:	0f 85 31 ff ff ff    	jne    80250b <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025da:	a1 38 41 80 00       	mov    0x804138,%eax
  8025df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e2:	eb 27                	jmp    80260b <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  8025e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ea:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8025ed:	76 14                	jbe    802603 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  8025ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	8b 40 08             	mov    0x8(%eax),%eax
  8025fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802601:	eb 2e                	jmp    802631 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802603:	a1 40 41 80 00       	mov    0x804140,%eax
  802608:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80260b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260f:	74 07                	je     802618 <alloc_block_BF+0x136>
  802611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802614:	8b 00                	mov    (%eax),%eax
  802616:	eb 05                	jmp    80261d <alloc_block_BF+0x13b>
  802618:	b8 00 00 00 00       	mov    $0x0,%eax
  80261d:	a3 40 41 80 00       	mov    %eax,0x804140
  802622:	a1 40 41 80 00       	mov    0x804140,%eax
  802627:	85 c0                	test   %eax,%eax
  802629:	75 b9                	jne    8025e4 <alloc_block_BF+0x102>
  80262b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262f:	75 b3                	jne    8025e4 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802631:	a1 38 41 80 00       	mov    0x804138,%eax
  802636:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802639:	eb 30                	jmp    80266b <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  80263b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263e:	8b 40 0c             	mov    0xc(%eax),%eax
  802641:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802644:	73 1d                	jae    802663 <alloc_block_BF+0x181>
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	8b 40 0c             	mov    0xc(%eax),%eax
  80264c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80264f:	76 12                	jbe    802663 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	8b 40 0c             	mov    0xc(%eax),%eax
  802657:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	8b 40 08             	mov    0x8(%eax),%eax
  802660:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802663:	a1 40 41 80 00       	mov    0x804140,%eax
  802668:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266f:	74 07                	je     802678 <alloc_block_BF+0x196>
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	8b 00                	mov    (%eax),%eax
  802676:	eb 05                	jmp    80267d <alloc_block_BF+0x19b>
  802678:	b8 00 00 00 00       	mov    $0x0,%eax
  80267d:	a3 40 41 80 00       	mov    %eax,0x804140
  802682:	a1 40 41 80 00       	mov    0x804140,%eax
  802687:	85 c0                	test   %eax,%eax
  802689:	75 b0                	jne    80263b <alloc_block_BF+0x159>
  80268b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80268f:	75 aa                	jne    80263b <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802691:	a1 38 41 80 00       	mov    0x804138,%eax
  802696:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802699:	e9 e4 00 00 00       	jmp    802782 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8026a7:	0f 85 cd 00 00 00    	jne    80277a <alloc_block_BF+0x298>
  8026ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b0:	8b 40 08             	mov    0x8(%eax),%eax
  8026b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026b6:	0f 85 be 00 00 00    	jne    80277a <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  8026bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026c0:	75 17                	jne    8026d9 <alloc_block_BF+0x1f7>
  8026c2:	83 ec 04             	sub    $0x4,%esp
  8026c5:	68 68 39 80 00       	push   $0x803968
  8026ca:	68 db 00 00 00       	push   $0xdb
  8026cf:	68 f7 38 80 00       	push   $0x8038f7
  8026d4:	e8 98 db ff ff       	call   800271 <_panic>
  8026d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026dc:	8b 00                	mov    (%eax),%eax
  8026de:	85 c0                	test   %eax,%eax
  8026e0:	74 10                	je     8026f2 <alloc_block_BF+0x210>
  8026e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e5:	8b 00                	mov    (%eax),%eax
  8026e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026ea:	8b 52 04             	mov    0x4(%edx),%edx
  8026ed:	89 50 04             	mov    %edx,0x4(%eax)
  8026f0:	eb 0b                	jmp    8026fd <alloc_block_BF+0x21b>
  8026f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f5:	8b 40 04             	mov    0x4(%eax),%eax
  8026f8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802700:	8b 40 04             	mov    0x4(%eax),%eax
  802703:	85 c0                	test   %eax,%eax
  802705:	74 0f                	je     802716 <alloc_block_BF+0x234>
  802707:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80270a:	8b 40 04             	mov    0x4(%eax),%eax
  80270d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802710:	8b 12                	mov    (%edx),%edx
  802712:	89 10                	mov    %edx,(%eax)
  802714:	eb 0a                	jmp    802720 <alloc_block_BF+0x23e>
  802716:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802719:	8b 00                	mov    (%eax),%eax
  80271b:	a3 48 41 80 00       	mov    %eax,0x804148
  802720:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802723:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802729:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80272c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802733:	a1 54 41 80 00       	mov    0x804154,%eax
  802738:	48                   	dec    %eax
  802739:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  80273e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802741:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802744:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802747:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80274a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80274d:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802753:	8b 40 0c             	mov    0xc(%eax),%eax
  802756:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802759:	89 c2                	mov    %eax,%edx
  80275b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275e:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802764:	8b 50 08             	mov    0x8(%eax),%edx
  802767:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80276a:	8b 40 0c             	mov    0xc(%eax),%eax
  80276d:	01 c2                	add    %eax,%edx
  80276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802772:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802775:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802778:	eb 3b                	jmp    8027b5 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80277a:	a1 40 41 80 00       	mov    0x804140,%eax
  80277f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802782:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802786:	74 07                	je     80278f <alloc_block_BF+0x2ad>
  802788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278b:	8b 00                	mov    (%eax),%eax
  80278d:	eb 05                	jmp    802794 <alloc_block_BF+0x2b2>
  80278f:	b8 00 00 00 00       	mov    $0x0,%eax
  802794:	a3 40 41 80 00       	mov    %eax,0x804140
  802799:	a1 40 41 80 00       	mov    0x804140,%eax
  80279e:	85 c0                	test   %eax,%eax
  8027a0:	0f 85 f8 fe ff ff    	jne    80269e <alloc_block_BF+0x1bc>
  8027a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027aa:	0f 85 ee fe ff ff    	jne    80269e <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  8027b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027b5:	c9                   	leave  
  8027b6:	c3                   	ret    

008027b7 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027b7:	55                   	push   %ebp
  8027b8:	89 e5                	mov    %esp,%ebp
  8027ba:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  8027bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8027c3:	a1 48 41 80 00       	mov    0x804148,%eax
  8027c8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8027cb:	a1 38 41 80 00       	mov    0x804138,%eax
  8027d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d3:	e9 77 01 00 00       	jmp    80294f <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	8b 40 0c             	mov    0xc(%eax),%eax
  8027de:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027e1:	0f 85 8a 00 00 00    	jne    802871 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8027e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027eb:	75 17                	jne    802804 <alloc_block_NF+0x4d>
  8027ed:	83 ec 04             	sub    $0x4,%esp
  8027f0:	68 68 39 80 00       	push   $0x803968
  8027f5:	68 f7 00 00 00       	push   $0xf7
  8027fa:	68 f7 38 80 00       	push   $0x8038f7
  8027ff:	e8 6d da ff ff       	call   800271 <_panic>
  802804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802807:	8b 00                	mov    (%eax),%eax
  802809:	85 c0                	test   %eax,%eax
  80280b:	74 10                	je     80281d <alloc_block_NF+0x66>
  80280d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802810:	8b 00                	mov    (%eax),%eax
  802812:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802815:	8b 52 04             	mov    0x4(%edx),%edx
  802818:	89 50 04             	mov    %edx,0x4(%eax)
  80281b:	eb 0b                	jmp    802828 <alloc_block_NF+0x71>
  80281d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802820:	8b 40 04             	mov    0x4(%eax),%eax
  802823:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282b:	8b 40 04             	mov    0x4(%eax),%eax
  80282e:	85 c0                	test   %eax,%eax
  802830:	74 0f                	je     802841 <alloc_block_NF+0x8a>
  802832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802835:	8b 40 04             	mov    0x4(%eax),%eax
  802838:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80283b:	8b 12                	mov    (%edx),%edx
  80283d:	89 10                	mov    %edx,(%eax)
  80283f:	eb 0a                	jmp    80284b <alloc_block_NF+0x94>
  802841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802844:	8b 00                	mov    (%eax),%eax
  802846:	a3 38 41 80 00       	mov    %eax,0x804138
  80284b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802857:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80285e:	a1 44 41 80 00       	mov    0x804144,%eax
  802863:	48                   	dec    %eax
  802864:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286c:	e9 11 01 00 00       	jmp    802982 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802874:	8b 40 0c             	mov    0xc(%eax),%eax
  802877:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80287a:	0f 86 c7 00 00 00    	jbe    802947 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802880:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802884:	75 17                	jne    80289d <alloc_block_NF+0xe6>
  802886:	83 ec 04             	sub    $0x4,%esp
  802889:	68 68 39 80 00       	push   $0x803968
  80288e:	68 fc 00 00 00       	push   $0xfc
  802893:	68 f7 38 80 00       	push   $0x8038f7
  802898:	e8 d4 d9 ff ff       	call   800271 <_panic>
  80289d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a0:	8b 00                	mov    (%eax),%eax
  8028a2:	85 c0                	test   %eax,%eax
  8028a4:	74 10                	je     8028b6 <alloc_block_NF+0xff>
  8028a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a9:	8b 00                	mov    (%eax),%eax
  8028ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028ae:	8b 52 04             	mov    0x4(%edx),%edx
  8028b1:	89 50 04             	mov    %edx,0x4(%eax)
  8028b4:	eb 0b                	jmp    8028c1 <alloc_block_NF+0x10a>
  8028b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b9:	8b 40 04             	mov    0x4(%eax),%eax
  8028bc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c4:	8b 40 04             	mov    0x4(%eax),%eax
  8028c7:	85 c0                	test   %eax,%eax
  8028c9:	74 0f                	je     8028da <alloc_block_NF+0x123>
  8028cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ce:	8b 40 04             	mov    0x4(%eax),%eax
  8028d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028d4:	8b 12                	mov    (%edx),%edx
  8028d6:	89 10                	mov    %edx,(%eax)
  8028d8:	eb 0a                	jmp    8028e4 <alloc_block_NF+0x12d>
  8028da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028dd:	8b 00                	mov    (%eax),%eax
  8028df:	a3 48 41 80 00       	mov    %eax,0x804148
  8028e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f7:	a1 54 41 80 00       	mov    0x804154,%eax
  8028fc:	48                   	dec    %eax
  8028fd:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802902:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802905:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802908:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  80290b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290e:	8b 40 0c             	mov    0xc(%eax),%eax
  802911:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802914:	89 c2                	mov    %eax,%edx
  802916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802919:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  80291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291f:	8b 40 08             	mov    0x8(%eax),%eax
  802922:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802928:	8b 50 08             	mov    0x8(%eax),%edx
  80292b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292e:	8b 40 0c             	mov    0xc(%eax),%eax
  802931:	01 c2                	add    %eax,%edx
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802939:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80293f:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802942:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802945:	eb 3b                	jmp    802982 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802947:	a1 40 41 80 00       	mov    0x804140,%eax
  80294c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80294f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802953:	74 07                	je     80295c <alloc_block_NF+0x1a5>
  802955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802958:	8b 00                	mov    (%eax),%eax
  80295a:	eb 05                	jmp    802961 <alloc_block_NF+0x1aa>
  80295c:	b8 00 00 00 00       	mov    $0x0,%eax
  802961:	a3 40 41 80 00       	mov    %eax,0x804140
  802966:	a1 40 41 80 00       	mov    0x804140,%eax
  80296b:	85 c0                	test   %eax,%eax
  80296d:	0f 85 65 fe ff ff    	jne    8027d8 <alloc_block_NF+0x21>
  802973:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802977:	0f 85 5b fe ff ff    	jne    8027d8 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  80297d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802982:	c9                   	leave  
  802983:	c3                   	ret    

00802984 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802984:	55                   	push   %ebp
  802985:	89 e5                	mov    %esp,%ebp
  802987:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  80298a:	8b 45 08             	mov    0x8(%ebp),%eax
  80298d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802994:	8b 45 08             	mov    0x8(%ebp),%eax
  802997:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  80299e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029a2:	75 17                	jne    8029bb <addToAvailMemBlocksList+0x37>
  8029a4:	83 ec 04             	sub    $0x4,%esp
  8029a7:	68 10 39 80 00       	push   $0x803910
  8029ac:	68 10 01 00 00       	push   $0x110
  8029b1:	68 f7 38 80 00       	push   $0x8038f7
  8029b6:	e8 b6 d8 ff ff       	call   800271 <_panic>
  8029bb:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  8029c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c4:	89 50 04             	mov    %edx,0x4(%eax)
  8029c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ca:	8b 40 04             	mov    0x4(%eax),%eax
  8029cd:	85 c0                	test   %eax,%eax
  8029cf:	74 0c                	je     8029dd <addToAvailMemBlocksList+0x59>
  8029d1:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8029d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8029d9:	89 10                	mov    %edx,(%eax)
  8029db:	eb 08                	jmp    8029e5 <addToAvailMemBlocksList+0x61>
  8029dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e0:	a3 48 41 80 00       	mov    %eax,0x804148
  8029e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029f6:	a1 54 41 80 00       	mov    0x804154,%eax
  8029fb:	40                   	inc    %eax
  8029fc:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802a01:	90                   	nop
  802a02:	c9                   	leave  
  802a03:	c3                   	ret    

00802a04 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a04:	55                   	push   %ebp
  802a05:	89 e5                	mov    %esp,%ebp
  802a07:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802a0a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802a12:	a1 44 41 80 00       	mov    0x804144,%eax
  802a17:	85 c0                	test   %eax,%eax
  802a19:	75 68                	jne    802a83 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802a1b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a1f:	75 17                	jne    802a38 <insert_sorted_with_merge_freeList+0x34>
  802a21:	83 ec 04             	sub    $0x4,%esp
  802a24:	68 d4 38 80 00       	push   $0x8038d4
  802a29:	68 1a 01 00 00       	push   $0x11a
  802a2e:	68 f7 38 80 00       	push   $0x8038f7
  802a33:	e8 39 d8 ff ff       	call   800271 <_panic>
  802a38:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a41:	89 10                	mov    %edx,(%eax)
  802a43:	8b 45 08             	mov    0x8(%ebp),%eax
  802a46:	8b 00                	mov    (%eax),%eax
  802a48:	85 c0                	test   %eax,%eax
  802a4a:	74 0d                	je     802a59 <insert_sorted_with_merge_freeList+0x55>
  802a4c:	a1 38 41 80 00       	mov    0x804138,%eax
  802a51:	8b 55 08             	mov    0x8(%ebp),%edx
  802a54:	89 50 04             	mov    %edx,0x4(%eax)
  802a57:	eb 08                	jmp    802a61 <insert_sorted_with_merge_freeList+0x5d>
  802a59:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a61:	8b 45 08             	mov    0x8(%ebp),%eax
  802a64:	a3 38 41 80 00       	mov    %eax,0x804138
  802a69:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a73:	a1 44 41 80 00       	mov    0x804144,%eax
  802a78:	40                   	inc    %eax
  802a79:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802a7e:	e9 c5 03 00 00       	jmp    802e48 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a86:	8b 50 08             	mov    0x8(%eax),%edx
  802a89:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8c:	8b 40 08             	mov    0x8(%eax),%eax
  802a8f:	39 c2                	cmp    %eax,%edx
  802a91:	0f 83 b2 00 00 00    	jae    802b49 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9a:	8b 50 08             	mov    0x8(%eax),%edx
  802a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa0:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa3:	01 c2                	add    %eax,%edx
  802aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa8:	8b 40 08             	mov    0x8(%eax),%eax
  802aab:	39 c2                	cmp    %eax,%edx
  802aad:	75 27                	jne    802ad6 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802aaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab2:	8b 50 0c             	mov    0xc(%eax),%edx
  802ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab8:	8b 40 0c             	mov    0xc(%eax),%eax
  802abb:	01 c2                	add    %eax,%edx
  802abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac0:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802ac3:	83 ec 0c             	sub    $0xc,%esp
  802ac6:	ff 75 08             	pushl  0x8(%ebp)
  802ac9:	e8 b6 fe ff ff       	call   802984 <addToAvailMemBlocksList>
  802ace:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ad1:	e9 72 03 00 00       	jmp    802e48 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802ad6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ada:	74 06                	je     802ae2 <insert_sorted_with_merge_freeList+0xde>
  802adc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ae0:	75 17                	jne    802af9 <insert_sorted_with_merge_freeList+0xf5>
  802ae2:	83 ec 04             	sub    $0x4,%esp
  802ae5:	68 34 39 80 00       	push   $0x803934
  802aea:	68 24 01 00 00       	push   $0x124
  802aef:	68 f7 38 80 00       	push   $0x8038f7
  802af4:	e8 78 d7 ff ff       	call   800271 <_panic>
  802af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afc:	8b 10                	mov    (%eax),%edx
  802afe:	8b 45 08             	mov    0x8(%ebp),%eax
  802b01:	89 10                	mov    %edx,(%eax)
  802b03:	8b 45 08             	mov    0x8(%ebp),%eax
  802b06:	8b 00                	mov    (%eax),%eax
  802b08:	85 c0                	test   %eax,%eax
  802b0a:	74 0b                	je     802b17 <insert_sorted_with_merge_freeList+0x113>
  802b0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0f:	8b 00                	mov    (%eax),%eax
  802b11:	8b 55 08             	mov    0x8(%ebp),%edx
  802b14:	89 50 04             	mov    %edx,0x4(%eax)
  802b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b1d:	89 10                	mov    %edx,(%eax)
  802b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b22:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b25:	89 50 04             	mov    %edx,0x4(%eax)
  802b28:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2b:	8b 00                	mov    (%eax),%eax
  802b2d:	85 c0                	test   %eax,%eax
  802b2f:	75 08                	jne    802b39 <insert_sorted_with_merge_freeList+0x135>
  802b31:	8b 45 08             	mov    0x8(%ebp),%eax
  802b34:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b39:	a1 44 41 80 00       	mov    0x804144,%eax
  802b3e:	40                   	inc    %eax
  802b3f:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802b44:	e9 ff 02 00 00       	jmp    802e48 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802b49:	a1 38 41 80 00       	mov    0x804138,%eax
  802b4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b51:	e9 c2 02 00 00       	jmp    802e18 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b59:	8b 50 08             	mov    0x8(%eax),%edx
  802b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5f:	8b 40 08             	mov    0x8(%eax),%eax
  802b62:	39 c2                	cmp    %eax,%edx
  802b64:	0f 86 a6 02 00 00    	jbe    802e10 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6d:	8b 40 04             	mov    0x4(%eax),%eax
  802b70:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802b73:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b77:	0f 85 ba 00 00 00    	jne    802c37 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b80:	8b 50 0c             	mov    0xc(%eax),%edx
  802b83:	8b 45 08             	mov    0x8(%ebp),%eax
  802b86:	8b 40 08             	mov    0x8(%eax),%eax
  802b89:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802b91:	39 c2                	cmp    %eax,%edx
  802b93:	75 33                	jne    802bc8 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802b95:	8b 45 08             	mov    0x8(%ebp),%eax
  802b98:	8b 50 08             	mov    0x8(%eax),%edx
  802b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9e:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba4:	8b 50 0c             	mov    0xc(%eax),%edx
  802ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  802baa:	8b 40 0c             	mov    0xc(%eax),%eax
  802bad:	01 c2                	add    %eax,%edx
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802bb5:	83 ec 0c             	sub    $0xc,%esp
  802bb8:	ff 75 08             	pushl  0x8(%ebp)
  802bbb:	e8 c4 fd ff ff       	call   802984 <addToAvailMemBlocksList>
  802bc0:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802bc3:	e9 80 02 00 00       	jmp    802e48 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802bc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bcc:	74 06                	je     802bd4 <insert_sorted_with_merge_freeList+0x1d0>
  802bce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bd2:	75 17                	jne    802beb <insert_sorted_with_merge_freeList+0x1e7>
  802bd4:	83 ec 04             	sub    $0x4,%esp
  802bd7:	68 88 39 80 00       	push   $0x803988
  802bdc:	68 3a 01 00 00       	push   $0x13a
  802be1:	68 f7 38 80 00       	push   $0x8038f7
  802be6:	e8 86 d6 ff ff       	call   800271 <_panic>
  802beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bee:	8b 50 04             	mov    0x4(%eax),%edx
  802bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf4:	89 50 04             	mov    %edx,0x4(%eax)
  802bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bfd:	89 10                	mov    %edx,(%eax)
  802bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c02:	8b 40 04             	mov    0x4(%eax),%eax
  802c05:	85 c0                	test   %eax,%eax
  802c07:	74 0d                	je     802c16 <insert_sorted_with_merge_freeList+0x212>
  802c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0c:	8b 40 04             	mov    0x4(%eax),%eax
  802c0f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c12:	89 10                	mov    %edx,(%eax)
  802c14:	eb 08                	jmp    802c1e <insert_sorted_with_merge_freeList+0x21a>
  802c16:	8b 45 08             	mov    0x8(%ebp),%eax
  802c19:	a3 38 41 80 00       	mov    %eax,0x804138
  802c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c21:	8b 55 08             	mov    0x8(%ebp),%edx
  802c24:	89 50 04             	mov    %edx,0x4(%eax)
  802c27:	a1 44 41 80 00       	mov    0x804144,%eax
  802c2c:	40                   	inc    %eax
  802c2d:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802c32:	e9 11 02 00 00       	jmp    802e48 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802c37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3a:	8b 50 08             	mov    0x8(%eax),%edx
  802c3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c40:	8b 40 0c             	mov    0xc(%eax),%eax
  802c43:	01 c2                	add    %eax,%edx
  802c45:	8b 45 08             	mov    0x8(%ebp),%eax
  802c48:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4b:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802c53:	39 c2                	cmp    %eax,%edx
  802c55:	0f 85 bf 00 00 00    	jne    802d1a <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802c5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5e:	8b 50 0c             	mov    0xc(%eax),%edx
  802c61:	8b 45 08             	mov    0x8(%ebp),%eax
  802c64:	8b 40 0c             	mov    0xc(%eax),%eax
  802c67:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6f:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802c71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c74:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802c77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c7b:	75 17                	jne    802c94 <insert_sorted_with_merge_freeList+0x290>
  802c7d:	83 ec 04             	sub    $0x4,%esp
  802c80:	68 68 39 80 00       	push   $0x803968
  802c85:	68 43 01 00 00       	push   $0x143
  802c8a:	68 f7 38 80 00       	push   $0x8038f7
  802c8f:	e8 dd d5 ff ff       	call   800271 <_panic>
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	8b 00                	mov    (%eax),%eax
  802c99:	85 c0                	test   %eax,%eax
  802c9b:	74 10                	je     802cad <insert_sorted_with_merge_freeList+0x2a9>
  802c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca0:	8b 00                	mov    (%eax),%eax
  802ca2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ca5:	8b 52 04             	mov    0x4(%edx),%edx
  802ca8:	89 50 04             	mov    %edx,0x4(%eax)
  802cab:	eb 0b                	jmp    802cb8 <insert_sorted_with_merge_freeList+0x2b4>
  802cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb0:	8b 40 04             	mov    0x4(%eax),%eax
  802cb3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbb:	8b 40 04             	mov    0x4(%eax),%eax
  802cbe:	85 c0                	test   %eax,%eax
  802cc0:	74 0f                	je     802cd1 <insert_sorted_with_merge_freeList+0x2cd>
  802cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc5:	8b 40 04             	mov    0x4(%eax),%eax
  802cc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ccb:	8b 12                	mov    (%edx),%edx
  802ccd:	89 10                	mov    %edx,(%eax)
  802ccf:	eb 0a                	jmp    802cdb <insert_sorted_with_merge_freeList+0x2d7>
  802cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd4:	8b 00                	mov    (%eax),%eax
  802cd6:	a3 38 41 80 00       	mov    %eax,0x804138
  802cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cee:	a1 44 41 80 00       	mov    0x804144,%eax
  802cf3:	48                   	dec    %eax
  802cf4:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802cf9:	83 ec 0c             	sub    $0xc,%esp
  802cfc:	ff 75 08             	pushl  0x8(%ebp)
  802cff:	e8 80 fc ff ff       	call   802984 <addToAvailMemBlocksList>
  802d04:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802d07:	83 ec 0c             	sub    $0xc,%esp
  802d0a:	ff 75 f4             	pushl  -0xc(%ebp)
  802d0d:	e8 72 fc ff ff       	call   802984 <addToAvailMemBlocksList>
  802d12:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802d15:	e9 2e 01 00 00       	jmp    802e48 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802d1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1d:	8b 50 08             	mov    0x8(%eax),%edx
  802d20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d23:	8b 40 0c             	mov    0xc(%eax),%eax
  802d26:	01 c2                	add    %eax,%edx
  802d28:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2b:	8b 40 08             	mov    0x8(%eax),%eax
  802d2e:	39 c2                	cmp    %eax,%edx
  802d30:	75 27                	jne    802d59 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802d32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d35:	8b 50 0c             	mov    0xc(%eax),%edx
  802d38:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d3e:	01 c2                	add    %eax,%edx
  802d40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d43:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802d46:	83 ec 0c             	sub    $0xc,%esp
  802d49:	ff 75 08             	pushl  0x8(%ebp)
  802d4c:	e8 33 fc ff ff       	call   802984 <addToAvailMemBlocksList>
  802d51:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802d54:	e9 ef 00 00 00       	jmp    802e48 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802d59:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5c:	8b 50 0c             	mov    0xc(%eax),%edx
  802d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d62:	8b 40 08             	mov    0x8(%eax),%eax
  802d65:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6a:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802d6d:	39 c2                	cmp    %eax,%edx
  802d6f:	75 33                	jne    802da4 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802d71:	8b 45 08             	mov    0x8(%ebp),%eax
  802d74:	8b 50 08             	mov    0x8(%eax),%edx
  802d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7a:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d80:	8b 50 0c             	mov    0xc(%eax),%edx
  802d83:	8b 45 08             	mov    0x8(%ebp),%eax
  802d86:	8b 40 0c             	mov    0xc(%eax),%eax
  802d89:	01 c2                	add    %eax,%edx
  802d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8e:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802d91:	83 ec 0c             	sub    $0xc,%esp
  802d94:	ff 75 08             	pushl  0x8(%ebp)
  802d97:	e8 e8 fb ff ff       	call   802984 <addToAvailMemBlocksList>
  802d9c:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802d9f:	e9 a4 00 00 00       	jmp    802e48 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802da4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802da8:	74 06                	je     802db0 <insert_sorted_with_merge_freeList+0x3ac>
  802daa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dae:	75 17                	jne    802dc7 <insert_sorted_with_merge_freeList+0x3c3>
  802db0:	83 ec 04             	sub    $0x4,%esp
  802db3:	68 88 39 80 00       	push   $0x803988
  802db8:	68 56 01 00 00       	push   $0x156
  802dbd:	68 f7 38 80 00       	push   $0x8038f7
  802dc2:	e8 aa d4 ff ff       	call   800271 <_panic>
  802dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dca:	8b 50 04             	mov    0x4(%eax),%edx
  802dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd0:	89 50 04             	mov    %edx,0x4(%eax)
  802dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd9:	89 10                	mov    %edx,(%eax)
  802ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dde:	8b 40 04             	mov    0x4(%eax),%eax
  802de1:	85 c0                	test   %eax,%eax
  802de3:	74 0d                	je     802df2 <insert_sorted_with_merge_freeList+0x3ee>
  802de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de8:	8b 40 04             	mov    0x4(%eax),%eax
  802deb:	8b 55 08             	mov    0x8(%ebp),%edx
  802dee:	89 10                	mov    %edx,(%eax)
  802df0:	eb 08                	jmp    802dfa <insert_sorted_with_merge_freeList+0x3f6>
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	a3 38 41 80 00       	mov    %eax,0x804138
  802dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfd:	8b 55 08             	mov    0x8(%ebp),%edx
  802e00:	89 50 04             	mov    %edx,0x4(%eax)
  802e03:	a1 44 41 80 00       	mov    0x804144,%eax
  802e08:	40                   	inc    %eax
  802e09:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802e0e:	eb 38                	jmp    802e48 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802e10:	a1 40 41 80 00       	mov    0x804140,%eax
  802e15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e1c:	74 07                	je     802e25 <insert_sorted_with_merge_freeList+0x421>
  802e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e21:	8b 00                	mov    (%eax),%eax
  802e23:	eb 05                	jmp    802e2a <insert_sorted_with_merge_freeList+0x426>
  802e25:	b8 00 00 00 00       	mov    $0x0,%eax
  802e2a:	a3 40 41 80 00       	mov    %eax,0x804140
  802e2f:	a1 40 41 80 00       	mov    0x804140,%eax
  802e34:	85 c0                	test   %eax,%eax
  802e36:	0f 85 1a fd ff ff    	jne    802b56 <insert_sorted_with_merge_freeList+0x152>
  802e3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e40:	0f 85 10 fd ff ff    	jne    802b56 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e46:	eb 00                	jmp    802e48 <insert_sorted_with_merge_freeList+0x444>
  802e48:	90                   	nop
  802e49:	c9                   	leave  
  802e4a:	c3                   	ret    
  802e4b:	90                   	nop

00802e4c <__udivdi3>:
  802e4c:	55                   	push   %ebp
  802e4d:	57                   	push   %edi
  802e4e:	56                   	push   %esi
  802e4f:	53                   	push   %ebx
  802e50:	83 ec 1c             	sub    $0x1c,%esp
  802e53:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802e57:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802e5b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802e5f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802e63:	89 ca                	mov    %ecx,%edx
  802e65:	89 f8                	mov    %edi,%eax
  802e67:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802e6b:	85 f6                	test   %esi,%esi
  802e6d:	75 2d                	jne    802e9c <__udivdi3+0x50>
  802e6f:	39 cf                	cmp    %ecx,%edi
  802e71:	77 65                	ja     802ed8 <__udivdi3+0x8c>
  802e73:	89 fd                	mov    %edi,%ebp
  802e75:	85 ff                	test   %edi,%edi
  802e77:	75 0b                	jne    802e84 <__udivdi3+0x38>
  802e79:	b8 01 00 00 00       	mov    $0x1,%eax
  802e7e:	31 d2                	xor    %edx,%edx
  802e80:	f7 f7                	div    %edi
  802e82:	89 c5                	mov    %eax,%ebp
  802e84:	31 d2                	xor    %edx,%edx
  802e86:	89 c8                	mov    %ecx,%eax
  802e88:	f7 f5                	div    %ebp
  802e8a:	89 c1                	mov    %eax,%ecx
  802e8c:	89 d8                	mov    %ebx,%eax
  802e8e:	f7 f5                	div    %ebp
  802e90:	89 cf                	mov    %ecx,%edi
  802e92:	89 fa                	mov    %edi,%edx
  802e94:	83 c4 1c             	add    $0x1c,%esp
  802e97:	5b                   	pop    %ebx
  802e98:	5e                   	pop    %esi
  802e99:	5f                   	pop    %edi
  802e9a:	5d                   	pop    %ebp
  802e9b:	c3                   	ret    
  802e9c:	39 ce                	cmp    %ecx,%esi
  802e9e:	77 28                	ja     802ec8 <__udivdi3+0x7c>
  802ea0:	0f bd fe             	bsr    %esi,%edi
  802ea3:	83 f7 1f             	xor    $0x1f,%edi
  802ea6:	75 40                	jne    802ee8 <__udivdi3+0x9c>
  802ea8:	39 ce                	cmp    %ecx,%esi
  802eaa:	72 0a                	jb     802eb6 <__udivdi3+0x6a>
  802eac:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802eb0:	0f 87 9e 00 00 00    	ja     802f54 <__udivdi3+0x108>
  802eb6:	b8 01 00 00 00       	mov    $0x1,%eax
  802ebb:	89 fa                	mov    %edi,%edx
  802ebd:	83 c4 1c             	add    $0x1c,%esp
  802ec0:	5b                   	pop    %ebx
  802ec1:	5e                   	pop    %esi
  802ec2:	5f                   	pop    %edi
  802ec3:	5d                   	pop    %ebp
  802ec4:	c3                   	ret    
  802ec5:	8d 76 00             	lea    0x0(%esi),%esi
  802ec8:	31 ff                	xor    %edi,%edi
  802eca:	31 c0                	xor    %eax,%eax
  802ecc:	89 fa                	mov    %edi,%edx
  802ece:	83 c4 1c             	add    $0x1c,%esp
  802ed1:	5b                   	pop    %ebx
  802ed2:	5e                   	pop    %esi
  802ed3:	5f                   	pop    %edi
  802ed4:	5d                   	pop    %ebp
  802ed5:	c3                   	ret    
  802ed6:	66 90                	xchg   %ax,%ax
  802ed8:	89 d8                	mov    %ebx,%eax
  802eda:	f7 f7                	div    %edi
  802edc:	31 ff                	xor    %edi,%edi
  802ede:	89 fa                	mov    %edi,%edx
  802ee0:	83 c4 1c             	add    $0x1c,%esp
  802ee3:	5b                   	pop    %ebx
  802ee4:	5e                   	pop    %esi
  802ee5:	5f                   	pop    %edi
  802ee6:	5d                   	pop    %ebp
  802ee7:	c3                   	ret    
  802ee8:	bd 20 00 00 00       	mov    $0x20,%ebp
  802eed:	89 eb                	mov    %ebp,%ebx
  802eef:	29 fb                	sub    %edi,%ebx
  802ef1:	89 f9                	mov    %edi,%ecx
  802ef3:	d3 e6                	shl    %cl,%esi
  802ef5:	89 c5                	mov    %eax,%ebp
  802ef7:	88 d9                	mov    %bl,%cl
  802ef9:	d3 ed                	shr    %cl,%ebp
  802efb:	89 e9                	mov    %ebp,%ecx
  802efd:	09 f1                	or     %esi,%ecx
  802eff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802f03:	89 f9                	mov    %edi,%ecx
  802f05:	d3 e0                	shl    %cl,%eax
  802f07:	89 c5                	mov    %eax,%ebp
  802f09:	89 d6                	mov    %edx,%esi
  802f0b:	88 d9                	mov    %bl,%cl
  802f0d:	d3 ee                	shr    %cl,%esi
  802f0f:	89 f9                	mov    %edi,%ecx
  802f11:	d3 e2                	shl    %cl,%edx
  802f13:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f17:	88 d9                	mov    %bl,%cl
  802f19:	d3 e8                	shr    %cl,%eax
  802f1b:	09 c2                	or     %eax,%edx
  802f1d:	89 d0                	mov    %edx,%eax
  802f1f:	89 f2                	mov    %esi,%edx
  802f21:	f7 74 24 0c          	divl   0xc(%esp)
  802f25:	89 d6                	mov    %edx,%esi
  802f27:	89 c3                	mov    %eax,%ebx
  802f29:	f7 e5                	mul    %ebp
  802f2b:	39 d6                	cmp    %edx,%esi
  802f2d:	72 19                	jb     802f48 <__udivdi3+0xfc>
  802f2f:	74 0b                	je     802f3c <__udivdi3+0xf0>
  802f31:	89 d8                	mov    %ebx,%eax
  802f33:	31 ff                	xor    %edi,%edi
  802f35:	e9 58 ff ff ff       	jmp    802e92 <__udivdi3+0x46>
  802f3a:	66 90                	xchg   %ax,%ax
  802f3c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802f40:	89 f9                	mov    %edi,%ecx
  802f42:	d3 e2                	shl    %cl,%edx
  802f44:	39 c2                	cmp    %eax,%edx
  802f46:	73 e9                	jae    802f31 <__udivdi3+0xe5>
  802f48:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802f4b:	31 ff                	xor    %edi,%edi
  802f4d:	e9 40 ff ff ff       	jmp    802e92 <__udivdi3+0x46>
  802f52:	66 90                	xchg   %ax,%ax
  802f54:	31 c0                	xor    %eax,%eax
  802f56:	e9 37 ff ff ff       	jmp    802e92 <__udivdi3+0x46>
  802f5b:	90                   	nop

00802f5c <__umoddi3>:
  802f5c:	55                   	push   %ebp
  802f5d:	57                   	push   %edi
  802f5e:	56                   	push   %esi
  802f5f:	53                   	push   %ebx
  802f60:	83 ec 1c             	sub    $0x1c,%esp
  802f63:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802f67:	8b 74 24 34          	mov    0x34(%esp),%esi
  802f6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802f6f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802f73:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802f77:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802f7b:	89 f3                	mov    %esi,%ebx
  802f7d:	89 fa                	mov    %edi,%edx
  802f7f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802f83:	89 34 24             	mov    %esi,(%esp)
  802f86:	85 c0                	test   %eax,%eax
  802f88:	75 1a                	jne    802fa4 <__umoddi3+0x48>
  802f8a:	39 f7                	cmp    %esi,%edi
  802f8c:	0f 86 a2 00 00 00    	jbe    803034 <__umoddi3+0xd8>
  802f92:	89 c8                	mov    %ecx,%eax
  802f94:	89 f2                	mov    %esi,%edx
  802f96:	f7 f7                	div    %edi
  802f98:	89 d0                	mov    %edx,%eax
  802f9a:	31 d2                	xor    %edx,%edx
  802f9c:	83 c4 1c             	add    $0x1c,%esp
  802f9f:	5b                   	pop    %ebx
  802fa0:	5e                   	pop    %esi
  802fa1:	5f                   	pop    %edi
  802fa2:	5d                   	pop    %ebp
  802fa3:	c3                   	ret    
  802fa4:	39 f0                	cmp    %esi,%eax
  802fa6:	0f 87 ac 00 00 00    	ja     803058 <__umoddi3+0xfc>
  802fac:	0f bd e8             	bsr    %eax,%ebp
  802faf:	83 f5 1f             	xor    $0x1f,%ebp
  802fb2:	0f 84 ac 00 00 00    	je     803064 <__umoddi3+0x108>
  802fb8:	bf 20 00 00 00       	mov    $0x20,%edi
  802fbd:	29 ef                	sub    %ebp,%edi
  802fbf:	89 fe                	mov    %edi,%esi
  802fc1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802fc5:	89 e9                	mov    %ebp,%ecx
  802fc7:	d3 e0                	shl    %cl,%eax
  802fc9:	89 d7                	mov    %edx,%edi
  802fcb:	89 f1                	mov    %esi,%ecx
  802fcd:	d3 ef                	shr    %cl,%edi
  802fcf:	09 c7                	or     %eax,%edi
  802fd1:	89 e9                	mov    %ebp,%ecx
  802fd3:	d3 e2                	shl    %cl,%edx
  802fd5:	89 14 24             	mov    %edx,(%esp)
  802fd8:	89 d8                	mov    %ebx,%eax
  802fda:	d3 e0                	shl    %cl,%eax
  802fdc:	89 c2                	mov    %eax,%edx
  802fde:	8b 44 24 08          	mov    0x8(%esp),%eax
  802fe2:	d3 e0                	shl    %cl,%eax
  802fe4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802fe8:	8b 44 24 08          	mov    0x8(%esp),%eax
  802fec:	89 f1                	mov    %esi,%ecx
  802fee:	d3 e8                	shr    %cl,%eax
  802ff0:	09 d0                	or     %edx,%eax
  802ff2:	d3 eb                	shr    %cl,%ebx
  802ff4:	89 da                	mov    %ebx,%edx
  802ff6:	f7 f7                	div    %edi
  802ff8:	89 d3                	mov    %edx,%ebx
  802ffa:	f7 24 24             	mull   (%esp)
  802ffd:	89 c6                	mov    %eax,%esi
  802fff:	89 d1                	mov    %edx,%ecx
  803001:	39 d3                	cmp    %edx,%ebx
  803003:	0f 82 87 00 00 00    	jb     803090 <__umoddi3+0x134>
  803009:	0f 84 91 00 00 00    	je     8030a0 <__umoddi3+0x144>
  80300f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803013:	29 f2                	sub    %esi,%edx
  803015:	19 cb                	sbb    %ecx,%ebx
  803017:	89 d8                	mov    %ebx,%eax
  803019:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80301d:	d3 e0                	shl    %cl,%eax
  80301f:	89 e9                	mov    %ebp,%ecx
  803021:	d3 ea                	shr    %cl,%edx
  803023:	09 d0                	or     %edx,%eax
  803025:	89 e9                	mov    %ebp,%ecx
  803027:	d3 eb                	shr    %cl,%ebx
  803029:	89 da                	mov    %ebx,%edx
  80302b:	83 c4 1c             	add    $0x1c,%esp
  80302e:	5b                   	pop    %ebx
  80302f:	5e                   	pop    %esi
  803030:	5f                   	pop    %edi
  803031:	5d                   	pop    %ebp
  803032:	c3                   	ret    
  803033:	90                   	nop
  803034:	89 fd                	mov    %edi,%ebp
  803036:	85 ff                	test   %edi,%edi
  803038:	75 0b                	jne    803045 <__umoddi3+0xe9>
  80303a:	b8 01 00 00 00       	mov    $0x1,%eax
  80303f:	31 d2                	xor    %edx,%edx
  803041:	f7 f7                	div    %edi
  803043:	89 c5                	mov    %eax,%ebp
  803045:	89 f0                	mov    %esi,%eax
  803047:	31 d2                	xor    %edx,%edx
  803049:	f7 f5                	div    %ebp
  80304b:	89 c8                	mov    %ecx,%eax
  80304d:	f7 f5                	div    %ebp
  80304f:	89 d0                	mov    %edx,%eax
  803051:	e9 44 ff ff ff       	jmp    802f9a <__umoddi3+0x3e>
  803056:	66 90                	xchg   %ax,%ax
  803058:	89 c8                	mov    %ecx,%eax
  80305a:	89 f2                	mov    %esi,%edx
  80305c:	83 c4 1c             	add    $0x1c,%esp
  80305f:	5b                   	pop    %ebx
  803060:	5e                   	pop    %esi
  803061:	5f                   	pop    %edi
  803062:	5d                   	pop    %ebp
  803063:	c3                   	ret    
  803064:	3b 04 24             	cmp    (%esp),%eax
  803067:	72 06                	jb     80306f <__umoddi3+0x113>
  803069:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80306d:	77 0f                	ja     80307e <__umoddi3+0x122>
  80306f:	89 f2                	mov    %esi,%edx
  803071:	29 f9                	sub    %edi,%ecx
  803073:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803077:	89 14 24             	mov    %edx,(%esp)
  80307a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80307e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803082:	8b 14 24             	mov    (%esp),%edx
  803085:	83 c4 1c             	add    $0x1c,%esp
  803088:	5b                   	pop    %ebx
  803089:	5e                   	pop    %esi
  80308a:	5f                   	pop    %edi
  80308b:	5d                   	pop    %ebp
  80308c:	c3                   	ret    
  80308d:	8d 76 00             	lea    0x0(%esi),%esi
  803090:	2b 04 24             	sub    (%esp),%eax
  803093:	19 fa                	sbb    %edi,%edx
  803095:	89 d1                	mov    %edx,%ecx
  803097:	89 c6                	mov    %eax,%esi
  803099:	e9 71 ff ff ff       	jmp    80300f <__umoddi3+0xb3>
  80309e:	66 90                	xchg   %ax,%ax
  8030a0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8030a4:	72 ea                	jb     803090 <__umoddi3+0x134>
  8030a6:	89 d9                	mov    %ebx,%ecx
  8030a8:	e9 62 ff ff ff       	jmp    80300f <__umoddi3+0xb3>
