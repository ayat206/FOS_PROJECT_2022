
obj/user/ef_MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 b4 01 00 00       	call   8001ea <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	/*[1] CREATE SHARED VARIABLE & INITIALIZE IT*/
	int *X = smalloc("X", sizeof(int) , 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 20 32 80 00       	push   $0x803220
  80004a:	e8 65 16 00 00       	call   8016b4 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	//cprintf("Do you want to use semaphore (y/n)? ") ;
	//char select = getchar() ;
	char select = 'y';
  80005e:	c6 45 f3 79          	movb   $0x79,-0xd(%ebp)
	//cputchar(select);
	//cputchar('\n');

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *useSem = smalloc("useSem", sizeof(int) , 0) ;
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	6a 00                	push   $0x0
  800067:	6a 04                	push   $0x4
  800069:	68 22 32 80 00       	push   $0x803222
  80006e:	e8 41 16 00 00       	call   8016b4 <smalloc>
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	89 45 ec             	mov    %eax,-0x14(%ebp)
	*useSem = 0 ;
  800079:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80007c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == 'Y' || select == 'y')
  800082:	80 7d f3 59          	cmpb   $0x59,-0xd(%ebp)
  800086:	74 06                	je     80008e <_main+0x56>
  800088:	80 7d f3 79          	cmpb   $0x79,-0xd(%ebp)
  80008c:	75 09                	jne    800097 <_main+0x5f>
		*useSem = 1 ;
  80008e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800091:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	if (*useSem == 1)
  800097:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80009a:	8b 00                	mov    (%eax),%eax
  80009c:	83 f8 01             	cmp    $0x1,%eax
  80009f:	75 12                	jne    8000b3 <_main+0x7b>
	{
		sys_createSemaphore("T", 0);
  8000a1:	83 ec 08             	sub    $0x8,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	68 29 32 80 00       	push   $0x803229
  8000ab:	e8 29 1a 00 00       	call   801ad9 <sys_createSemaphore>
  8000b0:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 01                	push   $0x1
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 2b 32 80 00       	push   $0x80322b
  8000bf:	e8 f0 15 00 00       	call   8016b4 <smalloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	*numOfFinished = 0 ;
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8000d8:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000de:	89 c2                	mov    %eax,%edx
  8000e0:	a1 20 40 80 00       	mov    0x804020,%eax
  8000e5:	8b 40 74             	mov    0x74(%eax),%eax
  8000e8:	6a 32                	push   $0x32
  8000ea:	52                   	push   %edx
  8000eb:	50                   	push   %eax
  8000ec:	68 39 32 80 00       	push   $0x803239
  8000f1:	e8 f4 1a 00 00       	call   801bea <sys_create_env>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800101:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800107:	89 c2                	mov    %eax,%edx
  800109:	a1 20 40 80 00       	mov    0x804020,%eax
  80010e:	8b 40 74             	mov    0x74(%eax),%eax
  800111:	6a 32                	push   $0x32
  800113:	52                   	push   %edx
  800114:	50                   	push   %eax
  800115:	68 43 32 80 00       	push   $0x803243
  80011a:	e8 cb 1a 00 00       	call   801bea <sys_create_env>
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (envIdProcessA == E_ENV_CREATION_ERROR || envIdProcessB == E_ENV_CREATION_ERROR)
  800125:	83 7d e4 ef          	cmpl   $0xffffffef,-0x1c(%ebp)
  800129:	74 06                	je     800131 <_main+0xf9>
  80012b:	83 7d e0 ef          	cmpl   $0xffffffef,-0x20(%ebp)
  80012f:	75 14                	jne    800145 <_main+0x10d>
		panic("NO AVAILABLE ENVs...");
  800131:	83 ec 04             	sub    $0x4,%esp
  800134:	68 4d 32 80 00       	push   $0x80324d
  800139:	6a 27                	push   $0x27
  80013b:	68 62 32 80 00       	push   $0x803262
  800140:	e8 e1 01 00 00       	call   800326 <_panic>

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	ff 75 e4             	pushl  -0x1c(%ebp)
  80014b:	e8 b8 1a 00 00       	call   801c08 <sys_run_env>
  800150:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	68 10 27 00 00       	push   $0x2710
  80015b:	e8 a0 2d 00 00       	call   802f00 <env_sleep>
  800160:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800163:	83 ec 0c             	sub    $0xc,%esp
  800166:	ff 75 e0             	pushl  -0x20(%ebp)
  800169:	e8 9a 1a 00 00       	call   801c08 <sys_run_env>
  80016e:	83 c4 10             	add    $0x10,%esp

	/*[5] BUSY-WAIT TILL FINISHING BOTH PROCESSES*/
	while (*numOfFinished != 2) ;
  800171:	90                   	nop
  800172:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800175:	8b 00                	mov    (%eax),%eax
  800177:	83 f8 02             	cmp    $0x2,%eax
  80017a:	75 f6                	jne    800172 <_main+0x13a>

	/*[6] PRINT X*/
	cprintf("Final value of X = %d\n", *X);
  80017c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80017f:	8b 00                	mov    (%eax),%eax
  800181:	83 ec 08             	sub    $0x8,%esp
  800184:	50                   	push   %eax
  800185:	68 7d 32 80 00       	push   $0x80327d
  80018a:	e8 4b 04 00 00       	call   8005da <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800192:	e8 da 1a 00 00       	call   801c71 <sys_getparentenvid>
  800197:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(parentenvID > 0)
  80019a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80019e:	7e 47                	jle    8001e7 <_main+0x1af>
	{
		//Get the check-finishing counter
		int *AllFinish = NULL;
  8001a0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		AllFinish = sget(parentenvID, "finishedCount") ;
  8001a7:	83 ec 08             	sub    $0x8,%esp
  8001aa:	68 2b 32 80 00       	push   $0x80322b
  8001af:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b2:	e8 ad 15 00 00       	call   801764 <sget>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_destroy_env(envIdProcessA);
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c3:	e8 5c 1a 00 00       	call   801c24 <sys_destroy_env>
  8001c8:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001cb:	83 ec 0c             	sub    $0xc,%esp
  8001ce:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d1:	e8 4e 1a 00 00       	call   801c24 <sys_destroy_env>
  8001d6:	83 c4 10             	add    $0x10,%esp
		(*AllFinish)++ ;
  8001d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001dc:	8b 00                	mov    (%eax),%eax
  8001de:	8d 50 01             	lea    0x1(%eax),%edx
  8001e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001e4:	89 10                	mov    %edx,(%eax)
	}

	return;
  8001e6:	90                   	nop
  8001e7:	90                   	nop
}
  8001e8:	c9                   	leave  
  8001e9:	c3                   	ret    

008001ea <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001f0:	e8 63 1a 00 00       	call   801c58 <sys_getenvindex>
  8001f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001fb:	89 d0                	mov    %edx,%eax
  8001fd:	c1 e0 03             	shl    $0x3,%eax
  800200:	01 d0                	add    %edx,%eax
  800202:	01 c0                	add    %eax,%eax
  800204:	01 d0                	add    %edx,%eax
  800206:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80020d:	01 d0                	add    %edx,%eax
  80020f:	c1 e0 04             	shl    $0x4,%eax
  800212:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800217:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80021c:	a1 20 40 80 00       	mov    0x804020,%eax
  800221:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800227:	84 c0                	test   %al,%al
  800229:	74 0f                	je     80023a <libmain+0x50>
		binaryname = myEnv->prog_name;
  80022b:	a1 20 40 80 00       	mov    0x804020,%eax
  800230:	05 5c 05 00 00       	add    $0x55c,%eax
  800235:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80023a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80023e:	7e 0a                	jle    80024a <libmain+0x60>
		binaryname = argv[0];
  800240:	8b 45 0c             	mov    0xc(%ebp),%eax
  800243:	8b 00                	mov    (%eax),%eax
  800245:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80024a:	83 ec 08             	sub    $0x8,%esp
  80024d:	ff 75 0c             	pushl  0xc(%ebp)
  800250:	ff 75 08             	pushl  0x8(%ebp)
  800253:	e8 e0 fd ff ff       	call   800038 <_main>
  800258:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80025b:	e8 05 18 00 00       	call   801a65 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	68 ac 32 80 00       	push   $0x8032ac
  800268:	e8 6d 03 00 00       	call   8005da <cprintf>
  80026d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800270:	a1 20 40 80 00       	mov    0x804020,%eax
  800275:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80027b:	a1 20 40 80 00       	mov    0x804020,%eax
  800280:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800286:	83 ec 04             	sub    $0x4,%esp
  800289:	52                   	push   %edx
  80028a:	50                   	push   %eax
  80028b:	68 d4 32 80 00       	push   $0x8032d4
  800290:	e8 45 03 00 00       	call   8005da <cprintf>
  800295:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800298:	a1 20 40 80 00       	mov    0x804020,%eax
  80029d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002a3:	a1 20 40 80 00       	mov    0x804020,%eax
  8002a8:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8002ae:	a1 20 40 80 00       	mov    0x804020,%eax
  8002b3:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002b9:	51                   	push   %ecx
  8002ba:	52                   	push   %edx
  8002bb:	50                   	push   %eax
  8002bc:	68 fc 32 80 00       	push   $0x8032fc
  8002c1:	e8 14 03 00 00       	call   8005da <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ce:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002d4:	83 ec 08             	sub    $0x8,%esp
  8002d7:	50                   	push   %eax
  8002d8:	68 54 33 80 00       	push   $0x803354
  8002dd:	e8 f8 02 00 00       	call   8005da <cprintf>
  8002e2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 ac 32 80 00       	push   $0x8032ac
  8002ed:	e8 e8 02 00 00       	call   8005da <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002f5:	e8 85 17 00 00       	call   801a7f <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002fa:	e8 19 00 00 00       	call   800318 <exit>
}
  8002ff:	90                   	nop
  800300:	c9                   	leave  
  800301:	c3                   	ret    

00800302 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	6a 00                	push   $0x0
  80030d:	e8 12 19 00 00       	call   801c24 <sys_destroy_env>
  800312:	83 c4 10             	add    $0x10,%esp
}
  800315:	90                   	nop
  800316:	c9                   	leave  
  800317:	c3                   	ret    

00800318 <exit>:

void
exit(void)
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80031e:	e8 67 19 00 00       	call   801c8a <sys_exit_env>
}
  800323:	90                   	nop
  800324:	c9                   	leave  
  800325:	c3                   	ret    

00800326 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800326:	55                   	push   %ebp
  800327:	89 e5                	mov    %esp,%ebp
  800329:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80032c:	8d 45 10             	lea    0x10(%ebp),%eax
  80032f:	83 c0 04             	add    $0x4,%eax
  800332:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800335:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80033a:	85 c0                	test   %eax,%eax
  80033c:	74 16                	je     800354 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80033e:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800343:	83 ec 08             	sub    $0x8,%esp
  800346:	50                   	push   %eax
  800347:	68 68 33 80 00       	push   $0x803368
  80034c:	e8 89 02 00 00       	call   8005da <cprintf>
  800351:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800354:	a1 00 40 80 00       	mov    0x804000,%eax
  800359:	ff 75 0c             	pushl  0xc(%ebp)
  80035c:	ff 75 08             	pushl  0x8(%ebp)
  80035f:	50                   	push   %eax
  800360:	68 6d 33 80 00       	push   $0x80336d
  800365:	e8 70 02 00 00       	call   8005da <cprintf>
  80036a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80036d:	8b 45 10             	mov    0x10(%ebp),%eax
  800370:	83 ec 08             	sub    $0x8,%esp
  800373:	ff 75 f4             	pushl  -0xc(%ebp)
  800376:	50                   	push   %eax
  800377:	e8 f3 01 00 00       	call   80056f <vcprintf>
  80037c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	6a 00                	push   $0x0
  800384:	68 89 33 80 00       	push   $0x803389
  800389:	e8 e1 01 00 00       	call   80056f <vcprintf>
  80038e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800391:	e8 82 ff ff ff       	call   800318 <exit>

	// should not return here
	while (1) ;
  800396:	eb fe                	jmp    800396 <_panic+0x70>

00800398 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800398:	55                   	push   %ebp
  800399:	89 e5                	mov    %esp,%ebp
  80039b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80039e:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a3:	8b 50 74             	mov    0x74(%eax),%edx
  8003a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a9:	39 c2                	cmp    %eax,%edx
  8003ab:	74 14                	je     8003c1 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003ad:	83 ec 04             	sub    $0x4,%esp
  8003b0:	68 8c 33 80 00       	push   $0x80338c
  8003b5:	6a 26                	push   $0x26
  8003b7:	68 d8 33 80 00       	push   $0x8033d8
  8003bc:	e8 65 ff ff ff       	call   800326 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003cf:	e9 c2 00 00 00       	jmp    800496 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003de:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e1:	01 d0                	add    %edx,%eax
  8003e3:	8b 00                	mov    (%eax),%eax
  8003e5:	85 c0                	test   %eax,%eax
  8003e7:	75 08                	jne    8003f1 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003e9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003ec:	e9 a2 00 00 00       	jmp    800493 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003ff:	eb 69                	jmp    80046a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800401:	a1 20 40 80 00       	mov    0x804020,%eax
  800406:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80040c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80040f:	89 d0                	mov    %edx,%eax
  800411:	01 c0                	add    %eax,%eax
  800413:	01 d0                	add    %edx,%eax
  800415:	c1 e0 03             	shl    $0x3,%eax
  800418:	01 c8                	add    %ecx,%eax
  80041a:	8a 40 04             	mov    0x4(%eax),%al
  80041d:	84 c0                	test   %al,%al
  80041f:	75 46                	jne    800467 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800421:	a1 20 40 80 00       	mov    0x804020,%eax
  800426:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80042c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80042f:	89 d0                	mov    %edx,%eax
  800431:	01 c0                	add    %eax,%eax
  800433:	01 d0                	add    %edx,%eax
  800435:	c1 e0 03             	shl    $0x3,%eax
  800438:	01 c8                	add    %ecx,%eax
  80043a:	8b 00                	mov    (%eax),%eax
  80043c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80043f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800442:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800447:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800449:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80044c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	01 c8                	add    %ecx,%eax
  800458:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80045a:	39 c2                	cmp    %eax,%edx
  80045c:	75 09                	jne    800467 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80045e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800465:	eb 12                	jmp    800479 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800467:	ff 45 e8             	incl   -0x18(%ebp)
  80046a:	a1 20 40 80 00       	mov    0x804020,%eax
  80046f:	8b 50 74             	mov    0x74(%eax),%edx
  800472:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800475:	39 c2                	cmp    %eax,%edx
  800477:	77 88                	ja     800401 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800479:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80047d:	75 14                	jne    800493 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80047f:	83 ec 04             	sub    $0x4,%esp
  800482:	68 e4 33 80 00       	push   $0x8033e4
  800487:	6a 3a                	push   $0x3a
  800489:	68 d8 33 80 00       	push   $0x8033d8
  80048e:	e8 93 fe ff ff       	call   800326 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800493:	ff 45 f0             	incl   -0x10(%ebp)
  800496:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800499:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80049c:	0f 8c 32 ff ff ff    	jl     8003d4 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004a2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004a9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004b0:	eb 26                	jmp    8004d8 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004b2:	a1 20 40 80 00       	mov    0x804020,%eax
  8004b7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c0:	89 d0                	mov    %edx,%eax
  8004c2:	01 c0                	add    %eax,%eax
  8004c4:	01 d0                	add    %edx,%eax
  8004c6:	c1 e0 03             	shl    $0x3,%eax
  8004c9:	01 c8                	add    %ecx,%eax
  8004cb:	8a 40 04             	mov    0x4(%eax),%al
  8004ce:	3c 01                	cmp    $0x1,%al
  8004d0:	75 03                	jne    8004d5 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004d2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d5:	ff 45 e0             	incl   -0x20(%ebp)
  8004d8:	a1 20 40 80 00       	mov    0x804020,%eax
  8004dd:	8b 50 74             	mov    0x74(%eax),%edx
  8004e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e3:	39 c2                	cmp    %eax,%edx
  8004e5:	77 cb                	ja     8004b2 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ea:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004ed:	74 14                	je     800503 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004ef:	83 ec 04             	sub    $0x4,%esp
  8004f2:	68 38 34 80 00       	push   $0x803438
  8004f7:	6a 44                	push   $0x44
  8004f9:	68 d8 33 80 00       	push   $0x8033d8
  8004fe:	e8 23 fe ff ff       	call   800326 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800503:	90                   	nop
  800504:	c9                   	leave  
  800505:	c3                   	ret    

00800506 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800506:	55                   	push   %ebp
  800507:	89 e5                	mov    %esp,%ebp
  800509:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80050c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	8d 48 01             	lea    0x1(%eax),%ecx
  800514:	8b 55 0c             	mov    0xc(%ebp),%edx
  800517:	89 0a                	mov    %ecx,(%edx)
  800519:	8b 55 08             	mov    0x8(%ebp),%edx
  80051c:	88 d1                	mov    %dl,%cl
  80051e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800521:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800525:	8b 45 0c             	mov    0xc(%ebp),%eax
  800528:	8b 00                	mov    (%eax),%eax
  80052a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80052f:	75 2c                	jne    80055d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800531:	a0 24 40 80 00       	mov    0x804024,%al
  800536:	0f b6 c0             	movzbl %al,%eax
  800539:	8b 55 0c             	mov    0xc(%ebp),%edx
  80053c:	8b 12                	mov    (%edx),%edx
  80053e:	89 d1                	mov    %edx,%ecx
  800540:	8b 55 0c             	mov    0xc(%ebp),%edx
  800543:	83 c2 08             	add    $0x8,%edx
  800546:	83 ec 04             	sub    $0x4,%esp
  800549:	50                   	push   %eax
  80054a:	51                   	push   %ecx
  80054b:	52                   	push   %edx
  80054c:	e8 66 13 00 00       	call   8018b7 <sys_cputs>
  800551:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800554:	8b 45 0c             	mov    0xc(%ebp),%eax
  800557:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80055d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800560:	8b 40 04             	mov    0x4(%eax),%eax
  800563:	8d 50 01             	lea    0x1(%eax),%edx
  800566:	8b 45 0c             	mov    0xc(%ebp),%eax
  800569:	89 50 04             	mov    %edx,0x4(%eax)
}
  80056c:	90                   	nop
  80056d:	c9                   	leave  
  80056e:	c3                   	ret    

0080056f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80056f:	55                   	push   %ebp
  800570:	89 e5                	mov    %esp,%ebp
  800572:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800578:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80057f:	00 00 00 
	b.cnt = 0;
  800582:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800589:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80058c:	ff 75 0c             	pushl  0xc(%ebp)
  80058f:	ff 75 08             	pushl  0x8(%ebp)
  800592:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800598:	50                   	push   %eax
  800599:	68 06 05 80 00       	push   $0x800506
  80059e:	e8 11 02 00 00       	call   8007b4 <vprintfmt>
  8005a3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005a6:	a0 24 40 80 00       	mov    0x804024,%al
  8005ab:	0f b6 c0             	movzbl %al,%eax
  8005ae:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005b4:	83 ec 04             	sub    $0x4,%esp
  8005b7:	50                   	push   %eax
  8005b8:	52                   	push   %edx
  8005b9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005bf:	83 c0 08             	add    $0x8,%eax
  8005c2:	50                   	push   %eax
  8005c3:	e8 ef 12 00 00       	call   8018b7 <sys_cputs>
  8005c8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005cb:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8005d2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005d8:	c9                   	leave  
  8005d9:	c3                   	ret    

008005da <cprintf>:

int cprintf(const char *fmt, ...) {
  8005da:	55                   	push   %ebp
  8005db:	89 e5                	mov    %esp,%ebp
  8005dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005e0:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8005e7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f6:	50                   	push   %eax
  8005f7:	e8 73 ff ff ff       	call   80056f <vcprintf>
  8005fc:	83 c4 10             	add    $0x10,%esp
  8005ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800602:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800605:	c9                   	leave  
  800606:	c3                   	ret    

00800607 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800607:	55                   	push   %ebp
  800608:	89 e5                	mov    %esp,%ebp
  80060a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80060d:	e8 53 14 00 00       	call   801a65 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800612:	8d 45 0c             	lea    0xc(%ebp),%eax
  800615:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800618:	8b 45 08             	mov    0x8(%ebp),%eax
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	ff 75 f4             	pushl  -0xc(%ebp)
  800621:	50                   	push   %eax
  800622:	e8 48 ff ff ff       	call   80056f <vcprintf>
  800627:	83 c4 10             	add    $0x10,%esp
  80062a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80062d:	e8 4d 14 00 00       	call   801a7f <sys_enable_interrupt>
	return cnt;
  800632:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800635:	c9                   	leave  
  800636:	c3                   	ret    

00800637 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800637:	55                   	push   %ebp
  800638:	89 e5                	mov    %esp,%ebp
  80063a:	53                   	push   %ebx
  80063b:	83 ec 14             	sub    $0x14,%esp
  80063e:	8b 45 10             	mov    0x10(%ebp),%eax
  800641:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80064a:	8b 45 18             	mov    0x18(%ebp),%eax
  80064d:	ba 00 00 00 00       	mov    $0x0,%edx
  800652:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800655:	77 55                	ja     8006ac <printnum+0x75>
  800657:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80065a:	72 05                	jb     800661 <printnum+0x2a>
  80065c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80065f:	77 4b                	ja     8006ac <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800661:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800664:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800667:	8b 45 18             	mov    0x18(%ebp),%eax
  80066a:	ba 00 00 00 00       	mov    $0x0,%edx
  80066f:	52                   	push   %edx
  800670:	50                   	push   %eax
  800671:	ff 75 f4             	pushl  -0xc(%ebp)
  800674:	ff 75 f0             	pushl  -0x10(%ebp)
  800677:	e8 38 29 00 00       	call   802fb4 <__udivdi3>
  80067c:	83 c4 10             	add    $0x10,%esp
  80067f:	83 ec 04             	sub    $0x4,%esp
  800682:	ff 75 20             	pushl  0x20(%ebp)
  800685:	53                   	push   %ebx
  800686:	ff 75 18             	pushl  0x18(%ebp)
  800689:	52                   	push   %edx
  80068a:	50                   	push   %eax
  80068b:	ff 75 0c             	pushl  0xc(%ebp)
  80068e:	ff 75 08             	pushl  0x8(%ebp)
  800691:	e8 a1 ff ff ff       	call   800637 <printnum>
  800696:	83 c4 20             	add    $0x20,%esp
  800699:	eb 1a                	jmp    8006b5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80069b:	83 ec 08             	sub    $0x8,%esp
  80069e:	ff 75 0c             	pushl  0xc(%ebp)
  8006a1:	ff 75 20             	pushl  0x20(%ebp)
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	ff d0                	call   *%eax
  8006a9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006ac:	ff 4d 1c             	decl   0x1c(%ebp)
  8006af:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006b3:	7f e6                	jg     80069b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006b5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c3:	53                   	push   %ebx
  8006c4:	51                   	push   %ecx
  8006c5:	52                   	push   %edx
  8006c6:	50                   	push   %eax
  8006c7:	e8 f8 29 00 00       	call   8030c4 <__umoddi3>
  8006cc:	83 c4 10             	add    $0x10,%esp
  8006cf:	05 b4 36 80 00       	add    $0x8036b4,%eax
  8006d4:	8a 00                	mov    (%eax),%al
  8006d6:	0f be c0             	movsbl %al,%eax
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	ff 75 0c             	pushl  0xc(%ebp)
  8006df:	50                   	push   %eax
  8006e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e3:	ff d0                	call   *%eax
  8006e5:	83 c4 10             	add    $0x10,%esp
}
  8006e8:	90                   	nop
  8006e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ec:	c9                   	leave  
  8006ed:	c3                   	ret    

008006ee <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006ee:	55                   	push   %ebp
  8006ef:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006f1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006f5:	7e 1c                	jle    800713 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	8d 50 08             	lea    0x8(%eax),%edx
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	89 10                	mov    %edx,(%eax)
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	83 e8 08             	sub    $0x8,%eax
  80070c:	8b 50 04             	mov    0x4(%eax),%edx
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	eb 40                	jmp    800753 <getuint+0x65>
	else if (lflag)
  800713:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800717:	74 1e                	je     800737 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	8d 50 04             	lea    0x4(%eax),%edx
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	89 10                	mov    %edx,(%eax)
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	83 e8 04             	sub    $0x4,%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	ba 00 00 00 00       	mov    $0x0,%edx
  800735:	eb 1c                	jmp    800753 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	8d 50 04             	lea    0x4(%eax),%edx
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	89 10                	mov    %edx,(%eax)
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	8b 00                	mov    (%eax),%eax
  800749:	83 e8 04             	sub    $0x4,%eax
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800753:	5d                   	pop    %ebp
  800754:	c3                   	ret    

00800755 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800755:	55                   	push   %ebp
  800756:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800758:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80075c:	7e 1c                	jle    80077a <getint+0x25>
		return va_arg(*ap, long long);
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	8b 00                	mov    (%eax),%eax
  800763:	8d 50 08             	lea    0x8(%eax),%edx
  800766:	8b 45 08             	mov    0x8(%ebp),%eax
  800769:	89 10                	mov    %edx,(%eax)
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	83 e8 08             	sub    $0x8,%eax
  800773:	8b 50 04             	mov    0x4(%eax),%edx
  800776:	8b 00                	mov    (%eax),%eax
  800778:	eb 38                	jmp    8007b2 <getint+0x5d>
	else if (lflag)
  80077a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80077e:	74 1a                	je     80079a <getint+0x45>
		return va_arg(*ap, long);
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	8b 00                	mov    (%eax),%eax
  800785:	8d 50 04             	lea    0x4(%eax),%edx
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	89 10                	mov    %edx,(%eax)
  80078d:	8b 45 08             	mov    0x8(%ebp),%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	83 e8 04             	sub    $0x4,%eax
  800795:	8b 00                	mov    (%eax),%eax
  800797:	99                   	cltd   
  800798:	eb 18                	jmp    8007b2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	8b 00                	mov    (%eax),%eax
  80079f:	8d 50 04             	lea    0x4(%eax),%edx
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	89 10                	mov    %edx,(%eax)
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	83 e8 04             	sub    $0x4,%eax
  8007af:	8b 00                	mov    (%eax),%eax
  8007b1:	99                   	cltd   
}
  8007b2:	5d                   	pop    %ebp
  8007b3:	c3                   	ret    

008007b4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007b4:	55                   	push   %ebp
  8007b5:	89 e5                	mov    %esp,%ebp
  8007b7:	56                   	push   %esi
  8007b8:	53                   	push   %ebx
  8007b9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007bc:	eb 17                	jmp    8007d5 <vprintfmt+0x21>
			if (ch == '\0')
  8007be:	85 db                	test   %ebx,%ebx
  8007c0:	0f 84 af 03 00 00    	je     800b75 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	ff 75 0c             	pushl  0xc(%ebp)
  8007cc:	53                   	push   %ebx
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	ff d0                	call   *%eax
  8007d2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d8:	8d 50 01             	lea    0x1(%eax),%edx
  8007db:	89 55 10             	mov    %edx,0x10(%ebp)
  8007de:	8a 00                	mov    (%eax),%al
  8007e0:	0f b6 d8             	movzbl %al,%ebx
  8007e3:	83 fb 25             	cmp    $0x25,%ebx
  8007e6:	75 d6                	jne    8007be <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007e8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007ec:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007f3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007fa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800801:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800808:	8b 45 10             	mov    0x10(%ebp),%eax
  80080b:	8d 50 01             	lea    0x1(%eax),%edx
  80080e:	89 55 10             	mov    %edx,0x10(%ebp)
  800811:	8a 00                	mov    (%eax),%al
  800813:	0f b6 d8             	movzbl %al,%ebx
  800816:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800819:	83 f8 55             	cmp    $0x55,%eax
  80081c:	0f 87 2b 03 00 00    	ja     800b4d <vprintfmt+0x399>
  800822:	8b 04 85 d8 36 80 00 	mov    0x8036d8(,%eax,4),%eax
  800829:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80082b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80082f:	eb d7                	jmp    800808 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800831:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800835:	eb d1                	jmp    800808 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800837:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80083e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800841:	89 d0                	mov    %edx,%eax
  800843:	c1 e0 02             	shl    $0x2,%eax
  800846:	01 d0                	add    %edx,%eax
  800848:	01 c0                	add    %eax,%eax
  80084a:	01 d8                	add    %ebx,%eax
  80084c:	83 e8 30             	sub    $0x30,%eax
  80084f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800852:	8b 45 10             	mov    0x10(%ebp),%eax
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80085a:	83 fb 2f             	cmp    $0x2f,%ebx
  80085d:	7e 3e                	jle    80089d <vprintfmt+0xe9>
  80085f:	83 fb 39             	cmp    $0x39,%ebx
  800862:	7f 39                	jg     80089d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800864:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800867:	eb d5                	jmp    80083e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800869:	8b 45 14             	mov    0x14(%ebp),%eax
  80086c:	83 c0 04             	add    $0x4,%eax
  80086f:	89 45 14             	mov    %eax,0x14(%ebp)
  800872:	8b 45 14             	mov    0x14(%ebp),%eax
  800875:	83 e8 04             	sub    $0x4,%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80087d:	eb 1f                	jmp    80089e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80087f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800883:	79 83                	jns    800808 <vprintfmt+0x54>
				width = 0;
  800885:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80088c:	e9 77 ff ff ff       	jmp    800808 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800891:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800898:	e9 6b ff ff ff       	jmp    800808 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80089d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80089e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a2:	0f 89 60 ff ff ff    	jns    800808 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008b5:	e9 4e ff ff ff       	jmp    800808 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008ba:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008bd:	e9 46 ff ff ff       	jmp    800808 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c5:	83 c0 04             	add    $0x4,%eax
  8008c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ce:	83 e8 04             	sub    $0x4,%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	ff 75 0c             	pushl  0xc(%ebp)
  8008d9:	50                   	push   %eax
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	ff d0                	call   *%eax
  8008df:	83 c4 10             	add    $0x10,%esp
			break;
  8008e2:	e9 89 02 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ea:	83 c0 04             	add    $0x4,%eax
  8008ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f3:	83 e8 04             	sub    $0x4,%eax
  8008f6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008f8:	85 db                	test   %ebx,%ebx
  8008fa:	79 02                	jns    8008fe <vprintfmt+0x14a>
				err = -err;
  8008fc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008fe:	83 fb 64             	cmp    $0x64,%ebx
  800901:	7f 0b                	jg     80090e <vprintfmt+0x15a>
  800903:	8b 34 9d 20 35 80 00 	mov    0x803520(,%ebx,4),%esi
  80090a:	85 f6                	test   %esi,%esi
  80090c:	75 19                	jne    800927 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80090e:	53                   	push   %ebx
  80090f:	68 c5 36 80 00       	push   $0x8036c5
  800914:	ff 75 0c             	pushl  0xc(%ebp)
  800917:	ff 75 08             	pushl  0x8(%ebp)
  80091a:	e8 5e 02 00 00       	call   800b7d <printfmt>
  80091f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800922:	e9 49 02 00 00       	jmp    800b70 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800927:	56                   	push   %esi
  800928:	68 ce 36 80 00       	push   $0x8036ce
  80092d:	ff 75 0c             	pushl  0xc(%ebp)
  800930:	ff 75 08             	pushl  0x8(%ebp)
  800933:	e8 45 02 00 00       	call   800b7d <printfmt>
  800938:	83 c4 10             	add    $0x10,%esp
			break;
  80093b:	e9 30 02 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800940:	8b 45 14             	mov    0x14(%ebp),%eax
  800943:	83 c0 04             	add    $0x4,%eax
  800946:	89 45 14             	mov    %eax,0x14(%ebp)
  800949:	8b 45 14             	mov    0x14(%ebp),%eax
  80094c:	83 e8 04             	sub    $0x4,%eax
  80094f:	8b 30                	mov    (%eax),%esi
  800951:	85 f6                	test   %esi,%esi
  800953:	75 05                	jne    80095a <vprintfmt+0x1a6>
				p = "(null)";
  800955:	be d1 36 80 00       	mov    $0x8036d1,%esi
			if (width > 0 && padc != '-')
  80095a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095e:	7e 6d                	jle    8009cd <vprintfmt+0x219>
  800960:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800964:	74 67                	je     8009cd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800966:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800969:	83 ec 08             	sub    $0x8,%esp
  80096c:	50                   	push   %eax
  80096d:	56                   	push   %esi
  80096e:	e8 0c 03 00 00       	call   800c7f <strnlen>
  800973:	83 c4 10             	add    $0x10,%esp
  800976:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800979:	eb 16                	jmp    800991 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80097b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80097f:	83 ec 08             	sub    $0x8,%esp
  800982:	ff 75 0c             	pushl  0xc(%ebp)
  800985:	50                   	push   %eax
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	ff d0                	call   *%eax
  80098b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80098e:	ff 4d e4             	decl   -0x1c(%ebp)
  800991:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800995:	7f e4                	jg     80097b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800997:	eb 34                	jmp    8009cd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800999:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80099d:	74 1c                	je     8009bb <vprintfmt+0x207>
  80099f:	83 fb 1f             	cmp    $0x1f,%ebx
  8009a2:	7e 05                	jle    8009a9 <vprintfmt+0x1f5>
  8009a4:	83 fb 7e             	cmp    $0x7e,%ebx
  8009a7:	7e 12                	jle    8009bb <vprintfmt+0x207>
					putch('?', putdat);
  8009a9:	83 ec 08             	sub    $0x8,%esp
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	6a 3f                	push   $0x3f
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	ff d0                	call   *%eax
  8009b6:	83 c4 10             	add    $0x10,%esp
  8009b9:	eb 0f                	jmp    8009ca <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	ff 75 0c             	pushl  0xc(%ebp)
  8009c1:	53                   	push   %ebx
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	ff d0                	call   *%eax
  8009c7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ca:	ff 4d e4             	decl   -0x1c(%ebp)
  8009cd:	89 f0                	mov    %esi,%eax
  8009cf:	8d 70 01             	lea    0x1(%eax),%esi
  8009d2:	8a 00                	mov    (%eax),%al
  8009d4:	0f be d8             	movsbl %al,%ebx
  8009d7:	85 db                	test   %ebx,%ebx
  8009d9:	74 24                	je     8009ff <vprintfmt+0x24b>
  8009db:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009df:	78 b8                	js     800999 <vprintfmt+0x1e5>
  8009e1:	ff 4d e0             	decl   -0x20(%ebp)
  8009e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009e8:	79 af                	jns    800999 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ea:	eb 13                	jmp    8009ff <vprintfmt+0x24b>
				putch(' ', putdat);
  8009ec:	83 ec 08             	sub    $0x8,%esp
  8009ef:	ff 75 0c             	pushl  0xc(%ebp)
  8009f2:	6a 20                	push   $0x20
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	ff d0                	call   *%eax
  8009f9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009fc:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a03:	7f e7                	jg     8009ec <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a05:	e9 66 01 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a0a:	83 ec 08             	sub    $0x8,%esp
  800a0d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a10:	8d 45 14             	lea    0x14(%ebp),%eax
  800a13:	50                   	push   %eax
  800a14:	e8 3c fd ff ff       	call   800755 <getint>
  800a19:	83 c4 10             	add    $0x10,%esp
  800a1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a28:	85 d2                	test   %edx,%edx
  800a2a:	79 23                	jns    800a4f <vprintfmt+0x29b>
				putch('-', putdat);
  800a2c:	83 ec 08             	sub    $0x8,%esp
  800a2f:	ff 75 0c             	pushl  0xc(%ebp)
  800a32:	6a 2d                	push   $0x2d
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	ff d0                	call   *%eax
  800a39:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a42:	f7 d8                	neg    %eax
  800a44:	83 d2 00             	adc    $0x0,%edx
  800a47:	f7 da                	neg    %edx
  800a49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a4f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a56:	e9 bc 00 00 00       	jmp    800b17 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800a61:	8d 45 14             	lea    0x14(%ebp),%eax
  800a64:	50                   	push   %eax
  800a65:	e8 84 fc ff ff       	call   8006ee <getuint>
  800a6a:	83 c4 10             	add    $0x10,%esp
  800a6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a73:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a7a:	e9 98 00 00 00       	jmp    800b17 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a7f:	83 ec 08             	sub    $0x8,%esp
  800a82:	ff 75 0c             	pushl  0xc(%ebp)
  800a85:	6a 58                	push   $0x58
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	ff d0                	call   *%eax
  800a8c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a8f:	83 ec 08             	sub    $0x8,%esp
  800a92:	ff 75 0c             	pushl  0xc(%ebp)
  800a95:	6a 58                	push   $0x58
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	ff d0                	call   *%eax
  800a9c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 0c             	pushl  0xc(%ebp)
  800aa5:	6a 58                	push   $0x58
  800aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaa:	ff d0                	call   *%eax
  800aac:	83 c4 10             	add    $0x10,%esp
			break;
  800aaf:	e9 bc 00 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ab4:	83 ec 08             	sub    $0x8,%esp
  800ab7:	ff 75 0c             	pushl  0xc(%ebp)
  800aba:	6a 30                	push   $0x30
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	ff d0                	call   *%eax
  800ac1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ac4:	83 ec 08             	sub    $0x8,%esp
  800ac7:	ff 75 0c             	pushl  0xc(%ebp)
  800aca:	6a 78                	push   $0x78
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	ff d0                	call   *%eax
  800ad1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ad4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad7:	83 c0 04             	add    $0x4,%eax
  800ada:	89 45 14             	mov    %eax,0x14(%ebp)
  800add:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae0:	83 e8 04             	sub    $0x4,%eax
  800ae3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800aef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800af6:	eb 1f                	jmp    800b17 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 e8             	pushl  -0x18(%ebp)
  800afe:	8d 45 14             	lea    0x14(%ebp),%eax
  800b01:	50                   	push   %eax
  800b02:	e8 e7 fb ff ff       	call   8006ee <getuint>
  800b07:	83 c4 10             	add    $0x10,%esp
  800b0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b10:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b17:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b1e:	83 ec 04             	sub    $0x4,%esp
  800b21:	52                   	push   %edx
  800b22:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b25:	50                   	push   %eax
  800b26:	ff 75 f4             	pushl  -0xc(%ebp)
  800b29:	ff 75 f0             	pushl  -0x10(%ebp)
  800b2c:	ff 75 0c             	pushl  0xc(%ebp)
  800b2f:	ff 75 08             	pushl  0x8(%ebp)
  800b32:	e8 00 fb ff ff       	call   800637 <printnum>
  800b37:	83 c4 20             	add    $0x20,%esp
			break;
  800b3a:	eb 34                	jmp    800b70 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	53                   	push   %ebx
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
			break;
  800b4b:	eb 23                	jmp    800b70 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b4d:	83 ec 08             	sub    $0x8,%esp
  800b50:	ff 75 0c             	pushl  0xc(%ebp)
  800b53:	6a 25                	push   $0x25
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	ff d0                	call   *%eax
  800b5a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b5d:	ff 4d 10             	decl   0x10(%ebp)
  800b60:	eb 03                	jmp    800b65 <vprintfmt+0x3b1>
  800b62:	ff 4d 10             	decl   0x10(%ebp)
  800b65:	8b 45 10             	mov    0x10(%ebp),%eax
  800b68:	48                   	dec    %eax
  800b69:	8a 00                	mov    (%eax),%al
  800b6b:	3c 25                	cmp    $0x25,%al
  800b6d:	75 f3                	jne    800b62 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b6f:	90                   	nop
		}
	}
  800b70:	e9 47 fc ff ff       	jmp    8007bc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b75:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b79:	5b                   	pop    %ebx
  800b7a:	5e                   	pop    %esi
  800b7b:	5d                   	pop    %ebp
  800b7c:	c3                   	ret    

00800b7d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b83:	8d 45 10             	lea    0x10(%ebp),%eax
  800b86:	83 c0 04             	add    $0x4,%eax
  800b89:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b92:	50                   	push   %eax
  800b93:	ff 75 0c             	pushl  0xc(%ebp)
  800b96:	ff 75 08             	pushl  0x8(%ebp)
  800b99:	e8 16 fc ff ff       	call   8007b4 <vprintfmt>
  800b9e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ba1:	90                   	nop
  800ba2:	c9                   	leave  
  800ba3:	c3                   	ret    

00800ba4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800baa:	8b 40 08             	mov    0x8(%eax),%eax
  800bad:	8d 50 01             	lea    0x1(%eax),%edx
  800bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb9:	8b 10                	mov    (%eax),%edx
  800bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbe:	8b 40 04             	mov    0x4(%eax),%eax
  800bc1:	39 c2                	cmp    %eax,%edx
  800bc3:	73 12                	jae    800bd7 <sprintputch+0x33>
		*b->buf++ = ch;
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	8b 00                	mov    (%eax),%eax
  800bca:	8d 48 01             	lea    0x1(%eax),%ecx
  800bcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd0:	89 0a                	mov    %ecx,(%edx)
  800bd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd5:	88 10                	mov    %dl,(%eax)
}
  800bd7:	90                   	nop
  800bd8:	5d                   	pop    %ebp
  800bd9:	c3                   	ret    

00800bda <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800be6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	01 d0                	add    %edx,%eax
  800bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bfb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bff:	74 06                	je     800c07 <vsnprintf+0x2d>
  800c01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c05:	7f 07                	jg     800c0e <vsnprintf+0x34>
		return -E_INVAL;
  800c07:	b8 03 00 00 00       	mov    $0x3,%eax
  800c0c:	eb 20                	jmp    800c2e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c0e:	ff 75 14             	pushl  0x14(%ebp)
  800c11:	ff 75 10             	pushl  0x10(%ebp)
  800c14:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c17:	50                   	push   %eax
  800c18:	68 a4 0b 80 00       	push   $0x800ba4
  800c1d:	e8 92 fb ff ff       	call   8007b4 <vprintfmt>
  800c22:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c28:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c2e:	c9                   	leave  
  800c2f:	c3                   	ret    

00800c30 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c36:	8d 45 10             	lea    0x10(%ebp),%eax
  800c39:	83 c0 04             	add    $0x4,%eax
  800c3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c42:	ff 75 f4             	pushl  -0xc(%ebp)
  800c45:	50                   	push   %eax
  800c46:	ff 75 0c             	pushl  0xc(%ebp)
  800c49:	ff 75 08             	pushl  0x8(%ebp)
  800c4c:	e8 89 ff ff ff       	call   800bda <vsnprintf>
  800c51:	83 c4 10             	add    $0x10,%esp
  800c54:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c5a:	c9                   	leave  
  800c5b:	c3                   	ret    

00800c5c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c69:	eb 06                	jmp    800c71 <strlen+0x15>
		n++;
  800c6b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c6e:	ff 45 08             	incl   0x8(%ebp)
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	8a 00                	mov    (%eax),%al
  800c76:	84 c0                	test   %al,%al
  800c78:	75 f1                	jne    800c6b <strlen+0xf>
		n++;
	return n;
  800c7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c7d:	c9                   	leave  
  800c7e:	c3                   	ret    

00800c7f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c8c:	eb 09                	jmp    800c97 <strnlen+0x18>
		n++;
  800c8e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c91:	ff 45 08             	incl   0x8(%ebp)
  800c94:	ff 4d 0c             	decl   0xc(%ebp)
  800c97:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c9b:	74 09                	je     800ca6 <strnlen+0x27>
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	8a 00                	mov    (%eax),%al
  800ca2:	84 c0                	test   %al,%al
  800ca4:	75 e8                	jne    800c8e <strnlen+0xf>
		n++;
	return n;
  800ca6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ca9:	c9                   	leave  
  800caa:	c3                   	ret    

00800cab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cb7:	90                   	nop
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8d 50 01             	lea    0x1(%eax),%edx
  800cbe:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cca:	8a 12                	mov    (%edx),%dl
  800ccc:	88 10                	mov    %dl,(%eax)
  800cce:	8a 00                	mov    (%eax),%al
  800cd0:	84 c0                	test   %al,%al
  800cd2:	75 e4                	jne    800cb8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd7:	c9                   	leave  
  800cd8:	c3                   	ret    

00800cd9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ce5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cec:	eb 1f                	jmp    800d0d <strncpy+0x34>
		*dst++ = *src;
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	8d 50 01             	lea    0x1(%eax),%edx
  800cf4:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfa:	8a 12                	mov    (%edx),%dl
  800cfc:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	84 c0                	test   %al,%al
  800d05:	74 03                	je     800d0a <strncpy+0x31>
			src++;
  800d07:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d0a:	ff 45 fc             	incl   -0x4(%ebp)
  800d0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d10:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d13:	72 d9                	jb     800cee <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d15:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d18:	c9                   	leave  
  800d19:	c3                   	ret    

00800d1a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2a:	74 30                	je     800d5c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d2c:	eb 16                	jmp    800d44 <strlcpy+0x2a>
			*dst++ = *src++;
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	8d 50 01             	lea    0x1(%eax),%edx
  800d34:	89 55 08             	mov    %edx,0x8(%ebp)
  800d37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d40:	8a 12                	mov    (%edx),%dl
  800d42:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d44:	ff 4d 10             	decl   0x10(%ebp)
  800d47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4b:	74 09                	je     800d56 <strlcpy+0x3c>
  800d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	84 c0                	test   %al,%al
  800d54:	75 d8                	jne    800d2e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d62:	29 c2                	sub    %eax,%edx
  800d64:	89 d0                	mov    %edx,%eax
}
  800d66:	c9                   	leave  
  800d67:	c3                   	ret    

00800d68 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d6b:	eb 06                	jmp    800d73 <strcmp+0xb>
		p++, q++;
  800d6d:	ff 45 08             	incl   0x8(%ebp)
  800d70:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 00                	mov    (%eax),%al
  800d78:	84 c0                	test   %al,%al
  800d7a:	74 0e                	je     800d8a <strcmp+0x22>
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	8a 10                	mov    (%eax),%dl
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	38 c2                	cmp    %al,%dl
  800d88:	74 e3                	je     800d6d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	0f b6 d0             	movzbl %al,%edx
  800d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	0f b6 c0             	movzbl %al,%eax
  800d9a:	29 c2                	sub    %eax,%edx
  800d9c:	89 d0                	mov    %edx,%eax
}
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    

00800da0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800da3:	eb 09                	jmp    800dae <strncmp+0xe>
		n--, p++, q++;
  800da5:	ff 4d 10             	decl   0x10(%ebp)
  800da8:	ff 45 08             	incl   0x8(%ebp)
  800dab:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db2:	74 17                	je     800dcb <strncmp+0x2b>
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	84 c0                	test   %al,%al
  800dbb:	74 0e                	je     800dcb <strncmp+0x2b>
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8a 10                	mov    (%eax),%dl
  800dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc5:	8a 00                	mov    (%eax),%al
  800dc7:	38 c2                	cmp    %al,%dl
  800dc9:	74 da                	je     800da5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dcf:	75 07                	jne    800dd8 <strncmp+0x38>
		return 0;
  800dd1:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd6:	eb 14                	jmp    800dec <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddb:	8a 00                	mov    (%eax),%al
  800ddd:	0f b6 d0             	movzbl %al,%edx
  800de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	0f b6 c0             	movzbl %al,%eax
  800de8:	29 c2                	sub    %eax,%edx
  800dea:	89 d0                	mov    %edx,%eax
}
  800dec:	5d                   	pop    %ebp
  800ded:	c3                   	ret    

00800dee <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	83 ec 04             	sub    $0x4,%esp
  800df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dfa:	eb 12                	jmp    800e0e <strchr+0x20>
		if (*s == c)
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e04:	75 05                	jne    800e0b <strchr+0x1d>
			return (char *) s;
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	eb 11                	jmp    800e1c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e0b:	ff 45 08             	incl   0x8(%ebp)
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	8a 00                	mov    (%eax),%al
  800e13:	84 c0                	test   %al,%al
  800e15:	75 e5                	jne    800dfc <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e1c:	c9                   	leave  
  800e1d:	c3                   	ret    

00800e1e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	83 ec 04             	sub    $0x4,%esp
  800e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e27:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e2a:	eb 0d                	jmp    800e39 <strfind+0x1b>
		if (*s == c)
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	8a 00                	mov    (%eax),%al
  800e31:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e34:	74 0e                	je     800e44 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e36:	ff 45 08             	incl   0x8(%ebp)
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	84 c0                	test   %al,%al
  800e40:	75 ea                	jne    800e2c <strfind+0xe>
  800e42:	eb 01                	jmp    800e45 <strfind+0x27>
		if (*s == c)
			break;
  800e44:	90                   	nop
	return (char *) s;
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e48:	c9                   	leave  
  800e49:	c3                   	ret    

00800e4a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
  800e4d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e56:	8b 45 10             	mov    0x10(%ebp),%eax
  800e59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e5c:	eb 0e                	jmp    800e6c <memset+0x22>
		*p++ = c;
  800e5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e61:	8d 50 01             	lea    0x1(%eax),%edx
  800e64:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e6c:	ff 4d f8             	decl   -0x8(%ebp)
  800e6f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e73:	79 e9                	jns    800e5e <memset+0x14>
		*p++ = c;

	return v;
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e78:	c9                   	leave  
  800e79:	c3                   	ret    

00800e7a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e8c:	eb 16                	jmp    800ea4 <memcpy+0x2a>
		*d++ = *s++;
  800e8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e91:	8d 50 01             	lea    0x1(%eax),%edx
  800e94:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e9d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ea0:	8a 12                	mov    (%edx),%dl
  800ea2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ea4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eaa:	89 55 10             	mov    %edx,0x10(%ebp)
  800ead:	85 c0                	test   %eax,%eax
  800eaf:	75 dd                	jne    800e8e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb4:	c9                   	leave  
  800eb5:	c3                   	ret    

00800eb6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ece:	73 50                	jae    800f20 <memmove+0x6a>
  800ed0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed6:	01 d0                	add    %edx,%eax
  800ed8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800edb:	76 43                	jbe    800f20 <memmove+0x6a>
		s += n;
  800edd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ee3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ee9:	eb 10                	jmp    800efb <memmove+0x45>
			*--d = *--s;
  800eeb:	ff 4d f8             	decl   -0x8(%ebp)
  800eee:	ff 4d fc             	decl   -0x4(%ebp)
  800ef1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef4:	8a 10                	mov    (%eax),%dl
  800ef6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800efb:	8b 45 10             	mov    0x10(%ebp),%eax
  800efe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f01:	89 55 10             	mov    %edx,0x10(%ebp)
  800f04:	85 c0                	test   %eax,%eax
  800f06:	75 e3                	jne    800eeb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f08:	eb 23                	jmp    800f2d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0d:	8d 50 01             	lea    0x1(%eax),%edx
  800f10:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f16:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f19:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f1c:	8a 12                	mov    (%edx),%dl
  800f1e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f20:	8b 45 10             	mov    0x10(%ebp),%eax
  800f23:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f26:	89 55 10             	mov    %edx,0x10(%ebp)
  800f29:	85 c0                	test   %eax,%eax
  800f2b:	75 dd                	jne    800f0a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f30:	c9                   	leave  
  800f31:	c3                   	ret    

00800f32 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f41:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f44:	eb 2a                	jmp    800f70 <memcmp+0x3e>
		if (*s1 != *s2)
  800f46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f49:	8a 10                	mov    (%eax),%dl
  800f4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	38 c2                	cmp    %al,%dl
  800f52:	74 16                	je     800f6a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	0f b6 d0             	movzbl %al,%edx
  800f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5f:	8a 00                	mov    (%eax),%al
  800f61:	0f b6 c0             	movzbl %al,%eax
  800f64:	29 c2                	sub    %eax,%edx
  800f66:	89 d0                	mov    %edx,%eax
  800f68:	eb 18                	jmp    800f82 <memcmp+0x50>
		s1++, s2++;
  800f6a:	ff 45 fc             	incl   -0x4(%ebp)
  800f6d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f70:	8b 45 10             	mov    0x10(%ebp),%eax
  800f73:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f76:	89 55 10             	mov    %edx,0x10(%ebp)
  800f79:	85 c0                	test   %eax,%eax
  800f7b:	75 c9                	jne    800f46 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    

00800f84 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f90:	01 d0                	add    %edx,%eax
  800f92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f95:	eb 15                	jmp    800fac <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	0f b6 d0             	movzbl %al,%edx
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	0f b6 c0             	movzbl %al,%eax
  800fa5:	39 c2                	cmp    %eax,%edx
  800fa7:	74 0d                	je     800fb6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fa9:	ff 45 08             	incl   0x8(%ebp)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fb2:	72 e3                	jb     800f97 <memfind+0x13>
  800fb4:	eb 01                	jmp    800fb7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fb6:	90                   	nop
	return (void *) s;
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fba:	c9                   	leave  
  800fbb:	c3                   	ret    

00800fbc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fc2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fc9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd0:	eb 03                	jmp    800fd5 <strtol+0x19>
		s++;
  800fd2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	3c 20                	cmp    $0x20,%al
  800fdc:	74 f4                	je     800fd2 <strtol+0x16>
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	3c 09                	cmp    $0x9,%al
  800fe5:	74 eb                	je     800fd2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	3c 2b                	cmp    $0x2b,%al
  800fee:	75 05                	jne    800ff5 <strtol+0x39>
		s++;
  800ff0:	ff 45 08             	incl   0x8(%ebp)
  800ff3:	eb 13                	jmp    801008 <strtol+0x4c>
	else if (*s == '-')
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	3c 2d                	cmp    $0x2d,%al
  800ffc:	75 0a                	jne    801008 <strtol+0x4c>
		s++, neg = 1;
  800ffe:	ff 45 08             	incl   0x8(%ebp)
  801001:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801008:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100c:	74 06                	je     801014 <strtol+0x58>
  80100e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801012:	75 20                	jne    801034 <strtol+0x78>
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	8a 00                	mov    (%eax),%al
  801019:	3c 30                	cmp    $0x30,%al
  80101b:	75 17                	jne    801034 <strtol+0x78>
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	40                   	inc    %eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	3c 78                	cmp    $0x78,%al
  801025:	75 0d                	jne    801034 <strtol+0x78>
		s += 2, base = 16;
  801027:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80102b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801032:	eb 28                	jmp    80105c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801034:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801038:	75 15                	jne    80104f <strtol+0x93>
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	3c 30                	cmp    $0x30,%al
  801041:	75 0c                	jne    80104f <strtol+0x93>
		s++, base = 8;
  801043:	ff 45 08             	incl   0x8(%ebp)
  801046:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80104d:	eb 0d                	jmp    80105c <strtol+0xa0>
	else if (base == 0)
  80104f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801053:	75 07                	jne    80105c <strtol+0xa0>
		base = 10;
  801055:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	3c 2f                	cmp    $0x2f,%al
  801063:	7e 19                	jle    80107e <strtol+0xc2>
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	3c 39                	cmp    $0x39,%al
  80106c:	7f 10                	jg     80107e <strtol+0xc2>
			dig = *s - '0';
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	8a 00                	mov    (%eax),%al
  801073:	0f be c0             	movsbl %al,%eax
  801076:	83 e8 30             	sub    $0x30,%eax
  801079:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80107c:	eb 42                	jmp    8010c0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 60                	cmp    $0x60,%al
  801085:	7e 19                	jle    8010a0 <strtol+0xe4>
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	3c 7a                	cmp    $0x7a,%al
  80108e:	7f 10                	jg     8010a0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	8a 00                	mov    (%eax),%al
  801095:	0f be c0             	movsbl %al,%eax
  801098:	83 e8 57             	sub    $0x57,%eax
  80109b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80109e:	eb 20                	jmp    8010c0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	8a 00                	mov    (%eax),%al
  8010a5:	3c 40                	cmp    $0x40,%al
  8010a7:	7e 39                	jle    8010e2 <strtol+0x126>
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8a 00                	mov    (%eax),%al
  8010ae:	3c 5a                	cmp    $0x5a,%al
  8010b0:	7f 30                	jg     8010e2 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	8a 00                	mov    (%eax),%al
  8010b7:	0f be c0             	movsbl %al,%eax
  8010ba:	83 e8 37             	sub    $0x37,%eax
  8010bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010c6:	7d 19                	jge    8010e1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010c8:	ff 45 08             	incl   0x8(%ebp)
  8010cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ce:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010d2:	89 c2                	mov    %eax,%edx
  8010d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d7:	01 d0                	add    %edx,%eax
  8010d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010dc:	e9 7b ff ff ff       	jmp    80105c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010e1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010e6:	74 08                	je     8010f0 <strtol+0x134>
		*endptr = (char *) s;
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ee:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f4:	74 07                	je     8010fd <strtol+0x141>
  8010f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f9:	f7 d8                	neg    %eax
  8010fb:	eb 03                	jmp    801100 <strtol+0x144>
  8010fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801100:	c9                   	leave  
  801101:	c3                   	ret    

00801102 <ltostr>:

void
ltostr(long value, char *str)
{
  801102:	55                   	push   %ebp
  801103:	89 e5                	mov    %esp,%ebp
  801105:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801108:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80110f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801116:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80111a:	79 13                	jns    80112f <ltostr+0x2d>
	{
		neg = 1;
  80111c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801123:	8b 45 0c             	mov    0xc(%ebp),%eax
  801126:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801129:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80112c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801137:	99                   	cltd   
  801138:	f7 f9                	idiv   %ecx
  80113a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80113d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801140:	8d 50 01             	lea    0x1(%eax),%edx
  801143:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801146:	89 c2                	mov    %eax,%edx
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	01 d0                	add    %edx,%eax
  80114d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801150:	83 c2 30             	add    $0x30,%edx
  801153:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801155:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801158:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80115d:	f7 e9                	imul   %ecx
  80115f:	c1 fa 02             	sar    $0x2,%edx
  801162:	89 c8                	mov    %ecx,%eax
  801164:	c1 f8 1f             	sar    $0x1f,%eax
  801167:	29 c2                	sub    %eax,%edx
  801169:	89 d0                	mov    %edx,%eax
  80116b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80116e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801171:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801176:	f7 e9                	imul   %ecx
  801178:	c1 fa 02             	sar    $0x2,%edx
  80117b:	89 c8                	mov    %ecx,%eax
  80117d:	c1 f8 1f             	sar    $0x1f,%eax
  801180:	29 c2                	sub    %eax,%edx
  801182:	89 d0                	mov    %edx,%eax
  801184:	c1 e0 02             	shl    $0x2,%eax
  801187:	01 d0                	add    %edx,%eax
  801189:	01 c0                	add    %eax,%eax
  80118b:	29 c1                	sub    %eax,%ecx
  80118d:	89 ca                	mov    %ecx,%edx
  80118f:	85 d2                	test   %edx,%edx
  801191:	75 9c                	jne    80112f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801193:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80119a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119d:	48                   	dec    %eax
  80119e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011a5:	74 3d                	je     8011e4 <ltostr+0xe2>
		start = 1 ;
  8011a7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011ae:	eb 34                	jmp    8011e4 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	01 d0                	add    %edx,%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c3:	01 c2                	add    %eax,%edx
  8011c5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cb:	01 c8                	add    %ecx,%eax
  8011cd:	8a 00                	mov    (%eax),%al
  8011cf:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d7:	01 c2                	add    %eax,%edx
  8011d9:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011dc:	88 02                	mov    %al,(%edx)
		start++ ;
  8011de:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011e1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ea:	7c c4                	jl     8011b0 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011ec:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f2:	01 d0                	add    %edx,%eax
  8011f4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011f7:	90                   	nop
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    

008011fa <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
  8011fd:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801200:	ff 75 08             	pushl  0x8(%ebp)
  801203:	e8 54 fa ff ff       	call   800c5c <strlen>
  801208:	83 c4 04             	add    $0x4,%esp
  80120b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80120e:	ff 75 0c             	pushl  0xc(%ebp)
  801211:	e8 46 fa ff ff       	call   800c5c <strlen>
  801216:	83 c4 04             	add    $0x4,%esp
  801219:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80121c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801223:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80122a:	eb 17                	jmp    801243 <strcconcat+0x49>
		final[s] = str1[s] ;
  80122c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80122f:	8b 45 10             	mov    0x10(%ebp),%eax
  801232:	01 c2                	add    %eax,%edx
  801234:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	01 c8                	add    %ecx,%eax
  80123c:	8a 00                	mov    (%eax),%al
  80123e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801240:	ff 45 fc             	incl   -0x4(%ebp)
  801243:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801246:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801249:	7c e1                	jl     80122c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80124b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801252:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801259:	eb 1f                	jmp    80127a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80125b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80125e:	8d 50 01             	lea    0x1(%eax),%edx
  801261:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801264:	89 c2                	mov    %eax,%edx
  801266:	8b 45 10             	mov    0x10(%ebp),%eax
  801269:	01 c2                	add    %eax,%edx
  80126b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80126e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801271:	01 c8                	add    %ecx,%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801277:	ff 45 f8             	incl   -0x8(%ebp)
  80127a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801280:	7c d9                	jl     80125b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801282:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801285:	8b 45 10             	mov    0x10(%ebp),%eax
  801288:	01 d0                	add    %edx,%eax
  80128a:	c6 00 00             	movb   $0x0,(%eax)
}
  80128d:	90                   	nop
  80128e:	c9                   	leave  
  80128f:	c3                   	ret    

00801290 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80129c:	8b 45 14             	mov    0x14(%ebp),%eax
  80129f:	8b 00                	mov    (%eax),%eax
  8012a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ab:	01 d0                	add    %edx,%eax
  8012ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012b3:	eb 0c                	jmp    8012c1 <strsplit+0x31>
			*string++ = 0;
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8d 50 01             	lea    0x1(%eax),%edx
  8012bb:	89 55 08             	mov    %edx,0x8(%ebp)
  8012be:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	84 c0                	test   %al,%al
  8012c8:	74 18                	je     8012e2 <strsplit+0x52>
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	0f be c0             	movsbl %al,%eax
  8012d2:	50                   	push   %eax
  8012d3:	ff 75 0c             	pushl  0xc(%ebp)
  8012d6:	e8 13 fb ff ff       	call   800dee <strchr>
  8012db:	83 c4 08             	add    $0x8,%esp
  8012de:	85 c0                	test   %eax,%eax
  8012e0:	75 d3                	jne    8012b5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	84 c0                	test   %al,%al
  8012e9:	74 5a                	je     801345 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ee:	8b 00                	mov    (%eax),%eax
  8012f0:	83 f8 0f             	cmp    $0xf,%eax
  8012f3:	75 07                	jne    8012fc <strsplit+0x6c>
		{
			return 0;
  8012f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012fa:	eb 66                	jmp    801362 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ff:	8b 00                	mov    (%eax),%eax
  801301:	8d 48 01             	lea    0x1(%eax),%ecx
  801304:	8b 55 14             	mov    0x14(%ebp),%edx
  801307:	89 0a                	mov    %ecx,(%edx)
  801309:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801310:	8b 45 10             	mov    0x10(%ebp),%eax
  801313:	01 c2                	add    %eax,%edx
  801315:	8b 45 08             	mov    0x8(%ebp),%eax
  801318:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80131a:	eb 03                	jmp    80131f <strsplit+0x8f>
			string++;
  80131c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	84 c0                	test   %al,%al
  801326:	74 8b                	je     8012b3 <strsplit+0x23>
  801328:	8b 45 08             	mov    0x8(%ebp),%eax
  80132b:	8a 00                	mov    (%eax),%al
  80132d:	0f be c0             	movsbl %al,%eax
  801330:	50                   	push   %eax
  801331:	ff 75 0c             	pushl  0xc(%ebp)
  801334:	e8 b5 fa ff ff       	call   800dee <strchr>
  801339:	83 c4 08             	add    $0x8,%esp
  80133c:	85 c0                	test   %eax,%eax
  80133e:	74 dc                	je     80131c <strsplit+0x8c>
			string++;
	}
  801340:	e9 6e ff ff ff       	jmp    8012b3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801345:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801346:	8b 45 14             	mov    0x14(%ebp),%eax
  801349:	8b 00                	mov    (%eax),%eax
  80134b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801352:	8b 45 10             	mov    0x10(%ebp),%eax
  801355:	01 d0                	add    %edx,%eax
  801357:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80135d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801362:	c9                   	leave  
  801363:	c3                   	ret    

00801364 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
  801367:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80136a:	a1 04 40 80 00       	mov    0x804004,%eax
  80136f:	85 c0                	test   %eax,%eax
  801371:	74 1f                	je     801392 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801373:	e8 1d 00 00 00       	call   801395 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801378:	83 ec 0c             	sub    $0xc,%esp
  80137b:	68 30 38 80 00       	push   $0x803830
  801380:	e8 55 f2 ff ff       	call   8005da <cprintf>
  801385:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801388:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80138f:	00 00 00 
	}
}
  801392:	90                   	nop
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  80139b:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013a2:	00 00 00 
  8013a5:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8013ac:	00 00 00 
  8013af:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8013b6:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8013b9:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8013c0:	00 00 00 
  8013c3:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8013ca:	00 00 00 
  8013cd:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8013d4:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8013d7:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8013de:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  8013e1:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8013e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013f0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013f5:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  8013fa:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801401:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801404:	a1 20 41 80 00       	mov    0x804120,%eax
  801409:	0f af c2             	imul   %edx,%eax
  80140c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  80140f:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801416:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801419:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80141c:	01 d0                	add    %edx,%eax
  80141e:	48                   	dec    %eax
  80141f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801422:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801425:	ba 00 00 00 00       	mov    $0x0,%edx
  80142a:	f7 75 e8             	divl   -0x18(%ebp)
  80142d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801430:	29 d0                	sub    %edx,%eax
  801432:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801435:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801438:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  80143f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801442:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801448:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  80144e:	83 ec 04             	sub    $0x4,%esp
  801451:	6a 06                	push   $0x6
  801453:	50                   	push   %eax
  801454:	52                   	push   %edx
  801455:	e8 a1 05 00 00       	call   8019fb <sys_allocate_chunk>
  80145a:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80145d:	a1 20 41 80 00       	mov    0x804120,%eax
  801462:	83 ec 0c             	sub    $0xc,%esp
  801465:	50                   	push   %eax
  801466:	e8 16 0c 00 00       	call   802081 <initialize_MemBlocksList>
  80146b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  80146e:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801473:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801476:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80147a:	75 14                	jne    801490 <initialize_dyn_block_system+0xfb>
  80147c:	83 ec 04             	sub    $0x4,%esp
  80147f:	68 55 38 80 00       	push   $0x803855
  801484:	6a 2d                	push   $0x2d
  801486:	68 73 38 80 00       	push   $0x803873
  80148b:	e8 96 ee ff ff       	call   800326 <_panic>
  801490:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801493:	8b 00                	mov    (%eax),%eax
  801495:	85 c0                	test   %eax,%eax
  801497:	74 10                	je     8014a9 <initialize_dyn_block_system+0x114>
  801499:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80149c:	8b 00                	mov    (%eax),%eax
  80149e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014a1:	8b 52 04             	mov    0x4(%edx),%edx
  8014a4:	89 50 04             	mov    %edx,0x4(%eax)
  8014a7:	eb 0b                	jmp    8014b4 <initialize_dyn_block_system+0x11f>
  8014a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014ac:	8b 40 04             	mov    0x4(%eax),%eax
  8014af:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8014b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014b7:	8b 40 04             	mov    0x4(%eax),%eax
  8014ba:	85 c0                	test   %eax,%eax
  8014bc:	74 0f                	je     8014cd <initialize_dyn_block_system+0x138>
  8014be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014c1:	8b 40 04             	mov    0x4(%eax),%eax
  8014c4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014c7:	8b 12                	mov    (%edx),%edx
  8014c9:	89 10                	mov    %edx,(%eax)
  8014cb:	eb 0a                	jmp    8014d7 <initialize_dyn_block_system+0x142>
  8014cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014d0:	8b 00                	mov    (%eax),%eax
  8014d2:	a3 48 41 80 00       	mov    %eax,0x804148
  8014d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014ea:	a1 54 41 80 00       	mov    0x804154,%eax
  8014ef:	48                   	dec    %eax
  8014f0:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  8014f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014f8:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  8014ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801502:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801509:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80150d:	75 14                	jne    801523 <initialize_dyn_block_system+0x18e>
  80150f:	83 ec 04             	sub    $0x4,%esp
  801512:	68 80 38 80 00       	push   $0x803880
  801517:	6a 30                	push   $0x30
  801519:	68 73 38 80 00       	push   $0x803873
  80151e:	e8 03 ee ff ff       	call   800326 <_panic>
  801523:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  801529:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80152c:	89 50 04             	mov    %edx,0x4(%eax)
  80152f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801532:	8b 40 04             	mov    0x4(%eax),%eax
  801535:	85 c0                	test   %eax,%eax
  801537:	74 0c                	je     801545 <initialize_dyn_block_system+0x1b0>
  801539:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80153e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801541:	89 10                	mov    %edx,(%eax)
  801543:	eb 08                	jmp    80154d <initialize_dyn_block_system+0x1b8>
  801545:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801548:	a3 38 41 80 00       	mov    %eax,0x804138
  80154d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801550:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801555:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801558:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80155e:	a1 44 41 80 00       	mov    0x804144,%eax
  801563:	40                   	inc    %eax
  801564:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801569:	90                   	nop
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    

0080156c <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
  80156f:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801572:	e8 ed fd ff ff       	call   801364 <InitializeUHeap>
	if (size == 0) return NULL ;
  801577:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80157b:	75 07                	jne    801584 <malloc+0x18>
  80157d:	b8 00 00 00 00       	mov    $0x0,%eax
  801582:	eb 67                	jmp    8015eb <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801584:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80158b:	8b 55 08             	mov    0x8(%ebp),%edx
  80158e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801591:	01 d0                	add    %edx,%eax
  801593:	48                   	dec    %eax
  801594:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801597:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159a:	ba 00 00 00 00       	mov    $0x0,%edx
  80159f:	f7 75 f4             	divl   -0xc(%ebp)
  8015a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a5:	29 d0                	sub    %edx,%eax
  8015a7:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015aa:	e8 1a 08 00 00       	call   801dc9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015af:	85 c0                	test   %eax,%eax
  8015b1:	74 33                	je     8015e6 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  8015b3:	83 ec 0c             	sub    $0xc,%esp
  8015b6:	ff 75 08             	pushl  0x8(%ebp)
  8015b9:	e8 0c 0e 00 00       	call   8023ca <alloc_block_FF>
  8015be:	83 c4 10             	add    $0x10,%esp
  8015c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  8015c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015c8:	74 1c                	je     8015e6 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  8015ca:	83 ec 0c             	sub    $0xc,%esp
  8015cd:	ff 75 ec             	pushl  -0x14(%ebp)
  8015d0:	e8 07 0c 00 00       	call   8021dc <insert_sorted_allocList>
  8015d5:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  8015d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015db:	8b 40 08             	mov    0x8(%eax),%eax
  8015de:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  8015e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015e4:	eb 05                	jmp    8015eb <malloc+0x7f>
		}
	}
	return NULL;
  8015e6:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8015eb:	c9                   	leave  
  8015ec:	c3                   	ret    

008015ed <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  8015f9:	83 ec 08             	sub    $0x8,%esp
  8015fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8015ff:	68 40 40 80 00       	push   $0x804040
  801604:	e8 5b 0b 00 00       	call   802164 <find_block>
  801609:	83 c4 10             	add    $0x10,%esp
  80160c:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  80160f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801612:	8b 40 0c             	mov    0xc(%eax),%eax
  801615:	83 ec 08             	sub    $0x8,%esp
  801618:	50                   	push   %eax
  801619:	ff 75 f4             	pushl  -0xc(%ebp)
  80161c:	e8 a2 03 00 00       	call   8019c3 <sys_free_user_mem>
  801621:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801624:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801628:	75 14                	jne    80163e <free+0x51>
  80162a:	83 ec 04             	sub    $0x4,%esp
  80162d:	68 55 38 80 00       	push   $0x803855
  801632:	6a 76                	push   $0x76
  801634:	68 73 38 80 00       	push   $0x803873
  801639:	e8 e8 ec ff ff       	call   800326 <_panic>
  80163e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801641:	8b 00                	mov    (%eax),%eax
  801643:	85 c0                	test   %eax,%eax
  801645:	74 10                	je     801657 <free+0x6a>
  801647:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164a:	8b 00                	mov    (%eax),%eax
  80164c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80164f:	8b 52 04             	mov    0x4(%edx),%edx
  801652:	89 50 04             	mov    %edx,0x4(%eax)
  801655:	eb 0b                	jmp    801662 <free+0x75>
  801657:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165a:	8b 40 04             	mov    0x4(%eax),%eax
  80165d:	a3 44 40 80 00       	mov    %eax,0x804044
  801662:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801665:	8b 40 04             	mov    0x4(%eax),%eax
  801668:	85 c0                	test   %eax,%eax
  80166a:	74 0f                	je     80167b <free+0x8e>
  80166c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166f:	8b 40 04             	mov    0x4(%eax),%eax
  801672:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801675:	8b 12                	mov    (%edx),%edx
  801677:	89 10                	mov    %edx,(%eax)
  801679:	eb 0a                	jmp    801685 <free+0x98>
  80167b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167e:	8b 00                	mov    (%eax),%eax
  801680:	a3 40 40 80 00       	mov    %eax,0x804040
  801685:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801688:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80168e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801691:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801698:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80169d:	48                   	dec    %eax
  80169e:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  8016a3:	83 ec 0c             	sub    $0xc,%esp
  8016a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8016a9:	e8 0b 14 00 00       	call   802ab9 <insert_sorted_with_merge_freeList>
  8016ae:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8016b1:	90                   	nop
  8016b2:	c9                   	leave  
  8016b3:	c3                   	ret    

008016b4 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
  8016b7:	83 ec 28             	sub    $0x28,%esp
  8016ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bd:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016c0:	e8 9f fc ff ff       	call   801364 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016c9:	75 0a                	jne    8016d5 <smalloc+0x21>
  8016cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d0:	e9 8d 00 00 00       	jmp    801762 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  8016d5:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e2:	01 d0                	add    %edx,%eax
  8016e4:	48                   	dec    %eax
  8016e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f0:	f7 75 f4             	divl   -0xc(%ebp)
  8016f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f6:	29 d0                	sub    %edx,%eax
  8016f8:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016fb:	e8 c9 06 00 00       	call   801dc9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801700:	85 c0                	test   %eax,%eax
  801702:	74 59                	je     80175d <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801704:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  80170b:	83 ec 0c             	sub    $0xc,%esp
  80170e:	ff 75 0c             	pushl  0xc(%ebp)
  801711:	e8 b4 0c 00 00       	call   8023ca <alloc_block_FF>
  801716:	83 c4 10             	add    $0x10,%esp
  801719:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  80171c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801720:	75 07                	jne    801729 <smalloc+0x75>
			{
				return NULL;
  801722:	b8 00 00 00 00       	mov    $0x0,%eax
  801727:	eb 39                	jmp    801762 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801729:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80172c:	8b 40 08             	mov    0x8(%eax),%eax
  80172f:	89 c2                	mov    %eax,%edx
  801731:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801735:	52                   	push   %edx
  801736:	50                   	push   %eax
  801737:	ff 75 0c             	pushl  0xc(%ebp)
  80173a:	ff 75 08             	pushl  0x8(%ebp)
  80173d:	e8 0c 04 00 00       	call   801b4e <sys_createSharedObject>
  801742:	83 c4 10             	add    $0x10,%esp
  801745:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  801748:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80174c:	78 08                	js     801756 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  80174e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801751:	8b 40 08             	mov    0x8(%eax),%eax
  801754:	eb 0c                	jmp    801762 <smalloc+0xae>
				}
				else
				{
					return NULL;
  801756:	b8 00 00 00 00       	mov    $0x0,%eax
  80175b:	eb 05                	jmp    801762 <smalloc+0xae>
				}
			}

		}
		return NULL;
  80175d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801762:	c9                   	leave  
  801763:	c3                   	ret    

00801764 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
  801767:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80176a:	e8 f5 fb ff ff       	call   801364 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80176f:	83 ec 08             	sub    $0x8,%esp
  801772:	ff 75 0c             	pushl  0xc(%ebp)
  801775:	ff 75 08             	pushl  0x8(%ebp)
  801778:	e8 fb 03 00 00       	call   801b78 <sys_getSizeOfSharedObject>
  80177d:	83 c4 10             	add    $0x10,%esp
  801780:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801783:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801787:	75 07                	jne    801790 <sget+0x2c>
	{
		return NULL;
  801789:	b8 00 00 00 00       	mov    $0x0,%eax
  80178e:	eb 64                	jmp    8017f4 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801790:	e8 34 06 00 00       	call   801dc9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801795:	85 c0                	test   %eax,%eax
  801797:	74 56                	je     8017ef <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801799:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  8017a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a3:	83 ec 0c             	sub    $0xc,%esp
  8017a6:	50                   	push   %eax
  8017a7:	e8 1e 0c 00 00       	call   8023ca <alloc_block_FF>
  8017ac:	83 c4 10             	add    $0x10,%esp
  8017af:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  8017b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017b6:	75 07                	jne    8017bf <sget+0x5b>
		{
		return NULL;
  8017b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017bd:	eb 35                	jmp    8017f4 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  8017bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c2:	8b 40 08             	mov    0x8(%eax),%eax
  8017c5:	83 ec 04             	sub    $0x4,%esp
  8017c8:	50                   	push   %eax
  8017c9:	ff 75 0c             	pushl  0xc(%ebp)
  8017cc:	ff 75 08             	pushl  0x8(%ebp)
  8017cf:	e8 c1 03 00 00       	call   801b95 <sys_getSharedObject>
  8017d4:	83 c4 10             	add    $0x10,%esp
  8017d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  8017da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017de:	78 08                	js     8017e8 <sget+0x84>
			{
				return (void*)v1->sva;
  8017e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e3:	8b 40 08             	mov    0x8(%eax),%eax
  8017e6:	eb 0c                	jmp    8017f4 <sget+0x90>
			}
			else
			{
				return NULL;
  8017e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ed:	eb 05                	jmp    8017f4 <sget+0x90>
			}
		}
	}
  return NULL;
  8017ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017fc:	e8 63 fb ff ff       	call   801364 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801801:	83 ec 04             	sub    $0x4,%esp
  801804:	68 a4 38 80 00       	push   $0x8038a4
  801809:	68 0e 01 00 00       	push   $0x10e
  80180e:	68 73 38 80 00       	push   $0x803873
  801813:	e8 0e eb ff ff       	call   800326 <_panic>

00801818 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80181e:	83 ec 04             	sub    $0x4,%esp
  801821:	68 cc 38 80 00       	push   $0x8038cc
  801826:	68 22 01 00 00       	push   $0x122
  80182b:	68 73 38 80 00       	push   $0x803873
  801830:	e8 f1 ea ff ff       	call   800326 <_panic>

00801835 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
  801838:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80183b:	83 ec 04             	sub    $0x4,%esp
  80183e:	68 f0 38 80 00       	push   $0x8038f0
  801843:	68 2d 01 00 00       	push   $0x12d
  801848:	68 73 38 80 00       	push   $0x803873
  80184d:	e8 d4 ea ff ff       	call   800326 <_panic>

00801852 <shrink>:

}
void shrink(uint32 newSize)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
  801855:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801858:	83 ec 04             	sub    $0x4,%esp
  80185b:	68 f0 38 80 00       	push   $0x8038f0
  801860:	68 32 01 00 00       	push   $0x132
  801865:	68 73 38 80 00       	push   $0x803873
  80186a:	e8 b7 ea ff ff       	call   800326 <_panic>

0080186f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801875:	83 ec 04             	sub    $0x4,%esp
  801878:	68 f0 38 80 00       	push   $0x8038f0
  80187d:	68 37 01 00 00       	push   $0x137
  801882:	68 73 38 80 00       	push   $0x803873
  801887:	e8 9a ea ff ff       	call   800326 <_panic>

0080188c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	57                   	push   %edi
  801890:	56                   	push   %esi
  801891:	53                   	push   %ebx
  801892:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801895:	8b 45 08             	mov    0x8(%ebp),%eax
  801898:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80189e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018a1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018a4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018a7:	cd 30                	int    $0x30
  8018a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018af:	83 c4 10             	add    $0x10,%esp
  8018b2:	5b                   	pop    %ebx
  8018b3:	5e                   	pop    %esi
  8018b4:	5f                   	pop    %edi
  8018b5:	5d                   	pop    %ebp
  8018b6:	c3                   	ret    

008018b7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	83 ec 04             	sub    $0x4,%esp
  8018bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018c3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	52                   	push   %edx
  8018cf:	ff 75 0c             	pushl  0xc(%ebp)
  8018d2:	50                   	push   %eax
  8018d3:	6a 00                	push   $0x0
  8018d5:	e8 b2 ff ff ff       	call   80188c <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
}
  8018dd:	90                   	nop
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 01                	push   $0x1
  8018ef:	e8 98 ff ff ff       	call   80188c <syscall>
  8018f4:	83 c4 18             	add    $0x18,%esp
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	52                   	push   %edx
  801909:	50                   	push   %eax
  80190a:	6a 05                	push   $0x5
  80190c:	e8 7b ff ff ff       	call   80188c <syscall>
  801911:	83 c4 18             	add    $0x18,%esp
}
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	56                   	push   %esi
  80191a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80191b:	8b 75 18             	mov    0x18(%ebp),%esi
  80191e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801921:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801924:	8b 55 0c             	mov    0xc(%ebp),%edx
  801927:	8b 45 08             	mov    0x8(%ebp),%eax
  80192a:	56                   	push   %esi
  80192b:	53                   	push   %ebx
  80192c:	51                   	push   %ecx
  80192d:	52                   	push   %edx
  80192e:	50                   	push   %eax
  80192f:	6a 06                	push   $0x6
  801931:	e8 56 ff ff ff       	call   80188c <syscall>
  801936:	83 c4 18             	add    $0x18,%esp
}
  801939:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80193c:	5b                   	pop    %ebx
  80193d:	5e                   	pop    %esi
  80193e:	5d                   	pop    %ebp
  80193f:	c3                   	ret    

00801940 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801943:	8b 55 0c             	mov    0xc(%ebp),%edx
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	52                   	push   %edx
  801950:	50                   	push   %eax
  801951:	6a 07                	push   $0x7
  801953:	e8 34 ff ff ff       	call   80188c <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
}
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    

0080195d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	ff 75 0c             	pushl  0xc(%ebp)
  801969:	ff 75 08             	pushl  0x8(%ebp)
  80196c:	6a 08                	push   $0x8
  80196e:	e8 19 ff ff ff       	call   80188c <syscall>
  801973:	83 c4 18             	add    $0x18,%esp
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 09                	push   $0x9
  801987:	e8 00 ff ff ff       	call   80188c <syscall>
  80198c:	83 c4 18             	add    $0x18,%esp
}
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 0a                	push   $0xa
  8019a0:	e8 e7 fe ff ff       	call   80188c <syscall>
  8019a5:	83 c4 18             	add    $0x18,%esp
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 0b                	push   $0xb
  8019b9:	e8 ce fe ff ff       	call   80188c <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	ff 75 0c             	pushl  0xc(%ebp)
  8019cf:	ff 75 08             	pushl  0x8(%ebp)
  8019d2:	6a 0f                	push   $0xf
  8019d4:	e8 b3 fe ff ff       	call   80188c <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
	return;
  8019dc:	90                   	nop
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	ff 75 0c             	pushl  0xc(%ebp)
  8019eb:	ff 75 08             	pushl  0x8(%ebp)
  8019ee:	6a 10                	push   $0x10
  8019f0:	e8 97 fe ff ff       	call   80188c <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f8:	90                   	nop
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	ff 75 10             	pushl  0x10(%ebp)
  801a05:	ff 75 0c             	pushl  0xc(%ebp)
  801a08:	ff 75 08             	pushl  0x8(%ebp)
  801a0b:	6a 11                	push   $0x11
  801a0d:	e8 7a fe ff ff       	call   80188c <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
	return ;
  801a15:	90                   	nop
}
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 0c                	push   $0xc
  801a27:	e8 60 fe ff ff       	call   80188c <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	ff 75 08             	pushl  0x8(%ebp)
  801a3f:	6a 0d                	push   $0xd
  801a41:	e8 46 fe ff ff       	call   80188c <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 0e                	push   $0xe
  801a5a:	e8 2d fe ff ff       	call   80188c <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
}
  801a62:	90                   	nop
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 13                	push   $0x13
  801a74:	e8 13 fe ff ff       	call   80188c <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	90                   	nop
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 14                	push   $0x14
  801a8e:	e8 f9 fd ff ff       	call   80188c <syscall>
  801a93:	83 c4 18             	add    $0x18,%esp
}
  801a96:	90                   	nop
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	83 ec 04             	sub    $0x4,%esp
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801aa5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	50                   	push   %eax
  801ab2:	6a 15                	push   $0x15
  801ab4:	e8 d3 fd ff ff       	call   80188c <syscall>
  801ab9:	83 c4 18             	add    $0x18,%esp
}
  801abc:	90                   	nop
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 16                	push   $0x16
  801ace:	e8 b9 fd ff ff       	call   80188c <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	90                   	nop
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801adc:	8b 45 08             	mov    0x8(%ebp),%eax
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	ff 75 0c             	pushl  0xc(%ebp)
  801ae8:	50                   	push   %eax
  801ae9:	6a 17                	push   $0x17
  801aeb:	e8 9c fd ff ff       	call   80188c <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801af8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	52                   	push   %edx
  801b05:	50                   	push   %eax
  801b06:	6a 1a                	push   $0x1a
  801b08:	e8 7f fd ff ff       	call   80188c <syscall>
  801b0d:	83 c4 18             	add    $0x18,%esp
}
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b18:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	52                   	push   %edx
  801b22:	50                   	push   %eax
  801b23:	6a 18                	push   $0x18
  801b25:	e8 62 fd ff ff       	call   80188c <syscall>
  801b2a:	83 c4 18             	add    $0x18,%esp
}
  801b2d:	90                   	nop
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b36:	8b 45 08             	mov    0x8(%ebp),%eax
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	52                   	push   %edx
  801b40:	50                   	push   %eax
  801b41:	6a 19                	push   $0x19
  801b43:	e8 44 fd ff ff       	call   80188c <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
}
  801b4b:	90                   	nop
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	83 ec 04             	sub    $0x4,%esp
  801b54:	8b 45 10             	mov    0x10(%ebp),%eax
  801b57:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b5a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b5d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b61:	8b 45 08             	mov    0x8(%ebp),%eax
  801b64:	6a 00                	push   $0x0
  801b66:	51                   	push   %ecx
  801b67:	52                   	push   %edx
  801b68:	ff 75 0c             	pushl  0xc(%ebp)
  801b6b:	50                   	push   %eax
  801b6c:	6a 1b                	push   $0x1b
  801b6e:	e8 19 fd ff ff       	call   80188c <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	52                   	push   %edx
  801b88:	50                   	push   %eax
  801b89:	6a 1c                	push   $0x1c
  801b8b:	e8 fc fc ff ff       	call   80188c <syscall>
  801b90:	83 c4 18             	add    $0x18,%esp
}
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b98:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	51                   	push   %ecx
  801ba6:	52                   	push   %edx
  801ba7:	50                   	push   %eax
  801ba8:	6a 1d                	push   $0x1d
  801baa:	e8 dd fc ff ff       	call   80188c <syscall>
  801baf:	83 c4 18             	add    $0x18,%esp
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bba:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	52                   	push   %edx
  801bc4:	50                   	push   %eax
  801bc5:	6a 1e                	push   $0x1e
  801bc7:	e8 c0 fc ff ff       	call   80188c <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 1f                	push   $0x1f
  801be0:	e8 a7 fc ff ff       	call   80188c <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bed:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf0:	6a 00                	push   $0x0
  801bf2:	ff 75 14             	pushl  0x14(%ebp)
  801bf5:	ff 75 10             	pushl  0x10(%ebp)
  801bf8:	ff 75 0c             	pushl  0xc(%ebp)
  801bfb:	50                   	push   %eax
  801bfc:	6a 20                	push   $0x20
  801bfe:	e8 89 fc ff ff       	call   80188c <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
}
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	50                   	push   %eax
  801c17:	6a 21                	push   $0x21
  801c19:	e8 6e fc ff ff       	call   80188c <syscall>
  801c1e:	83 c4 18             	add    $0x18,%esp
}
  801c21:	90                   	nop
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    

00801c24 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c27:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	50                   	push   %eax
  801c33:	6a 22                	push   $0x22
  801c35:	e8 52 fc ff ff       	call   80188c <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 02                	push   $0x2
  801c4e:	e8 39 fc ff ff       	call   80188c <syscall>
  801c53:	83 c4 18             	add    $0x18,%esp
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 03                	push   $0x3
  801c67:	e8 20 fc ff ff       	call   80188c <syscall>
  801c6c:	83 c4 18             	add    $0x18,%esp
}
  801c6f:	c9                   	leave  
  801c70:	c3                   	ret    

00801c71 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 04                	push   $0x4
  801c80:	e8 07 fc ff ff       	call   80188c <syscall>
  801c85:	83 c4 18             	add    $0x18,%esp
}
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <sys_exit_env>:


void sys_exit_env(void)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 23                	push   $0x23
  801c99:	e8 ee fb ff ff       	call   80188c <syscall>
  801c9e:	83 c4 18             	add    $0x18,%esp
}
  801ca1:	90                   	nop
  801ca2:	c9                   	leave  
  801ca3:	c3                   	ret    

00801ca4 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
  801ca7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801caa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cad:	8d 50 04             	lea    0x4(%eax),%edx
  801cb0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	52                   	push   %edx
  801cba:	50                   	push   %eax
  801cbb:	6a 24                	push   $0x24
  801cbd:	e8 ca fb ff ff       	call   80188c <syscall>
  801cc2:	83 c4 18             	add    $0x18,%esp
	return result;
  801cc5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cc8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ccb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cce:	89 01                	mov    %eax,(%ecx)
  801cd0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd6:	c9                   	leave  
  801cd7:	c2 04 00             	ret    $0x4

00801cda <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	ff 75 10             	pushl  0x10(%ebp)
  801ce4:	ff 75 0c             	pushl  0xc(%ebp)
  801ce7:	ff 75 08             	pushl  0x8(%ebp)
  801cea:	6a 12                	push   $0x12
  801cec:	e8 9b fb ff ff       	call   80188c <syscall>
  801cf1:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf4:	90                   	nop
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 25                	push   $0x25
  801d06:	e8 81 fb ff ff       	call   80188c <syscall>
  801d0b:	83 c4 18             	add    $0x18,%esp
}
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
  801d13:	83 ec 04             	sub    $0x4,%esp
  801d16:	8b 45 08             	mov    0x8(%ebp),%eax
  801d19:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d1c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	50                   	push   %eax
  801d29:	6a 26                	push   $0x26
  801d2b:	e8 5c fb ff ff       	call   80188c <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
	return ;
  801d33:	90                   	nop
}
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <rsttst>:
void rsttst()
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 28                	push   $0x28
  801d45:	e8 42 fb ff ff       	call   80188c <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4d:	90                   	nop
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
  801d53:	83 ec 04             	sub    $0x4,%esp
  801d56:	8b 45 14             	mov    0x14(%ebp),%eax
  801d59:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d5c:	8b 55 18             	mov    0x18(%ebp),%edx
  801d5f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d63:	52                   	push   %edx
  801d64:	50                   	push   %eax
  801d65:	ff 75 10             	pushl  0x10(%ebp)
  801d68:	ff 75 0c             	pushl  0xc(%ebp)
  801d6b:	ff 75 08             	pushl  0x8(%ebp)
  801d6e:	6a 27                	push   $0x27
  801d70:	e8 17 fb ff ff       	call   80188c <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
	return ;
  801d78:	90                   	nop
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <chktst>:
void chktst(uint32 n)
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	ff 75 08             	pushl  0x8(%ebp)
  801d89:	6a 29                	push   $0x29
  801d8b:	e8 fc fa ff ff       	call   80188c <syscall>
  801d90:	83 c4 18             	add    $0x18,%esp
	return ;
  801d93:	90                   	nop
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <inctst>:

void inctst()
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 2a                	push   $0x2a
  801da5:	e8 e2 fa ff ff       	call   80188c <syscall>
  801daa:	83 c4 18             	add    $0x18,%esp
	return ;
  801dad:	90                   	nop
}
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <gettst>:
uint32 gettst()
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 2b                	push   $0x2b
  801dbf:	e8 c8 fa ff ff       	call   80188c <syscall>
  801dc4:	83 c4 18             	add    $0x18,%esp
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 2c                	push   $0x2c
  801ddb:	e8 ac fa ff ff       	call   80188c <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
  801de3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801de6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dea:	75 07                	jne    801df3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801dec:	b8 01 00 00 00       	mov    $0x1,%eax
  801df1:	eb 05                	jmp    801df8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801df3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
  801dfd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 2c                	push   $0x2c
  801e0c:	e8 7b fa ff ff       	call   80188c <syscall>
  801e11:	83 c4 18             	add    $0x18,%esp
  801e14:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e17:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e1b:	75 07                	jne    801e24 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e1d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e22:	eb 05                	jmp    801e29 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    

00801e2b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
  801e2e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 2c                	push   $0x2c
  801e3d:	e8 4a fa ff ff       	call   80188c <syscall>
  801e42:	83 c4 18             	add    $0x18,%esp
  801e45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e48:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e4c:	75 07                	jne    801e55 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e53:	eb 05                	jmp    801e5a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e5a:	c9                   	leave  
  801e5b:	c3                   	ret    

00801e5c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 2c                	push   $0x2c
  801e6e:	e8 19 fa ff ff       	call   80188c <syscall>
  801e73:	83 c4 18             	add    $0x18,%esp
  801e76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e79:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e7d:	75 07                	jne    801e86 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e7f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e84:	eb 05                	jmp    801e8b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	ff 75 08             	pushl  0x8(%ebp)
  801e9b:	6a 2d                	push   $0x2d
  801e9d:	e8 ea f9 ff ff       	call   80188c <syscall>
  801ea2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea5:	90                   	nop
}
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
  801eab:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801eac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eaf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb8:	6a 00                	push   $0x0
  801eba:	53                   	push   %ebx
  801ebb:	51                   	push   %ecx
  801ebc:	52                   	push   %edx
  801ebd:	50                   	push   %eax
  801ebe:	6a 2e                	push   $0x2e
  801ec0:	e8 c7 f9 ff ff       	call   80188c <syscall>
  801ec5:	83 c4 18             	add    $0x18,%esp
}
  801ec8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ed0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	52                   	push   %edx
  801edd:	50                   	push   %eax
  801ede:	6a 2f                	push   $0x2f
  801ee0:	e8 a7 f9 ff ff       	call   80188c <syscall>
  801ee5:	83 c4 18             	add    $0x18,%esp
}
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
  801eed:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ef0:	83 ec 0c             	sub    $0xc,%esp
  801ef3:	68 00 39 80 00       	push   $0x803900
  801ef8:	e8 dd e6 ff ff       	call   8005da <cprintf>
  801efd:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f00:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f07:	83 ec 0c             	sub    $0xc,%esp
  801f0a:	68 2c 39 80 00       	push   $0x80392c
  801f0f:	e8 c6 e6 ff ff       	call   8005da <cprintf>
  801f14:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f17:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f1b:	a1 38 41 80 00       	mov    0x804138,%eax
  801f20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f23:	eb 56                	jmp    801f7b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f29:	74 1c                	je     801f47 <print_mem_block_lists+0x5d>
  801f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2e:	8b 50 08             	mov    0x8(%eax),%edx
  801f31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f34:	8b 48 08             	mov    0x8(%eax),%ecx
  801f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f3d:	01 c8                	add    %ecx,%eax
  801f3f:	39 c2                	cmp    %eax,%edx
  801f41:	73 04                	jae    801f47 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f43:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4a:	8b 50 08             	mov    0x8(%eax),%edx
  801f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f50:	8b 40 0c             	mov    0xc(%eax),%eax
  801f53:	01 c2                	add    %eax,%edx
  801f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f58:	8b 40 08             	mov    0x8(%eax),%eax
  801f5b:	83 ec 04             	sub    $0x4,%esp
  801f5e:	52                   	push   %edx
  801f5f:	50                   	push   %eax
  801f60:	68 41 39 80 00       	push   $0x803941
  801f65:	e8 70 e6 ff ff       	call   8005da <cprintf>
  801f6a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f70:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f73:	a1 40 41 80 00       	mov    0x804140,%eax
  801f78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f7f:	74 07                	je     801f88 <print_mem_block_lists+0x9e>
  801f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f84:	8b 00                	mov    (%eax),%eax
  801f86:	eb 05                	jmp    801f8d <print_mem_block_lists+0xa3>
  801f88:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8d:	a3 40 41 80 00       	mov    %eax,0x804140
  801f92:	a1 40 41 80 00       	mov    0x804140,%eax
  801f97:	85 c0                	test   %eax,%eax
  801f99:	75 8a                	jne    801f25 <print_mem_block_lists+0x3b>
  801f9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f9f:	75 84                	jne    801f25 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fa1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fa5:	75 10                	jne    801fb7 <print_mem_block_lists+0xcd>
  801fa7:	83 ec 0c             	sub    $0xc,%esp
  801faa:	68 50 39 80 00       	push   $0x803950
  801faf:	e8 26 e6 ff ff       	call   8005da <cprintf>
  801fb4:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fb7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fbe:	83 ec 0c             	sub    $0xc,%esp
  801fc1:	68 74 39 80 00       	push   $0x803974
  801fc6:	e8 0f e6 ff ff       	call   8005da <cprintf>
  801fcb:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fce:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fd2:	a1 40 40 80 00       	mov    0x804040,%eax
  801fd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fda:	eb 56                	jmp    802032 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fdc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fe0:	74 1c                	je     801ffe <print_mem_block_lists+0x114>
  801fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe5:	8b 50 08             	mov    0x8(%eax),%edx
  801fe8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801feb:	8b 48 08             	mov    0x8(%eax),%ecx
  801fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ff4:	01 c8                	add    %ecx,%eax
  801ff6:	39 c2                	cmp    %eax,%edx
  801ff8:	73 04                	jae    801ffe <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ffa:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802001:	8b 50 08             	mov    0x8(%eax),%edx
  802004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802007:	8b 40 0c             	mov    0xc(%eax),%eax
  80200a:	01 c2                	add    %eax,%edx
  80200c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200f:	8b 40 08             	mov    0x8(%eax),%eax
  802012:	83 ec 04             	sub    $0x4,%esp
  802015:	52                   	push   %edx
  802016:	50                   	push   %eax
  802017:	68 41 39 80 00       	push   $0x803941
  80201c:	e8 b9 e5 ff ff       	call   8005da <cprintf>
  802021:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802027:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80202a:	a1 48 40 80 00       	mov    0x804048,%eax
  80202f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802032:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802036:	74 07                	je     80203f <print_mem_block_lists+0x155>
  802038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203b:	8b 00                	mov    (%eax),%eax
  80203d:	eb 05                	jmp    802044 <print_mem_block_lists+0x15a>
  80203f:	b8 00 00 00 00       	mov    $0x0,%eax
  802044:	a3 48 40 80 00       	mov    %eax,0x804048
  802049:	a1 48 40 80 00       	mov    0x804048,%eax
  80204e:	85 c0                	test   %eax,%eax
  802050:	75 8a                	jne    801fdc <print_mem_block_lists+0xf2>
  802052:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802056:	75 84                	jne    801fdc <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802058:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80205c:	75 10                	jne    80206e <print_mem_block_lists+0x184>
  80205e:	83 ec 0c             	sub    $0xc,%esp
  802061:	68 8c 39 80 00       	push   $0x80398c
  802066:	e8 6f e5 ff ff       	call   8005da <cprintf>
  80206b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80206e:	83 ec 0c             	sub    $0xc,%esp
  802071:	68 00 39 80 00       	push   $0x803900
  802076:	e8 5f e5 ff ff       	call   8005da <cprintf>
  80207b:	83 c4 10             	add    $0x10,%esp

}
  80207e:	90                   	nop
  80207f:	c9                   	leave  
  802080:	c3                   	ret    

00802081 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
  802084:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  802087:	8b 45 08             	mov    0x8(%ebp),%eax
  80208a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  80208d:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802094:	00 00 00 
  802097:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80209e:	00 00 00 
  8020a1:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020a8:	00 00 00 
	for(int i = 0; i<n;i++)
  8020ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020b2:	e9 9e 00 00 00       	jmp    802155 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  8020b7:	a1 50 40 80 00       	mov    0x804050,%eax
  8020bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020bf:	c1 e2 04             	shl    $0x4,%edx
  8020c2:	01 d0                	add    %edx,%eax
  8020c4:	85 c0                	test   %eax,%eax
  8020c6:	75 14                	jne    8020dc <initialize_MemBlocksList+0x5b>
  8020c8:	83 ec 04             	sub    $0x4,%esp
  8020cb:	68 b4 39 80 00       	push   $0x8039b4
  8020d0:	6a 47                	push   $0x47
  8020d2:	68 d7 39 80 00       	push   $0x8039d7
  8020d7:	e8 4a e2 ff ff       	call   800326 <_panic>
  8020dc:	a1 50 40 80 00       	mov    0x804050,%eax
  8020e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e4:	c1 e2 04             	shl    $0x4,%edx
  8020e7:	01 d0                	add    %edx,%eax
  8020e9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020ef:	89 10                	mov    %edx,(%eax)
  8020f1:	8b 00                	mov    (%eax),%eax
  8020f3:	85 c0                	test   %eax,%eax
  8020f5:	74 18                	je     80210f <initialize_MemBlocksList+0x8e>
  8020f7:	a1 48 41 80 00       	mov    0x804148,%eax
  8020fc:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802102:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802105:	c1 e1 04             	shl    $0x4,%ecx
  802108:	01 ca                	add    %ecx,%edx
  80210a:	89 50 04             	mov    %edx,0x4(%eax)
  80210d:	eb 12                	jmp    802121 <initialize_MemBlocksList+0xa0>
  80210f:	a1 50 40 80 00       	mov    0x804050,%eax
  802114:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802117:	c1 e2 04             	shl    $0x4,%edx
  80211a:	01 d0                	add    %edx,%eax
  80211c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802121:	a1 50 40 80 00       	mov    0x804050,%eax
  802126:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802129:	c1 e2 04             	shl    $0x4,%edx
  80212c:	01 d0                	add    %edx,%eax
  80212e:	a3 48 41 80 00       	mov    %eax,0x804148
  802133:	a1 50 40 80 00       	mov    0x804050,%eax
  802138:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80213b:	c1 e2 04             	shl    $0x4,%edx
  80213e:	01 d0                	add    %edx,%eax
  802140:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802147:	a1 54 41 80 00       	mov    0x804154,%eax
  80214c:	40                   	inc    %eax
  80214d:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  802152:	ff 45 f4             	incl   -0xc(%ebp)
  802155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802158:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80215b:	0f 82 56 ff ff ff    	jb     8020b7 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  802161:	90                   	nop
  802162:	c9                   	leave  
  802163:	c3                   	ret    

00802164 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802164:	55                   	push   %ebp
  802165:	89 e5                	mov    %esp,%ebp
  802167:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  80216a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  802170:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802177:	a1 40 40 80 00       	mov    0x804040,%eax
  80217c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80217f:	eb 23                	jmp    8021a4 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802181:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802184:	8b 40 08             	mov    0x8(%eax),%eax
  802187:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80218a:	75 09                	jne    802195 <find_block+0x31>
		{
			found = 1;
  80218c:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802193:	eb 35                	jmp    8021ca <find_block+0x66>
		}
		else
		{
			found = 0;
  802195:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80219c:	a1 48 40 80 00       	mov    0x804048,%eax
  8021a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021a8:	74 07                	je     8021b1 <find_block+0x4d>
  8021aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ad:	8b 00                	mov    (%eax),%eax
  8021af:	eb 05                	jmp    8021b6 <find_block+0x52>
  8021b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b6:	a3 48 40 80 00       	mov    %eax,0x804048
  8021bb:	a1 48 40 80 00       	mov    0x804048,%eax
  8021c0:	85 c0                	test   %eax,%eax
  8021c2:	75 bd                	jne    802181 <find_block+0x1d>
  8021c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021c8:	75 b7                	jne    802181 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  8021ca:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  8021ce:	75 05                	jne    8021d5 <find_block+0x71>
	{
		return blk;
  8021d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021d3:	eb 05                	jmp    8021da <find_block+0x76>
	}
	else
	{
		return NULL;
  8021d5:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  8021da:	c9                   	leave  
  8021db:	c3                   	ret    

008021dc <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021dc:	55                   	push   %ebp
  8021dd:	89 e5                	mov    %esp,%ebp
  8021df:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  8021e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e5:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  8021e8:	a1 40 40 80 00       	mov    0x804040,%eax
  8021ed:	85 c0                	test   %eax,%eax
  8021ef:	74 12                	je     802203 <insert_sorted_allocList+0x27>
  8021f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f4:	8b 50 08             	mov    0x8(%eax),%edx
  8021f7:	a1 40 40 80 00       	mov    0x804040,%eax
  8021fc:	8b 40 08             	mov    0x8(%eax),%eax
  8021ff:	39 c2                	cmp    %eax,%edx
  802201:	73 65                	jae    802268 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802203:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802207:	75 14                	jne    80221d <insert_sorted_allocList+0x41>
  802209:	83 ec 04             	sub    $0x4,%esp
  80220c:	68 b4 39 80 00       	push   $0x8039b4
  802211:	6a 7b                	push   $0x7b
  802213:	68 d7 39 80 00       	push   $0x8039d7
  802218:	e8 09 e1 ff ff       	call   800326 <_panic>
  80221d:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802223:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802226:	89 10                	mov    %edx,(%eax)
  802228:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222b:	8b 00                	mov    (%eax),%eax
  80222d:	85 c0                	test   %eax,%eax
  80222f:	74 0d                	je     80223e <insert_sorted_allocList+0x62>
  802231:	a1 40 40 80 00       	mov    0x804040,%eax
  802236:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802239:	89 50 04             	mov    %edx,0x4(%eax)
  80223c:	eb 08                	jmp    802246 <insert_sorted_allocList+0x6a>
  80223e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802241:	a3 44 40 80 00       	mov    %eax,0x804044
  802246:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802249:	a3 40 40 80 00       	mov    %eax,0x804040
  80224e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802251:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802258:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80225d:	40                   	inc    %eax
  80225e:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802263:	e9 5f 01 00 00       	jmp    8023c7 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  802268:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226b:	8b 50 08             	mov    0x8(%eax),%edx
  80226e:	a1 44 40 80 00       	mov    0x804044,%eax
  802273:	8b 40 08             	mov    0x8(%eax),%eax
  802276:	39 c2                	cmp    %eax,%edx
  802278:	76 65                	jbe    8022df <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  80227a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80227e:	75 14                	jne    802294 <insert_sorted_allocList+0xb8>
  802280:	83 ec 04             	sub    $0x4,%esp
  802283:	68 f0 39 80 00       	push   $0x8039f0
  802288:	6a 7f                	push   $0x7f
  80228a:	68 d7 39 80 00       	push   $0x8039d7
  80228f:	e8 92 e0 ff ff       	call   800326 <_panic>
  802294:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80229a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229d:	89 50 04             	mov    %edx,0x4(%eax)
  8022a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a3:	8b 40 04             	mov    0x4(%eax),%eax
  8022a6:	85 c0                	test   %eax,%eax
  8022a8:	74 0c                	je     8022b6 <insert_sorted_allocList+0xda>
  8022aa:	a1 44 40 80 00       	mov    0x804044,%eax
  8022af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022b2:	89 10                	mov    %edx,(%eax)
  8022b4:	eb 08                	jmp    8022be <insert_sorted_allocList+0xe2>
  8022b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b9:	a3 40 40 80 00       	mov    %eax,0x804040
  8022be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c1:	a3 44 40 80 00       	mov    %eax,0x804044
  8022c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022cf:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022d4:	40                   	inc    %eax
  8022d5:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  8022da:	e9 e8 00 00 00       	jmp    8023c7 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8022df:	a1 40 40 80 00       	mov    0x804040,%eax
  8022e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e7:	e9 ab 00 00 00       	jmp    802397 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  8022ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ef:	8b 00                	mov    (%eax),%eax
  8022f1:	85 c0                	test   %eax,%eax
  8022f3:	0f 84 96 00 00 00    	je     80238f <insert_sorted_allocList+0x1b3>
  8022f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fc:	8b 50 08             	mov    0x8(%eax),%edx
  8022ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802302:	8b 40 08             	mov    0x8(%eax),%eax
  802305:	39 c2                	cmp    %eax,%edx
  802307:	0f 86 82 00 00 00    	jbe    80238f <insert_sorted_allocList+0x1b3>
  80230d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802310:	8b 50 08             	mov    0x8(%eax),%edx
  802313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802316:	8b 00                	mov    (%eax),%eax
  802318:	8b 40 08             	mov    0x8(%eax),%eax
  80231b:	39 c2                	cmp    %eax,%edx
  80231d:	73 70                	jae    80238f <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  80231f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802323:	74 06                	je     80232b <insert_sorted_allocList+0x14f>
  802325:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802329:	75 17                	jne    802342 <insert_sorted_allocList+0x166>
  80232b:	83 ec 04             	sub    $0x4,%esp
  80232e:	68 14 3a 80 00       	push   $0x803a14
  802333:	68 87 00 00 00       	push   $0x87
  802338:	68 d7 39 80 00       	push   $0x8039d7
  80233d:	e8 e4 df ff ff       	call   800326 <_panic>
  802342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802345:	8b 10                	mov    (%eax),%edx
  802347:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234a:	89 10                	mov    %edx,(%eax)
  80234c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234f:	8b 00                	mov    (%eax),%eax
  802351:	85 c0                	test   %eax,%eax
  802353:	74 0b                	je     802360 <insert_sorted_allocList+0x184>
  802355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802358:	8b 00                	mov    (%eax),%eax
  80235a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80235d:	89 50 04             	mov    %edx,0x4(%eax)
  802360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802363:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802366:	89 10                	mov    %edx,(%eax)
  802368:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236e:	89 50 04             	mov    %edx,0x4(%eax)
  802371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802374:	8b 00                	mov    (%eax),%eax
  802376:	85 c0                	test   %eax,%eax
  802378:	75 08                	jne    802382 <insert_sorted_allocList+0x1a6>
  80237a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237d:	a3 44 40 80 00       	mov    %eax,0x804044
  802382:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802387:	40                   	inc    %eax
  802388:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80238d:	eb 38                	jmp    8023c7 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  80238f:	a1 48 40 80 00       	mov    0x804048,%eax
  802394:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802397:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80239b:	74 07                	je     8023a4 <insert_sorted_allocList+0x1c8>
  80239d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a0:	8b 00                	mov    (%eax),%eax
  8023a2:	eb 05                	jmp    8023a9 <insert_sorted_allocList+0x1cd>
  8023a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a9:	a3 48 40 80 00       	mov    %eax,0x804048
  8023ae:	a1 48 40 80 00       	mov    0x804048,%eax
  8023b3:	85 c0                	test   %eax,%eax
  8023b5:	0f 85 31 ff ff ff    	jne    8022ec <insert_sorted_allocList+0x110>
  8023bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023bf:	0f 85 27 ff ff ff    	jne    8022ec <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  8023c5:	eb 00                	jmp    8023c7 <insert_sorted_allocList+0x1eb>
  8023c7:	90                   	nop
  8023c8:	c9                   	leave  
  8023c9:	c3                   	ret    

008023ca <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023ca:	55                   	push   %ebp
  8023cb:	89 e5                	mov    %esp,%ebp
  8023cd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  8023d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8023d6:	a1 48 41 80 00       	mov    0x804148,%eax
  8023db:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8023de:	a1 38 41 80 00       	mov    0x804138,%eax
  8023e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e6:	e9 77 01 00 00       	jmp    802562 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8023f4:	0f 85 8a 00 00 00    	jne    802484 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8023fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023fe:	75 17                	jne    802417 <alloc_block_FF+0x4d>
  802400:	83 ec 04             	sub    $0x4,%esp
  802403:	68 48 3a 80 00       	push   $0x803a48
  802408:	68 9e 00 00 00       	push   $0x9e
  80240d:	68 d7 39 80 00       	push   $0x8039d7
  802412:	e8 0f df ff ff       	call   800326 <_panic>
  802417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241a:	8b 00                	mov    (%eax),%eax
  80241c:	85 c0                	test   %eax,%eax
  80241e:	74 10                	je     802430 <alloc_block_FF+0x66>
  802420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802423:	8b 00                	mov    (%eax),%eax
  802425:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802428:	8b 52 04             	mov    0x4(%edx),%edx
  80242b:	89 50 04             	mov    %edx,0x4(%eax)
  80242e:	eb 0b                	jmp    80243b <alloc_block_FF+0x71>
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	8b 40 04             	mov    0x4(%eax),%eax
  802436:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	8b 40 04             	mov    0x4(%eax),%eax
  802441:	85 c0                	test   %eax,%eax
  802443:	74 0f                	je     802454 <alloc_block_FF+0x8a>
  802445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802448:	8b 40 04             	mov    0x4(%eax),%eax
  80244b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80244e:	8b 12                	mov    (%edx),%edx
  802450:	89 10                	mov    %edx,(%eax)
  802452:	eb 0a                	jmp    80245e <alloc_block_FF+0x94>
  802454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802457:	8b 00                	mov    (%eax),%eax
  802459:	a3 38 41 80 00       	mov    %eax,0x804138
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802471:	a1 44 41 80 00       	mov    0x804144,%eax
  802476:	48                   	dec    %eax
  802477:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  80247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247f:	e9 11 01 00 00       	jmp    802595 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	8b 40 0c             	mov    0xc(%eax),%eax
  80248a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80248d:	0f 86 c7 00 00 00    	jbe    80255a <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802493:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802497:	75 17                	jne    8024b0 <alloc_block_FF+0xe6>
  802499:	83 ec 04             	sub    $0x4,%esp
  80249c:	68 48 3a 80 00       	push   $0x803a48
  8024a1:	68 a3 00 00 00       	push   $0xa3
  8024a6:	68 d7 39 80 00       	push   $0x8039d7
  8024ab:	e8 76 de ff ff       	call   800326 <_panic>
  8024b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b3:	8b 00                	mov    (%eax),%eax
  8024b5:	85 c0                	test   %eax,%eax
  8024b7:	74 10                	je     8024c9 <alloc_block_FF+0xff>
  8024b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024bc:	8b 00                	mov    (%eax),%eax
  8024be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024c1:	8b 52 04             	mov    0x4(%edx),%edx
  8024c4:	89 50 04             	mov    %edx,0x4(%eax)
  8024c7:	eb 0b                	jmp    8024d4 <alloc_block_FF+0x10a>
  8024c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024cc:	8b 40 04             	mov    0x4(%eax),%eax
  8024cf:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d7:	8b 40 04             	mov    0x4(%eax),%eax
  8024da:	85 c0                	test   %eax,%eax
  8024dc:	74 0f                	je     8024ed <alloc_block_FF+0x123>
  8024de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e1:	8b 40 04             	mov    0x4(%eax),%eax
  8024e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024e7:	8b 12                	mov    (%edx),%edx
  8024e9:	89 10                	mov    %edx,(%eax)
  8024eb:	eb 0a                	jmp    8024f7 <alloc_block_FF+0x12d>
  8024ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f0:	8b 00                	mov    (%eax),%eax
  8024f2:	a3 48 41 80 00       	mov    %eax,0x804148
  8024f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802500:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802503:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80250a:	a1 54 41 80 00       	mov    0x804154,%eax
  80250f:	48                   	dec    %eax
  802510:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802515:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802518:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80251b:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  80251e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802521:	8b 40 0c             	mov    0xc(%eax),%eax
  802524:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802527:	89 c2                	mov    %eax,%edx
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  80252f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802532:	8b 40 08             	mov    0x8(%eax),%eax
  802535:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253b:	8b 50 08             	mov    0x8(%eax),%edx
  80253e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802541:	8b 40 0c             	mov    0xc(%eax),%eax
  802544:	01 c2                	add    %eax,%edx
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  80254c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80254f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802552:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802555:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802558:	eb 3b                	jmp    802595 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80255a:	a1 40 41 80 00       	mov    0x804140,%eax
  80255f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802562:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802566:	74 07                	je     80256f <alloc_block_FF+0x1a5>
  802568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256b:	8b 00                	mov    (%eax),%eax
  80256d:	eb 05                	jmp    802574 <alloc_block_FF+0x1aa>
  80256f:	b8 00 00 00 00       	mov    $0x0,%eax
  802574:	a3 40 41 80 00       	mov    %eax,0x804140
  802579:	a1 40 41 80 00       	mov    0x804140,%eax
  80257e:	85 c0                	test   %eax,%eax
  802580:	0f 85 65 fe ff ff    	jne    8023eb <alloc_block_FF+0x21>
  802586:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80258a:	0f 85 5b fe ff ff    	jne    8023eb <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802590:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802595:	c9                   	leave  
  802596:	c3                   	ret    

00802597 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802597:	55                   	push   %ebp
  802598:	89 e5                	mov    %esp,%ebp
  80259a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  80259d:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  8025a3:	a1 48 41 80 00       	mov    0x804148,%eax
  8025a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  8025ab:	a1 44 41 80 00       	mov    0x804144,%eax
  8025b0:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025b3:	a1 38 41 80 00       	mov    0x804138,%eax
  8025b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025bb:	e9 a1 00 00 00       	jmp    802661 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  8025c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8025c9:	0f 85 8a 00 00 00    	jne    802659 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  8025cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d3:	75 17                	jne    8025ec <alloc_block_BF+0x55>
  8025d5:	83 ec 04             	sub    $0x4,%esp
  8025d8:	68 48 3a 80 00       	push   $0x803a48
  8025dd:	68 c2 00 00 00       	push   $0xc2
  8025e2:	68 d7 39 80 00       	push   $0x8039d7
  8025e7:	e8 3a dd ff ff       	call   800326 <_panic>
  8025ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ef:	8b 00                	mov    (%eax),%eax
  8025f1:	85 c0                	test   %eax,%eax
  8025f3:	74 10                	je     802605 <alloc_block_BF+0x6e>
  8025f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f8:	8b 00                	mov    (%eax),%eax
  8025fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025fd:	8b 52 04             	mov    0x4(%edx),%edx
  802600:	89 50 04             	mov    %edx,0x4(%eax)
  802603:	eb 0b                	jmp    802610 <alloc_block_BF+0x79>
  802605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802608:	8b 40 04             	mov    0x4(%eax),%eax
  80260b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802613:	8b 40 04             	mov    0x4(%eax),%eax
  802616:	85 c0                	test   %eax,%eax
  802618:	74 0f                	je     802629 <alloc_block_BF+0x92>
  80261a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261d:	8b 40 04             	mov    0x4(%eax),%eax
  802620:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802623:	8b 12                	mov    (%edx),%edx
  802625:	89 10                	mov    %edx,(%eax)
  802627:	eb 0a                	jmp    802633 <alloc_block_BF+0x9c>
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	8b 00                	mov    (%eax),%eax
  80262e:	a3 38 41 80 00       	mov    %eax,0x804138
  802633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802636:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80263c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802646:	a1 44 41 80 00       	mov    0x804144,%eax
  80264b:	48                   	dec    %eax
  80264c:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	e9 11 02 00 00       	jmp    80286a <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802659:	a1 40 41 80 00       	mov    0x804140,%eax
  80265e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802661:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802665:	74 07                	je     80266e <alloc_block_BF+0xd7>
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	8b 00                	mov    (%eax),%eax
  80266c:	eb 05                	jmp    802673 <alloc_block_BF+0xdc>
  80266e:	b8 00 00 00 00       	mov    $0x0,%eax
  802673:	a3 40 41 80 00       	mov    %eax,0x804140
  802678:	a1 40 41 80 00       	mov    0x804140,%eax
  80267d:	85 c0                	test   %eax,%eax
  80267f:	0f 85 3b ff ff ff    	jne    8025c0 <alloc_block_BF+0x29>
  802685:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802689:	0f 85 31 ff ff ff    	jne    8025c0 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80268f:	a1 38 41 80 00       	mov    0x804138,%eax
  802694:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802697:	eb 27                	jmp    8026c0 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	8b 40 0c             	mov    0xc(%eax),%eax
  80269f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8026a2:	76 14                	jbe    8026b8 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  8026a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  8026ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b0:	8b 40 08             	mov    0x8(%eax),%eax
  8026b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  8026b6:	eb 2e                	jmp    8026e6 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026b8:	a1 40 41 80 00       	mov    0x804140,%eax
  8026bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c4:	74 07                	je     8026cd <alloc_block_BF+0x136>
  8026c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c9:	8b 00                	mov    (%eax),%eax
  8026cb:	eb 05                	jmp    8026d2 <alloc_block_BF+0x13b>
  8026cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d2:	a3 40 41 80 00       	mov    %eax,0x804140
  8026d7:	a1 40 41 80 00       	mov    0x804140,%eax
  8026dc:	85 c0                	test   %eax,%eax
  8026de:	75 b9                	jne    802699 <alloc_block_BF+0x102>
  8026e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e4:	75 b3                	jne    802699 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026e6:	a1 38 41 80 00       	mov    0x804138,%eax
  8026eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ee:	eb 30                	jmp    802720 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  8026f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8026f9:	73 1d                	jae    802718 <alloc_block_BF+0x181>
  8026fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802701:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802704:	76 12                	jbe    802718 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802709:	8b 40 0c             	mov    0xc(%eax),%eax
  80270c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	8b 40 08             	mov    0x8(%eax),%eax
  802715:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802718:	a1 40 41 80 00       	mov    0x804140,%eax
  80271d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802720:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802724:	74 07                	je     80272d <alloc_block_BF+0x196>
  802726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802729:	8b 00                	mov    (%eax),%eax
  80272b:	eb 05                	jmp    802732 <alloc_block_BF+0x19b>
  80272d:	b8 00 00 00 00       	mov    $0x0,%eax
  802732:	a3 40 41 80 00       	mov    %eax,0x804140
  802737:	a1 40 41 80 00       	mov    0x804140,%eax
  80273c:	85 c0                	test   %eax,%eax
  80273e:	75 b0                	jne    8026f0 <alloc_block_BF+0x159>
  802740:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802744:	75 aa                	jne    8026f0 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802746:	a1 38 41 80 00       	mov    0x804138,%eax
  80274b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80274e:	e9 e4 00 00 00       	jmp    802837 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	8b 40 0c             	mov    0xc(%eax),%eax
  802759:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80275c:	0f 85 cd 00 00 00    	jne    80282f <alloc_block_BF+0x298>
  802762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802765:	8b 40 08             	mov    0x8(%eax),%eax
  802768:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80276b:	0f 85 be 00 00 00    	jne    80282f <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802771:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802775:	75 17                	jne    80278e <alloc_block_BF+0x1f7>
  802777:	83 ec 04             	sub    $0x4,%esp
  80277a:	68 48 3a 80 00       	push   $0x803a48
  80277f:	68 db 00 00 00       	push   $0xdb
  802784:	68 d7 39 80 00       	push   $0x8039d7
  802789:	e8 98 db ff ff       	call   800326 <_panic>
  80278e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802791:	8b 00                	mov    (%eax),%eax
  802793:	85 c0                	test   %eax,%eax
  802795:	74 10                	je     8027a7 <alloc_block_BF+0x210>
  802797:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80279a:	8b 00                	mov    (%eax),%eax
  80279c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80279f:	8b 52 04             	mov    0x4(%edx),%edx
  8027a2:	89 50 04             	mov    %edx,0x4(%eax)
  8027a5:	eb 0b                	jmp    8027b2 <alloc_block_BF+0x21b>
  8027a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027aa:	8b 40 04             	mov    0x4(%eax),%eax
  8027ad:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b5:	8b 40 04             	mov    0x4(%eax),%eax
  8027b8:	85 c0                	test   %eax,%eax
  8027ba:	74 0f                	je     8027cb <alloc_block_BF+0x234>
  8027bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027bf:	8b 40 04             	mov    0x4(%eax),%eax
  8027c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027c5:	8b 12                	mov    (%edx),%edx
  8027c7:	89 10                	mov    %edx,(%eax)
  8027c9:	eb 0a                	jmp    8027d5 <alloc_block_BF+0x23e>
  8027cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ce:	8b 00                	mov    (%eax),%eax
  8027d0:	a3 48 41 80 00       	mov    %eax,0x804148
  8027d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027e8:	a1 54 41 80 00       	mov    0x804154,%eax
  8027ed:	48                   	dec    %eax
  8027ee:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8027f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027f9:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  8027fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802802:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802808:	8b 40 0c             	mov    0xc(%eax),%eax
  80280b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80280e:	89 c2                	mov    %eax,%edx
  802810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802813:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802819:	8b 50 08             	mov    0x8(%eax),%edx
  80281c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80281f:	8b 40 0c             	mov    0xc(%eax),%eax
  802822:	01 c2                	add    %eax,%edx
  802824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802827:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  80282a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80282d:	eb 3b                	jmp    80286a <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80282f:	a1 40 41 80 00       	mov    0x804140,%eax
  802834:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802837:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80283b:	74 07                	je     802844 <alloc_block_BF+0x2ad>
  80283d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802840:	8b 00                	mov    (%eax),%eax
  802842:	eb 05                	jmp    802849 <alloc_block_BF+0x2b2>
  802844:	b8 00 00 00 00       	mov    $0x0,%eax
  802849:	a3 40 41 80 00       	mov    %eax,0x804140
  80284e:	a1 40 41 80 00       	mov    0x804140,%eax
  802853:	85 c0                	test   %eax,%eax
  802855:	0f 85 f8 fe ff ff    	jne    802753 <alloc_block_BF+0x1bc>
  80285b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80285f:	0f 85 ee fe ff ff    	jne    802753 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802865:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80286a:	c9                   	leave  
  80286b:	c3                   	ret    

0080286c <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  80286c:	55                   	push   %ebp
  80286d:	89 e5                	mov    %esp,%ebp
  80286f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802872:	8b 45 08             	mov    0x8(%ebp),%eax
  802875:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802878:	a1 48 41 80 00       	mov    0x804148,%eax
  80287d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802880:	a1 38 41 80 00       	mov    0x804138,%eax
  802885:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802888:	e9 77 01 00 00       	jmp    802a04 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  80288d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802890:	8b 40 0c             	mov    0xc(%eax),%eax
  802893:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802896:	0f 85 8a 00 00 00    	jne    802926 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80289c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a0:	75 17                	jne    8028b9 <alloc_block_NF+0x4d>
  8028a2:	83 ec 04             	sub    $0x4,%esp
  8028a5:	68 48 3a 80 00       	push   $0x803a48
  8028aa:	68 f7 00 00 00       	push   $0xf7
  8028af:	68 d7 39 80 00       	push   $0x8039d7
  8028b4:	e8 6d da ff ff       	call   800326 <_panic>
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	8b 00                	mov    (%eax),%eax
  8028be:	85 c0                	test   %eax,%eax
  8028c0:	74 10                	je     8028d2 <alloc_block_NF+0x66>
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	8b 00                	mov    (%eax),%eax
  8028c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ca:	8b 52 04             	mov    0x4(%edx),%edx
  8028cd:	89 50 04             	mov    %edx,0x4(%eax)
  8028d0:	eb 0b                	jmp    8028dd <alloc_block_NF+0x71>
  8028d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d5:	8b 40 04             	mov    0x4(%eax),%eax
  8028d8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	8b 40 04             	mov    0x4(%eax),%eax
  8028e3:	85 c0                	test   %eax,%eax
  8028e5:	74 0f                	je     8028f6 <alloc_block_NF+0x8a>
  8028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ea:	8b 40 04             	mov    0x4(%eax),%eax
  8028ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f0:	8b 12                	mov    (%edx),%edx
  8028f2:	89 10                	mov    %edx,(%eax)
  8028f4:	eb 0a                	jmp    802900 <alloc_block_NF+0x94>
  8028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f9:	8b 00                	mov    (%eax),%eax
  8028fb:	a3 38 41 80 00       	mov    %eax,0x804138
  802900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802903:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802913:	a1 44 41 80 00       	mov    0x804144,%eax
  802918:	48                   	dec    %eax
  802919:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	e9 11 01 00 00       	jmp    802a37 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802929:	8b 40 0c             	mov    0xc(%eax),%eax
  80292c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80292f:	0f 86 c7 00 00 00    	jbe    8029fc <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802935:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802939:	75 17                	jne    802952 <alloc_block_NF+0xe6>
  80293b:	83 ec 04             	sub    $0x4,%esp
  80293e:	68 48 3a 80 00       	push   $0x803a48
  802943:	68 fc 00 00 00       	push   $0xfc
  802948:	68 d7 39 80 00       	push   $0x8039d7
  80294d:	e8 d4 d9 ff ff       	call   800326 <_panic>
  802952:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802955:	8b 00                	mov    (%eax),%eax
  802957:	85 c0                	test   %eax,%eax
  802959:	74 10                	je     80296b <alloc_block_NF+0xff>
  80295b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295e:	8b 00                	mov    (%eax),%eax
  802960:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802963:	8b 52 04             	mov    0x4(%edx),%edx
  802966:	89 50 04             	mov    %edx,0x4(%eax)
  802969:	eb 0b                	jmp    802976 <alloc_block_NF+0x10a>
  80296b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296e:	8b 40 04             	mov    0x4(%eax),%eax
  802971:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802976:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802979:	8b 40 04             	mov    0x4(%eax),%eax
  80297c:	85 c0                	test   %eax,%eax
  80297e:	74 0f                	je     80298f <alloc_block_NF+0x123>
  802980:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802983:	8b 40 04             	mov    0x4(%eax),%eax
  802986:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802989:	8b 12                	mov    (%edx),%edx
  80298b:	89 10                	mov    %edx,(%eax)
  80298d:	eb 0a                	jmp    802999 <alloc_block_NF+0x12d>
  80298f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802992:	8b 00                	mov    (%eax),%eax
  802994:	a3 48 41 80 00       	mov    %eax,0x804148
  802999:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ac:	a1 54 41 80 00       	mov    0x804154,%eax
  8029b1:	48                   	dec    %eax
  8029b2:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8029b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029bd:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c6:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8029c9:	89 c2                	mov    %eax,%edx
  8029cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ce:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8029d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d4:	8b 40 08             	mov    0x8(%eax),%eax
  8029d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dd:	8b 50 08             	mov    0x8(%eax),%edx
  8029e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e6:	01 c2                	add    %eax,%edx
  8029e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029eb:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8029ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029f4:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8029f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fa:	eb 3b                	jmp    802a37 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8029fc:	a1 40 41 80 00       	mov    0x804140,%eax
  802a01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a08:	74 07                	je     802a11 <alloc_block_NF+0x1a5>
  802a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0d:	8b 00                	mov    (%eax),%eax
  802a0f:	eb 05                	jmp    802a16 <alloc_block_NF+0x1aa>
  802a11:	b8 00 00 00 00       	mov    $0x0,%eax
  802a16:	a3 40 41 80 00       	mov    %eax,0x804140
  802a1b:	a1 40 41 80 00       	mov    0x804140,%eax
  802a20:	85 c0                	test   %eax,%eax
  802a22:	0f 85 65 fe ff ff    	jne    80288d <alloc_block_NF+0x21>
  802a28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a2c:	0f 85 5b fe ff ff    	jne    80288d <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802a32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a37:	c9                   	leave  
  802a38:	c3                   	ret    

00802a39 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802a39:	55                   	push   %ebp
  802a3a:	89 e5                	mov    %esp,%ebp
  802a3c:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a42:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802a49:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802a53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a57:	75 17                	jne    802a70 <addToAvailMemBlocksList+0x37>
  802a59:	83 ec 04             	sub    $0x4,%esp
  802a5c:	68 f0 39 80 00       	push   $0x8039f0
  802a61:	68 10 01 00 00       	push   $0x110
  802a66:	68 d7 39 80 00       	push   $0x8039d7
  802a6b:	e8 b6 d8 ff ff       	call   800326 <_panic>
  802a70:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802a76:	8b 45 08             	mov    0x8(%ebp),%eax
  802a79:	89 50 04             	mov    %edx,0x4(%eax)
  802a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7f:	8b 40 04             	mov    0x4(%eax),%eax
  802a82:	85 c0                	test   %eax,%eax
  802a84:	74 0c                	je     802a92 <addToAvailMemBlocksList+0x59>
  802a86:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802a8b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a8e:	89 10                	mov    %edx,(%eax)
  802a90:	eb 08                	jmp    802a9a <addToAvailMemBlocksList+0x61>
  802a92:	8b 45 08             	mov    0x8(%ebp),%eax
  802a95:	a3 48 41 80 00       	mov    %eax,0x804148
  802a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aab:	a1 54 41 80 00       	mov    0x804154,%eax
  802ab0:	40                   	inc    %eax
  802ab1:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802ab6:	90                   	nop
  802ab7:	c9                   	leave  
  802ab8:	c3                   	ret    

00802ab9 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ab9:	55                   	push   %ebp
  802aba:	89 e5                	mov    %esp,%ebp
  802abc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802abf:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ac4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802ac7:	a1 44 41 80 00       	mov    0x804144,%eax
  802acc:	85 c0                	test   %eax,%eax
  802ace:	75 68                	jne    802b38 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802ad0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ad4:	75 17                	jne    802aed <insert_sorted_with_merge_freeList+0x34>
  802ad6:	83 ec 04             	sub    $0x4,%esp
  802ad9:	68 b4 39 80 00       	push   $0x8039b4
  802ade:	68 1a 01 00 00       	push   $0x11a
  802ae3:	68 d7 39 80 00       	push   $0x8039d7
  802ae8:	e8 39 d8 ff ff       	call   800326 <_panic>
  802aed:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802af3:	8b 45 08             	mov    0x8(%ebp),%eax
  802af6:	89 10                	mov    %edx,(%eax)
  802af8:	8b 45 08             	mov    0x8(%ebp),%eax
  802afb:	8b 00                	mov    (%eax),%eax
  802afd:	85 c0                	test   %eax,%eax
  802aff:	74 0d                	je     802b0e <insert_sorted_with_merge_freeList+0x55>
  802b01:	a1 38 41 80 00       	mov    0x804138,%eax
  802b06:	8b 55 08             	mov    0x8(%ebp),%edx
  802b09:	89 50 04             	mov    %edx,0x4(%eax)
  802b0c:	eb 08                	jmp    802b16 <insert_sorted_with_merge_freeList+0x5d>
  802b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b11:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b16:	8b 45 08             	mov    0x8(%ebp),%eax
  802b19:	a3 38 41 80 00       	mov    %eax,0x804138
  802b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b28:	a1 44 41 80 00       	mov    0x804144,%eax
  802b2d:	40                   	inc    %eax
  802b2e:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802b33:	e9 c5 03 00 00       	jmp    802efd <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3b:	8b 50 08             	mov    0x8(%eax),%edx
  802b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b41:	8b 40 08             	mov    0x8(%eax),%eax
  802b44:	39 c2                	cmp    %eax,%edx
  802b46:	0f 83 b2 00 00 00    	jae    802bfe <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4f:	8b 50 08             	mov    0x8(%eax),%edx
  802b52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b55:	8b 40 0c             	mov    0xc(%eax),%eax
  802b58:	01 c2                	add    %eax,%edx
  802b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5d:	8b 40 08             	mov    0x8(%eax),%eax
  802b60:	39 c2                	cmp    %eax,%edx
  802b62:	75 27                	jne    802b8b <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b67:	8b 50 0c             	mov    0xc(%eax),%edx
  802b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b70:	01 c2                	add    %eax,%edx
  802b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b75:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802b78:	83 ec 0c             	sub    $0xc,%esp
  802b7b:	ff 75 08             	pushl  0x8(%ebp)
  802b7e:	e8 b6 fe ff ff       	call   802a39 <addToAvailMemBlocksList>
  802b83:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802b86:	e9 72 03 00 00       	jmp    802efd <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802b8b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b8f:	74 06                	je     802b97 <insert_sorted_with_merge_freeList+0xde>
  802b91:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b95:	75 17                	jne    802bae <insert_sorted_with_merge_freeList+0xf5>
  802b97:	83 ec 04             	sub    $0x4,%esp
  802b9a:	68 14 3a 80 00       	push   $0x803a14
  802b9f:	68 24 01 00 00       	push   $0x124
  802ba4:	68 d7 39 80 00       	push   $0x8039d7
  802ba9:	e8 78 d7 ff ff       	call   800326 <_panic>
  802bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb1:	8b 10                	mov    (%eax),%edx
  802bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb6:	89 10                	mov    %edx,(%eax)
  802bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbb:	8b 00                	mov    (%eax),%eax
  802bbd:	85 c0                	test   %eax,%eax
  802bbf:	74 0b                	je     802bcc <insert_sorted_with_merge_freeList+0x113>
  802bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc4:	8b 00                	mov    (%eax),%eax
  802bc6:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc9:	89 50 04             	mov    %edx,0x4(%eax)
  802bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcf:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd2:	89 10                	mov    %edx,(%eax)
  802bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bda:	89 50 04             	mov    %edx,0x4(%eax)
  802bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802be0:	8b 00                	mov    (%eax),%eax
  802be2:	85 c0                	test   %eax,%eax
  802be4:	75 08                	jne    802bee <insert_sorted_with_merge_freeList+0x135>
  802be6:	8b 45 08             	mov    0x8(%ebp),%eax
  802be9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bee:	a1 44 41 80 00       	mov    0x804144,%eax
  802bf3:	40                   	inc    %eax
  802bf4:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802bf9:	e9 ff 02 00 00       	jmp    802efd <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802bfe:	a1 38 41 80 00       	mov    0x804138,%eax
  802c03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c06:	e9 c2 02 00 00       	jmp    802ecd <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	8b 50 08             	mov    0x8(%eax),%edx
  802c11:	8b 45 08             	mov    0x8(%ebp),%eax
  802c14:	8b 40 08             	mov    0x8(%eax),%eax
  802c17:	39 c2                	cmp    %eax,%edx
  802c19:	0f 86 a6 02 00 00    	jbe    802ec5 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c22:	8b 40 04             	mov    0x4(%eax),%eax
  802c25:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802c28:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c2c:	0f 85 ba 00 00 00    	jne    802cec <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802c32:	8b 45 08             	mov    0x8(%ebp),%eax
  802c35:	8b 50 0c             	mov    0xc(%eax),%edx
  802c38:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3b:	8b 40 08             	mov    0x8(%eax),%eax
  802c3e:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c43:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802c46:	39 c2                	cmp    %eax,%edx
  802c48:	75 33                	jne    802c7d <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4d:	8b 50 08             	mov    0x8(%eax),%edx
  802c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c53:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c59:	8b 50 0c             	mov    0xc(%eax),%edx
  802c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c62:	01 c2                	add    %eax,%edx
  802c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c67:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802c6a:	83 ec 0c             	sub    $0xc,%esp
  802c6d:	ff 75 08             	pushl  0x8(%ebp)
  802c70:	e8 c4 fd ff ff       	call   802a39 <addToAvailMemBlocksList>
  802c75:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802c78:	e9 80 02 00 00       	jmp    802efd <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802c7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c81:	74 06                	je     802c89 <insert_sorted_with_merge_freeList+0x1d0>
  802c83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c87:	75 17                	jne    802ca0 <insert_sorted_with_merge_freeList+0x1e7>
  802c89:	83 ec 04             	sub    $0x4,%esp
  802c8c:	68 68 3a 80 00       	push   $0x803a68
  802c91:	68 3a 01 00 00       	push   $0x13a
  802c96:	68 d7 39 80 00       	push   $0x8039d7
  802c9b:	e8 86 d6 ff ff       	call   800326 <_panic>
  802ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca3:	8b 50 04             	mov    0x4(%eax),%edx
  802ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca9:	89 50 04             	mov    %edx,0x4(%eax)
  802cac:	8b 45 08             	mov    0x8(%ebp),%eax
  802caf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb2:	89 10                	mov    %edx,(%eax)
  802cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb7:	8b 40 04             	mov    0x4(%eax),%eax
  802cba:	85 c0                	test   %eax,%eax
  802cbc:	74 0d                	je     802ccb <insert_sorted_with_merge_freeList+0x212>
  802cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc1:	8b 40 04             	mov    0x4(%eax),%eax
  802cc4:	8b 55 08             	mov    0x8(%ebp),%edx
  802cc7:	89 10                	mov    %edx,(%eax)
  802cc9:	eb 08                	jmp    802cd3 <insert_sorted_with_merge_freeList+0x21a>
  802ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cce:	a3 38 41 80 00       	mov    %eax,0x804138
  802cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd6:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd9:	89 50 04             	mov    %edx,0x4(%eax)
  802cdc:	a1 44 41 80 00       	mov    0x804144,%eax
  802ce1:	40                   	inc    %eax
  802ce2:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802ce7:	e9 11 02 00 00       	jmp    802efd <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802cec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cef:	8b 50 08             	mov    0x8(%eax),%edx
  802cf2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf5:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf8:	01 c2                	add    %eax,%edx
  802cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfd:	8b 40 0c             	mov    0xc(%eax),%eax
  802d00:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d05:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802d08:	39 c2                	cmp    %eax,%edx
  802d0a:	0f 85 bf 00 00 00    	jne    802dcf <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802d10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d13:	8b 50 0c             	mov    0xc(%eax),%edx
  802d16:	8b 45 08             	mov    0x8(%ebp),%eax
  802d19:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1c:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d21:	8b 40 0c             	mov    0xc(%eax),%eax
  802d24:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802d26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d29:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802d2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d30:	75 17                	jne    802d49 <insert_sorted_with_merge_freeList+0x290>
  802d32:	83 ec 04             	sub    $0x4,%esp
  802d35:	68 48 3a 80 00       	push   $0x803a48
  802d3a:	68 43 01 00 00       	push   $0x143
  802d3f:	68 d7 39 80 00       	push   $0x8039d7
  802d44:	e8 dd d5 ff ff       	call   800326 <_panic>
  802d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4c:	8b 00                	mov    (%eax),%eax
  802d4e:	85 c0                	test   %eax,%eax
  802d50:	74 10                	je     802d62 <insert_sorted_with_merge_freeList+0x2a9>
  802d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d55:	8b 00                	mov    (%eax),%eax
  802d57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d5a:	8b 52 04             	mov    0x4(%edx),%edx
  802d5d:	89 50 04             	mov    %edx,0x4(%eax)
  802d60:	eb 0b                	jmp    802d6d <insert_sorted_with_merge_freeList+0x2b4>
  802d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d65:	8b 40 04             	mov    0x4(%eax),%eax
  802d68:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d70:	8b 40 04             	mov    0x4(%eax),%eax
  802d73:	85 c0                	test   %eax,%eax
  802d75:	74 0f                	je     802d86 <insert_sorted_with_merge_freeList+0x2cd>
  802d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7a:	8b 40 04             	mov    0x4(%eax),%eax
  802d7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d80:	8b 12                	mov    (%edx),%edx
  802d82:	89 10                	mov    %edx,(%eax)
  802d84:	eb 0a                	jmp    802d90 <insert_sorted_with_merge_freeList+0x2d7>
  802d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d89:	8b 00                	mov    (%eax),%eax
  802d8b:	a3 38 41 80 00       	mov    %eax,0x804138
  802d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da3:	a1 44 41 80 00       	mov    0x804144,%eax
  802da8:	48                   	dec    %eax
  802da9:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802dae:	83 ec 0c             	sub    $0xc,%esp
  802db1:	ff 75 08             	pushl  0x8(%ebp)
  802db4:	e8 80 fc ff ff       	call   802a39 <addToAvailMemBlocksList>
  802db9:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802dbc:	83 ec 0c             	sub    $0xc,%esp
  802dbf:	ff 75 f4             	pushl  -0xc(%ebp)
  802dc2:	e8 72 fc ff ff       	call   802a39 <addToAvailMemBlocksList>
  802dc7:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802dca:	e9 2e 01 00 00       	jmp    802efd <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802dcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd2:	8b 50 08             	mov    0x8(%eax),%edx
  802dd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ddb:	01 c2                	add    %eax,%edx
  802ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  802de0:	8b 40 08             	mov    0x8(%eax),%eax
  802de3:	39 c2                	cmp    %eax,%edx
  802de5:	75 27                	jne    802e0e <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802de7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dea:	8b 50 0c             	mov    0xc(%eax),%edx
  802ded:	8b 45 08             	mov    0x8(%ebp),%eax
  802df0:	8b 40 0c             	mov    0xc(%eax),%eax
  802df3:	01 c2                	add    %eax,%edx
  802df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df8:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802dfb:	83 ec 0c             	sub    $0xc,%esp
  802dfe:	ff 75 08             	pushl  0x8(%ebp)
  802e01:	e8 33 fc ff ff       	call   802a39 <addToAvailMemBlocksList>
  802e06:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802e09:	e9 ef 00 00 00       	jmp    802efd <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e11:	8b 50 0c             	mov    0xc(%eax),%edx
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	8b 40 08             	mov    0x8(%eax),%eax
  802e1a:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1f:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802e22:	39 c2                	cmp    %eax,%edx
  802e24:	75 33                	jne    802e59 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802e26:	8b 45 08             	mov    0x8(%ebp),%eax
  802e29:	8b 50 08             	mov    0x8(%eax),%edx
  802e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2f:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e35:	8b 50 0c             	mov    0xc(%eax),%edx
  802e38:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3e:	01 c2                	add    %eax,%edx
  802e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e43:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802e46:	83 ec 0c             	sub    $0xc,%esp
  802e49:	ff 75 08             	pushl  0x8(%ebp)
  802e4c:	e8 e8 fb ff ff       	call   802a39 <addToAvailMemBlocksList>
  802e51:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802e54:	e9 a4 00 00 00       	jmp    802efd <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802e59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e5d:	74 06                	je     802e65 <insert_sorted_with_merge_freeList+0x3ac>
  802e5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e63:	75 17                	jne    802e7c <insert_sorted_with_merge_freeList+0x3c3>
  802e65:	83 ec 04             	sub    $0x4,%esp
  802e68:	68 68 3a 80 00       	push   $0x803a68
  802e6d:	68 56 01 00 00       	push   $0x156
  802e72:	68 d7 39 80 00       	push   $0x8039d7
  802e77:	e8 aa d4 ff ff       	call   800326 <_panic>
  802e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7f:	8b 50 04             	mov    0x4(%eax),%edx
  802e82:	8b 45 08             	mov    0x8(%ebp),%eax
  802e85:	89 50 04             	mov    %edx,0x4(%eax)
  802e88:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e8e:	89 10                	mov    %edx,(%eax)
  802e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e93:	8b 40 04             	mov    0x4(%eax),%eax
  802e96:	85 c0                	test   %eax,%eax
  802e98:	74 0d                	je     802ea7 <insert_sorted_with_merge_freeList+0x3ee>
  802e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9d:	8b 40 04             	mov    0x4(%eax),%eax
  802ea0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea3:	89 10                	mov    %edx,(%eax)
  802ea5:	eb 08                	jmp    802eaf <insert_sorted_with_merge_freeList+0x3f6>
  802ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaa:	a3 38 41 80 00       	mov    %eax,0x804138
  802eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb2:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb5:	89 50 04             	mov    %edx,0x4(%eax)
  802eb8:	a1 44 41 80 00       	mov    0x804144,%eax
  802ebd:	40                   	inc    %eax
  802ebe:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802ec3:	eb 38                	jmp    802efd <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802ec5:	a1 40 41 80 00       	mov    0x804140,%eax
  802eca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ecd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed1:	74 07                	je     802eda <insert_sorted_with_merge_freeList+0x421>
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	8b 00                	mov    (%eax),%eax
  802ed8:	eb 05                	jmp    802edf <insert_sorted_with_merge_freeList+0x426>
  802eda:	b8 00 00 00 00       	mov    $0x0,%eax
  802edf:	a3 40 41 80 00       	mov    %eax,0x804140
  802ee4:	a1 40 41 80 00       	mov    0x804140,%eax
  802ee9:	85 c0                	test   %eax,%eax
  802eeb:	0f 85 1a fd ff ff    	jne    802c0b <insert_sorted_with_merge_freeList+0x152>
  802ef1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ef5:	0f 85 10 fd ff ff    	jne    802c0b <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802efb:	eb 00                	jmp    802efd <insert_sorted_with_merge_freeList+0x444>
  802efd:	90                   	nop
  802efe:	c9                   	leave  
  802eff:	c3                   	ret    

00802f00 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802f00:	55                   	push   %ebp
  802f01:	89 e5                	mov    %esp,%ebp
  802f03:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802f06:	8b 55 08             	mov    0x8(%ebp),%edx
  802f09:	89 d0                	mov    %edx,%eax
  802f0b:	c1 e0 02             	shl    $0x2,%eax
  802f0e:	01 d0                	add    %edx,%eax
  802f10:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802f17:	01 d0                	add    %edx,%eax
  802f19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802f20:	01 d0                	add    %edx,%eax
  802f22:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802f29:	01 d0                	add    %edx,%eax
  802f2b:	c1 e0 04             	shl    $0x4,%eax
  802f2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802f31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802f38:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802f3b:	83 ec 0c             	sub    $0xc,%esp
  802f3e:	50                   	push   %eax
  802f3f:	e8 60 ed ff ff       	call   801ca4 <sys_get_virtual_time>
  802f44:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802f47:	eb 41                	jmp    802f8a <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802f49:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802f4c:	83 ec 0c             	sub    $0xc,%esp
  802f4f:	50                   	push   %eax
  802f50:	e8 4f ed ff ff       	call   801ca4 <sys_get_virtual_time>
  802f55:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802f58:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5e:	29 c2                	sub    %eax,%edx
  802f60:	89 d0                	mov    %edx,%eax
  802f62:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802f65:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6b:	89 d1                	mov    %edx,%ecx
  802f6d:	29 c1                	sub    %eax,%ecx
  802f6f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802f72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f75:	39 c2                	cmp    %eax,%edx
  802f77:	0f 97 c0             	seta   %al
  802f7a:	0f b6 c0             	movzbl %al,%eax
  802f7d:	29 c1                	sub    %eax,%ecx
  802f7f:	89 c8                	mov    %ecx,%eax
  802f81:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802f84:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f87:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f90:	72 b7                	jb     802f49 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802f92:	90                   	nop
  802f93:	c9                   	leave  
  802f94:	c3                   	ret    

00802f95 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802f95:	55                   	push   %ebp
  802f96:	89 e5                	mov    %esp,%ebp
  802f98:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802f9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802fa2:	eb 03                	jmp    802fa7 <busy_wait+0x12>
  802fa4:	ff 45 fc             	incl   -0x4(%ebp)
  802fa7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802faa:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fad:	72 f5                	jb     802fa4 <busy_wait+0xf>
	return i;
  802faf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802fb2:	c9                   	leave  
  802fb3:	c3                   	ret    

00802fb4 <__udivdi3>:
  802fb4:	55                   	push   %ebp
  802fb5:	57                   	push   %edi
  802fb6:	56                   	push   %esi
  802fb7:	53                   	push   %ebx
  802fb8:	83 ec 1c             	sub    $0x1c,%esp
  802fbb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802fbf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802fc3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802fc7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802fcb:	89 ca                	mov    %ecx,%edx
  802fcd:	89 f8                	mov    %edi,%eax
  802fcf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802fd3:	85 f6                	test   %esi,%esi
  802fd5:	75 2d                	jne    803004 <__udivdi3+0x50>
  802fd7:	39 cf                	cmp    %ecx,%edi
  802fd9:	77 65                	ja     803040 <__udivdi3+0x8c>
  802fdb:	89 fd                	mov    %edi,%ebp
  802fdd:	85 ff                	test   %edi,%edi
  802fdf:	75 0b                	jne    802fec <__udivdi3+0x38>
  802fe1:	b8 01 00 00 00       	mov    $0x1,%eax
  802fe6:	31 d2                	xor    %edx,%edx
  802fe8:	f7 f7                	div    %edi
  802fea:	89 c5                	mov    %eax,%ebp
  802fec:	31 d2                	xor    %edx,%edx
  802fee:	89 c8                	mov    %ecx,%eax
  802ff0:	f7 f5                	div    %ebp
  802ff2:	89 c1                	mov    %eax,%ecx
  802ff4:	89 d8                	mov    %ebx,%eax
  802ff6:	f7 f5                	div    %ebp
  802ff8:	89 cf                	mov    %ecx,%edi
  802ffa:	89 fa                	mov    %edi,%edx
  802ffc:	83 c4 1c             	add    $0x1c,%esp
  802fff:	5b                   	pop    %ebx
  803000:	5e                   	pop    %esi
  803001:	5f                   	pop    %edi
  803002:	5d                   	pop    %ebp
  803003:	c3                   	ret    
  803004:	39 ce                	cmp    %ecx,%esi
  803006:	77 28                	ja     803030 <__udivdi3+0x7c>
  803008:	0f bd fe             	bsr    %esi,%edi
  80300b:	83 f7 1f             	xor    $0x1f,%edi
  80300e:	75 40                	jne    803050 <__udivdi3+0x9c>
  803010:	39 ce                	cmp    %ecx,%esi
  803012:	72 0a                	jb     80301e <__udivdi3+0x6a>
  803014:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803018:	0f 87 9e 00 00 00    	ja     8030bc <__udivdi3+0x108>
  80301e:	b8 01 00 00 00       	mov    $0x1,%eax
  803023:	89 fa                	mov    %edi,%edx
  803025:	83 c4 1c             	add    $0x1c,%esp
  803028:	5b                   	pop    %ebx
  803029:	5e                   	pop    %esi
  80302a:	5f                   	pop    %edi
  80302b:	5d                   	pop    %ebp
  80302c:	c3                   	ret    
  80302d:	8d 76 00             	lea    0x0(%esi),%esi
  803030:	31 ff                	xor    %edi,%edi
  803032:	31 c0                	xor    %eax,%eax
  803034:	89 fa                	mov    %edi,%edx
  803036:	83 c4 1c             	add    $0x1c,%esp
  803039:	5b                   	pop    %ebx
  80303a:	5e                   	pop    %esi
  80303b:	5f                   	pop    %edi
  80303c:	5d                   	pop    %ebp
  80303d:	c3                   	ret    
  80303e:	66 90                	xchg   %ax,%ax
  803040:	89 d8                	mov    %ebx,%eax
  803042:	f7 f7                	div    %edi
  803044:	31 ff                	xor    %edi,%edi
  803046:	89 fa                	mov    %edi,%edx
  803048:	83 c4 1c             	add    $0x1c,%esp
  80304b:	5b                   	pop    %ebx
  80304c:	5e                   	pop    %esi
  80304d:	5f                   	pop    %edi
  80304e:	5d                   	pop    %ebp
  80304f:	c3                   	ret    
  803050:	bd 20 00 00 00       	mov    $0x20,%ebp
  803055:	89 eb                	mov    %ebp,%ebx
  803057:	29 fb                	sub    %edi,%ebx
  803059:	89 f9                	mov    %edi,%ecx
  80305b:	d3 e6                	shl    %cl,%esi
  80305d:	89 c5                	mov    %eax,%ebp
  80305f:	88 d9                	mov    %bl,%cl
  803061:	d3 ed                	shr    %cl,%ebp
  803063:	89 e9                	mov    %ebp,%ecx
  803065:	09 f1                	or     %esi,%ecx
  803067:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80306b:	89 f9                	mov    %edi,%ecx
  80306d:	d3 e0                	shl    %cl,%eax
  80306f:	89 c5                	mov    %eax,%ebp
  803071:	89 d6                	mov    %edx,%esi
  803073:	88 d9                	mov    %bl,%cl
  803075:	d3 ee                	shr    %cl,%esi
  803077:	89 f9                	mov    %edi,%ecx
  803079:	d3 e2                	shl    %cl,%edx
  80307b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80307f:	88 d9                	mov    %bl,%cl
  803081:	d3 e8                	shr    %cl,%eax
  803083:	09 c2                	or     %eax,%edx
  803085:	89 d0                	mov    %edx,%eax
  803087:	89 f2                	mov    %esi,%edx
  803089:	f7 74 24 0c          	divl   0xc(%esp)
  80308d:	89 d6                	mov    %edx,%esi
  80308f:	89 c3                	mov    %eax,%ebx
  803091:	f7 e5                	mul    %ebp
  803093:	39 d6                	cmp    %edx,%esi
  803095:	72 19                	jb     8030b0 <__udivdi3+0xfc>
  803097:	74 0b                	je     8030a4 <__udivdi3+0xf0>
  803099:	89 d8                	mov    %ebx,%eax
  80309b:	31 ff                	xor    %edi,%edi
  80309d:	e9 58 ff ff ff       	jmp    802ffa <__udivdi3+0x46>
  8030a2:	66 90                	xchg   %ax,%ax
  8030a4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8030a8:	89 f9                	mov    %edi,%ecx
  8030aa:	d3 e2                	shl    %cl,%edx
  8030ac:	39 c2                	cmp    %eax,%edx
  8030ae:	73 e9                	jae    803099 <__udivdi3+0xe5>
  8030b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8030b3:	31 ff                	xor    %edi,%edi
  8030b5:	e9 40 ff ff ff       	jmp    802ffa <__udivdi3+0x46>
  8030ba:	66 90                	xchg   %ax,%ax
  8030bc:	31 c0                	xor    %eax,%eax
  8030be:	e9 37 ff ff ff       	jmp    802ffa <__udivdi3+0x46>
  8030c3:	90                   	nop

008030c4 <__umoddi3>:
  8030c4:	55                   	push   %ebp
  8030c5:	57                   	push   %edi
  8030c6:	56                   	push   %esi
  8030c7:	53                   	push   %ebx
  8030c8:	83 ec 1c             	sub    $0x1c,%esp
  8030cb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8030cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8030d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030d7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8030db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8030df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8030e3:	89 f3                	mov    %esi,%ebx
  8030e5:	89 fa                	mov    %edi,%edx
  8030e7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8030eb:	89 34 24             	mov    %esi,(%esp)
  8030ee:	85 c0                	test   %eax,%eax
  8030f0:	75 1a                	jne    80310c <__umoddi3+0x48>
  8030f2:	39 f7                	cmp    %esi,%edi
  8030f4:	0f 86 a2 00 00 00    	jbe    80319c <__umoddi3+0xd8>
  8030fa:	89 c8                	mov    %ecx,%eax
  8030fc:	89 f2                	mov    %esi,%edx
  8030fe:	f7 f7                	div    %edi
  803100:	89 d0                	mov    %edx,%eax
  803102:	31 d2                	xor    %edx,%edx
  803104:	83 c4 1c             	add    $0x1c,%esp
  803107:	5b                   	pop    %ebx
  803108:	5e                   	pop    %esi
  803109:	5f                   	pop    %edi
  80310a:	5d                   	pop    %ebp
  80310b:	c3                   	ret    
  80310c:	39 f0                	cmp    %esi,%eax
  80310e:	0f 87 ac 00 00 00    	ja     8031c0 <__umoddi3+0xfc>
  803114:	0f bd e8             	bsr    %eax,%ebp
  803117:	83 f5 1f             	xor    $0x1f,%ebp
  80311a:	0f 84 ac 00 00 00    	je     8031cc <__umoddi3+0x108>
  803120:	bf 20 00 00 00       	mov    $0x20,%edi
  803125:	29 ef                	sub    %ebp,%edi
  803127:	89 fe                	mov    %edi,%esi
  803129:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80312d:	89 e9                	mov    %ebp,%ecx
  80312f:	d3 e0                	shl    %cl,%eax
  803131:	89 d7                	mov    %edx,%edi
  803133:	89 f1                	mov    %esi,%ecx
  803135:	d3 ef                	shr    %cl,%edi
  803137:	09 c7                	or     %eax,%edi
  803139:	89 e9                	mov    %ebp,%ecx
  80313b:	d3 e2                	shl    %cl,%edx
  80313d:	89 14 24             	mov    %edx,(%esp)
  803140:	89 d8                	mov    %ebx,%eax
  803142:	d3 e0                	shl    %cl,%eax
  803144:	89 c2                	mov    %eax,%edx
  803146:	8b 44 24 08          	mov    0x8(%esp),%eax
  80314a:	d3 e0                	shl    %cl,%eax
  80314c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803150:	8b 44 24 08          	mov    0x8(%esp),%eax
  803154:	89 f1                	mov    %esi,%ecx
  803156:	d3 e8                	shr    %cl,%eax
  803158:	09 d0                	or     %edx,%eax
  80315a:	d3 eb                	shr    %cl,%ebx
  80315c:	89 da                	mov    %ebx,%edx
  80315e:	f7 f7                	div    %edi
  803160:	89 d3                	mov    %edx,%ebx
  803162:	f7 24 24             	mull   (%esp)
  803165:	89 c6                	mov    %eax,%esi
  803167:	89 d1                	mov    %edx,%ecx
  803169:	39 d3                	cmp    %edx,%ebx
  80316b:	0f 82 87 00 00 00    	jb     8031f8 <__umoddi3+0x134>
  803171:	0f 84 91 00 00 00    	je     803208 <__umoddi3+0x144>
  803177:	8b 54 24 04          	mov    0x4(%esp),%edx
  80317b:	29 f2                	sub    %esi,%edx
  80317d:	19 cb                	sbb    %ecx,%ebx
  80317f:	89 d8                	mov    %ebx,%eax
  803181:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803185:	d3 e0                	shl    %cl,%eax
  803187:	89 e9                	mov    %ebp,%ecx
  803189:	d3 ea                	shr    %cl,%edx
  80318b:	09 d0                	or     %edx,%eax
  80318d:	89 e9                	mov    %ebp,%ecx
  80318f:	d3 eb                	shr    %cl,%ebx
  803191:	89 da                	mov    %ebx,%edx
  803193:	83 c4 1c             	add    $0x1c,%esp
  803196:	5b                   	pop    %ebx
  803197:	5e                   	pop    %esi
  803198:	5f                   	pop    %edi
  803199:	5d                   	pop    %ebp
  80319a:	c3                   	ret    
  80319b:	90                   	nop
  80319c:	89 fd                	mov    %edi,%ebp
  80319e:	85 ff                	test   %edi,%edi
  8031a0:	75 0b                	jne    8031ad <__umoddi3+0xe9>
  8031a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8031a7:	31 d2                	xor    %edx,%edx
  8031a9:	f7 f7                	div    %edi
  8031ab:	89 c5                	mov    %eax,%ebp
  8031ad:	89 f0                	mov    %esi,%eax
  8031af:	31 d2                	xor    %edx,%edx
  8031b1:	f7 f5                	div    %ebp
  8031b3:	89 c8                	mov    %ecx,%eax
  8031b5:	f7 f5                	div    %ebp
  8031b7:	89 d0                	mov    %edx,%eax
  8031b9:	e9 44 ff ff ff       	jmp    803102 <__umoddi3+0x3e>
  8031be:	66 90                	xchg   %ax,%ax
  8031c0:	89 c8                	mov    %ecx,%eax
  8031c2:	89 f2                	mov    %esi,%edx
  8031c4:	83 c4 1c             	add    $0x1c,%esp
  8031c7:	5b                   	pop    %ebx
  8031c8:	5e                   	pop    %esi
  8031c9:	5f                   	pop    %edi
  8031ca:	5d                   	pop    %ebp
  8031cb:	c3                   	ret    
  8031cc:	3b 04 24             	cmp    (%esp),%eax
  8031cf:	72 06                	jb     8031d7 <__umoddi3+0x113>
  8031d1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8031d5:	77 0f                	ja     8031e6 <__umoddi3+0x122>
  8031d7:	89 f2                	mov    %esi,%edx
  8031d9:	29 f9                	sub    %edi,%ecx
  8031db:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8031df:	89 14 24             	mov    %edx,(%esp)
  8031e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031e6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8031ea:	8b 14 24             	mov    (%esp),%edx
  8031ed:	83 c4 1c             	add    $0x1c,%esp
  8031f0:	5b                   	pop    %ebx
  8031f1:	5e                   	pop    %esi
  8031f2:	5f                   	pop    %edi
  8031f3:	5d                   	pop    %ebp
  8031f4:	c3                   	ret    
  8031f5:	8d 76 00             	lea    0x0(%esi),%esi
  8031f8:	2b 04 24             	sub    (%esp),%eax
  8031fb:	19 fa                	sbb    %edi,%edx
  8031fd:	89 d1                	mov    %edx,%ecx
  8031ff:	89 c6                	mov    %eax,%esi
  803201:	e9 71 ff ff ff       	jmp    803177 <__umoddi3+0xb3>
  803206:	66 90                	xchg   %ax,%ax
  803208:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80320c:	72 ea                	jb     8031f8 <__umoddi3+0x134>
  80320e:	89 d9                	mov    %ebx,%ecx
  803210:	e9 62 ff ff ff       	jmp    803177 <__umoddi3+0xb3>
