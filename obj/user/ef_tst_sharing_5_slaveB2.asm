
obj/user/ef_tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 77 01 00 00       	call   8001ad <libmain>
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
  80008c:	68 e0 31 80 00       	push   $0x8031e0
  800091:	6a 12                	push   $0x12
  800093:	68 fc 31 80 00       	push   $0x8031fc
  800098:	e8 4c 02 00 00       	call   8002e9 <_panic>
	}
	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  80009d:	e8 92 1b 00 00       	call   801c34 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 1c 32 80 00       	push   $0x80321c
  8000aa:	50                   	push   %eax
  8000ab:	e8 77 16 00 00       	call   801727 <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 20 32 80 00       	push   $0x803220
  8000be:	e8 da 04 00 00       	call   80059d <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B2 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 48 32 80 00       	push   $0x803248
  8000ce:	e8 ca 04 00 00       	call   80059d <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(9000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 28 23 00 00       	push   $0x2328
  8000de:	e8 e0 2d 00 00       	call   802ec3 <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 50 18 00 00       	call   80193b <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 e2 16 00 00       	call   8017db <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 68 32 80 00       	push   $0x803268
  800104:	e8 94 04 00 00       	call   80059d <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  80010c:	e8 2a 18 00 00       	call   80193b <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 80 32 80 00       	push   $0x803280
  800127:	6a 20                	push   $0x20
  800129:	68 fc 31 80 00       	push   $0x8031fc
  80012e:	e8 b6 01 00 00       	call   8002e9 <_panic>

	//to ensure that the other environments completed successfully
	if (gettst()!=2) panic("test failed");
  800133:	e8 3b 1c 00 00       	call   801d73 <gettst>
  800138:	83 f8 02             	cmp    $0x2,%eax
  80013b:	74 14                	je     800151 <_main+0x119>
  80013d:	83 ec 04             	sub    $0x4,%esp
  800140:	68 20 33 80 00       	push   $0x803320
  800145:	6a 23                	push   $0x23
  800147:	68 fc 31 80 00       	push   $0x8031fc
  80014c:	e8 98 01 00 00       	call   8002e9 <_panic>

	cprintf("Step B completed successfully!!\n\n\n");
  800151:	83 ec 0c             	sub    $0xc,%esp
  800154:	68 2c 33 80 00       	push   $0x80332c
  800159:	e8 3f 04 00 00       	call   80059d <cprintf>
  80015e:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	68 50 33 80 00       	push   $0x803350
  800169:	e8 2f 04 00 00       	call   80059d <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800171:	e8 be 1a 00 00       	call   801c34 <sys_getparentenvid>
  800176:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(parentenvID > 0)
  800179:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80017d:	7e 2b                	jle    8001aa <_main+0x172>
	{
		//Get the check-finishing counter
		int *finish = NULL;
  80017f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		finish = sget(parentenvID, "finish_children") ;
  800186:	83 ec 08             	sub    $0x8,%esp
  800189:	68 9c 33 80 00       	push   $0x80339c
  80018e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800191:	e8 91 15 00 00       	call   801727 <sget>
  800196:	83 c4 10             	add    $0x10,%esp
  800199:	89 45 e0             	mov    %eax,-0x20(%ebp)
		(*finish)++ ;
  80019c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80019f:	8b 00                	mov    (%eax),%eax
  8001a1:	8d 50 01             	lea    0x1(%eax),%edx
  8001a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a7:	89 10                	mov    %edx,(%eax)
	}
	return;
  8001a9:	90                   	nop
  8001aa:	90                   	nop
}
  8001ab:	c9                   	leave  
  8001ac:	c3                   	ret    

008001ad <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001ad:	55                   	push   %ebp
  8001ae:	89 e5                	mov    %esp,%ebp
  8001b0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001b3:	e8 63 1a 00 00       	call   801c1b <sys_getenvindex>
  8001b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001be:	89 d0                	mov    %edx,%eax
  8001c0:	c1 e0 03             	shl    $0x3,%eax
  8001c3:	01 d0                	add    %edx,%eax
  8001c5:	01 c0                	add    %eax,%eax
  8001c7:	01 d0                	add    %edx,%eax
  8001c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001d0:	01 d0                	add    %edx,%eax
  8001d2:	c1 e0 04             	shl    $0x4,%eax
  8001d5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001da:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001df:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e4:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001ea:	84 c0                	test   %al,%al
  8001ec:	74 0f                	je     8001fd <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001ee:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f3:	05 5c 05 00 00       	add    $0x55c,%eax
  8001f8:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800201:	7e 0a                	jle    80020d <libmain+0x60>
		binaryname = argv[0];
  800203:	8b 45 0c             	mov    0xc(%ebp),%eax
  800206:	8b 00                	mov    (%eax),%eax
  800208:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80020d:	83 ec 08             	sub    $0x8,%esp
  800210:	ff 75 0c             	pushl  0xc(%ebp)
  800213:	ff 75 08             	pushl  0x8(%ebp)
  800216:	e8 1d fe ff ff       	call   800038 <_main>
  80021b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80021e:	e8 05 18 00 00       	call   801a28 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	68 c4 33 80 00       	push   $0x8033c4
  80022b:	e8 6d 03 00 00       	call   80059d <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800233:	a1 20 40 80 00       	mov    0x804020,%eax
  800238:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80023e:	a1 20 40 80 00       	mov    0x804020,%eax
  800243:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800249:	83 ec 04             	sub    $0x4,%esp
  80024c:	52                   	push   %edx
  80024d:	50                   	push   %eax
  80024e:	68 ec 33 80 00       	push   $0x8033ec
  800253:	e8 45 03 00 00       	call   80059d <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80025b:	a1 20 40 80 00       	mov    0x804020,%eax
  800260:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800266:	a1 20 40 80 00       	mov    0x804020,%eax
  80026b:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800271:	a1 20 40 80 00       	mov    0x804020,%eax
  800276:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80027c:	51                   	push   %ecx
  80027d:	52                   	push   %edx
  80027e:	50                   	push   %eax
  80027f:	68 14 34 80 00       	push   $0x803414
  800284:	e8 14 03 00 00       	call   80059d <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80028c:	a1 20 40 80 00       	mov    0x804020,%eax
  800291:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800297:	83 ec 08             	sub    $0x8,%esp
  80029a:	50                   	push   %eax
  80029b:	68 6c 34 80 00       	push   $0x80346c
  8002a0:	e8 f8 02 00 00       	call   80059d <cprintf>
  8002a5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 c4 33 80 00       	push   $0x8033c4
  8002b0:	e8 e8 02 00 00       	call   80059d <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002b8:	e8 85 17 00 00       	call   801a42 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002bd:	e8 19 00 00 00       	call   8002db <exit>
}
  8002c2:	90                   	nop
  8002c3:	c9                   	leave  
  8002c4:	c3                   	ret    

008002c5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002c5:	55                   	push   %ebp
  8002c6:	89 e5                	mov    %esp,%ebp
  8002c8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002cb:	83 ec 0c             	sub    $0xc,%esp
  8002ce:	6a 00                	push   $0x0
  8002d0:	e8 12 19 00 00       	call   801be7 <sys_destroy_env>
  8002d5:	83 c4 10             	add    $0x10,%esp
}
  8002d8:	90                   	nop
  8002d9:	c9                   	leave  
  8002da:	c3                   	ret    

008002db <exit>:

void
exit(void)
{
  8002db:	55                   	push   %ebp
  8002dc:	89 e5                	mov    %esp,%ebp
  8002de:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002e1:	e8 67 19 00 00       	call   801c4d <sys_exit_env>
}
  8002e6:	90                   	nop
  8002e7:	c9                   	leave  
  8002e8:	c3                   	ret    

008002e9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002ef:	8d 45 10             	lea    0x10(%ebp),%eax
  8002f2:	83 c0 04             	add    $0x4,%eax
  8002f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002f8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002fd:	85 c0                	test   %eax,%eax
  8002ff:	74 16                	je     800317 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800301:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800306:	83 ec 08             	sub    $0x8,%esp
  800309:	50                   	push   %eax
  80030a:	68 80 34 80 00       	push   $0x803480
  80030f:	e8 89 02 00 00       	call   80059d <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800317:	a1 00 40 80 00       	mov    0x804000,%eax
  80031c:	ff 75 0c             	pushl  0xc(%ebp)
  80031f:	ff 75 08             	pushl  0x8(%ebp)
  800322:	50                   	push   %eax
  800323:	68 85 34 80 00       	push   $0x803485
  800328:	e8 70 02 00 00       	call   80059d <cprintf>
  80032d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800330:	8b 45 10             	mov    0x10(%ebp),%eax
  800333:	83 ec 08             	sub    $0x8,%esp
  800336:	ff 75 f4             	pushl  -0xc(%ebp)
  800339:	50                   	push   %eax
  80033a:	e8 f3 01 00 00       	call   800532 <vcprintf>
  80033f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	6a 00                	push   $0x0
  800347:	68 a1 34 80 00       	push   $0x8034a1
  80034c:	e8 e1 01 00 00       	call   800532 <vcprintf>
  800351:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800354:	e8 82 ff ff ff       	call   8002db <exit>

	// should not return here
	while (1) ;
  800359:	eb fe                	jmp    800359 <_panic+0x70>

0080035b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80035b:	55                   	push   %ebp
  80035c:	89 e5                	mov    %esp,%ebp
  80035e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800361:	a1 20 40 80 00       	mov    0x804020,%eax
  800366:	8b 50 74             	mov    0x74(%eax),%edx
  800369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036c:	39 c2                	cmp    %eax,%edx
  80036e:	74 14                	je     800384 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	68 a4 34 80 00       	push   $0x8034a4
  800378:	6a 26                	push   $0x26
  80037a:	68 f0 34 80 00       	push   $0x8034f0
  80037f:	e8 65 ff ff ff       	call   8002e9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800384:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80038b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800392:	e9 c2 00 00 00       	jmp    800459 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800397:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	85 c0                	test   %eax,%eax
  8003aa:	75 08                	jne    8003b4 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003ac:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003af:	e9 a2 00 00 00       	jmp    800456 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003b4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003bb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003c2:	eb 69                	jmp    80042d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003c4:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d2:	89 d0                	mov    %edx,%eax
  8003d4:	01 c0                	add    %eax,%eax
  8003d6:	01 d0                	add    %edx,%eax
  8003d8:	c1 e0 03             	shl    $0x3,%eax
  8003db:	01 c8                	add    %ecx,%eax
  8003dd:	8a 40 04             	mov    0x4(%eax),%al
  8003e0:	84 c0                	test   %al,%al
  8003e2:	75 46                	jne    80042a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003e4:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003f2:	89 d0                	mov    %edx,%eax
  8003f4:	01 c0                	add    %eax,%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	c1 e0 03             	shl    $0x3,%eax
  8003fb:	01 c8                	add    %ecx,%eax
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800402:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800405:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80040a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80040c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80040f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800416:	8b 45 08             	mov    0x8(%ebp),%eax
  800419:	01 c8                	add    %ecx,%eax
  80041b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80041d:	39 c2                	cmp    %eax,%edx
  80041f:	75 09                	jne    80042a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800421:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800428:	eb 12                	jmp    80043c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042a:	ff 45 e8             	incl   -0x18(%ebp)
  80042d:	a1 20 40 80 00       	mov    0x804020,%eax
  800432:	8b 50 74             	mov    0x74(%eax),%edx
  800435:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800438:	39 c2                	cmp    %eax,%edx
  80043a:	77 88                	ja     8003c4 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80043c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800440:	75 14                	jne    800456 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800442:	83 ec 04             	sub    $0x4,%esp
  800445:	68 fc 34 80 00       	push   $0x8034fc
  80044a:	6a 3a                	push   $0x3a
  80044c:	68 f0 34 80 00       	push   $0x8034f0
  800451:	e8 93 fe ff ff       	call   8002e9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800456:	ff 45 f0             	incl   -0x10(%ebp)
  800459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80045c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80045f:	0f 8c 32 ff ff ff    	jl     800397 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800465:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800473:	eb 26                	jmp    80049b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800475:	a1 20 40 80 00       	mov    0x804020,%eax
  80047a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800480:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800483:	89 d0                	mov    %edx,%eax
  800485:	01 c0                	add    %eax,%eax
  800487:	01 d0                	add    %edx,%eax
  800489:	c1 e0 03             	shl    $0x3,%eax
  80048c:	01 c8                	add    %ecx,%eax
  80048e:	8a 40 04             	mov    0x4(%eax),%al
  800491:	3c 01                	cmp    $0x1,%al
  800493:	75 03                	jne    800498 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800495:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800498:	ff 45 e0             	incl   -0x20(%ebp)
  80049b:	a1 20 40 80 00       	mov    0x804020,%eax
  8004a0:	8b 50 74             	mov    0x74(%eax),%edx
  8004a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a6:	39 c2                	cmp    %eax,%edx
  8004a8:	77 cb                	ja     800475 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ad:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004b0:	74 14                	je     8004c6 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004b2:	83 ec 04             	sub    $0x4,%esp
  8004b5:	68 50 35 80 00       	push   $0x803550
  8004ba:	6a 44                	push   $0x44
  8004bc:	68 f0 34 80 00       	push   $0x8034f0
  8004c1:	e8 23 fe ff ff       	call   8002e9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004c6:	90                   	nop
  8004c7:	c9                   	leave  
  8004c8:	c3                   	ret    

008004c9 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004c9:	55                   	push   %ebp
  8004ca:	89 e5                	mov    %esp,%ebp
  8004cc:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d2:	8b 00                	mov    (%eax),%eax
  8004d4:	8d 48 01             	lea    0x1(%eax),%ecx
  8004d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004da:	89 0a                	mov    %ecx,(%edx)
  8004dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8004df:	88 d1                	mov    %dl,%cl
  8004e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004eb:	8b 00                	mov    (%eax),%eax
  8004ed:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004f2:	75 2c                	jne    800520 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004f4:	a0 24 40 80 00       	mov    0x804024,%al
  8004f9:	0f b6 c0             	movzbl %al,%eax
  8004fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ff:	8b 12                	mov    (%edx),%edx
  800501:	89 d1                	mov    %edx,%ecx
  800503:	8b 55 0c             	mov    0xc(%ebp),%edx
  800506:	83 c2 08             	add    $0x8,%edx
  800509:	83 ec 04             	sub    $0x4,%esp
  80050c:	50                   	push   %eax
  80050d:	51                   	push   %ecx
  80050e:	52                   	push   %edx
  80050f:	e8 66 13 00 00       	call   80187a <sys_cputs>
  800514:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800520:	8b 45 0c             	mov    0xc(%ebp),%eax
  800523:	8b 40 04             	mov    0x4(%eax),%eax
  800526:	8d 50 01             	lea    0x1(%eax),%edx
  800529:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80052f:	90                   	nop
  800530:	c9                   	leave  
  800531:	c3                   	ret    

00800532 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800532:	55                   	push   %ebp
  800533:	89 e5                	mov    %esp,%ebp
  800535:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80053b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800542:	00 00 00 
	b.cnt = 0;
  800545:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80054c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80054f:	ff 75 0c             	pushl  0xc(%ebp)
  800552:	ff 75 08             	pushl  0x8(%ebp)
  800555:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80055b:	50                   	push   %eax
  80055c:	68 c9 04 80 00       	push   $0x8004c9
  800561:	e8 11 02 00 00       	call   800777 <vprintfmt>
  800566:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800569:	a0 24 40 80 00       	mov    0x804024,%al
  80056e:	0f b6 c0             	movzbl %al,%eax
  800571:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800577:	83 ec 04             	sub    $0x4,%esp
  80057a:	50                   	push   %eax
  80057b:	52                   	push   %edx
  80057c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800582:	83 c0 08             	add    $0x8,%eax
  800585:	50                   	push   %eax
  800586:	e8 ef 12 00 00       	call   80187a <sys_cputs>
  80058b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80058e:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800595:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80059b:	c9                   	leave  
  80059c:	c3                   	ret    

0080059d <cprintf>:

int cprintf(const char *fmt, ...) {
  80059d:	55                   	push   %ebp
  80059e:	89 e5                	mov    %esp,%ebp
  8005a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005a3:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8005aa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b9:	50                   	push   %eax
  8005ba:	e8 73 ff ff ff       	call   800532 <vcprintf>
  8005bf:	83 c4 10             	add    $0x10,%esp
  8005c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c8:	c9                   	leave  
  8005c9:	c3                   	ret    

008005ca <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005ca:	55                   	push   %ebp
  8005cb:	89 e5                	mov    %esp,%ebp
  8005cd:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005d0:	e8 53 14 00 00       	call   801a28 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005d5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	83 ec 08             	sub    $0x8,%esp
  8005e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e4:	50                   	push   %eax
  8005e5:	e8 48 ff ff ff       	call   800532 <vcprintf>
  8005ea:	83 c4 10             	add    $0x10,%esp
  8005ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005f0:	e8 4d 14 00 00       	call   801a42 <sys_enable_interrupt>
	return cnt;
  8005f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f8:	c9                   	leave  
  8005f9:	c3                   	ret    

008005fa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005fa:	55                   	push   %ebp
  8005fb:	89 e5                	mov    %esp,%ebp
  8005fd:	53                   	push   %ebx
  8005fe:	83 ec 14             	sub    $0x14,%esp
  800601:	8b 45 10             	mov    0x10(%ebp),%eax
  800604:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800607:	8b 45 14             	mov    0x14(%ebp),%eax
  80060a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80060d:	8b 45 18             	mov    0x18(%ebp),%eax
  800610:	ba 00 00 00 00       	mov    $0x0,%edx
  800615:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800618:	77 55                	ja     80066f <printnum+0x75>
  80061a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80061d:	72 05                	jb     800624 <printnum+0x2a>
  80061f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800622:	77 4b                	ja     80066f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800624:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800627:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80062a:	8b 45 18             	mov    0x18(%ebp),%eax
  80062d:	ba 00 00 00 00       	mov    $0x0,%edx
  800632:	52                   	push   %edx
  800633:	50                   	push   %eax
  800634:	ff 75 f4             	pushl  -0xc(%ebp)
  800637:	ff 75 f0             	pushl  -0x10(%ebp)
  80063a:	e8 39 29 00 00       	call   802f78 <__udivdi3>
  80063f:	83 c4 10             	add    $0x10,%esp
  800642:	83 ec 04             	sub    $0x4,%esp
  800645:	ff 75 20             	pushl  0x20(%ebp)
  800648:	53                   	push   %ebx
  800649:	ff 75 18             	pushl  0x18(%ebp)
  80064c:	52                   	push   %edx
  80064d:	50                   	push   %eax
  80064e:	ff 75 0c             	pushl  0xc(%ebp)
  800651:	ff 75 08             	pushl  0x8(%ebp)
  800654:	e8 a1 ff ff ff       	call   8005fa <printnum>
  800659:	83 c4 20             	add    $0x20,%esp
  80065c:	eb 1a                	jmp    800678 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80065e:	83 ec 08             	sub    $0x8,%esp
  800661:	ff 75 0c             	pushl  0xc(%ebp)
  800664:	ff 75 20             	pushl  0x20(%ebp)
  800667:	8b 45 08             	mov    0x8(%ebp),%eax
  80066a:	ff d0                	call   *%eax
  80066c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80066f:	ff 4d 1c             	decl   0x1c(%ebp)
  800672:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800676:	7f e6                	jg     80065e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800678:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80067b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800683:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800686:	53                   	push   %ebx
  800687:	51                   	push   %ecx
  800688:	52                   	push   %edx
  800689:	50                   	push   %eax
  80068a:	e8 f9 29 00 00       	call   803088 <__umoddi3>
  80068f:	83 c4 10             	add    $0x10,%esp
  800692:	05 b4 37 80 00       	add    $0x8037b4,%eax
  800697:	8a 00                	mov    (%eax),%al
  800699:	0f be c0             	movsbl %al,%eax
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	ff 75 0c             	pushl  0xc(%ebp)
  8006a2:	50                   	push   %eax
  8006a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a6:	ff d0                	call   *%eax
  8006a8:	83 c4 10             	add    $0x10,%esp
}
  8006ab:	90                   	nop
  8006ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006af:	c9                   	leave  
  8006b0:	c3                   	ret    

008006b1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006b1:	55                   	push   %ebp
  8006b2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b8:	7e 1c                	jle    8006d6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
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
  8006d4:	eb 40                	jmp    800716 <getuint+0x65>
	else if (lflag)
  8006d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006da:	74 1e                	je     8006fa <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	8d 50 04             	lea    0x4(%eax),%edx
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	89 10                	mov    %edx,(%eax)
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	83 e8 04             	sub    $0x4,%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f8:	eb 1c                	jmp    800716 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	8d 50 04             	lea    0x4(%eax),%edx
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	89 10                	mov    %edx,(%eax)
  800707:	8b 45 08             	mov    0x8(%ebp),%eax
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	83 e8 04             	sub    $0x4,%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800716:	5d                   	pop    %ebp
  800717:	c3                   	ret    

00800718 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800718:	55                   	push   %ebp
  800719:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80071b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80071f:	7e 1c                	jle    80073d <getint+0x25>
		return va_arg(*ap, long long);
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	8d 50 08             	lea    0x8(%eax),%edx
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	89 10                	mov    %edx,(%eax)
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	8b 00                	mov    (%eax),%eax
  800733:	83 e8 08             	sub    $0x8,%eax
  800736:	8b 50 04             	mov    0x4(%eax),%edx
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	eb 38                	jmp    800775 <getint+0x5d>
	else if (lflag)
  80073d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800741:	74 1a                	je     80075d <getint+0x45>
		return va_arg(*ap, long);
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	8d 50 04             	lea    0x4(%eax),%edx
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	89 10                	mov    %edx,(%eax)
  800750:	8b 45 08             	mov    0x8(%ebp),%eax
  800753:	8b 00                	mov    (%eax),%eax
  800755:	83 e8 04             	sub    $0x4,%eax
  800758:	8b 00                	mov    (%eax),%eax
  80075a:	99                   	cltd   
  80075b:	eb 18                	jmp    800775 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	8d 50 04             	lea    0x4(%eax),%edx
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	89 10                	mov    %edx,(%eax)
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	83 e8 04             	sub    $0x4,%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	99                   	cltd   
}
  800775:	5d                   	pop    %ebp
  800776:	c3                   	ret    

00800777 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
  80077a:	56                   	push   %esi
  80077b:	53                   	push   %ebx
  80077c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077f:	eb 17                	jmp    800798 <vprintfmt+0x21>
			if (ch == '\0')
  800781:	85 db                	test   %ebx,%ebx
  800783:	0f 84 af 03 00 00    	je     800b38 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	53                   	push   %ebx
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	ff d0                	call   *%eax
  800795:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800798:	8b 45 10             	mov    0x10(%ebp),%eax
  80079b:	8d 50 01             	lea    0x1(%eax),%edx
  80079e:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a1:	8a 00                	mov    (%eax),%al
  8007a3:	0f b6 d8             	movzbl %al,%ebx
  8007a6:	83 fb 25             	cmp    $0x25,%ebx
  8007a9:	75 d6                	jne    800781 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007ab:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007af:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007b6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007c4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ce:	8d 50 01             	lea    0x1(%eax),%edx
  8007d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8007d4:	8a 00                	mov    (%eax),%al
  8007d6:	0f b6 d8             	movzbl %al,%ebx
  8007d9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007dc:	83 f8 55             	cmp    $0x55,%eax
  8007df:	0f 87 2b 03 00 00    	ja     800b10 <vprintfmt+0x399>
  8007e5:	8b 04 85 d8 37 80 00 	mov    0x8037d8(,%eax,4),%eax
  8007ec:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007ee:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007f2:	eb d7                	jmp    8007cb <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007f4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007f8:	eb d1                	jmp    8007cb <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800801:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800804:	89 d0                	mov    %edx,%eax
  800806:	c1 e0 02             	shl    $0x2,%eax
  800809:	01 d0                	add    %edx,%eax
  80080b:	01 c0                	add    %eax,%eax
  80080d:	01 d8                	add    %ebx,%eax
  80080f:	83 e8 30             	sub    $0x30,%eax
  800812:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800815:	8b 45 10             	mov    0x10(%ebp),%eax
  800818:	8a 00                	mov    (%eax),%al
  80081a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80081d:	83 fb 2f             	cmp    $0x2f,%ebx
  800820:	7e 3e                	jle    800860 <vprintfmt+0xe9>
  800822:	83 fb 39             	cmp    $0x39,%ebx
  800825:	7f 39                	jg     800860 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800827:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80082a:	eb d5                	jmp    800801 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	83 c0 04             	add    $0x4,%eax
  800832:	89 45 14             	mov    %eax,0x14(%ebp)
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	83 e8 04             	sub    $0x4,%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800840:	eb 1f                	jmp    800861 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800842:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800846:	79 83                	jns    8007cb <vprintfmt+0x54>
				width = 0;
  800848:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80084f:	e9 77 ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800854:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80085b:	e9 6b ff ff ff       	jmp    8007cb <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800860:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800861:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800865:	0f 89 60 ff ff ff    	jns    8007cb <vprintfmt+0x54>
				width = precision, precision = -1;
  80086b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80086e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800871:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800878:	e9 4e ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80087d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800880:	e9 46 ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	83 c0 04             	add    $0x4,%eax
  80088b:	89 45 14             	mov    %eax,0x14(%ebp)
  80088e:	8b 45 14             	mov    0x14(%ebp),%eax
  800891:	83 e8 04             	sub    $0x4,%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	83 ec 08             	sub    $0x8,%esp
  800899:	ff 75 0c             	pushl  0xc(%ebp)
  80089c:	50                   	push   %eax
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	ff d0                	call   *%eax
  8008a2:	83 c4 10             	add    $0x10,%esp
			break;
  8008a5:	e9 89 02 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	83 c0 04             	add    $0x4,%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	83 e8 04             	sub    $0x4,%eax
  8008b9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008bb:	85 db                	test   %ebx,%ebx
  8008bd:	79 02                	jns    8008c1 <vprintfmt+0x14a>
				err = -err;
  8008bf:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008c1:	83 fb 64             	cmp    $0x64,%ebx
  8008c4:	7f 0b                	jg     8008d1 <vprintfmt+0x15a>
  8008c6:	8b 34 9d 20 36 80 00 	mov    0x803620(,%ebx,4),%esi
  8008cd:	85 f6                	test   %esi,%esi
  8008cf:	75 19                	jne    8008ea <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008d1:	53                   	push   %ebx
  8008d2:	68 c5 37 80 00       	push   $0x8037c5
  8008d7:	ff 75 0c             	pushl  0xc(%ebp)
  8008da:	ff 75 08             	pushl  0x8(%ebp)
  8008dd:	e8 5e 02 00 00       	call   800b40 <printfmt>
  8008e2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008e5:	e9 49 02 00 00       	jmp    800b33 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008ea:	56                   	push   %esi
  8008eb:	68 ce 37 80 00       	push   $0x8037ce
  8008f0:	ff 75 0c             	pushl  0xc(%ebp)
  8008f3:	ff 75 08             	pushl  0x8(%ebp)
  8008f6:	e8 45 02 00 00       	call   800b40 <printfmt>
  8008fb:	83 c4 10             	add    $0x10,%esp
			break;
  8008fe:	e9 30 02 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800903:	8b 45 14             	mov    0x14(%ebp),%eax
  800906:	83 c0 04             	add    $0x4,%eax
  800909:	89 45 14             	mov    %eax,0x14(%ebp)
  80090c:	8b 45 14             	mov    0x14(%ebp),%eax
  80090f:	83 e8 04             	sub    $0x4,%eax
  800912:	8b 30                	mov    (%eax),%esi
  800914:	85 f6                	test   %esi,%esi
  800916:	75 05                	jne    80091d <vprintfmt+0x1a6>
				p = "(null)";
  800918:	be d1 37 80 00       	mov    $0x8037d1,%esi
			if (width > 0 && padc != '-')
  80091d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800921:	7e 6d                	jle    800990 <vprintfmt+0x219>
  800923:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800927:	74 67                	je     800990 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800929:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092c:	83 ec 08             	sub    $0x8,%esp
  80092f:	50                   	push   %eax
  800930:	56                   	push   %esi
  800931:	e8 0c 03 00 00       	call   800c42 <strnlen>
  800936:	83 c4 10             	add    $0x10,%esp
  800939:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80093c:	eb 16                	jmp    800954 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80093e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800942:	83 ec 08             	sub    $0x8,%esp
  800945:	ff 75 0c             	pushl  0xc(%ebp)
  800948:	50                   	push   %eax
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	ff d0                	call   *%eax
  80094e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800951:	ff 4d e4             	decl   -0x1c(%ebp)
  800954:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800958:	7f e4                	jg     80093e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80095a:	eb 34                	jmp    800990 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80095c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800960:	74 1c                	je     80097e <vprintfmt+0x207>
  800962:	83 fb 1f             	cmp    $0x1f,%ebx
  800965:	7e 05                	jle    80096c <vprintfmt+0x1f5>
  800967:	83 fb 7e             	cmp    $0x7e,%ebx
  80096a:	7e 12                	jle    80097e <vprintfmt+0x207>
					putch('?', putdat);
  80096c:	83 ec 08             	sub    $0x8,%esp
  80096f:	ff 75 0c             	pushl  0xc(%ebp)
  800972:	6a 3f                	push   $0x3f
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	ff d0                	call   *%eax
  800979:	83 c4 10             	add    $0x10,%esp
  80097c:	eb 0f                	jmp    80098d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80097e:	83 ec 08             	sub    $0x8,%esp
  800981:	ff 75 0c             	pushl  0xc(%ebp)
  800984:	53                   	push   %ebx
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	ff d0                	call   *%eax
  80098a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80098d:	ff 4d e4             	decl   -0x1c(%ebp)
  800990:	89 f0                	mov    %esi,%eax
  800992:	8d 70 01             	lea    0x1(%eax),%esi
  800995:	8a 00                	mov    (%eax),%al
  800997:	0f be d8             	movsbl %al,%ebx
  80099a:	85 db                	test   %ebx,%ebx
  80099c:	74 24                	je     8009c2 <vprintfmt+0x24b>
  80099e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009a2:	78 b8                	js     80095c <vprintfmt+0x1e5>
  8009a4:	ff 4d e0             	decl   -0x20(%ebp)
  8009a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ab:	79 af                	jns    80095c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ad:	eb 13                	jmp    8009c2 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009af:	83 ec 08             	sub    $0x8,%esp
  8009b2:	ff 75 0c             	pushl  0xc(%ebp)
  8009b5:	6a 20                	push   $0x20
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	ff d0                	call   *%eax
  8009bc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009bf:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c6:	7f e7                	jg     8009af <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009c8:	e9 66 01 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	ff 75 e8             	pushl  -0x18(%ebp)
  8009d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8009d6:	50                   	push   %eax
  8009d7:	e8 3c fd ff ff       	call   800718 <getint>
  8009dc:	83 c4 10             	add    $0x10,%esp
  8009df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009eb:	85 d2                	test   %edx,%edx
  8009ed:	79 23                	jns    800a12 <vprintfmt+0x29b>
				putch('-', putdat);
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	ff 75 0c             	pushl  0xc(%ebp)
  8009f5:	6a 2d                	push   $0x2d
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	ff d0                	call   *%eax
  8009fc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a05:	f7 d8                	neg    %eax
  800a07:	83 d2 00             	adc    $0x0,%edx
  800a0a:	f7 da                	neg    %edx
  800a0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a12:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a19:	e9 bc 00 00 00       	jmp    800ada <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 e8             	pushl  -0x18(%ebp)
  800a24:	8d 45 14             	lea    0x14(%ebp),%eax
  800a27:	50                   	push   %eax
  800a28:	e8 84 fc ff ff       	call   8006b1 <getuint>
  800a2d:	83 c4 10             	add    $0x10,%esp
  800a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a33:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a36:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a3d:	e9 98 00 00 00       	jmp    800ada <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a42:	83 ec 08             	sub    $0x8,%esp
  800a45:	ff 75 0c             	pushl  0xc(%ebp)
  800a48:	6a 58                	push   $0x58
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	ff d0                	call   *%eax
  800a4f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	6a 58                	push   $0x58
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	ff d0                	call   *%eax
  800a5f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 0c             	pushl  0xc(%ebp)
  800a68:	6a 58                	push   $0x58
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	ff d0                	call   *%eax
  800a6f:	83 c4 10             	add    $0x10,%esp
			break;
  800a72:	e9 bc 00 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	6a 30                	push   $0x30
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
  800a84:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 0c             	pushl  0xc(%ebp)
  800a8d:	6a 78                	push   $0x78
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	ff d0                	call   *%eax
  800a94:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 c0 04             	add    $0x4,%eax
  800a9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	83 e8 04             	sub    $0x4,%eax
  800aa6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800aa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ab2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ab9:	eb 1f                	jmp    800ada <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	ff 75 e8             	pushl  -0x18(%ebp)
  800ac1:	8d 45 14             	lea    0x14(%ebp),%eax
  800ac4:	50                   	push   %eax
  800ac5:	e8 e7 fb ff ff       	call   8006b1 <getuint>
  800aca:	83 c4 10             	add    $0x10,%esp
  800acd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ad3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ada:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ade:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ae1:	83 ec 04             	sub    $0x4,%esp
  800ae4:	52                   	push   %edx
  800ae5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ae8:	50                   	push   %eax
  800ae9:	ff 75 f4             	pushl  -0xc(%ebp)
  800aec:	ff 75 f0             	pushl  -0x10(%ebp)
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	ff 75 08             	pushl  0x8(%ebp)
  800af5:	e8 00 fb ff ff       	call   8005fa <printnum>
  800afa:	83 c4 20             	add    $0x20,%esp
			break;
  800afd:	eb 34                	jmp    800b33 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 0c             	pushl  0xc(%ebp)
  800b05:	53                   	push   %ebx
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	ff d0                	call   *%eax
  800b0b:	83 c4 10             	add    $0x10,%esp
			break;
  800b0e:	eb 23                	jmp    800b33 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	ff 75 0c             	pushl  0xc(%ebp)
  800b16:	6a 25                	push   $0x25
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	ff d0                	call   *%eax
  800b1d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b20:	ff 4d 10             	decl   0x10(%ebp)
  800b23:	eb 03                	jmp    800b28 <vprintfmt+0x3b1>
  800b25:	ff 4d 10             	decl   0x10(%ebp)
  800b28:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2b:	48                   	dec    %eax
  800b2c:	8a 00                	mov    (%eax),%al
  800b2e:	3c 25                	cmp    $0x25,%al
  800b30:	75 f3                	jne    800b25 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b32:	90                   	nop
		}
	}
  800b33:	e9 47 fc ff ff       	jmp    80077f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b38:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b39:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b3c:	5b                   	pop    %ebx
  800b3d:	5e                   	pop    %esi
  800b3e:	5d                   	pop    %ebp
  800b3f:	c3                   	ret    

00800b40 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b46:	8d 45 10             	lea    0x10(%ebp),%eax
  800b49:	83 c0 04             	add    $0x4,%eax
  800b4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b52:	ff 75 f4             	pushl  -0xc(%ebp)
  800b55:	50                   	push   %eax
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	ff 75 08             	pushl  0x8(%ebp)
  800b5c:	e8 16 fc ff ff       	call   800777 <vprintfmt>
  800b61:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b64:	90                   	nop
  800b65:	c9                   	leave  
  800b66:	c3                   	ret    

00800b67 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6d:	8b 40 08             	mov    0x8(%eax),%eax
  800b70:	8d 50 01             	lea    0x1(%eax),%edx
  800b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b76:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7c:	8b 10                	mov    (%eax),%edx
  800b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b81:	8b 40 04             	mov    0x4(%eax),%eax
  800b84:	39 c2                	cmp    %eax,%edx
  800b86:	73 12                	jae    800b9a <sprintputch+0x33>
		*b->buf++ = ch;
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	8b 00                	mov    (%eax),%eax
  800b8d:	8d 48 01             	lea    0x1(%eax),%ecx
  800b90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b93:	89 0a                	mov    %ecx,(%edx)
  800b95:	8b 55 08             	mov    0x8(%ebp),%edx
  800b98:	88 10                	mov    %dl,(%eax)
}
  800b9a:	90                   	nop
  800b9b:	5d                   	pop    %ebp
  800b9c:	c3                   	ret    

00800b9d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bac:	8d 50 ff             	lea    -0x1(%eax),%edx
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	01 d0                	add    %edx,%eax
  800bb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bc2:	74 06                	je     800bca <vsnprintf+0x2d>
  800bc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc8:	7f 07                	jg     800bd1 <vsnprintf+0x34>
		return -E_INVAL;
  800bca:	b8 03 00 00 00       	mov    $0x3,%eax
  800bcf:	eb 20                	jmp    800bf1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bd1:	ff 75 14             	pushl  0x14(%ebp)
  800bd4:	ff 75 10             	pushl  0x10(%ebp)
  800bd7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bda:	50                   	push   %eax
  800bdb:	68 67 0b 80 00       	push   $0x800b67
  800be0:	e8 92 fb ff ff       	call   800777 <vprintfmt>
  800be5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800be8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800beb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bf1:	c9                   	leave  
  800bf2:	c3                   	ret    

00800bf3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bf9:	8d 45 10             	lea    0x10(%ebp),%eax
  800bfc:	83 c0 04             	add    $0x4,%eax
  800bff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c02:	8b 45 10             	mov    0x10(%ebp),%eax
  800c05:	ff 75 f4             	pushl  -0xc(%ebp)
  800c08:	50                   	push   %eax
  800c09:	ff 75 0c             	pushl  0xc(%ebp)
  800c0c:	ff 75 08             	pushl  0x8(%ebp)
  800c0f:	e8 89 ff ff ff       	call   800b9d <vsnprintf>
  800c14:	83 c4 10             	add    $0x10,%esp
  800c17:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2c:	eb 06                	jmp    800c34 <strlen+0x15>
		n++;
  800c2e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c31:	ff 45 08             	incl   0x8(%ebp)
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	75 f1                	jne    800c2e <strlen+0xf>
		n++;
	return n;
  800c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c4f:	eb 09                	jmp    800c5a <strnlen+0x18>
		n++;
  800c51:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c54:	ff 45 08             	incl   0x8(%ebp)
  800c57:	ff 4d 0c             	decl   0xc(%ebp)
  800c5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c5e:	74 09                	je     800c69 <strnlen+0x27>
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	84 c0                	test   %al,%al
  800c67:	75 e8                	jne    800c51 <strnlen+0xf>
		n++;
	return n;
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c7a:	90                   	nop
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8d 50 01             	lea    0x1(%eax),%edx
  800c81:	89 55 08             	mov    %edx,0x8(%ebp)
  800c84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c87:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c8a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c8d:	8a 12                	mov    (%edx),%dl
  800c8f:	88 10                	mov    %dl,(%eax)
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	84 c0                	test   %al,%al
  800c95:	75 e4                	jne    800c7b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c97:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ca8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800caf:	eb 1f                	jmp    800cd0 <strncpy+0x34>
		*dst++ = *src;
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	8d 50 01             	lea    0x1(%eax),%edx
  800cb7:	89 55 08             	mov    %edx,0x8(%ebp)
  800cba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbd:	8a 12                	mov    (%edx),%dl
  800cbf:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc4:	8a 00                	mov    (%eax),%al
  800cc6:	84 c0                	test   %al,%al
  800cc8:	74 03                	je     800ccd <strncpy+0x31>
			src++;
  800cca:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ccd:	ff 45 fc             	incl   -0x4(%ebp)
  800cd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cd6:	72 d9                	jb     800cb1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cdb:	c9                   	leave  
  800cdc:	c3                   	ret    

00800cdd <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cdd:	55                   	push   %ebp
  800cde:	89 e5                	mov    %esp,%ebp
  800ce0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ce9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ced:	74 30                	je     800d1f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cef:	eb 16                	jmp    800d07 <strlcpy+0x2a>
			*dst++ = *src++;
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	8d 50 01             	lea    0x1(%eax),%edx
  800cf7:	89 55 08             	mov    %edx,0x8(%ebp)
  800cfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d00:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d03:	8a 12                	mov    (%edx),%dl
  800d05:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d07:	ff 4d 10             	decl   0x10(%ebp)
  800d0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0e:	74 09                	je     800d19 <strlcpy+0x3c>
  800d10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	84 c0                	test   %al,%al
  800d17:	75 d8                	jne    800cf1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d25:	29 c2                	sub    %eax,%edx
  800d27:	89 d0                	mov    %edx,%eax
}
  800d29:	c9                   	leave  
  800d2a:	c3                   	ret    

00800d2b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d2e:	eb 06                	jmp    800d36 <strcmp+0xb>
		p++, q++;
  800d30:	ff 45 08             	incl   0x8(%ebp)
  800d33:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8a 00                	mov    (%eax),%al
  800d3b:	84 c0                	test   %al,%al
  800d3d:	74 0e                	je     800d4d <strcmp+0x22>
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8a 10                	mov    (%eax),%dl
  800d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	38 c2                	cmp    %al,%dl
  800d4b:	74 e3                	je     800d30 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	0f b6 d0             	movzbl %al,%edx
  800d55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	0f b6 c0             	movzbl %al,%eax
  800d5d:	29 c2                	sub    %eax,%edx
  800d5f:	89 d0                	mov    %edx,%eax
}
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    

00800d63 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d66:	eb 09                	jmp    800d71 <strncmp+0xe>
		n--, p++, q++;
  800d68:	ff 4d 10             	decl   0x10(%ebp)
  800d6b:	ff 45 08             	incl   0x8(%ebp)
  800d6e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d75:	74 17                	je     800d8e <strncmp+0x2b>
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	84 c0                	test   %al,%al
  800d7e:	74 0e                	je     800d8e <strncmp+0x2b>
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 10                	mov    (%eax),%dl
  800d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	38 c2                	cmp    %al,%dl
  800d8c:	74 da                	je     800d68 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d92:	75 07                	jne    800d9b <strncmp+0x38>
		return 0;
  800d94:	b8 00 00 00 00       	mov    $0x0,%eax
  800d99:	eb 14                	jmp    800daf <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	8a 00                	mov    (%eax),%al
  800da0:	0f b6 d0             	movzbl %al,%edx
  800da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	0f b6 c0             	movzbl %al,%eax
  800dab:	29 c2                	sub    %eax,%edx
  800dad:	89 d0                	mov    %edx,%eax
}
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    

00800db1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	83 ec 04             	sub    $0x4,%esp
  800db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dba:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dbd:	eb 12                	jmp    800dd1 <strchr+0x20>
		if (*s == c)
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc7:	75 05                	jne    800dce <strchr+0x1d>
			return (char *) s;
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	eb 11                	jmp    800ddf <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dce:	ff 45 08             	incl   0x8(%ebp)
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	84 c0                	test   %al,%al
  800dd8:	75 e5                	jne    800dbf <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 04             	sub    $0x4,%esp
  800de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dea:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ded:	eb 0d                	jmp    800dfc <strfind+0x1b>
		if (*s == c)
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df7:	74 0e                	je     800e07 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800df9:	ff 45 08             	incl   0x8(%ebp)
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	84 c0                	test   %al,%al
  800e03:	75 ea                	jne    800def <strfind+0xe>
  800e05:	eb 01                	jmp    800e08 <strfind+0x27>
		if (*s == c)
			break;
  800e07:	90                   	nop
	return (char *) s;
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e19:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e1f:	eb 0e                	jmp    800e2f <memset+0x22>
		*p++ = c;
  800e21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e24:	8d 50 01             	lea    0x1(%eax),%edx
  800e27:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e2d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e2f:	ff 4d f8             	decl   -0x8(%ebp)
  800e32:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e36:	79 e9                	jns    800e21 <memset+0x14>
		*p++ = c;

	return v;
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3b:	c9                   	leave  
  800e3c:	c3                   	ret    

00800e3d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e4f:	eb 16                	jmp    800e67 <memcpy+0x2a>
		*d++ = *s++;
  800e51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e60:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e63:	8a 12                	mov    (%edx),%dl
  800e65:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e67:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e70:	85 c0                	test   %eax,%eax
  800e72:	75 dd                	jne    800e51 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e77:	c9                   	leave  
  800e78:	c3                   	ret    

00800e79 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e91:	73 50                	jae    800ee3 <memmove+0x6a>
  800e93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e96:	8b 45 10             	mov    0x10(%ebp),%eax
  800e99:	01 d0                	add    %edx,%eax
  800e9b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e9e:	76 43                	jbe    800ee3 <memmove+0x6a>
		s += n;
  800ea0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ea6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eac:	eb 10                	jmp    800ebe <memmove+0x45>
			*--d = *--s;
  800eae:	ff 4d f8             	decl   -0x8(%ebp)
  800eb1:	ff 4d fc             	decl   -0x4(%ebp)
  800eb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb7:	8a 10                	mov    (%eax),%dl
  800eb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ebe:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec7:	85 c0                	test   %eax,%eax
  800ec9:	75 e3                	jne    800eae <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ecb:	eb 23                	jmp    800ef0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ecd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed0:	8d 50 01             	lea    0x1(%eax),%edx
  800ed3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ed6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800edc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800edf:	8a 12                	mov    (%edx),%dl
  800ee1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ee3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee9:	89 55 10             	mov    %edx,0x10(%ebp)
  800eec:	85 c0                	test   %eax,%eax
  800eee:	75 dd                	jne    800ecd <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef3:	c9                   	leave  
  800ef4:	c3                   	ret    

00800ef5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f04:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f07:	eb 2a                	jmp    800f33 <memcmp+0x3e>
		if (*s1 != *s2)
  800f09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0c:	8a 10                	mov    (%eax),%dl
  800f0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f11:	8a 00                	mov    (%eax),%al
  800f13:	38 c2                	cmp    %al,%dl
  800f15:	74 16                	je     800f2d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	0f b6 d0             	movzbl %al,%edx
  800f1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	0f b6 c0             	movzbl %al,%eax
  800f27:	29 c2                	sub    %eax,%edx
  800f29:	89 d0                	mov    %edx,%eax
  800f2b:	eb 18                	jmp    800f45 <memcmp+0x50>
		s1++, s2++;
  800f2d:	ff 45 fc             	incl   -0x4(%ebp)
  800f30:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f33:	8b 45 10             	mov    0x10(%ebp),%eax
  800f36:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f39:	89 55 10             	mov    %edx,0x10(%ebp)
  800f3c:	85 c0                	test   %eax,%eax
  800f3e:	75 c9                	jne    800f09 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f45:	c9                   	leave  
  800f46:	c3                   	ret    

00800f47 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
  800f4a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f50:	8b 45 10             	mov    0x10(%ebp),%eax
  800f53:	01 d0                	add    %edx,%eax
  800f55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f58:	eb 15                	jmp    800f6f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	0f b6 d0             	movzbl %al,%edx
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	0f b6 c0             	movzbl %al,%eax
  800f68:	39 c2                	cmp    %eax,%edx
  800f6a:	74 0d                	je     800f79 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f6c:	ff 45 08             	incl   0x8(%ebp)
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f75:	72 e3                	jb     800f5a <memfind+0x13>
  800f77:	eb 01                	jmp    800f7a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f79:	90                   	nop
	return (void *) s;
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f7d:	c9                   	leave  
  800f7e:	c3                   	ret    

00800f7f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f8c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f93:	eb 03                	jmp    800f98 <strtol+0x19>
		s++;
  800f95:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	3c 20                	cmp    $0x20,%al
  800f9f:	74 f4                	je     800f95 <strtol+0x16>
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	3c 09                	cmp    $0x9,%al
  800fa8:	74 eb                	je     800f95 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3c 2b                	cmp    $0x2b,%al
  800fb1:	75 05                	jne    800fb8 <strtol+0x39>
		s++;
  800fb3:	ff 45 08             	incl   0x8(%ebp)
  800fb6:	eb 13                	jmp    800fcb <strtol+0x4c>
	else if (*s == '-')
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	3c 2d                	cmp    $0x2d,%al
  800fbf:	75 0a                	jne    800fcb <strtol+0x4c>
		s++, neg = 1;
  800fc1:	ff 45 08             	incl   0x8(%ebp)
  800fc4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fcf:	74 06                	je     800fd7 <strtol+0x58>
  800fd1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fd5:	75 20                	jne    800ff7 <strtol+0x78>
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 30                	cmp    $0x30,%al
  800fde:	75 17                	jne    800ff7 <strtol+0x78>
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	40                   	inc    %eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	3c 78                	cmp    $0x78,%al
  800fe8:	75 0d                	jne    800ff7 <strtol+0x78>
		s += 2, base = 16;
  800fea:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fee:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ff5:	eb 28                	jmp    80101f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffb:	75 15                	jne    801012 <strtol+0x93>
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	3c 30                	cmp    $0x30,%al
  801004:	75 0c                	jne    801012 <strtol+0x93>
		s++, base = 8;
  801006:	ff 45 08             	incl   0x8(%ebp)
  801009:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801010:	eb 0d                	jmp    80101f <strtol+0xa0>
	else if (base == 0)
  801012:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801016:	75 07                	jne    80101f <strtol+0xa0>
		base = 10;
  801018:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	8a 00                	mov    (%eax),%al
  801024:	3c 2f                	cmp    $0x2f,%al
  801026:	7e 19                	jle    801041 <strtol+0xc2>
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	3c 39                	cmp    $0x39,%al
  80102f:	7f 10                	jg     801041 <strtol+0xc2>
			dig = *s - '0';
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	8a 00                	mov    (%eax),%al
  801036:	0f be c0             	movsbl %al,%eax
  801039:	83 e8 30             	sub    $0x30,%eax
  80103c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80103f:	eb 42                	jmp    801083 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	8a 00                	mov    (%eax),%al
  801046:	3c 60                	cmp    $0x60,%al
  801048:	7e 19                	jle    801063 <strtol+0xe4>
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	8a 00                	mov    (%eax),%al
  80104f:	3c 7a                	cmp    $0x7a,%al
  801051:	7f 10                	jg     801063 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	0f be c0             	movsbl %al,%eax
  80105b:	83 e8 57             	sub    $0x57,%eax
  80105e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801061:	eb 20                	jmp    801083 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	3c 40                	cmp    $0x40,%al
  80106a:	7e 39                	jle    8010a5 <strtol+0x126>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	3c 5a                	cmp    $0x5a,%al
  801073:	7f 30                	jg     8010a5 <strtol+0x126>
			dig = *s - 'A' + 10;
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	8a 00                	mov    (%eax),%al
  80107a:	0f be c0             	movsbl %al,%eax
  80107d:	83 e8 37             	sub    $0x37,%eax
  801080:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801086:	3b 45 10             	cmp    0x10(%ebp),%eax
  801089:	7d 19                	jge    8010a4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80108b:	ff 45 08             	incl   0x8(%ebp)
  80108e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801091:	0f af 45 10          	imul   0x10(%ebp),%eax
  801095:	89 c2                	mov    %eax,%edx
  801097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80109a:	01 d0                	add    %edx,%eax
  80109c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80109f:	e9 7b ff ff ff       	jmp    80101f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010a4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010a9:	74 08                	je     8010b3 <strtol+0x134>
		*endptr = (char *) s;
  8010ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010b7:	74 07                	je     8010c0 <strtol+0x141>
  8010b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bc:	f7 d8                	neg    %eax
  8010be:	eb 03                	jmp    8010c3 <strtol+0x144>
  8010c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010c3:	c9                   	leave  
  8010c4:	c3                   	ret    

008010c5 <ltostr>:

void
ltostr(long value, char *str)
{
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010dd:	79 13                	jns    8010f2 <ltostr+0x2d>
	{
		neg = 1;
  8010df:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010ec:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010ef:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010fa:	99                   	cltd   
  8010fb:	f7 f9                	idiv   %ecx
  8010fd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801100:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801103:	8d 50 01             	lea    0x1(%eax),%edx
  801106:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801109:	89 c2                	mov    %eax,%edx
  80110b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110e:	01 d0                	add    %edx,%eax
  801110:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801113:	83 c2 30             	add    $0x30,%edx
  801116:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801118:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80111b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801120:	f7 e9                	imul   %ecx
  801122:	c1 fa 02             	sar    $0x2,%edx
  801125:	89 c8                	mov    %ecx,%eax
  801127:	c1 f8 1f             	sar    $0x1f,%eax
  80112a:	29 c2                	sub    %eax,%edx
  80112c:	89 d0                	mov    %edx,%eax
  80112e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801131:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801134:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801139:	f7 e9                	imul   %ecx
  80113b:	c1 fa 02             	sar    $0x2,%edx
  80113e:	89 c8                	mov    %ecx,%eax
  801140:	c1 f8 1f             	sar    $0x1f,%eax
  801143:	29 c2                	sub    %eax,%edx
  801145:	89 d0                	mov    %edx,%eax
  801147:	c1 e0 02             	shl    $0x2,%eax
  80114a:	01 d0                	add    %edx,%eax
  80114c:	01 c0                	add    %eax,%eax
  80114e:	29 c1                	sub    %eax,%ecx
  801150:	89 ca                	mov    %ecx,%edx
  801152:	85 d2                	test   %edx,%edx
  801154:	75 9c                	jne    8010f2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801156:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80115d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801160:	48                   	dec    %eax
  801161:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801164:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801168:	74 3d                	je     8011a7 <ltostr+0xe2>
		start = 1 ;
  80116a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801171:	eb 34                	jmp    8011a7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801173:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801176:	8b 45 0c             	mov    0xc(%ebp),%eax
  801179:	01 d0                	add    %edx,%eax
  80117b:	8a 00                	mov    (%eax),%al
  80117d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801180:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801183:	8b 45 0c             	mov    0xc(%ebp),%eax
  801186:	01 c2                	add    %eax,%edx
  801188:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80118b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118e:	01 c8                	add    %ecx,%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801194:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	01 c2                	add    %eax,%edx
  80119c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80119f:	88 02                	mov    %al,(%edx)
		start++ ;
  8011a1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011a4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011aa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ad:	7c c4                	jl     801173 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011af:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b5:	01 d0                	add    %edx,%eax
  8011b7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011ba:	90                   	nop
  8011bb:	c9                   	leave  
  8011bc:	c3                   	ret    

008011bd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
  8011c0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011c3:	ff 75 08             	pushl  0x8(%ebp)
  8011c6:	e8 54 fa ff ff       	call   800c1f <strlen>
  8011cb:	83 c4 04             	add    $0x4,%esp
  8011ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011d1:	ff 75 0c             	pushl  0xc(%ebp)
  8011d4:	e8 46 fa ff ff       	call   800c1f <strlen>
  8011d9:	83 c4 04             	add    $0x4,%esp
  8011dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ed:	eb 17                	jmp    801206 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f5:	01 c2                	add    %eax,%edx
  8011f7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	01 c8                	add    %ecx,%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801203:	ff 45 fc             	incl   -0x4(%ebp)
  801206:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801209:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80120c:	7c e1                	jl     8011ef <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80120e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801215:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80121c:	eb 1f                	jmp    80123d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80121e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801221:	8d 50 01             	lea    0x1(%eax),%edx
  801224:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801227:	89 c2                	mov    %eax,%edx
  801229:	8b 45 10             	mov    0x10(%ebp),%eax
  80122c:	01 c2                	add    %eax,%edx
  80122e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801231:	8b 45 0c             	mov    0xc(%ebp),%eax
  801234:	01 c8                	add    %ecx,%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80123a:	ff 45 f8             	incl   -0x8(%ebp)
  80123d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801240:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801243:	7c d9                	jl     80121e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801245:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801248:	8b 45 10             	mov    0x10(%ebp),%eax
  80124b:	01 d0                	add    %edx,%eax
  80124d:	c6 00 00             	movb   $0x0,(%eax)
}
  801250:	90                   	nop
  801251:	c9                   	leave  
  801252:	c3                   	ret    

00801253 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801256:	8b 45 14             	mov    0x14(%ebp),%eax
  801259:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80125f:	8b 45 14             	mov    0x14(%ebp),%eax
  801262:	8b 00                	mov    (%eax),%eax
  801264:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80126b:	8b 45 10             	mov    0x10(%ebp),%eax
  80126e:	01 d0                	add    %edx,%eax
  801270:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801276:	eb 0c                	jmp    801284 <strsplit+0x31>
			*string++ = 0;
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	8d 50 01             	lea    0x1(%eax),%edx
  80127e:	89 55 08             	mov    %edx,0x8(%ebp)
  801281:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	84 c0                	test   %al,%al
  80128b:	74 18                	je     8012a5 <strsplit+0x52>
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	0f be c0             	movsbl %al,%eax
  801295:	50                   	push   %eax
  801296:	ff 75 0c             	pushl  0xc(%ebp)
  801299:	e8 13 fb ff ff       	call   800db1 <strchr>
  80129e:	83 c4 08             	add    $0x8,%esp
  8012a1:	85 c0                	test   %eax,%eax
  8012a3:	75 d3                	jne    801278 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	8a 00                	mov    (%eax),%al
  8012aa:	84 c0                	test   %al,%al
  8012ac:	74 5a                	je     801308 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b1:	8b 00                	mov    (%eax),%eax
  8012b3:	83 f8 0f             	cmp    $0xf,%eax
  8012b6:	75 07                	jne    8012bf <strsplit+0x6c>
		{
			return 0;
  8012b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012bd:	eb 66                	jmp    801325 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c2:	8b 00                	mov    (%eax),%eax
  8012c4:	8d 48 01             	lea    0x1(%eax),%ecx
  8012c7:	8b 55 14             	mov    0x14(%ebp),%edx
  8012ca:	89 0a                	mov    %ecx,(%edx)
  8012cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d6:	01 c2                	add    %eax,%edx
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012dd:	eb 03                	jmp    8012e2 <strsplit+0x8f>
			string++;
  8012df:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	84 c0                	test   %al,%al
  8012e9:	74 8b                	je     801276 <strsplit+0x23>
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	8a 00                	mov    (%eax),%al
  8012f0:	0f be c0             	movsbl %al,%eax
  8012f3:	50                   	push   %eax
  8012f4:	ff 75 0c             	pushl  0xc(%ebp)
  8012f7:	e8 b5 fa ff ff       	call   800db1 <strchr>
  8012fc:	83 c4 08             	add    $0x8,%esp
  8012ff:	85 c0                	test   %eax,%eax
  801301:	74 dc                	je     8012df <strsplit+0x8c>
			string++;
	}
  801303:	e9 6e ff ff ff       	jmp    801276 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801308:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801309:	8b 45 14             	mov    0x14(%ebp),%eax
  80130c:	8b 00                	mov    (%eax),%eax
  80130e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801315:	8b 45 10             	mov    0x10(%ebp),%eax
  801318:	01 d0                	add    %edx,%eax
  80131a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801320:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80132d:	a1 04 40 80 00       	mov    0x804004,%eax
  801332:	85 c0                	test   %eax,%eax
  801334:	74 1f                	je     801355 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801336:	e8 1d 00 00 00       	call   801358 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80133b:	83 ec 0c             	sub    $0xc,%esp
  80133e:	68 30 39 80 00       	push   $0x803930
  801343:	e8 55 f2 ff ff       	call   80059d <cprintf>
  801348:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80134b:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801352:	00 00 00 
	}
}
  801355:	90                   	nop
  801356:	c9                   	leave  
  801357:	c3                   	ret    

00801358 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801358:	55                   	push   %ebp
  801359:	89 e5                	mov    %esp,%ebp
  80135b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  80135e:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801365:	00 00 00 
  801368:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80136f:	00 00 00 
  801372:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801379:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80137c:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801383:	00 00 00 
  801386:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80138d:	00 00 00 
  801390:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801397:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  80139a:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8013a1:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  8013a4:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8013ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013b8:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  8013bd:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  8013c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013c7:	a1 20 41 80 00       	mov    0x804120,%eax
  8013cc:	0f af c2             	imul   %edx,%eax
  8013cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  8013d2:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8013d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013df:	01 d0                	add    %edx,%eax
  8013e1:	48                   	dec    %eax
  8013e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8013e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ed:	f7 75 e8             	divl   -0x18(%ebp)
  8013f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013f3:	29 d0                	sub    %edx,%eax
  8013f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  8013f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013fb:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801402:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801405:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80140b:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801411:	83 ec 04             	sub    $0x4,%esp
  801414:	6a 06                	push   $0x6
  801416:	50                   	push   %eax
  801417:	52                   	push   %edx
  801418:	e8 a1 05 00 00       	call   8019be <sys_allocate_chunk>
  80141d:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801420:	a1 20 41 80 00       	mov    0x804120,%eax
  801425:	83 ec 0c             	sub    $0xc,%esp
  801428:	50                   	push   %eax
  801429:	e8 16 0c 00 00       	call   802044 <initialize_MemBlocksList>
  80142e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801431:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801436:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801439:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80143d:	75 14                	jne    801453 <initialize_dyn_block_system+0xfb>
  80143f:	83 ec 04             	sub    $0x4,%esp
  801442:	68 55 39 80 00       	push   $0x803955
  801447:	6a 2d                	push   $0x2d
  801449:	68 73 39 80 00       	push   $0x803973
  80144e:	e8 96 ee ff ff       	call   8002e9 <_panic>
  801453:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801456:	8b 00                	mov    (%eax),%eax
  801458:	85 c0                	test   %eax,%eax
  80145a:	74 10                	je     80146c <initialize_dyn_block_system+0x114>
  80145c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80145f:	8b 00                	mov    (%eax),%eax
  801461:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801464:	8b 52 04             	mov    0x4(%edx),%edx
  801467:	89 50 04             	mov    %edx,0x4(%eax)
  80146a:	eb 0b                	jmp    801477 <initialize_dyn_block_system+0x11f>
  80146c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80146f:	8b 40 04             	mov    0x4(%eax),%eax
  801472:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801477:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80147a:	8b 40 04             	mov    0x4(%eax),%eax
  80147d:	85 c0                	test   %eax,%eax
  80147f:	74 0f                	je     801490 <initialize_dyn_block_system+0x138>
  801481:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801484:	8b 40 04             	mov    0x4(%eax),%eax
  801487:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80148a:	8b 12                	mov    (%edx),%edx
  80148c:	89 10                	mov    %edx,(%eax)
  80148e:	eb 0a                	jmp    80149a <initialize_dyn_block_system+0x142>
  801490:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801493:	8b 00                	mov    (%eax),%eax
  801495:	a3 48 41 80 00       	mov    %eax,0x804148
  80149a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80149d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014ad:	a1 54 41 80 00       	mov    0x804154,%eax
  8014b2:	48                   	dec    %eax
  8014b3:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  8014b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014bb:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  8014c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014c5:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  8014cc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8014d0:	75 14                	jne    8014e6 <initialize_dyn_block_system+0x18e>
  8014d2:	83 ec 04             	sub    $0x4,%esp
  8014d5:	68 80 39 80 00       	push   $0x803980
  8014da:	6a 30                	push   $0x30
  8014dc:	68 73 39 80 00       	push   $0x803973
  8014e1:	e8 03 ee ff ff       	call   8002e9 <_panic>
  8014e6:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8014ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014ef:	89 50 04             	mov    %edx,0x4(%eax)
  8014f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014f5:	8b 40 04             	mov    0x4(%eax),%eax
  8014f8:	85 c0                	test   %eax,%eax
  8014fa:	74 0c                	je     801508 <initialize_dyn_block_system+0x1b0>
  8014fc:	a1 3c 41 80 00       	mov    0x80413c,%eax
  801501:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801504:	89 10                	mov    %edx,(%eax)
  801506:	eb 08                	jmp    801510 <initialize_dyn_block_system+0x1b8>
  801508:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80150b:	a3 38 41 80 00       	mov    %eax,0x804138
  801510:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801513:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801518:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80151b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801521:	a1 44 41 80 00       	mov    0x804144,%eax
  801526:	40                   	inc    %eax
  801527:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80152c:	90                   	nop
  80152d:	c9                   	leave  
  80152e:	c3                   	ret    

0080152f <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
  801532:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801535:	e8 ed fd ff ff       	call   801327 <InitializeUHeap>
	if (size == 0) return NULL ;
  80153a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80153e:	75 07                	jne    801547 <malloc+0x18>
  801540:	b8 00 00 00 00       	mov    $0x0,%eax
  801545:	eb 67                	jmp    8015ae <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801547:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80154e:	8b 55 08             	mov    0x8(%ebp),%edx
  801551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801554:	01 d0                	add    %edx,%eax
  801556:	48                   	dec    %eax
  801557:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80155a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155d:	ba 00 00 00 00       	mov    $0x0,%edx
  801562:	f7 75 f4             	divl   -0xc(%ebp)
  801565:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801568:	29 d0                	sub    %edx,%eax
  80156a:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80156d:	e8 1a 08 00 00       	call   801d8c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801572:	85 c0                	test   %eax,%eax
  801574:	74 33                	je     8015a9 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801576:	83 ec 0c             	sub    $0xc,%esp
  801579:	ff 75 08             	pushl  0x8(%ebp)
  80157c:	e8 0c 0e 00 00       	call   80238d <alloc_block_FF>
  801581:	83 c4 10             	add    $0x10,%esp
  801584:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801587:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80158b:	74 1c                	je     8015a9 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  80158d:	83 ec 0c             	sub    $0xc,%esp
  801590:	ff 75 ec             	pushl  -0x14(%ebp)
  801593:	e8 07 0c 00 00       	call   80219f <insert_sorted_allocList>
  801598:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  80159b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80159e:	8b 40 08             	mov    0x8(%eax),%eax
  8015a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  8015a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015a7:	eb 05                	jmp    8015ae <malloc+0x7f>
		}
	}
	return NULL;
  8015a9:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  8015bc:	83 ec 08             	sub    $0x8,%esp
  8015bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8015c2:	68 40 40 80 00       	push   $0x804040
  8015c7:	e8 5b 0b 00 00       	call   802127 <find_block>
  8015cc:	83 c4 10             	add    $0x10,%esp
  8015cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  8015d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8015d8:	83 ec 08             	sub    $0x8,%esp
  8015db:	50                   	push   %eax
  8015dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8015df:	e8 a2 03 00 00       	call   801986 <sys_free_user_mem>
  8015e4:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  8015e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015eb:	75 14                	jne    801601 <free+0x51>
  8015ed:	83 ec 04             	sub    $0x4,%esp
  8015f0:	68 55 39 80 00       	push   $0x803955
  8015f5:	6a 76                	push   $0x76
  8015f7:	68 73 39 80 00       	push   $0x803973
  8015fc:	e8 e8 ec ff ff       	call   8002e9 <_panic>
  801601:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801604:	8b 00                	mov    (%eax),%eax
  801606:	85 c0                	test   %eax,%eax
  801608:	74 10                	je     80161a <free+0x6a>
  80160a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160d:	8b 00                	mov    (%eax),%eax
  80160f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801612:	8b 52 04             	mov    0x4(%edx),%edx
  801615:	89 50 04             	mov    %edx,0x4(%eax)
  801618:	eb 0b                	jmp    801625 <free+0x75>
  80161a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161d:	8b 40 04             	mov    0x4(%eax),%eax
  801620:	a3 44 40 80 00       	mov    %eax,0x804044
  801625:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801628:	8b 40 04             	mov    0x4(%eax),%eax
  80162b:	85 c0                	test   %eax,%eax
  80162d:	74 0f                	je     80163e <free+0x8e>
  80162f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801632:	8b 40 04             	mov    0x4(%eax),%eax
  801635:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801638:	8b 12                	mov    (%edx),%edx
  80163a:	89 10                	mov    %edx,(%eax)
  80163c:	eb 0a                	jmp    801648 <free+0x98>
  80163e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801641:	8b 00                	mov    (%eax),%eax
  801643:	a3 40 40 80 00       	mov    %eax,0x804040
  801648:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801651:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801654:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80165b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801660:	48                   	dec    %eax
  801661:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  801666:	83 ec 0c             	sub    $0xc,%esp
  801669:	ff 75 f0             	pushl  -0x10(%ebp)
  80166c:	e8 0b 14 00 00       	call   802a7c <insert_sorted_with_merge_freeList>
  801671:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801674:	90                   	nop
  801675:	c9                   	leave  
  801676:	c3                   	ret    

00801677 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	83 ec 28             	sub    $0x28,%esp
  80167d:	8b 45 10             	mov    0x10(%ebp),%eax
  801680:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801683:	e8 9f fc ff ff       	call   801327 <InitializeUHeap>
	if (size == 0) return NULL ;
  801688:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80168c:	75 0a                	jne    801698 <smalloc+0x21>
  80168e:	b8 00 00 00 00       	mov    $0x0,%eax
  801693:	e9 8d 00 00 00       	jmp    801725 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801698:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80169f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a5:	01 d0                	add    %edx,%eax
  8016a7:	48                   	dec    %eax
  8016a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b3:	f7 75 f4             	divl   -0xc(%ebp)
  8016b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b9:	29 d0                	sub    %edx,%eax
  8016bb:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016be:	e8 c9 06 00 00       	call   801d8c <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016c3:	85 c0                	test   %eax,%eax
  8016c5:	74 59                	je     801720 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  8016c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  8016ce:	83 ec 0c             	sub    $0xc,%esp
  8016d1:	ff 75 0c             	pushl  0xc(%ebp)
  8016d4:	e8 b4 0c 00 00       	call   80238d <alloc_block_FF>
  8016d9:	83 c4 10             	add    $0x10,%esp
  8016dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  8016df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016e3:	75 07                	jne    8016ec <smalloc+0x75>
			{
				return NULL;
  8016e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ea:	eb 39                	jmp    801725 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  8016ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ef:	8b 40 08             	mov    0x8(%eax),%eax
  8016f2:	89 c2                	mov    %eax,%edx
  8016f4:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8016f8:	52                   	push   %edx
  8016f9:	50                   	push   %eax
  8016fa:	ff 75 0c             	pushl  0xc(%ebp)
  8016fd:	ff 75 08             	pushl  0x8(%ebp)
  801700:	e8 0c 04 00 00       	call   801b11 <sys_createSharedObject>
  801705:	83 c4 10             	add    $0x10,%esp
  801708:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  80170b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80170f:	78 08                	js     801719 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  801711:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801714:	8b 40 08             	mov    0x8(%eax),%eax
  801717:	eb 0c                	jmp    801725 <smalloc+0xae>
				}
				else
				{
					return NULL;
  801719:	b8 00 00 00 00       	mov    $0x0,%eax
  80171e:	eb 05                	jmp    801725 <smalloc+0xae>
				}
			}

		}
		return NULL;
  801720:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
  80172a:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80172d:	e8 f5 fb ff ff       	call   801327 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801732:	83 ec 08             	sub    $0x8,%esp
  801735:	ff 75 0c             	pushl  0xc(%ebp)
  801738:	ff 75 08             	pushl  0x8(%ebp)
  80173b:	e8 fb 03 00 00       	call   801b3b <sys_getSizeOfSharedObject>
  801740:	83 c4 10             	add    $0x10,%esp
  801743:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801746:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80174a:	75 07                	jne    801753 <sget+0x2c>
	{
		return NULL;
  80174c:	b8 00 00 00 00       	mov    $0x0,%eax
  801751:	eb 64                	jmp    8017b7 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801753:	e8 34 06 00 00       	call   801d8c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801758:	85 c0                	test   %eax,%eax
  80175a:	74 56                	je     8017b2 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  80175c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801766:	83 ec 0c             	sub    $0xc,%esp
  801769:	50                   	push   %eax
  80176a:	e8 1e 0c 00 00       	call   80238d <alloc_block_FF>
  80176f:	83 c4 10             	add    $0x10,%esp
  801772:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801775:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801779:	75 07                	jne    801782 <sget+0x5b>
		{
		return NULL;
  80177b:	b8 00 00 00 00       	mov    $0x0,%eax
  801780:	eb 35                	jmp    8017b7 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801782:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801785:	8b 40 08             	mov    0x8(%eax),%eax
  801788:	83 ec 04             	sub    $0x4,%esp
  80178b:	50                   	push   %eax
  80178c:	ff 75 0c             	pushl  0xc(%ebp)
  80178f:	ff 75 08             	pushl  0x8(%ebp)
  801792:	e8 c1 03 00 00       	call   801b58 <sys_getSharedObject>
  801797:	83 c4 10             	add    $0x10,%esp
  80179a:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  80179d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017a1:	78 08                	js     8017ab <sget+0x84>
			{
				return (void*)v1->sva;
  8017a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a6:	8b 40 08             	mov    0x8(%eax),%eax
  8017a9:	eb 0c                	jmp    8017b7 <sget+0x90>
			}
			else
			{
				return NULL;
  8017ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b0:	eb 05                	jmp    8017b7 <sget+0x90>
			}
		}
	}
  return NULL;
  8017b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b7:	c9                   	leave  
  8017b8:	c3                   	ret    

008017b9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
  8017bc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017bf:	e8 63 fb ff ff       	call   801327 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017c4:	83 ec 04             	sub    $0x4,%esp
  8017c7:	68 a4 39 80 00       	push   $0x8039a4
  8017cc:	68 0e 01 00 00       	push   $0x10e
  8017d1:	68 73 39 80 00       	push   $0x803973
  8017d6:	e8 0e eb ff ff       	call   8002e9 <_panic>

008017db <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017e1:	83 ec 04             	sub    $0x4,%esp
  8017e4:	68 cc 39 80 00       	push   $0x8039cc
  8017e9:	68 22 01 00 00       	push   $0x122
  8017ee:	68 73 39 80 00       	push   $0x803973
  8017f3:	e8 f1 ea ff ff       	call   8002e9 <_panic>

008017f8 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017fe:	83 ec 04             	sub    $0x4,%esp
  801801:	68 f0 39 80 00       	push   $0x8039f0
  801806:	68 2d 01 00 00       	push   $0x12d
  80180b:	68 73 39 80 00       	push   $0x803973
  801810:	e8 d4 ea ff ff       	call   8002e9 <_panic>

00801815 <shrink>:

}
void shrink(uint32 newSize)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
  801818:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80181b:	83 ec 04             	sub    $0x4,%esp
  80181e:	68 f0 39 80 00       	push   $0x8039f0
  801823:	68 32 01 00 00       	push   $0x132
  801828:	68 73 39 80 00       	push   $0x803973
  80182d:	e8 b7 ea ff ff       	call   8002e9 <_panic>

00801832 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801838:	83 ec 04             	sub    $0x4,%esp
  80183b:	68 f0 39 80 00       	push   $0x8039f0
  801840:	68 37 01 00 00       	push   $0x137
  801845:	68 73 39 80 00       	push   $0x803973
  80184a:	e8 9a ea ff ff       	call   8002e9 <_panic>

0080184f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
  801852:	57                   	push   %edi
  801853:	56                   	push   %esi
  801854:	53                   	push   %ebx
  801855:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801858:	8b 45 08             	mov    0x8(%ebp),%eax
  80185b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801861:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801864:	8b 7d 18             	mov    0x18(%ebp),%edi
  801867:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80186a:	cd 30                	int    $0x30
  80186c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80186f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801872:	83 c4 10             	add    $0x10,%esp
  801875:	5b                   	pop    %ebx
  801876:	5e                   	pop    %esi
  801877:	5f                   	pop    %edi
  801878:	5d                   	pop    %ebp
  801879:	c3                   	ret    

0080187a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
  80187d:	83 ec 04             	sub    $0x4,%esp
  801880:	8b 45 10             	mov    0x10(%ebp),%eax
  801883:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801886:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	52                   	push   %edx
  801892:	ff 75 0c             	pushl  0xc(%ebp)
  801895:	50                   	push   %eax
  801896:	6a 00                	push   $0x0
  801898:	e8 b2 ff ff ff       	call   80184f <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
}
  8018a0:	90                   	nop
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 01                	push   $0x1
  8018b2:	e8 98 ff ff ff       	call   80184f <syscall>
  8018b7:	83 c4 18             	add    $0x18,%esp
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	52                   	push   %edx
  8018cc:	50                   	push   %eax
  8018cd:	6a 05                	push   $0x5
  8018cf:	e8 7b ff ff ff       	call   80184f <syscall>
  8018d4:	83 c4 18             	add    $0x18,%esp
}
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
  8018dc:	56                   	push   %esi
  8018dd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018de:	8b 75 18             	mov    0x18(%ebp),%esi
  8018e1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ed:	56                   	push   %esi
  8018ee:	53                   	push   %ebx
  8018ef:	51                   	push   %ecx
  8018f0:	52                   	push   %edx
  8018f1:	50                   	push   %eax
  8018f2:	6a 06                	push   $0x6
  8018f4:	e8 56 ff ff ff       	call   80184f <syscall>
  8018f9:	83 c4 18             	add    $0x18,%esp
}
  8018fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ff:	5b                   	pop    %ebx
  801900:	5e                   	pop    %esi
  801901:	5d                   	pop    %ebp
  801902:	c3                   	ret    

00801903 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801906:	8b 55 0c             	mov    0xc(%ebp),%edx
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	52                   	push   %edx
  801913:	50                   	push   %eax
  801914:	6a 07                	push   $0x7
  801916:	e8 34 ff ff ff       	call   80184f <syscall>
  80191b:	83 c4 18             	add    $0x18,%esp
}
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	ff 75 0c             	pushl  0xc(%ebp)
  80192c:	ff 75 08             	pushl  0x8(%ebp)
  80192f:	6a 08                	push   $0x8
  801931:	e8 19 ff ff ff       	call   80184f <syscall>
  801936:	83 c4 18             	add    $0x18,%esp
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 09                	push   $0x9
  80194a:	e8 00 ff ff ff       	call   80184f <syscall>
  80194f:	83 c4 18             	add    $0x18,%esp
}
  801952:	c9                   	leave  
  801953:	c3                   	ret    

00801954 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 0a                	push   $0xa
  801963:	e8 e7 fe ff ff       	call   80184f <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 0b                	push   $0xb
  80197c:	e8 ce fe ff ff       	call   80184f <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	ff 75 0c             	pushl  0xc(%ebp)
  801992:	ff 75 08             	pushl  0x8(%ebp)
  801995:	6a 0f                	push   $0xf
  801997:	e8 b3 fe ff ff       	call   80184f <syscall>
  80199c:	83 c4 18             	add    $0x18,%esp
	return;
  80199f:	90                   	nop
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	ff 75 0c             	pushl  0xc(%ebp)
  8019ae:	ff 75 08             	pushl  0x8(%ebp)
  8019b1:	6a 10                	push   $0x10
  8019b3:	e8 97 fe ff ff       	call   80184f <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8019bb:	90                   	nop
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	ff 75 10             	pushl  0x10(%ebp)
  8019c8:	ff 75 0c             	pushl  0xc(%ebp)
  8019cb:	ff 75 08             	pushl  0x8(%ebp)
  8019ce:	6a 11                	push   $0x11
  8019d0:	e8 7a fe ff ff       	call   80184f <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d8:	90                   	nop
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 0c                	push   $0xc
  8019ea:	e8 60 fe ff ff       	call   80184f <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	ff 75 08             	pushl  0x8(%ebp)
  801a02:	6a 0d                	push   $0xd
  801a04:	e8 46 fe ff ff       	call   80184f <syscall>
  801a09:	83 c4 18             	add    $0x18,%esp
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 0e                	push   $0xe
  801a1d:	e8 2d fe ff ff       	call   80184f <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
}
  801a25:	90                   	nop
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 13                	push   $0x13
  801a37:	e8 13 fe ff ff       	call   80184f <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
}
  801a3f:	90                   	nop
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 14                	push   $0x14
  801a51:	e8 f9 fd ff ff       	call   80184f <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
}
  801a59:	90                   	nop
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <sys_cputc>:


void
sys_cputc(const char c)
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
  801a5f:	83 ec 04             	sub    $0x4,%esp
  801a62:	8b 45 08             	mov    0x8(%ebp),%eax
  801a65:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a68:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	50                   	push   %eax
  801a75:	6a 15                	push   $0x15
  801a77:	e8 d3 fd ff ff       	call   80184f <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
}
  801a7f:	90                   	nop
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    

00801a82 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 16                	push   $0x16
  801a91:	e8 b9 fd ff ff       	call   80184f <syscall>
  801a96:	83 c4 18             	add    $0x18,%esp
}
  801a99:	90                   	nop
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    

00801a9c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	ff 75 0c             	pushl  0xc(%ebp)
  801aab:	50                   	push   %eax
  801aac:	6a 17                	push   $0x17
  801aae:	e8 9c fd ff ff       	call   80184f <syscall>
  801ab3:	83 c4 18             	add    $0x18,%esp
}
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801abb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	52                   	push   %edx
  801ac8:	50                   	push   %eax
  801ac9:	6a 1a                	push   $0x1a
  801acb:	e8 7f fd ff ff       	call   80184f <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ad8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801adb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	52                   	push   %edx
  801ae5:	50                   	push   %eax
  801ae6:	6a 18                	push   $0x18
  801ae8:	e8 62 fd ff ff       	call   80184f <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
}
  801af0:	90                   	nop
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801af6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af9:	8b 45 08             	mov    0x8(%ebp),%eax
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	52                   	push   %edx
  801b03:	50                   	push   %eax
  801b04:	6a 19                	push   $0x19
  801b06:	e8 44 fd ff ff       	call   80184f <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
}
  801b0e:	90                   	nop
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	83 ec 04             	sub    $0x4,%esp
  801b17:	8b 45 10             	mov    0x10(%ebp),%eax
  801b1a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b1d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b20:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b24:	8b 45 08             	mov    0x8(%ebp),%eax
  801b27:	6a 00                	push   $0x0
  801b29:	51                   	push   %ecx
  801b2a:	52                   	push   %edx
  801b2b:	ff 75 0c             	pushl  0xc(%ebp)
  801b2e:	50                   	push   %eax
  801b2f:	6a 1b                	push   $0x1b
  801b31:	e8 19 fd ff ff       	call   80184f <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b41:	8b 45 08             	mov    0x8(%ebp),%eax
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	52                   	push   %edx
  801b4b:	50                   	push   %eax
  801b4c:	6a 1c                	push   $0x1c
  801b4e:	e8 fc fc ff ff       	call   80184f <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b61:	8b 45 08             	mov    0x8(%ebp),%eax
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	51                   	push   %ecx
  801b69:	52                   	push   %edx
  801b6a:	50                   	push   %eax
  801b6b:	6a 1d                	push   $0x1d
  801b6d:	e8 dd fc ff ff       	call   80184f <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	52                   	push   %edx
  801b87:	50                   	push   %eax
  801b88:	6a 1e                	push   $0x1e
  801b8a:	e8 c0 fc ff ff       	call   80184f <syscall>
  801b8f:	83 c4 18             	add    $0x18,%esp
}
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 1f                	push   $0x1f
  801ba3:	e8 a7 fc ff ff       	call   80184f <syscall>
  801ba8:	83 c4 18             	add    $0x18,%esp
}
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	6a 00                	push   $0x0
  801bb5:	ff 75 14             	pushl  0x14(%ebp)
  801bb8:	ff 75 10             	pushl  0x10(%ebp)
  801bbb:	ff 75 0c             	pushl  0xc(%ebp)
  801bbe:	50                   	push   %eax
  801bbf:	6a 20                	push   $0x20
  801bc1:	e8 89 fc ff ff       	call   80184f <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bce:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	50                   	push   %eax
  801bda:	6a 21                	push   $0x21
  801bdc:	e8 6e fc ff ff       	call   80184f <syscall>
  801be1:	83 c4 18             	add    $0x18,%esp
}
  801be4:	90                   	nop
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bea:	8b 45 08             	mov    0x8(%ebp),%eax
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	50                   	push   %eax
  801bf6:	6a 22                	push   $0x22
  801bf8:	e8 52 fc ff ff       	call   80184f <syscall>
  801bfd:	83 c4 18             	add    $0x18,%esp
}
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 02                	push   $0x2
  801c11:	e8 39 fc ff ff       	call   80184f <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 03                	push   $0x3
  801c2a:	e8 20 fc ff ff       	call   80184f <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 04                	push   $0x4
  801c43:	e8 07 fc ff ff       	call   80184f <syscall>
  801c48:	83 c4 18             	add    $0x18,%esp
}
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <sys_exit_env>:


void sys_exit_env(void)
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 23                	push   $0x23
  801c5c:	e8 ee fb ff ff       	call   80184f <syscall>
  801c61:	83 c4 18             	add    $0x18,%esp
}
  801c64:	90                   	nop
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
  801c6a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c6d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c70:	8d 50 04             	lea    0x4(%eax),%edx
  801c73:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	52                   	push   %edx
  801c7d:	50                   	push   %eax
  801c7e:	6a 24                	push   $0x24
  801c80:	e8 ca fb ff ff       	call   80184f <syscall>
  801c85:	83 c4 18             	add    $0x18,%esp
	return result;
  801c88:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c8e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c91:	89 01                	mov    %eax,(%ecx)
  801c93:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	c9                   	leave  
  801c9a:	c2 04 00             	ret    $0x4

00801c9d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	ff 75 10             	pushl  0x10(%ebp)
  801ca7:	ff 75 0c             	pushl  0xc(%ebp)
  801caa:	ff 75 08             	pushl  0x8(%ebp)
  801cad:	6a 12                	push   $0x12
  801caf:	e8 9b fb ff ff       	call   80184f <syscall>
  801cb4:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb7:	90                   	nop
}
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <sys_rcr2>:
uint32 sys_rcr2()
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 25                	push   $0x25
  801cc9:	e8 81 fb ff ff       	call   80184f <syscall>
  801cce:	83 c4 18             	add    $0x18,%esp
}
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	83 ec 04             	sub    $0x4,%esp
  801cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cdf:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	50                   	push   %eax
  801cec:	6a 26                	push   $0x26
  801cee:	e8 5c fb ff ff       	call   80184f <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf6:	90                   	nop
}
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <rsttst>:
void rsttst()
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 28                	push   $0x28
  801d08:	e8 42 fb ff ff       	call   80184f <syscall>
  801d0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d10:	90                   	nop
}
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
  801d16:	83 ec 04             	sub    $0x4,%esp
  801d19:	8b 45 14             	mov    0x14(%ebp),%eax
  801d1c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d1f:	8b 55 18             	mov    0x18(%ebp),%edx
  801d22:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d26:	52                   	push   %edx
  801d27:	50                   	push   %eax
  801d28:	ff 75 10             	pushl  0x10(%ebp)
  801d2b:	ff 75 0c             	pushl  0xc(%ebp)
  801d2e:	ff 75 08             	pushl  0x8(%ebp)
  801d31:	6a 27                	push   $0x27
  801d33:	e8 17 fb ff ff       	call   80184f <syscall>
  801d38:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3b:	90                   	nop
}
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <chktst>:
void chktst(uint32 n)
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	ff 75 08             	pushl  0x8(%ebp)
  801d4c:	6a 29                	push   $0x29
  801d4e:	e8 fc fa ff ff       	call   80184f <syscall>
  801d53:	83 c4 18             	add    $0x18,%esp
	return ;
  801d56:	90                   	nop
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <inctst>:

void inctst()
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 2a                	push   $0x2a
  801d68:	e8 e2 fa ff ff       	call   80184f <syscall>
  801d6d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d70:	90                   	nop
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <gettst>:
uint32 gettst()
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 2b                	push   $0x2b
  801d82:	e8 c8 fa ff ff       	call   80184f <syscall>
  801d87:	83 c4 18             	add    $0x18,%esp
}
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 2c                	push   $0x2c
  801d9e:	e8 ac fa ff ff       	call   80184f <syscall>
  801da3:	83 c4 18             	add    $0x18,%esp
  801da6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801da9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dad:	75 07                	jne    801db6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801daf:	b8 01 00 00 00       	mov    $0x1,%eax
  801db4:	eb 05                	jmp    801dbb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801db6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbb:	c9                   	leave  
  801dbc:	c3                   	ret    

00801dbd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
  801dc0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 2c                	push   $0x2c
  801dcf:	e8 7b fa ff ff       	call   80184f <syscall>
  801dd4:	83 c4 18             	add    $0x18,%esp
  801dd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dda:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dde:	75 07                	jne    801de7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801de0:	b8 01 00 00 00       	mov    $0x1,%eax
  801de5:	eb 05                	jmp    801dec <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801de7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
  801df1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 2c                	push   $0x2c
  801e00:	e8 4a fa ff ff       	call   80184f <syscall>
  801e05:	83 c4 18             	add    $0x18,%esp
  801e08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e0b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e0f:	75 07                	jne    801e18 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e11:	b8 01 00 00 00       	mov    $0x1,%eax
  801e16:	eb 05                	jmp    801e1d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1d:	c9                   	leave  
  801e1e:	c3                   	ret    

00801e1f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
  801e22:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 2c                	push   $0x2c
  801e31:	e8 19 fa ff ff       	call   80184f <syscall>
  801e36:	83 c4 18             	add    $0x18,%esp
  801e39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e3c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e40:	75 07                	jne    801e49 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e42:	b8 01 00 00 00       	mov    $0x1,%eax
  801e47:	eb 05                	jmp    801e4e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	ff 75 08             	pushl  0x8(%ebp)
  801e5e:	6a 2d                	push   $0x2d
  801e60:	e8 ea f9 ff ff       	call   80184f <syscall>
  801e65:	83 c4 18             	add    $0x18,%esp
	return ;
  801e68:	90                   	nop
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
  801e6e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e6f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e72:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e78:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7b:	6a 00                	push   $0x0
  801e7d:	53                   	push   %ebx
  801e7e:	51                   	push   %ecx
  801e7f:	52                   	push   %edx
  801e80:	50                   	push   %eax
  801e81:	6a 2e                	push   $0x2e
  801e83:	e8 c7 f9 ff ff       	call   80184f <syscall>
  801e88:	83 c4 18             	add    $0x18,%esp
}
  801e8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e8e:	c9                   	leave  
  801e8f:	c3                   	ret    

00801e90 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e96:	8b 45 08             	mov    0x8(%ebp),%eax
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	52                   	push   %edx
  801ea0:	50                   	push   %eax
  801ea1:	6a 2f                	push   $0x2f
  801ea3:	e8 a7 f9 ff ff       	call   80184f <syscall>
  801ea8:	83 c4 18             	add    $0x18,%esp
}
  801eab:	c9                   	leave  
  801eac:	c3                   	ret    

00801ead <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
  801eb0:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801eb3:	83 ec 0c             	sub    $0xc,%esp
  801eb6:	68 00 3a 80 00       	push   $0x803a00
  801ebb:	e8 dd e6 ff ff       	call   80059d <cprintf>
  801ec0:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ec3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801eca:	83 ec 0c             	sub    $0xc,%esp
  801ecd:	68 2c 3a 80 00       	push   $0x803a2c
  801ed2:	e8 c6 e6 ff ff       	call   80059d <cprintf>
  801ed7:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801eda:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ede:	a1 38 41 80 00       	mov    0x804138,%eax
  801ee3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee6:	eb 56                	jmp    801f3e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ee8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eec:	74 1c                	je     801f0a <print_mem_block_lists+0x5d>
  801eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef1:	8b 50 08             	mov    0x8(%eax),%edx
  801ef4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef7:	8b 48 08             	mov    0x8(%eax),%ecx
  801efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801efd:	8b 40 0c             	mov    0xc(%eax),%eax
  801f00:	01 c8                	add    %ecx,%eax
  801f02:	39 c2                	cmp    %eax,%edx
  801f04:	73 04                	jae    801f0a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f06:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0d:	8b 50 08             	mov    0x8(%eax),%edx
  801f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f13:	8b 40 0c             	mov    0xc(%eax),%eax
  801f16:	01 c2                	add    %eax,%edx
  801f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1b:	8b 40 08             	mov    0x8(%eax),%eax
  801f1e:	83 ec 04             	sub    $0x4,%esp
  801f21:	52                   	push   %edx
  801f22:	50                   	push   %eax
  801f23:	68 41 3a 80 00       	push   $0x803a41
  801f28:	e8 70 e6 ff ff       	call   80059d <cprintf>
  801f2d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f33:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f36:	a1 40 41 80 00       	mov    0x804140,%eax
  801f3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f42:	74 07                	je     801f4b <print_mem_block_lists+0x9e>
  801f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f47:	8b 00                	mov    (%eax),%eax
  801f49:	eb 05                	jmp    801f50 <print_mem_block_lists+0xa3>
  801f4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f50:	a3 40 41 80 00       	mov    %eax,0x804140
  801f55:	a1 40 41 80 00       	mov    0x804140,%eax
  801f5a:	85 c0                	test   %eax,%eax
  801f5c:	75 8a                	jne    801ee8 <print_mem_block_lists+0x3b>
  801f5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f62:	75 84                	jne    801ee8 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f64:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f68:	75 10                	jne    801f7a <print_mem_block_lists+0xcd>
  801f6a:	83 ec 0c             	sub    $0xc,%esp
  801f6d:	68 50 3a 80 00       	push   $0x803a50
  801f72:	e8 26 e6 ff ff       	call   80059d <cprintf>
  801f77:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f7a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f81:	83 ec 0c             	sub    $0xc,%esp
  801f84:	68 74 3a 80 00       	push   $0x803a74
  801f89:	e8 0f e6 ff ff       	call   80059d <cprintf>
  801f8e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f91:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f95:	a1 40 40 80 00       	mov    0x804040,%eax
  801f9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f9d:	eb 56                	jmp    801ff5 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f9f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fa3:	74 1c                	je     801fc1 <print_mem_block_lists+0x114>
  801fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa8:	8b 50 08             	mov    0x8(%eax),%edx
  801fab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fae:	8b 48 08             	mov    0x8(%eax),%ecx
  801fb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb4:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb7:	01 c8                	add    %ecx,%eax
  801fb9:	39 c2                	cmp    %eax,%edx
  801fbb:	73 04                	jae    801fc1 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fbd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc4:	8b 50 08             	mov    0x8(%eax),%edx
  801fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fca:	8b 40 0c             	mov    0xc(%eax),%eax
  801fcd:	01 c2                	add    %eax,%edx
  801fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd2:	8b 40 08             	mov    0x8(%eax),%eax
  801fd5:	83 ec 04             	sub    $0x4,%esp
  801fd8:	52                   	push   %edx
  801fd9:	50                   	push   %eax
  801fda:	68 41 3a 80 00       	push   $0x803a41
  801fdf:	e8 b9 e5 ff ff       	call   80059d <cprintf>
  801fe4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fed:	a1 48 40 80 00       	mov    0x804048,%eax
  801ff2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff9:	74 07                	je     802002 <print_mem_block_lists+0x155>
  801ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffe:	8b 00                	mov    (%eax),%eax
  802000:	eb 05                	jmp    802007 <print_mem_block_lists+0x15a>
  802002:	b8 00 00 00 00       	mov    $0x0,%eax
  802007:	a3 48 40 80 00       	mov    %eax,0x804048
  80200c:	a1 48 40 80 00       	mov    0x804048,%eax
  802011:	85 c0                	test   %eax,%eax
  802013:	75 8a                	jne    801f9f <print_mem_block_lists+0xf2>
  802015:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802019:	75 84                	jne    801f9f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80201b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80201f:	75 10                	jne    802031 <print_mem_block_lists+0x184>
  802021:	83 ec 0c             	sub    $0xc,%esp
  802024:	68 8c 3a 80 00       	push   $0x803a8c
  802029:	e8 6f e5 ff ff       	call   80059d <cprintf>
  80202e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802031:	83 ec 0c             	sub    $0xc,%esp
  802034:	68 00 3a 80 00       	push   $0x803a00
  802039:	e8 5f e5 ff ff       	call   80059d <cprintf>
  80203e:	83 c4 10             	add    $0x10,%esp

}
  802041:	90                   	nop
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  802050:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802057:	00 00 00 
  80205a:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802061:	00 00 00 
  802064:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80206b:	00 00 00 
	for(int i = 0; i<n;i++)
  80206e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802075:	e9 9e 00 00 00       	jmp    802118 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80207a:	a1 50 40 80 00       	mov    0x804050,%eax
  80207f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802082:	c1 e2 04             	shl    $0x4,%edx
  802085:	01 d0                	add    %edx,%eax
  802087:	85 c0                	test   %eax,%eax
  802089:	75 14                	jne    80209f <initialize_MemBlocksList+0x5b>
  80208b:	83 ec 04             	sub    $0x4,%esp
  80208e:	68 b4 3a 80 00       	push   $0x803ab4
  802093:	6a 47                	push   $0x47
  802095:	68 d7 3a 80 00       	push   $0x803ad7
  80209a:	e8 4a e2 ff ff       	call   8002e9 <_panic>
  80209f:	a1 50 40 80 00       	mov    0x804050,%eax
  8020a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a7:	c1 e2 04             	shl    $0x4,%edx
  8020aa:	01 d0                	add    %edx,%eax
  8020ac:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020b2:	89 10                	mov    %edx,(%eax)
  8020b4:	8b 00                	mov    (%eax),%eax
  8020b6:	85 c0                	test   %eax,%eax
  8020b8:	74 18                	je     8020d2 <initialize_MemBlocksList+0x8e>
  8020ba:	a1 48 41 80 00       	mov    0x804148,%eax
  8020bf:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020c5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020c8:	c1 e1 04             	shl    $0x4,%ecx
  8020cb:	01 ca                	add    %ecx,%edx
  8020cd:	89 50 04             	mov    %edx,0x4(%eax)
  8020d0:	eb 12                	jmp    8020e4 <initialize_MemBlocksList+0xa0>
  8020d2:	a1 50 40 80 00       	mov    0x804050,%eax
  8020d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020da:	c1 e2 04             	shl    $0x4,%edx
  8020dd:	01 d0                	add    %edx,%eax
  8020df:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020e4:	a1 50 40 80 00       	mov    0x804050,%eax
  8020e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ec:	c1 e2 04             	shl    $0x4,%edx
  8020ef:	01 d0                	add    %edx,%eax
  8020f1:	a3 48 41 80 00       	mov    %eax,0x804148
  8020f6:	a1 50 40 80 00       	mov    0x804050,%eax
  8020fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020fe:	c1 e2 04             	shl    $0x4,%edx
  802101:	01 d0                	add    %edx,%eax
  802103:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80210a:	a1 54 41 80 00       	mov    0x804154,%eax
  80210f:	40                   	inc    %eax
  802110:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  802115:	ff 45 f4             	incl   -0xc(%ebp)
  802118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80211e:	0f 82 56 ff ff ff    	jb     80207a <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  802124:	90                   	nop
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
  80212a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  80212d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802130:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  802133:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80213a:	a1 40 40 80 00       	mov    0x804040,%eax
  80213f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802142:	eb 23                	jmp    802167 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802144:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802147:	8b 40 08             	mov    0x8(%eax),%eax
  80214a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80214d:	75 09                	jne    802158 <find_block+0x31>
		{
			found = 1;
  80214f:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802156:	eb 35                	jmp    80218d <find_block+0x66>
		}
		else
		{
			found = 0;
  802158:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80215f:	a1 48 40 80 00       	mov    0x804048,%eax
  802164:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802167:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80216b:	74 07                	je     802174 <find_block+0x4d>
  80216d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802170:	8b 00                	mov    (%eax),%eax
  802172:	eb 05                	jmp    802179 <find_block+0x52>
  802174:	b8 00 00 00 00       	mov    $0x0,%eax
  802179:	a3 48 40 80 00       	mov    %eax,0x804048
  80217e:	a1 48 40 80 00       	mov    0x804048,%eax
  802183:	85 c0                	test   %eax,%eax
  802185:	75 bd                	jne    802144 <find_block+0x1d>
  802187:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80218b:	75 b7                	jne    802144 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  80218d:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802191:	75 05                	jne    802198 <find_block+0x71>
	{
		return blk;
  802193:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802196:	eb 05                	jmp    80219d <find_block+0x76>
	}
	else
	{
		return NULL;
  802198:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  80219d:	c9                   	leave  
  80219e:	c3                   	ret    

0080219f <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80219f:	55                   	push   %ebp
  8021a0:	89 e5                	mov    %esp,%ebp
  8021a2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  8021a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a8:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  8021ab:	a1 40 40 80 00       	mov    0x804040,%eax
  8021b0:	85 c0                	test   %eax,%eax
  8021b2:	74 12                	je     8021c6 <insert_sorted_allocList+0x27>
  8021b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b7:	8b 50 08             	mov    0x8(%eax),%edx
  8021ba:	a1 40 40 80 00       	mov    0x804040,%eax
  8021bf:	8b 40 08             	mov    0x8(%eax),%eax
  8021c2:	39 c2                	cmp    %eax,%edx
  8021c4:	73 65                	jae    80222b <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  8021c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021ca:	75 14                	jne    8021e0 <insert_sorted_allocList+0x41>
  8021cc:	83 ec 04             	sub    $0x4,%esp
  8021cf:	68 b4 3a 80 00       	push   $0x803ab4
  8021d4:	6a 7b                	push   $0x7b
  8021d6:	68 d7 3a 80 00       	push   $0x803ad7
  8021db:	e8 09 e1 ff ff       	call   8002e9 <_panic>
  8021e0:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e9:	89 10                	mov    %edx,(%eax)
  8021eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ee:	8b 00                	mov    (%eax),%eax
  8021f0:	85 c0                	test   %eax,%eax
  8021f2:	74 0d                	je     802201 <insert_sorted_allocList+0x62>
  8021f4:	a1 40 40 80 00       	mov    0x804040,%eax
  8021f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021fc:	89 50 04             	mov    %edx,0x4(%eax)
  8021ff:	eb 08                	jmp    802209 <insert_sorted_allocList+0x6a>
  802201:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802204:	a3 44 40 80 00       	mov    %eax,0x804044
  802209:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220c:	a3 40 40 80 00       	mov    %eax,0x804040
  802211:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802214:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80221b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802220:	40                   	inc    %eax
  802221:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802226:	e9 5f 01 00 00       	jmp    80238a <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  80222b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222e:	8b 50 08             	mov    0x8(%eax),%edx
  802231:	a1 44 40 80 00       	mov    0x804044,%eax
  802236:	8b 40 08             	mov    0x8(%eax),%eax
  802239:	39 c2                	cmp    %eax,%edx
  80223b:	76 65                	jbe    8022a2 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  80223d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802241:	75 14                	jne    802257 <insert_sorted_allocList+0xb8>
  802243:	83 ec 04             	sub    $0x4,%esp
  802246:	68 f0 3a 80 00       	push   $0x803af0
  80224b:	6a 7f                	push   $0x7f
  80224d:	68 d7 3a 80 00       	push   $0x803ad7
  802252:	e8 92 e0 ff ff       	call   8002e9 <_panic>
  802257:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80225d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802260:	89 50 04             	mov    %edx,0x4(%eax)
  802263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802266:	8b 40 04             	mov    0x4(%eax),%eax
  802269:	85 c0                	test   %eax,%eax
  80226b:	74 0c                	je     802279 <insert_sorted_allocList+0xda>
  80226d:	a1 44 40 80 00       	mov    0x804044,%eax
  802272:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802275:	89 10                	mov    %edx,(%eax)
  802277:	eb 08                	jmp    802281 <insert_sorted_allocList+0xe2>
  802279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227c:	a3 40 40 80 00       	mov    %eax,0x804040
  802281:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802284:	a3 44 40 80 00       	mov    %eax,0x804044
  802289:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802292:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802297:	40                   	inc    %eax
  802298:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80229d:	e9 e8 00 00 00       	jmp    80238a <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8022a2:	a1 40 40 80 00       	mov    0x804040,%eax
  8022a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022aa:	e9 ab 00 00 00       	jmp    80235a <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  8022af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b2:	8b 00                	mov    (%eax),%eax
  8022b4:	85 c0                	test   %eax,%eax
  8022b6:	0f 84 96 00 00 00    	je     802352 <insert_sorted_allocList+0x1b3>
  8022bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022bf:	8b 50 08             	mov    0x8(%eax),%edx
  8022c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c5:	8b 40 08             	mov    0x8(%eax),%eax
  8022c8:	39 c2                	cmp    %eax,%edx
  8022ca:	0f 86 82 00 00 00    	jbe    802352 <insert_sorted_allocList+0x1b3>
  8022d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d3:	8b 50 08             	mov    0x8(%eax),%edx
  8022d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d9:	8b 00                	mov    (%eax),%eax
  8022db:	8b 40 08             	mov    0x8(%eax),%eax
  8022de:	39 c2                	cmp    %eax,%edx
  8022e0:	73 70                	jae    802352 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  8022e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e6:	74 06                	je     8022ee <insert_sorted_allocList+0x14f>
  8022e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022ec:	75 17                	jne    802305 <insert_sorted_allocList+0x166>
  8022ee:	83 ec 04             	sub    $0x4,%esp
  8022f1:	68 14 3b 80 00       	push   $0x803b14
  8022f6:	68 87 00 00 00       	push   $0x87
  8022fb:	68 d7 3a 80 00       	push   $0x803ad7
  802300:	e8 e4 df ff ff       	call   8002e9 <_panic>
  802305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802308:	8b 10                	mov    (%eax),%edx
  80230a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80230d:	89 10                	mov    %edx,(%eax)
  80230f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802312:	8b 00                	mov    (%eax),%eax
  802314:	85 c0                	test   %eax,%eax
  802316:	74 0b                	je     802323 <insert_sorted_allocList+0x184>
  802318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231b:	8b 00                	mov    (%eax),%eax
  80231d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802320:	89 50 04             	mov    %edx,0x4(%eax)
  802323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802326:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802329:	89 10                	mov    %edx,(%eax)
  80232b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802331:	89 50 04             	mov    %edx,0x4(%eax)
  802334:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802337:	8b 00                	mov    (%eax),%eax
  802339:	85 c0                	test   %eax,%eax
  80233b:	75 08                	jne    802345 <insert_sorted_allocList+0x1a6>
  80233d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802340:	a3 44 40 80 00       	mov    %eax,0x804044
  802345:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80234a:	40                   	inc    %eax
  80234b:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802350:	eb 38                	jmp    80238a <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802352:	a1 48 40 80 00       	mov    0x804048,%eax
  802357:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80235a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80235e:	74 07                	je     802367 <insert_sorted_allocList+0x1c8>
  802360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802363:	8b 00                	mov    (%eax),%eax
  802365:	eb 05                	jmp    80236c <insert_sorted_allocList+0x1cd>
  802367:	b8 00 00 00 00       	mov    $0x0,%eax
  80236c:	a3 48 40 80 00       	mov    %eax,0x804048
  802371:	a1 48 40 80 00       	mov    0x804048,%eax
  802376:	85 c0                	test   %eax,%eax
  802378:	0f 85 31 ff ff ff    	jne    8022af <insert_sorted_allocList+0x110>
  80237e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802382:	0f 85 27 ff ff ff    	jne    8022af <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802388:	eb 00                	jmp    80238a <insert_sorted_allocList+0x1eb>
  80238a:	90                   	nop
  80238b:	c9                   	leave  
  80238c:	c3                   	ret    

0080238d <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80238d:	55                   	push   %ebp
  80238e:	89 e5                	mov    %esp,%ebp
  802390:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802393:	8b 45 08             	mov    0x8(%ebp),%eax
  802396:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802399:	a1 48 41 80 00       	mov    0x804148,%eax
  80239e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8023a1:	a1 38 41 80 00       	mov    0x804138,%eax
  8023a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a9:	e9 77 01 00 00       	jmp    802525 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  8023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8023b7:	0f 85 8a 00 00 00    	jne    802447 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8023bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c1:	75 17                	jne    8023da <alloc_block_FF+0x4d>
  8023c3:	83 ec 04             	sub    $0x4,%esp
  8023c6:	68 48 3b 80 00       	push   $0x803b48
  8023cb:	68 9e 00 00 00       	push   $0x9e
  8023d0:	68 d7 3a 80 00       	push   $0x803ad7
  8023d5:	e8 0f df ff ff       	call   8002e9 <_panic>
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	8b 00                	mov    (%eax),%eax
  8023df:	85 c0                	test   %eax,%eax
  8023e1:	74 10                	je     8023f3 <alloc_block_FF+0x66>
  8023e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e6:	8b 00                	mov    (%eax),%eax
  8023e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023eb:	8b 52 04             	mov    0x4(%edx),%edx
  8023ee:	89 50 04             	mov    %edx,0x4(%eax)
  8023f1:	eb 0b                	jmp    8023fe <alloc_block_FF+0x71>
  8023f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f6:	8b 40 04             	mov    0x4(%eax),%eax
  8023f9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802401:	8b 40 04             	mov    0x4(%eax),%eax
  802404:	85 c0                	test   %eax,%eax
  802406:	74 0f                	je     802417 <alloc_block_FF+0x8a>
  802408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240b:	8b 40 04             	mov    0x4(%eax),%eax
  80240e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802411:	8b 12                	mov    (%edx),%edx
  802413:	89 10                	mov    %edx,(%eax)
  802415:	eb 0a                	jmp    802421 <alloc_block_FF+0x94>
  802417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241a:	8b 00                	mov    (%eax),%eax
  80241c:	a3 38 41 80 00       	mov    %eax,0x804138
  802421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802424:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80242a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802434:	a1 44 41 80 00       	mov    0x804144,%eax
  802439:	48                   	dec    %eax
  80243a:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  80243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802442:	e9 11 01 00 00       	jmp    802558 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244a:	8b 40 0c             	mov    0xc(%eax),%eax
  80244d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802450:	0f 86 c7 00 00 00    	jbe    80251d <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802456:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80245a:	75 17                	jne    802473 <alloc_block_FF+0xe6>
  80245c:	83 ec 04             	sub    $0x4,%esp
  80245f:	68 48 3b 80 00       	push   $0x803b48
  802464:	68 a3 00 00 00       	push   $0xa3
  802469:	68 d7 3a 80 00       	push   $0x803ad7
  80246e:	e8 76 de ff ff       	call   8002e9 <_panic>
  802473:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802476:	8b 00                	mov    (%eax),%eax
  802478:	85 c0                	test   %eax,%eax
  80247a:	74 10                	je     80248c <alloc_block_FF+0xff>
  80247c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80247f:	8b 00                	mov    (%eax),%eax
  802481:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802484:	8b 52 04             	mov    0x4(%edx),%edx
  802487:	89 50 04             	mov    %edx,0x4(%eax)
  80248a:	eb 0b                	jmp    802497 <alloc_block_FF+0x10a>
  80248c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80248f:	8b 40 04             	mov    0x4(%eax),%eax
  802492:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802497:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80249a:	8b 40 04             	mov    0x4(%eax),%eax
  80249d:	85 c0                	test   %eax,%eax
  80249f:	74 0f                	je     8024b0 <alloc_block_FF+0x123>
  8024a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a4:	8b 40 04             	mov    0x4(%eax),%eax
  8024a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024aa:	8b 12                	mov    (%edx),%edx
  8024ac:	89 10                	mov    %edx,(%eax)
  8024ae:	eb 0a                	jmp    8024ba <alloc_block_FF+0x12d>
  8024b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b3:	8b 00                	mov    (%eax),%eax
  8024b5:	a3 48 41 80 00       	mov    %eax,0x804148
  8024ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024cd:	a1 54 41 80 00       	mov    0x804154,%eax
  8024d2:	48                   	dec    %eax
  8024d3:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8024d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024de:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8024e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e7:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8024ea:	89 c2                	mov    %eax,%edx
  8024ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ef:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8024f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f5:	8b 40 08             	mov    0x8(%eax),%eax
  8024f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8024fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fe:	8b 50 08             	mov    0x8(%eax),%edx
  802501:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802504:	8b 40 0c             	mov    0xc(%eax),%eax
  802507:	01 c2                	add    %eax,%edx
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  80250f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802512:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802515:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802518:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251b:	eb 3b                	jmp    802558 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80251d:	a1 40 41 80 00       	mov    0x804140,%eax
  802522:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802525:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802529:	74 07                	je     802532 <alloc_block_FF+0x1a5>
  80252b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252e:	8b 00                	mov    (%eax),%eax
  802530:	eb 05                	jmp    802537 <alloc_block_FF+0x1aa>
  802532:	b8 00 00 00 00       	mov    $0x0,%eax
  802537:	a3 40 41 80 00       	mov    %eax,0x804140
  80253c:	a1 40 41 80 00       	mov    0x804140,%eax
  802541:	85 c0                	test   %eax,%eax
  802543:	0f 85 65 fe ff ff    	jne    8023ae <alloc_block_FF+0x21>
  802549:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80254d:	0f 85 5b fe ff ff    	jne    8023ae <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802553:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802558:	c9                   	leave  
  802559:	c3                   	ret    

0080255a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80255a:	55                   	push   %ebp
  80255b:	89 e5                	mov    %esp,%ebp
  80255d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802560:	8b 45 08             	mov    0x8(%ebp),%eax
  802563:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802566:	a1 48 41 80 00       	mov    0x804148,%eax
  80256b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  80256e:	a1 44 41 80 00       	mov    0x804144,%eax
  802573:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802576:	a1 38 41 80 00       	mov    0x804138,%eax
  80257b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80257e:	e9 a1 00 00 00       	jmp    802624 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802586:	8b 40 0c             	mov    0xc(%eax),%eax
  802589:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80258c:	0f 85 8a 00 00 00    	jne    80261c <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802592:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802596:	75 17                	jne    8025af <alloc_block_BF+0x55>
  802598:	83 ec 04             	sub    $0x4,%esp
  80259b:	68 48 3b 80 00       	push   $0x803b48
  8025a0:	68 c2 00 00 00       	push   $0xc2
  8025a5:	68 d7 3a 80 00       	push   $0x803ad7
  8025aa:	e8 3a dd ff ff       	call   8002e9 <_panic>
  8025af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b2:	8b 00                	mov    (%eax),%eax
  8025b4:	85 c0                	test   %eax,%eax
  8025b6:	74 10                	je     8025c8 <alloc_block_BF+0x6e>
  8025b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bb:	8b 00                	mov    (%eax),%eax
  8025bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c0:	8b 52 04             	mov    0x4(%edx),%edx
  8025c3:	89 50 04             	mov    %edx,0x4(%eax)
  8025c6:	eb 0b                	jmp    8025d3 <alloc_block_BF+0x79>
  8025c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cb:	8b 40 04             	mov    0x4(%eax),%eax
  8025ce:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	8b 40 04             	mov    0x4(%eax),%eax
  8025d9:	85 c0                	test   %eax,%eax
  8025db:	74 0f                	je     8025ec <alloc_block_BF+0x92>
  8025dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e0:	8b 40 04             	mov    0x4(%eax),%eax
  8025e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e6:	8b 12                	mov    (%edx),%edx
  8025e8:	89 10                	mov    %edx,(%eax)
  8025ea:	eb 0a                	jmp    8025f6 <alloc_block_BF+0x9c>
  8025ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ef:	8b 00                	mov    (%eax),%eax
  8025f1:	a3 38 41 80 00       	mov    %eax,0x804138
  8025f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802609:	a1 44 41 80 00       	mov    0x804144,%eax
  80260e:	48                   	dec    %eax
  80260f:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802617:	e9 11 02 00 00       	jmp    80282d <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  80261c:	a1 40 41 80 00       	mov    0x804140,%eax
  802621:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802624:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802628:	74 07                	je     802631 <alloc_block_BF+0xd7>
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	8b 00                	mov    (%eax),%eax
  80262f:	eb 05                	jmp    802636 <alloc_block_BF+0xdc>
  802631:	b8 00 00 00 00       	mov    $0x0,%eax
  802636:	a3 40 41 80 00       	mov    %eax,0x804140
  80263b:	a1 40 41 80 00       	mov    0x804140,%eax
  802640:	85 c0                	test   %eax,%eax
  802642:	0f 85 3b ff ff ff    	jne    802583 <alloc_block_BF+0x29>
  802648:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264c:	0f 85 31 ff ff ff    	jne    802583 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802652:	a1 38 41 80 00       	mov    0x804138,%eax
  802657:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80265a:	eb 27                	jmp    802683 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  80265c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265f:	8b 40 0c             	mov    0xc(%eax),%eax
  802662:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802665:	76 14                	jbe    80267b <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	8b 40 0c             	mov    0xc(%eax),%eax
  80266d:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	8b 40 08             	mov    0x8(%eax),%eax
  802676:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802679:	eb 2e                	jmp    8026a9 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80267b:	a1 40 41 80 00       	mov    0x804140,%eax
  802680:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802683:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802687:	74 07                	je     802690 <alloc_block_BF+0x136>
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	8b 00                	mov    (%eax),%eax
  80268e:	eb 05                	jmp    802695 <alloc_block_BF+0x13b>
  802690:	b8 00 00 00 00       	mov    $0x0,%eax
  802695:	a3 40 41 80 00       	mov    %eax,0x804140
  80269a:	a1 40 41 80 00       	mov    0x804140,%eax
  80269f:	85 c0                	test   %eax,%eax
  8026a1:	75 b9                	jne    80265c <alloc_block_BF+0x102>
  8026a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a7:	75 b3                	jne    80265c <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026a9:	a1 38 41 80 00       	mov    0x804138,%eax
  8026ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b1:	eb 30                	jmp    8026e3 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8026bc:	73 1d                	jae    8026db <alloc_block_BF+0x181>
  8026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8026c7:	76 12                	jbe    8026db <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8026cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  8026d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d5:	8b 40 08             	mov    0x8(%eax),%eax
  8026d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026db:	a1 40 41 80 00       	mov    0x804140,%eax
  8026e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e7:	74 07                	je     8026f0 <alloc_block_BF+0x196>
  8026e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ec:	8b 00                	mov    (%eax),%eax
  8026ee:	eb 05                	jmp    8026f5 <alloc_block_BF+0x19b>
  8026f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f5:	a3 40 41 80 00       	mov    %eax,0x804140
  8026fa:	a1 40 41 80 00       	mov    0x804140,%eax
  8026ff:	85 c0                	test   %eax,%eax
  802701:	75 b0                	jne    8026b3 <alloc_block_BF+0x159>
  802703:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802707:	75 aa                	jne    8026b3 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802709:	a1 38 41 80 00       	mov    0x804138,%eax
  80270e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802711:	e9 e4 00 00 00       	jmp    8027fa <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802719:	8b 40 0c             	mov    0xc(%eax),%eax
  80271c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80271f:	0f 85 cd 00 00 00    	jne    8027f2 <alloc_block_BF+0x298>
  802725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802728:	8b 40 08             	mov    0x8(%eax),%eax
  80272b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80272e:	0f 85 be 00 00 00    	jne    8027f2 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802734:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802738:	75 17                	jne    802751 <alloc_block_BF+0x1f7>
  80273a:	83 ec 04             	sub    $0x4,%esp
  80273d:	68 48 3b 80 00       	push   $0x803b48
  802742:	68 db 00 00 00       	push   $0xdb
  802747:	68 d7 3a 80 00       	push   $0x803ad7
  80274c:	e8 98 db ff ff       	call   8002e9 <_panic>
  802751:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802754:	8b 00                	mov    (%eax),%eax
  802756:	85 c0                	test   %eax,%eax
  802758:	74 10                	je     80276a <alloc_block_BF+0x210>
  80275a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80275d:	8b 00                	mov    (%eax),%eax
  80275f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802762:	8b 52 04             	mov    0x4(%edx),%edx
  802765:	89 50 04             	mov    %edx,0x4(%eax)
  802768:	eb 0b                	jmp    802775 <alloc_block_BF+0x21b>
  80276a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80276d:	8b 40 04             	mov    0x4(%eax),%eax
  802770:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802775:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802778:	8b 40 04             	mov    0x4(%eax),%eax
  80277b:	85 c0                	test   %eax,%eax
  80277d:	74 0f                	je     80278e <alloc_block_BF+0x234>
  80277f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802782:	8b 40 04             	mov    0x4(%eax),%eax
  802785:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802788:	8b 12                	mov    (%edx),%edx
  80278a:	89 10                	mov    %edx,(%eax)
  80278c:	eb 0a                	jmp    802798 <alloc_block_BF+0x23e>
  80278e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802791:	8b 00                	mov    (%eax),%eax
  802793:	a3 48 41 80 00       	mov    %eax,0x804148
  802798:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80279b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ab:	a1 54 41 80 00       	mov    0x804154,%eax
  8027b0:	48                   	dec    %eax
  8027b1:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8027b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027bc:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  8027bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027c5:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ce:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8027d1:	89 c2                	mov    %eax,%edx
  8027d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d6:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	8b 50 08             	mov    0x8(%eax),%edx
  8027df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e5:	01 c2                	add    %eax,%edx
  8027e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ea:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8027ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f0:	eb 3b                	jmp    80282d <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027f2:	a1 40 41 80 00       	mov    0x804140,%eax
  8027f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fe:	74 07                	je     802807 <alloc_block_BF+0x2ad>
  802800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802803:	8b 00                	mov    (%eax),%eax
  802805:	eb 05                	jmp    80280c <alloc_block_BF+0x2b2>
  802807:	b8 00 00 00 00       	mov    $0x0,%eax
  80280c:	a3 40 41 80 00       	mov    %eax,0x804140
  802811:	a1 40 41 80 00       	mov    0x804140,%eax
  802816:	85 c0                	test   %eax,%eax
  802818:	0f 85 f8 fe ff ff    	jne    802716 <alloc_block_BF+0x1bc>
  80281e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802822:	0f 85 ee fe ff ff    	jne    802716 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802828:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80282d:	c9                   	leave  
  80282e:	c3                   	ret    

0080282f <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  80282f:	55                   	push   %ebp
  802830:	89 e5                	mov    %esp,%ebp
  802832:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802835:	8b 45 08             	mov    0x8(%ebp),%eax
  802838:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  80283b:	a1 48 41 80 00       	mov    0x804148,%eax
  802840:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802843:	a1 38 41 80 00       	mov    0x804138,%eax
  802848:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80284b:	e9 77 01 00 00       	jmp    8029c7 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802853:	8b 40 0c             	mov    0xc(%eax),%eax
  802856:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802859:	0f 85 8a 00 00 00    	jne    8028e9 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80285f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802863:	75 17                	jne    80287c <alloc_block_NF+0x4d>
  802865:	83 ec 04             	sub    $0x4,%esp
  802868:	68 48 3b 80 00       	push   $0x803b48
  80286d:	68 f7 00 00 00       	push   $0xf7
  802872:	68 d7 3a 80 00       	push   $0x803ad7
  802877:	e8 6d da ff ff       	call   8002e9 <_panic>
  80287c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287f:	8b 00                	mov    (%eax),%eax
  802881:	85 c0                	test   %eax,%eax
  802883:	74 10                	je     802895 <alloc_block_NF+0x66>
  802885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802888:	8b 00                	mov    (%eax),%eax
  80288a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80288d:	8b 52 04             	mov    0x4(%edx),%edx
  802890:	89 50 04             	mov    %edx,0x4(%eax)
  802893:	eb 0b                	jmp    8028a0 <alloc_block_NF+0x71>
  802895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802898:	8b 40 04             	mov    0x4(%eax),%eax
  80289b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	8b 40 04             	mov    0x4(%eax),%eax
  8028a6:	85 c0                	test   %eax,%eax
  8028a8:	74 0f                	je     8028b9 <alloc_block_NF+0x8a>
  8028aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ad:	8b 40 04             	mov    0x4(%eax),%eax
  8028b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b3:	8b 12                	mov    (%edx),%edx
  8028b5:	89 10                	mov    %edx,(%eax)
  8028b7:	eb 0a                	jmp    8028c3 <alloc_block_NF+0x94>
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	8b 00                	mov    (%eax),%eax
  8028be:	a3 38 41 80 00       	mov    %eax,0x804138
  8028c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d6:	a1 44 41 80 00       	mov    0x804144,%eax
  8028db:	48                   	dec    %eax
  8028dc:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8028e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e4:	e9 11 01 00 00       	jmp    8029fa <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  8028e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028f2:	0f 86 c7 00 00 00    	jbe    8029bf <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8028f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028fc:	75 17                	jne    802915 <alloc_block_NF+0xe6>
  8028fe:	83 ec 04             	sub    $0x4,%esp
  802901:	68 48 3b 80 00       	push   $0x803b48
  802906:	68 fc 00 00 00       	push   $0xfc
  80290b:	68 d7 3a 80 00       	push   $0x803ad7
  802910:	e8 d4 d9 ff ff       	call   8002e9 <_panic>
  802915:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802918:	8b 00                	mov    (%eax),%eax
  80291a:	85 c0                	test   %eax,%eax
  80291c:	74 10                	je     80292e <alloc_block_NF+0xff>
  80291e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802921:	8b 00                	mov    (%eax),%eax
  802923:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802926:	8b 52 04             	mov    0x4(%edx),%edx
  802929:	89 50 04             	mov    %edx,0x4(%eax)
  80292c:	eb 0b                	jmp    802939 <alloc_block_NF+0x10a>
  80292e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802931:	8b 40 04             	mov    0x4(%eax),%eax
  802934:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802939:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293c:	8b 40 04             	mov    0x4(%eax),%eax
  80293f:	85 c0                	test   %eax,%eax
  802941:	74 0f                	je     802952 <alloc_block_NF+0x123>
  802943:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802946:	8b 40 04             	mov    0x4(%eax),%eax
  802949:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80294c:	8b 12                	mov    (%edx),%edx
  80294e:	89 10                	mov    %edx,(%eax)
  802950:	eb 0a                	jmp    80295c <alloc_block_NF+0x12d>
  802952:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802955:	8b 00                	mov    (%eax),%eax
  802957:	a3 48 41 80 00       	mov    %eax,0x804148
  80295c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802965:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802968:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80296f:	a1 54 41 80 00       	mov    0x804154,%eax
  802974:	48                   	dec    %eax
  802975:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  80297a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802980:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	8b 40 0c             	mov    0xc(%eax),%eax
  802989:	2b 45 f0             	sub    -0x10(%ebp),%eax
  80298c:	89 c2                	mov    %eax,%edx
  80298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802991:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802997:	8b 40 08             	mov    0x8(%eax),%eax
  80299a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  80299d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a0:	8b 50 08             	mov    0x8(%eax),%edx
  8029a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a9:	01 c2                	add    %eax,%edx
  8029ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ae:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8029b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029b7:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8029ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029bd:	eb 3b                	jmp    8029fa <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8029bf:	a1 40 41 80 00       	mov    0x804140,%eax
  8029c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029cb:	74 07                	je     8029d4 <alloc_block_NF+0x1a5>
  8029cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d0:	8b 00                	mov    (%eax),%eax
  8029d2:	eb 05                	jmp    8029d9 <alloc_block_NF+0x1aa>
  8029d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d9:	a3 40 41 80 00       	mov    %eax,0x804140
  8029de:	a1 40 41 80 00       	mov    0x804140,%eax
  8029e3:	85 c0                	test   %eax,%eax
  8029e5:	0f 85 65 fe ff ff    	jne    802850 <alloc_block_NF+0x21>
  8029eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ef:	0f 85 5b fe ff ff    	jne    802850 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8029f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029fa:	c9                   	leave  
  8029fb:	c3                   	ret    

008029fc <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  8029fc:	55                   	push   %ebp
  8029fd:	89 e5                	mov    %esp,%ebp
  8029ff:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802a02:	8b 45 08             	mov    0x8(%ebp),%eax
  802a05:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802a16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a1a:	75 17                	jne    802a33 <addToAvailMemBlocksList+0x37>
  802a1c:	83 ec 04             	sub    $0x4,%esp
  802a1f:	68 f0 3a 80 00       	push   $0x803af0
  802a24:	68 10 01 00 00       	push   $0x110
  802a29:	68 d7 3a 80 00       	push   $0x803ad7
  802a2e:	e8 b6 d8 ff ff       	call   8002e9 <_panic>
  802a33:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802a39:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3c:	89 50 04             	mov    %edx,0x4(%eax)
  802a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a42:	8b 40 04             	mov    0x4(%eax),%eax
  802a45:	85 c0                	test   %eax,%eax
  802a47:	74 0c                	je     802a55 <addToAvailMemBlocksList+0x59>
  802a49:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802a4e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a51:	89 10                	mov    %edx,(%eax)
  802a53:	eb 08                	jmp    802a5d <addToAvailMemBlocksList+0x61>
  802a55:	8b 45 08             	mov    0x8(%ebp),%eax
  802a58:	a3 48 41 80 00       	mov    %eax,0x804148
  802a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a60:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a65:	8b 45 08             	mov    0x8(%ebp),%eax
  802a68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a6e:	a1 54 41 80 00       	mov    0x804154,%eax
  802a73:	40                   	inc    %eax
  802a74:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802a79:	90                   	nop
  802a7a:	c9                   	leave  
  802a7b:	c3                   	ret    

00802a7c <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a7c:	55                   	push   %ebp
  802a7d:	89 e5                	mov    %esp,%ebp
  802a7f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802a82:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a87:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802a8a:	a1 44 41 80 00       	mov    0x804144,%eax
  802a8f:	85 c0                	test   %eax,%eax
  802a91:	75 68                	jne    802afb <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802a93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a97:	75 17                	jne    802ab0 <insert_sorted_with_merge_freeList+0x34>
  802a99:	83 ec 04             	sub    $0x4,%esp
  802a9c:	68 b4 3a 80 00       	push   $0x803ab4
  802aa1:	68 1a 01 00 00       	push   $0x11a
  802aa6:	68 d7 3a 80 00       	push   $0x803ad7
  802aab:	e8 39 d8 ff ff       	call   8002e9 <_panic>
  802ab0:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab9:	89 10                	mov    %edx,(%eax)
  802abb:	8b 45 08             	mov    0x8(%ebp),%eax
  802abe:	8b 00                	mov    (%eax),%eax
  802ac0:	85 c0                	test   %eax,%eax
  802ac2:	74 0d                	je     802ad1 <insert_sorted_with_merge_freeList+0x55>
  802ac4:	a1 38 41 80 00       	mov    0x804138,%eax
  802ac9:	8b 55 08             	mov    0x8(%ebp),%edx
  802acc:	89 50 04             	mov    %edx,0x4(%eax)
  802acf:	eb 08                	jmp    802ad9 <insert_sorted_with_merge_freeList+0x5d>
  802ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  802adc:	a3 38 41 80 00       	mov    %eax,0x804138
  802ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aeb:	a1 44 41 80 00       	mov    0x804144,%eax
  802af0:	40                   	inc    %eax
  802af1:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802af6:	e9 c5 03 00 00       	jmp    802ec0 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802afb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afe:	8b 50 08             	mov    0x8(%eax),%edx
  802b01:	8b 45 08             	mov    0x8(%ebp),%eax
  802b04:	8b 40 08             	mov    0x8(%eax),%eax
  802b07:	39 c2                	cmp    %eax,%edx
  802b09:	0f 83 b2 00 00 00    	jae    802bc1 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802b0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b12:	8b 50 08             	mov    0x8(%eax),%edx
  802b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b18:	8b 40 0c             	mov    0xc(%eax),%eax
  802b1b:	01 c2                	add    %eax,%edx
  802b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b20:	8b 40 08             	mov    0x8(%eax),%eax
  802b23:	39 c2                	cmp    %eax,%edx
  802b25:	75 27                	jne    802b4e <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2a:	8b 50 0c             	mov    0xc(%eax),%edx
  802b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b30:	8b 40 0c             	mov    0xc(%eax),%eax
  802b33:	01 c2                	add    %eax,%edx
  802b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b38:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802b3b:	83 ec 0c             	sub    $0xc,%esp
  802b3e:	ff 75 08             	pushl  0x8(%ebp)
  802b41:	e8 b6 fe ff ff       	call   8029fc <addToAvailMemBlocksList>
  802b46:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802b49:	e9 72 03 00 00       	jmp    802ec0 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802b4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b52:	74 06                	je     802b5a <insert_sorted_with_merge_freeList+0xde>
  802b54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b58:	75 17                	jne    802b71 <insert_sorted_with_merge_freeList+0xf5>
  802b5a:	83 ec 04             	sub    $0x4,%esp
  802b5d:	68 14 3b 80 00       	push   $0x803b14
  802b62:	68 24 01 00 00       	push   $0x124
  802b67:	68 d7 3a 80 00       	push   $0x803ad7
  802b6c:	e8 78 d7 ff ff       	call   8002e9 <_panic>
  802b71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b74:	8b 10                	mov    (%eax),%edx
  802b76:	8b 45 08             	mov    0x8(%ebp),%eax
  802b79:	89 10                	mov    %edx,(%eax)
  802b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7e:	8b 00                	mov    (%eax),%eax
  802b80:	85 c0                	test   %eax,%eax
  802b82:	74 0b                	je     802b8f <insert_sorted_with_merge_freeList+0x113>
  802b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b87:	8b 00                	mov    (%eax),%eax
  802b89:	8b 55 08             	mov    0x8(%ebp),%edx
  802b8c:	89 50 04             	mov    %edx,0x4(%eax)
  802b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b92:	8b 55 08             	mov    0x8(%ebp),%edx
  802b95:	89 10                	mov    %edx,(%eax)
  802b97:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b9d:	89 50 04             	mov    %edx,0x4(%eax)
  802ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba3:	8b 00                	mov    (%eax),%eax
  802ba5:	85 c0                	test   %eax,%eax
  802ba7:	75 08                	jne    802bb1 <insert_sorted_with_merge_freeList+0x135>
  802ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bac:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bb1:	a1 44 41 80 00       	mov    0x804144,%eax
  802bb6:	40                   	inc    %eax
  802bb7:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802bbc:	e9 ff 02 00 00       	jmp    802ec0 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802bc1:	a1 38 41 80 00       	mov    0x804138,%eax
  802bc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bc9:	e9 c2 02 00 00       	jmp    802e90 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd1:	8b 50 08             	mov    0x8(%eax),%edx
  802bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd7:	8b 40 08             	mov    0x8(%eax),%eax
  802bda:	39 c2                	cmp    %eax,%edx
  802bdc:	0f 86 a6 02 00 00    	jbe    802e88 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be5:	8b 40 04             	mov    0x4(%eax),%eax
  802be8:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802beb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bef:	0f 85 ba 00 00 00    	jne    802caf <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf8:	8b 50 0c             	mov    0xc(%eax),%edx
  802bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfe:	8b 40 08             	mov    0x8(%eax),%eax
  802c01:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c06:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802c09:	39 c2                	cmp    %eax,%edx
  802c0b:	75 33                	jne    802c40 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c10:	8b 50 08             	mov    0x8(%eax),%edx
  802c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c16:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	8b 50 0c             	mov    0xc(%eax),%edx
  802c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c22:	8b 40 0c             	mov    0xc(%eax),%eax
  802c25:	01 c2                	add    %eax,%edx
  802c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2a:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802c2d:	83 ec 0c             	sub    $0xc,%esp
  802c30:	ff 75 08             	pushl  0x8(%ebp)
  802c33:	e8 c4 fd ff ff       	call   8029fc <addToAvailMemBlocksList>
  802c38:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802c3b:	e9 80 02 00 00       	jmp    802ec0 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802c40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c44:	74 06                	je     802c4c <insert_sorted_with_merge_freeList+0x1d0>
  802c46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c4a:	75 17                	jne    802c63 <insert_sorted_with_merge_freeList+0x1e7>
  802c4c:	83 ec 04             	sub    $0x4,%esp
  802c4f:	68 68 3b 80 00       	push   $0x803b68
  802c54:	68 3a 01 00 00       	push   $0x13a
  802c59:	68 d7 3a 80 00       	push   $0x803ad7
  802c5e:	e8 86 d6 ff ff       	call   8002e9 <_panic>
  802c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c66:	8b 50 04             	mov    0x4(%eax),%edx
  802c69:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6c:	89 50 04             	mov    %edx,0x4(%eax)
  802c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c75:	89 10                	mov    %edx,(%eax)
  802c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7a:	8b 40 04             	mov    0x4(%eax),%eax
  802c7d:	85 c0                	test   %eax,%eax
  802c7f:	74 0d                	je     802c8e <insert_sorted_with_merge_freeList+0x212>
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 40 04             	mov    0x4(%eax),%eax
  802c87:	8b 55 08             	mov    0x8(%ebp),%edx
  802c8a:	89 10                	mov    %edx,(%eax)
  802c8c:	eb 08                	jmp    802c96 <insert_sorted_with_merge_freeList+0x21a>
  802c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c91:	a3 38 41 80 00       	mov    %eax,0x804138
  802c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c99:	8b 55 08             	mov    0x8(%ebp),%edx
  802c9c:	89 50 04             	mov    %edx,0x4(%eax)
  802c9f:	a1 44 41 80 00       	mov    0x804144,%eax
  802ca4:	40                   	inc    %eax
  802ca5:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802caa:	e9 11 02 00 00       	jmp    802ec0 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802caf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb2:	8b 50 08             	mov    0x8(%eax),%edx
  802cb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb8:	8b 40 0c             	mov    0xc(%eax),%eax
  802cbb:	01 c2                	add    %eax,%edx
  802cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc3:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802ccb:	39 c2                	cmp    %eax,%edx
  802ccd:	0f 85 bf 00 00 00    	jne    802d92 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802cd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd6:	8b 50 0c             	mov    0xc(%eax),%edx
  802cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdc:	8b 40 0c             	mov    0xc(%eax),%eax
  802cdf:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce7:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802ce9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cec:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802cef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf3:	75 17                	jne    802d0c <insert_sorted_with_merge_freeList+0x290>
  802cf5:	83 ec 04             	sub    $0x4,%esp
  802cf8:	68 48 3b 80 00       	push   $0x803b48
  802cfd:	68 43 01 00 00       	push   $0x143
  802d02:	68 d7 3a 80 00       	push   $0x803ad7
  802d07:	e8 dd d5 ff ff       	call   8002e9 <_panic>
  802d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0f:	8b 00                	mov    (%eax),%eax
  802d11:	85 c0                	test   %eax,%eax
  802d13:	74 10                	je     802d25 <insert_sorted_with_merge_freeList+0x2a9>
  802d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d18:	8b 00                	mov    (%eax),%eax
  802d1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d1d:	8b 52 04             	mov    0x4(%edx),%edx
  802d20:	89 50 04             	mov    %edx,0x4(%eax)
  802d23:	eb 0b                	jmp    802d30 <insert_sorted_with_merge_freeList+0x2b4>
  802d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d28:	8b 40 04             	mov    0x4(%eax),%eax
  802d2b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d33:	8b 40 04             	mov    0x4(%eax),%eax
  802d36:	85 c0                	test   %eax,%eax
  802d38:	74 0f                	je     802d49 <insert_sorted_with_merge_freeList+0x2cd>
  802d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3d:	8b 40 04             	mov    0x4(%eax),%eax
  802d40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d43:	8b 12                	mov    (%edx),%edx
  802d45:	89 10                	mov    %edx,(%eax)
  802d47:	eb 0a                	jmp    802d53 <insert_sorted_with_merge_freeList+0x2d7>
  802d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4c:	8b 00                	mov    (%eax),%eax
  802d4e:	a3 38 41 80 00       	mov    %eax,0x804138
  802d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d66:	a1 44 41 80 00       	mov    0x804144,%eax
  802d6b:	48                   	dec    %eax
  802d6c:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802d71:	83 ec 0c             	sub    $0xc,%esp
  802d74:	ff 75 08             	pushl  0x8(%ebp)
  802d77:	e8 80 fc ff ff       	call   8029fc <addToAvailMemBlocksList>
  802d7c:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802d7f:	83 ec 0c             	sub    $0xc,%esp
  802d82:	ff 75 f4             	pushl  -0xc(%ebp)
  802d85:	e8 72 fc ff ff       	call   8029fc <addToAvailMemBlocksList>
  802d8a:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802d8d:	e9 2e 01 00 00       	jmp    802ec0 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802d92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d95:	8b 50 08             	mov    0x8(%eax),%edx
  802d98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9e:	01 c2                	add    %eax,%edx
  802da0:	8b 45 08             	mov    0x8(%ebp),%eax
  802da3:	8b 40 08             	mov    0x8(%eax),%eax
  802da6:	39 c2                	cmp    %eax,%edx
  802da8:	75 27                	jne    802dd1 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802daa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dad:	8b 50 0c             	mov    0xc(%eax),%edx
  802db0:	8b 45 08             	mov    0x8(%ebp),%eax
  802db3:	8b 40 0c             	mov    0xc(%eax),%eax
  802db6:	01 c2                	add    %eax,%edx
  802db8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dbb:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802dbe:	83 ec 0c             	sub    $0xc,%esp
  802dc1:	ff 75 08             	pushl  0x8(%ebp)
  802dc4:	e8 33 fc ff ff       	call   8029fc <addToAvailMemBlocksList>
  802dc9:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802dcc:	e9 ef 00 00 00       	jmp    802ec0 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd4:	8b 50 0c             	mov    0xc(%eax),%edx
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	8b 40 08             	mov    0x8(%eax),%eax
  802ddd:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de2:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802de5:	39 c2                	cmp    %eax,%edx
  802de7:	75 33                	jne    802e1c <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802de9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dec:	8b 50 08             	mov    0x8(%eax),%edx
  802def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df2:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df8:	8b 50 0c             	mov    0xc(%eax),%edx
  802dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfe:	8b 40 0c             	mov    0xc(%eax),%eax
  802e01:	01 c2                	add    %eax,%edx
  802e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e06:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802e09:	83 ec 0c             	sub    $0xc,%esp
  802e0c:	ff 75 08             	pushl  0x8(%ebp)
  802e0f:	e8 e8 fb ff ff       	call   8029fc <addToAvailMemBlocksList>
  802e14:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802e17:	e9 a4 00 00 00       	jmp    802ec0 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802e1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e20:	74 06                	je     802e28 <insert_sorted_with_merge_freeList+0x3ac>
  802e22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e26:	75 17                	jne    802e3f <insert_sorted_with_merge_freeList+0x3c3>
  802e28:	83 ec 04             	sub    $0x4,%esp
  802e2b:	68 68 3b 80 00       	push   $0x803b68
  802e30:	68 56 01 00 00       	push   $0x156
  802e35:	68 d7 3a 80 00       	push   $0x803ad7
  802e3a:	e8 aa d4 ff ff       	call   8002e9 <_panic>
  802e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e42:	8b 50 04             	mov    0x4(%eax),%edx
  802e45:	8b 45 08             	mov    0x8(%ebp),%eax
  802e48:	89 50 04             	mov    %edx,0x4(%eax)
  802e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e51:	89 10                	mov    %edx,(%eax)
  802e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e56:	8b 40 04             	mov    0x4(%eax),%eax
  802e59:	85 c0                	test   %eax,%eax
  802e5b:	74 0d                	je     802e6a <insert_sorted_with_merge_freeList+0x3ee>
  802e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e60:	8b 40 04             	mov    0x4(%eax),%eax
  802e63:	8b 55 08             	mov    0x8(%ebp),%edx
  802e66:	89 10                	mov    %edx,(%eax)
  802e68:	eb 08                	jmp    802e72 <insert_sorted_with_merge_freeList+0x3f6>
  802e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6d:	a3 38 41 80 00       	mov    %eax,0x804138
  802e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e75:	8b 55 08             	mov    0x8(%ebp),%edx
  802e78:	89 50 04             	mov    %edx,0x4(%eax)
  802e7b:	a1 44 41 80 00       	mov    0x804144,%eax
  802e80:	40                   	inc    %eax
  802e81:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802e86:	eb 38                	jmp    802ec0 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802e88:	a1 40 41 80 00       	mov    0x804140,%eax
  802e8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e94:	74 07                	je     802e9d <insert_sorted_with_merge_freeList+0x421>
  802e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e99:	8b 00                	mov    (%eax),%eax
  802e9b:	eb 05                	jmp    802ea2 <insert_sorted_with_merge_freeList+0x426>
  802e9d:	b8 00 00 00 00       	mov    $0x0,%eax
  802ea2:	a3 40 41 80 00       	mov    %eax,0x804140
  802ea7:	a1 40 41 80 00       	mov    0x804140,%eax
  802eac:	85 c0                	test   %eax,%eax
  802eae:	0f 85 1a fd ff ff    	jne    802bce <insert_sorted_with_merge_freeList+0x152>
  802eb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb8:	0f 85 10 fd ff ff    	jne    802bce <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ebe:	eb 00                	jmp    802ec0 <insert_sorted_with_merge_freeList+0x444>
  802ec0:	90                   	nop
  802ec1:	c9                   	leave  
  802ec2:	c3                   	ret    

00802ec3 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802ec3:	55                   	push   %ebp
  802ec4:	89 e5                	mov    %esp,%ebp
  802ec6:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802ec9:	8b 55 08             	mov    0x8(%ebp),%edx
  802ecc:	89 d0                	mov    %edx,%eax
  802ece:	c1 e0 02             	shl    $0x2,%eax
  802ed1:	01 d0                	add    %edx,%eax
  802ed3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802eda:	01 d0                	add    %edx,%eax
  802edc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ee3:	01 d0                	add    %edx,%eax
  802ee5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802eec:	01 d0                	add    %edx,%eax
  802eee:	c1 e0 04             	shl    $0x4,%eax
  802ef1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802ef4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802efb:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802efe:	83 ec 0c             	sub    $0xc,%esp
  802f01:	50                   	push   %eax
  802f02:	e8 60 ed ff ff       	call   801c67 <sys_get_virtual_time>
  802f07:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802f0a:	eb 41                	jmp    802f4d <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802f0c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802f0f:	83 ec 0c             	sub    $0xc,%esp
  802f12:	50                   	push   %eax
  802f13:	e8 4f ed ff ff       	call   801c67 <sys_get_virtual_time>
  802f18:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802f1b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f21:	29 c2                	sub    %eax,%edx
  802f23:	89 d0                	mov    %edx,%eax
  802f25:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802f28:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2e:	89 d1                	mov    %edx,%ecx
  802f30:	29 c1                	sub    %eax,%ecx
  802f32:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802f35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f38:	39 c2                	cmp    %eax,%edx
  802f3a:	0f 97 c0             	seta   %al
  802f3d:	0f b6 c0             	movzbl %al,%eax
  802f40:	29 c1                	sub    %eax,%ecx
  802f42:	89 c8                	mov    %ecx,%eax
  802f44:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802f47:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f50:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f53:	72 b7                	jb     802f0c <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802f55:	90                   	nop
  802f56:	c9                   	leave  
  802f57:	c3                   	ret    

00802f58 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802f58:	55                   	push   %ebp
  802f59:	89 e5                	mov    %esp,%ebp
  802f5b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802f5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802f65:	eb 03                	jmp    802f6a <busy_wait+0x12>
  802f67:	ff 45 fc             	incl   -0x4(%ebp)
  802f6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f6d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f70:	72 f5                	jb     802f67 <busy_wait+0xf>
	return i;
  802f72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802f75:	c9                   	leave  
  802f76:	c3                   	ret    
  802f77:	90                   	nop

00802f78 <__udivdi3>:
  802f78:	55                   	push   %ebp
  802f79:	57                   	push   %edi
  802f7a:	56                   	push   %esi
  802f7b:	53                   	push   %ebx
  802f7c:	83 ec 1c             	sub    $0x1c,%esp
  802f7f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802f83:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802f87:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802f8b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f8f:	89 ca                	mov    %ecx,%edx
  802f91:	89 f8                	mov    %edi,%eax
  802f93:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802f97:	85 f6                	test   %esi,%esi
  802f99:	75 2d                	jne    802fc8 <__udivdi3+0x50>
  802f9b:	39 cf                	cmp    %ecx,%edi
  802f9d:	77 65                	ja     803004 <__udivdi3+0x8c>
  802f9f:	89 fd                	mov    %edi,%ebp
  802fa1:	85 ff                	test   %edi,%edi
  802fa3:	75 0b                	jne    802fb0 <__udivdi3+0x38>
  802fa5:	b8 01 00 00 00       	mov    $0x1,%eax
  802faa:	31 d2                	xor    %edx,%edx
  802fac:	f7 f7                	div    %edi
  802fae:	89 c5                	mov    %eax,%ebp
  802fb0:	31 d2                	xor    %edx,%edx
  802fb2:	89 c8                	mov    %ecx,%eax
  802fb4:	f7 f5                	div    %ebp
  802fb6:	89 c1                	mov    %eax,%ecx
  802fb8:	89 d8                	mov    %ebx,%eax
  802fba:	f7 f5                	div    %ebp
  802fbc:	89 cf                	mov    %ecx,%edi
  802fbe:	89 fa                	mov    %edi,%edx
  802fc0:	83 c4 1c             	add    $0x1c,%esp
  802fc3:	5b                   	pop    %ebx
  802fc4:	5e                   	pop    %esi
  802fc5:	5f                   	pop    %edi
  802fc6:	5d                   	pop    %ebp
  802fc7:	c3                   	ret    
  802fc8:	39 ce                	cmp    %ecx,%esi
  802fca:	77 28                	ja     802ff4 <__udivdi3+0x7c>
  802fcc:	0f bd fe             	bsr    %esi,%edi
  802fcf:	83 f7 1f             	xor    $0x1f,%edi
  802fd2:	75 40                	jne    803014 <__udivdi3+0x9c>
  802fd4:	39 ce                	cmp    %ecx,%esi
  802fd6:	72 0a                	jb     802fe2 <__udivdi3+0x6a>
  802fd8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802fdc:	0f 87 9e 00 00 00    	ja     803080 <__udivdi3+0x108>
  802fe2:	b8 01 00 00 00       	mov    $0x1,%eax
  802fe7:	89 fa                	mov    %edi,%edx
  802fe9:	83 c4 1c             	add    $0x1c,%esp
  802fec:	5b                   	pop    %ebx
  802fed:	5e                   	pop    %esi
  802fee:	5f                   	pop    %edi
  802fef:	5d                   	pop    %ebp
  802ff0:	c3                   	ret    
  802ff1:	8d 76 00             	lea    0x0(%esi),%esi
  802ff4:	31 ff                	xor    %edi,%edi
  802ff6:	31 c0                	xor    %eax,%eax
  802ff8:	89 fa                	mov    %edi,%edx
  802ffa:	83 c4 1c             	add    $0x1c,%esp
  802ffd:	5b                   	pop    %ebx
  802ffe:	5e                   	pop    %esi
  802fff:	5f                   	pop    %edi
  803000:	5d                   	pop    %ebp
  803001:	c3                   	ret    
  803002:	66 90                	xchg   %ax,%ax
  803004:	89 d8                	mov    %ebx,%eax
  803006:	f7 f7                	div    %edi
  803008:	31 ff                	xor    %edi,%edi
  80300a:	89 fa                	mov    %edi,%edx
  80300c:	83 c4 1c             	add    $0x1c,%esp
  80300f:	5b                   	pop    %ebx
  803010:	5e                   	pop    %esi
  803011:	5f                   	pop    %edi
  803012:	5d                   	pop    %ebp
  803013:	c3                   	ret    
  803014:	bd 20 00 00 00       	mov    $0x20,%ebp
  803019:	89 eb                	mov    %ebp,%ebx
  80301b:	29 fb                	sub    %edi,%ebx
  80301d:	89 f9                	mov    %edi,%ecx
  80301f:	d3 e6                	shl    %cl,%esi
  803021:	89 c5                	mov    %eax,%ebp
  803023:	88 d9                	mov    %bl,%cl
  803025:	d3 ed                	shr    %cl,%ebp
  803027:	89 e9                	mov    %ebp,%ecx
  803029:	09 f1                	or     %esi,%ecx
  80302b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80302f:	89 f9                	mov    %edi,%ecx
  803031:	d3 e0                	shl    %cl,%eax
  803033:	89 c5                	mov    %eax,%ebp
  803035:	89 d6                	mov    %edx,%esi
  803037:	88 d9                	mov    %bl,%cl
  803039:	d3 ee                	shr    %cl,%esi
  80303b:	89 f9                	mov    %edi,%ecx
  80303d:	d3 e2                	shl    %cl,%edx
  80303f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803043:	88 d9                	mov    %bl,%cl
  803045:	d3 e8                	shr    %cl,%eax
  803047:	09 c2                	or     %eax,%edx
  803049:	89 d0                	mov    %edx,%eax
  80304b:	89 f2                	mov    %esi,%edx
  80304d:	f7 74 24 0c          	divl   0xc(%esp)
  803051:	89 d6                	mov    %edx,%esi
  803053:	89 c3                	mov    %eax,%ebx
  803055:	f7 e5                	mul    %ebp
  803057:	39 d6                	cmp    %edx,%esi
  803059:	72 19                	jb     803074 <__udivdi3+0xfc>
  80305b:	74 0b                	je     803068 <__udivdi3+0xf0>
  80305d:	89 d8                	mov    %ebx,%eax
  80305f:	31 ff                	xor    %edi,%edi
  803061:	e9 58 ff ff ff       	jmp    802fbe <__udivdi3+0x46>
  803066:	66 90                	xchg   %ax,%ax
  803068:	8b 54 24 08          	mov    0x8(%esp),%edx
  80306c:	89 f9                	mov    %edi,%ecx
  80306e:	d3 e2                	shl    %cl,%edx
  803070:	39 c2                	cmp    %eax,%edx
  803072:	73 e9                	jae    80305d <__udivdi3+0xe5>
  803074:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803077:	31 ff                	xor    %edi,%edi
  803079:	e9 40 ff ff ff       	jmp    802fbe <__udivdi3+0x46>
  80307e:	66 90                	xchg   %ax,%ax
  803080:	31 c0                	xor    %eax,%eax
  803082:	e9 37 ff ff ff       	jmp    802fbe <__udivdi3+0x46>
  803087:	90                   	nop

00803088 <__umoddi3>:
  803088:	55                   	push   %ebp
  803089:	57                   	push   %edi
  80308a:	56                   	push   %esi
  80308b:	53                   	push   %ebx
  80308c:	83 ec 1c             	sub    $0x1c,%esp
  80308f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803093:	8b 74 24 34          	mov    0x34(%esp),%esi
  803097:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80309b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80309f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8030a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8030a7:	89 f3                	mov    %esi,%ebx
  8030a9:	89 fa                	mov    %edi,%edx
  8030ab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8030af:	89 34 24             	mov    %esi,(%esp)
  8030b2:	85 c0                	test   %eax,%eax
  8030b4:	75 1a                	jne    8030d0 <__umoddi3+0x48>
  8030b6:	39 f7                	cmp    %esi,%edi
  8030b8:	0f 86 a2 00 00 00    	jbe    803160 <__umoddi3+0xd8>
  8030be:	89 c8                	mov    %ecx,%eax
  8030c0:	89 f2                	mov    %esi,%edx
  8030c2:	f7 f7                	div    %edi
  8030c4:	89 d0                	mov    %edx,%eax
  8030c6:	31 d2                	xor    %edx,%edx
  8030c8:	83 c4 1c             	add    $0x1c,%esp
  8030cb:	5b                   	pop    %ebx
  8030cc:	5e                   	pop    %esi
  8030cd:	5f                   	pop    %edi
  8030ce:	5d                   	pop    %ebp
  8030cf:	c3                   	ret    
  8030d0:	39 f0                	cmp    %esi,%eax
  8030d2:	0f 87 ac 00 00 00    	ja     803184 <__umoddi3+0xfc>
  8030d8:	0f bd e8             	bsr    %eax,%ebp
  8030db:	83 f5 1f             	xor    $0x1f,%ebp
  8030de:	0f 84 ac 00 00 00    	je     803190 <__umoddi3+0x108>
  8030e4:	bf 20 00 00 00       	mov    $0x20,%edi
  8030e9:	29 ef                	sub    %ebp,%edi
  8030eb:	89 fe                	mov    %edi,%esi
  8030ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8030f1:	89 e9                	mov    %ebp,%ecx
  8030f3:	d3 e0                	shl    %cl,%eax
  8030f5:	89 d7                	mov    %edx,%edi
  8030f7:	89 f1                	mov    %esi,%ecx
  8030f9:	d3 ef                	shr    %cl,%edi
  8030fb:	09 c7                	or     %eax,%edi
  8030fd:	89 e9                	mov    %ebp,%ecx
  8030ff:	d3 e2                	shl    %cl,%edx
  803101:	89 14 24             	mov    %edx,(%esp)
  803104:	89 d8                	mov    %ebx,%eax
  803106:	d3 e0                	shl    %cl,%eax
  803108:	89 c2                	mov    %eax,%edx
  80310a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80310e:	d3 e0                	shl    %cl,%eax
  803110:	89 44 24 04          	mov    %eax,0x4(%esp)
  803114:	8b 44 24 08          	mov    0x8(%esp),%eax
  803118:	89 f1                	mov    %esi,%ecx
  80311a:	d3 e8                	shr    %cl,%eax
  80311c:	09 d0                	or     %edx,%eax
  80311e:	d3 eb                	shr    %cl,%ebx
  803120:	89 da                	mov    %ebx,%edx
  803122:	f7 f7                	div    %edi
  803124:	89 d3                	mov    %edx,%ebx
  803126:	f7 24 24             	mull   (%esp)
  803129:	89 c6                	mov    %eax,%esi
  80312b:	89 d1                	mov    %edx,%ecx
  80312d:	39 d3                	cmp    %edx,%ebx
  80312f:	0f 82 87 00 00 00    	jb     8031bc <__umoddi3+0x134>
  803135:	0f 84 91 00 00 00    	je     8031cc <__umoddi3+0x144>
  80313b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80313f:	29 f2                	sub    %esi,%edx
  803141:	19 cb                	sbb    %ecx,%ebx
  803143:	89 d8                	mov    %ebx,%eax
  803145:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803149:	d3 e0                	shl    %cl,%eax
  80314b:	89 e9                	mov    %ebp,%ecx
  80314d:	d3 ea                	shr    %cl,%edx
  80314f:	09 d0                	or     %edx,%eax
  803151:	89 e9                	mov    %ebp,%ecx
  803153:	d3 eb                	shr    %cl,%ebx
  803155:	89 da                	mov    %ebx,%edx
  803157:	83 c4 1c             	add    $0x1c,%esp
  80315a:	5b                   	pop    %ebx
  80315b:	5e                   	pop    %esi
  80315c:	5f                   	pop    %edi
  80315d:	5d                   	pop    %ebp
  80315e:	c3                   	ret    
  80315f:	90                   	nop
  803160:	89 fd                	mov    %edi,%ebp
  803162:	85 ff                	test   %edi,%edi
  803164:	75 0b                	jne    803171 <__umoddi3+0xe9>
  803166:	b8 01 00 00 00       	mov    $0x1,%eax
  80316b:	31 d2                	xor    %edx,%edx
  80316d:	f7 f7                	div    %edi
  80316f:	89 c5                	mov    %eax,%ebp
  803171:	89 f0                	mov    %esi,%eax
  803173:	31 d2                	xor    %edx,%edx
  803175:	f7 f5                	div    %ebp
  803177:	89 c8                	mov    %ecx,%eax
  803179:	f7 f5                	div    %ebp
  80317b:	89 d0                	mov    %edx,%eax
  80317d:	e9 44 ff ff ff       	jmp    8030c6 <__umoddi3+0x3e>
  803182:	66 90                	xchg   %ax,%ax
  803184:	89 c8                	mov    %ecx,%eax
  803186:	89 f2                	mov    %esi,%edx
  803188:	83 c4 1c             	add    $0x1c,%esp
  80318b:	5b                   	pop    %ebx
  80318c:	5e                   	pop    %esi
  80318d:	5f                   	pop    %edi
  80318e:	5d                   	pop    %ebp
  80318f:	c3                   	ret    
  803190:	3b 04 24             	cmp    (%esp),%eax
  803193:	72 06                	jb     80319b <__umoddi3+0x113>
  803195:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803199:	77 0f                	ja     8031aa <__umoddi3+0x122>
  80319b:	89 f2                	mov    %esi,%edx
  80319d:	29 f9                	sub    %edi,%ecx
  80319f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8031a3:	89 14 24             	mov    %edx,(%esp)
  8031a6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031aa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8031ae:	8b 14 24             	mov    (%esp),%edx
  8031b1:	83 c4 1c             	add    $0x1c,%esp
  8031b4:	5b                   	pop    %ebx
  8031b5:	5e                   	pop    %esi
  8031b6:	5f                   	pop    %edi
  8031b7:	5d                   	pop    %ebp
  8031b8:	c3                   	ret    
  8031b9:	8d 76 00             	lea    0x0(%esi),%esi
  8031bc:	2b 04 24             	sub    (%esp),%eax
  8031bf:	19 fa                	sbb    %edi,%edx
  8031c1:	89 d1                	mov    %edx,%ecx
  8031c3:	89 c6                	mov    %eax,%esi
  8031c5:	e9 71 ff ff ff       	jmp    80313b <__umoddi3+0xb3>
  8031ca:	66 90                	xchg   %ax,%ax
  8031cc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8031d0:	72 ea                	jb     8031bc <__umoddi3+0x134>
  8031d2:	89 d9                	mov    %ebx,%ecx
  8031d4:	e9 62 ff ff ff       	jmp    80313b <__umoddi3+0xb3>
