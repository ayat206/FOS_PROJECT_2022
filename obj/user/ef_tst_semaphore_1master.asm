
obj/user/ef_tst_semaphore_1master:     file format elf32-i386


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
  800031:	e8 f8 01 00 00       	call   80022e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the semaphores, run slaves and wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int envID = sys_getenvid();
  80003e:	e8 40 1c 00 00       	call   801c83 <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	sys_createSemaphore("cs1", 1);
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	6a 01                	push   $0x1
  80004b:	68 c0 31 80 00       	push   $0x8031c0
  800050:	e8 c8 1a 00 00       	call   801b1d <sys_createSemaphore>
  800055:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore("depend1", 0);
  800058:	83 ec 08             	sub    $0x8,%esp
  80005b:	6a 00                	push   $0x0
  80005d:	68 c4 31 80 00       	push   $0x8031c4
  800062:	e8 b6 1a 00 00       	call   801b1d <sys_createSemaphore>
  800067:	83 c4 10             	add    $0x10,%esp

	int id1, id2, id3;
	id1 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80006a:	a1 20 40 80 00       	mov    0x804020,%eax
  80006f:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800075:	89 c2                	mov    %eax,%edx
  800077:	a1 20 40 80 00       	mov    0x804020,%eax
  80007c:	8b 40 74             	mov    0x74(%eax),%eax
  80007f:	6a 32                	push   $0x32
  800081:	52                   	push   %edx
  800082:	50                   	push   %eax
  800083:	68 cc 31 80 00       	push   $0x8031cc
  800088:	e8 a1 1b 00 00       	call   801c2e <sys_create_env>
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	89 45 f0             	mov    %eax,-0x10(%ebp)
	id2 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800093:	a1 20 40 80 00       	mov    0x804020,%eax
  800098:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80009e:	89 c2                	mov    %eax,%edx
  8000a0:	a1 20 40 80 00       	mov    0x804020,%eax
  8000a5:	8b 40 74             	mov    0x74(%eax),%eax
  8000a8:	6a 32                	push   $0x32
  8000aa:	52                   	push   %edx
  8000ab:	50                   	push   %eax
  8000ac:	68 cc 31 80 00       	push   $0x8031cc
  8000b1:	e8 78 1b 00 00       	call   801c2e <sys_create_env>
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	id3 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000bc:	a1 20 40 80 00       	mov    0x804020,%eax
  8000c1:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000c7:	89 c2                	mov    %eax,%edx
  8000c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8000ce:	8b 40 74             	mov    0x74(%eax),%eax
  8000d1:	6a 32                	push   $0x32
  8000d3:	52                   	push   %edx
  8000d4:	50                   	push   %eax
  8000d5:	68 cc 31 80 00       	push   $0x8031cc
  8000da:	e8 4f 1b 00 00       	call   801c2e <sys_create_env>
  8000df:	83 c4 10             	add    $0x10,%esp
  8000e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (id1 == E_ENV_CREATION_ERROR || id2 == E_ENV_CREATION_ERROR || id3 == E_ENV_CREATION_ERROR)
  8000e5:	83 7d f0 ef          	cmpl   $0xffffffef,-0x10(%ebp)
  8000e9:	74 0c                	je     8000f7 <_main+0xbf>
  8000eb:	83 7d ec ef          	cmpl   $0xffffffef,-0x14(%ebp)
  8000ef:	74 06                	je     8000f7 <_main+0xbf>
  8000f1:	83 7d e8 ef          	cmpl   $0xffffffef,-0x18(%ebp)
  8000f5:	75 14                	jne    80010b <_main+0xd3>
		panic("NO AVAILABLE ENVs...");
  8000f7:	83 ec 04             	sub    $0x4,%esp
  8000fa:	68 d9 31 80 00       	push   $0x8031d9
  8000ff:	6a 13                	push   $0x13
  800101:	68 f0 31 80 00       	push   $0x8031f0
  800106:	e8 5f 02 00 00       	call   80036a <_panic>

	sys_run_env(id1);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	ff 75 f0             	pushl  -0x10(%ebp)
  800111:	e8 36 1b 00 00       	call   801c4c <sys_run_env>
  800116:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	ff 75 ec             	pushl  -0x14(%ebp)
  80011f:	e8 28 1b 00 00       	call   801c4c <sys_run_env>
  800124:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 e8             	pushl  -0x18(%ebp)
  80012d:	e8 1a 1b 00 00       	call   801c4c <sys_run_env>
  800132:	83 c4 10             	add    $0x10,%esp

	sys_waitSemaphore(envID, "depend1") ;
  800135:	83 ec 08             	sub    $0x8,%esp
  800138:	68 c4 31 80 00       	push   $0x8031c4
  80013d:	ff 75 f4             	pushl  -0xc(%ebp)
  800140:	e8 11 1a 00 00       	call   801b56 <sys_waitSemaphore>
  800145:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	68 c4 31 80 00       	push   $0x8031c4
  800150:	ff 75 f4             	pushl  -0xc(%ebp)
  800153:	e8 fe 19 00 00       	call   801b56 <sys_waitSemaphore>
  800158:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	68 c4 31 80 00       	push   $0x8031c4
  800163:	ff 75 f4             	pushl  -0xc(%ebp)
  800166:	e8 eb 19 00 00       	call   801b56 <sys_waitSemaphore>
  80016b:	83 c4 10             	add    $0x10,%esp

	int sem1val = sys_getSemaphoreValue(envID, "cs1");
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	68 c0 31 80 00       	push   $0x8031c0
  800176:	ff 75 f4             	pushl  -0xc(%ebp)
  800179:	e8 bb 19 00 00       	call   801b39 <sys_getSemaphoreValue>
  80017e:	83 c4 10             	add    $0x10,%esp
  800181:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int sem2val = sys_getSemaphoreValue(envID, "depend1");
  800184:	83 ec 08             	sub    $0x8,%esp
  800187:	68 c4 31 80 00       	push   $0x8031c4
  80018c:	ff 75 f4             	pushl  -0xc(%ebp)
  80018f:	e8 a5 19 00 00       	call   801b39 <sys_getSemaphoreValue>
  800194:	83 c4 10             	add    $0x10,%esp
  800197:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (sem2val == 0 && sem1val == 1)
  80019a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80019e:	75 18                	jne    8001b8 <_main+0x180>
  8001a0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8001a4:	75 12                	jne    8001b8 <_main+0x180>
		cprintf("Congratulations!! Test of Semaphores [1] completed successfully!!\n\n\n");
  8001a6:	83 ec 0c             	sub    $0xc,%esp
  8001a9:	68 10 32 80 00       	push   $0x803210
  8001ae:	e8 6b 04 00 00       	call   80061e <cprintf>
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	eb 10                	jmp    8001c8 <_main+0x190>
	else
		cprintf("Error: wrong semaphore value... please review your semaphore code again...");
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	68 58 32 80 00       	push   $0x803258
  8001c0:	e8 59 04 00 00       	call   80061e <cprintf>
  8001c5:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  8001c8:	e8 e8 1a 00 00       	call   801cb5 <sys_getparentenvid>
  8001cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(parentenvID > 0)
  8001d0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001d4:	7e 55                	jle    80022b <_main+0x1f3>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  8001d6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  8001dd:	83 ec 08             	sub    $0x8,%esp
  8001e0:	68 a3 32 80 00       	push   $0x8032a3
  8001e5:	ff 75 dc             	pushl  -0x24(%ebp)
  8001e8:	e8 bb 15 00 00       	call   8017a8 <sget>
  8001ed:	83 c4 10             	add    $0x10,%esp
  8001f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_destroy_env(id1);
  8001f3:	83 ec 0c             	sub    $0xc,%esp
  8001f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f9:	e8 6a 1a 00 00       	call   801c68 <sys_destroy_env>
  8001fe:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	ff 75 ec             	pushl  -0x14(%ebp)
  800207:	e8 5c 1a 00 00       	call   801c68 <sys_destroy_env>
  80020c:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	ff 75 e8             	pushl  -0x18(%ebp)
  800215:	e8 4e 1a 00 00       	call   801c68 <sys_destroy_env>
  80021a:	83 c4 10             	add    $0x10,%esp
		(*finishedCount)++ ;
  80021d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800220:	8b 00                	mov    (%eax),%eax
  800222:	8d 50 01             	lea    0x1(%eax),%edx
  800225:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800228:	89 10                	mov    %edx,(%eax)
	}

	return;
  80022a:	90                   	nop
  80022b:	90                   	nop
}
  80022c:	c9                   	leave  
  80022d:	c3                   	ret    

0080022e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80022e:	55                   	push   %ebp
  80022f:	89 e5                	mov    %esp,%ebp
  800231:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800234:	e8 63 1a 00 00       	call   801c9c <sys_getenvindex>
  800239:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80023c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80023f:	89 d0                	mov    %edx,%eax
  800241:	c1 e0 03             	shl    $0x3,%eax
  800244:	01 d0                	add    %edx,%eax
  800246:	01 c0                	add    %eax,%eax
  800248:	01 d0                	add    %edx,%eax
  80024a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800251:	01 d0                	add    %edx,%eax
  800253:	c1 e0 04             	shl    $0x4,%eax
  800256:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80025b:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800260:	a1 20 40 80 00       	mov    0x804020,%eax
  800265:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80026b:	84 c0                	test   %al,%al
  80026d:	74 0f                	je     80027e <libmain+0x50>
		binaryname = myEnv->prog_name;
  80026f:	a1 20 40 80 00       	mov    0x804020,%eax
  800274:	05 5c 05 00 00       	add    $0x55c,%eax
  800279:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80027e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800282:	7e 0a                	jle    80028e <libmain+0x60>
		binaryname = argv[0];
  800284:	8b 45 0c             	mov    0xc(%ebp),%eax
  800287:	8b 00                	mov    (%eax),%eax
  800289:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80028e:	83 ec 08             	sub    $0x8,%esp
  800291:	ff 75 0c             	pushl  0xc(%ebp)
  800294:	ff 75 08             	pushl  0x8(%ebp)
  800297:	e8 9c fd ff ff       	call   800038 <_main>
  80029c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80029f:	e8 05 18 00 00       	call   801aa9 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	68 cc 32 80 00       	push   $0x8032cc
  8002ac:	e8 6d 03 00 00       	call   80061e <cprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002b4:	a1 20 40 80 00       	mov    0x804020,%eax
  8002b9:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002bf:	a1 20 40 80 00       	mov    0x804020,%eax
  8002c4:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002ca:	83 ec 04             	sub    $0x4,%esp
  8002cd:	52                   	push   %edx
  8002ce:	50                   	push   %eax
  8002cf:	68 f4 32 80 00       	push   $0x8032f4
  8002d4:	e8 45 03 00 00       	call   80061e <cprintf>
  8002d9:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8002e1:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ec:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8002f2:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f7:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002fd:	51                   	push   %ecx
  8002fe:	52                   	push   %edx
  8002ff:	50                   	push   %eax
  800300:	68 1c 33 80 00       	push   $0x80331c
  800305:	e8 14 03 00 00       	call   80061e <cprintf>
  80030a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80030d:	a1 20 40 80 00       	mov    0x804020,%eax
  800312:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	50                   	push   %eax
  80031c:	68 74 33 80 00       	push   $0x803374
  800321:	e8 f8 02 00 00       	call   80061e <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800329:	83 ec 0c             	sub    $0xc,%esp
  80032c:	68 cc 32 80 00       	push   $0x8032cc
  800331:	e8 e8 02 00 00       	call   80061e <cprintf>
  800336:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800339:	e8 85 17 00 00       	call   801ac3 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80033e:	e8 19 00 00 00       	call   80035c <exit>
}
  800343:	90                   	nop
  800344:	c9                   	leave  
  800345:	c3                   	ret    

00800346 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80034c:	83 ec 0c             	sub    $0xc,%esp
  80034f:	6a 00                	push   $0x0
  800351:	e8 12 19 00 00       	call   801c68 <sys_destroy_env>
  800356:	83 c4 10             	add    $0x10,%esp
}
  800359:	90                   	nop
  80035a:	c9                   	leave  
  80035b:	c3                   	ret    

0080035c <exit>:

void
exit(void)
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800362:	e8 67 19 00 00       	call   801cce <sys_exit_env>
}
  800367:	90                   	nop
  800368:	c9                   	leave  
  800369:	c3                   	ret    

0080036a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
  80036d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800370:	8d 45 10             	lea    0x10(%ebp),%eax
  800373:	83 c0 04             	add    $0x4,%eax
  800376:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800379:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80037e:	85 c0                	test   %eax,%eax
  800380:	74 16                	je     800398 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800382:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800387:	83 ec 08             	sub    $0x8,%esp
  80038a:	50                   	push   %eax
  80038b:	68 88 33 80 00       	push   $0x803388
  800390:	e8 89 02 00 00       	call   80061e <cprintf>
  800395:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800398:	a1 00 40 80 00       	mov    0x804000,%eax
  80039d:	ff 75 0c             	pushl  0xc(%ebp)
  8003a0:	ff 75 08             	pushl  0x8(%ebp)
  8003a3:	50                   	push   %eax
  8003a4:	68 8d 33 80 00       	push   $0x80338d
  8003a9:	e8 70 02 00 00       	call   80061e <cprintf>
  8003ae:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b4:	83 ec 08             	sub    $0x8,%esp
  8003b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ba:	50                   	push   %eax
  8003bb:	e8 f3 01 00 00       	call   8005b3 <vcprintf>
  8003c0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003c3:	83 ec 08             	sub    $0x8,%esp
  8003c6:	6a 00                	push   $0x0
  8003c8:	68 a9 33 80 00       	push   $0x8033a9
  8003cd:	e8 e1 01 00 00       	call   8005b3 <vcprintf>
  8003d2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003d5:	e8 82 ff ff ff       	call   80035c <exit>

	// should not return here
	while (1) ;
  8003da:	eb fe                	jmp    8003da <_panic+0x70>

008003dc <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003e2:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e7:	8b 50 74             	mov    0x74(%eax),%edx
  8003ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ed:	39 c2                	cmp    %eax,%edx
  8003ef:	74 14                	je     800405 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003f1:	83 ec 04             	sub    $0x4,%esp
  8003f4:	68 ac 33 80 00       	push   $0x8033ac
  8003f9:	6a 26                	push   $0x26
  8003fb:	68 f8 33 80 00       	push   $0x8033f8
  800400:	e8 65 ff ff ff       	call   80036a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800405:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80040c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800413:	e9 c2 00 00 00       	jmp    8004da <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80041b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800422:	8b 45 08             	mov    0x8(%ebp),%eax
  800425:	01 d0                	add    %edx,%eax
  800427:	8b 00                	mov    (%eax),%eax
  800429:	85 c0                	test   %eax,%eax
  80042b:	75 08                	jne    800435 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80042d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800430:	e9 a2 00 00 00       	jmp    8004d7 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800435:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800443:	eb 69                	jmp    8004ae <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800445:	a1 20 40 80 00       	mov    0x804020,%eax
  80044a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800450:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800453:	89 d0                	mov    %edx,%eax
  800455:	01 c0                	add    %eax,%eax
  800457:	01 d0                	add    %edx,%eax
  800459:	c1 e0 03             	shl    $0x3,%eax
  80045c:	01 c8                	add    %ecx,%eax
  80045e:	8a 40 04             	mov    0x4(%eax),%al
  800461:	84 c0                	test   %al,%al
  800463:	75 46                	jne    8004ab <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800465:	a1 20 40 80 00       	mov    0x804020,%eax
  80046a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800470:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800473:	89 d0                	mov    %edx,%eax
  800475:	01 c0                	add    %eax,%eax
  800477:	01 d0                	add    %edx,%eax
  800479:	c1 e0 03             	shl    $0x3,%eax
  80047c:	01 c8                	add    %ecx,%eax
  80047e:	8b 00                	mov    (%eax),%eax
  800480:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800483:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800486:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80048b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80048d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800490:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	01 c8                	add    %ecx,%eax
  80049c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80049e:	39 c2                	cmp    %eax,%edx
  8004a0:	75 09                	jne    8004ab <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004a2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004a9:	eb 12                	jmp    8004bd <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ab:	ff 45 e8             	incl   -0x18(%ebp)
  8004ae:	a1 20 40 80 00       	mov    0x804020,%eax
  8004b3:	8b 50 74             	mov    0x74(%eax),%edx
  8004b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004b9:	39 c2                	cmp    %eax,%edx
  8004bb:	77 88                	ja     800445 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004c1:	75 14                	jne    8004d7 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004c3:	83 ec 04             	sub    $0x4,%esp
  8004c6:	68 04 34 80 00       	push   $0x803404
  8004cb:	6a 3a                	push   $0x3a
  8004cd:	68 f8 33 80 00       	push   $0x8033f8
  8004d2:	e8 93 fe ff ff       	call   80036a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004d7:	ff 45 f0             	incl   -0x10(%ebp)
  8004da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004e0:	0f 8c 32 ff ff ff    	jl     800418 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ed:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004f4:	eb 26                	jmp    80051c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004f6:	a1 20 40 80 00       	mov    0x804020,%eax
  8004fb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800501:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800504:	89 d0                	mov    %edx,%eax
  800506:	01 c0                	add    %eax,%eax
  800508:	01 d0                	add    %edx,%eax
  80050a:	c1 e0 03             	shl    $0x3,%eax
  80050d:	01 c8                	add    %ecx,%eax
  80050f:	8a 40 04             	mov    0x4(%eax),%al
  800512:	3c 01                	cmp    $0x1,%al
  800514:	75 03                	jne    800519 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800516:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800519:	ff 45 e0             	incl   -0x20(%ebp)
  80051c:	a1 20 40 80 00       	mov    0x804020,%eax
  800521:	8b 50 74             	mov    0x74(%eax),%edx
  800524:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800527:	39 c2                	cmp    %eax,%edx
  800529:	77 cb                	ja     8004f6 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80052b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80052e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800531:	74 14                	je     800547 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800533:	83 ec 04             	sub    $0x4,%esp
  800536:	68 58 34 80 00       	push   $0x803458
  80053b:	6a 44                	push   $0x44
  80053d:	68 f8 33 80 00       	push   $0x8033f8
  800542:	e8 23 fe ff ff       	call   80036a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800550:	8b 45 0c             	mov    0xc(%ebp),%eax
  800553:	8b 00                	mov    (%eax),%eax
  800555:	8d 48 01             	lea    0x1(%eax),%ecx
  800558:	8b 55 0c             	mov    0xc(%ebp),%edx
  80055b:	89 0a                	mov    %ecx,(%edx)
  80055d:	8b 55 08             	mov    0x8(%ebp),%edx
  800560:	88 d1                	mov    %dl,%cl
  800562:	8b 55 0c             	mov    0xc(%ebp),%edx
  800565:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056c:	8b 00                	mov    (%eax),%eax
  80056e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800573:	75 2c                	jne    8005a1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800575:	a0 24 40 80 00       	mov    0x804024,%al
  80057a:	0f b6 c0             	movzbl %al,%eax
  80057d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800580:	8b 12                	mov    (%edx),%edx
  800582:	89 d1                	mov    %edx,%ecx
  800584:	8b 55 0c             	mov    0xc(%ebp),%edx
  800587:	83 c2 08             	add    $0x8,%edx
  80058a:	83 ec 04             	sub    $0x4,%esp
  80058d:	50                   	push   %eax
  80058e:	51                   	push   %ecx
  80058f:	52                   	push   %edx
  800590:	e8 66 13 00 00       	call   8018fb <sys_cputs>
  800595:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a4:	8b 40 04             	mov    0x4(%eax),%eax
  8005a7:	8d 50 01             	lea    0x1(%eax),%edx
  8005aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ad:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005b0:	90                   	nop
  8005b1:	c9                   	leave  
  8005b2:	c3                   	ret    

008005b3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005b3:	55                   	push   %ebp
  8005b4:	89 e5                	mov    %esp,%ebp
  8005b6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005bc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005c3:	00 00 00 
	b.cnt = 0;
  8005c6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005cd:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005d0:	ff 75 0c             	pushl  0xc(%ebp)
  8005d3:	ff 75 08             	pushl  0x8(%ebp)
  8005d6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005dc:	50                   	push   %eax
  8005dd:	68 4a 05 80 00       	push   $0x80054a
  8005e2:	e8 11 02 00 00       	call   8007f8 <vprintfmt>
  8005e7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005ea:	a0 24 40 80 00       	mov    0x804024,%al
  8005ef:	0f b6 c0             	movzbl %al,%eax
  8005f2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005f8:	83 ec 04             	sub    $0x4,%esp
  8005fb:	50                   	push   %eax
  8005fc:	52                   	push   %edx
  8005fd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800603:	83 c0 08             	add    $0x8,%eax
  800606:	50                   	push   %eax
  800607:	e8 ef 12 00 00       	call   8018fb <sys_cputs>
  80060c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80060f:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800616:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80061c:	c9                   	leave  
  80061d:	c3                   	ret    

0080061e <cprintf>:

int cprintf(const char *fmt, ...) {
  80061e:	55                   	push   %ebp
  80061f:	89 e5                	mov    %esp,%ebp
  800621:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800624:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80062b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80062e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800631:	8b 45 08             	mov    0x8(%ebp),%eax
  800634:	83 ec 08             	sub    $0x8,%esp
  800637:	ff 75 f4             	pushl  -0xc(%ebp)
  80063a:	50                   	push   %eax
  80063b:	e8 73 ff ff ff       	call   8005b3 <vcprintf>
  800640:	83 c4 10             	add    $0x10,%esp
  800643:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800646:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800649:	c9                   	leave  
  80064a:	c3                   	ret    

0080064b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80064b:	55                   	push   %ebp
  80064c:	89 e5                	mov    %esp,%ebp
  80064e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800651:	e8 53 14 00 00       	call   801aa9 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800656:	8d 45 0c             	lea    0xc(%ebp),%eax
  800659:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80065c:	8b 45 08             	mov    0x8(%ebp),%eax
  80065f:	83 ec 08             	sub    $0x8,%esp
  800662:	ff 75 f4             	pushl  -0xc(%ebp)
  800665:	50                   	push   %eax
  800666:	e8 48 ff ff ff       	call   8005b3 <vcprintf>
  80066b:	83 c4 10             	add    $0x10,%esp
  80066e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800671:	e8 4d 14 00 00       	call   801ac3 <sys_enable_interrupt>
	return cnt;
  800676:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800679:	c9                   	leave  
  80067a:	c3                   	ret    

0080067b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80067b:	55                   	push   %ebp
  80067c:	89 e5                	mov    %esp,%ebp
  80067e:	53                   	push   %ebx
  80067f:	83 ec 14             	sub    $0x14,%esp
  800682:	8b 45 10             	mov    0x10(%ebp),%eax
  800685:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80068e:	8b 45 18             	mov    0x18(%ebp),%eax
  800691:	ba 00 00 00 00       	mov    $0x0,%edx
  800696:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800699:	77 55                	ja     8006f0 <printnum+0x75>
  80069b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80069e:	72 05                	jb     8006a5 <printnum+0x2a>
  8006a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006a3:	77 4b                	ja     8006f0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006a5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006a8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006ab:	8b 45 18             	mov    0x18(%ebp),%eax
  8006ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b3:	52                   	push   %edx
  8006b4:	50                   	push   %eax
  8006b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8006b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8006bb:	e8 84 28 00 00       	call   802f44 <__udivdi3>
  8006c0:	83 c4 10             	add    $0x10,%esp
  8006c3:	83 ec 04             	sub    $0x4,%esp
  8006c6:	ff 75 20             	pushl  0x20(%ebp)
  8006c9:	53                   	push   %ebx
  8006ca:	ff 75 18             	pushl  0x18(%ebp)
  8006cd:	52                   	push   %edx
  8006ce:	50                   	push   %eax
  8006cf:	ff 75 0c             	pushl  0xc(%ebp)
  8006d2:	ff 75 08             	pushl  0x8(%ebp)
  8006d5:	e8 a1 ff ff ff       	call   80067b <printnum>
  8006da:	83 c4 20             	add    $0x20,%esp
  8006dd:	eb 1a                	jmp    8006f9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006df:	83 ec 08             	sub    $0x8,%esp
  8006e2:	ff 75 0c             	pushl  0xc(%ebp)
  8006e5:	ff 75 20             	pushl  0x20(%ebp)
  8006e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006eb:	ff d0                	call   *%eax
  8006ed:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006f0:	ff 4d 1c             	decl   0x1c(%ebp)
  8006f3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006f7:	7f e6                	jg     8006df <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006f9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800704:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800707:	53                   	push   %ebx
  800708:	51                   	push   %ecx
  800709:	52                   	push   %edx
  80070a:	50                   	push   %eax
  80070b:	e8 44 29 00 00       	call   803054 <__umoddi3>
  800710:	83 c4 10             	add    $0x10,%esp
  800713:	05 d4 36 80 00       	add    $0x8036d4,%eax
  800718:	8a 00                	mov    (%eax),%al
  80071a:	0f be c0             	movsbl %al,%eax
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	ff 75 0c             	pushl  0xc(%ebp)
  800723:	50                   	push   %eax
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	ff d0                	call   *%eax
  800729:	83 c4 10             	add    $0x10,%esp
}
  80072c:	90                   	nop
  80072d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800730:	c9                   	leave  
  800731:	c3                   	ret    

00800732 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800732:	55                   	push   %ebp
  800733:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800735:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800739:	7e 1c                	jle    800757 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80073b:	8b 45 08             	mov    0x8(%ebp),%eax
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	8d 50 08             	lea    0x8(%eax),%edx
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	89 10                	mov    %edx,(%eax)
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	8b 00                	mov    (%eax),%eax
  80074d:	83 e8 08             	sub    $0x8,%eax
  800750:	8b 50 04             	mov    0x4(%eax),%edx
  800753:	8b 00                	mov    (%eax),%eax
  800755:	eb 40                	jmp    800797 <getuint+0x65>
	else if (lflag)
  800757:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80075b:	74 1e                	je     80077b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	8d 50 04             	lea    0x4(%eax),%edx
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	89 10                	mov    %edx,(%eax)
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	83 e8 04             	sub    $0x4,%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	ba 00 00 00 00       	mov    $0x0,%edx
  800779:	eb 1c                	jmp    800797 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	8d 50 04             	lea    0x4(%eax),%edx
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	89 10                	mov    %edx,(%eax)
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	8b 00                	mov    (%eax),%eax
  80078d:	83 e8 04             	sub    $0x4,%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800797:	5d                   	pop    %ebp
  800798:	c3                   	ret    

00800799 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80079c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007a0:	7e 1c                	jle    8007be <getint+0x25>
		return va_arg(*ap, long long);
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	8b 00                	mov    (%eax),%eax
  8007a7:	8d 50 08             	lea    0x8(%eax),%edx
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	89 10                	mov    %edx,(%eax)
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	8b 00                	mov    (%eax),%eax
  8007b4:	83 e8 08             	sub    $0x8,%eax
  8007b7:	8b 50 04             	mov    0x4(%eax),%edx
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	eb 38                	jmp    8007f6 <getint+0x5d>
	else if (lflag)
  8007be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c2:	74 1a                	je     8007de <getint+0x45>
		return va_arg(*ap, long);
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	8d 50 04             	lea    0x4(%eax),%edx
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	89 10                	mov    %edx,(%eax)
  8007d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	83 e8 04             	sub    $0x4,%eax
  8007d9:	8b 00                	mov    (%eax),%eax
  8007db:	99                   	cltd   
  8007dc:	eb 18                	jmp    8007f6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	8b 00                	mov    (%eax),%eax
  8007e3:	8d 50 04             	lea    0x4(%eax),%edx
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	89 10                	mov    %edx,(%eax)
  8007eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ee:	8b 00                	mov    (%eax),%eax
  8007f0:	83 e8 04             	sub    $0x4,%eax
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	99                   	cltd   
}
  8007f6:	5d                   	pop    %ebp
  8007f7:	c3                   	ret    

008007f8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	56                   	push   %esi
  8007fc:	53                   	push   %ebx
  8007fd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800800:	eb 17                	jmp    800819 <vprintfmt+0x21>
			if (ch == '\0')
  800802:	85 db                	test   %ebx,%ebx
  800804:	0f 84 af 03 00 00    	je     800bb9 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80080a:	83 ec 08             	sub    $0x8,%esp
  80080d:	ff 75 0c             	pushl  0xc(%ebp)
  800810:	53                   	push   %ebx
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	ff d0                	call   *%eax
  800816:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800819:	8b 45 10             	mov    0x10(%ebp),%eax
  80081c:	8d 50 01             	lea    0x1(%eax),%edx
  80081f:	89 55 10             	mov    %edx,0x10(%ebp)
  800822:	8a 00                	mov    (%eax),%al
  800824:	0f b6 d8             	movzbl %al,%ebx
  800827:	83 fb 25             	cmp    $0x25,%ebx
  80082a:	75 d6                	jne    800802 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80082c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800830:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800837:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80083e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800845:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80084c:	8b 45 10             	mov    0x10(%ebp),%eax
  80084f:	8d 50 01             	lea    0x1(%eax),%edx
  800852:	89 55 10             	mov    %edx,0x10(%ebp)
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f b6 d8             	movzbl %al,%ebx
  80085a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80085d:	83 f8 55             	cmp    $0x55,%eax
  800860:	0f 87 2b 03 00 00    	ja     800b91 <vprintfmt+0x399>
  800866:	8b 04 85 f8 36 80 00 	mov    0x8036f8(,%eax,4),%eax
  80086d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80086f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800873:	eb d7                	jmp    80084c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800875:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800879:	eb d1                	jmp    80084c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80087b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800882:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800885:	89 d0                	mov    %edx,%eax
  800887:	c1 e0 02             	shl    $0x2,%eax
  80088a:	01 d0                	add    %edx,%eax
  80088c:	01 c0                	add    %eax,%eax
  80088e:	01 d8                	add    %ebx,%eax
  800890:	83 e8 30             	sub    $0x30,%eax
  800893:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800896:	8b 45 10             	mov    0x10(%ebp),%eax
  800899:	8a 00                	mov    (%eax),%al
  80089b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80089e:	83 fb 2f             	cmp    $0x2f,%ebx
  8008a1:	7e 3e                	jle    8008e1 <vprintfmt+0xe9>
  8008a3:	83 fb 39             	cmp    $0x39,%ebx
  8008a6:	7f 39                	jg     8008e1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008ab:	eb d5                	jmp    800882 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b0:	83 c0 04             	add    $0x4,%eax
  8008b3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b9:	83 e8 04             	sub    $0x4,%eax
  8008bc:	8b 00                	mov    (%eax),%eax
  8008be:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008c1:	eb 1f                	jmp    8008e2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c7:	79 83                	jns    80084c <vprintfmt+0x54>
				width = 0;
  8008c9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008d0:	e9 77 ff ff ff       	jmp    80084c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008d5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008dc:	e9 6b ff ff ff       	jmp    80084c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008e1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e6:	0f 89 60 ff ff ff    	jns    80084c <vprintfmt+0x54>
				width = precision, precision = -1;
  8008ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008f9:	e9 4e ff ff ff       	jmp    80084c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008fe:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800901:	e9 46 ff ff ff       	jmp    80084c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800906:	8b 45 14             	mov    0x14(%ebp),%eax
  800909:	83 c0 04             	add    $0x4,%eax
  80090c:	89 45 14             	mov    %eax,0x14(%ebp)
  80090f:	8b 45 14             	mov    0x14(%ebp),%eax
  800912:	83 e8 04             	sub    $0x4,%eax
  800915:	8b 00                	mov    (%eax),%eax
  800917:	83 ec 08             	sub    $0x8,%esp
  80091a:	ff 75 0c             	pushl  0xc(%ebp)
  80091d:	50                   	push   %eax
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	ff d0                	call   *%eax
  800923:	83 c4 10             	add    $0x10,%esp
			break;
  800926:	e9 89 02 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80092b:	8b 45 14             	mov    0x14(%ebp),%eax
  80092e:	83 c0 04             	add    $0x4,%eax
  800931:	89 45 14             	mov    %eax,0x14(%ebp)
  800934:	8b 45 14             	mov    0x14(%ebp),%eax
  800937:	83 e8 04             	sub    $0x4,%eax
  80093a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80093c:	85 db                	test   %ebx,%ebx
  80093e:	79 02                	jns    800942 <vprintfmt+0x14a>
				err = -err;
  800940:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800942:	83 fb 64             	cmp    $0x64,%ebx
  800945:	7f 0b                	jg     800952 <vprintfmt+0x15a>
  800947:	8b 34 9d 40 35 80 00 	mov    0x803540(,%ebx,4),%esi
  80094e:	85 f6                	test   %esi,%esi
  800950:	75 19                	jne    80096b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800952:	53                   	push   %ebx
  800953:	68 e5 36 80 00       	push   $0x8036e5
  800958:	ff 75 0c             	pushl  0xc(%ebp)
  80095b:	ff 75 08             	pushl  0x8(%ebp)
  80095e:	e8 5e 02 00 00       	call   800bc1 <printfmt>
  800963:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800966:	e9 49 02 00 00       	jmp    800bb4 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80096b:	56                   	push   %esi
  80096c:	68 ee 36 80 00       	push   $0x8036ee
  800971:	ff 75 0c             	pushl  0xc(%ebp)
  800974:	ff 75 08             	pushl  0x8(%ebp)
  800977:	e8 45 02 00 00       	call   800bc1 <printfmt>
  80097c:	83 c4 10             	add    $0x10,%esp
			break;
  80097f:	e9 30 02 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800984:	8b 45 14             	mov    0x14(%ebp),%eax
  800987:	83 c0 04             	add    $0x4,%eax
  80098a:	89 45 14             	mov    %eax,0x14(%ebp)
  80098d:	8b 45 14             	mov    0x14(%ebp),%eax
  800990:	83 e8 04             	sub    $0x4,%eax
  800993:	8b 30                	mov    (%eax),%esi
  800995:	85 f6                	test   %esi,%esi
  800997:	75 05                	jne    80099e <vprintfmt+0x1a6>
				p = "(null)";
  800999:	be f1 36 80 00       	mov    $0x8036f1,%esi
			if (width > 0 && padc != '-')
  80099e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a2:	7e 6d                	jle    800a11 <vprintfmt+0x219>
  8009a4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009a8:	74 67                	je     800a11 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009ad:	83 ec 08             	sub    $0x8,%esp
  8009b0:	50                   	push   %eax
  8009b1:	56                   	push   %esi
  8009b2:	e8 0c 03 00 00       	call   800cc3 <strnlen>
  8009b7:	83 c4 10             	add    $0x10,%esp
  8009ba:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009bd:	eb 16                	jmp    8009d5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009bf:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009c3:	83 ec 08             	sub    $0x8,%esp
  8009c6:	ff 75 0c             	pushl  0xc(%ebp)
  8009c9:	50                   	push   %eax
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	ff d0                	call   *%eax
  8009cf:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d2:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d9:	7f e4                	jg     8009bf <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009db:	eb 34                	jmp    800a11 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009dd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009e1:	74 1c                	je     8009ff <vprintfmt+0x207>
  8009e3:	83 fb 1f             	cmp    $0x1f,%ebx
  8009e6:	7e 05                	jle    8009ed <vprintfmt+0x1f5>
  8009e8:	83 fb 7e             	cmp    $0x7e,%ebx
  8009eb:	7e 12                	jle    8009ff <vprintfmt+0x207>
					putch('?', putdat);
  8009ed:	83 ec 08             	sub    $0x8,%esp
  8009f0:	ff 75 0c             	pushl  0xc(%ebp)
  8009f3:	6a 3f                	push   $0x3f
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	ff d0                	call   *%eax
  8009fa:	83 c4 10             	add    $0x10,%esp
  8009fd:	eb 0f                	jmp    800a0e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	53                   	push   %ebx
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	ff d0                	call   *%eax
  800a0b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0e:	ff 4d e4             	decl   -0x1c(%ebp)
  800a11:	89 f0                	mov    %esi,%eax
  800a13:	8d 70 01             	lea    0x1(%eax),%esi
  800a16:	8a 00                	mov    (%eax),%al
  800a18:	0f be d8             	movsbl %al,%ebx
  800a1b:	85 db                	test   %ebx,%ebx
  800a1d:	74 24                	je     800a43 <vprintfmt+0x24b>
  800a1f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a23:	78 b8                	js     8009dd <vprintfmt+0x1e5>
  800a25:	ff 4d e0             	decl   -0x20(%ebp)
  800a28:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a2c:	79 af                	jns    8009dd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a2e:	eb 13                	jmp    800a43 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a30:	83 ec 08             	sub    $0x8,%esp
  800a33:	ff 75 0c             	pushl  0xc(%ebp)
  800a36:	6a 20                	push   $0x20
  800a38:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3b:	ff d0                	call   *%eax
  800a3d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a40:	ff 4d e4             	decl   -0x1c(%ebp)
  800a43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a47:	7f e7                	jg     800a30 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a49:	e9 66 01 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	ff 75 e8             	pushl  -0x18(%ebp)
  800a54:	8d 45 14             	lea    0x14(%ebp),%eax
  800a57:	50                   	push   %eax
  800a58:	e8 3c fd ff ff       	call   800799 <getint>
  800a5d:	83 c4 10             	add    $0x10,%esp
  800a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a63:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a6c:	85 d2                	test   %edx,%edx
  800a6e:	79 23                	jns    800a93 <vprintfmt+0x29b>
				putch('-', putdat);
  800a70:	83 ec 08             	sub    $0x8,%esp
  800a73:	ff 75 0c             	pushl  0xc(%ebp)
  800a76:	6a 2d                	push   $0x2d
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	ff d0                	call   *%eax
  800a7d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a86:	f7 d8                	neg    %eax
  800a88:	83 d2 00             	adc    $0x0,%edx
  800a8b:	f7 da                	neg    %edx
  800a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a90:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a93:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a9a:	e9 bc 00 00 00       	jmp    800b5b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa5:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa8:	50                   	push   %eax
  800aa9:	e8 84 fc ff ff       	call   800732 <getuint>
  800aae:	83 c4 10             	add    $0x10,%esp
  800ab1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ab7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800abe:	e9 98 00 00 00       	jmp    800b5b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ac3:	83 ec 08             	sub    $0x8,%esp
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	6a 58                	push   $0x58
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	ff d0                	call   *%eax
  800ad0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	6a 58                	push   $0x58
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	ff d0                	call   *%eax
  800ae0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ae3:	83 ec 08             	sub    $0x8,%esp
  800ae6:	ff 75 0c             	pushl  0xc(%ebp)
  800ae9:	6a 58                	push   $0x58
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	ff d0                	call   *%eax
  800af0:	83 c4 10             	add    $0x10,%esp
			break;
  800af3:	e9 bc 00 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 0c             	pushl  0xc(%ebp)
  800afe:	6a 30                	push   $0x30
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	ff d0                	call   *%eax
  800b05:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b08:	83 ec 08             	sub    $0x8,%esp
  800b0b:	ff 75 0c             	pushl  0xc(%ebp)
  800b0e:	6a 78                	push   $0x78
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	ff d0                	call   *%eax
  800b15:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b18:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1b:	83 c0 04             	add    $0x4,%eax
  800b1e:	89 45 14             	mov    %eax,0x14(%ebp)
  800b21:	8b 45 14             	mov    0x14(%ebp),%eax
  800b24:	83 e8 04             	sub    $0x4,%eax
  800b27:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b33:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b3a:	eb 1f                	jmp    800b5b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 e8             	pushl  -0x18(%ebp)
  800b42:	8d 45 14             	lea    0x14(%ebp),%eax
  800b45:	50                   	push   %eax
  800b46:	e8 e7 fb ff ff       	call   800732 <getuint>
  800b4b:	83 c4 10             	add    $0x10,%esp
  800b4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b51:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b54:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b5b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b62:	83 ec 04             	sub    $0x4,%esp
  800b65:	52                   	push   %edx
  800b66:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b69:	50                   	push   %eax
  800b6a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6d:	ff 75 f0             	pushl  -0x10(%ebp)
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	ff 75 08             	pushl  0x8(%ebp)
  800b76:	e8 00 fb ff ff       	call   80067b <printnum>
  800b7b:	83 c4 20             	add    $0x20,%esp
			break;
  800b7e:	eb 34                	jmp    800bb4 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b80:	83 ec 08             	sub    $0x8,%esp
  800b83:	ff 75 0c             	pushl  0xc(%ebp)
  800b86:	53                   	push   %ebx
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	ff d0                	call   *%eax
  800b8c:	83 c4 10             	add    $0x10,%esp
			break;
  800b8f:	eb 23                	jmp    800bb4 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b91:	83 ec 08             	sub    $0x8,%esp
  800b94:	ff 75 0c             	pushl  0xc(%ebp)
  800b97:	6a 25                	push   $0x25
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	ff d0                	call   *%eax
  800b9e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ba1:	ff 4d 10             	decl   0x10(%ebp)
  800ba4:	eb 03                	jmp    800ba9 <vprintfmt+0x3b1>
  800ba6:	ff 4d 10             	decl   0x10(%ebp)
  800ba9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bac:	48                   	dec    %eax
  800bad:	8a 00                	mov    (%eax),%al
  800baf:	3c 25                	cmp    $0x25,%al
  800bb1:	75 f3                	jne    800ba6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bb3:	90                   	nop
		}
	}
  800bb4:	e9 47 fc ff ff       	jmp    800800 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bb9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bbd:	5b                   	pop    %ebx
  800bbe:	5e                   	pop    %esi
  800bbf:	5d                   	pop    %ebp
  800bc0:	c3                   	ret    

00800bc1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bc7:	8d 45 10             	lea    0x10(%ebp),%eax
  800bca:	83 c0 04             	add    $0x4,%eax
  800bcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd3:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd6:	50                   	push   %eax
  800bd7:	ff 75 0c             	pushl  0xc(%ebp)
  800bda:	ff 75 08             	pushl  0x8(%ebp)
  800bdd:	e8 16 fc ff ff       	call   8007f8 <vprintfmt>
  800be2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800be5:	90                   	nop
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800beb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bee:	8b 40 08             	mov    0x8(%eax),%eax
  800bf1:	8d 50 01             	lea    0x1(%eax),%edx
  800bf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfd:	8b 10                	mov    (%eax),%edx
  800bff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c02:	8b 40 04             	mov    0x4(%eax),%eax
  800c05:	39 c2                	cmp    %eax,%edx
  800c07:	73 12                	jae    800c1b <sprintputch+0x33>
		*b->buf++ = ch;
  800c09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0c:	8b 00                	mov    (%eax),%eax
  800c0e:	8d 48 01             	lea    0x1(%eax),%ecx
  800c11:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c14:	89 0a                	mov    %ecx,(%edx)
  800c16:	8b 55 08             	mov    0x8(%ebp),%edx
  800c19:	88 10                	mov    %dl,(%eax)
}
  800c1b:	90                   	nop
  800c1c:	5d                   	pop    %ebp
  800c1d:	c3                   	ret    

00800c1e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	01 d0                	add    %edx,%eax
  800c35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c3f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c43:	74 06                	je     800c4b <vsnprintf+0x2d>
  800c45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c49:	7f 07                	jg     800c52 <vsnprintf+0x34>
		return -E_INVAL;
  800c4b:	b8 03 00 00 00       	mov    $0x3,%eax
  800c50:	eb 20                	jmp    800c72 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c52:	ff 75 14             	pushl  0x14(%ebp)
  800c55:	ff 75 10             	pushl  0x10(%ebp)
  800c58:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c5b:	50                   	push   %eax
  800c5c:	68 e8 0b 80 00       	push   $0x800be8
  800c61:	e8 92 fb ff ff       	call   8007f8 <vprintfmt>
  800c66:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c6c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c72:	c9                   	leave  
  800c73:	c3                   	ret    

00800c74 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c7a:	8d 45 10             	lea    0x10(%ebp),%eax
  800c7d:	83 c0 04             	add    $0x4,%eax
  800c80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c83:	8b 45 10             	mov    0x10(%ebp),%eax
  800c86:	ff 75 f4             	pushl  -0xc(%ebp)
  800c89:	50                   	push   %eax
  800c8a:	ff 75 0c             	pushl  0xc(%ebp)
  800c8d:	ff 75 08             	pushl  0x8(%ebp)
  800c90:	e8 89 ff ff ff       	call   800c1e <vsnprintf>
  800c95:	83 c4 10             	add    $0x10,%esp
  800c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c9e:	c9                   	leave  
  800c9f:	c3                   	ret    

00800ca0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ca6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cad:	eb 06                	jmp    800cb5 <strlen+0x15>
		n++;
  800caf:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb2:	ff 45 08             	incl   0x8(%ebp)
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	8a 00                	mov    (%eax),%al
  800cba:	84 c0                	test   %al,%al
  800cbc:	75 f1                	jne    800caf <strlen+0xf>
		n++;
	return n;
  800cbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc1:	c9                   	leave  
  800cc2:	c3                   	ret    

00800cc3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cc9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd0:	eb 09                	jmp    800cdb <strnlen+0x18>
		n++;
  800cd2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd5:	ff 45 08             	incl   0x8(%ebp)
  800cd8:	ff 4d 0c             	decl   0xc(%ebp)
  800cdb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cdf:	74 09                	je     800cea <strnlen+0x27>
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	8a 00                	mov    (%eax),%al
  800ce6:	84 c0                	test   %al,%al
  800ce8:	75 e8                	jne    800cd2 <strnlen+0xf>
		n++;
	return n;
  800cea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ced:	c9                   	leave  
  800cee:	c3                   	ret    

00800cef <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cfb:	90                   	nop
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	8d 50 01             	lea    0x1(%eax),%edx
  800d02:	89 55 08             	mov    %edx,0x8(%ebp)
  800d05:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d08:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d0b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d0e:	8a 12                	mov    (%edx),%dl
  800d10:	88 10                	mov    %dl,(%eax)
  800d12:	8a 00                	mov    (%eax),%al
  800d14:	84 c0                	test   %al,%al
  800d16:	75 e4                	jne    800cfc <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d18:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d1b:	c9                   	leave  
  800d1c:	c3                   	ret    

00800d1d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d29:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d30:	eb 1f                	jmp    800d51 <strncpy+0x34>
		*dst++ = *src;
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	8d 50 01             	lea    0x1(%eax),%edx
  800d38:	89 55 08             	mov    %edx,0x8(%ebp)
  800d3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3e:	8a 12                	mov    (%edx),%dl
  800d40:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	84 c0                	test   %al,%al
  800d49:	74 03                	je     800d4e <strncpy+0x31>
			src++;
  800d4b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d4e:	ff 45 fc             	incl   -0x4(%ebp)
  800d51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d54:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d57:	72 d9                	jb     800d32 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d59:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d6e:	74 30                	je     800da0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d70:	eb 16                	jmp    800d88 <strlcpy+0x2a>
			*dst++ = *src++;
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	8d 50 01             	lea    0x1(%eax),%edx
  800d78:	89 55 08             	mov    %edx,0x8(%ebp)
  800d7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d7e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d81:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d84:	8a 12                	mov    (%edx),%dl
  800d86:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d88:	ff 4d 10             	decl   0x10(%ebp)
  800d8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d8f:	74 09                	je     800d9a <strlcpy+0x3c>
  800d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d94:	8a 00                	mov    (%eax),%al
  800d96:	84 c0                	test   %al,%al
  800d98:	75 d8                	jne    800d72 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800da0:	8b 55 08             	mov    0x8(%ebp),%edx
  800da3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da6:	29 c2                	sub    %eax,%edx
  800da8:	89 d0                	mov    %edx,%eax
}
  800daa:	c9                   	leave  
  800dab:	c3                   	ret    

00800dac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800daf:	eb 06                	jmp    800db7 <strcmp+0xb>
		p++, q++;
  800db1:	ff 45 08             	incl   0x8(%ebp)
  800db4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dba:	8a 00                	mov    (%eax),%al
  800dbc:	84 c0                	test   %al,%al
  800dbe:	74 0e                	je     800dce <strcmp+0x22>
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8a 10                	mov    (%eax),%dl
  800dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	38 c2                	cmp    %al,%dl
  800dcc:	74 e3                	je     800db1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	8a 00                	mov    (%eax),%al
  800dd3:	0f b6 d0             	movzbl %al,%edx
  800dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd9:	8a 00                	mov    (%eax),%al
  800ddb:	0f b6 c0             	movzbl %al,%eax
  800dde:	29 c2                	sub    %eax,%edx
  800de0:	89 d0                	mov    %edx,%eax
}
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    

00800de4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800de7:	eb 09                	jmp    800df2 <strncmp+0xe>
		n--, p++, q++;
  800de9:	ff 4d 10             	decl   0x10(%ebp)
  800dec:	ff 45 08             	incl   0x8(%ebp)
  800def:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800df2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df6:	74 17                	je     800e0f <strncmp+0x2b>
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	84 c0                	test   %al,%al
  800dff:	74 0e                	je     800e0f <strncmp+0x2b>
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8a 10                	mov    (%eax),%dl
  800e06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	38 c2                	cmp    %al,%dl
  800e0d:	74 da                	je     800de9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e0f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e13:	75 07                	jne    800e1c <strncmp+0x38>
		return 0;
  800e15:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1a:	eb 14                	jmp    800e30 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	0f b6 d0             	movzbl %al,%edx
  800e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e27:	8a 00                	mov    (%eax),%al
  800e29:	0f b6 c0             	movzbl %al,%eax
  800e2c:	29 c2                	sub    %eax,%edx
  800e2e:	89 d0                	mov    %edx,%eax
}
  800e30:	5d                   	pop    %ebp
  800e31:	c3                   	ret    

00800e32 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
  800e35:	83 ec 04             	sub    $0x4,%esp
  800e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e3e:	eb 12                	jmp    800e52 <strchr+0x20>
		if (*s == c)
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	8a 00                	mov    (%eax),%al
  800e45:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e48:	75 05                	jne    800e4f <strchr+0x1d>
			return (char *) s;
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	eb 11                	jmp    800e60 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e4f:	ff 45 08             	incl   0x8(%ebp)
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	8a 00                	mov    (%eax),%al
  800e57:	84 c0                	test   %al,%al
  800e59:	75 e5                	jne    800e40 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e60:	c9                   	leave  
  800e61:	c3                   	ret    

00800e62 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	83 ec 04             	sub    $0x4,%esp
  800e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e6e:	eb 0d                	jmp    800e7d <strfind+0x1b>
		if (*s == c)
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	8a 00                	mov    (%eax),%al
  800e75:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e78:	74 0e                	je     800e88 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e7a:	ff 45 08             	incl   0x8(%ebp)
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	8a 00                	mov    (%eax),%al
  800e82:	84 c0                	test   %al,%al
  800e84:	75 ea                	jne    800e70 <strfind+0xe>
  800e86:	eb 01                	jmp    800e89 <strfind+0x27>
		if (*s == c)
			break;
  800e88:	90                   	nop
	return (char *) s;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ea0:	eb 0e                	jmp    800eb0 <memset+0x22>
		*p++ = c;
  800ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea5:	8d 50 01             	lea    0x1(%eax),%edx
  800ea8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800eab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eae:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800eb0:	ff 4d f8             	decl   -0x8(%ebp)
  800eb3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800eb7:	79 e9                	jns    800ea2 <memset+0x14>
		*p++ = c;

	return v;
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebc:	c9                   	leave  
  800ebd:	c3                   	ret    

00800ebe <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ed0:	eb 16                	jmp    800ee8 <memcpy+0x2a>
		*d++ = *s++;
  800ed2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed5:	8d 50 01             	lea    0x1(%eax),%edx
  800ed8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800edb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ede:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ee4:	8a 12                	mov    (%edx),%dl
  800ee6:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ee8:	8b 45 10             	mov    0x10(%ebp),%eax
  800eeb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eee:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef1:	85 c0                	test   %eax,%eax
  800ef3:	75 dd                	jne    800ed2 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef8:	c9                   	leave  
  800ef9:	c3                   	ret    

00800efa <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f12:	73 50                	jae    800f64 <memmove+0x6a>
  800f14:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f17:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1a:	01 d0                	add    %edx,%eax
  800f1c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f1f:	76 43                	jbe    800f64 <memmove+0x6a>
		s += n;
  800f21:	8b 45 10             	mov    0x10(%ebp),%eax
  800f24:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f27:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f2d:	eb 10                	jmp    800f3f <memmove+0x45>
			*--d = *--s;
  800f2f:	ff 4d f8             	decl   -0x8(%ebp)
  800f32:	ff 4d fc             	decl   -0x4(%ebp)
  800f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f38:	8a 10                	mov    (%eax),%dl
  800f3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f42:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f45:	89 55 10             	mov    %edx,0x10(%ebp)
  800f48:	85 c0                	test   %eax,%eax
  800f4a:	75 e3                	jne    800f2f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f4c:	eb 23                	jmp    800f71 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f51:	8d 50 01             	lea    0x1(%eax),%edx
  800f54:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f57:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f5a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f5d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f60:	8a 12                	mov    (%edx),%dl
  800f62:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f64:	8b 45 10             	mov    0x10(%ebp),%eax
  800f67:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6d:	85 c0                	test   %eax,%eax
  800f6f:	75 dd                	jne    800f4e <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f74:	c9                   	leave  
  800f75:	c3                   	ret    

00800f76 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f85:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f88:	eb 2a                	jmp    800fb4 <memcmp+0x3e>
		if (*s1 != *s2)
  800f8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f8d:	8a 10                	mov    (%eax),%dl
  800f8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	38 c2                	cmp    %al,%dl
  800f96:	74 16                	je     800fae <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	0f b6 d0             	movzbl %al,%edx
  800fa0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	0f b6 c0             	movzbl %al,%eax
  800fa8:	29 c2                	sub    %eax,%edx
  800faa:	89 d0                	mov    %edx,%eax
  800fac:	eb 18                	jmp    800fc6 <memcmp+0x50>
		s1++, s2++;
  800fae:	ff 45 fc             	incl   -0x4(%ebp)
  800fb1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fb4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fba:	89 55 10             	mov    %edx,0x10(%ebp)
  800fbd:	85 c0                	test   %eax,%eax
  800fbf:	75 c9                	jne    800f8a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc6:	c9                   	leave  
  800fc7:	c3                   	ret    

00800fc8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fc8:	55                   	push   %ebp
  800fc9:	89 e5                	mov    %esp,%ebp
  800fcb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fce:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	01 d0                	add    %edx,%eax
  800fd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fd9:	eb 15                	jmp    800ff0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	0f b6 d0             	movzbl %al,%edx
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	0f b6 c0             	movzbl %al,%eax
  800fe9:	39 c2                	cmp    %eax,%edx
  800feb:	74 0d                	je     800ffa <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fed:	ff 45 08             	incl   0x8(%ebp)
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ff6:	72 e3                	jb     800fdb <memfind+0x13>
  800ff8:	eb 01                	jmp    800ffb <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ffa:	90                   	nop
	return (void *) s;
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ffe:	c9                   	leave  
  800fff:	c3                   	ret    

00801000 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801006:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80100d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801014:	eb 03                	jmp    801019 <strtol+0x19>
		s++;
  801016:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	3c 20                	cmp    $0x20,%al
  801020:	74 f4                	je     801016 <strtol+0x16>
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	3c 09                	cmp    $0x9,%al
  801029:	74 eb                	je     801016 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	8a 00                	mov    (%eax),%al
  801030:	3c 2b                	cmp    $0x2b,%al
  801032:	75 05                	jne    801039 <strtol+0x39>
		s++;
  801034:	ff 45 08             	incl   0x8(%ebp)
  801037:	eb 13                	jmp    80104c <strtol+0x4c>
	else if (*s == '-')
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	3c 2d                	cmp    $0x2d,%al
  801040:	75 0a                	jne    80104c <strtol+0x4c>
		s++, neg = 1;
  801042:	ff 45 08             	incl   0x8(%ebp)
  801045:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80104c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801050:	74 06                	je     801058 <strtol+0x58>
  801052:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801056:	75 20                	jne    801078 <strtol+0x78>
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	3c 30                	cmp    $0x30,%al
  80105f:	75 17                	jne    801078 <strtol+0x78>
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	40                   	inc    %eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	3c 78                	cmp    $0x78,%al
  801069:	75 0d                	jne    801078 <strtol+0x78>
		s += 2, base = 16;
  80106b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80106f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801076:	eb 28                	jmp    8010a0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801078:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80107c:	75 15                	jne    801093 <strtol+0x93>
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 30                	cmp    $0x30,%al
  801085:	75 0c                	jne    801093 <strtol+0x93>
		s++, base = 8;
  801087:	ff 45 08             	incl   0x8(%ebp)
  80108a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801091:	eb 0d                	jmp    8010a0 <strtol+0xa0>
	else if (base == 0)
  801093:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801097:	75 07                	jne    8010a0 <strtol+0xa0>
		base = 10;
  801099:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	8a 00                	mov    (%eax),%al
  8010a5:	3c 2f                	cmp    $0x2f,%al
  8010a7:	7e 19                	jle    8010c2 <strtol+0xc2>
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8a 00                	mov    (%eax),%al
  8010ae:	3c 39                	cmp    $0x39,%al
  8010b0:	7f 10                	jg     8010c2 <strtol+0xc2>
			dig = *s - '0';
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	8a 00                	mov    (%eax),%al
  8010b7:	0f be c0             	movsbl %al,%eax
  8010ba:	83 e8 30             	sub    $0x30,%eax
  8010bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010c0:	eb 42                	jmp    801104 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	3c 60                	cmp    $0x60,%al
  8010c9:	7e 19                	jle    8010e4 <strtol+0xe4>
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	8a 00                	mov    (%eax),%al
  8010d0:	3c 7a                	cmp    $0x7a,%al
  8010d2:	7f 10                	jg     8010e4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d7:	8a 00                	mov    (%eax),%al
  8010d9:	0f be c0             	movsbl %al,%eax
  8010dc:	83 e8 57             	sub    $0x57,%eax
  8010df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e2:	eb 20                	jmp    801104 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	8a 00                	mov    (%eax),%al
  8010e9:	3c 40                	cmp    $0x40,%al
  8010eb:	7e 39                	jle    801126 <strtol+0x126>
  8010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f0:	8a 00                	mov    (%eax),%al
  8010f2:	3c 5a                	cmp    $0x5a,%al
  8010f4:	7f 30                	jg     801126 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	0f be c0             	movsbl %al,%eax
  8010fe:	83 e8 37             	sub    $0x37,%eax
  801101:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801107:	3b 45 10             	cmp    0x10(%ebp),%eax
  80110a:	7d 19                	jge    801125 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80110c:	ff 45 08             	incl   0x8(%ebp)
  80110f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801112:	0f af 45 10          	imul   0x10(%ebp),%eax
  801116:	89 c2                	mov    %eax,%edx
  801118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111b:	01 d0                	add    %edx,%eax
  80111d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801120:	e9 7b ff ff ff       	jmp    8010a0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801125:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801126:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80112a:	74 08                	je     801134 <strtol+0x134>
		*endptr = (char *) s;
  80112c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112f:	8b 55 08             	mov    0x8(%ebp),%edx
  801132:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801134:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801138:	74 07                	je     801141 <strtol+0x141>
  80113a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113d:	f7 d8                	neg    %eax
  80113f:	eb 03                	jmp    801144 <strtol+0x144>
  801141:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801144:	c9                   	leave  
  801145:	c3                   	ret    

00801146 <ltostr>:

void
ltostr(long value, char *str)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80114c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801153:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80115a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80115e:	79 13                	jns    801173 <ltostr+0x2d>
	{
		neg = 1;
  801160:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80116d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801170:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80117b:	99                   	cltd   
  80117c:	f7 f9                	idiv   %ecx
  80117e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801181:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801184:	8d 50 01             	lea    0x1(%eax),%edx
  801187:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80118a:	89 c2                	mov    %eax,%edx
  80118c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118f:	01 d0                	add    %edx,%eax
  801191:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801194:	83 c2 30             	add    $0x30,%edx
  801197:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801199:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80119c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011a1:	f7 e9                	imul   %ecx
  8011a3:	c1 fa 02             	sar    $0x2,%edx
  8011a6:	89 c8                	mov    %ecx,%eax
  8011a8:	c1 f8 1f             	sar    $0x1f,%eax
  8011ab:	29 c2                	sub    %eax,%edx
  8011ad:	89 d0                	mov    %edx,%eax
  8011af:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ba:	f7 e9                	imul   %ecx
  8011bc:	c1 fa 02             	sar    $0x2,%edx
  8011bf:	89 c8                	mov    %ecx,%eax
  8011c1:	c1 f8 1f             	sar    $0x1f,%eax
  8011c4:	29 c2                	sub    %eax,%edx
  8011c6:	89 d0                	mov    %edx,%eax
  8011c8:	c1 e0 02             	shl    $0x2,%eax
  8011cb:	01 d0                	add    %edx,%eax
  8011cd:	01 c0                	add    %eax,%eax
  8011cf:	29 c1                	sub    %eax,%ecx
  8011d1:	89 ca                	mov    %ecx,%edx
  8011d3:	85 d2                	test   %edx,%edx
  8011d5:	75 9c                	jne    801173 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e1:	48                   	dec    %eax
  8011e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011e9:	74 3d                	je     801228 <ltostr+0xe2>
		start = 1 ;
  8011eb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011f2:	eb 34                	jmp    801228 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fa:	01 d0                	add    %edx,%eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801201:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801204:	8b 45 0c             	mov    0xc(%ebp),%eax
  801207:	01 c2                	add    %eax,%edx
  801209:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80120c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120f:	01 c8                	add    %ecx,%eax
  801211:	8a 00                	mov    (%eax),%al
  801213:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801215:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121b:	01 c2                	add    %eax,%edx
  80121d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801220:	88 02                	mov    %al,(%edx)
		start++ ;
  801222:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801225:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80122e:	7c c4                	jl     8011f4 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801230:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801233:	8b 45 0c             	mov    0xc(%ebp),%eax
  801236:	01 d0                	add    %edx,%eax
  801238:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80123b:	90                   	nop
  80123c:	c9                   	leave  
  80123d:	c3                   	ret    

0080123e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
  801241:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801244:	ff 75 08             	pushl  0x8(%ebp)
  801247:	e8 54 fa ff ff       	call   800ca0 <strlen>
  80124c:	83 c4 04             	add    $0x4,%esp
  80124f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801252:	ff 75 0c             	pushl  0xc(%ebp)
  801255:	e8 46 fa ff ff       	call   800ca0 <strlen>
  80125a:	83 c4 04             	add    $0x4,%esp
  80125d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801260:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801267:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80126e:	eb 17                	jmp    801287 <strcconcat+0x49>
		final[s] = str1[s] ;
  801270:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801273:	8b 45 10             	mov    0x10(%ebp),%eax
  801276:	01 c2                	add    %eax,%edx
  801278:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	01 c8                	add    %ecx,%eax
  801280:	8a 00                	mov    (%eax),%al
  801282:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801284:	ff 45 fc             	incl   -0x4(%ebp)
  801287:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80128d:	7c e1                	jl     801270 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80128f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801296:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80129d:	eb 1f                	jmp    8012be <strcconcat+0x80>
		final[s++] = str2[i] ;
  80129f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a2:	8d 50 01             	lea    0x1(%eax),%edx
  8012a5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012a8:	89 c2                	mov    %eax,%edx
  8012aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ad:	01 c2                	add    %eax,%edx
  8012af:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b5:	01 c8                	add    %ecx,%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012bb:	ff 45 f8             	incl   -0x8(%ebp)
  8012be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c4:	7c d9                	jl     80129f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cc:	01 d0                	add    %edx,%eax
  8012ce:	c6 00 00             	movb   $0x0,(%eax)
}
  8012d1:	90                   	nop
  8012d2:	c9                   	leave  
  8012d3:	c3                   	ret    

008012d4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e3:	8b 00                	mov    (%eax),%eax
  8012e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ef:	01 d0                	add    %edx,%eax
  8012f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012f7:	eb 0c                	jmp    801305 <strsplit+0x31>
			*string++ = 0;
  8012f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fc:	8d 50 01             	lea    0x1(%eax),%edx
  8012ff:	89 55 08             	mov    %edx,0x8(%ebp)
  801302:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	84 c0                	test   %al,%al
  80130c:	74 18                	je     801326 <strsplit+0x52>
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	0f be c0             	movsbl %al,%eax
  801316:	50                   	push   %eax
  801317:	ff 75 0c             	pushl  0xc(%ebp)
  80131a:	e8 13 fb ff ff       	call   800e32 <strchr>
  80131f:	83 c4 08             	add    $0x8,%esp
  801322:	85 c0                	test   %eax,%eax
  801324:	75 d3                	jne    8012f9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	8a 00                	mov    (%eax),%al
  80132b:	84 c0                	test   %al,%al
  80132d:	74 5a                	je     801389 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80132f:	8b 45 14             	mov    0x14(%ebp),%eax
  801332:	8b 00                	mov    (%eax),%eax
  801334:	83 f8 0f             	cmp    $0xf,%eax
  801337:	75 07                	jne    801340 <strsplit+0x6c>
		{
			return 0;
  801339:	b8 00 00 00 00       	mov    $0x0,%eax
  80133e:	eb 66                	jmp    8013a6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801340:	8b 45 14             	mov    0x14(%ebp),%eax
  801343:	8b 00                	mov    (%eax),%eax
  801345:	8d 48 01             	lea    0x1(%eax),%ecx
  801348:	8b 55 14             	mov    0x14(%ebp),%edx
  80134b:	89 0a                	mov    %ecx,(%edx)
  80134d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801354:	8b 45 10             	mov    0x10(%ebp),%eax
  801357:	01 c2                	add    %eax,%edx
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80135e:	eb 03                	jmp    801363 <strsplit+0x8f>
			string++;
  801360:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	8a 00                	mov    (%eax),%al
  801368:	84 c0                	test   %al,%al
  80136a:	74 8b                	je     8012f7 <strsplit+0x23>
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	8a 00                	mov    (%eax),%al
  801371:	0f be c0             	movsbl %al,%eax
  801374:	50                   	push   %eax
  801375:	ff 75 0c             	pushl  0xc(%ebp)
  801378:	e8 b5 fa ff ff       	call   800e32 <strchr>
  80137d:	83 c4 08             	add    $0x8,%esp
  801380:	85 c0                	test   %eax,%eax
  801382:	74 dc                	je     801360 <strsplit+0x8c>
			string++;
	}
  801384:	e9 6e ff ff ff       	jmp    8012f7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801389:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80138a:	8b 45 14             	mov    0x14(%ebp),%eax
  80138d:	8b 00                	mov    (%eax),%eax
  80138f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801396:	8b 45 10             	mov    0x10(%ebp),%eax
  801399:	01 d0                	add    %edx,%eax
  80139b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013a1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    

008013a8 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
  8013ab:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013ae:	a1 04 40 80 00       	mov    0x804004,%eax
  8013b3:	85 c0                	test   %eax,%eax
  8013b5:	74 1f                	je     8013d6 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013b7:	e8 1d 00 00 00       	call   8013d9 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013bc:	83 ec 0c             	sub    $0xc,%esp
  8013bf:	68 50 38 80 00       	push   $0x803850
  8013c4:	e8 55 f2 ff ff       	call   80061e <cprintf>
  8013c9:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013cc:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8013d3:	00 00 00 
	}
}
  8013d6:	90                   	nop
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
  8013dc:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  8013df:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013e6:	00 00 00 
  8013e9:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8013f0:	00 00 00 
  8013f3:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8013fa:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8013fd:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801404:	00 00 00 
  801407:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80140e:	00 00 00 
  801411:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801418:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  80141b:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801422:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801425:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80142c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80142f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801434:	2d 00 10 00 00       	sub    $0x1000,%eax
  801439:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  80143e:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801445:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801448:	a1 20 41 80 00       	mov    0x804120,%eax
  80144d:	0f af c2             	imul   %edx,%eax
  801450:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801453:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  80145a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80145d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801460:	01 d0                	add    %edx,%eax
  801462:	48                   	dec    %eax
  801463:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801466:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801469:	ba 00 00 00 00       	mov    $0x0,%edx
  80146e:	f7 75 e8             	divl   -0x18(%ebp)
  801471:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801474:	29 d0                	sub    %edx,%eax
  801476:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801479:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80147c:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801483:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801486:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80148c:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801492:	83 ec 04             	sub    $0x4,%esp
  801495:	6a 06                	push   $0x6
  801497:	50                   	push   %eax
  801498:	52                   	push   %edx
  801499:	e8 a1 05 00 00       	call   801a3f <sys_allocate_chunk>
  80149e:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014a1:	a1 20 41 80 00       	mov    0x804120,%eax
  8014a6:	83 ec 0c             	sub    $0xc,%esp
  8014a9:	50                   	push   %eax
  8014aa:	e8 16 0c 00 00       	call   8020c5 <initialize_MemBlocksList>
  8014af:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  8014b2:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8014b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  8014ba:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8014be:	75 14                	jne    8014d4 <initialize_dyn_block_system+0xfb>
  8014c0:	83 ec 04             	sub    $0x4,%esp
  8014c3:	68 75 38 80 00       	push   $0x803875
  8014c8:	6a 2d                	push   $0x2d
  8014ca:	68 93 38 80 00       	push   $0x803893
  8014cf:	e8 96 ee ff ff       	call   80036a <_panic>
  8014d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014d7:	8b 00                	mov    (%eax),%eax
  8014d9:	85 c0                	test   %eax,%eax
  8014db:	74 10                	je     8014ed <initialize_dyn_block_system+0x114>
  8014dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014e0:	8b 00                	mov    (%eax),%eax
  8014e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014e5:	8b 52 04             	mov    0x4(%edx),%edx
  8014e8:	89 50 04             	mov    %edx,0x4(%eax)
  8014eb:	eb 0b                	jmp    8014f8 <initialize_dyn_block_system+0x11f>
  8014ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014f0:	8b 40 04             	mov    0x4(%eax),%eax
  8014f3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8014f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014fb:	8b 40 04             	mov    0x4(%eax),%eax
  8014fe:	85 c0                	test   %eax,%eax
  801500:	74 0f                	je     801511 <initialize_dyn_block_system+0x138>
  801502:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801505:	8b 40 04             	mov    0x4(%eax),%eax
  801508:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80150b:	8b 12                	mov    (%edx),%edx
  80150d:	89 10                	mov    %edx,(%eax)
  80150f:	eb 0a                	jmp    80151b <initialize_dyn_block_system+0x142>
  801511:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801514:	8b 00                	mov    (%eax),%eax
  801516:	a3 48 41 80 00       	mov    %eax,0x804148
  80151b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80151e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801524:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801527:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80152e:	a1 54 41 80 00       	mov    0x804154,%eax
  801533:	48                   	dec    %eax
  801534:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801539:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80153c:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801543:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801546:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  80154d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801551:	75 14                	jne    801567 <initialize_dyn_block_system+0x18e>
  801553:	83 ec 04             	sub    $0x4,%esp
  801556:	68 a0 38 80 00       	push   $0x8038a0
  80155b:	6a 30                	push   $0x30
  80155d:	68 93 38 80 00       	push   $0x803893
  801562:	e8 03 ee ff ff       	call   80036a <_panic>
  801567:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80156d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801570:	89 50 04             	mov    %edx,0x4(%eax)
  801573:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801576:	8b 40 04             	mov    0x4(%eax),%eax
  801579:	85 c0                	test   %eax,%eax
  80157b:	74 0c                	je     801589 <initialize_dyn_block_system+0x1b0>
  80157d:	a1 3c 41 80 00       	mov    0x80413c,%eax
  801582:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801585:	89 10                	mov    %edx,(%eax)
  801587:	eb 08                	jmp    801591 <initialize_dyn_block_system+0x1b8>
  801589:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80158c:	a3 38 41 80 00       	mov    %eax,0x804138
  801591:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801594:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801599:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80159c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015a2:	a1 44 41 80 00       	mov    0x804144,%eax
  8015a7:	40                   	inc    %eax
  8015a8:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8015ad:	90                   	nop
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015b6:	e8 ed fd ff ff       	call   8013a8 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015bf:	75 07                	jne    8015c8 <malloc+0x18>
  8015c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c6:	eb 67                	jmp    80162f <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  8015c8:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d5:	01 d0                	add    %edx,%eax
  8015d7:	48                   	dec    %eax
  8015d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015de:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e3:	f7 75 f4             	divl   -0xc(%ebp)
  8015e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e9:	29 d0                	sub    %edx,%eax
  8015eb:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015ee:	e8 1a 08 00 00       	call   801e0d <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015f3:	85 c0                	test   %eax,%eax
  8015f5:	74 33                	je     80162a <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  8015f7:	83 ec 0c             	sub    $0xc,%esp
  8015fa:	ff 75 08             	pushl  0x8(%ebp)
  8015fd:	e8 0c 0e 00 00       	call   80240e <alloc_block_FF>
  801602:	83 c4 10             	add    $0x10,%esp
  801605:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801608:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80160c:	74 1c                	je     80162a <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  80160e:	83 ec 0c             	sub    $0xc,%esp
  801611:	ff 75 ec             	pushl  -0x14(%ebp)
  801614:	e8 07 0c 00 00       	call   802220 <insert_sorted_allocList>
  801619:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  80161c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80161f:	8b 40 08             	mov    0x8(%eax),%eax
  801622:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801625:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801628:	eb 05                	jmp    80162f <malloc+0x7f>
		}
	}
	return NULL;
  80162a:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801637:	8b 45 08             	mov    0x8(%ebp),%eax
  80163a:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  80163d:	83 ec 08             	sub    $0x8,%esp
  801640:	ff 75 f4             	pushl  -0xc(%ebp)
  801643:	68 40 40 80 00       	push   $0x804040
  801648:	e8 5b 0b 00 00       	call   8021a8 <find_block>
  80164d:	83 c4 10             	add    $0x10,%esp
  801650:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801653:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801656:	8b 40 0c             	mov    0xc(%eax),%eax
  801659:	83 ec 08             	sub    $0x8,%esp
  80165c:	50                   	push   %eax
  80165d:	ff 75 f4             	pushl  -0xc(%ebp)
  801660:	e8 a2 03 00 00       	call   801a07 <sys_free_user_mem>
  801665:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801668:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80166c:	75 14                	jne    801682 <free+0x51>
  80166e:	83 ec 04             	sub    $0x4,%esp
  801671:	68 75 38 80 00       	push   $0x803875
  801676:	6a 76                	push   $0x76
  801678:	68 93 38 80 00       	push   $0x803893
  80167d:	e8 e8 ec ff ff       	call   80036a <_panic>
  801682:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801685:	8b 00                	mov    (%eax),%eax
  801687:	85 c0                	test   %eax,%eax
  801689:	74 10                	je     80169b <free+0x6a>
  80168b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168e:	8b 00                	mov    (%eax),%eax
  801690:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801693:	8b 52 04             	mov    0x4(%edx),%edx
  801696:	89 50 04             	mov    %edx,0x4(%eax)
  801699:	eb 0b                	jmp    8016a6 <free+0x75>
  80169b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169e:	8b 40 04             	mov    0x4(%eax),%eax
  8016a1:	a3 44 40 80 00       	mov    %eax,0x804044
  8016a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a9:	8b 40 04             	mov    0x4(%eax),%eax
  8016ac:	85 c0                	test   %eax,%eax
  8016ae:	74 0f                	je     8016bf <free+0x8e>
  8016b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b3:	8b 40 04             	mov    0x4(%eax),%eax
  8016b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016b9:	8b 12                	mov    (%edx),%edx
  8016bb:	89 10                	mov    %edx,(%eax)
  8016bd:	eb 0a                	jmp    8016c9 <free+0x98>
  8016bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c2:	8b 00                	mov    (%eax),%eax
  8016c4:	a3 40 40 80 00       	mov    %eax,0x804040
  8016c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016dc:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8016e1:	48                   	dec    %eax
  8016e2:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  8016e7:	83 ec 0c             	sub    $0xc,%esp
  8016ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8016ed:	e8 0b 14 00 00       	call   802afd <insert_sorted_with_merge_freeList>
  8016f2:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8016f5:	90                   	nop
  8016f6:	c9                   	leave  
  8016f7:	c3                   	ret    

008016f8 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
  8016fb:	83 ec 28             	sub    $0x28,%esp
  8016fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801701:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801704:	e8 9f fc ff ff       	call   8013a8 <InitializeUHeap>
	if (size == 0) return NULL ;
  801709:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80170d:	75 0a                	jne    801719 <smalloc+0x21>
  80170f:	b8 00 00 00 00       	mov    $0x0,%eax
  801714:	e9 8d 00 00 00       	jmp    8017a6 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801719:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801720:	8b 55 0c             	mov    0xc(%ebp),%edx
  801723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801726:	01 d0                	add    %edx,%eax
  801728:	48                   	dec    %eax
  801729:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80172c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172f:	ba 00 00 00 00       	mov    $0x0,%edx
  801734:	f7 75 f4             	divl   -0xc(%ebp)
  801737:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173a:	29 d0                	sub    %edx,%eax
  80173c:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80173f:	e8 c9 06 00 00       	call   801e0d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801744:	85 c0                	test   %eax,%eax
  801746:	74 59                	je     8017a1 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801748:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  80174f:	83 ec 0c             	sub    $0xc,%esp
  801752:	ff 75 0c             	pushl  0xc(%ebp)
  801755:	e8 b4 0c 00 00       	call   80240e <alloc_block_FF>
  80175a:	83 c4 10             	add    $0x10,%esp
  80175d:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801760:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801764:	75 07                	jne    80176d <smalloc+0x75>
			{
				return NULL;
  801766:	b8 00 00 00 00       	mov    $0x0,%eax
  80176b:	eb 39                	jmp    8017a6 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  80176d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801770:	8b 40 08             	mov    0x8(%eax),%eax
  801773:	89 c2                	mov    %eax,%edx
  801775:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801779:	52                   	push   %edx
  80177a:	50                   	push   %eax
  80177b:	ff 75 0c             	pushl  0xc(%ebp)
  80177e:	ff 75 08             	pushl  0x8(%ebp)
  801781:	e8 0c 04 00 00       	call   801b92 <sys_createSharedObject>
  801786:	83 c4 10             	add    $0x10,%esp
  801789:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  80178c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801790:	78 08                	js     80179a <smalloc+0xa2>
				{
					return (void*)v1->sva;
  801792:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801795:	8b 40 08             	mov    0x8(%eax),%eax
  801798:	eb 0c                	jmp    8017a6 <smalloc+0xae>
				}
				else
				{
					return NULL;
  80179a:	b8 00 00 00 00       	mov    $0x0,%eax
  80179f:	eb 05                	jmp    8017a6 <smalloc+0xae>
				}
			}

		}
		return NULL;
  8017a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017ae:	e8 f5 fb ff ff       	call   8013a8 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017b3:	83 ec 08             	sub    $0x8,%esp
  8017b6:	ff 75 0c             	pushl  0xc(%ebp)
  8017b9:	ff 75 08             	pushl  0x8(%ebp)
  8017bc:	e8 fb 03 00 00       	call   801bbc <sys_getSizeOfSharedObject>
  8017c1:	83 c4 10             	add    $0x10,%esp
  8017c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  8017c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017cb:	75 07                	jne    8017d4 <sget+0x2c>
	{
		return NULL;
  8017cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d2:	eb 64                	jmp    801838 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8017d4:	e8 34 06 00 00       	call   801e0d <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017d9:	85 c0                	test   %eax,%eax
  8017db:	74 56                	je     801833 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  8017dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  8017e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e7:	83 ec 0c             	sub    $0xc,%esp
  8017ea:	50                   	push   %eax
  8017eb:	e8 1e 0c 00 00       	call   80240e <alloc_block_FF>
  8017f0:	83 c4 10             	add    $0x10,%esp
  8017f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  8017f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017fa:	75 07                	jne    801803 <sget+0x5b>
		{
		return NULL;
  8017fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801801:	eb 35                	jmp    801838 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801806:	8b 40 08             	mov    0x8(%eax),%eax
  801809:	83 ec 04             	sub    $0x4,%esp
  80180c:	50                   	push   %eax
  80180d:	ff 75 0c             	pushl  0xc(%ebp)
  801810:	ff 75 08             	pushl  0x8(%ebp)
  801813:	e8 c1 03 00 00       	call   801bd9 <sys_getSharedObject>
  801818:	83 c4 10             	add    $0x10,%esp
  80181b:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  80181e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801822:	78 08                	js     80182c <sget+0x84>
			{
				return (void*)v1->sva;
  801824:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801827:	8b 40 08             	mov    0x8(%eax),%eax
  80182a:	eb 0c                	jmp    801838 <sget+0x90>
			}
			else
			{
				return NULL;
  80182c:	b8 00 00 00 00       	mov    $0x0,%eax
  801831:	eb 05                	jmp    801838 <sget+0x90>
			}
		}
	}
  return NULL;
  801833:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801840:	e8 63 fb ff ff       	call   8013a8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801845:	83 ec 04             	sub    $0x4,%esp
  801848:	68 c4 38 80 00       	push   $0x8038c4
  80184d:	68 0e 01 00 00       	push   $0x10e
  801852:	68 93 38 80 00       	push   $0x803893
  801857:	e8 0e eb ff ff       	call   80036a <_panic>

0080185c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801862:	83 ec 04             	sub    $0x4,%esp
  801865:	68 ec 38 80 00       	push   $0x8038ec
  80186a:	68 22 01 00 00       	push   $0x122
  80186f:	68 93 38 80 00       	push   $0x803893
  801874:	e8 f1 ea ff ff       	call   80036a <_panic>

00801879 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80187f:	83 ec 04             	sub    $0x4,%esp
  801882:	68 10 39 80 00       	push   $0x803910
  801887:	68 2d 01 00 00       	push   $0x12d
  80188c:	68 93 38 80 00       	push   $0x803893
  801891:	e8 d4 ea ff ff       	call   80036a <_panic>

00801896 <shrink>:

}
void shrink(uint32 newSize)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80189c:	83 ec 04             	sub    $0x4,%esp
  80189f:	68 10 39 80 00       	push   $0x803910
  8018a4:	68 32 01 00 00       	push   $0x132
  8018a9:	68 93 38 80 00       	push   $0x803893
  8018ae:	e8 b7 ea ff ff       	call   80036a <_panic>

008018b3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
  8018b6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018b9:	83 ec 04             	sub    $0x4,%esp
  8018bc:	68 10 39 80 00       	push   $0x803910
  8018c1:	68 37 01 00 00       	push   $0x137
  8018c6:	68 93 38 80 00       	push   $0x803893
  8018cb:	e8 9a ea ff ff       	call   80036a <_panic>

008018d0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
  8018d3:	57                   	push   %edi
  8018d4:	56                   	push   %esi
  8018d5:	53                   	push   %ebx
  8018d6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018df:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018e5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018e8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018eb:	cd 30                	int    $0x30
  8018ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018f3:	83 c4 10             	add    $0x10,%esp
  8018f6:	5b                   	pop    %ebx
  8018f7:	5e                   	pop    %esi
  8018f8:	5f                   	pop    %edi
  8018f9:	5d                   	pop    %ebp
  8018fa:	c3                   	ret    

008018fb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	83 ec 04             	sub    $0x4,%esp
  801901:	8b 45 10             	mov    0x10(%ebp),%eax
  801904:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801907:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80190b:	8b 45 08             	mov    0x8(%ebp),%eax
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	52                   	push   %edx
  801913:	ff 75 0c             	pushl  0xc(%ebp)
  801916:	50                   	push   %eax
  801917:	6a 00                	push   $0x0
  801919:	e8 b2 ff ff ff       	call   8018d0 <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
}
  801921:	90                   	nop
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_cgetc>:

int
sys_cgetc(void)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 01                	push   $0x1
  801933:	e8 98 ff ff ff       	call   8018d0 <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
}
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801940:	8b 55 0c             	mov    0xc(%ebp),%edx
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	52                   	push   %edx
  80194d:	50                   	push   %eax
  80194e:	6a 05                	push   $0x5
  801950:	e8 7b ff ff ff       	call   8018d0 <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
}
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
  80195d:	56                   	push   %esi
  80195e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80195f:	8b 75 18             	mov    0x18(%ebp),%esi
  801962:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801965:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801968:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	56                   	push   %esi
  80196f:	53                   	push   %ebx
  801970:	51                   	push   %ecx
  801971:	52                   	push   %edx
  801972:	50                   	push   %eax
  801973:	6a 06                	push   $0x6
  801975:	e8 56 ff ff ff       	call   8018d0 <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
}
  80197d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801980:	5b                   	pop    %ebx
  801981:	5e                   	pop    %esi
  801982:	5d                   	pop    %ebp
  801983:	c3                   	ret    

00801984 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801987:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198a:	8b 45 08             	mov    0x8(%ebp),%eax
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	52                   	push   %edx
  801994:	50                   	push   %eax
  801995:	6a 07                	push   $0x7
  801997:	e8 34 ff ff ff       	call   8018d0 <syscall>
  80199c:	83 c4 18             	add    $0x18,%esp
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	ff 75 0c             	pushl  0xc(%ebp)
  8019ad:	ff 75 08             	pushl  0x8(%ebp)
  8019b0:	6a 08                	push   $0x8
  8019b2:	e8 19 ff ff ff       	call   8018d0 <syscall>
  8019b7:	83 c4 18             	add    $0x18,%esp
}
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 09                	push   $0x9
  8019cb:	e8 00 ff ff ff       	call   8018d0 <syscall>
  8019d0:	83 c4 18             	add    $0x18,%esp
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 0a                	push   $0xa
  8019e4:	e8 e7 fe ff ff       	call   8018d0 <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 0b                	push   $0xb
  8019fd:	e8 ce fe ff ff       	call   8018d0 <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	ff 75 0c             	pushl  0xc(%ebp)
  801a13:	ff 75 08             	pushl  0x8(%ebp)
  801a16:	6a 0f                	push   $0xf
  801a18:	e8 b3 fe ff ff       	call   8018d0 <syscall>
  801a1d:	83 c4 18             	add    $0x18,%esp
	return;
  801a20:	90                   	nop
}
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	ff 75 0c             	pushl  0xc(%ebp)
  801a2f:	ff 75 08             	pushl  0x8(%ebp)
  801a32:	6a 10                	push   $0x10
  801a34:	e8 97 fe ff ff       	call   8018d0 <syscall>
  801a39:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3c:	90                   	nop
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	ff 75 10             	pushl  0x10(%ebp)
  801a49:	ff 75 0c             	pushl  0xc(%ebp)
  801a4c:	ff 75 08             	pushl  0x8(%ebp)
  801a4f:	6a 11                	push   $0x11
  801a51:	e8 7a fe ff ff       	call   8018d0 <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
	return ;
  801a59:	90                   	nop
}
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 0c                	push   $0xc
  801a6b:	e8 60 fe ff ff       	call   8018d0 <syscall>
  801a70:	83 c4 18             	add    $0x18,%esp
}
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	ff 75 08             	pushl  0x8(%ebp)
  801a83:	6a 0d                	push   $0xd
  801a85:	e8 46 fe ff ff       	call   8018d0 <syscall>
  801a8a:	83 c4 18             	add    $0x18,%esp
}
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 0e                	push   $0xe
  801a9e:	e8 2d fe ff ff       	call   8018d0 <syscall>
  801aa3:	83 c4 18             	add    $0x18,%esp
}
  801aa6:	90                   	nop
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 13                	push   $0x13
  801ab8:	e8 13 fe ff ff       	call   8018d0 <syscall>
  801abd:	83 c4 18             	add    $0x18,%esp
}
  801ac0:	90                   	nop
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 14                	push   $0x14
  801ad2:	e8 f9 fd ff ff       	call   8018d0 <syscall>
  801ad7:	83 c4 18             	add    $0x18,%esp
}
  801ada:	90                   	nop
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_cputc>:


void
sys_cputc(const char c)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	83 ec 04             	sub    $0x4,%esp
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ae9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	50                   	push   %eax
  801af6:	6a 15                	push   $0x15
  801af8:	e8 d3 fd ff ff       	call   8018d0 <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	90                   	nop
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 16                	push   $0x16
  801b12:	e8 b9 fd ff ff       	call   8018d0 <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
}
  801b1a:	90                   	nop
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b20:	8b 45 08             	mov    0x8(%ebp),%eax
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	ff 75 0c             	pushl  0xc(%ebp)
  801b2c:	50                   	push   %eax
  801b2d:	6a 17                	push   $0x17
  801b2f:	e8 9c fd ff ff       	call   8018d0 <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	52                   	push   %edx
  801b49:	50                   	push   %eax
  801b4a:	6a 1a                	push   $0x1a
  801b4c:	e8 7f fd ff ff       	call   8018d0 <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
}
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	52                   	push   %edx
  801b66:	50                   	push   %eax
  801b67:	6a 18                	push   $0x18
  801b69:	e8 62 fd ff ff       	call   8018d0 <syscall>
  801b6e:	83 c4 18             	add    $0x18,%esp
}
  801b71:	90                   	nop
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	52                   	push   %edx
  801b84:	50                   	push   %eax
  801b85:	6a 19                	push   $0x19
  801b87:	e8 44 fd ff ff       	call   8018d0 <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
}
  801b8f:	90                   	nop
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
  801b95:	83 ec 04             	sub    $0x4,%esp
  801b98:	8b 45 10             	mov    0x10(%ebp),%eax
  801b9b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b9e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ba1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba8:	6a 00                	push   $0x0
  801baa:	51                   	push   %ecx
  801bab:	52                   	push   %edx
  801bac:	ff 75 0c             	pushl  0xc(%ebp)
  801baf:	50                   	push   %eax
  801bb0:	6a 1b                	push   $0x1b
  801bb2:	e8 19 fd ff ff       	call   8018d0 <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
}
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	52                   	push   %edx
  801bcc:	50                   	push   %eax
  801bcd:	6a 1c                	push   $0x1c
  801bcf:	e8 fc fc ff ff       	call   8018d0 <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
}
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bdc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be2:	8b 45 08             	mov    0x8(%ebp),%eax
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	51                   	push   %ecx
  801bea:	52                   	push   %edx
  801beb:	50                   	push   %eax
  801bec:	6a 1d                	push   $0x1d
  801bee:	e8 dd fc ff ff       	call   8018d0 <syscall>
  801bf3:	83 c4 18             	add    $0x18,%esp
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	52                   	push   %edx
  801c08:	50                   	push   %eax
  801c09:	6a 1e                	push   $0x1e
  801c0b:	e8 c0 fc ff ff       	call   8018d0 <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 1f                	push   $0x1f
  801c24:	e8 a7 fc ff ff       	call   8018d0 <syscall>
  801c29:	83 c4 18             	add    $0x18,%esp
}
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    

00801c2e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c31:	8b 45 08             	mov    0x8(%ebp),%eax
  801c34:	6a 00                	push   $0x0
  801c36:	ff 75 14             	pushl  0x14(%ebp)
  801c39:	ff 75 10             	pushl  0x10(%ebp)
  801c3c:	ff 75 0c             	pushl  0xc(%ebp)
  801c3f:	50                   	push   %eax
  801c40:	6a 20                	push   $0x20
  801c42:	e8 89 fc ff ff       	call   8018d0 <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	50                   	push   %eax
  801c5b:	6a 21                	push   $0x21
  801c5d:	e8 6e fc ff ff       	call   8018d0 <syscall>
  801c62:	83 c4 18             	add    $0x18,%esp
}
  801c65:	90                   	nop
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	50                   	push   %eax
  801c77:	6a 22                	push   $0x22
  801c79:	e8 52 fc ff ff       	call   8018d0 <syscall>
  801c7e:	83 c4 18             	add    $0x18,%esp
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 02                	push   $0x2
  801c92:	e8 39 fc ff ff       	call   8018d0 <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
}
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 03                	push   $0x3
  801cab:	e8 20 fc ff ff       	call   8018d0 <syscall>
  801cb0:	83 c4 18             	add    $0x18,%esp
}
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 04                	push   $0x4
  801cc4:	e8 07 fc ff ff       	call   8018d0 <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
}
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <sys_exit_env>:


void sys_exit_env(void)
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 23                	push   $0x23
  801cdd:	e8 ee fb ff ff       	call   8018d0 <syscall>
  801ce2:	83 c4 18             	add    $0x18,%esp
}
  801ce5:	90                   	nop
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cee:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cf1:	8d 50 04             	lea    0x4(%eax),%edx
  801cf4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	52                   	push   %edx
  801cfe:	50                   	push   %eax
  801cff:	6a 24                	push   $0x24
  801d01:	e8 ca fb ff ff       	call   8018d0 <syscall>
  801d06:	83 c4 18             	add    $0x18,%esp
	return result;
  801d09:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d0f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d12:	89 01                	mov    %eax,(%ecx)
  801d14:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	c9                   	leave  
  801d1b:	c2 04 00             	ret    $0x4

00801d1e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	ff 75 10             	pushl  0x10(%ebp)
  801d28:	ff 75 0c             	pushl  0xc(%ebp)
  801d2b:	ff 75 08             	pushl  0x8(%ebp)
  801d2e:	6a 12                	push   $0x12
  801d30:	e8 9b fb ff ff       	call   8018d0 <syscall>
  801d35:	83 c4 18             	add    $0x18,%esp
	return ;
  801d38:	90                   	nop
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <sys_rcr2>:
uint32 sys_rcr2()
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 25                	push   $0x25
  801d4a:	e8 81 fb ff ff       	call   8018d0 <syscall>
  801d4f:	83 c4 18             	add    $0x18,%esp
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	83 ec 04             	sub    $0x4,%esp
  801d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d60:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	50                   	push   %eax
  801d6d:	6a 26                	push   $0x26
  801d6f:	e8 5c fb ff ff       	call   8018d0 <syscall>
  801d74:	83 c4 18             	add    $0x18,%esp
	return ;
  801d77:	90                   	nop
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <rsttst>:
void rsttst()
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 28                	push   $0x28
  801d89:	e8 42 fb ff ff       	call   8018d0 <syscall>
  801d8e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d91:	90                   	nop
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	83 ec 04             	sub    $0x4,%esp
  801d9a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d9d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801da0:	8b 55 18             	mov    0x18(%ebp),%edx
  801da3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801da7:	52                   	push   %edx
  801da8:	50                   	push   %eax
  801da9:	ff 75 10             	pushl  0x10(%ebp)
  801dac:	ff 75 0c             	pushl  0xc(%ebp)
  801daf:	ff 75 08             	pushl  0x8(%ebp)
  801db2:	6a 27                	push   $0x27
  801db4:	e8 17 fb ff ff       	call   8018d0 <syscall>
  801db9:	83 c4 18             	add    $0x18,%esp
	return ;
  801dbc:	90                   	nop
}
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <chktst>:
void chktst(uint32 n)
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	ff 75 08             	pushl  0x8(%ebp)
  801dcd:	6a 29                	push   $0x29
  801dcf:	e8 fc fa ff ff       	call   8018d0 <syscall>
  801dd4:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd7:	90                   	nop
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <inctst>:

void inctst()
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 2a                	push   $0x2a
  801de9:	e8 e2 fa ff ff       	call   8018d0 <syscall>
  801dee:	83 c4 18             	add    $0x18,%esp
	return ;
  801df1:	90                   	nop
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <gettst>:
uint32 gettst()
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 2b                	push   $0x2b
  801e03:	e8 c8 fa ff ff       	call   8018d0 <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
  801e10:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 2c                	push   $0x2c
  801e1f:	e8 ac fa ff ff       	call   8018d0 <syscall>
  801e24:	83 c4 18             	add    $0x18,%esp
  801e27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e2a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e2e:	75 07                	jne    801e37 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e30:	b8 01 00 00 00       	mov    $0x1,%eax
  801e35:	eb 05                	jmp    801e3c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
  801e41:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 2c                	push   $0x2c
  801e50:	e8 7b fa ff ff       	call   8018d0 <syscall>
  801e55:	83 c4 18             	add    $0x18,%esp
  801e58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e5b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e5f:	75 07                	jne    801e68 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e61:	b8 01 00 00 00       	mov    $0x1,%eax
  801e66:	eb 05                	jmp    801e6d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 2c                	push   $0x2c
  801e81:	e8 4a fa ff ff       	call   8018d0 <syscall>
  801e86:	83 c4 18             	add    $0x18,%esp
  801e89:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e8c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e90:	75 07                	jne    801e99 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e92:	b8 01 00 00 00       	mov    $0x1,%eax
  801e97:	eb 05                	jmp    801e9e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
  801ea3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 2c                	push   $0x2c
  801eb2:	e8 19 fa ff ff       	call   8018d0 <syscall>
  801eb7:	83 c4 18             	add    $0x18,%esp
  801eba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ebd:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ec1:	75 07                	jne    801eca <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ec3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec8:	eb 05                	jmp    801ecf <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801eca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	ff 75 08             	pushl  0x8(%ebp)
  801edf:	6a 2d                	push   $0x2d
  801ee1:	e8 ea f9 ff ff       	call   8018d0 <syscall>
  801ee6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee9:	90                   	nop
}
  801eea:	c9                   	leave  
  801eeb:	c3                   	ret    

00801eec <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
  801eef:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ef0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ef3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ef6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  801efc:	6a 00                	push   $0x0
  801efe:	53                   	push   %ebx
  801eff:	51                   	push   %ecx
  801f00:	52                   	push   %edx
  801f01:	50                   	push   %eax
  801f02:	6a 2e                	push   $0x2e
  801f04:	e8 c7 f9 ff ff       	call   8018d0 <syscall>
  801f09:	83 c4 18             	add    $0x18,%esp
}
  801f0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f17:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	52                   	push   %edx
  801f21:	50                   	push   %eax
  801f22:	6a 2f                	push   $0x2f
  801f24:	e8 a7 f9 ff ff       	call   8018d0 <syscall>
  801f29:	83 c4 18             	add    $0x18,%esp
}
  801f2c:	c9                   	leave  
  801f2d:	c3                   	ret    

00801f2e <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f2e:	55                   	push   %ebp
  801f2f:	89 e5                	mov    %esp,%ebp
  801f31:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f34:	83 ec 0c             	sub    $0xc,%esp
  801f37:	68 20 39 80 00       	push   $0x803920
  801f3c:	e8 dd e6 ff ff       	call   80061e <cprintf>
  801f41:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f44:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f4b:	83 ec 0c             	sub    $0xc,%esp
  801f4e:	68 4c 39 80 00       	push   $0x80394c
  801f53:	e8 c6 e6 ff ff       	call   80061e <cprintf>
  801f58:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f5b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f5f:	a1 38 41 80 00       	mov    0x804138,%eax
  801f64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f67:	eb 56                	jmp    801fbf <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f6d:	74 1c                	je     801f8b <print_mem_block_lists+0x5d>
  801f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f72:	8b 50 08             	mov    0x8(%eax),%edx
  801f75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f78:	8b 48 08             	mov    0x8(%eax),%ecx
  801f7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f81:	01 c8                	add    %ecx,%eax
  801f83:	39 c2                	cmp    %eax,%edx
  801f85:	73 04                	jae    801f8b <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f87:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8e:	8b 50 08             	mov    0x8(%eax),%edx
  801f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f94:	8b 40 0c             	mov    0xc(%eax),%eax
  801f97:	01 c2                	add    %eax,%edx
  801f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9c:	8b 40 08             	mov    0x8(%eax),%eax
  801f9f:	83 ec 04             	sub    $0x4,%esp
  801fa2:	52                   	push   %edx
  801fa3:	50                   	push   %eax
  801fa4:	68 61 39 80 00       	push   $0x803961
  801fa9:	e8 70 e6 ff ff       	call   80061e <cprintf>
  801fae:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fb7:	a1 40 41 80 00       	mov    0x804140,%eax
  801fbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc3:	74 07                	je     801fcc <print_mem_block_lists+0x9e>
  801fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc8:	8b 00                	mov    (%eax),%eax
  801fca:	eb 05                	jmp    801fd1 <print_mem_block_lists+0xa3>
  801fcc:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd1:	a3 40 41 80 00       	mov    %eax,0x804140
  801fd6:	a1 40 41 80 00       	mov    0x804140,%eax
  801fdb:	85 c0                	test   %eax,%eax
  801fdd:	75 8a                	jne    801f69 <print_mem_block_lists+0x3b>
  801fdf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe3:	75 84                	jne    801f69 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fe5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fe9:	75 10                	jne    801ffb <print_mem_block_lists+0xcd>
  801feb:	83 ec 0c             	sub    $0xc,%esp
  801fee:	68 70 39 80 00       	push   $0x803970
  801ff3:	e8 26 e6 ff ff       	call   80061e <cprintf>
  801ff8:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801ffb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802002:	83 ec 0c             	sub    $0xc,%esp
  802005:	68 94 39 80 00       	push   $0x803994
  80200a:	e8 0f e6 ff ff       	call   80061e <cprintf>
  80200f:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802012:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802016:	a1 40 40 80 00       	mov    0x804040,%eax
  80201b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80201e:	eb 56                	jmp    802076 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802020:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802024:	74 1c                	je     802042 <print_mem_block_lists+0x114>
  802026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802029:	8b 50 08             	mov    0x8(%eax),%edx
  80202c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80202f:	8b 48 08             	mov    0x8(%eax),%ecx
  802032:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802035:	8b 40 0c             	mov    0xc(%eax),%eax
  802038:	01 c8                	add    %ecx,%eax
  80203a:	39 c2                	cmp    %eax,%edx
  80203c:	73 04                	jae    802042 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80203e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802045:	8b 50 08             	mov    0x8(%eax),%edx
  802048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204b:	8b 40 0c             	mov    0xc(%eax),%eax
  80204e:	01 c2                	add    %eax,%edx
  802050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802053:	8b 40 08             	mov    0x8(%eax),%eax
  802056:	83 ec 04             	sub    $0x4,%esp
  802059:	52                   	push   %edx
  80205a:	50                   	push   %eax
  80205b:	68 61 39 80 00       	push   $0x803961
  802060:	e8 b9 e5 ff ff       	call   80061e <cprintf>
  802065:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80206e:	a1 48 40 80 00       	mov    0x804048,%eax
  802073:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802076:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80207a:	74 07                	je     802083 <print_mem_block_lists+0x155>
  80207c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207f:	8b 00                	mov    (%eax),%eax
  802081:	eb 05                	jmp    802088 <print_mem_block_lists+0x15a>
  802083:	b8 00 00 00 00       	mov    $0x0,%eax
  802088:	a3 48 40 80 00       	mov    %eax,0x804048
  80208d:	a1 48 40 80 00       	mov    0x804048,%eax
  802092:	85 c0                	test   %eax,%eax
  802094:	75 8a                	jne    802020 <print_mem_block_lists+0xf2>
  802096:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80209a:	75 84                	jne    802020 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80209c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020a0:	75 10                	jne    8020b2 <print_mem_block_lists+0x184>
  8020a2:	83 ec 0c             	sub    $0xc,%esp
  8020a5:	68 ac 39 80 00       	push   $0x8039ac
  8020aa:	e8 6f e5 ff ff       	call   80061e <cprintf>
  8020af:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020b2:	83 ec 0c             	sub    $0xc,%esp
  8020b5:	68 20 39 80 00       	push   $0x803920
  8020ba:	e8 5f e5 ff ff       	call   80061e <cprintf>
  8020bf:	83 c4 10             	add    $0x10,%esp

}
  8020c2:	90                   	nop
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
  8020c8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  8020cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ce:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  8020d1:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020d8:	00 00 00 
  8020db:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020e2:	00 00 00 
  8020e5:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020ec:	00 00 00 
	for(int i = 0; i<n;i++)
  8020ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020f6:	e9 9e 00 00 00       	jmp    802199 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  8020fb:	a1 50 40 80 00       	mov    0x804050,%eax
  802100:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802103:	c1 e2 04             	shl    $0x4,%edx
  802106:	01 d0                	add    %edx,%eax
  802108:	85 c0                	test   %eax,%eax
  80210a:	75 14                	jne    802120 <initialize_MemBlocksList+0x5b>
  80210c:	83 ec 04             	sub    $0x4,%esp
  80210f:	68 d4 39 80 00       	push   $0x8039d4
  802114:	6a 47                	push   $0x47
  802116:	68 f7 39 80 00       	push   $0x8039f7
  80211b:	e8 4a e2 ff ff       	call   80036a <_panic>
  802120:	a1 50 40 80 00       	mov    0x804050,%eax
  802125:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802128:	c1 e2 04             	shl    $0x4,%edx
  80212b:	01 d0                	add    %edx,%eax
  80212d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802133:	89 10                	mov    %edx,(%eax)
  802135:	8b 00                	mov    (%eax),%eax
  802137:	85 c0                	test   %eax,%eax
  802139:	74 18                	je     802153 <initialize_MemBlocksList+0x8e>
  80213b:	a1 48 41 80 00       	mov    0x804148,%eax
  802140:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802146:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802149:	c1 e1 04             	shl    $0x4,%ecx
  80214c:	01 ca                	add    %ecx,%edx
  80214e:	89 50 04             	mov    %edx,0x4(%eax)
  802151:	eb 12                	jmp    802165 <initialize_MemBlocksList+0xa0>
  802153:	a1 50 40 80 00       	mov    0x804050,%eax
  802158:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80215b:	c1 e2 04             	shl    $0x4,%edx
  80215e:	01 d0                	add    %edx,%eax
  802160:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802165:	a1 50 40 80 00       	mov    0x804050,%eax
  80216a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80216d:	c1 e2 04             	shl    $0x4,%edx
  802170:	01 d0                	add    %edx,%eax
  802172:	a3 48 41 80 00       	mov    %eax,0x804148
  802177:	a1 50 40 80 00       	mov    0x804050,%eax
  80217c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80217f:	c1 e2 04             	shl    $0x4,%edx
  802182:	01 d0                	add    %edx,%eax
  802184:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80218b:	a1 54 41 80 00       	mov    0x804154,%eax
  802190:	40                   	inc    %eax
  802191:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  802196:	ff 45 f4             	incl   -0xc(%ebp)
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80219f:	0f 82 56 ff ff ff    	jb     8020fb <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8021a5:	90                   	nop
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
  8021ab:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  8021ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  8021b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8021bb:	a1 40 40 80 00       	mov    0x804040,%eax
  8021c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021c3:	eb 23                	jmp    8021e8 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  8021c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c8:	8b 40 08             	mov    0x8(%eax),%eax
  8021cb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8021ce:	75 09                	jne    8021d9 <find_block+0x31>
		{
			found = 1;
  8021d0:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  8021d7:	eb 35                	jmp    80220e <find_block+0x66>
		}
		else
		{
			found = 0;
  8021d9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8021e0:	a1 48 40 80 00       	mov    0x804048,%eax
  8021e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021ec:	74 07                	je     8021f5 <find_block+0x4d>
  8021ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021f1:	8b 00                	mov    (%eax),%eax
  8021f3:	eb 05                	jmp    8021fa <find_block+0x52>
  8021f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021fa:	a3 48 40 80 00       	mov    %eax,0x804048
  8021ff:	a1 48 40 80 00       	mov    0x804048,%eax
  802204:	85 c0                	test   %eax,%eax
  802206:	75 bd                	jne    8021c5 <find_block+0x1d>
  802208:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80220c:	75 b7                	jne    8021c5 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  80220e:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802212:	75 05                	jne    802219 <find_block+0x71>
	{
		return blk;
  802214:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802217:	eb 05                	jmp    80221e <find_block+0x76>
	}
	else
	{
		return NULL;
  802219:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  80221e:	c9                   	leave  
  80221f:	c3                   	ret    

00802220 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802220:	55                   	push   %ebp
  802221:	89 e5                	mov    %esp,%ebp
  802223:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802226:	8b 45 08             	mov    0x8(%ebp),%eax
  802229:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  80222c:	a1 40 40 80 00       	mov    0x804040,%eax
  802231:	85 c0                	test   %eax,%eax
  802233:	74 12                	je     802247 <insert_sorted_allocList+0x27>
  802235:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802238:	8b 50 08             	mov    0x8(%eax),%edx
  80223b:	a1 40 40 80 00       	mov    0x804040,%eax
  802240:	8b 40 08             	mov    0x8(%eax),%eax
  802243:	39 c2                	cmp    %eax,%edx
  802245:	73 65                	jae    8022ac <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802247:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80224b:	75 14                	jne    802261 <insert_sorted_allocList+0x41>
  80224d:	83 ec 04             	sub    $0x4,%esp
  802250:	68 d4 39 80 00       	push   $0x8039d4
  802255:	6a 7b                	push   $0x7b
  802257:	68 f7 39 80 00       	push   $0x8039f7
  80225c:	e8 09 e1 ff ff       	call   80036a <_panic>
  802261:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802267:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226a:	89 10                	mov    %edx,(%eax)
  80226c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226f:	8b 00                	mov    (%eax),%eax
  802271:	85 c0                	test   %eax,%eax
  802273:	74 0d                	je     802282 <insert_sorted_allocList+0x62>
  802275:	a1 40 40 80 00       	mov    0x804040,%eax
  80227a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80227d:	89 50 04             	mov    %edx,0x4(%eax)
  802280:	eb 08                	jmp    80228a <insert_sorted_allocList+0x6a>
  802282:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802285:	a3 44 40 80 00       	mov    %eax,0x804044
  80228a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228d:	a3 40 40 80 00       	mov    %eax,0x804040
  802292:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802295:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80229c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022a1:	40                   	inc    %eax
  8022a2:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8022a7:	e9 5f 01 00 00       	jmp    80240b <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8022ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022af:	8b 50 08             	mov    0x8(%eax),%edx
  8022b2:	a1 44 40 80 00       	mov    0x804044,%eax
  8022b7:	8b 40 08             	mov    0x8(%eax),%eax
  8022ba:	39 c2                	cmp    %eax,%edx
  8022bc:	76 65                	jbe    802323 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  8022be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022c2:	75 14                	jne    8022d8 <insert_sorted_allocList+0xb8>
  8022c4:	83 ec 04             	sub    $0x4,%esp
  8022c7:	68 10 3a 80 00       	push   $0x803a10
  8022cc:	6a 7f                	push   $0x7f
  8022ce:	68 f7 39 80 00       	push   $0x8039f7
  8022d3:	e8 92 e0 ff ff       	call   80036a <_panic>
  8022d8:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8022de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e1:	89 50 04             	mov    %edx,0x4(%eax)
  8022e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e7:	8b 40 04             	mov    0x4(%eax),%eax
  8022ea:	85 c0                	test   %eax,%eax
  8022ec:	74 0c                	je     8022fa <insert_sorted_allocList+0xda>
  8022ee:	a1 44 40 80 00       	mov    0x804044,%eax
  8022f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022f6:	89 10                	mov    %edx,(%eax)
  8022f8:	eb 08                	jmp    802302 <insert_sorted_allocList+0xe2>
  8022fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fd:	a3 40 40 80 00       	mov    %eax,0x804040
  802302:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802305:	a3 44 40 80 00       	mov    %eax,0x804044
  80230a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80230d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802313:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802318:	40                   	inc    %eax
  802319:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80231e:	e9 e8 00 00 00       	jmp    80240b <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802323:	a1 40 40 80 00       	mov    0x804040,%eax
  802328:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80232b:	e9 ab 00 00 00       	jmp    8023db <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802333:	8b 00                	mov    (%eax),%eax
  802335:	85 c0                	test   %eax,%eax
  802337:	0f 84 96 00 00 00    	je     8023d3 <insert_sorted_allocList+0x1b3>
  80233d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802340:	8b 50 08             	mov    0x8(%eax),%edx
  802343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802346:	8b 40 08             	mov    0x8(%eax),%eax
  802349:	39 c2                	cmp    %eax,%edx
  80234b:	0f 86 82 00 00 00    	jbe    8023d3 <insert_sorted_allocList+0x1b3>
  802351:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802354:	8b 50 08             	mov    0x8(%eax),%edx
  802357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235a:	8b 00                	mov    (%eax),%eax
  80235c:	8b 40 08             	mov    0x8(%eax),%eax
  80235f:	39 c2                	cmp    %eax,%edx
  802361:	73 70                	jae    8023d3 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802363:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802367:	74 06                	je     80236f <insert_sorted_allocList+0x14f>
  802369:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80236d:	75 17                	jne    802386 <insert_sorted_allocList+0x166>
  80236f:	83 ec 04             	sub    $0x4,%esp
  802372:	68 34 3a 80 00       	push   $0x803a34
  802377:	68 87 00 00 00       	push   $0x87
  80237c:	68 f7 39 80 00       	push   $0x8039f7
  802381:	e8 e4 df ff ff       	call   80036a <_panic>
  802386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802389:	8b 10                	mov    (%eax),%edx
  80238b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238e:	89 10                	mov    %edx,(%eax)
  802390:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802393:	8b 00                	mov    (%eax),%eax
  802395:	85 c0                	test   %eax,%eax
  802397:	74 0b                	je     8023a4 <insert_sorted_allocList+0x184>
  802399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239c:	8b 00                	mov    (%eax),%eax
  80239e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023a1:	89 50 04             	mov    %edx,0x4(%eax)
  8023a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023aa:	89 10                	mov    %edx,(%eax)
  8023ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b2:	89 50 04             	mov    %edx,0x4(%eax)
  8023b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b8:	8b 00                	mov    (%eax),%eax
  8023ba:	85 c0                	test   %eax,%eax
  8023bc:	75 08                	jne    8023c6 <insert_sorted_allocList+0x1a6>
  8023be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c1:	a3 44 40 80 00       	mov    %eax,0x804044
  8023c6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023cb:	40                   	inc    %eax
  8023cc:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8023d1:	eb 38                	jmp    80240b <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8023d3:	a1 48 40 80 00       	mov    0x804048,%eax
  8023d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023df:	74 07                	je     8023e8 <insert_sorted_allocList+0x1c8>
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	8b 00                	mov    (%eax),%eax
  8023e6:	eb 05                	jmp    8023ed <insert_sorted_allocList+0x1cd>
  8023e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ed:	a3 48 40 80 00       	mov    %eax,0x804048
  8023f2:	a1 48 40 80 00       	mov    0x804048,%eax
  8023f7:	85 c0                	test   %eax,%eax
  8023f9:	0f 85 31 ff ff ff    	jne    802330 <insert_sorted_allocList+0x110>
  8023ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802403:	0f 85 27 ff ff ff    	jne    802330 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802409:	eb 00                	jmp    80240b <insert_sorted_allocList+0x1eb>
  80240b:	90                   	nop
  80240c:	c9                   	leave  
  80240d:	c3                   	ret    

0080240e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80240e:	55                   	push   %ebp
  80240f:	89 e5                	mov    %esp,%ebp
  802411:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  80241a:	a1 48 41 80 00       	mov    0x804148,%eax
  80241f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802422:	a1 38 41 80 00       	mov    0x804138,%eax
  802427:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80242a:	e9 77 01 00 00       	jmp    8025a6 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  80242f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802432:	8b 40 0c             	mov    0xc(%eax),%eax
  802435:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802438:	0f 85 8a 00 00 00    	jne    8024c8 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80243e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802442:	75 17                	jne    80245b <alloc_block_FF+0x4d>
  802444:	83 ec 04             	sub    $0x4,%esp
  802447:	68 68 3a 80 00       	push   $0x803a68
  80244c:	68 9e 00 00 00       	push   $0x9e
  802451:	68 f7 39 80 00       	push   $0x8039f7
  802456:	e8 0f df ff ff       	call   80036a <_panic>
  80245b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245e:	8b 00                	mov    (%eax),%eax
  802460:	85 c0                	test   %eax,%eax
  802462:	74 10                	je     802474 <alloc_block_FF+0x66>
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	8b 00                	mov    (%eax),%eax
  802469:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80246c:	8b 52 04             	mov    0x4(%edx),%edx
  80246f:	89 50 04             	mov    %edx,0x4(%eax)
  802472:	eb 0b                	jmp    80247f <alloc_block_FF+0x71>
  802474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802477:	8b 40 04             	mov    0x4(%eax),%eax
  80247a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80247f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802482:	8b 40 04             	mov    0x4(%eax),%eax
  802485:	85 c0                	test   %eax,%eax
  802487:	74 0f                	je     802498 <alloc_block_FF+0x8a>
  802489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248c:	8b 40 04             	mov    0x4(%eax),%eax
  80248f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802492:	8b 12                	mov    (%edx),%edx
  802494:	89 10                	mov    %edx,(%eax)
  802496:	eb 0a                	jmp    8024a2 <alloc_block_FF+0x94>
  802498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249b:	8b 00                	mov    (%eax),%eax
  80249d:	a3 38 41 80 00       	mov    %eax,0x804138
  8024a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024b5:	a1 44 41 80 00       	mov    0x804144,%eax
  8024ba:	48                   	dec    %eax
  8024bb:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8024c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c3:	e9 11 01 00 00       	jmp    8025d9 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  8024c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ce:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024d1:	0f 86 c7 00 00 00    	jbe    80259e <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8024d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024db:	75 17                	jne    8024f4 <alloc_block_FF+0xe6>
  8024dd:	83 ec 04             	sub    $0x4,%esp
  8024e0:	68 68 3a 80 00       	push   $0x803a68
  8024e5:	68 a3 00 00 00       	push   $0xa3
  8024ea:	68 f7 39 80 00       	push   $0x8039f7
  8024ef:	e8 76 de ff ff       	call   80036a <_panic>
  8024f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f7:	8b 00                	mov    (%eax),%eax
  8024f9:	85 c0                	test   %eax,%eax
  8024fb:	74 10                	je     80250d <alloc_block_FF+0xff>
  8024fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802500:	8b 00                	mov    (%eax),%eax
  802502:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802505:	8b 52 04             	mov    0x4(%edx),%edx
  802508:	89 50 04             	mov    %edx,0x4(%eax)
  80250b:	eb 0b                	jmp    802518 <alloc_block_FF+0x10a>
  80250d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802510:	8b 40 04             	mov    0x4(%eax),%eax
  802513:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802518:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251b:	8b 40 04             	mov    0x4(%eax),%eax
  80251e:	85 c0                	test   %eax,%eax
  802520:	74 0f                	je     802531 <alloc_block_FF+0x123>
  802522:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802525:	8b 40 04             	mov    0x4(%eax),%eax
  802528:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80252b:	8b 12                	mov    (%edx),%edx
  80252d:	89 10                	mov    %edx,(%eax)
  80252f:	eb 0a                	jmp    80253b <alloc_block_FF+0x12d>
  802531:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802534:	8b 00                	mov    (%eax),%eax
  802536:	a3 48 41 80 00       	mov    %eax,0x804148
  80253b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802544:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802547:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80254e:	a1 54 41 80 00       	mov    0x804154,%eax
  802553:	48                   	dec    %eax
  802554:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802559:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80255f:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802565:	8b 40 0c             	mov    0xc(%eax),%eax
  802568:	2b 45 f0             	sub    -0x10(%ebp),%eax
  80256b:	89 c2                	mov    %eax,%edx
  80256d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802570:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802576:	8b 40 08             	mov    0x8(%eax),%eax
  802579:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  80257c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257f:	8b 50 08             	mov    0x8(%eax),%edx
  802582:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802585:	8b 40 0c             	mov    0xc(%eax),%eax
  802588:	01 c2                	add    %eax,%edx
  80258a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258d:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802590:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802593:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802596:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802599:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80259c:	eb 3b                	jmp    8025d9 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80259e:	a1 40 41 80 00       	mov    0x804140,%eax
  8025a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025aa:	74 07                	je     8025b3 <alloc_block_FF+0x1a5>
  8025ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025af:	8b 00                	mov    (%eax),%eax
  8025b1:	eb 05                	jmp    8025b8 <alloc_block_FF+0x1aa>
  8025b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b8:	a3 40 41 80 00       	mov    %eax,0x804140
  8025bd:	a1 40 41 80 00       	mov    0x804140,%eax
  8025c2:	85 c0                	test   %eax,%eax
  8025c4:	0f 85 65 fe ff ff    	jne    80242f <alloc_block_FF+0x21>
  8025ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ce:	0f 85 5b fe ff ff    	jne    80242f <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8025d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d9:	c9                   	leave  
  8025da:	c3                   	ret    

008025db <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025db:	55                   	push   %ebp
  8025dc:	89 e5                	mov    %esp,%ebp
  8025de:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  8025e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  8025e7:	a1 48 41 80 00       	mov    0x804148,%eax
  8025ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  8025ef:	a1 44 41 80 00       	mov    0x804144,%eax
  8025f4:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025f7:	a1 38 41 80 00       	mov    0x804138,%eax
  8025fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ff:	e9 a1 00 00 00       	jmp    8026a5 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802607:	8b 40 0c             	mov    0xc(%eax),%eax
  80260a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80260d:	0f 85 8a 00 00 00    	jne    80269d <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802613:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802617:	75 17                	jne    802630 <alloc_block_BF+0x55>
  802619:	83 ec 04             	sub    $0x4,%esp
  80261c:	68 68 3a 80 00       	push   $0x803a68
  802621:	68 c2 00 00 00       	push   $0xc2
  802626:	68 f7 39 80 00       	push   $0x8039f7
  80262b:	e8 3a dd ff ff       	call   80036a <_panic>
  802630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802633:	8b 00                	mov    (%eax),%eax
  802635:	85 c0                	test   %eax,%eax
  802637:	74 10                	je     802649 <alloc_block_BF+0x6e>
  802639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263c:	8b 00                	mov    (%eax),%eax
  80263e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802641:	8b 52 04             	mov    0x4(%edx),%edx
  802644:	89 50 04             	mov    %edx,0x4(%eax)
  802647:	eb 0b                	jmp    802654 <alloc_block_BF+0x79>
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	8b 40 04             	mov    0x4(%eax),%eax
  80264f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802657:	8b 40 04             	mov    0x4(%eax),%eax
  80265a:	85 c0                	test   %eax,%eax
  80265c:	74 0f                	je     80266d <alloc_block_BF+0x92>
  80265e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802661:	8b 40 04             	mov    0x4(%eax),%eax
  802664:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802667:	8b 12                	mov    (%edx),%edx
  802669:	89 10                	mov    %edx,(%eax)
  80266b:	eb 0a                	jmp    802677 <alloc_block_BF+0x9c>
  80266d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802670:	8b 00                	mov    (%eax),%eax
  802672:	a3 38 41 80 00       	mov    %eax,0x804138
  802677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802683:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80268a:	a1 44 41 80 00       	mov    0x804144,%eax
  80268f:	48                   	dec    %eax
  802690:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	e9 11 02 00 00       	jmp    8028ae <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  80269d:	a1 40 41 80 00       	mov    0x804140,%eax
  8026a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a9:	74 07                	je     8026b2 <alloc_block_BF+0xd7>
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	8b 00                	mov    (%eax),%eax
  8026b0:	eb 05                	jmp    8026b7 <alloc_block_BF+0xdc>
  8026b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b7:	a3 40 41 80 00       	mov    %eax,0x804140
  8026bc:	a1 40 41 80 00       	mov    0x804140,%eax
  8026c1:	85 c0                	test   %eax,%eax
  8026c3:	0f 85 3b ff ff ff    	jne    802604 <alloc_block_BF+0x29>
  8026c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026cd:	0f 85 31 ff ff ff    	jne    802604 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026d3:	a1 38 41 80 00       	mov    0x804138,%eax
  8026d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026db:	eb 27                	jmp    802704 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  8026dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8026e6:	76 14                	jbe    8026fc <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  8026e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  8026f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f4:	8b 40 08             	mov    0x8(%eax),%eax
  8026f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  8026fa:	eb 2e                	jmp    80272a <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026fc:	a1 40 41 80 00       	mov    0x804140,%eax
  802701:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802704:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802708:	74 07                	je     802711 <alloc_block_BF+0x136>
  80270a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270d:	8b 00                	mov    (%eax),%eax
  80270f:	eb 05                	jmp    802716 <alloc_block_BF+0x13b>
  802711:	b8 00 00 00 00       	mov    $0x0,%eax
  802716:	a3 40 41 80 00       	mov    %eax,0x804140
  80271b:	a1 40 41 80 00       	mov    0x804140,%eax
  802720:	85 c0                	test   %eax,%eax
  802722:	75 b9                	jne    8026dd <alloc_block_BF+0x102>
  802724:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802728:	75 b3                	jne    8026dd <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80272a:	a1 38 41 80 00       	mov    0x804138,%eax
  80272f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802732:	eb 30                	jmp    802764 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802737:	8b 40 0c             	mov    0xc(%eax),%eax
  80273a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80273d:	73 1d                	jae    80275c <alloc_block_BF+0x181>
  80273f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802742:	8b 40 0c             	mov    0xc(%eax),%eax
  802745:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802748:	76 12                	jbe    80275c <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  80274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274d:	8b 40 0c             	mov    0xc(%eax),%eax
  802750:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	8b 40 08             	mov    0x8(%eax),%eax
  802759:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80275c:	a1 40 41 80 00       	mov    0x804140,%eax
  802761:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802764:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802768:	74 07                	je     802771 <alloc_block_BF+0x196>
  80276a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276d:	8b 00                	mov    (%eax),%eax
  80276f:	eb 05                	jmp    802776 <alloc_block_BF+0x19b>
  802771:	b8 00 00 00 00       	mov    $0x0,%eax
  802776:	a3 40 41 80 00       	mov    %eax,0x804140
  80277b:	a1 40 41 80 00       	mov    0x804140,%eax
  802780:	85 c0                	test   %eax,%eax
  802782:	75 b0                	jne    802734 <alloc_block_BF+0x159>
  802784:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802788:	75 aa                	jne    802734 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80278a:	a1 38 41 80 00       	mov    0x804138,%eax
  80278f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802792:	e9 e4 00 00 00       	jmp    80287b <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279a:	8b 40 0c             	mov    0xc(%eax),%eax
  80279d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8027a0:	0f 85 cd 00 00 00    	jne    802873 <alloc_block_BF+0x298>
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	8b 40 08             	mov    0x8(%eax),%eax
  8027ac:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027af:	0f 85 be 00 00 00    	jne    802873 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  8027b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027b9:	75 17                	jne    8027d2 <alloc_block_BF+0x1f7>
  8027bb:	83 ec 04             	sub    $0x4,%esp
  8027be:	68 68 3a 80 00       	push   $0x803a68
  8027c3:	68 db 00 00 00       	push   $0xdb
  8027c8:	68 f7 39 80 00       	push   $0x8039f7
  8027cd:	e8 98 db ff ff       	call   80036a <_panic>
  8027d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d5:	8b 00                	mov    (%eax),%eax
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	74 10                	je     8027eb <alloc_block_BF+0x210>
  8027db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027de:	8b 00                	mov    (%eax),%eax
  8027e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027e3:	8b 52 04             	mov    0x4(%edx),%edx
  8027e6:	89 50 04             	mov    %edx,0x4(%eax)
  8027e9:	eb 0b                	jmp    8027f6 <alloc_block_BF+0x21b>
  8027eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ee:	8b 40 04             	mov    0x4(%eax),%eax
  8027f1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f9:	8b 40 04             	mov    0x4(%eax),%eax
  8027fc:	85 c0                	test   %eax,%eax
  8027fe:	74 0f                	je     80280f <alloc_block_BF+0x234>
  802800:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802803:	8b 40 04             	mov    0x4(%eax),%eax
  802806:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802809:	8b 12                	mov    (%edx),%edx
  80280b:	89 10                	mov    %edx,(%eax)
  80280d:	eb 0a                	jmp    802819 <alloc_block_BF+0x23e>
  80280f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802812:	8b 00                	mov    (%eax),%eax
  802814:	a3 48 41 80 00       	mov    %eax,0x804148
  802819:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80281c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802822:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802825:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80282c:	a1 54 41 80 00       	mov    0x804154,%eax
  802831:	48                   	dec    %eax
  802832:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802837:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80283a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80283d:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802840:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802843:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802846:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	8b 40 0c             	mov    0xc(%eax),%eax
  80284f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802852:	89 c2                	mov    %eax,%edx
  802854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802857:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  80285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285d:	8b 50 08             	mov    0x8(%eax),%edx
  802860:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802863:	8b 40 0c             	mov    0xc(%eax),%eax
  802866:	01 c2                	add    %eax,%edx
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  80286e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802871:	eb 3b                	jmp    8028ae <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802873:	a1 40 41 80 00       	mov    0x804140,%eax
  802878:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80287b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80287f:	74 07                	je     802888 <alloc_block_BF+0x2ad>
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	8b 00                	mov    (%eax),%eax
  802886:	eb 05                	jmp    80288d <alloc_block_BF+0x2b2>
  802888:	b8 00 00 00 00       	mov    $0x0,%eax
  80288d:	a3 40 41 80 00       	mov    %eax,0x804140
  802892:	a1 40 41 80 00       	mov    0x804140,%eax
  802897:	85 c0                	test   %eax,%eax
  802899:	0f 85 f8 fe ff ff    	jne    802797 <alloc_block_BF+0x1bc>
  80289f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a3:	0f 85 ee fe ff ff    	jne    802797 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  8028a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028ae:	c9                   	leave  
  8028af:	c3                   	ret    

008028b0 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8028b0:	55                   	push   %ebp
  8028b1:	89 e5                	mov    %esp,%ebp
  8028b3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  8028b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8028bc:	a1 48 41 80 00       	mov    0x804148,%eax
  8028c1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8028c4:	a1 38 41 80 00       	mov    0x804138,%eax
  8028c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028cc:	e9 77 01 00 00       	jmp    802a48 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028da:	0f 85 8a 00 00 00    	jne    80296a <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8028e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e4:	75 17                	jne    8028fd <alloc_block_NF+0x4d>
  8028e6:	83 ec 04             	sub    $0x4,%esp
  8028e9:	68 68 3a 80 00       	push   $0x803a68
  8028ee:	68 f7 00 00 00       	push   $0xf7
  8028f3:	68 f7 39 80 00       	push   $0x8039f7
  8028f8:	e8 6d da ff ff       	call   80036a <_panic>
  8028fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802900:	8b 00                	mov    (%eax),%eax
  802902:	85 c0                	test   %eax,%eax
  802904:	74 10                	je     802916 <alloc_block_NF+0x66>
  802906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802909:	8b 00                	mov    (%eax),%eax
  80290b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80290e:	8b 52 04             	mov    0x4(%edx),%edx
  802911:	89 50 04             	mov    %edx,0x4(%eax)
  802914:	eb 0b                	jmp    802921 <alloc_block_NF+0x71>
  802916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802919:	8b 40 04             	mov    0x4(%eax),%eax
  80291c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	8b 40 04             	mov    0x4(%eax),%eax
  802927:	85 c0                	test   %eax,%eax
  802929:	74 0f                	je     80293a <alloc_block_NF+0x8a>
  80292b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292e:	8b 40 04             	mov    0x4(%eax),%eax
  802931:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802934:	8b 12                	mov    (%edx),%edx
  802936:	89 10                	mov    %edx,(%eax)
  802938:	eb 0a                	jmp    802944 <alloc_block_NF+0x94>
  80293a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293d:	8b 00                	mov    (%eax),%eax
  80293f:	a3 38 41 80 00       	mov    %eax,0x804138
  802944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802947:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80294d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802950:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802957:	a1 44 41 80 00       	mov    0x804144,%eax
  80295c:	48                   	dec    %eax
  80295d:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802965:	e9 11 01 00 00       	jmp    802a7b <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  80296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296d:	8b 40 0c             	mov    0xc(%eax),%eax
  802970:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802973:	0f 86 c7 00 00 00    	jbe    802a40 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802979:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80297d:	75 17                	jne    802996 <alloc_block_NF+0xe6>
  80297f:	83 ec 04             	sub    $0x4,%esp
  802982:	68 68 3a 80 00       	push   $0x803a68
  802987:	68 fc 00 00 00       	push   $0xfc
  80298c:	68 f7 39 80 00       	push   $0x8039f7
  802991:	e8 d4 d9 ff ff       	call   80036a <_panic>
  802996:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802999:	8b 00                	mov    (%eax),%eax
  80299b:	85 c0                	test   %eax,%eax
  80299d:	74 10                	je     8029af <alloc_block_NF+0xff>
  80299f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a2:	8b 00                	mov    (%eax),%eax
  8029a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029a7:	8b 52 04             	mov    0x4(%edx),%edx
  8029aa:	89 50 04             	mov    %edx,0x4(%eax)
  8029ad:	eb 0b                	jmp    8029ba <alloc_block_NF+0x10a>
  8029af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b2:	8b 40 04             	mov    0x4(%eax),%eax
  8029b5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029bd:	8b 40 04             	mov    0x4(%eax),%eax
  8029c0:	85 c0                	test   %eax,%eax
  8029c2:	74 0f                	je     8029d3 <alloc_block_NF+0x123>
  8029c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c7:	8b 40 04             	mov    0x4(%eax),%eax
  8029ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029cd:	8b 12                	mov    (%edx),%edx
  8029cf:	89 10                	mov    %edx,(%eax)
  8029d1:	eb 0a                	jmp    8029dd <alloc_block_NF+0x12d>
  8029d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d6:	8b 00                	mov    (%eax),%eax
  8029d8:	a3 48 41 80 00       	mov    %eax,0x804148
  8029dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029f0:	a1 54 41 80 00       	mov    0x804154,%eax
  8029f5:	48                   	dec    %eax
  8029f6:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8029fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a01:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a07:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0a:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802a0d:	89 c2                	mov    %eax,%edx
  802a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a12:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a18:	8b 40 08             	mov    0x8(%eax),%eax
  802a1b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a21:	8b 50 08             	mov    0x8(%eax),%edx
  802a24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a27:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2a:	01 c2                	add    %eax,%edx
  802a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2f:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802a32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a35:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a38:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802a3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3e:	eb 3b                	jmp    802a7b <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802a40:	a1 40 41 80 00       	mov    0x804140,%eax
  802a45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a4c:	74 07                	je     802a55 <alloc_block_NF+0x1a5>
  802a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a51:	8b 00                	mov    (%eax),%eax
  802a53:	eb 05                	jmp    802a5a <alloc_block_NF+0x1aa>
  802a55:	b8 00 00 00 00       	mov    $0x0,%eax
  802a5a:	a3 40 41 80 00       	mov    %eax,0x804140
  802a5f:	a1 40 41 80 00       	mov    0x804140,%eax
  802a64:	85 c0                	test   %eax,%eax
  802a66:	0f 85 65 fe ff ff    	jne    8028d1 <alloc_block_NF+0x21>
  802a6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a70:	0f 85 5b fe ff ff    	jne    8028d1 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802a76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a7b:	c9                   	leave  
  802a7c:	c3                   	ret    

00802a7d <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802a7d:	55                   	push   %ebp
  802a7e:	89 e5                	mov    %esp,%ebp
  802a80:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802a83:	8b 45 08             	mov    0x8(%ebp),%eax
  802a86:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a90:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802a97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a9b:	75 17                	jne    802ab4 <addToAvailMemBlocksList+0x37>
  802a9d:	83 ec 04             	sub    $0x4,%esp
  802aa0:	68 10 3a 80 00       	push   $0x803a10
  802aa5:	68 10 01 00 00       	push   $0x110
  802aaa:	68 f7 39 80 00       	push   $0x8039f7
  802aaf:	e8 b6 d8 ff ff       	call   80036a <_panic>
  802ab4:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802aba:	8b 45 08             	mov    0x8(%ebp),%eax
  802abd:	89 50 04             	mov    %edx,0x4(%eax)
  802ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac3:	8b 40 04             	mov    0x4(%eax),%eax
  802ac6:	85 c0                	test   %eax,%eax
  802ac8:	74 0c                	je     802ad6 <addToAvailMemBlocksList+0x59>
  802aca:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802acf:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad2:	89 10                	mov    %edx,(%eax)
  802ad4:	eb 08                	jmp    802ade <addToAvailMemBlocksList+0x61>
  802ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad9:	a3 48 41 80 00       	mov    %eax,0x804148
  802ade:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aef:	a1 54 41 80 00       	mov    0x804154,%eax
  802af4:	40                   	inc    %eax
  802af5:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802afa:	90                   	nop
  802afb:	c9                   	leave  
  802afc:	c3                   	ret    

00802afd <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802afd:	55                   	push   %ebp
  802afe:	89 e5                	mov    %esp,%ebp
  802b00:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802b03:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b08:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802b0b:	a1 44 41 80 00       	mov    0x804144,%eax
  802b10:	85 c0                	test   %eax,%eax
  802b12:	75 68                	jne    802b7c <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802b14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b18:	75 17                	jne    802b31 <insert_sorted_with_merge_freeList+0x34>
  802b1a:	83 ec 04             	sub    $0x4,%esp
  802b1d:	68 d4 39 80 00       	push   $0x8039d4
  802b22:	68 1a 01 00 00       	push   $0x11a
  802b27:	68 f7 39 80 00       	push   $0x8039f7
  802b2c:	e8 39 d8 ff ff       	call   80036a <_panic>
  802b31:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b37:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3a:	89 10                	mov    %edx,(%eax)
  802b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3f:	8b 00                	mov    (%eax),%eax
  802b41:	85 c0                	test   %eax,%eax
  802b43:	74 0d                	je     802b52 <insert_sorted_with_merge_freeList+0x55>
  802b45:	a1 38 41 80 00       	mov    0x804138,%eax
  802b4a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b4d:	89 50 04             	mov    %edx,0x4(%eax)
  802b50:	eb 08                	jmp    802b5a <insert_sorted_with_merge_freeList+0x5d>
  802b52:	8b 45 08             	mov    0x8(%ebp),%eax
  802b55:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5d:	a3 38 41 80 00       	mov    %eax,0x804138
  802b62:	8b 45 08             	mov    0x8(%ebp),%eax
  802b65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b6c:	a1 44 41 80 00       	mov    0x804144,%eax
  802b71:	40                   	inc    %eax
  802b72:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802b77:	e9 c5 03 00 00       	jmp    802f41 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7f:	8b 50 08             	mov    0x8(%eax),%edx
  802b82:	8b 45 08             	mov    0x8(%ebp),%eax
  802b85:	8b 40 08             	mov    0x8(%eax),%eax
  802b88:	39 c2                	cmp    %eax,%edx
  802b8a:	0f 83 b2 00 00 00    	jae    802c42 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b93:	8b 50 08             	mov    0x8(%eax),%edx
  802b96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b99:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9c:	01 c2                	add    %eax,%edx
  802b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba1:	8b 40 08             	mov    0x8(%eax),%eax
  802ba4:	39 c2                	cmp    %eax,%edx
  802ba6:	75 27                	jne    802bcf <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bab:	8b 50 0c             	mov    0xc(%eax),%edx
  802bae:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb1:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb4:	01 c2                	add    %eax,%edx
  802bb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb9:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802bbc:	83 ec 0c             	sub    $0xc,%esp
  802bbf:	ff 75 08             	pushl  0x8(%ebp)
  802bc2:	e8 b6 fe ff ff       	call   802a7d <addToAvailMemBlocksList>
  802bc7:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802bca:	e9 72 03 00 00       	jmp    802f41 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802bcf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bd3:	74 06                	je     802bdb <insert_sorted_with_merge_freeList+0xde>
  802bd5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bd9:	75 17                	jne    802bf2 <insert_sorted_with_merge_freeList+0xf5>
  802bdb:	83 ec 04             	sub    $0x4,%esp
  802bde:	68 34 3a 80 00       	push   $0x803a34
  802be3:	68 24 01 00 00       	push   $0x124
  802be8:	68 f7 39 80 00       	push   $0x8039f7
  802bed:	e8 78 d7 ff ff       	call   80036a <_panic>
  802bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf5:	8b 10                	mov    (%eax),%edx
  802bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfa:	89 10                	mov    %edx,(%eax)
  802bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bff:	8b 00                	mov    (%eax),%eax
  802c01:	85 c0                	test   %eax,%eax
  802c03:	74 0b                	je     802c10 <insert_sorted_with_merge_freeList+0x113>
  802c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c08:	8b 00                	mov    (%eax),%eax
  802c0a:	8b 55 08             	mov    0x8(%ebp),%edx
  802c0d:	89 50 04             	mov    %edx,0x4(%eax)
  802c10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c13:	8b 55 08             	mov    0x8(%ebp),%edx
  802c16:	89 10                	mov    %edx,(%eax)
  802c18:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c1e:	89 50 04             	mov    %edx,0x4(%eax)
  802c21:	8b 45 08             	mov    0x8(%ebp),%eax
  802c24:	8b 00                	mov    (%eax),%eax
  802c26:	85 c0                	test   %eax,%eax
  802c28:	75 08                	jne    802c32 <insert_sorted_with_merge_freeList+0x135>
  802c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c32:	a1 44 41 80 00       	mov    0x804144,%eax
  802c37:	40                   	inc    %eax
  802c38:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802c3d:	e9 ff 02 00 00       	jmp    802f41 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802c42:	a1 38 41 80 00       	mov    0x804138,%eax
  802c47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c4a:	e9 c2 02 00 00       	jmp    802f11 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c52:	8b 50 08             	mov    0x8(%eax),%edx
  802c55:	8b 45 08             	mov    0x8(%ebp),%eax
  802c58:	8b 40 08             	mov    0x8(%eax),%eax
  802c5b:	39 c2                	cmp    %eax,%edx
  802c5d:	0f 86 a6 02 00 00    	jbe    802f09 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c66:	8b 40 04             	mov    0x4(%eax),%eax
  802c69:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802c6c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c70:	0f 85 ba 00 00 00    	jne    802d30 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802c76:	8b 45 08             	mov    0x8(%ebp),%eax
  802c79:	8b 50 0c             	mov    0xc(%eax),%edx
  802c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7f:	8b 40 08             	mov    0x8(%eax),%eax
  802c82:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802c8a:	39 c2                	cmp    %eax,%edx
  802c8c:	75 33                	jne    802cc1 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c91:	8b 50 08             	mov    0x8(%eax),%edx
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9d:	8b 50 0c             	mov    0xc(%eax),%edx
  802ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca6:	01 c2                	add    %eax,%edx
  802ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cab:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802cae:	83 ec 0c             	sub    $0xc,%esp
  802cb1:	ff 75 08             	pushl  0x8(%ebp)
  802cb4:	e8 c4 fd ff ff       	call   802a7d <addToAvailMemBlocksList>
  802cb9:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802cbc:	e9 80 02 00 00       	jmp    802f41 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802cc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc5:	74 06                	je     802ccd <insert_sorted_with_merge_freeList+0x1d0>
  802cc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ccb:	75 17                	jne    802ce4 <insert_sorted_with_merge_freeList+0x1e7>
  802ccd:	83 ec 04             	sub    $0x4,%esp
  802cd0:	68 88 3a 80 00       	push   $0x803a88
  802cd5:	68 3a 01 00 00       	push   $0x13a
  802cda:	68 f7 39 80 00       	push   $0x8039f7
  802cdf:	e8 86 d6 ff ff       	call   80036a <_panic>
  802ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce7:	8b 50 04             	mov    0x4(%eax),%edx
  802cea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ced:	89 50 04             	mov    %edx,0x4(%eax)
  802cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf6:	89 10                	mov    %edx,(%eax)
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	8b 40 04             	mov    0x4(%eax),%eax
  802cfe:	85 c0                	test   %eax,%eax
  802d00:	74 0d                	je     802d0f <insert_sorted_with_merge_freeList+0x212>
  802d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d05:	8b 40 04             	mov    0x4(%eax),%eax
  802d08:	8b 55 08             	mov    0x8(%ebp),%edx
  802d0b:	89 10                	mov    %edx,(%eax)
  802d0d:	eb 08                	jmp    802d17 <insert_sorted_with_merge_freeList+0x21a>
  802d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d12:	a3 38 41 80 00       	mov    %eax,0x804138
  802d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d1d:	89 50 04             	mov    %edx,0x4(%eax)
  802d20:	a1 44 41 80 00       	mov    0x804144,%eax
  802d25:	40                   	inc    %eax
  802d26:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802d2b:	e9 11 02 00 00       	jmp    802f41 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802d30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d33:	8b 50 08             	mov    0x8(%eax),%edx
  802d36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d39:	8b 40 0c             	mov    0xc(%eax),%eax
  802d3c:	01 c2                	add    %eax,%edx
  802d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d41:	8b 40 0c             	mov    0xc(%eax),%eax
  802d44:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d49:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802d4c:	39 c2                	cmp    %eax,%edx
  802d4e:	0f 85 bf 00 00 00    	jne    802e13 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802d54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d57:	8b 50 0c             	mov    0xc(%eax),%edx
  802d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d60:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d65:	8b 40 0c             	mov    0xc(%eax),%eax
  802d68:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802d6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6d:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802d70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d74:	75 17                	jne    802d8d <insert_sorted_with_merge_freeList+0x290>
  802d76:	83 ec 04             	sub    $0x4,%esp
  802d79:	68 68 3a 80 00       	push   $0x803a68
  802d7e:	68 43 01 00 00       	push   $0x143
  802d83:	68 f7 39 80 00       	push   $0x8039f7
  802d88:	e8 dd d5 ff ff       	call   80036a <_panic>
  802d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d90:	8b 00                	mov    (%eax),%eax
  802d92:	85 c0                	test   %eax,%eax
  802d94:	74 10                	je     802da6 <insert_sorted_with_merge_freeList+0x2a9>
  802d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d99:	8b 00                	mov    (%eax),%eax
  802d9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d9e:	8b 52 04             	mov    0x4(%edx),%edx
  802da1:	89 50 04             	mov    %edx,0x4(%eax)
  802da4:	eb 0b                	jmp    802db1 <insert_sorted_with_merge_freeList+0x2b4>
  802da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da9:	8b 40 04             	mov    0x4(%eax),%eax
  802dac:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db4:	8b 40 04             	mov    0x4(%eax),%eax
  802db7:	85 c0                	test   %eax,%eax
  802db9:	74 0f                	je     802dca <insert_sorted_with_merge_freeList+0x2cd>
  802dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbe:	8b 40 04             	mov    0x4(%eax),%eax
  802dc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dc4:	8b 12                	mov    (%edx),%edx
  802dc6:	89 10                	mov    %edx,(%eax)
  802dc8:	eb 0a                	jmp    802dd4 <insert_sorted_with_merge_freeList+0x2d7>
  802dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcd:	8b 00                	mov    (%eax),%eax
  802dcf:	a3 38 41 80 00       	mov    %eax,0x804138
  802dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de7:	a1 44 41 80 00       	mov    0x804144,%eax
  802dec:	48                   	dec    %eax
  802ded:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802df2:	83 ec 0c             	sub    $0xc,%esp
  802df5:	ff 75 08             	pushl  0x8(%ebp)
  802df8:	e8 80 fc ff ff       	call   802a7d <addToAvailMemBlocksList>
  802dfd:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802e00:	83 ec 0c             	sub    $0xc,%esp
  802e03:	ff 75 f4             	pushl  -0xc(%ebp)
  802e06:	e8 72 fc ff ff       	call   802a7d <addToAvailMemBlocksList>
  802e0b:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802e0e:	e9 2e 01 00 00       	jmp    802f41 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802e13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e16:	8b 50 08             	mov    0x8(%eax),%edx
  802e19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1f:	01 c2                	add    %eax,%edx
  802e21:	8b 45 08             	mov    0x8(%ebp),%eax
  802e24:	8b 40 08             	mov    0x8(%eax),%eax
  802e27:	39 c2                	cmp    %eax,%edx
  802e29:	75 27                	jne    802e52 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802e2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2e:	8b 50 0c             	mov    0xc(%eax),%edx
  802e31:	8b 45 08             	mov    0x8(%ebp),%eax
  802e34:	8b 40 0c             	mov    0xc(%eax),%eax
  802e37:	01 c2                	add    %eax,%edx
  802e39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3c:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802e3f:	83 ec 0c             	sub    $0xc,%esp
  802e42:	ff 75 08             	pushl  0x8(%ebp)
  802e45:	e8 33 fc ff ff       	call   802a7d <addToAvailMemBlocksList>
  802e4a:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802e4d:	e9 ef 00 00 00       	jmp    802f41 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802e52:	8b 45 08             	mov    0x8(%ebp),%eax
  802e55:	8b 50 0c             	mov    0xc(%eax),%edx
  802e58:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5b:	8b 40 08             	mov    0x8(%eax),%eax
  802e5e:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e63:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802e66:	39 c2                	cmp    %eax,%edx
  802e68:	75 33                	jne    802e9d <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6d:	8b 50 08             	mov    0x8(%eax),%edx
  802e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e73:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e79:	8b 50 0c             	mov    0xc(%eax),%edx
  802e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e82:	01 c2                	add    %eax,%edx
  802e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e87:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802e8a:	83 ec 0c             	sub    $0xc,%esp
  802e8d:	ff 75 08             	pushl  0x8(%ebp)
  802e90:	e8 e8 fb ff ff       	call   802a7d <addToAvailMemBlocksList>
  802e95:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802e98:	e9 a4 00 00 00       	jmp    802f41 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802e9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea1:	74 06                	je     802ea9 <insert_sorted_with_merge_freeList+0x3ac>
  802ea3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ea7:	75 17                	jne    802ec0 <insert_sorted_with_merge_freeList+0x3c3>
  802ea9:	83 ec 04             	sub    $0x4,%esp
  802eac:	68 88 3a 80 00       	push   $0x803a88
  802eb1:	68 56 01 00 00       	push   $0x156
  802eb6:	68 f7 39 80 00       	push   $0x8039f7
  802ebb:	e8 aa d4 ff ff       	call   80036a <_panic>
  802ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec3:	8b 50 04             	mov    0x4(%eax),%edx
  802ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec9:	89 50 04             	mov    %edx,0x4(%eax)
  802ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed2:	89 10                	mov    %edx,(%eax)
  802ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed7:	8b 40 04             	mov    0x4(%eax),%eax
  802eda:	85 c0                	test   %eax,%eax
  802edc:	74 0d                	je     802eeb <insert_sorted_with_merge_freeList+0x3ee>
  802ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee1:	8b 40 04             	mov    0x4(%eax),%eax
  802ee4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ee7:	89 10                	mov    %edx,(%eax)
  802ee9:	eb 08                	jmp    802ef3 <insert_sorted_with_merge_freeList+0x3f6>
  802eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802eee:	a3 38 41 80 00       	mov    %eax,0x804138
  802ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef9:	89 50 04             	mov    %edx,0x4(%eax)
  802efc:	a1 44 41 80 00       	mov    0x804144,%eax
  802f01:	40                   	inc    %eax
  802f02:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802f07:	eb 38                	jmp    802f41 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802f09:	a1 40 41 80 00       	mov    0x804140,%eax
  802f0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f15:	74 07                	je     802f1e <insert_sorted_with_merge_freeList+0x421>
  802f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1a:	8b 00                	mov    (%eax),%eax
  802f1c:	eb 05                	jmp    802f23 <insert_sorted_with_merge_freeList+0x426>
  802f1e:	b8 00 00 00 00       	mov    $0x0,%eax
  802f23:	a3 40 41 80 00       	mov    %eax,0x804140
  802f28:	a1 40 41 80 00       	mov    0x804140,%eax
  802f2d:	85 c0                	test   %eax,%eax
  802f2f:	0f 85 1a fd ff ff    	jne    802c4f <insert_sorted_with_merge_freeList+0x152>
  802f35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f39:	0f 85 10 fd ff ff    	jne    802c4f <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f3f:	eb 00                	jmp    802f41 <insert_sorted_with_merge_freeList+0x444>
  802f41:	90                   	nop
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
