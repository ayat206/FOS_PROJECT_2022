
obj/user/MidTermEx_ProcessA:     file format elf32-i386


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
  800031:	e8 36 01 00 00       	call   80016c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 d0 19 00 00       	call   801a13 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 a0 31 80 00       	push   $0x8031a0
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 b0 14 00 00       	call   801506 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 a2 31 80 00       	push   $0x8031a2
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 9a 14 00 00       	call   801506 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 a9 31 80 00       	push   $0x8031a9
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 84 14 00 00       	call   801506 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Y ;
	//random delay
	delay = RAND(2000, 10000);
  800088:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	50                   	push   %eax
  80008f:	e8 b2 19 00 00       	call   801a46 <sys_get_virtual_time>
  800094:	83 c4 0c             	add    $0xc,%esp
  800097:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80009a:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80009f:	ba 00 00 00 00       	mov    $0x0,%edx
  8000a4:	f7 f1                	div    %ecx
  8000a6:	89 d0                	mov    %edx,%eax
  8000a8:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	50                   	push   %eax
  8000b7:	e8 e6 2b 00 00       	call   802ca2 <env_sleep>
  8000bc:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	Y = (*X) * 2 ;
  8000bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c2:	8b 00                	mov    (%eax),%eax
  8000c4:	01 c0                	add    %eax,%eax
  8000c6:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  8000c9:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 71 19 00 00       	call   801a46 <sys_get_virtual_time>
  8000d5:	83 c4 0c             	add    $0xc,%esp
  8000d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000db:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e5:	f7 f1                	div    %ecx
  8000e7:	89 d0                	mov    %edx,%eax
  8000e9:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	50                   	push   %eax
  8000f8:	e8 a5 2b 00 00       	call   802ca2 <env_sleep>
  8000fd:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	(*X) = Y ;
  800100:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800103:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800106:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800108:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 32 19 00 00       	call   801a46 <sys_get_virtual_time>
  800114:	83 c4 0c             	add    $0xc,%esp
  800117:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80011a:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80011f:	ba 00 00 00 00       	mov    $0x0,%edx
  800124:	f7 f1                	div    %ecx
  800126:	89 d0                	mov    %edx,%eax
  800128:	05 d0 07 00 00       	add    $0x7d0,%eax
  80012d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  800130:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	50                   	push   %eax
  800137:	e8 66 2b 00 00       	call   802ca2 <env_sleep>
  80013c:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	if (*useSem == 1)
  80013f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800142:	8b 00                	mov    (%eax),%eax
  800144:	83 f8 01             	cmp    $0x1,%eax
  800147:	75 13                	jne    80015c <_main+0x124>
	{
		sys_signalSemaphore(parentenvID, "T") ;
  800149:	83 ec 08             	sub    $0x8,%esp
  80014c:	68 b7 31 80 00       	push   $0x8031b7
  800151:	ff 75 f4             	pushl  -0xc(%ebp)
  800154:	e8 79 17 00 00       	call   8018d2 <sys_signalSemaphore>
  800159:	83 c4 10             	add    $0x10,%esp
	}

	/*[3] DECLARE FINISHING*/
	(*finishedCount)++ ;
  80015c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015f:	8b 00                	mov    (%eax),%eax
  800161:	8d 50 01             	lea    0x1(%eax),%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	89 10                	mov    %edx,(%eax)

}
  800169:	90                   	nop
  80016a:	c9                   	leave  
  80016b:	c3                   	ret    

0080016c <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800172:	e8 83 18 00 00       	call   8019fa <sys_getenvindex>
  800177:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80017a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80017d:	89 d0                	mov    %edx,%eax
  80017f:	c1 e0 03             	shl    $0x3,%eax
  800182:	01 d0                	add    %edx,%eax
  800184:	01 c0                	add    %eax,%eax
  800186:	01 d0                	add    %edx,%eax
  800188:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80018f:	01 d0                	add    %edx,%eax
  800191:	c1 e0 04             	shl    $0x4,%eax
  800194:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800199:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80019e:	a1 20 40 80 00       	mov    0x804020,%eax
  8001a3:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001a9:	84 c0                	test   %al,%al
  8001ab:	74 0f                	je     8001bc <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001ad:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b2:	05 5c 05 00 00       	add    $0x55c,%eax
  8001b7:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001c0:	7e 0a                	jle    8001cc <libmain+0x60>
		binaryname = argv[0];
  8001c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c5:	8b 00                	mov    (%eax),%eax
  8001c7:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001cc:	83 ec 08             	sub    $0x8,%esp
  8001cf:	ff 75 0c             	pushl  0xc(%ebp)
  8001d2:	ff 75 08             	pushl  0x8(%ebp)
  8001d5:	e8 5e fe ff ff       	call   800038 <_main>
  8001da:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001dd:	e8 25 16 00 00       	call   801807 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001e2:	83 ec 0c             	sub    $0xc,%esp
  8001e5:	68 d4 31 80 00       	push   $0x8031d4
  8001ea:	e8 8d 01 00 00       	call   80037c <cprintf>
  8001ef:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001f2:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f7:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001fd:	a1 20 40 80 00       	mov    0x804020,%eax
  800202:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800208:	83 ec 04             	sub    $0x4,%esp
  80020b:	52                   	push   %edx
  80020c:	50                   	push   %eax
  80020d:	68 fc 31 80 00       	push   $0x8031fc
  800212:	e8 65 01 00 00       	call   80037c <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80021a:	a1 20 40 80 00       	mov    0x804020,%eax
  80021f:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800225:	a1 20 40 80 00       	mov    0x804020,%eax
  80022a:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800230:	a1 20 40 80 00       	mov    0x804020,%eax
  800235:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80023b:	51                   	push   %ecx
  80023c:	52                   	push   %edx
  80023d:	50                   	push   %eax
  80023e:	68 24 32 80 00       	push   $0x803224
  800243:	e8 34 01 00 00       	call   80037c <cprintf>
  800248:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024b:	a1 20 40 80 00       	mov    0x804020,%eax
  800250:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800256:	83 ec 08             	sub    $0x8,%esp
  800259:	50                   	push   %eax
  80025a:	68 7c 32 80 00       	push   $0x80327c
  80025f:	e8 18 01 00 00       	call   80037c <cprintf>
  800264:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	68 d4 31 80 00       	push   $0x8031d4
  80026f:	e8 08 01 00 00       	call   80037c <cprintf>
  800274:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800277:	e8 a5 15 00 00       	call   801821 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80027c:	e8 19 00 00 00       	call   80029a <exit>
}
  800281:	90                   	nop
  800282:	c9                   	leave  
  800283:	c3                   	ret    

00800284 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800284:	55                   	push   %ebp
  800285:	89 e5                	mov    %esp,%ebp
  800287:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	6a 00                	push   $0x0
  80028f:	e8 32 17 00 00       	call   8019c6 <sys_destroy_env>
  800294:	83 c4 10             	add    $0x10,%esp
}
  800297:	90                   	nop
  800298:	c9                   	leave  
  800299:	c3                   	ret    

0080029a <exit>:

void
exit(void)
{
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002a0:	e8 87 17 00 00       	call   801a2c <sys_exit_env>
}
  8002a5:	90                   	nop
  8002a6:	c9                   	leave  
  8002a7:	c3                   	ret    

008002a8 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b1:	8b 00                	mov    (%eax),%eax
  8002b3:	8d 48 01             	lea    0x1(%eax),%ecx
  8002b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b9:	89 0a                	mov    %ecx,(%edx)
  8002bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002be:	88 d1                	mov    %dl,%cl
  8002c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ca:	8b 00                	mov    (%eax),%eax
  8002cc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d1:	75 2c                	jne    8002ff <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002d3:	a0 24 40 80 00       	mov    0x804024,%al
  8002d8:	0f b6 c0             	movzbl %al,%eax
  8002db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002de:	8b 12                	mov    (%edx),%edx
  8002e0:	89 d1                	mov    %edx,%ecx
  8002e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e5:	83 c2 08             	add    $0x8,%edx
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	50                   	push   %eax
  8002ec:	51                   	push   %ecx
  8002ed:	52                   	push   %edx
  8002ee:	e8 66 13 00 00       	call   801659 <sys_cputs>
  8002f3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800302:	8b 40 04             	mov    0x4(%eax),%eax
  800305:	8d 50 01             	lea    0x1(%eax),%edx
  800308:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80030e:	90                   	nop
  80030f:	c9                   	leave  
  800310:	c3                   	ret    

00800311 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80031a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800321:	00 00 00 
	b.cnt = 0;
  800324:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80032b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80032e:	ff 75 0c             	pushl  0xc(%ebp)
  800331:	ff 75 08             	pushl  0x8(%ebp)
  800334:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80033a:	50                   	push   %eax
  80033b:	68 a8 02 80 00       	push   $0x8002a8
  800340:	e8 11 02 00 00       	call   800556 <vprintfmt>
  800345:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800348:	a0 24 40 80 00       	mov    0x804024,%al
  80034d:	0f b6 c0             	movzbl %al,%eax
  800350:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	50                   	push   %eax
  80035a:	52                   	push   %edx
  80035b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800361:	83 c0 08             	add    $0x8,%eax
  800364:	50                   	push   %eax
  800365:	e8 ef 12 00 00       	call   801659 <sys_cputs>
  80036a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80036d:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800374:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <cprintf>:

int cprintf(const char *fmt, ...) {
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800382:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800389:	8d 45 0c             	lea    0xc(%ebp),%eax
  80038c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	83 ec 08             	sub    $0x8,%esp
  800395:	ff 75 f4             	pushl  -0xc(%ebp)
  800398:	50                   	push   %eax
  800399:	e8 73 ff ff ff       	call   800311 <vcprintf>
  80039e:	83 c4 10             	add    $0x10,%esp
  8003a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a7:	c9                   	leave  
  8003a8:	c3                   	ret    

008003a9 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8003a9:	55                   	push   %ebp
  8003aa:	89 e5                	mov    %esp,%ebp
  8003ac:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8003af:	e8 53 14 00 00       	call   801807 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003b4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bd:	83 ec 08             	sub    $0x8,%esp
  8003c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c3:	50                   	push   %eax
  8003c4:	e8 48 ff ff ff       	call   800311 <vcprintf>
  8003c9:	83 c4 10             	add    $0x10,%esp
  8003cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8003cf:	e8 4d 14 00 00       	call   801821 <sys_enable_interrupt>
	return cnt;
  8003d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003d7:	c9                   	leave  
  8003d8:	c3                   	ret    

008003d9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	53                   	push   %ebx
  8003dd:	83 ec 14             	sub    $0x14,%esp
  8003e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003ec:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003f7:	77 55                	ja     80044e <printnum+0x75>
  8003f9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003fc:	72 05                	jb     800403 <printnum+0x2a>
  8003fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800401:	77 4b                	ja     80044e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800403:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800406:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800409:	8b 45 18             	mov    0x18(%ebp),%eax
  80040c:	ba 00 00 00 00       	mov    $0x0,%edx
  800411:	52                   	push   %edx
  800412:	50                   	push   %eax
  800413:	ff 75 f4             	pushl  -0xc(%ebp)
  800416:	ff 75 f0             	pushl  -0x10(%ebp)
  800419:	e8 1a 2b 00 00       	call   802f38 <__udivdi3>
  80041e:	83 c4 10             	add    $0x10,%esp
  800421:	83 ec 04             	sub    $0x4,%esp
  800424:	ff 75 20             	pushl  0x20(%ebp)
  800427:	53                   	push   %ebx
  800428:	ff 75 18             	pushl  0x18(%ebp)
  80042b:	52                   	push   %edx
  80042c:	50                   	push   %eax
  80042d:	ff 75 0c             	pushl  0xc(%ebp)
  800430:	ff 75 08             	pushl  0x8(%ebp)
  800433:	e8 a1 ff ff ff       	call   8003d9 <printnum>
  800438:	83 c4 20             	add    $0x20,%esp
  80043b:	eb 1a                	jmp    800457 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80043d:	83 ec 08             	sub    $0x8,%esp
  800440:	ff 75 0c             	pushl  0xc(%ebp)
  800443:	ff 75 20             	pushl  0x20(%ebp)
  800446:	8b 45 08             	mov    0x8(%ebp),%eax
  800449:	ff d0                	call   *%eax
  80044b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80044e:	ff 4d 1c             	decl   0x1c(%ebp)
  800451:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800455:	7f e6                	jg     80043d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800457:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80045a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80045f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800462:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800465:	53                   	push   %ebx
  800466:	51                   	push   %ecx
  800467:	52                   	push   %edx
  800468:	50                   	push   %eax
  800469:	e8 da 2b 00 00       	call   803048 <__umoddi3>
  80046e:	83 c4 10             	add    $0x10,%esp
  800471:	05 b4 34 80 00       	add    $0x8034b4,%eax
  800476:	8a 00                	mov    (%eax),%al
  800478:	0f be c0             	movsbl %al,%eax
  80047b:	83 ec 08             	sub    $0x8,%esp
  80047e:	ff 75 0c             	pushl  0xc(%ebp)
  800481:	50                   	push   %eax
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	ff d0                	call   *%eax
  800487:	83 c4 10             	add    $0x10,%esp
}
  80048a:	90                   	nop
  80048b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80048e:	c9                   	leave  
  80048f:	c3                   	ret    

00800490 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800493:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800497:	7e 1c                	jle    8004b5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	8d 50 08             	lea    0x8(%eax),%edx
  8004a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a4:	89 10                	mov    %edx,(%eax)
  8004a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	83 e8 08             	sub    $0x8,%eax
  8004ae:	8b 50 04             	mov    0x4(%eax),%edx
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	eb 40                	jmp    8004f5 <getuint+0x65>
	else if (lflag)
  8004b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004b9:	74 1e                	je     8004d9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	8b 00                	mov    (%eax),%eax
  8004c0:	8d 50 04             	lea    0x4(%eax),%edx
  8004c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c6:	89 10                	mov    %edx,(%eax)
  8004c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cb:	8b 00                	mov    (%eax),%eax
  8004cd:	83 e8 04             	sub    $0x4,%eax
  8004d0:	8b 00                	mov    (%eax),%eax
  8004d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d7:	eb 1c                	jmp    8004f5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dc:	8b 00                	mov    (%eax),%eax
  8004de:	8d 50 04             	lea    0x4(%eax),%edx
  8004e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e4:	89 10                	mov    %edx,(%eax)
  8004e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e9:	8b 00                	mov    (%eax),%eax
  8004eb:	83 e8 04             	sub    $0x4,%eax
  8004ee:	8b 00                	mov    (%eax),%eax
  8004f0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004f5:	5d                   	pop    %ebp
  8004f6:	c3                   	ret    

008004f7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004f7:	55                   	push   %ebp
  8004f8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004fa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004fe:	7e 1c                	jle    80051c <getint+0x25>
		return va_arg(*ap, long long);
  800500:	8b 45 08             	mov    0x8(%ebp),%eax
  800503:	8b 00                	mov    (%eax),%eax
  800505:	8d 50 08             	lea    0x8(%eax),%edx
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	89 10                	mov    %edx,(%eax)
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	83 e8 08             	sub    $0x8,%eax
  800515:	8b 50 04             	mov    0x4(%eax),%edx
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	eb 38                	jmp    800554 <getint+0x5d>
	else if (lflag)
  80051c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800520:	74 1a                	je     80053c <getint+0x45>
		return va_arg(*ap, long);
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	8b 00                	mov    (%eax),%eax
  800527:	8d 50 04             	lea    0x4(%eax),%edx
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	89 10                	mov    %edx,(%eax)
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	8b 00                	mov    (%eax),%eax
  800534:	83 e8 04             	sub    $0x4,%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	99                   	cltd   
  80053a:	eb 18                	jmp    800554 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80053c:	8b 45 08             	mov    0x8(%ebp),%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	8d 50 04             	lea    0x4(%eax),%edx
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	89 10                	mov    %edx,(%eax)
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	8b 00                	mov    (%eax),%eax
  80054e:	83 e8 04             	sub    $0x4,%eax
  800551:	8b 00                	mov    (%eax),%eax
  800553:	99                   	cltd   
}
  800554:	5d                   	pop    %ebp
  800555:	c3                   	ret    

00800556 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800556:	55                   	push   %ebp
  800557:	89 e5                	mov    %esp,%ebp
  800559:	56                   	push   %esi
  80055a:	53                   	push   %ebx
  80055b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80055e:	eb 17                	jmp    800577 <vprintfmt+0x21>
			if (ch == '\0')
  800560:	85 db                	test   %ebx,%ebx
  800562:	0f 84 af 03 00 00    	je     800917 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800568:	83 ec 08             	sub    $0x8,%esp
  80056b:	ff 75 0c             	pushl  0xc(%ebp)
  80056e:	53                   	push   %ebx
  80056f:	8b 45 08             	mov    0x8(%ebp),%eax
  800572:	ff d0                	call   *%eax
  800574:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800577:	8b 45 10             	mov    0x10(%ebp),%eax
  80057a:	8d 50 01             	lea    0x1(%eax),%edx
  80057d:	89 55 10             	mov    %edx,0x10(%ebp)
  800580:	8a 00                	mov    (%eax),%al
  800582:	0f b6 d8             	movzbl %al,%ebx
  800585:	83 fb 25             	cmp    $0x25,%ebx
  800588:	75 d6                	jne    800560 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80058a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80058e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800595:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80059c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005a3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ad:	8d 50 01             	lea    0x1(%eax),%edx
  8005b0:	89 55 10             	mov    %edx,0x10(%ebp)
  8005b3:	8a 00                	mov    (%eax),%al
  8005b5:	0f b6 d8             	movzbl %al,%ebx
  8005b8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005bb:	83 f8 55             	cmp    $0x55,%eax
  8005be:	0f 87 2b 03 00 00    	ja     8008ef <vprintfmt+0x399>
  8005c4:	8b 04 85 d8 34 80 00 	mov    0x8034d8(,%eax,4),%eax
  8005cb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005cd:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005d1:	eb d7                	jmp    8005aa <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005d3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005d7:	eb d1                	jmp    8005aa <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e3:	89 d0                	mov    %edx,%eax
  8005e5:	c1 e0 02             	shl    $0x2,%eax
  8005e8:	01 d0                	add    %edx,%eax
  8005ea:	01 c0                	add    %eax,%eax
  8005ec:	01 d8                	add    %ebx,%eax
  8005ee:	83 e8 30             	sub    $0x30,%eax
  8005f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f7:	8a 00                	mov    (%eax),%al
  8005f9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005fc:	83 fb 2f             	cmp    $0x2f,%ebx
  8005ff:	7e 3e                	jle    80063f <vprintfmt+0xe9>
  800601:	83 fb 39             	cmp    $0x39,%ebx
  800604:	7f 39                	jg     80063f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800606:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800609:	eb d5                	jmp    8005e0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	83 c0 04             	add    $0x4,%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
  800614:	8b 45 14             	mov    0x14(%ebp),%eax
  800617:	83 e8 04             	sub    $0x4,%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80061f:	eb 1f                	jmp    800640 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800621:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800625:	79 83                	jns    8005aa <vprintfmt+0x54>
				width = 0;
  800627:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80062e:	e9 77 ff ff ff       	jmp    8005aa <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800633:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80063a:	e9 6b ff ff ff       	jmp    8005aa <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80063f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800640:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800644:	0f 89 60 ff ff ff    	jns    8005aa <vprintfmt+0x54>
				width = precision, precision = -1;
  80064a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80064d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800650:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800657:	e9 4e ff ff ff       	jmp    8005aa <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80065c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80065f:	e9 46 ff ff ff       	jmp    8005aa <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	83 c0 04             	add    $0x4,%eax
  80066a:	89 45 14             	mov    %eax,0x14(%ebp)
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	83 e8 04             	sub    $0x4,%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	83 ec 08             	sub    $0x8,%esp
  800678:	ff 75 0c             	pushl  0xc(%ebp)
  80067b:	50                   	push   %eax
  80067c:	8b 45 08             	mov    0x8(%ebp),%eax
  80067f:	ff d0                	call   *%eax
  800681:	83 c4 10             	add    $0x10,%esp
			break;
  800684:	e9 89 02 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	83 c0 04             	add    $0x4,%eax
  80068f:	89 45 14             	mov    %eax,0x14(%ebp)
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	83 e8 04             	sub    $0x4,%eax
  800698:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80069a:	85 db                	test   %ebx,%ebx
  80069c:	79 02                	jns    8006a0 <vprintfmt+0x14a>
				err = -err;
  80069e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006a0:	83 fb 64             	cmp    $0x64,%ebx
  8006a3:	7f 0b                	jg     8006b0 <vprintfmt+0x15a>
  8006a5:	8b 34 9d 20 33 80 00 	mov    0x803320(,%ebx,4),%esi
  8006ac:	85 f6                	test   %esi,%esi
  8006ae:	75 19                	jne    8006c9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006b0:	53                   	push   %ebx
  8006b1:	68 c5 34 80 00       	push   $0x8034c5
  8006b6:	ff 75 0c             	pushl  0xc(%ebp)
  8006b9:	ff 75 08             	pushl  0x8(%ebp)
  8006bc:	e8 5e 02 00 00       	call   80091f <printfmt>
  8006c1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006c4:	e9 49 02 00 00       	jmp    800912 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006c9:	56                   	push   %esi
  8006ca:	68 ce 34 80 00       	push   $0x8034ce
  8006cf:	ff 75 0c             	pushl  0xc(%ebp)
  8006d2:	ff 75 08             	pushl  0x8(%ebp)
  8006d5:	e8 45 02 00 00       	call   80091f <printfmt>
  8006da:	83 c4 10             	add    $0x10,%esp
			break;
  8006dd:	e9 30 02 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	83 c0 04             	add    $0x4,%eax
  8006e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	83 e8 04             	sub    $0x4,%eax
  8006f1:	8b 30                	mov    (%eax),%esi
  8006f3:	85 f6                	test   %esi,%esi
  8006f5:	75 05                	jne    8006fc <vprintfmt+0x1a6>
				p = "(null)";
  8006f7:	be d1 34 80 00       	mov    $0x8034d1,%esi
			if (width > 0 && padc != '-')
  8006fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800700:	7e 6d                	jle    80076f <vprintfmt+0x219>
  800702:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800706:	74 67                	je     80076f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800708:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80070b:	83 ec 08             	sub    $0x8,%esp
  80070e:	50                   	push   %eax
  80070f:	56                   	push   %esi
  800710:	e8 0c 03 00 00       	call   800a21 <strnlen>
  800715:	83 c4 10             	add    $0x10,%esp
  800718:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80071b:	eb 16                	jmp    800733 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80071d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	ff 75 0c             	pushl  0xc(%ebp)
  800727:	50                   	push   %eax
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	ff d0                	call   *%eax
  80072d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800730:	ff 4d e4             	decl   -0x1c(%ebp)
  800733:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800737:	7f e4                	jg     80071d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800739:	eb 34                	jmp    80076f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80073b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80073f:	74 1c                	je     80075d <vprintfmt+0x207>
  800741:	83 fb 1f             	cmp    $0x1f,%ebx
  800744:	7e 05                	jle    80074b <vprintfmt+0x1f5>
  800746:	83 fb 7e             	cmp    $0x7e,%ebx
  800749:	7e 12                	jle    80075d <vprintfmt+0x207>
					putch('?', putdat);
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	ff 75 0c             	pushl  0xc(%ebp)
  800751:	6a 3f                	push   $0x3f
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	ff d0                	call   *%eax
  800758:	83 c4 10             	add    $0x10,%esp
  80075b:	eb 0f                	jmp    80076c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	ff 75 0c             	pushl  0xc(%ebp)
  800763:	53                   	push   %ebx
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	ff d0                	call   *%eax
  800769:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80076c:	ff 4d e4             	decl   -0x1c(%ebp)
  80076f:	89 f0                	mov    %esi,%eax
  800771:	8d 70 01             	lea    0x1(%eax),%esi
  800774:	8a 00                	mov    (%eax),%al
  800776:	0f be d8             	movsbl %al,%ebx
  800779:	85 db                	test   %ebx,%ebx
  80077b:	74 24                	je     8007a1 <vprintfmt+0x24b>
  80077d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800781:	78 b8                	js     80073b <vprintfmt+0x1e5>
  800783:	ff 4d e0             	decl   -0x20(%ebp)
  800786:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80078a:	79 af                	jns    80073b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80078c:	eb 13                	jmp    8007a1 <vprintfmt+0x24b>
				putch(' ', putdat);
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	ff 75 0c             	pushl  0xc(%ebp)
  800794:	6a 20                	push   $0x20
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	ff d0                	call   *%eax
  80079b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80079e:	ff 4d e4             	decl   -0x1c(%ebp)
  8007a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007a5:	7f e7                	jg     80078e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007a7:	e9 66 01 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007ac:	83 ec 08             	sub    $0x8,%esp
  8007af:	ff 75 e8             	pushl  -0x18(%ebp)
  8007b2:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b5:	50                   	push   %eax
  8007b6:	e8 3c fd ff ff       	call   8004f7 <getint>
  8007bb:	83 c4 10             	add    $0x10,%esp
  8007be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ca:	85 d2                	test   %edx,%edx
  8007cc:	79 23                	jns    8007f1 <vprintfmt+0x29b>
				putch('-', putdat);
  8007ce:	83 ec 08             	sub    $0x8,%esp
  8007d1:	ff 75 0c             	pushl  0xc(%ebp)
  8007d4:	6a 2d                	push   $0x2d
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	ff d0                	call   *%eax
  8007db:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e4:	f7 d8                	neg    %eax
  8007e6:	83 d2 00             	adc    $0x0,%edx
  8007e9:	f7 da                	neg    %edx
  8007eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ee:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007f1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007f8:	e9 bc 00 00 00       	jmp    8008b9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	ff 75 e8             	pushl  -0x18(%ebp)
  800803:	8d 45 14             	lea    0x14(%ebp),%eax
  800806:	50                   	push   %eax
  800807:	e8 84 fc ff ff       	call   800490 <getuint>
  80080c:	83 c4 10             	add    $0x10,%esp
  80080f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800812:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800815:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80081c:	e9 98 00 00 00       	jmp    8008b9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800821:	83 ec 08             	sub    $0x8,%esp
  800824:	ff 75 0c             	pushl  0xc(%ebp)
  800827:	6a 58                	push   $0x58
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	ff d0                	call   *%eax
  80082e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800831:	83 ec 08             	sub    $0x8,%esp
  800834:	ff 75 0c             	pushl  0xc(%ebp)
  800837:	6a 58                	push   $0x58
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	ff d0                	call   *%eax
  80083e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	ff 75 0c             	pushl  0xc(%ebp)
  800847:	6a 58                	push   $0x58
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	ff d0                	call   *%eax
  80084e:	83 c4 10             	add    $0x10,%esp
			break;
  800851:	e9 bc 00 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800856:	83 ec 08             	sub    $0x8,%esp
  800859:	ff 75 0c             	pushl  0xc(%ebp)
  80085c:	6a 30                	push   $0x30
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	ff d0                	call   *%eax
  800863:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	ff 75 0c             	pushl  0xc(%ebp)
  80086c:	6a 78                	push   $0x78
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	ff d0                	call   *%eax
  800873:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	83 c0 04             	add    $0x4,%eax
  80087c:	89 45 14             	mov    %eax,0x14(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800887:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80088a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800891:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800898:	eb 1f                	jmp    8008b9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80089a:	83 ec 08             	sub    $0x8,%esp
  80089d:	ff 75 e8             	pushl  -0x18(%ebp)
  8008a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a3:	50                   	push   %eax
  8008a4:	e8 e7 fb ff ff       	call   800490 <getuint>
  8008a9:	83 c4 10             	add    $0x10,%esp
  8008ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008af:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008b2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008b9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c0:	83 ec 04             	sub    $0x4,%esp
  8008c3:	52                   	push   %edx
  8008c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008c7:	50                   	push   %eax
  8008c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8008cb:	ff 75 f0             	pushl  -0x10(%ebp)
  8008ce:	ff 75 0c             	pushl  0xc(%ebp)
  8008d1:	ff 75 08             	pushl  0x8(%ebp)
  8008d4:	e8 00 fb ff ff       	call   8003d9 <printnum>
  8008d9:	83 c4 20             	add    $0x20,%esp
			break;
  8008dc:	eb 34                	jmp    800912 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008de:	83 ec 08             	sub    $0x8,%esp
  8008e1:	ff 75 0c             	pushl  0xc(%ebp)
  8008e4:	53                   	push   %ebx
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	ff d0                	call   *%eax
  8008ea:	83 c4 10             	add    $0x10,%esp
			break;
  8008ed:	eb 23                	jmp    800912 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	ff 75 0c             	pushl  0xc(%ebp)
  8008f5:	6a 25                	push   $0x25
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	ff d0                	call   *%eax
  8008fc:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008ff:	ff 4d 10             	decl   0x10(%ebp)
  800902:	eb 03                	jmp    800907 <vprintfmt+0x3b1>
  800904:	ff 4d 10             	decl   0x10(%ebp)
  800907:	8b 45 10             	mov    0x10(%ebp),%eax
  80090a:	48                   	dec    %eax
  80090b:	8a 00                	mov    (%eax),%al
  80090d:	3c 25                	cmp    $0x25,%al
  80090f:	75 f3                	jne    800904 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800911:	90                   	nop
		}
	}
  800912:	e9 47 fc ff ff       	jmp    80055e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800917:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800918:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80091b:	5b                   	pop    %ebx
  80091c:	5e                   	pop    %esi
  80091d:	5d                   	pop    %ebp
  80091e:	c3                   	ret    

0080091f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800925:	8d 45 10             	lea    0x10(%ebp),%eax
  800928:	83 c0 04             	add    $0x4,%eax
  80092b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80092e:	8b 45 10             	mov    0x10(%ebp),%eax
  800931:	ff 75 f4             	pushl  -0xc(%ebp)
  800934:	50                   	push   %eax
  800935:	ff 75 0c             	pushl  0xc(%ebp)
  800938:	ff 75 08             	pushl  0x8(%ebp)
  80093b:	e8 16 fc ff ff       	call   800556 <vprintfmt>
  800940:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800943:	90                   	nop
  800944:	c9                   	leave  
  800945:	c3                   	ret    

00800946 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800949:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094c:	8b 40 08             	mov    0x8(%eax),%eax
  80094f:	8d 50 01             	lea    0x1(%eax),%edx
  800952:	8b 45 0c             	mov    0xc(%ebp),%eax
  800955:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095b:	8b 10                	mov    (%eax),%edx
  80095d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800960:	8b 40 04             	mov    0x4(%eax),%eax
  800963:	39 c2                	cmp    %eax,%edx
  800965:	73 12                	jae    800979 <sprintputch+0x33>
		*b->buf++ = ch;
  800967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096a:	8b 00                	mov    (%eax),%eax
  80096c:	8d 48 01             	lea    0x1(%eax),%ecx
  80096f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800972:	89 0a                	mov    %ecx,(%edx)
  800974:	8b 55 08             	mov    0x8(%ebp),%edx
  800977:	88 10                	mov    %dl,(%eax)
}
  800979:	90                   	nop
  80097a:	5d                   	pop    %ebp
  80097b:	c3                   	ret    

0080097c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800988:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	01 d0                	add    %edx,%eax
  800993:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800996:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80099d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009a1:	74 06                	je     8009a9 <vsnprintf+0x2d>
  8009a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a7:	7f 07                	jg     8009b0 <vsnprintf+0x34>
		return -E_INVAL;
  8009a9:	b8 03 00 00 00       	mov    $0x3,%eax
  8009ae:	eb 20                	jmp    8009d0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009b0:	ff 75 14             	pushl  0x14(%ebp)
  8009b3:	ff 75 10             	pushl  0x10(%ebp)
  8009b6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b9:	50                   	push   %eax
  8009ba:	68 46 09 80 00       	push   $0x800946
  8009bf:	e8 92 fb ff ff       	call   800556 <vprintfmt>
  8009c4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ca:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    

008009d2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009d8:	8d 45 10             	lea    0x10(%ebp),%eax
  8009db:	83 c0 04             	add    $0x4,%eax
  8009de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8009e7:	50                   	push   %eax
  8009e8:	ff 75 0c             	pushl  0xc(%ebp)
  8009eb:	ff 75 08             	pushl  0x8(%ebp)
  8009ee:	e8 89 ff ff ff       	call   80097c <vsnprintf>
  8009f3:	83 c4 10             	add    $0x10,%esp
  8009f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fc:	c9                   	leave  
  8009fd:	c3                   	ret    

008009fe <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009fe:	55                   	push   %ebp
  8009ff:	89 e5                	mov    %esp,%ebp
  800a01:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a0b:	eb 06                	jmp    800a13 <strlen+0x15>
		n++;
  800a0d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a10:	ff 45 08             	incl   0x8(%ebp)
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	8a 00                	mov    (%eax),%al
  800a18:	84 c0                	test   %al,%al
  800a1a:	75 f1                	jne    800a0d <strlen+0xf>
		n++;
	return n;
  800a1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a1f:	c9                   	leave  
  800a20:	c3                   	ret    

00800a21 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a21:	55                   	push   %ebp
  800a22:	89 e5                	mov    %esp,%ebp
  800a24:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a2e:	eb 09                	jmp    800a39 <strnlen+0x18>
		n++;
  800a30:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a33:	ff 45 08             	incl   0x8(%ebp)
  800a36:	ff 4d 0c             	decl   0xc(%ebp)
  800a39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a3d:	74 09                	je     800a48 <strnlen+0x27>
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	8a 00                	mov    (%eax),%al
  800a44:	84 c0                	test   %al,%al
  800a46:	75 e8                	jne    800a30 <strnlen+0xf>
		n++;
	return n;
  800a48:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a4b:	c9                   	leave  
  800a4c:	c3                   	ret    

00800a4d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a59:	90                   	nop
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	8d 50 01             	lea    0x1(%eax),%edx
  800a60:	89 55 08             	mov    %edx,0x8(%ebp)
  800a63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a66:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a69:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a6c:	8a 12                	mov    (%edx),%dl
  800a6e:	88 10                	mov    %dl,(%eax)
  800a70:	8a 00                	mov    (%eax),%al
  800a72:	84 c0                	test   %al,%al
  800a74:	75 e4                	jne    800a5a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a76:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a79:	c9                   	leave  
  800a7a:	c3                   	ret    

00800a7b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a8e:	eb 1f                	jmp    800aaf <strncpy+0x34>
		*dst++ = *src;
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	8d 50 01             	lea    0x1(%eax),%edx
  800a96:	89 55 08             	mov    %edx,0x8(%ebp)
  800a99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9c:	8a 12                	mov    (%edx),%dl
  800a9e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa3:	8a 00                	mov    (%eax),%al
  800aa5:	84 c0                	test   %al,%al
  800aa7:	74 03                	je     800aac <strncpy+0x31>
			src++;
  800aa9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aac:	ff 45 fc             	incl   -0x4(%ebp)
  800aaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ab2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ab5:	72 d9                	jb     800a90 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ab7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800aba:	c9                   	leave  
  800abb:	c3                   	ret    

00800abc <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ac8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800acc:	74 30                	je     800afe <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ace:	eb 16                	jmp    800ae6 <strlcpy+0x2a>
			*dst++ = *src++;
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	8d 50 01             	lea    0x1(%eax),%edx
  800ad6:	89 55 08             	mov    %edx,0x8(%ebp)
  800ad9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800adf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ae2:	8a 12                	mov    (%edx),%dl
  800ae4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ae6:	ff 4d 10             	decl   0x10(%ebp)
  800ae9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aed:	74 09                	je     800af8 <strlcpy+0x3c>
  800aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af2:	8a 00                	mov    (%eax),%al
  800af4:	84 c0                	test   %al,%al
  800af6:	75 d8                	jne    800ad0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800afe:	8b 55 08             	mov    0x8(%ebp),%edx
  800b01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b04:	29 c2                	sub    %eax,%edx
  800b06:	89 d0                	mov    %edx,%eax
}
  800b08:	c9                   	leave  
  800b09:	c3                   	ret    

00800b0a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b0d:	eb 06                	jmp    800b15 <strcmp+0xb>
		p++, q++;
  800b0f:	ff 45 08             	incl   0x8(%ebp)
  800b12:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	8a 00                	mov    (%eax),%al
  800b1a:	84 c0                	test   %al,%al
  800b1c:	74 0e                	je     800b2c <strcmp+0x22>
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8a 10                	mov    (%eax),%dl
  800b23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b26:	8a 00                	mov    (%eax),%al
  800b28:	38 c2                	cmp    %al,%dl
  800b2a:	74 e3                	je     800b0f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	8a 00                	mov    (%eax),%al
  800b31:	0f b6 d0             	movzbl %al,%edx
  800b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b37:	8a 00                	mov    (%eax),%al
  800b39:	0f b6 c0             	movzbl %al,%eax
  800b3c:	29 c2                	sub    %eax,%edx
  800b3e:	89 d0                	mov    %edx,%eax
}
  800b40:	5d                   	pop    %ebp
  800b41:	c3                   	ret    

00800b42 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b45:	eb 09                	jmp    800b50 <strncmp+0xe>
		n--, p++, q++;
  800b47:	ff 4d 10             	decl   0x10(%ebp)
  800b4a:	ff 45 08             	incl   0x8(%ebp)
  800b4d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b54:	74 17                	je     800b6d <strncmp+0x2b>
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8a 00                	mov    (%eax),%al
  800b5b:	84 c0                	test   %al,%al
  800b5d:	74 0e                	je     800b6d <strncmp+0x2b>
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	8a 10                	mov    (%eax),%dl
  800b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b67:	8a 00                	mov    (%eax),%al
  800b69:	38 c2                	cmp    %al,%dl
  800b6b:	74 da                	je     800b47 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b6d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b71:	75 07                	jne    800b7a <strncmp+0x38>
		return 0;
  800b73:	b8 00 00 00 00       	mov    $0x0,%eax
  800b78:	eb 14                	jmp    800b8e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	8a 00                	mov    (%eax),%al
  800b7f:	0f b6 d0             	movzbl %al,%edx
  800b82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b85:	8a 00                	mov    (%eax),%al
  800b87:	0f b6 c0             	movzbl %al,%eax
  800b8a:	29 c2                	sub    %eax,%edx
  800b8c:	89 d0                	mov    %edx,%eax
}
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	83 ec 04             	sub    $0x4,%esp
  800b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b99:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b9c:	eb 12                	jmp    800bb0 <strchr+0x20>
		if (*s == c)
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	8a 00                	mov    (%eax),%al
  800ba3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba6:	75 05                	jne    800bad <strchr+0x1d>
			return (char *) s;
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	eb 11                	jmp    800bbe <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bad:	ff 45 08             	incl   0x8(%ebp)
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	8a 00                	mov    (%eax),%al
  800bb5:	84 c0                	test   %al,%al
  800bb7:	75 e5                	jne    800b9e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 04             	sub    $0x4,%esp
  800bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bcc:	eb 0d                	jmp    800bdb <strfind+0x1b>
		if (*s == c)
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	8a 00                	mov    (%eax),%al
  800bd3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bd6:	74 0e                	je     800be6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bd8:	ff 45 08             	incl   0x8(%ebp)
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	84 c0                	test   %al,%al
  800be2:	75 ea                	jne    800bce <strfind+0xe>
  800be4:	eb 01                	jmp    800be7 <strfind+0x27>
		if (*s == c)
			break;
  800be6:	90                   	nop
	return (char *) s;
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bf8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bfe:	eb 0e                	jmp    800c0e <memset+0x22>
		*p++ = c;
  800c00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c03:	8d 50 01             	lea    0x1(%eax),%edx
  800c06:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c0e:	ff 4d f8             	decl   -0x8(%ebp)
  800c11:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c15:	79 e9                	jns    800c00 <memset+0x14>
		*p++ = c;

	return v;
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c1a:	c9                   	leave  
  800c1b:	c3                   	ret    

00800c1c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c2e:	eb 16                	jmp    800c46 <memcpy+0x2a>
		*d++ = *s++;
  800c30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c33:	8d 50 01             	lea    0x1(%eax),%edx
  800c36:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c3c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c3f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c42:	8a 12                	mov    (%edx),%dl
  800c44:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c46:	8b 45 10             	mov    0x10(%ebp),%eax
  800c49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800c4f:	85 c0                	test   %eax,%eax
  800c51:	75 dd                	jne    800c30 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c56:	c9                   	leave  
  800c57:	c3                   	ret    

00800c58 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c64:	8b 45 08             	mov    0x8(%ebp),%eax
  800c67:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c70:	73 50                	jae    800cc2 <memmove+0x6a>
  800c72:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c75:	8b 45 10             	mov    0x10(%ebp),%eax
  800c78:	01 d0                	add    %edx,%eax
  800c7a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c7d:	76 43                	jbe    800cc2 <memmove+0x6a>
		s += n;
  800c7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c82:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c85:	8b 45 10             	mov    0x10(%ebp),%eax
  800c88:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c8b:	eb 10                	jmp    800c9d <memmove+0x45>
			*--d = *--s;
  800c8d:	ff 4d f8             	decl   -0x8(%ebp)
  800c90:	ff 4d fc             	decl   -0x4(%ebp)
  800c93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c96:	8a 10                	mov    (%eax),%dl
  800c98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c9b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca3:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca6:	85 c0                	test   %eax,%eax
  800ca8:	75 e3                	jne    800c8d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800caa:	eb 23                	jmp    800ccf <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800cac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800caf:	8d 50 01             	lea    0x1(%eax),%edx
  800cb2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cb5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cb8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cbb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cbe:	8a 12                	mov    (%edx),%dl
  800cc0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800cc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc8:	89 55 10             	mov    %edx,0x10(%ebp)
  800ccb:	85 c0                	test   %eax,%eax
  800ccd:	75 dd                	jne    800cac <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd2:	c9                   	leave  
  800cd3:	c3                   	ret    

00800cd4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ce6:	eb 2a                	jmp    800d12 <memcmp+0x3e>
		if (*s1 != *s2)
  800ce8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ceb:	8a 10                	mov    (%eax),%dl
  800ced:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cf0:	8a 00                	mov    (%eax),%al
  800cf2:	38 c2                	cmp    %al,%dl
  800cf4:	74 16                	je     800d0c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf9:	8a 00                	mov    (%eax),%al
  800cfb:	0f b6 d0             	movzbl %al,%edx
  800cfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	0f b6 c0             	movzbl %al,%eax
  800d06:	29 c2                	sub    %eax,%edx
  800d08:	89 d0                	mov    %edx,%eax
  800d0a:	eb 18                	jmp    800d24 <memcmp+0x50>
		s1++, s2++;
  800d0c:	ff 45 fc             	incl   -0x4(%ebp)
  800d0f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d12:	8b 45 10             	mov    0x10(%ebp),%eax
  800d15:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d18:	89 55 10             	mov    %edx,0x10(%ebp)
  800d1b:	85 c0                	test   %eax,%eax
  800d1d:	75 c9                	jne    800ce8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d24:	c9                   	leave  
  800d25:	c3                   	ret    

00800d26 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d32:	01 d0                	add    %edx,%eax
  800d34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d37:	eb 15                	jmp    800d4e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	0f b6 d0             	movzbl %al,%edx
  800d41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d44:	0f b6 c0             	movzbl %al,%eax
  800d47:	39 c2                	cmp    %eax,%edx
  800d49:	74 0d                	je     800d58 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d4b:	ff 45 08             	incl   0x8(%ebp)
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d54:	72 e3                	jb     800d39 <memfind+0x13>
  800d56:	eb 01                	jmp    800d59 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d58:	90                   	nop
	return (void *) s;
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d6b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d72:	eb 03                	jmp    800d77 <strtol+0x19>
		s++;
  800d74:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	3c 20                	cmp    $0x20,%al
  800d7e:	74 f4                	je     800d74 <strtol+0x16>
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	3c 09                	cmp    $0x9,%al
  800d87:	74 eb                	je     800d74 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	3c 2b                	cmp    $0x2b,%al
  800d90:	75 05                	jne    800d97 <strtol+0x39>
		s++;
  800d92:	ff 45 08             	incl   0x8(%ebp)
  800d95:	eb 13                	jmp    800daa <strtol+0x4c>
	else if (*s == '-')
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8a 00                	mov    (%eax),%al
  800d9c:	3c 2d                	cmp    $0x2d,%al
  800d9e:	75 0a                	jne    800daa <strtol+0x4c>
		s++, neg = 1;
  800da0:	ff 45 08             	incl   0x8(%ebp)
  800da3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800daa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dae:	74 06                	je     800db6 <strtol+0x58>
  800db0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800db4:	75 20                	jne    800dd6 <strtol+0x78>
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	3c 30                	cmp    $0x30,%al
  800dbd:	75 17                	jne    800dd6 <strtol+0x78>
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	40                   	inc    %eax
  800dc3:	8a 00                	mov    (%eax),%al
  800dc5:	3c 78                	cmp    $0x78,%al
  800dc7:	75 0d                	jne    800dd6 <strtol+0x78>
		s += 2, base = 16;
  800dc9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dcd:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dd4:	eb 28                	jmp    800dfe <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dd6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dda:	75 15                	jne    800df1 <strtol+0x93>
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	3c 30                	cmp    $0x30,%al
  800de3:	75 0c                	jne    800df1 <strtol+0x93>
		s++, base = 8;
  800de5:	ff 45 08             	incl   0x8(%ebp)
  800de8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800def:	eb 0d                	jmp    800dfe <strtol+0xa0>
	else if (base == 0)
  800df1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df5:	75 07                	jne    800dfe <strtol+0xa0>
		base = 10;
  800df7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	3c 2f                	cmp    $0x2f,%al
  800e05:	7e 19                	jle    800e20 <strtol+0xc2>
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8a 00                	mov    (%eax),%al
  800e0c:	3c 39                	cmp    $0x39,%al
  800e0e:	7f 10                	jg     800e20 <strtol+0xc2>
			dig = *s - '0';
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	0f be c0             	movsbl %al,%eax
  800e18:	83 e8 30             	sub    $0x30,%eax
  800e1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e1e:	eb 42                	jmp    800e62 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	3c 60                	cmp    $0x60,%al
  800e27:	7e 19                	jle    800e42 <strtol+0xe4>
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	3c 7a                	cmp    $0x7a,%al
  800e30:	7f 10                	jg     800e42 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	0f be c0             	movsbl %al,%eax
  800e3a:	83 e8 57             	sub    $0x57,%eax
  800e3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e40:	eb 20                	jmp    800e62 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	3c 40                	cmp    $0x40,%al
  800e49:	7e 39                	jle    800e84 <strtol+0x126>
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	8a 00                	mov    (%eax),%al
  800e50:	3c 5a                	cmp    $0x5a,%al
  800e52:	7f 30                	jg     800e84 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	0f be c0             	movsbl %al,%eax
  800e5c:	83 e8 37             	sub    $0x37,%eax
  800e5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e65:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e68:	7d 19                	jge    800e83 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e6a:	ff 45 08             	incl   0x8(%ebp)
  800e6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e70:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e74:	89 c2                	mov    %eax,%edx
  800e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e79:	01 d0                	add    %edx,%eax
  800e7b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e7e:	e9 7b ff ff ff       	jmp    800dfe <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e83:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e88:	74 08                	je     800e92 <strtol+0x134>
		*endptr = (char *) s;
  800e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e90:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e92:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e96:	74 07                	je     800e9f <strtol+0x141>
  800e98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9b:	f7 d8                	neg    %eax
  800e9d:	eb 03                	jmp    800ea2 <strtol+0x144>
  800e9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ea2:	c9                   	leave  
  800ea3:	c3                   	ret    

00800ea4 <ltostr>:

void
ltostr(long value, char *str)
{
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
  800ea7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800eaa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800eb1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800eb8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ebc:	79 13                	jns    800ed1 <ltostr+0x2d>
	{
		neg = 1;
  800ebe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ecb:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ece:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ed9:	99                   	cltd   
  800eda:	f7 f9                	idiv   %ecx
  800edc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800edf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee2:	8d 50 01             	lea    0x1(%eax),%edx
  800ee5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ee8:	89 c2                	mov    %eax,%edx
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	01 d0                	add    %edx,%eax
  800eef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ef2:	83 c2 30             	add    $0x30,%edx
  800ef5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ef7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800efa:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800eff:	f7 e9                	imul   %ecx
  800f01:	c1 fa 02             	sar    $0x2,%edx
  800f04:	89 c8                	mov    %ecx,%eax
  800f06:	c1 f8 1f             	sar    $0x1f,%eax
  800f09:	29 c2                	sub    %eax,%edx
  800f0b:	89 d0                	mov    %edx,%eax
  800f0d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800f10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f13:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f18:	f7 e9                	imul   %ecx
  800f1a:	c1 fa 02             	sar    $0x2,%edx
  800f1d:	89 c8                	mov    %ecx,%eax
  800f1f:	c1 f8 1f             	sar    $0x1f,%eax
  800f22:	29 c2                	sub    %eax,%edx
  800f24:	89 d0                	mov    %edx,%eax
  800f26:	c1 e0 02             	shl    $0x2,%eax
  800f29:	01 d0                	add    %edx,%eax
  800f2b:	01 c0                	add    %eax,%eax
  800f2d:	29 c1                	sub    %eax,%ecx
  800f2f:	89 ca                	mov    %ecx,%edx
  800f31:	85 d2                	test   %edx,%edx
  800f33:	75 9c                	jne    800ed1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3f:	48                   	dec    %eax
  800f40:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f43:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f47:	74 3d                	je     800f86 <ltostr+0xe2>
		start = 1 ;
  800f49:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f50:	eb 34                	jmp    800f86 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f58:	01 d0                	add    %edx,%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	01 c2                	add    %eax,%edx
  800f67:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6d:	01 c8                	add    %ecx,%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f73:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f79:	01 c2                	add    %eax,%edx
  800f7b:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f7e:	88 02                	mov    %al,(%edx)
		start++ ;
  800f80:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f83:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f89:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f8c:	7c c4                	jl     800f52 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f8e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f94:	01 d0                	add    %edx,%eax
  800f96:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f99:	90                   	nop
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800fa2:	ff 75 08             	pushl  0x8(%ebp)
  800fa5:	e8 54 fa ff ff       	call   8009fe <strlen>
  800faa:	83 c4 04             	add    $0x4,%esp
  800fad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800fb0:	ff 75 0c             	pushl  0xc(%ebp)
  800fb3:	e8 46 fa ff ff       	call   8009fe <strlen>
  800fb8:	83 c4 04             	add    $0x4,%esp
  800fbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fcc:	eb 17                	jmp    800fe5 <strcconcat+0x49>
		final[s] = str1[s] ;
  800fce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	01 c2                	add    %eax,%edx
  800fd6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	01 c8                	add    %ecx,%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fe2:	ff 45 fc             	incl   -0x4(%ebp)
  800fe5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800feb:	7c e1                	jl     800fce <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ff4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ffb:	eb 1f                	jmp    80101c <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ffd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801000:	8d 50 01             	lea    0x1(%eax),%edx
  801003:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801006:	89 c2                	mov    %eax,%edx
  801008:	8b 45 10             	mov    0x10(%ebp),%eax
  80100b:	01 c2                	add    %eax,%edx
  80100d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801010:	8b 45 0c             	mov    0xc(%ebp),%eax
  801013:	01 c8                	add    %ecx,%eax
  801015:	8a 00                	mov    (%eax),%al
  801017:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801019:	ff 45 f8             	incl   -0x8(%ebp)
  80101c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801022:	7c d9                	jl     800ffd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801024:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801027:	8b 45 10             	mov    0x10(%ebp),%eax
  80102a:	01 d0                	add    %edx,%eax
  80102c:	c6 00 00             	movb   $0x0,(%eax)
}
  80102f:	90                   	nop
  801030:	c9                   	leave  
  801031:	c3                   	ret    

00801032 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801035:	8b 45 14             	mov    0x14(%ebp),%eax
  801038:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80103e:	8b 45 14             	mov    0x14(%ebp),%eax
  801041:	8b 00                	mov    (%eax),%eax
  801043:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80104a:	8b 45 10             	mov    0x10(%ebp),%eax
  80104d:	01 d0                	add    %edx,%eax
  80104f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801055:	eb 0c                	jmp    801063 <strsplit+0x31>
			*string++ = 0;
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	8d 50 01             	lea    0x1(%eax),%edx
  80105d:	89 55 08             	mov    %edx,0x8(%ebp)
  801060:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	84 c0                	test   %al,%al
  80106a:	74 18                	je     801084 <strsplit+0x52>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	0f be c0             	movsbl %al,%eax
  801074:	50                   	push   %eax
  801075:	ff 75 0c             	pushl  0xc(%ebp)
  801078:	e8 13 fb ff ff       	call   800b90 <strchr>
  80107d:	83 c4 08             	add    $0x8,%esp
  801080:	85 c0                	test   %eax,%eax
  801082:	75 d3                	jne    801057 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	84 c0                	test   %al,%al
  80108b:	74 5a                	je     8010e7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80108d:	8b 45 14             	mov    0x14(%ebp),%eax
  801090:	8b 00                	mov    (%eax),%eax
  801092:	83 f8 0f             	cmp    $0xf,%eax
  801095:	75 07                	jne    80109e <strsplit+0x6c>
		{
			return 0;
  801097:	b8 00 00 00 00       	mov    $0x0,%eax
  80109c:	eb 66                	jmp    801104 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80109e:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a1:	8b 00                	mov    (%eax),%eax
  8010a3:	8d 48 01             	lea    0x1(%eax),%ecx
  8010a6:	8b 55 14             	mov    0x14(%ebp),%edx
  8010a9:	89 0a                	mov    %ecx,(%edx)
  8010ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b5:	01 c2                	add    %eax,%edx
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010bc:	eb 03                	jmp    8010c1 <strsplit+0x8f>
			string++;
  8010be:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	84 c0                	test   %al,%al
  8010c8:	74 8b                	je     801055 <strsplit+0x23>
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	0f be c0             	movsbl %al,%eax
  8010d2:	50                   	push   %eax
  8010d3:	ff 75 0c             	pushl  0xc(%ebp)
  8010d6:	e8 b5 fa ff ff       	call   800b90 <strchr>
  8010db:	83 c4 08             	add    $0x8,%esp
  8010de:	85 c0                	test   %eax,%eax
  8010e0:	74 dc                	je     8010be <strsplit+0x8c>
			string++;
	}
  8010e2:	e9 6e ff ff ff       	jmp    801055 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010e7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010eb:	8b 00                	mov    (%eax),%eax
  8010ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f7:	01 d0                	add    %edx,%eax
  8010f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010ff:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801104:	c9                   	leave  
  801105:	c3                   	ret    

00801106 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801106:	55                   	push   %ebp
  801107:	89 e5                	mov    %esp,%ebp
  801109:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80110c:	a1 04 40 80 00       	mov    0x804004,%eax
  801111:	85 c0                	test   %eax,%eax
  801113:	74 1f                	je     801134 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801115:	e8 1d 00 00 00       	call   801137 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80111a:	83 ec 0c             	sub    $0xc,%esp
  80111d:	68 30 36 80 00       	push   $0x803630
  801122:	e8 55 f2 ff ff       	call   80037c <cprintf>
  801127:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80112a:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801131:	00 00 00 
	}
}
  801134:	90                   	nop
  801135:	c9                   	leave  
  801136:	c3                   	ret    

00801137 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  80113d:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801144:	00 00 00 
  801147:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80114e:	00 00 00 
  801151:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801158:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80115b:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801162:	00 00 00 
  801165:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80116c:	00 00 00 
  80116f:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801176:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801179:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801180:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801183:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80118a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801192:	2d 00 10 00 00       	sub    $0x1000,%eax
  801197:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  80119c:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  8011a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011a6:	a1 20 41 80 00       	mov    0x804120,%eax
  8011ab:	0f af c2             	imul   %edx,%eax
  8011ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  8011b1:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8011b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011be:	01 d0                	add    %edx,%eax
  8011c0:	48                   	dec    %eax
  8011c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8011cc:	f7 75 e8             	divl   -0x18(%ebp)
  8011cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011d2:	29 d0                	sub    %edx,%eax
  8011d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  8011d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011da:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  8011e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8011e4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8011ea:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8011f0:	83 ec 04             	sub    $0x4,%esp
  8011f3:	6a 06                	push   $0x6
  8011f5:	50                   	push   %eax
  8011f6:	52                   	push   %edx
  8011f7:	e8 a1 05 00 00       	call   80179d <sys_allocate_chunk>
  8011fc:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011ff:	a1 20 41 80 00       	mov    0x804120,%eax
  801204:	83 ec 0c             	sub    $0xc,%esp
  801207:	50                   	push   %eax
  801208:	e8 16 0c 00 00       	call   801e23 <initialize_MemBlocksList>
  80120d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801210:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801215:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801218:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80121c:	75 14                	jne    801232 <initialize_dyn_block_system+0xfb>
  80121e:	83 ec 04             	sub    $0x4,%esp
  801221:	68 55 36 80 00       	push   $0x803655
  801226:	6a 2d                	push   $0x2d
  801228:	68 73 36 80 00       	push   $0x803673
  80122d:	e8 24 1b 00 00       	call   802d56 <_panic>
  801232:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801235:	8b 00                	mov    (%eax),%eax
  801237:	85 c0                	test   %eax,%eax
  801239:	74 10                	je     80124b <initialize_dyn_block_system+0x114>
  80123b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80123e:	8b 00                	mov    (%eax),%eax
  801240:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801243:	8b 52 04             	mov    0x4(%edx),%edx
  801246:	89 50 04             	mov    %edx,0x4(%eax)
  801249:	eb 0b                	jmp    801256 <initialize_dyn_block_system+0x11f>
  80124b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80124e:	8b 40 04             	mov    0x4(%eax),%eax
  801251:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801256:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801259:	8b 40 04             	mov    0x4(%eax),%eax
  80125c:	85 c0                	test   %eax,%eax
  80125e:	74 0f                	je     80126f <initialize_dyn_block_system+0x138>
  801260:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801263:	8b 40 04             	mov    0x4(%eax),%eax
  801266:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801269:	8b 12                	mov    (%edx),%edx
  80126b:	89 10                	mov    %edx,(%eax)
  80126d:	eb 0a                	jmp    801279 <initialize_dyn_block_system+0x142>
  80126f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801272:	8b 00                	mov    (%eax),%eax
  801274:	a3 48 41 80 00       	mov    %eax,0x804148
  801279:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80127c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801282:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801285:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80128c:	a1 54 41 80 00       	mov    0x804154,%eax
  801291:	48                   	dec    %eax
  801292:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801297:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80129a:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  8012a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012a4:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  8012ab:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012af:	75 14                	jne    8012c5 <initialize_dyn_block_system+0x18e>
  8012b1:	83 ec 04             	sub    $0x4,%esp
  8012b4:	68 80 36 80 00       	push   $0x803680
  8012b9:	6a 30                	push   $0x30
  8012bb:	68 73 36 80 00       	push   $0x803673
  8012c0:	e8 91 1a 00 00       	call   802d56 <_panic>
  8012c5:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8012cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012ce:	89 50 04             	mov    %edx,0x4(%eax)
  8012d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012d4:	8b 40 04             	mov    0x4(%eax),%eax
  8012d7:	85 c0                	test   %eax,%eax
  8012d9:	74 0c                	je     8012e7 <initialize_dyn_block_system+0x1b0>
  8012db:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8012e0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8012e3:	89 10                	mov    %edx,(%eax)
  8012e5:	eb 08                	jmp    8012ef <initialize_dyn_block_system+0x1b8>
  8012e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012ea:	a3 38 41 80 00       	mov    %eax,0x804138
  8012ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012f2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8012f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801300:	a1 44 41 80 00       	mov    0x804144,%eax
  801305:	40                   	inc    %eax
  801306:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80130b:	90                   	nop
  80130c:	c9                   	leave  
  80130d:	c3                   	ret    

0080130e <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
  801311:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801314:	e8 ed fd ff ff       	call   801106 <InitializeUHeap>
	if (size == 0) return NULL ;
  801319:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80131d:	75 07                	jne    801326 <malloc+0x18>
  80131f:	b8 00 00 00 00       	mov    $0x0,%eax
  801324:	eb 67                	jmp    80138d <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801326:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80132d:	8b 55 08             	mov    0x8(%ebp),%edx
  801330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801333:	01 d0                	add    %edx,%eax
  801335:	48                   	dec    %eax
  801336:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80133c:	ba 00 00 00 00       	mov    $0x0,%edx
  801341:	f7 75 f4             	divl   -0xc(%ebp)
  801344:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801347:	29 d0                	sub    %edx,%eax
  801349:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80134c:	e8 1a 08 00 00       	call   801b6b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801351:	85 c0                	test   %eax,%eax
  801353:	74 33                	je     801388 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801355:	83 ec 0c             	sub    $0xc,%esp
  801358:	ff 75 08             	pushl  0x8(%ebp)
  80135b:	e8 0c 0e 00 00       	call   80216c <alloc_block_FF>
  801360:	83 c4 10             	add    $0x10,%esp
  801363:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801366:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80136a:	74 1c                	je     801388 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  80136c:	83 ec 0c             	sub    $0xc,%esp
  80136f:	ff 75 ec             	pushl  -0x14(%ebp)
  801372:	e8 07 0c 00 00       	call   801f7e <insert_sorted_allocList>
  801377:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  80137a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80137d:	8b 40 08             	mov    0x8(%eax),%eax
  801380:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801383:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801386:	eb 05                	jmp    80138d <malloc+0x7f>
		}
	}
	return NULL;
  801388:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80138d:	c9                   	leave  
  80138e:	c3                   	ret    

0080138f <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80138f:	55                   	push   %ebp
  801390:	89 e5                	mov    %esp,%ebp
  801392:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  80139b:	83 ec 08             	sub    $0x8,%esp
  80139e:	ff 75 f4             	pushl  -0xc(%ebp)
  8013a1:	68 40 40 80 00       	push   $0x804040
  8013a6:	e8 5b 0b 00 00       	call   801f06 <find_block>
  8013ab:	83 c4 10             	add    $0x10,%esp
  8013ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  8013b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8013b7:	83 ec 08             	sub    $0x8,%esp
  8013ba:	50                   	push   %eax
  8013bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8013be:	e8 a2 03 00 00       	call   801765 <sys_free_user_mem>
  8013c3:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  8013c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013ca:	75 14                	jne    8013e0 <free+0x51>
  8013cc:	83 ec 04             	sub    $0x4,%esp
  8013cf:	68 55 36 80 00       	push   $0x803655
  8013d4:	6a 76                	push   $0x76
  8013d6:	68 73 36 80 00       	push   $0x803673
  8013db:	e8 76 19 00 00       	call   802d56 <_panic>
  8013e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e3:	8b 00                	mov    (%eax),%eax
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	74 10                	je     8013f9 <free+0x6a>
  8013e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ec:	8b 00                	mov    (%eax),%eax
  8013ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013f1:	8b 52 04             	mov    0x4(%edx),%edx
  8013f4:	89 50 04             	mov    %edx,0x4(%eax)
  8013f7:	eb 0b                	jmp    801404 <free+0x75>
  8013f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013fc:	8b 40 04             	mov    0x4(%eax),%eax
  8013ff:	a3 44 40 80 00       	mov    %eax,0x804044
  801404:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801407:	8b 40 04             	mov    0x4(%eax),%eax
  80140a:	85 c0                	test   %eax,%eax
  80140c:	74 0f                	je     80141d <free+0x8e>
  80140e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801411:	8b 40 04             	mov    0x4(%eax),%eax
  801414:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801417:	8b 12                	mov    (%edx),%edx
  801419:	89 10                	mov    %edx,(%eax)
  80141b:	eb 0a                	jmp    801427 <free+0x98>
  80141d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801420:	8b 00                	mov    (%eax),%eax
  801422:	a3 40 40 80 00       	mov    %eax,0x804040
  801427:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80142a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801430:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801433:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80143a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80143f:	48                   	dec    %eax
  801440:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  801445:	83 ec 0c             	sub    $0xc,%esp
  801448:	ff 75 f0             	pushl  -0x10(%ebp)
  80144b:	e8 0b 14 00 00       	call   80285b <insert_sorted_with_merge_freeList>
  801450:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801453:	90                   	nop
  801454:	c9                   	leave  
  801455:	c3                   	ret    

00801456 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	83 ec 28             	sub    $0x28,%esp
  80145c:	8b 45 10             	mov    0x10(%ebp),%eax
  80145f:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801462:	e8 9f fc ff ff       	call   801106 <InitializeUHeap>
	if (size == 0) return NULL ;
  801467:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80146b:	75 0a                	jne    801477 <smalloc+0x21>
  80146d:	b8 00 00 00 00       	mov    $0x0,%eax
  801472:	e9 8d 00 00 00       	jmp    801504 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801477:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80147e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801484:	01 d0                	add    %edx,%eax
  801486:	48                   	dec    %eax
  801487:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80148a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148d:	ba 00 00 00 00       	mov    $0x0,%edx
  801492:	f7 75 f4             	divl   -0xc(%ebp)
  801495:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801498:	29 d0                	sub    %edx,%eax
  80149a:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80149d:	e8 c9 06 00 00       	call   801b6b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014a2:	85 c0                	test   %eax,%eax
  8014a4:	74 59                	je     8014ff <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  8014a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  8014ad:	83 ec 0c             	sub    $0xc,%esp
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	e8 b4 0c 00 00       	call   80216c <alloc_block_FF>
  8014b8:	83 c4 10             	add    $0x10,%esp
  8014bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  8014be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014c2:	75 07                	jne    8014cb <smalloc+0x75>
			{
				return NULL;
  8014c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c9:	eb 39                	jmp    801504 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  8014cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014ce:	8b 40 08             	mov    0x8(%eax),%eax
  8014d1:	89 c2                	mov    %eax,%edx
  8014d3:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8014d7:	52                   	push   %edx
  8014d8:	50                   	push   %eax
  8014d9:	ff 75 0c             	pushl  0xc(%ebp)
  8014dc:	ff 75 08             	pushl  0x8(%ebp)
  8014df:	e8 0c 04 00 00       	call   8018f0 <sys_createSharedObject>
  8014e4:	83 c4 10             	add    $0x10,%esp
  8014e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  8014ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8014ee:	78 08                	js     8014f8 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  8014f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014f3:	8b 40 08             	mov    0x8(%eax),%eax
  8014f6:	eb 0c                	jmp    801504 <smalloc+0xae>
				}
				else
				{
					return NULL;
  8014f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fd:	eb 05                	jmp    801504 <smalloc+0xae>
				}
			}

		}
		return NULL;
  8014ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801504:	c9                   	leave  
  801505:	c3                   	ret    

00801506 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
  801509:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80150c:	e8 f5 fb ff ff       	call   801106 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801511:	83 ec 08             	sub    $0x8,%esp
  801514:	ff 75 0c             	pushl  0xc(%ebp)
  801517:	ff 75 08             	pushl  0x8(%ebp)
  80151a:	e8 fb 03 00 00       	call   80191a <sys_getSizeOfSharedObject>
  80151f:	83 c4 10             	add    $0x10,%esp
  801522:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801525:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801529:	75 07                	jne    801532 <sget+0x2c>
	{
		return NULL;
  80152b:	b8 00 00 00 00       	mov    $0x0,%eax
  801530:	eb 64                	jmp    801596 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801532:	e8 34 06 00 00       	call   801b6b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801537:	85 c0                	test   %eax,%eax
  801539:	74 56                	je     801591 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  80153b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801545:	83 ec 0c             	sub    $0xc,%esp
  801548:	50                   	push   %eax
  801549:	e8 1e 0c 00 00       	call   80216c <alloc_block_FF>
  80154e:	83 c4 10             	add    $0x10,%esp
  801551:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801554:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801558:	75 07                	jne    801561 <sget+0x5b>
		{
		return NULL;
  80155a:	b8 00 00 00 00       	mov    $0x0,%eax
  80155f:	eb 35                	jmp    801596 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801561:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801564:	8b 40 08             	mov    0x8(%eax),%eax
  801567:	83 ec 04             	sub    $0x4,%esp
  80156a:	50                   	push   %eax
  80156b:	ff 75 0c             	pushl  0xc(%ebp)
  80156e:	ff 75 08             	pushl  0x8(%ebp)
  801571:	e8 c1 03 00 00       	call   801937 <sys_getSharedObject>
  801576:	83 c4 10             	add    $0x10,%esp
  801579:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  80157c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801580:	78 08                	js     80158a <sget+0x84>
			{
				return (void*)v1->sva;
  801582:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801585:	8b 40 08             	mov    0x8(%eax),%eax
  801588:	eb 0c                	jmp    801596 <sget+0x90>
			}
			else
			{
				return NULL;
  80158a:	b8 00 00 00 00       	mov    $0x0,%eax
  80158f:	eb 05                	jmp    801596 <sget+0x90>
			}
		}
	}
  return NULL;
  801591:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80159e:	e8 63 fb ff ff       	call   801106 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015a3:	83 ec 04             	sub    $0x4,%esp
  8015a6:	68 a4 36 80 00       	push   $0x8036a4
  8015ab:	68 0e 01 00 00       	push   $0x10e
  8015b0:	68 73 36 80 00       	push   $0x803673
  8015b5:	e8 9c 17 00 00       	call   802d56 <_panic>

008015ba <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
  8015bd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015c0:	83 ec 04             	sub    $0x4,%esp
  8015c3:	68 cc 36 80 00       	push   $0x8036cc
  8015c8:	68 22 01 00 00       	push   $0x122
  8015cd:	68 73 36 80 00       	push   $0x803673
  8015d2:	e8 7f 17 00 00       	call   802d56 <_panic>

008015d7 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
  8015da:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015dd:	83 ec 04             	sub    $0x4,%esp
  8015e0:	68 f0 36 80 00       	push   $0x8036f0
  8015e5:	68 2d 01 00 00       	push   $0x12d
  8015ea:	68 73 36 80 00       	push   $0x803673
  8015ef:	e8 62 17 00 00       	call   802d56 <_panic>

008015f4 <shrink>:

}
void shrink(uint32 newSize)
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
  8015f7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015fa:	83 ec 04             	sub    $0x4,%esp
  8015fd:	68 f0 36 80 00       	push   $0x8036f0
  801602:	68 32 01 00 00       	push   $0x132
  801607:	68 73 36 80 00       	push   $0x803673
  80160c:	e8 45 17 00 00       	call   802d56 <_panic>

00801611 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
  801614:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801617:	83 ec 04             	sub    $0x4,%esp
  80161a:	68 f0 36 80 00       	push   $0x8036f0
  80161f:	68 37 01 00 00       	push   $0x137
  801624:	68 73 36 80 00       	push   $0x803673
  801629:	e8 28 17 00 00       	call   802d56 <_panic>

0080162e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
  801631:	57                   	push   %edi
  801632:	56                   	push   %esi
  801633:	53                   	push   %ebx
  801634:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801637:	8b 45 08             	mov    0x8(%ebp),%eax
  80163a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801640:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801643:	8b 7d 18             	mov    0x18(%ebp),%edi
  801646:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801649:	cd 30                	int    $0x30
  80164b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80164e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801651:	83 c4 10             	add    $0x10,%esp
  801654:	5b                   	pop    %ebx
  801655:	5e                   	pop    %esi
  801656:	5f                   	pop    %edi
  801657:	5d                   	pop    %ebp
  801658:	c3                   	ret    

00801659 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	83 ec 04             	sub    $0x4,%esp
  80165f:	8b 45 10             	mov    0x10(%ebp),%eax
  801662:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801665:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801669:	8b 45 08             	mov    0x8(%ebp),%eax
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	52                   	push   %edx
  801671:	ff 75 0c             	pushl  0xc(%ebp)
  801674:	50                   	push   %eax
  801675:	6a 00                	push   $0x0
  801677:	e8 b2 ff ff ff       	call   80162e <syscall>
  80167c:	83 c4 18             	add    $0x18,%esp
}
  80167f:	90                   	nop
  801680:	c9                   	leave  
  801681:	c3                   	ret    

00801682 <sys_cgetc>:

int
sys_cgetc(void)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 01                	push   $0x1
  801691:	e8 98 ff ff ff       	call   80162e <syscall>
  801696:	83 c4 18             	add    $0x18,%esp
}
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80169e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	52                   	push   %edx
  8016ab:	50                   	push   %eax
  8016ac:	6a 05                	push   $0x5
  8016ae:	e8 7b ff ff ff       	call   80162e <syscall>
  8016b3:	83 c4 18             	add    $0x18,%esp
}
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
  8016bb:	56                   	push   %esi
  8016bc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016bd:	8b 75 18             	mov    0x18(%ebp),%esi
  8016c0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	56                   	push   %esi
  8016cd:	53                   	push   %ebx
  8016ce:	51                   	push   %ecx
  8016cf:	52                   	push   %edx
  8016d0:	50                   	push   %eax
  8016d1:	6a 06                	push   $0x6
  8016d3:	e8 56 ff ff ff       	call   80162e <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
}
  8016db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016de:	5b                   	pop    %ebx
  8016df:	5e                   	pop    %esi
  8016e0:	5d                   	pop    %ebp
  8016e1:	c3                   	ret    

008016e2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	52                   	push   %edx
  8016f2:	50                   	push   %eax
  8016f3:	6a 07                	push   $0x7
  8016f5:	e8 34 ff ff ff       	call   80162e <syscall>
  8016fa:	83 c4 18             	add    $0x18,%esp
}
  8016fd:	c9                   	leave  
  8016fe:	c3                   	ret    

008016ff <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	ff 75 0c             	pushl  0xc(%ebp)
  80170b:	ff 75 08             	pushl  0x8(%ebp)
  80170e:	6a 08                	push   $0x8
  801710:	e8 19 ff ff ff       	call   80162e <syscall>
  801715:	83 c4 18             	add    $0x18,%esp
}
  801718:	c9                   	leave  
  801719:	c3                   	ret    

0080171a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80171a:	55                   	push   %ebp
  80171b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 09                	push   $0x9
  801729:	e8 00 ff ff ff       	call   80162e <syscall>
  80172e:	83 c4 18             	add    $0x18,%esp
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 0a                	push   $0xa
  801742:	e8 e7 fe ff ff       	call   80162e <syscall>
  801747:	83 c4 18             	add    $0x18,%esp
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 0b                	push   $0xb
  80175b:	e8 ce fe ff ff       	call   80162e <syscall>
  801760:	83 c4 18             	add    $0x18,%esp
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	ff 75 0c             	pushl  0xc(%ebp)
  801771:	ff 75 08             	pushl  0x8(%ebp)
  801774:	6a 0f                	push   $0xf
  801776:	e8 b3 fe ff ff       	call   80162e <syscall>
  80177b:	83 c4 18             	add    $0x18,%esp
	return;
  80177e:	90                   	nop
}
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	ff 75 0c             	pushl  0xc(%ebp)
  80178d:	ff 75 08             	pushl  0x8(%ebp)
  801790:	6a 10                	push   $0x10
  801792:	e8 97 fe ff ff       	call   80162e <syscall>
  801797:	83 c4 18             	add    $0x18,%esp
	return ;
  80179a:	90                   	nop
}
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	ff 75 10             	pushl  0x10(%ebp)
  8017a7:	ff 75 0c             	pushl  0xc(%ebp)
  8017aa:	ff 75 08             	pushl  0x8(%ebp)
  8017ad:	6a 11                	push   $0x11
  8017af:	e8 7a fe ff ff       	call   80162e <syscall>
  8017b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b7:	90                   	nop
}
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 0c                	push   $0xc
  8017c9:	e8 60 fe ff ff       	call   80162e <syscall>
  8017ce:	83 c4 18             	add    $0x18,%esp
}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	ff 75 08             	pushl  0x8(%ebp)
  8017e1:	6a 0d                	push   $0xd
  8017e3:	e8 46 fe ff ff       	call   80162e <syscall>
  8017e8:	83 c4 18             	add    $0x18,%esp
}
  8017eb:	c9                   	leave  
  8017ec:	c3                   	ret    

008017ed <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 0e                	push   $0xe
  8017fc:	e8 2d fe ff ff       	call   80162e <syscall>
  801801:	83 c4 18             	add    $0x18,%esp
}
  801804:	90                   	nop
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 13                	push   $0x13
  801816:	e8 13 fe ff ff       	call   80162e <syscall>
  80181b:	83 c4 18             	add    $0x18,%esp
}
  80181e:	90                   	nop
  80181f:	c9                   	leave  
  801820:	c3                   	ret    

00801821 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 14                	push   $0x14
  801830:	e8 f9 fd ff ff       	call   80162e <syscall>
  801835:	83 c4 18             	add    $0x18,%esp
}
  801838:	90                   	nop
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <sys_cputc>:


void
sys_cputc(const char c)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	83 ec 04             	sub    $0x4,%esp
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801847:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	50                   	push   %eax
  801854:	6a 15                	push   $0x15
  801856:	e8 d3 fd ff ff       	call   80162e <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
}
  80185e:	90                   	nop
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 16                	push   $0x16
  801870:	e8 b9 fd ff ff       	call   80162e <syscall>
  801875:	83 c4 18             	add    $0x18,%esp
}
  801878:	90                   	nop
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80187e:	8b 45 08             	mov    0x8(%ebp),%eax
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	ff 75 0c             	pushl  0xc(%ebp)
  80188a:	50                   	push   %eax
  80188b:	6a 17                	push   $0x17
  80188d:	e8 9c fd ff ff       	call   80162e <syscall>
  801892:	83 c4 18             	add    $0x18,%esp
}
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80189a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	52                   	push   %edx
  8018a7:	50                   	push   %eax
  8018a8:	6a 1a                	push   $0x1a
  8018aa:	e8 7f fd ff ff       	call   80162e <syscall>
  8018af:	83 c4 18             	add    $0x18,%esp
}
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	52                   	push   %edx
  8018c4:	50                   	push   %eax
  8018c5:	6a 18                	push   $0x18
  8018c7:	e8 62 fd ff ff       	call   80162e <syscall>
  8018cc:	83 c4 18             	add    $0x18,%esp
}
  8018cf:	90                   	nop
  8018d0:	c9                   	leave  
  8018d1:	c3                   	ret    

008018d2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	52                   	push   %edx
  8018e2:	50                   	push   %eax
  8018e3:	6a 19                	push   $0x19
  8018e5:	e8 44 fd ff ff       	call   80162e <syscall>
  8018ea:	83 c4 18             	add    $0x18,%esp
}
  8018ed:	90                   	nop
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	83 ec 04             	sub    $0x4,%esp
  8018f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018fc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018ff:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801903:	8b 45 08             	mov    0x8(%ebp),%eax
  801906:	6a 00                	push   $0x0
  801908:	51                   	push   %ecx
  801909:	52                   	push   %edx
  80190a:	ff 75 0c             	pushl  0xc(%ebp)
  80190d:	50                   	push   %eax
  80190e:	6a 1b                	push   $0x1b
  801910:	e8 19 fd ff ff       	call   80162e <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80191d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801920:	8b 45 08             	mov    0x8(%ebp),%eax
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	52                   	push   %edx
  80192a:	50                   	push   %eax
  80192b:	6a 1c                	push   $0x1c
  80192d:	e8 fc fc ff ff       	call   80162e <syscall>
  801932:	83 c4 18             	add    $0x18,%esp
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80193a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80193d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801940:	8b 45 08             	mov    0x8(%ebp),%eax
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	51                   	push   %ecx
  801948:	52                   	push   %edx
  801949:	50                   	push   %eax
  80194a:	6a 1d                	push   $0x1d
  80194c:	e8 dd fc ff ff       	call   80162e <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801959:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	52                   	push   %edx
  801966:	50                   	push   %eax
  801967:	6a 1e                	push   $0x1e
  801969:	e8 c0 fc ff ff       	call   80162e <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
}
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 1f                	push   $0x1f
  801982:	e8 a7 fc ff ff       	call   80162e <syscall>
  801987:	83 c4 18             	add    $0x18,%esp
}
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	6a 00                	push   $0x0
  801994:	ff 75 14             	pushl  0x14(%ebp)
  801997:	ff 75 10             	pushl  0x10(%ebp)
  80199a:	ff 75 0c             	pushl  0xc(%ebp)
  80199d:	50                   	push   %eax
  80199e:	6a 20                	push   $0x20
  8019a0:	e8 89 fc ff ff       	call   80162e <syscall>
  8019a5:	83 c4 18             	add    $0x18,%esp
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	50                   	push   %eax
  8019b9:	6a 21                	push   $0x21
  8019bb:	e8 6e fc ff ff       	call   80162e <syscall>
  8019c0:	83 c4 18             	add    $0x18,%esp
}
  8019c3:	90                   	nop
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	50                   	push   %eax
  8019d5:	6a 22                	push   $0x22
  8019d7:	e8 52 fc ff ff       	call   80162e <syscall>
  8019dc:	83 c4 18             	add    $0x18,%esp
}
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 02                	push   $0x2
  8019f0:	e8 39 fc ff ff       	call   80162e <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 03                	push   $0x3
  801a09:	e8 20 fc ff ff       	call   80162e <syscall>
  801a0e:	83 c4 18             	add    $0x18,%esp
}
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 04                	push   $0x4
  801a22:	e8 07 fc ff ff       	call   80162e <syscall>
  801a27:	83 c4 18             	add    $0x18,%esp
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_exit_env>:


void sys_exit_env(void)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 23                	push   $0x23
  801a3b:	e8 ee fb ff ff       	call   80162e <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
}
  801a43:	90                   	nop
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
  801a49:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a4c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a4f:	8d 50 04             	lea    0x4(%eax),%edx
  801a52:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	52                   	push   %edx
  801a5c:	50                   	push   %eax
  801a5d:	6a 24                	push   $0x24
  801a5f:	e8 ca fb ff ff       	call   80162e <syscall>
  801a64:	83 c4 18             	add    $0x18,%esp
	return result;
  801a67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a6d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a70:	89 01                	mov    %eax,(%ecx)
  801a72:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	c9                   	leave  
  801a79:	c2 04 00             	ret    $0x4

00801a7c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	ff 75 10             	pushl  0x10(%ebp)
  801a86:	ff 75 0c             	pushl  0xc(%ebp)
  801a89:	ff 75 08             	pushl  0x8(%ebp)
  801a8c:	6a 12                	push   $0x12
  801a8e:	e8 9b fb ff ff       	call   80162e <syscall>
  801a93:	83 c4 18             	add    $0x18,%esp
	return ;
  801a96:	90                   	nop
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 25                	push   $0x25
  801aa8:	e8 81 fb ff ff       	call   80162e <syscall>
  801aad:	83 c4 18             	add    $0x18,%esp
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
  801ab5:	83 ec 04             	sub    $0x4,%esp
  801ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  801abb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801abe:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	50                   	push   %eax
  801acb:	6a 26                	push   $0x26
  801acd:	e8 5c fb ff ff       	call   80162e <syscall>
  801ad2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad5:	90                   	nop
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <rsttst>:
void rsttst()
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 28                	push   $0x28
  801ae7:	e8 42 fb ff ff       	call   80162e <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
	return ;
  801aef:	90                   	nop
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
  801af5:	83 ec 04             	sub    $0x4,%esp
  801af8:	8b 45 14             	mov    0x14(%ebp),%eax
  801afb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801afe:	8b 55 18             	mov    0x18(%ebp),%edx
  801b01:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b05:	52                   	push   %edx
  801b06:	50                   	push   %eax
  801b07:	ff 75 10             	pushl  0x10(%ebp)
  801b0a:	ff 75 0c             	pushl  0xc(%ebp)
  801b0d:	ff 75 08             	pushl  0x8(%ebp)
  801b10:	6a 27                	push   $0x27
  801b12:	e8 17 fb ff ff       	call   80162e <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
	return ;
  801b1a:	90                   	nop
}
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <chktst>:
void chktst(uint32 n)
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	ff 75 08             	pushl  0x8(%ebp)
  801b2b:	6a 29                	push   $0x29
  801b2d:	e8 fc fa ff ff       	call   80162e <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
	return ;
  801b35:	90                   	nop
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <inctst>:

void inctst()
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 2a                	push   $0x2a
  801b47:	e8 e2 fa ff ff       	call   80162e <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4f:	90                   	nop
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <gettst>:
uint32 gettst()
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 2b                	push   $0x2b
  801b61:	e8 c8 fa ff ff       	call   80162e <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
}
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
  801b6e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 2c                	push   $0x2c
  801b7d:	e8 ac fa ff ff       	call   80162e <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
  801b85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b88:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b8c:	75 07                	jne    801b95 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b93:	eb 05                	jmp    801b9a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
  801b9f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 2c                	push   $0x2c
  801bae:	e8 7b fa ff ff       	call   80162e <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
  801bb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bb9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bbd:	75 07                	jne    801bc6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bbf:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc4:	eb 05                	jmp    801bcb <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
  801bd0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 2c                	push   $0x2c
  801bdf:	e8 4a fa ff ff       	call   80162e <syscall>
  801be4:	83 c4 18             	add    $0x18,%esp
  801be7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801bea:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801bee:	75 07                	jne    801bf7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bf0:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf5:	eb 05                	jmp    801bfc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bf7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 2c                	push   $0x2c
  801c10:	e8 19 fa ff ff       	call   80162e <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
  801c18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c1b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c1f:	75 07                	jne    801c28 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c21:	b8 01 00 00 00       	mov    $0x1,%eax
  801c26:	eb 05                	jmp    801c2d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	ff 75 08             	pushl  0x8(%ebp)
  801c3d:	6a 2d                	push   $0x2d
  801c3f:	e8 ea f9 ff ff       	call   80162e <syscall>
  801c44:	83 c4 18             	add    $0x18,%esp
	return ;
  801c47:	90                   	nop
}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
  801c4d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c4e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c51:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c57:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5a:	6a 00                	push   $0x0
  801c5c:	53                   	push   %ebx
  801c5d:	51                   	push   %ecx
  801c5e:	52                   	push   %edx
  801c5f:	50                   	push   %eax
  801c60:	6a 2e                	push   $0x2e
  801c62:	e8 c7 f9 ff ff       	call   80162e <syscall>
  801c67:	83 c4 18             	add    $0x18,%esp
}
  801c6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c75:	8b 45 08             	mov    0x8(%ebp),%eax
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	52                   	push   %edx
  801c7f:	50                   	push   %eax
  801c80:	6a 2f                	push   $0x2f
  801c82:	e8 a7 f9 ff ff       	call   80162e <syscall>
  801c87:	83 c4 18             	add    $0x18,%esp
}
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
  801c8f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801c92:	83 ec 0c             	sub    $0xc,%esp
  801c95:	68 00 37 80 00       	push   $0x803700
  801c9a:	e8 dd e6 ff ff       	call   80037c <cprintf>
  801c9f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ca2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ca9:	83 ec 0c             	sub    $0xc,%esp
  801cac:	68 2c 37 80 00       	push   $0x80372c
  801cb1:	e8 c6 e6 ff ff       	call   80037c <cprintf>
  801cb6:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801cb9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cbd:	a1 38 41 80 00       	mov    0x804138,%eax
  801cc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cc5:	eb 56                	jmp    801d1d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801cc7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ccb:	74 1c                	je     801ce9 <print_mem_block_lists+0x5d>
  801ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd0:	8b 50 08             	mov    0x8(%eax),%edx
  801cd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd6:	8b 48 08             	mov    0x8(%eax),%ecx
  801cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cdc:	8b 40 0c             	mov    0xc(%eax),%eax
  801cdf:	01 c8                	add    %ecx,%eax
  801ce1:	39 c2                	cmp    %eax,%edx
  801ce3:	73 04                	jae    801ce9 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ce5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cec:	8b 50 08             	mov    0x8(%eax),%edx
  801cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf2:	8b 40 0c             	mov    0xc(%eax),%eax
  801cf5:	01 c2                	add    %eax,%edx
  801cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfa:	8b 40 08             	mov    0x8(%eax),%eax
  801cfd:	83 ec 04             	sub    $0x4,%esp
  801d00:	52                   	push   %edx
  801d01:	50                   	push   %eax
  801d02:	68 41 37 80 00       	push   $0x803741
  801d07:	e8 70 e6 ff ff       	call   80037c <cprintf>
  801d0c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d12:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d15:	a1 40 41 80 00       	mov    0x804140,%eax
  801d1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d21:	74 07                	je     801d2a <print_mem_block_lists+0x9e>
  801d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d26:	8b 00                	mov    (%eax),%eax
  801d28:	eb 05                	jmp    801d2f <print_mem_block_lists+0xa3>
  801d2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2f:	a3 40 41 80 00       	mov    %eax,0x804140
  801d34:	a1 40 41 80 00       	mov    0x804140,%eax
  801d39:	85 c0                	test   %eax,%eax
  801d3b:	75 8a                	jne    801cc7 <print_mem_block_lists+0x3b>
  801d3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d41:	75 84                	jne    801cc7 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d43:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d47:	75 10                	jne    801d59 <print_mem_block_lists+0xcd>
  801d49:	83 ec 0c             	sub    $0xc,%esp
  801d4c:	68 50 37 80 00       	push   $0x803750
  801d51:	e8 26 e6 ff ff       	call   80037c <cprintf>
  801d56:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d59:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d60:	83 ec 0c             	sub    $0xc,%esp
  801d63:	68 74 37 80 00       	push   $0x803774
  801d68:	e8 0f e6 ff ff       	call   80037c <cprintf>
  801d6d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d70:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d74:	a1 40 40 80 00       	mov    0x804040,%eax
  801d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d7c:	eb 56                	jmp    801dd4 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d82:	74 1c                	je     801da0 <print_mem_block_lists+0x114>
  801d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d87:	8b 50 08             	mov    0x8(%eax),%edx
  801d8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8d:	8b 48 08             	mov    0x8(%eax),%ecx
  801d90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d93:	8b 40 0c             	mov    0xc(%eax),%eax
  801d96:	01 c8                	add    %ecx,%eax
  801d98:	39 c2                	cmp    %eax,%edx
  801d9a:	73 04                	jae    801da0 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801d9c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da3:	8b 50 08             	mov    0x8(%eax),%edx
  801da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da9:	8b 40 0c             	mov    0xc(%eax),%eax
  801dac:	01 c2                	add    %eax,%edx
  801dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db1:	8b 40 08             	mov    0x8(%eax),%eax
  801db4:	83 ec 04             	sub    $0x4,%esp
  801db7:	52                   	push   %edx
  801db8:	50                   	push   %eax
  801db9:	68 41 37 80 00       	push   $0x803741
  801dbe:	e8 b9 e5 ff ff       	call   80037c <cprintf>
  801dc3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801dcc:	a1 48 40 80 00       	mov    0x804048,%eax
  801dd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dd8:	74 07                	je     801de1 <print_mem_block_lists+0x155>
  801dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddd:	8b 00                	mov    (%eax),%eax
  801ddf:	eb 05                	jmp    801de6 <print_mem_block_lists+0x15a>
  801de1:	b8 00 00 00 00       	mov    $0x0,%eax
  801de6:	a3 48 40 80 00       	mov    %eax,0x804048
  801deb:	a1 48 40 80 00       	mov    0x804048,%eax
  801df0:	85 c0                	test   %eax,%eax
  801df2:	75 8a                	jne    801d7e <print_mem_block_lists+0xf2>
  801df4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801df8:	75 84                	jne    801d7e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801dfa:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801dfe:	75 10                	jne    801e10 <print_mem_block_lists+0x184>
  801e00:	83 ec 0c             	sub    $0xc,%esp
  801e03:	68 8c 37 80 00       	push   $0x80378c
  801e08:	e8 6f e5 ff ff       	call   80037c <cprintf>
  801e0d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e10:	83 ec 0c             	sub    $0xc,%esp
  801e13:	68 00 37 80 00       	push   $0x803700
  801e18:	e8 5f e5 ff ff       	call   80037c <cprintf>
  801e1d:	83 c4 10             	add    $0x10,%esp

}
  801e20:	90                   	nop
  801e21:	c9                   	leave  
  801e22:	c3                   	ret    

00801e23 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  801e29:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2c:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  801e2f:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e36:	00 00 00 
  801e39:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e40:	00 00 00 
  801e43:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e4a:	00 00 00 
	for(int i = 0; i<n;i++)
  801e4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e54:	e9 9e 00 00 00       	jmp    801ef7 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  801e59:	a1 50 40 80 00       	mov    0x804050,%eax
  801e5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e61:	c1 e2 04             	shl    $0x4,%edx
  801e64:	01 d0                	add    %edx,%eax
  801e66:	85 c0                	test   %eax,%eax
  801e68:	75 14                	jne    801e7e <initialize_MemBlocksList+0x5b>
  801e6a:	83 ec 04             	sub    $0x4,%esp
  801e6d:	68 b4 37 80 00       	push   $0x8037b4
  801e72:	6a 47                	push   $0x47
  801e74:	68 d7 37 80 00       	push   $0x8037d7
  801e79:	e8 d8 0e 00 00       	call   802d56 <_panic>
  801e7e:	a1 50 40 80 00       	mov    0x804050,%eax
  801e83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e86:	c1 e2 04             	shl    $0x4,%edx
  801e89:	01 d0                	add    %edx,%eax
  801e8b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801e91:	89 10                	mov    %edx,(%eax)
  801e93:	8b 00                	mov    (%eax),%eax
  801e95:	85 c0                	test   %eax,%eax
  801e97:	74 18                	je     801eb1 <initialize_MemBlocksList+0x8e>
  801e99:	a1 48 41 80 00       	mov    0x804148,%eax
  801e9e:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801ea4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ea7:	c1 e1 04             	shl    $0x4,%ecx
  801eaa:	01 ca                	add    %ecx,%edx
  801eac:	89 50 04             	mov    %edx,0x4(%eax)
  801eaf:	eb 12                	jmp    801ec3 <initialize_MemBlocksList+0xa0>
  801eb1:	a1 50 40 80 00       	mov    0x804050,%eax
  801eb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb9:	c1 e2 04             	shl    $0x4,%edx
  801ebc:	01 d0                	add    %edx,%eax
  801ebe:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801ec3:	a1 50 40 80 00       	mov    0x804050,%eax
  801ec8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ecb:	c1 e2 04             	shl    $0x4,%edx
  801ece:	01 d0                	add    %edx,%eax
  801ed0:	a3 48 41 80 00       	mov    %eax,0x804148
  801ed5:	a1 50 40 80 00       	mov    0x804050,%eax
  801eda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801edd:	c1 e2 04             	shl    $0x4,%edx
  801ee0:	01 d0                	add    %edx,%eax
  801ee2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ee9:	a1 54 41 80 00       	mov    0x804154,%eax
  801eee:	40                   	inc    %eax
  801eef:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  801ef4:	ff 45 f4             	incl   -0xc(%ebp)
  801ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801efd:	0f 82 56 ff ff ff    	jb     801e59 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  801f03:	90                   	nop
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
  801f09:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  801f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  801f12:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  801f19:	a1 40 40 80 00       	mov    0x804040,%eax
  801f1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f21:	eb 23                	jmp    801f46 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  801f23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f26:	8b 40 08             	mov    0x8(%eax),%eax
  801f29:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801f2c:	75 09                	jne    801f37 <find_block+0x31>
		{
			found = 1;
  801f2e:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  801f35:	eb 35                	jmp    801f6c <find_block+0x66>
		}
		else
		{
			found = 0;
  801f37:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  801f3e:	a1 48 40 80 00       	mov    0x804048,%eax
  801f43:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f46:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f4a:	74 07                	je     801f53 <find_block+0x4d>
  801f4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f4f:	8b 00                	mov    (%eax),%eax
  801f51:	eb 05                	jmp    801f58 <find_block+0x52>
  801f53:	b8 00 00 00 00       	mov    $0x0,%eax
  801f58:	a3 48 40 80 00       	mov    %eax,0x804048
  801f5d:	a1 48 40 80 00       	mov    0x804048,%eax
  801f62:	85 c0                	test   %eax,%eax
  801f64:	75 bd                	jne    801f23 <find_block+0x1d>
  801f66:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f6a:	75 b7                	jne    801f23 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  801f6c:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  801f70:	75 05                	jne    801f77 <find_block+0x71>
	{
		return blk;
  801f72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f75:	eb 05                	jmp    801f7c <find_block+0x76>
	}
	else
	{
		return NULL;
  801f77:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    

00801f7e <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
  801f81:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  801f84:	8b 45 08             	mov    0x8(%ebp),%eax
  801f87:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  801f8a:	a1 40 40 80 00       	mov    0x804040,%eax
  801f8f:	85 c0                	test   %eax,%eax
  801f91:	74 12                	je     801fa5 <insert_sorted_allocList+0x27>
  801f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f96:	8b 50 08             	mov    0x8(%eax),%edx
  801f99:	a1 40 40 80 00       	mov    0x804040,%eax
  801f9e:	8b 40 08             	mov    0x8(%eax),%eax
  801fa1:	39 c2                	cmp    %eax,%edx
  801fa3:	73 65                	jae    80200a <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  801fa5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fa9:	75 14                	jne    801fbf <insert_sorted_allocList+0x41>
  801fab:	83 ec 04             	sub    $0x4,%esp
  801fae:	68 b4 37 80 00       	push   $0x8037b4
  801fb3:	6a 7b                	push   $0x7b
  801fb5:	68 d7 37 80 00       	push   $0x8037d7
  801fba:	e8 97 0d 00 00       	call   802d56 <_panic>
  801fbf:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801fc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc8:	89 10                	mov    %edx,(%eax)
  801fca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fcd:	8b 00                	mov    (%eax),%eax
  801fcf:	85 c0                	test   %eax,%eax
  801fd1:	74 0d                	je     801fe0 <insert_sorted_allocList+0x62>
  801fd3:	a1 40 40 80 00       	mov    0x804040,%eax
  801fd8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fdb:	89 50 04             	mov    %edx,0x4(%eax)
  801fde:	eb 08                	jmp    801fe8 <insert_sorted_allocList+0x6a>
  801fe0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe3:	a3 44 40 80 00       	mov    %eax,0x804044
  801fe8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801feb:	a3 40 40 80 00       	mov    %eax,0x804040
  801ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ffa:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fff:	40                   	inc    %eax
  802000:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802005:	e9 5f 01 00 00       	jmp    802169 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  80200a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200d:	8b 50 08             	mov    0x8(%eax),%edx
  802010:	a1 44 40 80 00       	mov    0x804044,%eax
  802015:	8b 40 08             	mov    0x8(%eax),%eax
  802018:	39 c2                	cmp    %eax,%edx
  80201a:	76 65                	jbe    802081 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  80201c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802020:	75 14                	jne    802036 <insert_sorted_allocList+0xb8>
  802022:	83 ec 04             	sub    $0x4,%esp
  802025:	68 f0 37 80 00       	push   $0x8037f0
  80202a:	6a 7f                	push   $0x7f
  80202c:	68 d7 37 80 00       	push   $0x8037d7
  802031:	e8 20 0d 00 00       	call   802d56 <_panic>
  802036:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80203c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203f:	89 50 04             	mov    %edx,0x4(%eax)
  802042:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802045:	8b 40 04             	mov    0x4(%eax),%eax
  802048:	85 c0                	test   %eax,%eax
  80204a:	74 0c                	je     802058 <insert_sorted_allocList+0xda>
  80204c:	a1 44 40 80 00       	mov    0x804044,%eax
  802051:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802054:	89 10                	mov    %edx,(%eax)
  802056:	eb 08                	jmp    802060 <insert_sorted_allocList+0xe2>
  802058:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205b:	a3 40 40 80 00       	mov    %eax,0x804040
  802060:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802063:	a3 44 40 80 00       	mov    %eax,0x804044
  802068:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80206b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802071:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802076:	40                   	inc    %eax
  802077:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80207c:	e9 e8 00 00 00       	jmp    802169 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802081:	a1 40 40 80 00       	mov    0x804040,%eax
  802086:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802089:	e9 ab 00 00 00       	jmp    802139 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  80208e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802091:	8b 00                	mov    (%eax),%eax
  802093:	85 c0                	test   %eax,%eax
  802095:	0f 84 96 00 00 00    	je     802131 <insert_sorted_allocList+0x1b3>
  80209b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209e:	8b 50 08             	mov    0x8(%eax),%edx
  8020a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a4:	8b 40 08             	mov    0x8(%eax),%eax
  8020a7:	39 c2                	cmp    %eax,%edx
  8020a9:	0f 86 82 00 00 00    	jbe    802131 <insert_sorted_allocList+0x1b3>
  8020af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b2:	8b 50 08             	mov    0x8(%eax),%edx
  8020b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b8:	8b 00                	mov    (%eax),%eax
  8020ba:	8b 40 08             	mov    0x8(%eax),%eax
  8020bd:	39 c2                	cmp    %eax,%edx
  8020bf:	73 70                	jae    802131 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  8020c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c5:	74 06                	je     8020cd <insert_sorted_allocList+0x14f>
  8020c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020cb:	75 17                	jne    8020e4 <insert_sorted_allocList+0x166>
  8020cd:	83 ec 04             	sub    $0x4,%esp
  8020d0:	68 14 38 80 00       	push   $0x803814
  8020d5:	68 87 00 00 00       	push   $0x87
  8020da:	68 d7 37 80 00       	push   $0x8037d7
  8020df:	e8 72 0c 00 00       	call   802d56 <_panic>
  8020e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e7:	8b 10                	mov    (%eax),%edx
  8020e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ec:	89 10                	mov    %edx,(%eax)
  8020ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f1:	8b 00                	mov    (%eax),%eax
  8020f3:	85 c0                	test   %eax,%eax
  8020f5:	74 0b                	je     802102 <insert_sorted_allocList+0x184>
  8020f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fa:	8b 00                	mov    (%eax),%eax
  8020fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020ff:	89 50 04             	mov    %edx,0x4(%eax)
  802102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802105:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802108:	89 10                	mov    %edx,(%eax)
  80210a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802110:	89 50 04             	mov    %edx,0x4(%eax)
  802113:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802116:	8b 00                	mov    (%eax),%eax
  802118:	85 c0                	test   %eax,%eax
  80211a:	75 08                	jne    802124 <insert_sorted_allocList+0x1a6>
  80211c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211f:	a3 44 40 80 00       	mov    %eax,0x804044
  802124:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802129:	40                   	inc    %eax
  80212a:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80212f:	eb 38                	jmp    802169 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802131:	a1 48 40 80 00       	mov    0x804048,%eax
  802136:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802139:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80213d:	74 07                	je     802146 <insert_sorted_allocList+0x1c8>
  80213f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802142:	8b 00                	mov    (%eax),%eax
  802144:	eb 05                	jmp    80214b <insert_sorted_allocList+0x1cd>
  802146:	b8 00 00 00 00       	mov    $0x0,%eax
  80214b:	a3 48 40 80 00       	mov    %eax,0x804048
  802150:	a1 48 40 80 00       	mov    0x804048,%eax
  802155:	85 c0                	test   %eax,%eax
  802157:	0f 85 31 ff ff ff    	jne    80208e <insert_sorted_allocList+0x110>
  80215d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802161:	0f 85 27 ff ff ff    	jne    80208e <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802167:	eb 00                	jmp    802169 <insert_sorted_allocList+0x1eb>
  802169:	90                   	nop
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
  80216f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802172:	8b 45 08             	mov    0x8(%ebp),%eax
  802175:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802178:	a1 48 41 80 00       	mov    0x804148,%eax
  80217d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802180:	a1 38 41 80 00       	mov    0x804138,%eax
  802185:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802188:	e9 77 01 00 00       	jmp    802304 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  80218d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802190:	8b 40 0c             	mov    0xc(%eax),%eax
  802193:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802196:	0f 85 8a 00 00 00    	jne    802226 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80219c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a0:	75 17                	jne    8021b9 <alloc_block_FF+0x4d>
  8021a2:	83 ec 04             	sub    $0x4,%esp
  8021a5:	68 48 38 80 00       	push   $0x803848
  8021aa:	68 9e 00 00 00       	push   $0x9e
  8021af:	68 d7 37 80 00       	push   $0x8037d7
  8021b4:	e8 9d 0b 00 00       	call   802d56 <_panic>
  8021b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bc:	8b 00                	mov    (%eax),%eax
  8021be:	85 c0                	test   %eax,%eax
  8021c0:	74 10                	je     8021d2 <alloc_block_FF+0x66>
  8021c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c5:	8b 00                	mov    (%eax),%eax
  8021c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ca:	8b 52 04             	mov    0x4(%edx),%edx
  8021cd:	89 50 04             	mov    %edx,0x4(%eax)
  8021d0:	eb 0b                	jmp    8021dd <alloc_block_FF+0x71>
  8021d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d5:	8b 40 04             	mov    0x4(%eax),%eax
  8021d8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8021dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e0:	8b 40 04             	mov    0x4(%eax),%eax
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	74 0f                	je     8021f6 <alloc_block_FF+0x8a>
  8021e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ea:	8b 40 04             	mov    0x4(%eax),%eax
  8021ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f0:	8b 12                	mov    (%edx),%edx
  8021f2:	89 10                	mov    %edx,(%eax)
  8021f4:	eb 0a                	jmp    802200 <alloc_block_FF+0x94>
  8021f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f9:	8b 00                	mov    (%eax),%eax
  8021fb:	a3 38 41 80 00       	mov    %eax,0x804138
  802200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802203:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802213:	a1 44 41 80 00       	mov    0x804144,%eax
  802218:	48                   	dec    %eax
  802219:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  80221e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802221:	e9 11 01 00 00       	jmp    802337 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802226:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802229:	8b 40 0c             	mov    0xc(%eax),%eax
  80222c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80222f:	0f 86 c7 00 00 00    	jbe    8022fc <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802235:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802239:	75 17                	jne    802252 <alloc_block_FF+0xe6>
  80223b:	83 ec 04             	sub    $0x4,%esp
  80223e:	68 48 38 80 00       	push   $0x803848
  802243:	68 a3 00 00 00       	push   $0xa3
  802248:	68 d7 37 80 00       	push   $0x8037d7
  80224d:	e8 04 0b 00 00       	call   802d56 <_panic>
  802252:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802255:	8b 00                	mov    (%eax),%eax
  802257:	85 c0                	test   %eax,%eax
  802259:	74 10                	je     80226b <alloc_block_FF+0xff>
  80225b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80225e:	8b 00                	mov    (%eax),%eax
  802260:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802263:	8b 52 04             	mov    0x4(%edx),%edx
  802266:	89 50 04             	mov    %edx,0x4(%eax)
  802269:	eb 0b                	jmp    802276 <alloc_block_FF+0x10a>
  80226b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226e:	8b 40 04             	mov    0x4(%eax),%eax
  802271:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802276:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802279:	8b 40 04             	mov    0x4(%eax),%eax
  80227c:	85 c0                	test   %eax,%eax
  80227e:	74 0f                	je     80228f <alloc_block_FF+0x123>
  802280:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802283:	8b 40 04             	mov    0x4(%eax),%eax
  802286:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802289:	8b 12                	mov    (%edx),%edx
  80228b:	89 10                	mov    %edx,(%eax)
  80228d:	eb 0a                	jmp    802299 <alloc_block_FF+0x12d>
  80228f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802292:	8b 00                	mov    (%eax),%eax
  802294:	a3 48 41 80 00       	mov    %eax,0x804148
  802299:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80229c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022ac:	a1 54 41 80 00       	mov    0x804154,%eax
  8022b1:	48                   	dec    %eax
  8022b2:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8022b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022bd:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8022c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8022c6:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8022c9:	89 c2                	mov    %eax,%edx
  8022cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ce:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8022d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d4:	8b 40 08             	mov    0x8(%eax),%eax
  8022d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8022da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dd:	8b 50 08             	mov    0x8(%eax),%edx
  8022e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8022e6:	01 c2                	add    %eax,%edx
  8022e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022eb:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8022ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022f4:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8022f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022fa:	eb 3b                	jmp    802337 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8022fc:	a1 40 41 80 00       	mov    0x804140,%eax
  802301:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802304:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802308:	74 07                	je     802311 <alloc_block_FF+0x1a5>
  80230a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230d:	8b 00                	mov    (%eax),%eax
  80230f:	eb 05                	jmp    802316 <alloc_block_FF+0x1aa>
  802311:	b8 00 00 00 00       	mov    $0x0,%eax
  802316:	a3 40 41 80 00       	mov    %eax,0x804140
  80231b:	a1 40 41 80 00       	mov    0x804140,%eax
  802320:	85 c0                	test   %eax,%eax
  802322:	0f 85 65 fe ff ff    	jne    80218d <alloc_block_FF+0x21>
  802328:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80232c:	0f 85 5b fe ff ff    	jne    80218d <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802332:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802337:	c9                   	leave  
  802338:	c3                   	ret    

00802339 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802339:	55                   	push   %ebp
  80233a:	89 e5                	mov    %esp,%ebp
  80233c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  80233f:	8b 45 08             	mov    0x8(%ebp),%eax
  802342:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802345:	a1 48 41 80 00       	mov    0x804148,%eax
  80234a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  80234d:	a1 44 41 80 00       	mov    0x804144,%eax
  802352:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802355:	a1 38 41 80 00       	mov    0x804138,%eax
  80235a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80235d:	e9 a1 00 00 00       	jmp    802403 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802365:	8b 40 0c             	mov    0xc(%eax),%eax
  802368:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80236b:	0f 85 8a 00 00 00    	jne    8023fb <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802371:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802375:	75 17                	jne    80238e <alloc_block_BF+0x55>
  802377:	83 ec 04             	sub    $0x4,%esp
  80237a:	68 48 38 80 00       	push   $0x803848
  80237f:	68 c2 00 00 00       	push   $0xc2
  802384:	68 d7 37 80 00       	push   $0x8037d7
  802389:	e8 c8 09 00 00       	call   802d56 <_panic>
  80238e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802391:	8b 00                	mov    (%eax),%eax
  802393:	85 c0                	test   %eax,%eax
  802395:	74 10                	je     8023a7 <alloc_block_BF+0x6e>
  802397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239a:	8b 00                	mov    (%eax),%eax
  80239c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80239f:	8b 52 04             	mov    0x4(%edx),%edx
  8023a2:	89 50 04             	mov    %edx,0x4(%eax)
  8023a5:	eb 0b                	jmp    8023b2 <alloc_block_BF+0x79>
  8023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023aa:	8b 40 04             	mov    0x4(%eax),%eax
  8023ad:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b5:	8b 40 04             	mov    0x4(%eax),%eax
  8023b8:	85 c0                	test   %eax,%eax
  8023ba:	74 0f                	je     8023cb <alloc_block_BF+0x92>
  8023bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bf:	8b 40 04             	mov    0x4(%eax),%eax
  8023c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c5:	8b 12                	mov    (%edx),%edx
  8023c7:	89 10                	mov    %edx,(%eax)
  8023c9:	eb 0a                	jmp    8023d5 <alloc_block_BF+0x9c>
  8023cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ce:	8b 00                	mov    (%eax),%eax
  8023d0:	a3 38 41 80 00       	mov    %eax,0x804138
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023e8:	a1 44 41 80 00       	mov    0x804144,%eax
  8023ed:	48                   	dec    %eax
  8023ee:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8023f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f6:	e9 11 02 00 00       	jmp    80260c <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023fb:	a1 40 41 80 00       	mov    0x804140,%eax
  802400:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802403:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802407:	74 07                	je     802410 <alloc_block_BF+0xd7>
  802409:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240c:	8b 00                	mov    (%eax),%eax
  80240e:	eb 05                	jmp    802415 <alloc_block_BF+0xdc>
  802410:	b8 00 00 00 00       	mov    $0x0,%eax
  802415:	a3 40 41 80 00       	mov    %eax,0x804140
  80241a:	a1 40 41 80 00       	mov    0x804140,%eax
  80241f:	85 c0                	test   %eax,%eax
  802421:	0f 85 3b ff ff ff    	jne    802362 <alloc_block_BF+0x29>
  802427:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242b:	0f 85 31 ff ff ff    	jne    802362 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802431:	a1 38 41 80 00       	mov    0x804138,%eax
  802436:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802439:	eb 27                	jmp    802462 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	8b 40 0c             	mov    0xc(%eax),%eax
  802441:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802444:	76 14                	jbe    80245a <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802449:	8b 40 0c             	mov    0xc(%eax),%eax
  80244c:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  80244f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802452:	8b 40 08             	mov    0x8(%eax),%eax
  802455:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802458:	eb 2e                	jmp    802488 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80245a:	a1 40 41 80 00       	mov    0x804140,%eax
  80245f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802462:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802466:	74 07                	je     80246f <alloc_block_BF+0x136>
  802468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246b:	8b 00                	mov    (%eax),%eax
  80246d:	eb 05                	jmp    802474 <alloc_block_BF+0x13b>
  80246f:	b8 00 00 00 00       	mov    $0x0,%eax
  802474:	a3 40 41 80 00       	mov    %eax,0x804140
  802479:	a1 40 41 80 00       	mov    0x804140,%eax
  80247e:	85 c0                	test   %eax,%eax
  802480:	75 b9                	jne    80243b <alloc_block_BF+0x102>
  802482:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802486:	75 b3                	jne    80243b <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802488:	a1 38 41 80 00       	mov    0x804138,%eax
  80248d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802490:	eb 30                	jmp    8024c2 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802495:	8b 40 0c             	mov    0xc(%eax),%eax
  802498:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80249b:	73 1d                	jae    8024ba <alloc_block_BF+0x181>
  80249d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8024a6:	76 12                	jbe    8024ba <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  8024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  8024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b4:	8b 40 08             	mov    0x8(%eax),%eax
  8024b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024ba:	a1 40 41 80 00       	mov    0x804140,%eax
  8024bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c6:	74 07                	je     8024cf <alloc_block_BF+0x196>
  8024c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cb:	8b 00                	mov    (%eax),%eax
  8024cd:	eb 05                	jmp    8024d4 <alloc_block_BF+0x19b>
  8024cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d4:	a3 40 41 80 00       	mov    %eax,0x804140
  8024d9:	a1 40 41 80 00       	mov    0x804140,%eax
  8024de:	85 c0                	test   %eax,%eax
  8024e0:	75 b0                	jne    802492 <alloc_block_BF+0x159>
  8024e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e6:	75 aa                	jne    802492 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024e8:	a1 38 41 80 00       	mov    0x804138,%eax
  8024ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024f0:	e9 e4 00 00 00       	jmp    8025d9 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  8024f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8024fb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8024fe:	0f 85 cd 00 00 00    	jne    8025d1 <alloc_block_BF+0x298>
  802504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802507:	8b 40 08             	mov    0x8(%eax),%eax
  80250a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80250d:	0f 85 be 00 00 00    	jne    8025d1 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802513:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802517:	75 17                	jne    802530 <alloc_block_BF+0x1f7>
  802519:	83 ec 04             	sub    $0x4,%esp
  80251c:	68 48 38 80 00       	push   $0x803848
  802521:	68 db 00 00 00       	push   $0xdb
  802526:	68 d7 37 80 00       	push   $0x8037d7
  80252b:	e8 26 08 00 00       	call   802d56 <_panic>
  802530:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802533:	8b 00                	mov    (%eax),%eax
  802535:	85 c0                	test   %eax,%eax
  802537:	74 10                	je     802549 <alloc_block_BF+0x210>
  802539:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80253c:	8b 00                	mov    (%eax),%eax
  80253e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802541:	8b 52 04             	mov    0x4(%edx),%edx
  802544:	89 50 04             	mov    %edx,0x4(%eax)
  802547:	eb 0b                	jmp    802554 <alloc_block_BF+0x21b>
  802549:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80254c:	8b 40 04             	mov    0x4(%eax),%eax
  80254f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802554:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802557:	8b 40 04             	mov    0x4(%eax),%eax
  80255a:	85 c0                	test   %eax,%eax
  80255c:	74 0f                	je     80256d <alloc_block_BF+0x234>
  80255e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802561:	8b 40 04             	mov    0x4(%eax),%eax
  802564:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802567:	8b 12                	mov    (%edx),%edx
  802569:	89 10                	mov    %edx,(%eax)
  80256b:	eb 0a                	jmp    802577 <alloc_block_BF+0x23e>
  80256d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802570:	8b 00                	mov    (%eax),%eax
  802572:	a3 48 41 80 00       	mov    %eax,0x804148
  802577:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80257a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802580:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802583:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80258a:	a1 54 41 80 00       	mov    0x804154,%eax
  80258f:	48                   	dec    %eax
  802590:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802598:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80259b:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  80259e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025a4:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  8025a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ad:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8025b0:	89 c2                	mov    %eax,%edx
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  8025b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bb:	8b 50 08             	mov    0x8(%eax),%edx
  8025be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c4:	01 c2                	add    %eax,%edx
  8025c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c9:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8025cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025cf:	eb 3b                	jmp    80260c <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025d1:	a1 40 41 80 00       	mov    0x804140,%eax
  8025d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025dd:	74 07                	je     8025e6 <alloc_block_BF+0x2ad>
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	8b 00                	mov    (%eax),%eax
  8025e4:	eb 05                	jmp    8025eb <alloc_block_BF+0x2b2>
  8025e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025eb:	a3 40 41 80 00       	mov    %eax,0x804140
  8025f0:	a1 40 41 80 00       	mov    0x804140,%eax
  8025f5:	85 c0                	test   %eax,%eax
  8025f7:	0f 85 f8 fe ff ff    	jne    8024f5 <alloc_block_BF+0x1bc>
  8025fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802601:	0f 85 ee fe ff ff    	jne    8024f5 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802607:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80260c:	c9                   	leave  
  80260d:	c3                   	ret    

0080260e <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  80260e:	55                   	push   %ebp
  80260f:	89 e5                	mov    %esp,%ebp
  802611:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802614:	8b 45 08             	mov    0x8(%ebp),%eax
  802617:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  80261a:	a1 48 41 80 00       	mov    0x804148,%eax
  80261f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802622:	a1 38 41 80 00       	mov    0x804138,%eax
  802627:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80262a:	e9 77 01 00 00       	jmp    8027a6 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  80262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802632:	8b 40 0c             	mov    0xc(%eax),%eax
  802635:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802638:	0f 85 8a 00 00 00    	jne    8026c8 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80263e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802642:	75 17                	jne    80265b <alloc_block_NF+0x4d>
  802644:	83 ec 04             	sub    $0x4,%esp
  802647:	68 48 38 80 00       	push   $0x803848
  80264c:	68 f7 00 00 00       	push   $0xf7
  802651:	68 d7 37 80 00       	push   $0x8037d7
  802656:	e8 fb 06 00 00       	call   802d56 <_panic>
  80265b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265e:	8b 00                	mov    (%eax),%eax
  802660:	85 c0                	test   %eax,%eax
  802662:	74 10                	je     802674 <alloc_block_NF+0x66>
  802664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802667:	8b 00                	mov    (%eax),%eax
  802669:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80266c:	8b 52 04             	mov    0x4(%edx),%edx
  80266f:	89 50 04             	mov    %edx,0x4(%eax)
  802672:	eb 0b                	jmp    80267f <alloc_block_NF+0x71>
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	8b 40 04             	mov    0x4(%eax),%eax
  80267a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802682:	8b 40 04             	mov    0x4(%eax),%eax
  802685:	85 c0                	test   %eax,%eax
  802687:	74 0f                	je     802698 <alloc_block_NF+0x8a>
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	8b 40 04             	mov    0x4(%eax),%eax
  80268f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802692:	8b 12                	mov    (%edx),%edx
  802694:	89 10                	mov    %edx,(%eax)
  802696:	eb 0a                	jmp    8026a2 <alloc_block_NF+0x94>
  802698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269b:	8b 00                	mov    (%eax),%eax
  80269d:	a3 38 41 80 00       	mov    %eax,0x804138
  8026a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026b5:	a1 44 41 80 00       	mov    0x804144,%eax
  8026ba:	48                   	dec    %eax
  8026bb:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c3:	e9 11 01 00 00       	jmp    8027d9 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  8026c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ce:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026d1:	0f 86 c7 00 00 00    	jbe    80279e <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8026d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026db:	75 17                	jne    8026f4 <alloc_block_NF+0xe6>
  8026dd:	83 ec 04             	sub    $0x4,%esp
  8026e0:	68 48 38 80 00       	push   $0x803848
  8026e5:	68 fc 00 00 00       	push   $0xfc
  8026ea:	68 d7 37 80 00       	push   $0x8037d7
  8026ef:	e8 62 06 00 00       	call   802d56 <_panic>
  8026f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f7:	8b 00                	mov    (%eax),%eax
  8026f9:	85 c0                	test   %eax,%eax
  8026fb:	74 10                	je     80270d <alloc_block_NF+0xff>
  8026fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802700:	8b 00                	mov    (%eax),%eax
  802702:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802705:	8b 52 04             	mov    0x4(%edx),%edx
  802708:	89 50 04             	mov    %edx,0x4(%eax)
  80270b:	eb 0b                	jmp    802718 <alloc_block_NF+0x10a>
  80270d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802710:	8b 40 04             	mov    0x4(%eax),%eax
  802713:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802718:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271b:	8b 40 04             	mov    0x4(%eax),%eax
  80271e:	85 c0                	test   %eax,%eax
  802720:	74 0f                	je     802731 <alloc_block_NF+0x123>
  802722:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802725:	8b 40 04             	mov    0x4(%eax),%eax
  802728:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80272b:	8b 12                	mov    (%edx),%edx
  80272d:	89 10                	mov    %edx,(%eax)
  80272f:	eb 0a                	jmp    80273b <alloc_block_NF+0x12d>
  802731:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802734:	8b 00                	mov    (%eax),%eax
  802736:	a3 48 41 80 00       	mov    %eax,0x804148
  80273b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802744:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802747:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80274e:	a1 54 41 80 00       	mov    0x804154,%eax
  802753:	48                   	dec    %eax
  802754:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802759:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80275f:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802765:	8b 40 0c             	mov    0xc(%eax),%eax
  802768:	2b 45 f0             	sub    -0x10(%ebp),%eax
  80276b:	89 c2                	mov    %eax,%edx
  80276d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802770:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802776:	8b 40 08             	mov    0x8(%eax),%eax
  802779:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  80277c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277f:	8b 50 08             	mov    0x8(%eax),%edx
  802782:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802785:	8b 40 0c             	mov    0xc(%eax),%eax
  802788:	01 c2                	add    %eax,%edx
  80278a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278d:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802790:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802793:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802796:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802799:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279c:	eb 3b                	jmp    8027d9 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80279e:	a1 40 41 80 00       	mov    0x804140,%eax
  8027a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027aa:	74 07                	je     8027b3 <alloc_block_NF+0x1a5>
  8027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027af:	8b 00                	mov    (%eax),%eax
  8027b1:	eb 05                	jmp    8027b8 <alloc_block_NF+0x1aa>
  8027b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b8:	a3 40 41 80 00       	mov    %eax,0x804140
  8027bd:	a1 40 41 80 00       	mov    0x804140,%eax
  8027c2:	85 c0                	test   %eax,%eax
  8027c4:	0f 85 65 fe ff ff    	jne    80262f <alloc_block_NF+0x21>
  8027ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ce:	0f 85 5b fe ff ff    	jne    80262f <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8027d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027d9:	c9                   	leave  
  8027da:	c3                   	ret    

008027db <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  8027db:	55                   	push   %ebp
  8027dc:	89 e5                	mov    %esp,%ebp
  8027de:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  8027e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  8027eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ee:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  8027f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027f9:	75 17                	jne    802812 <addToAvailMemBlocksList+0x37>
  8027fb:	83 ec 04             	sub    $0x4,%esp
  8027fe:	68 f0 37 80 00       	push   $0x8037f0
  802803:	68 10 01 00 00       	push   $0x110
  802808:	68 d7 37 80 00       	push   $0x8037d7
  80280d:	e8 44 05 00 00       	call   802d56 <_panic>
  802812:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802818:	8b 45 08             	mov    0x8(%ebp),%eax
  80281b:	89 50 04             	mov    %edx,0x4(%eax)
  80281e:	8b 45 08             	mov    0x8(%ebp),%eax
  802821:	8b 40 04             	mov    0x4(%eax),%eax
  802824:	85 c0                	test   %eax,%eax
  802826:	74 0c                	je     802834 <addToAvailMemBlocksList+0x59>
  802828:	a1 4c 41 80 00       	mov    0x80414c,%eax
  80282d:	8b 55 08             	mov    0x8(%ebp),%edx
  802830:	89 10                	mov    %edx,(%eax)
  802832:	eb 08                	jmp    80283c <addToAvailMemBlocksList+0x61>
  802834:	8b 45 08             	mov    0x8(%ebp),%eax
  802837:	a3 48 41 80 00       	mov    %eax,0x804148
  80283c:	8b 45 08             	mov    0x8(%ebp),%eax
  80283f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802844:	8b 45 08             	mov    0x8(%ebp),%eax
  802847:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80284d:	a1 54 41 80 00       	mov    0x804154,%eax
  802852:	40                   	inc    %eax
  802853:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802858:	90                   	nop
  802859:	c9                   	leave  
  80285a:	c3                   	ret    

0080285b <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80285b:	55                   	push   %ebp
  80285c:	89 e5                	mov    %esp,%ebp
  80285e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802861:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802866:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802869:	a1 44 41 80 00       	mov    0x804144,%eax
  80286e:	85 c0                	test   %eax,%eax
  802870:	75 68                	jne    8028da <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802872:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802876:	75 17                	jne    80288f <insert_sorted_with_merge_freeList+0x34>
  802878:	83 ec 04             	sub    $0x4,%esp
  80287b:	68 b4 37 80 00       	push   $0x8037b4
  802880:	68 1a 01 00 00       	push   $0x11a
  802885:	68 d7 37 80 00       	push   $0x8037d7
  80288a:	e8 c7 04 00 00       	call   802d56 <_panic>
  80288f:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802895:	8b 45 08             	mov    0x8(%ebp),%eax
  802898:	89 10                	mov    %edx,(%eax)
  80289a:	8b 45 08             	mov    0x8(%ebp),%eax
  80289d:	8b 00                	mov    (%eax),%eax
  80289f:	85 c0                	test   %eax,%eax
  8028a1:	74 0d                	je     8028b0 <insert_sorted_with_merge_freeList+0x55>
  8028a3:	a1 38 41 80 00       	mov    0x804138,%eax
  8028a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ab:	89 50 04             	mov    %edx,0x4(%eax)
  8028ae:	eb 08                	jmp    8028b8 <insert_sorted_with_merge_freeList+0x5d>
  8028b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bb:	a3 38 41 80 00       	mov    %eax,0x804138
  8028c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ca:	a1 44 41 80 00       	mov    0x804144,%eax
  8028cf:	40                   	inc    %eax
  8028d0:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8028d5:	e9 c5 03 00 00       	jmp    802c9f <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  8028da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028dd:	8b 50 08             	mov    0x8(%eax),%edx
  8028e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e3:	8b 40 08             	mov    0x8(%eax),%eax
  8028e6:	39 c2                	cmp    %eax,%edx
  8028e8:	0f 83 b2 00 00 00    	jae    8029a0 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  8028ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f1:	8b 50 08             	mov    0x8(%eax),%edx
  8028f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028fa:	01 c2                	add    %eax,%edx
  8028fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ff:	8b 40 08             	mov    0x8(%eax),%eax
  802902:	39 c2                	cmp    %eax,%edx
  802904:	75 27                	jne    80292d <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802906:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802909:	8b 50 0c             	mov    0xc(%eax),%edx
  80290c:	8b 45 08             	mov    0x8(%ebp),%eax
  80290f:	8b 40 0c             	mov    0xc(%eax),%eax
  802912:	01 c2                	add    %eax,%edx
  802914:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802917:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  80291a:	83 ec 0c             	sub    $0xc,%esp
  80291d:	ff 75 08             	pushl  0x8(%ebp)
  802920:	e8 b6 fe ff ff       	call   8027db <addToAvailMemBlocksList>
  802925:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802928:	e9 72 03 00 00       	jmp    802c9f <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  80292d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802931:	74 06                	je     802939 <insert_sorted_with_merge_freeList+0xde>
  802933:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802937:	75 17                	jne    802950 <insert_sorted_with_merge_freeList+0xf5>
  802939:	83 ec 04             	sub    $0x4,%esp
  80293c:	68 14 38 80 00       	push   $0x803814
  802941:	68 24 01 00 00       	push   $0x124
  802946:	68 d7 37 80 00       	push   $0x8037d7
  80294b:	e8 06 04 00 00       	call   802d56 <_panic>
  802950:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802953:	8b 10                	mov    (%eax),%edx
  802955:	8b 45 08             	mov    0x8(%ebp),%eax
  802958:	89 10                	mov    %edx,(%eax)
  80295a:	8b 45 08             	mov    0x8(%ebp),%eax
  80295d:	8b 00                	mov    (%eax),%eax
  80295f:	85 c0                	test   %eax,%eax
  802961:	74 0b                	je     80296e <insert_sorted_with_merge_freeList+0x113>
  802963:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802966:	8b 00                	mov    (%eax),%eax
  802968:	8b 55 08             	mov    0x8(%ebp),%edx
  80296b:	89 50 04             	mov    %edx,0x4(%eax)
  80296e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802971:	8b 55 08             	mov    0x8(%ebp),%edx
  802974:	89 10                	mov    %edx,(%eax)
  802976:	8b 45 08             	mov    0x8(%ebp),%eax
  802979:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80297c:	89 50 04             	mov    %edx,0x4(%eax)
  80297f:	8b 45 08             	mov    0x8(%ebp),%eax
  802982:	8b 00                	mov    (%eax),%eax
  802984:	85 c0                	test   %eax,%eax
  802986:	75 08                	jne    802990 <insert_sorted_with_merge_freeList+0x135>
  802988:	8b 45 08             	mov    0x8(%ebp),%eax
  80298b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802990:	a1 44 41 80 00       	mov    0x804144,%eax
  802995:	40                   	inc    %eax
  802996:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80299b:	e9 ff 02 00 00       	jmp    802c9f <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  8029a0:	a1 38 41 80 00       	mov    0x804138,%eax
  8029a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a8:	e9 c2 02 00 00       	jmp    802c6f <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  8029ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b0:	8b 50 08             	mov    0x8(%eax),%edx
  8029b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b6:	8b 40 08             	mov    0x8(%eax),%eax
  8029b9:	39 c2                	cmp    %eax,%edx
  8029bb:	0f 86 a6 02 00 00    	jbe    802c67 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  8029c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c4:	8b 40 04             	mov    0x4(%eax),%eax
  8029c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  8029ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029ce:	0f 85 ba 00 00 00    	jne    802a8e <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8029d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d7:	8b 50 0c             	mov    0xc(%eax),%edx
  8029da:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dd:	8b 40 08             	mov    0x8(%eax),%eax
  8029e0:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8029e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e5:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8029e8:	39 c2                	cmp    %eax,%edx
  8029ea:	75 33                	jne    802a1f <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  8029ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ef:	8b 50 08             	mov    0x8(%eax),%edx
  8029f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f5:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fb:	8b 50 0c             	mov    0xc(%eax),%edx
  8029fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802a01:	8b 40 0c             	mov    0xc(%eax),%eax
  802a04:	01 c2                	add    %eax,%edx
  802a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a09:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802a0c:	83 ec 0c             	sub    $0xc,%esp
  802a0f:	ff 75 08             	pushl  0x8(%ebp)
  802a12:	e8 c4 fd ff ff       	call   8027db <addToAvailMemBlocksList>
  802a17:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802a1a:	e9 80 02 00 00       	jmp    802c9f <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802a1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a23:	74 06                	je     802a2b <insert_sorted_with_merge_freeList+0x1d0>
  802a25:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a29:	75 17                	jne    802a42 <insert_sorted_with_merge_freeList+0x1e7>
  802a2b:	83 ec 04             	sub    $0x4,%esp
  802a2e:	68 68 38 80 00       	push   $0x803868
  802a33:	68 3a 01 00 00       	push   $0x13a
  802a38:	68 d7 37 80 00       	push   $0x8037d7
  802a3d:	e8 14 03 00 00       	call   802d56 <_panic>
  802a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a45:	8b 50 04             	mov    0x4(%eax),%edx
  802a48:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4b:	89 50 04             	mov    %edx,0x4(%eax)
  802a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a54:	89 10                	mov    %edx,(%eax)
  802a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a59:	8b 40 04             	mov    0x4(%eax),%eax
  802a5c:	85 c0                	test   %eax,%eax
  802a5e:	74 0d                	je     802a6d <insert_sorted_with_merge_freeList+0x212>
  802a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a63:	8b 40 04             	mov    0x4(%eax),%eax
  802a66:	8b 55 08             	mov    0x8(%ebp),%edx
  802a69:	89 10                	mov    %edx,(%eax)
  802a6b:	eb 08                	jmp    802a75 <insert_sorted_with_merge_freeList+0x21a>
  802a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a70:	a3 38 41 80 00       	mov    %eax,0x804138
  802a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a78:	8b 55 08             	mov    0x8(%ebp),%edx
  802a7b:	89 50 04             	mov    %edx,0x4(%eax)
  802a7e:	a1 44 41 80 00       	mov    0x804144,%eax
  802a83:	40                   	inc    %eax
  802a84:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802a89:	e9 11 02 00 00       	jmp    802c9f <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802a8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a91:	8b 50 08             	mov    0x8(%eax),%edx
  802a94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a97:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9a:	01 c2                	add    %eax,%edx
  802a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa2:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa7:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802aaa:	39 c2                	cmp    %eax,%edx
  802aac:	0f 85 bf 00 00 00    	jne    802b71 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802ab2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab5:	8b 50 0c             	mov    0xc(%eax),%edx
  802ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  802abb:	8b 40 0c             	mov    0xc(%eax),%eax
  802abe:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac6:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802ac8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802acb:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802ace:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad2:	75 17                	jne    802aeb <insert_sorted_with_merge_freeList+0x290>
  802ad4:	83 ec 04             	sub    $0x4,%esp
  802ad7:	68 48 38 80 00       	push   $0x803848
  802adc:	68 43 01 00 00       	push   $0x143
  802ae1:	68 d7 37 80 00       	push   $0x8037d7
  802ae6:	e8 6b 02 00 00       	call   802d56 <_panic>
  802aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aee:	8b 00                	mov    (%eax),%eax
  802af0:	85 c0                	test   %eax,%eax
  802af2:	74 10                	je     802b04 <insert_sorted_with_merge_freeList+0x2a9>
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	8b 00                	mov    (%eax),%eax
  802af9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802afc:	8b 52 04             	mov    0x4(%edx),%edx
  802aff:	89 50 04             	mov    %edx,0x4(%eax)
  802b02:	eb 0b                	jmp    802b0f <insert_sorted_with_merge_freeList+0x2b4>
  802b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b07:	8b 40 04             	mov    0x4(%eax),%eax
  802b0a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b12:	8b 40 04             	mov    0x4(%eax),%eax
  802b15:	85 c0                	test   %eax,%eax
  802b17:	74 0f                	je     802b28 <insert_sorted_with_merge_freeList+0x2cd>
  802b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1c:	8b 40 04             	mov    0x4(%eax),%eax
  802b1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b22:	8b 12                	mov    (%edx),%edx
  802b24:	89 10                	mov    %edx,(%eax)
  802b26:	eb 0a                	jmp    802b32 <insert_sorted_with_merge_freeList+0x2d7>
  802b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2b:	8b 00                	mov    (%eax),%eax
  802b2d:	a3 38 41 80 00       	mov    %eax,0x804138
  802b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b35:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b45:	a1 44 41 80 00       	mov    0x804144,%eax
  802b4a:	48                   	dec    %eax
  802b4b:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802b50:	83 ec 0c             	sub    $0xc,%esp
  802b53:	ff 75 08             	pushl  0x8(%ebp)
  802b56:	e8 80 fc ff ff       	call   8027db <addToAvailMemBlocksList>
  802b5b:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802b5e:	83 ec 0c             	sub    $0xc,%esp
  802b61:	ff 75 f4             	pushl  -0xc(%ebp)
  802b64:	e8 72 fc ff ff       	call   8027db <addToAvailMemBlocksList>
  802b69:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802b6c:	e9 2e 01 00 00       	jmp    802c9f <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802b71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b74:	8b 50 08             	mov    0x8(%eax),%edx
  802b77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7d:	01 c2                	add    %eax,%edx
  802b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b82:	8b 40 08             	mov    0x8(%eax),%eax
  802b85:	39 c2                	cmp    %eax,%edx
  802b87:	75 27                	jne    802bb0 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802b89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8c:	8b 50 0c             	mov    0xc(%eax),%edx
  802b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b92:	8b 40 0c             	mov    0xc(%eax),%eax
  802b95:	01 c2                	add    %eax,%edx
  802b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9a:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802b9d:	83 ec 0c             	sub    $0xc,%esp
  802ba0:	ff 75 08             	pushl  0x8(%ebp)
  802ba3:	e8 33 fc ff ff       	call   8027db <addToAvailMemBlocksList>
  802ba8:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802bab:	e9 ef 00 00 00       	jmp    802c9f <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb3:	8b 50 0c             	mov    0xc(%eax),%edx
  802bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb9:	8b 40 08             	mov    0x8(%eax),%eax
  802bbc:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc1:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802bc4:	39 c2                	cmp    %eax,%edx
  802bc6:	75 33                	jne    802bfb <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcb:	8b 50 08             	mov    0x8(%eax),%edx
  802bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd1:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd7:	8b 50 0c             	mov    0xc(%eax),%edx
  802bda:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdd:	8b 40 0c             	mov    0xc(%eax),%eax
  802be0:	01 c2                	add    %eax,%edx
  802be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be5:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802be8:	83 ec 0c             	sub    $0xc,%esp
  802beb:	ff 75 08             	pushl  0x8(%ebp)
  802bee:	e8 e8 fb ff ff       	call   8027db <addToAvailMemBlocksList>
  802bf3:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802bf6:	e9 a4 00 00 00       	jmp    802c9f <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802bfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bff:	74 06                	je     802c07 <insert_sorted_with_merge_freeList+0x3ac>
  802c01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c05:	75 17                	jne    802c1e <insert_sorted_with_merge_freeList+0x3c3>
  802c07:	83 ec 04             	sub    $0x4,%esp
  802c0a:	68 68 38 80 00       	push   $0x803868
  802c0f:	68 56 01 00 00       	push   $0x156
  802c14:	68 d7 37 80 00       	push   $0x8037d7
  802c19:	e8 38 01 00 00       	call   802d56 <_panic>
  802c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c21:	8b 50 04             	mov    0x4(%eax),%edx
  802c24:	8b 45 08             	mov    0x8(%ebp),%eax
  802c27:	89 50 04             	mov    %edx,0x4(%eax)
  802c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c30:	89 10                	mov    %edx,(%eax)
  802c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c35:	8b 40 04             	mov    0x4(%eax),%eax
  802c38:	85 c0                	test   %eax,%eax
  802c3a:	74 0d                	je     802c49 <insert_sorted_with_merge_freeList+0x3ee>
  802c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3f:	8b 40 04             	mov    0x4(%eax),%eax
  802c42:	8b 55 08             	mov    0x8(%ebp),%edx
  802c45:	89 10                	mov    %edx,(%eax)
  802c47:	eb 08                	jmp    802c51 <insert_sorted_with_merge_freeList+0x3f6>
  802c49:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4c:	a3 38 41 80 00       	mov    %eax,0x804138
  802c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c54:	8b 55 08             	mov    0x8(%ebp),%edx
  802c57:	89 50 04             	mov    %edx,0x4(%eax)
  802c5a:	a1 44 41 80 00       	mov    0x804144,%eax
  802c5f:	40                   	inc    %eax
  802c60:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802c65:	eb 38                	jmp    802c9f <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802c67:	a1 40 41 80 00       	mov    0x804140,%eax
  802c6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c73:	74 07                	je     802c7c <insert_sorted_with_merge_freeList+0x421>
  802c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c78:	8b 00                	mov    (%eax),%eax
  802c7a:	eb 05                	jmp    802c81 <insert_sorted_with_merge_freeList+0x426>
  802c7c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c81:	a3 40 41 80 00       	mov    %eax,0x804140
  802c86:	a1 40 41 80 00       	mov    0x804140,%eax
  802c8b:	85 c0                	test   %eax,%eax
  802c8d:	0f 85 1a fd ff ff    	jne    8029ad <insert_sorted_with_merge_freeList+0x152>
  802c93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c97:	0f 85 10 fd ff ff    	jne    8029ad <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802c9d:	eb 00                	jmp    802c9f <insert_sorted_with_merge_freeList+0x444>
  802c9f:	90                   	nop
  802ca0:	c9                   	leave  
  802ca1:	c3                   	ret    

00802ca2 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802ca2:	55                   	push   %ebp
  802ca3:	89 e5                	mov    %esp,%ebp
  802ca5:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  802cab:	89 d0                	mov    %edx,%eax
  802cad:	c1 e0 02             	shl    $0x2,%eax
  802cb0:	01 d0                	add    %edx,%eax
  802cb2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802cb9:	01 d0                	add    %edx,%eax
  802cbb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802cc2:	01 d0                	add    %edx,%eax
  802cc4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ccb:	01 d0                	add    %edx,%eax
  802ccd:	c1 e0 04             	shl    $0x4,%eax
  802cd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802cd3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802cda:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802cdd:	83 ec 0c             	sub    $0xc,%esp
  802ce0:	50                   	push   %eax
  802ce1:	e8 60 ed ff ff       	call   801a46 <sys_get_virtual_time>
  802ce6:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802ce9:	eb 41                	jmp    802d2c <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802ceb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802cee:	83 ec 0c             	sub    $0xc,%esp
  802cf1:	50                   	push   %eax
  802cf2:	e8 4f ed ff ff       	call   801a46 <sys_get_virtual_time>
  802cf7:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802cfa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d00:	29 c2                	sub    %eax,%edx
  802d02:	89 d0                	mov    %edx,%eax
  802d04:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802d07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0d:	89 d1                	mov    %edx,%ecx
  802d0f:	29 c1                	sub    %eax,%ecx
  802d11:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802d14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d17:	39 c2                	cmp    %eax,%edx
  802d19:	0f 97 c0             	seta   %al
  802d1c:	0f b6 c0             	movzbl %al,%eax
  802d1f:	29 c1                	sub    %eax,%ecx
  802d21:	89 c8                	mov    %ecx,%eax
  802d23:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802d26:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d29:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d32:	72 b7                	jb     802ceb <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802d34:	90                   	nop
  802d35:	c9                   	leave  
  802d36:	c3                   	ret    

00802d37 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802d37:	55                   	push   %ebp
  802d38:	89 e5                	mov    %esp,%ebp
  802d3a:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802d3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802d44:	eb 03                	jmp    802d49 <busy_wait+0x12>
  802d46:	ff 45 fc             	incl   -0x4(%ebp)
  802d49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d4c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d4f:	72 f5                	jb     802d46 <busy_wait+0xf>
	return i;
  802d51:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802d54:	c9                   	leave  
  802d55:	c3                   	ret    

00802d56 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802d56:	55                   	push   %ebp
  802d57:	89 e5                	mov    %esp,%ebp
  802d59:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802d5c:	8d 45 10             	lea    0x10(%ebp),%eax
  802d5f:	83 c0 04             	add    $0x4,%eax
  802d62:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802d65:	a1 60 41 80 00       	mov    0x804160,%eax
  802d6a:	85 c0                	test   %eax,%eax
  802d6c:	74 16                	je     802d84 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802d6e:	a1 60 41 80 00       	mov    0x804160,%eax
  802d73:	83 ec 08             	sub    $0x8,%esp
  802d76:	50                   	push   %eax
  802d77:	68 a0 38 80 00       	push   $0x8038a0
  802d7c:	e8 fb d5 ff ff       	call   80037c <cprintf>
  802d81:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802d84:	a1 00 40 80 00       	mov    0x804000,%eax
  802d89:	ff 75 0c             	pushl  0xc(%ebp)
  802d8c:	ff 75 08             	pushl  0x8(%ebp)
  802d8f:	50                   	push   %eax
  802d90:	68 a5 38 80 00       	push   $0x8038a5
  802d95:	e8 e2 d5 ff ff       	call   80037c <cprintf>
  802d9a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802d9d:	8b 45 10             	mov    0x10(%ebp),%eax
  802da0:	83 ec 08             	sub    $0x8,%esp
  802da3:	ff 75 f4             	pushl  -0xc(%ebp)
  802da6:	50                   	push   %eax
  802da7:	e8 65 d5 ff ff       	call   800311 <vcprintf>
  802dac:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802daf:	83 ec 08             	sub    $0x8,%esp
  802db2:	6a 00                	push   $0x0
  802db4:	68 c1 38 80 00       	push   $0x8038c1
  802db9:	e8 53 d5 ff ff       	call   800311 <vcprintf>
  802dbe:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802dc1:	e8 d4 d4 ff ff       	call   80029a <exit>

	// should not return here
	while (1) ;
  802dc6:	eb fe                	jmp    802dc6 <_panic+0x70>

00802dc8 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802dc8:	55                   	push   %ebp
  802dc9:	89 e5                	mov    %esp,%ebp
  802dcb:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802dce:	a1 20 40 80 00       	mov    0x804020,%eax
  802dd3:	8b 50 74             	mov    0x74(%eax),%edx
  802dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dd9:	39 c2                	cmp    %eax,%edx
  802ddb:	74 14                	je     802df1 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802ddd:	83 ec 04             	sub    $0x4,%esp
  802de0:	68 c4 38 80 00       	push   $0x8038c4
  802de5:	6a 26                	push   $0x26
  802de7:	68 10 39 80 00       	push   $0x803910
  802dec:	e8 65 ff ff ff       	call   802d56 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802df1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802df8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802dff:	e9 c2 00 00 00       	jmp    802ec6 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  802e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e07:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e11:	01 d0                	add    %edx,%eax
  802e13:	8b 00                	mov    (%eax),%eax
  802e15:	85 c0                	test   %eax,%eax
  802e17:	75 08                	jne    802e21 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  802e19:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802e1c:	e9 a2 00 00 00       	jmp    802ec3 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  802e21:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802e28:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802e2f:	eb 69                	jmp    802e9a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802e31:	a1 20 40 80 00       	mov    0x804020,%eax
  802e36:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802e3c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e3f:	89 d0                	mov    %edx,%eax
  802e41:	01 c0                	add    %eax,%eax
  802e43:	01 d0                	add    %edx,%eax
  802e45:	c1 e0 03             	shl    $0x3,%eax
  802e48:	01 c8                	add    %ecx,%eax
  802e4a:	8a 40 04             	mov    0x4(%eax),%al
  802e4d:	84 c0                	test   %al,%al
  802e4f:	75 46                	jne    802e97 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802e51:	a1 20 40 80 00       	mov    0x804020,%eax
  802e56:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802e5c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e5f:	89 d0                	mov    %edx,%eax
  802e61:	01 c0                	add    %eax,%eax
  802e63:	01 d0                	add    %edx,%eax
  802e65:	c1 e0 03             	shl    $0x3,%eax
  802e68:	01 c8                	add    %ecx,%eax
  802e6a:	8b 00                	mov    (%eax),%eax
  802e6c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802e6f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802e77:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802e83:	8b 45 08             	mov    0x8(%ebp),%eax
  802e86:	01 c8                	add    %ecx,%eax
  802e88:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802e8a:	39 c2                	cmp    %eax,%edx
  802e8c:	75 09                	jne    802e97 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  802e8e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802e95:	eb 12                	jmp    802ea9 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802e97:	ff 45 e8             	incl   -0x18(%ebp)
  802e9a:	a1 20 40 80 00       	mov    0x804020,%eax
  802e9f:	8b 50 74             	mov    0x74(%eax),%edx
  802ea2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea5:	39 c2                	cmp    %eax,%edx
  802ea7:	77 88                	ja     802e31 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802ea9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ead:	75 14                	jne    802ec3 <CheckWSWithoutLastIndex+0xfb>
			panic(
  802eaf:	83 ec 04             	sub    $0x4,%esp
  802eb2:	68 1c 39 80 00       	push   $0x80391c
  802eb7:	6a 3a                	push   $0x3a
  802eb9:	68 10 39 80 00       	push   $0x803910
  802ebe:	e8 93 fe ff ff       	call   802d56 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802ec3:	ff 45 f0             	incl   -0x10(%ebp)
  802ec6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ecc:	0f 8c 32 ff ff ff    	jl     802e04 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802ed2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802ed9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802ee0:	eb 26                	jmp    802f08 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802ee2:	a1 20 40 80 00       	mov    0x804020,%eax
  802ee7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802eed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ef0:	89 d0                	mov    %edx,%eax
  802ef2:	01 c0                	add    %eax,%eax
  802ef4:	01 d0                	add    %edx,%eax
  802ef6:	c1 e0 03             	shl    $0x3,%eax
  802ef9:	01 c8                	add    %ecx,%eax
  802efb:	8a 40 04             	mov    0x4(%eax),%al
  802efe:	3c 01                	cmp    $0x1,%al
  802f00:	75 03                	jne    802f05 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  802f02:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802f05:	ff 45 e0             	incl   -0x20(%ebp)
  802f08:	a1 20 40 80 00       	mov    0x804020,%eax
  802f0d:	8b 50 74             	mov    0x74(%eax),%edx
  802f10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f13:	39 c2                	cmp    %eax,%edx
  802f15:	77 cb                	ja     802ee2 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f1d:	74 14                	je     802f33 <CheckWSWithoutLastIndex+0x16b>
		panic(
  802f1f:	83 ec 04             	sub    $0x4,%esp
  802f22:	68 70 39 80 00       	push   $0x803970
  802f27:	6a 44                	push   $0x44
  802f29:	68 10 39 80 00       	push   $0x803910
  802f2e:	e8 23 fe ff ff       	call   802d56 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802f33:	90                   	nop
  802f34:	c9                   	leave  
  802f35:	c3                   	ret    
  802f36:	66 90                	xchg   %ax,%ax

00802f38 <__udivdi3>:
  802f38:	55                   	push   %ebp
  802f39:	57                   	push   %edi
  802f3a:	56                   	push   %esi
  802f3b:	53                   	push   %ebx
  802f3c:	83 ec 1c             	sub    $0x1c,%esp
  802f3f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802f43:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802f47:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802f4b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f4f:	89 ca                	mov    %ecx,%edx
  802f51:	89 f8                	mov    %edi,%eax
  802f53:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802f57:	85 f6                	test   %esi,%esi
  802f59:	75 2d                	jne    802f88 <__udivdi3+0x50>
  802f5b:	39 cf                	cmp    %ecx,%edi
  802f5d:	77 65                	ja     802fc4 <__udivdi3+0x8c>
  802f5f:	89 fd                	mov    %edi,%ebp
  802f61:	85 ff                	test   %edi,%edi
  802f63:	75 0b                	jne    802f70 <__udivdi3+0x38>
  802f65:	b8 01 00 00 00       	mov    $0x1,%eax
  802f6a:	31 d2                	xor    %edx,%edx
  802f6c:	f7 f7                	div    %edi
  802f6e:	89 c5                	mov    %eax,%ebp
  802f70:	31 d2                	xor    %edx,%edx
  802f72:	89 c8                	mov    %ecx,%eax
  802f74:	f7 f5                	div    %ebp
  802f76:	89 c1                	mov    %eax,%ecx
  802f78:	89 d8                	mov    %ebx,%eax
  802f7a:	f7 f5                	div    %ebp
  802f7c:	89 cf                	mov    %ecx,%edi
  802f7e:	89 fa                	mov    %edi,%edx
  802f80:	83 c4 1c             	add    $0x1c,%esp
  802f83:	5b                   	pop    %ebx
  802f84:	5e                   	pop    %esi
  802f85:	5f                   	pop    %edi
  802f86:	5d                   	pop    %ebp
  802f87:	c3                   	ret    
  802f88:	39 ce                	cmp    %ecx,%esi
  802f8a:	77 28                	ja     802fb4 <__udivdi3+0x7c>
  802f8c:	0f bd fe             	bsr    %esi,%edi
  802f8f:	83 f7 1f             	xor    $0x1f,%edi
  802f92:	75 40                	jne    802fd4 <__udivdi3+0x9c>
  802f94:	39 ce                	cmp    %ecx,%esi
  802f96:	72 0a                	jb     802fa2 <__udivdi3+0x6a>
  802f98:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802f9c:	0f 87 9e 00 00 00    	ja     803040 <__udivdi3+0x108>
  802fa2:	b8 01 00 00 00       	mov    $0x1,%eax
  802fa7:	89 fa                	mov    %edi,%edx
  802fa9:	83 c4 1c             	add    $0x1c,%esp
  802fac:	5b                   	pop    %ebx
  802fad:	5e                   	pop    %esi
  802fae:	5f                   	pop    %edi
  802faf:	5d                   	pop    %ebp
  802fb0:	c3                   	ret    
  802fb1:	8d 76 00             	lea    0x0(%esi),%esi
  802fb4:	31 ff                	xor    %edi,%edi
  802fb6:	31 c0                	xor    %eax,%eax
  802fb8:	89 fa                	mov    %edi,%edx
  802fba:	83 c4 1c             	add    $0x1c,%esp
  802fbd:	5b                   	pop    %ebx
  802fbe:	5e                   	pop    %esi
  802fbf:	5f                   	pop    %edi
  802fc0:	5d                   	pop    %ebp
  802fc1:	c3                   	ret    
  802fc2:	66 90                	xchg   %ax,%ax
  802fc4:	89 d8                	mov    %ebx,%eax
  802fc6:	f7 f7                	div    %edi
  802fc8:	31 ff                	xor    %edi,%edi
  802fca:	89 fa                	mov    %edi,%edx
  802fcc:	83 c4 1c             	add    $0x1c,%esp
  802fcf:	5b                   	pop    %ebx
  802fd0:	5e                   	pop    %esi
  802fd1:	5f                   	pop    %edi
  802fd2:	5d                   	pop    %ebp
  802fd3:	c3                   	ret    
  802fd4:	bd 20 00 00 00       	mov    $0x20,%ebp
  802fd9:	89 eb                	mov    %ebp,%ebx
  802fdb:	29 fb                	sub    %edi,%ebx
  802fdd:	89 f9                	mov    %edi,%ecx
  802fdf:	d3 e6                	shl    %cl,%esi
  802fe1:	89 c5                	mov    %eax,%ebp
  802fe3:	88 d9                	mov    %bl,%cl
  802fe5:	d3 ed                	shr    %cl,%ebp
  802fe7:	89 e9                	mov    %ebp,%ecx
  802fe9:	09 f1                	or     %esi,%ecx
  802feb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802fef:	89 f9                	mov    %edi,%ecx
  802ff1:	d3 e0                	shl    %cl,%eax
  802ff3:	89 c5                	mov    %eax,%ebp
  802ff5:	89 d6                	mov    %edx,%esi
  802ff7:	88 d9                	mov    %bl,%cl
  802ff9:	d3 ee                	shr    %cl,%esi
  802ffb:	89 f9                	mov    %edi,%ecx
  802ffd:	d3 e2                	shl    %cl,%edx
  802fff:	8b 44 24 08          	mov    0x8(%esp),%eax
  803003:	88 d9                	mov    %bl,%cl
  803005:	d3 e8                	shr    %cl,%eax
  803007:	09 c2                	or     %eax,%edx
  803009:	89 d0                	mov    %edx,%eax
  80300b:	89 f2                	mov    %esi,%edx
  80300d:	f7 74 24 0c          	divl   0xc(%esp)
  803011:	89 d6                	mov    %edx,%esi
  803013:	89 c3                	mov    %eax,%ebx
  803015:	f7 e5                	mul    %ebp
  803017:	39 d6                	cmp    %edx,%esi
  803019:	72 19                	jb     803034 <__udivdi3+0xfc>
  80301b:	74 0b                	je     803028 <__udivdi3+0xf0>
  80301d:	89 d8                	mov    %ebx,%eax
  80301f:	31 ff                	xor    %edi,%edi
  803021:	e9 58 ff ff ff       	jmp    802f7e <__udivdi3+0x46>
  803026:	66 90                	xchg   %ax,%ax
  803028:	8b 54 24 08          	mov    0x8(%esp),%edx
  80302c:	89 f9                	mov    %edi,%ecx
  80302e:	d3 e2                	shl    %cl,%edx
  803030:	39 c2                	cmp    %eax,%edx
  803032:	73 e9                	jae    80301d <__udivdi3+0xe5>
  803034:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803037:	31 ff                	xor    %edi,%edi
  803039:	e9 40 ff ff ff       	jmp    802f7e <__udivdi3+0x46>
  80303e:	66 90                	xchg   %ax,%ax
  803040:	31 c0                	xor    %eax,%eax
  803042:	e9 37 ff ff ff       	jmp    802f7e <__udivdi3+0x46>
  803047:	90                   	nop

00803048 <__umoddi3>:
  803048:	55                   	push   %ebp
  803049:	57                   	push   %edi
  80304a:	56                   	push   %esi
  80304b:	53                   	push   %ebx
  80304c:	83 ec 1c             	sub    $0x1c,%esp
  80304f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803053:	8b 74 24 34          	mov    0x34(%esp),%esi
  803057:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80305b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80305f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803063:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803067:	89 f3                	mov    %esi,%ebx
  803069:	89 fa                	mov    %edi,%edx
  80306b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80306f:	89 34 24             	mov    %esi,(%esp)
  803072:	85 c0                	test   %eax,%eax
  803074:	75 1a                	jne    803090 <__umoddi3+0x48>
  803076:	39 f7                	cmp    %esi,%edi
  803078:	0f 86 a2 00 00 00    	jbe    803120 <__umoddi3+0xd8>
  80307e:	89 c8                	mov    %ecx,%eax
  803080:	89 f2                	mov    %esi,%edx
  803082:	f7 f7                	div    %edi
  803084:	89 d0                	mov    %edx,%eax
  803086:	31 d2                	xor    %edx,%edx
  803088:	83 c4 1c             	add    $0x1c,%esp
  80308b:	5b                   	pop    %ebx
  80308c:	5e                   	pop    %esi
  80308d:	5f                   	pop    %edi
  80308e:	5d                   	pop    %ebp
  80308f:	c3                   	ret    
  803090:	39 f0                	cmp    %esi,%eax
  803092:	0f 87 ac 00 00 00    	ja     803144 <__umoddi3+0xfc>
  803098:	0f bd e8             	bsr    %eax,%ebp
  80309b:	83 f5 1f             	xor    $0x1f,%ebp
  80309e:	0f 84 ac 00 00 00    	je     803150 <__umoddi3+0x108>
  8030a4:	bf 20 00 00 00       	mov    $0x20,%edi
  8030a9:	29 ef                	sub    %ebp,%edi
  8030ab:	89 fe                	mov    %edi,%esi
  8030ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8030b1:	89 e9                	mov    %ebp,%ecx
  8030b3:	d3 e0                	shl    %cl,%eax
  8030b5:	89 d7                	mov    %edx,%edi
  8030b7:	89 f1                	mov    %esi,%ecx
  8030b9:	d3 ef                	shr    %cl,%edi
  8030bb:	09 c7                	or     %eax,%edi
  8030bd:	89 e9                	mov    %ebp,%ecx
  8030bf:	d3 e2                	shl    %cl,%edx
  8030c1:	89 14 24             	mov    %edx,(%esp)
  8030c4:	89 d8                	mov    %ebx,%eax
  8030c6:	d3 e0                	shl    %cl,%eax
  8030c8:	89 c2                	mov    %eax,%edx
  8030ca:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030ce:	d3 e0                	shl    %cl,%eax
  8030d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030d4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030d8:	89 f1                	mov    %esi,%ecx
  8030da:	d3 e8                	shr    %cl,%eax
  8030dc:	09 d0                	or     %edx,%eax
  8030de:	d3 eb                	shr    %cl,%ebx
  8030e0:	89 da                	mov    %ebx,%edx
  8030e2:	f7 f7                	div    %edi
  8030e4:	89 d3                	mov    %edx,%ebx
  8030e6:	f7 24 24             	mull   (%esp)
  8030e9:	89 c6                	mov    %eax,%esi
  8030eb:	89 d1                	mov    %edx,%ecx
  8030ed:	39 d3                	cmp    %edx,%ebx
  8030ef:	0f 82 87 00 00 00    	jb     80317c <__umoddi3+0x134>
  8030f5:	0f 84 91 00 00 00    	je     80318c <__umoddi3+0x144>
  8030fb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8030ff:	29 f2                	sub    %esi,%edx
  803101:	19 cb                	sbb    %ecx,%ebx
  803103:	89 d8                	mov    %ebx,%eax
  803105:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803109:	d3 e0                	shl    %cl,%eax
  80310b:	89 e9                	mov    %ebp,%ecx
  80310d:	d3 ea                	shr    %cl,%edx
  80310f:	09 d0                	or     %edx,%eax
  803111:	89 e9                	mov    %ebp,%ecx
  803113:	d3 eb                	shr    %cl,%ebx
  803115:	89 da                	mov    %ebx,%edx
  803117:	83 c4 1c             	add    $0x1c,%esp
  80311a:	5b                   	pop    %ebx
  80311b:	5e                   	pop    %esi
  80311c:	5f                   	pop    %edi
  80311d:	5d                   	pop    %ebp
  80311e:	c3                   	ret    
  80311f:	90                   	nop
  803120:	89 fd                	mov    %edi,%ebp
  803122:	85 ff                	test   %edi,%edi
  803124:	75 0b                	jne    803131 <__umoddi3+0xe9>
  803126:	b8 01 00 00 00       	mov    $0x1,%eax
  80312b:	31 d2                	xor    %edx,%edx
  80312d:	f7 f7                	div    %edi
  80312f:	89 c5                	mov    %eax,%ebp
  803131:	89 f0                	mov    %esi,%eax
  803133:	31 d2                	xor    %edx,%edx
  803135:	f7 f5                	div    %ebp
  803137:	89 c8                	mov    %ecx,%eax
  803139:	f7 f5                	div    %ebp
  80313b:	89 d0                	mov    %edx,%eax
  80313d:	e9 44 ff ff ff       	jmp    803086 <__umoddi3+0x3e>
  803142:	66 90                	xchg   %ax,%ax
  803144:	89 c8                	mov    %ecx,%eax
  803146:	89 f2                	mov    %esi,%edx
  803148:	83 c4 1c             	add    $0x1c,%esp
  80314b:	5b                   	pop    %ebx
  80314c:	5e                   	pop    %esi
  80314d:	5f                   	pop    %edi
  80314e:	5d                   	pop    %ebp
  80314f:	c3                   	ret    
  803150:	3b 04 24             	cmp    (%esp),%eax
  803153:	72 06                	jb     80315b <__umoddi3+0x113>
  803155:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803159:	77 0f                	ja     80316a <__umoddi3+0x122>
  80315b:	89 f2                	mov    %esi,%edx
  80315d:	29 f9                	sub    %edi,%ecx
  80315f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803163:	89 14 24             	mov    %edx,(%esp)
  803166:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80316a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80316e:	8b 14 24             	mov    (%esp),%edx
  803171:	83 c4 1c             	add    $0x1c,%esp
  803174:	5b                   	pop    %ebx
  803175:	5e                   	pop    %esi
  803176:	5f                   	pop    %edi
  803177:	5d                   	pop    %ebp
  803178:	c3                   	ret    
  803179:	8d 76 00             	lea    0x0(%esi),%esi
  80317c:	2b 04 24             	sub    (%esp),%eax
  80317f:	19 fa                	sbb    %edi,%edx
  803181:	89 d1                	mov    %edx,%ecx
  803183:	89 c6                	mov    %eax,%esi
  803185:	e9 71 ff ff ff       	jmp    8030fb <__umoddi3+0xb3>
  80318a:	66 90                	xchg   %ax,%ax
  80318c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803190:	72 ea                	jb     80317c <__umoddi3+0x134>
  803192:	89 d9                	mov    %ebx,%ecx
  803194:	e9 62 ff ff ff       	jmp    8030fb <__umoddi3+0xb3>
