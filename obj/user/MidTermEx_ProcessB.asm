
obj/user/MidTermEx_ProcessB:     file format elf32-i386


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
  800031:	e8 35 01 00 00       	call   80016b <libmain>
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
  80003e:	e8 cf 19 00 00       	call   801a12 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 a0 31 80 00       	push   $0x8031a0
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 af 14 00 00       	call   801505 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 a2 31 80 00       	push   $0x8031a2
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 99 14 00 00       	call   801505 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 a9 31 80 00       	push   $0x8031a9
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 83 14 00 00       	call   801505 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Z ;
	if (*useSem == 1)
  800088:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80008b:	8b 00                	mov    (%eax),%eax
  80008d:	83 f8 01             	cmp    $0x1,%eax
  800090:	75 13                	jne    8000a5 <_main+0x6d>
	{
		sys_waitSemaphore(parentenvID, "T") ;
  800092:	83 ec 08             	sub    $0x8,%esp
  800095:	68 b7 31 80 00       	push   $0x8031b7
  80009a:	ff 75 f4             	pushl  -0xc(%ebp)
  80009d:	e8 11 18 00 00       	call   8018b3 <sys_waitSemaphore>
  8000a2:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  8000a5:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	50                   	push   %eax
  8000ac:	e8 94 19 00 00       	call   801a45 <sys_get_virtual_time>
  8000b1:	83 c4 0c             	add    $0xc,%esp
  8000b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000b7:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c1:	f7 f1                	div    %ecx
  8000c3:	89 d0                	mov    %edx,%eax
  8000c5:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	50                   	push   %eax
  8000d4:	e8 c8 2b 00 00       	call   802ca1 <env_sleep>
  8000d9:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	Z = (*X) + 1 ;
  8000dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000df:	8b 00                	mov    (%eax),%eax
  8000e1:	40                   	inc    %eax
  8000e2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  8000e5:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	50                   	push   %eax
  8000ec:	e8 54 19 00 00       	call   801a45 <sys_get_virtual_time>
  8000f1:	83 c4 0c             	add    $0xc,%esp
  8000f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000f7:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800101:	f7 f1                	div    %ecx
  800103:	89 d0                	mov    %edx,%eax
  800105:	05 d0 07 00 00       	add    $0x7d0,%eax
  80010a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  80010d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	50                   	push   %eax
  800114:	e8 88 2b 00 00       	call   802ca1 <env_sleep>
  800119:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	(*X) = Z ;
  80011c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80011f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800122:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800124:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	50                   	push   %eax
  80012b:	e8 15 19 00 00       	call   801a45 <sys_get_virtual_time>
  800130:	83 c4 0c             	add    $0xc,%esp
  800133:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800136:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80013b:	ba 00 00 00 00       	mov    $0x0,%edx
  800140:	f7 f1                	div    %ecx
  800142:	89 d0                	mov    %edx,%eax
  800144:	05 d0 07 00 00       	add    $0x7d0,%eax
  800149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  80014c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	50                   	push   %eax
  800153:	e8 49 2b 00 00       	call   802ca1 <env_sleep>
  800158:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	/*[3] DECLARE FINISHING*/
	(*finishedCount)++ ;
  80015b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015e:	8b 00                	mov    (%eax),%eax
  800160:	8d 50 01             	lea    0x1(%eax),%edx
  800163:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800166:	89 10                	mov    %edx,(%eax)

}
  800168:	90                   	nop
  800169:	c9                   	leave  
  80016a:	c3                   	ret    

0080016b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800171:	e8 83 18 00 00       	call   8019f9 <sys_getenvindex>
  800176:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800179:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80017c:	89 d0                	mov    %edx,%eax
  80017e:	c1 e0 03             	shl    $0x3,%eax
  800181:	01 d0                	add    %edx,%eax
  800183:	01 c0                	add    %eax,%eax
  800185:	01 d0                	add    %edx,%eax
  800187:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80018e:	01 d0                	add    %edx,%eax
  800190:	c1 e0 04             	shl    $0x4,%eax
  800193:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800198:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80019d:	a1 20 40 80 00       	mov    0x804020,%eax
  8001a2:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001a8:	84 c0                	test   %al,%al
  8001aa:	74 0f                	je     8001bb <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b1:	05 5c 05 00 00       	add    $0x55c,%eax
  8001b6:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001bf:	7e 0a                	jle    8001cb <libmain+0x60>
		binaryname = argv[0];
  8001c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c4:	8b 00                	mov    (%eax),%eax
  8001c6:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001cb:	83 ec 08             	sub    $0x8,%esp
  8001ce:	ff 75 0c             	pushl  0xc(%ebp)
  8001d1:	ff 75 08             	pushl  0x8(%ebp)
  8001d4:	e8 5f fe ff ff       	call   800038 <_main>
  8001d9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001dc:	e8 25 16 00 00       	call   801806 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001e1:	83 ec 0c             	sub    $0xc,%esp
  8001e4:	68 d4 31 80 00       	push   $0x8031d4
  8001e9:	e8 8d 01 00 00       	call   80037b <cprintf>
  8001ee:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800201:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800207:	83 ec 04             	sub    $0x4,%esp
  80020a:	52                   	push   %edx
  80020b:	50                   	push   %eax
  80020c:	68 fc 31 80 00       	push   $0x8031fc
  800211:	e8 65 01 00 00       	call   80037b <cprintf>
  800216:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800219:	a1 20 40 80 00       	mov    0x804020,%eax
  80021e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800224:	a1 20 40 80 00       	mov    0x804020,%eax
  800229:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80022f:	a1 20 40 80 00       	mov    0x804020,%eax
  800234:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80023a:	51                   	push   %ecx
  80023b:	52                   	push   %edx
  80023c:	50                   	push   %eax
  80023d:	68 24 32 80 00       	push   $0x803224
  800242:	e8 34 01 00 00       	call   80037b <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024a:	a1 20 40 80 00       	mov    0x804020,%eax
  80024f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800255:	83 ec 08             	sub    $0x8,%esp
  800258:	50                   	push   %eax
  800259:	68 7c 32 80 00       	push   $0x80327c
  80025e:	e8 18 01 00 00       	call   80037b <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	68 d4 31 80 00       	push   $0x8031d4
  80026e:	e8 08 01 00 00       	call   80037b <cprintf>
  800273:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800276:	e8 a5 15 00 00       	call   801820 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80027b:	e8 19 00 00 00       	call   800299 <exit>
}
  800280:	90                   	nop
  800281:	c9                   	leave  
  800282:	c3                   	ret    

00800283 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800283:	55                   	push   %ebp
  800284:	89 e5                	mov    %esp,%ebp
  800286:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800289:	83 ec 0c             	sub    $0xc,%esp
  80028c:	6a 00                	push   $0x0
  80028e:	e8 32 17 00 00       	call   8019c5 <sys_destroy_env>
  800293:	83 c4 10             	add    $0x10,%esp
}
  800296:	90                   	nop
  800297:	c9                   	leave  
  800298:	c3                   	ret    

00800299 <exit>:

void
exit(void)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80029f:	e8 87 17 00 00       	call   801a2b <sys_exit_env>
}
  8002a4:	90                   	nop
  8002a5:	c9                   	leave  
  8002a6:	c3                   	ret    

008002a7 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b0:	8b 00                	mov    (%eax),%eax
  8002b2:	8d 48 01             	lea    0x1(%eax),%ecx
  8002b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b8:	89 0a                	mov    %ecx,(%edx)
  8002ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8002bd:	88 d1                	mov    %dl,%cl
  8002bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c9:	8b 00                	mov    (%eax),%eax
  8002cb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d0:	75 2c                	jne    8002fe <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002d2:	a0 24 40 80 00       	mov    0x804024,%al
  8002d7:	0f b6 c0             	movzbl %al,%eax
  8002da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002dd:	8b 12                	mov    (%edx),%edx
  8002df:	89 d1                	mov    %edx,%ecx
  8002e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e4:	83 c2 08             	add    $0x8,%edx
  8002e7:	83 ec 04             	sub    $0x4,%esp
  8002ea:	50                   	push   %eax
  8002eb:	51                   	push   %ecx
  8002ec:	52                   	push   %edx
  8002ed:	e8 66 13 00 00       	call   801658 <sys_cputs>
  8002f2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800301:	8b 40 04             	mov    0x4(%eax),%eax
  800304:	8d 50 01             	lea    0x1(%eax),%edx
  800307:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80030d:	90                   	nop
  80030e:	c9                   	leave  
  80030f:	c3                   	ret    

00800310 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800319:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800320:	00 00 00 
	b.cnt = 0;
  800323:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80032a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80032d:	ff 75 0c             	pushl  0xc(%ebp)
  800330:	ff 75 08             	pushl  0x8(%ebp)
  800333:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800339:	50                   	push   %eax
  80033a:	68 a7 02 80 00       	push   $0x8002a7
  80033f:	e8 11 02 00 00       	call   800555 <vprintfmt>
  800344:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800347:	a0 24 40 80 00       	mov    0x804024,%al
  80034c:	0f b6 c0             	movzbl %al,%eax
  80034f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800355:	83 ec 04             	sub    $0x4,%esp
  800358:	50                   	push   %eax
  800359:	52                   	push   %edx
  80035a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800360:	83 c0 08             	add    $0x8,%eax
  800363:	50                   	push   %eax
  800364:	e8 ef 12 00 00       	call   801658 <sys_cputs>
  800369:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80036c:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800373:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800379:	c9                   	leave  
  80037a:	c3                   	ret    

0080037b <cprintf>:

int cprintf(const char *fmt, ...) {
  80037b:	55                   	push   %ebp
  80037c:	89 e5                	mov    %esp,%ebp
  80037e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800381:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800388:	8d 45 0c             	lea    0xc(%ebp),%eax
  80038b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80038e:	8b 45 08             	mov    0x8(%ebp),%eax
  800391:	83 ec 08             	sub    $0x8,%esp
  800394:	ff 75 f4             	pushl  -0xc(%ebp)
  800397:	50                   	push   %eax
  800398:	e8 73 ff ff ff       	call   800310 <vcprintf>
  80039d:	83 c4 10             	add    $0x10,%esp
  8003a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a6:	c9                   	leave  
  8003a7:	c3                   	ret    

008003a8 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8003ae:	e8 53 14 00 00       	call   801806 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003b3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bc:	83 ec 08             	sub    $0x8,%esp
  8003bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c2:	50                   	push   %eax
  8003c3:	e8 48 ff ff ff       	call   800310 <vcprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8003ce:	e8 4d 14 00 00       	call   801820 <sys_enable_interrupt>
	return cnt;
  8003d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    

008003d8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	53                   	push   %ebx
  8003dc:	83 ec 14             	sub    $0x14,%esp
  8003df:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003f6:	77 55                	ja     80044d <printnum+0x75>
  8003f8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003fb:	72 05                	jb     800402 <printnum+0x2a>
  8003fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800400:	77 4b                	ja     80044d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800402:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800405:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800408:	8b 45 18             	mov    0x18(%ebp),%eax
  80040b:	ba 00 00 00 00       	mov    $0x0,%edx
  800410:	52                   	push   %edx
  800411:	50                   	push   %eax
  800412:	ff 75 f4             	pushl  -0xc(%ebp)
  800415:	ff 75 f0             	pushl  -0x10(%ebp)
  800418:	e8 1b 2b 00 00       	call   802f38 <__udivdi3>
  80041d:	83 c4 10             	add    $0x10,%esp
  800420:	83 ec 04             	sub    $0x4,%esp
  800423:	ff 75 20             	pushl  0x20(%ebp)
  800426:	53                   	push   %ebx
  800427:	ff 75 18             	pushl  0x18(%ebp)
  80042a:	52                   	push   %edx
  80042b:	50                   	push   %eax
  80042c:	ff 75 0c             	pushl  0xc(%ebp)
  80042f:	ff 75 08             	pushl  0x8(%ebp)
  800432:	e8 a1 ff ff ff       	call   8003d8 <printnum>
  800437:	83 c4 20             	add    $0x20,%esp
  80043a:	eb 1a                	jmp    800456 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80043c:	83 ec 08             	sub    $0x8,%esp
  80043f:	ff 75 0c             	pushl  0xc(%ebp)
  800442:	ff 75 20             	pushl  0x20(%ebp)
  800445:	8b 45 08             	mov    0x8(%ebp),%eax
  800448:	ff d0                	call   *%eax
  80044a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80044d:	ff 4d 1c             	decl   0x1c(%ebp)
  800450:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800454:	7f e6                	jg     80043c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800456:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800459:	bb 00 00 00 00       	mov    $0x0,%ebx
  80045e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800461:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800464:	53                   	push   %ebx
  800465:	51                   	push   %ecx
  800466:	52                   	push   %edx
  800467:	50                   	push   %eax
  800468:	e8 db 2b 00 00       	call   803048 <__umoddi3>
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	05 b4 34 80 00       	add    $0x8034b4,%eax
  800475:	8a 00                	mov    (%eax),%al
  800477:	0f be c0             	movsbl %al,%eax
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	ff 75 0c             	pushl  0xc(%ebp)
  800480:	50                   	push   %eax
  800481:	8b 45 08             	mov    0x8(%ebp),%eax
  800484:	ff d0                	call   *%eax
  800486:	83 c4 10             	add    $0x10,%esp
}
  800489:	90                   	nop
  80048a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80048d:	c9                   	leave  
  80048e:	c3                   	ret    

0080048f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800492:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800496:	7e 1c                	jle    8004b4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	8d 50 08             	lea    0x8(%eax),%edx
  8004a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a3:	89 10                	mov    %edx,(%eax)
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	83 e8 08             	sub    $0x8,%eax
  8004ad:	8b 50 04             	mov    0x4(%eax),%edx
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	eb 40                	jmp    8004f4 <getuint+0x65>
	else if (lflag)
  8004b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004b8:	74 1e                	je     8004d8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bd:	8b 00                	mov    (%eax),%eax
  8004bf:	8d 50 04             	lea    0x4(%eax),%edx
  8004c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c5:	89 10                	mov    %edx,(%eax)
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	8b 00                	mov    (%eax),%eax
  8004cc:	83 e8 04             	sub    $0x4,%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d6:	eb 1c                	jmp    8004f4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004db:	8b 00                	mov    (%eax),%eax
  8004dd:	8d 50 04             	lea    0x4(%eax),%edx
  8004e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e3:	89 10                	mov    %edx,(%eax)
  8004e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e8:	8b 00                	mov    (%eax),%eax
  8004ea:	83 e8 04             	sub    $0x4,%eax
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004f4:	5d                   	pop    %ebp
  8004f5:	c3                   	ret    

008004f6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004f6:	55                   	push   %ebp
  8004f7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004f9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004fd:	7e 1c                	jle    80051b <getint+0x25>
		return va_arg(*ap, long long);
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	8d 50 08             	lea    0x8(%eax),%edx
  800507:	8b 45 08             	mov    0x8(%ebp),%eax
  80050a:	89 10                	mov    %edx,(%eax)
  80050c:	8b 45 08             	mov    0x8(%ebp),%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	83 e8 08             	sub    $0x8,%eax
  800514:	8b 50 04             	mov    0x4(%eax),%edx
  800517:	8b 00                	mov    (%eax),%eax
  800519:	eb 38                	jmp    800553 <getint+0x5d>
	else if (lflag)
  80051b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80051f:	74 1a                	je     80053b <getint+0x45>
		return va_arg(*ap, long);
  800521:	8b 45 08             	mov    0x8(%ebp),%eax
  800524:	8b 00                	mov    (%eax),%eax
  800526:	8d 50 04             	lea    0x4(%eax),%edx
  800529:	8b 45 08             	mov    0x8(%ebp),%eax
  80052c:	89 10                	mov    %edx,(%eax)
  80052e:	8b 45 08             	mov    0x8(%ebp),%eax
  800531:	8b 00                	mov    (%eax),%eax
  800533:	83 e8 04             	sub    $0x4,%eax
  800536:	8b 00                	mov    (%eax),%eax
  800538:	99                   	cltd   
  800539:	eb 18                	jmp    800553 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	8d 50 04             	lea    0x4(%eax),%edx
  800543:	8b 45 08             	mov    0x8(%ebp),%eax
  800546:	89 10                	mov    %edx,(%eax)
  800548:	8b 45 08             	mov    0x8(%ebp),%eax
  80054b:	8b 00                	mov    (%eax),%eax
  80054d:	83 e8 04             	sub    $0x4,%eax
  800550:	8b 00                	mov    (%eax),%eax
  800552:	99                   	cltd   
}
  800553:	5d                   	pop    %ebp
  800554:	c3                   	ret    

00800555 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800555:	55                   	push   %ebp
  800556:	89 e5                	mov    %esp,%ebp
  800558:	56                   	push   %esi
  800559:	53                   	push   %ebx
  80055a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80055d:	eb 17                	jmp    800576 <vprintfmt+0x21>
			if (ch == '\0')
  80055f:	85 db                	test   %ebx,%ebx
  800561:	0f 84 af 03 00 00    	je     800916 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800567:	83 ec 08             	sub    $0x8,%esp
  80056a:	ff 75 0c             	pushl  0xc(%ebp)
  80056d:	53                   	push   %ebx
  80056e:	8b 45 08             	mov    0x8(%ebp),%eax
  800571:	ff d0                	call   *%eax
  800573:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800576:	8b 45 10             	mov    0x10(%ebp),%eax
  800579:	8d 50 01             	lea    0x1(%eax),%edx
  80057c:	89 55 10             	mov    %edx,0x10(%ebp)
  80057f:	8a 00                	mov    (%eax),%al
  800581:	0f b6 d8             	movzbl %al,%ebx
  800584:	83 fb 25             	cmp    $0x25,%ebx
  800587:	75 d6                	jne    80055f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800589:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80058d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800594:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80059b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005a2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ac:	8d 50 01             	lea    0x1(%eax),%edx
  8005af:	89 55 10             	mov    %edx,0x10(%ebp)
  8005b2:	8a 00                	mov    (%eax),%al
  8005b4:	0f b6 d8             	movzbl %al,%ebx
  8005b7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005ba:	83 f8 55             	cmp    $0x55,%eax
  8005bd:	0f 87 2b 03 00 00    	ja     8008ee <vprintfmt+0x399>
  8005c3:	8b 04 85 d8 34 80 00 	mov    0x8034d8(,%eax,4),%eax
  8005ca:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005cc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005d0:	eb d7                	jmp    8005a9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005d2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005d6:	eb d1                	jmp    8005a9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e2:	89 d0                	mov    %edx,%eax
  8005e4:	c1 e0 02             	shl    $0x2,%eax
  8005e7:	01 d0                	add    %edx,%eax
  8005e9:	01 c0                	add    %eax,%eax
  8005eb:	01 d8                	add    %ebx,%eax
  8005ed:	83 e8 30             	sub    $0x30,%eax
  8005f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f6:	8a 00                	mov    (%eax),%al
  8005f8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005fb:	83 fb 2f             	cmp    $0x2f,%ebx
  8005fe:	7e 3e                	jle    80063e <vprintfmt+0xe9>
  800600:	83 fb 39             	cmp    $0x39,%ebx
  800603:	7f 39                	jg     80063e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800605:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800608:	eb d5                	jmp    8005df <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	83 c0 04             	add    $0x4,%eax
  800610:	89 45 14             	mov    %eax,0x14(%ebp)
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	83 e8 04             	sub    $0x4,%eax
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80061e:	eb 1f                	jmp    80063f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800620:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800624:	79 83                	jns    8005a9 <vprintfmt+0x54>
				width = 0;
  800626:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80062d:	e9 77 ff ff ff       	jmp    8005a9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800632:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800639:	e9 6b ff ff ff       	jmp    8005a9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80063e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80063f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800643:	0f 89 60 ff ff ff    	jns    8005a9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800649:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80064c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80064f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800656:	e9 4e ff ff ff       	jmp    8005a9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80065b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80065e:	e9 46 ff ff ff       	jmp    8005a9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	83 c0 04             	add    $0x4,%eax
  800669:	89 45 14             	mov    %eax,0x14(%ebp)
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	83 e8 04             	sub    $0x4,%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	83 ec 08             	sub    $0x8,%esp
  800677:	ff 75 0c             	pushl  0xc(%ebp)
  80067a:	50                   	push   %eax
  80067b:	8b 45 08             	mov    0x8(%ebp),%eax
  80067e:	ff d0                	call   *%eax
  800680:	83 c4 10             	add    $0x10,%esp
			break;
  800683:	e9 89 02 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	83 c0 04             	add    $0x4,%eax
  80068e:	89 45 14             	mov    %eax,0x14(%ebp)
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	83 e8 04             	sub    $0x4,%eax
  800697:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800699:	85 db                	test   %ebx,%ebx
  80069b:	79 02                	jns    80069f <vprintfmt+0x14a>
				err = -err;
  80069d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80069f:	83 fb 64             	cmp    $0x64,%ebx
  8006a2:	7f 0b                	jg     8006af <vprintfmt+0x15a>
  8006a4:	8b 34 9d 20 33 80 00 	mov    0x803320(,%ebx,4),%esi
  8006ab:	85 f6                	test   %esi,%esi
  8006ad:	75 19                	jne    8006c8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006af:	53                   	push   %ebx
  8006b0:	68 c5 34 80 00       	push   $0x8034c5
  8006b5:	ff 75 0c             	pushl  0xc(%ebp)
  8006b8:	ff 75 08             	pushl  0x8(%ebp)
  8006bb:	e8 5e 02 00 00       	call   80091e <printfmt>
  8006c0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006c3:	e9 49 02 00 00       	jmp    800911 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006c8:	56                   	push   %esi
  8006c9:	68 ce 34 80 00       	push   $0x8034ce
  8006ce:	ff 75 0c             	pushl  0xc(%ebp)
  8006d1:	ff 75 08             	pushl  0x8(%ebp)
  8006d4:	e8 45 02 00 00       	call   80091e <printfmt>
  8006d9:	83 c4 10             	add    $0x10,%esp
			break;
  8006dc:	e9 30 02 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e4:	83 c0 04             	add    $0x4,%eax
  8006e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	83 e8 04             	sub    $0x4,%eax
  8006f0:	8b 30                	mov    (%eax),%esi
  8006f2:	85 f6                	test   %esi,%esi
  8006f4:	75 05                	jne    8006fb <vprintfmt+0x1a6>
				p = "(null)";
  8006f6:	be d1 34 80 00       	mov    $0x8034d1,%esi
			if (width > 0 && padc != '-')
  8006fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ff:	7e 6d                	jle    80076e <vprintfmt+0x219>
  800701:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800705:	74 67                	je     80076e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800707:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80070a:	83 ec 08             	sub    $0x8,%esp
  80070d:	50                   	push   %eax
  80070e:	56                   	push   %esi
  80070f:	e8 0c 03 00 00       	call   800a20 <strnlen>
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80071a:	eb 16                	jmp    800732 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80071c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	ff 75 0c             	pushl  0xc(%ebp)
  800726:	50                   	push   %eax
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	ff d0                	call   *%eax
  80072c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80072f:	ff 4d e4             	decl   -0x1c(%ebp)
  800732:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800736:	7f e4                	jg     80071c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800738:	eb 34                	jmp    80076e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80073a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80073e:	74 1c                	je     80075c <vprintfmt+0x207>
  800740:	83 fb 1f             	cmp    $0x1f,%ebx
  800743:	7e 05                	jle    80074a <vprintfmt+0x1f5>
  800745:	83 fb 7e             	cmp    $0x7e,%ebx
  800748:	7e 12                	jle    80075c <vprintfmt+0x207>
					putch('?', putdat);
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	ff 75 0c             	pushl  0xc(%ebp)
  800750:	6a 3f                	push   $0x3f
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	ff d0                	call   *%eax
  800757:	83 c4 10             	add    $0x10,%esp
  80075a:	eb 0f                	jmp    80076b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	ff 75 0c             	pushl  0xc(%ebp)
  800762:	53                   	push   %ebx
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	ff d0                	call   *%eax
  800768:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80076b:	ff 4d e4             	decl   -0x1c(%ebp)
  80076e:	89 f0                	mov    %esi,%eax
  800770:	8d 70 01             	lea    0x1(%eax),%esi
  800773:	8a 00                	mov    (%eax),%al
  800775:	0f be d8             	movsbl %al,%ebx
  800778:	85 db                	test   %ebx,%ebx
  80077a:	74 24                	je     8007a0 <vprintfmt+0x24b>
  80077c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800780:	78 b8                	js     80073a <vprintfmt+0x1e5>
  800782:	ff 4d e0             	decl   -0x20(%ebp)
  800785:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800789:	79 af                	jns    80073a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80078b:	eb 13                	jmp    8007a0 <vprintfmt+0x24b>
				putch(' ', putdat);
  80078d:	83 ec 08             	sub    $0x8,%esp
  800790:	ff 75 0c             	pushl  0xc(%ebp)
  800793:	6a 20                	push   $0x20
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	ff d0                	call   *%eax
  80079a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80079d:	ff 4d e4             	decl   -0x1c(%ebp)
  8007a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007a4:	7f e7                	jg     80078d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007a6:	e9 66 01 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	ff 75 e8             	pushl  -0x18(%ebp)
  8007b1:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b4:	50                   	push   %eax
  8007b5:	e8 3c fd ff ff       	call   8004f6 <getint>
  8007ba:	83 c4 10             	add    $0x10,%esp
  8007bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c9:	85 d2                	test   %edx,%edx
  8007cb:	79 23                	jns    8007f0 <vprintfmt+0x29b>
				putch('-', putdat);
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	ff 75 0c             	pushl  0xc(%ebp)
  8007d3:	6a 2d                	push   $0x2d
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	ff d0                	call   *%eax
  8007da:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e3:	f7 d8                	neg    %eax
  8007e5:	83 d2 00             	adc    $0x0,%edx
  8007e8:	f7 da                	neg    %edx
  8007ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007f0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007f7:	e9 bc 00 00 00       	jmp    8008b8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007fc:	83 ec 08             	sub    $0x8,%esp
  8007ff:	ff 75 e8             	pushl  -0x18(%ebp)
  800802:	8d 45 14             	lea    0x14(%ebp),%eax
  800805:	50                   	push   %eax
  800806:	e8 84 fc ff ff       	call   80048f <getuint>
  80080b:	83 c4 10             	add    $0x10,%esp
  80080e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800811:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800814:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80081b:	e9 98 00 00 00       	jmp    8008b8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	ff 75 0c             	pushl  0xc(%ebp)
  800826:	6a 58                	push   $0x58
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	ff d0                	call   *%eax
  80082d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	6a 58                	push   $0x58
  800838:	8b 45 08             	mov    0x8(%ebp),%eax
  80083b:	ff d0                	call   *%eax
  80083d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800840:	83 ec 08             	sub    $0x8,%esp
  800843:	ff 75 0c             	pushl  0xc(%ebp)
  800846:	6a 58                	push   $0x58
  800848:	8b 45 08             	mov    0x8(%ebp),%eax
  80084b:	ff d0                	call   *%eax
  80084d:	83 c4 10             	add    $0x10,%esp
			break;
  800850:	e9 bc 00 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800855:	83 ec 08             	sub    $0x8,%esp
  800858:	ff 75 0c             	pushl  0xc(%ebp)
  80085b:	6a 30                	push   $0x30
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	ff d0                	call   *%eax
  800862:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800865:	83 ec 08             	sub    $0x8,%esp
  800868:	ff 75 0c             	pushl  0xc(%ebp)
  80086b:	6a 78                	push   $0x78
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	ff d0                	call   *%eax
  800872:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	83 c0 04             	add    $0x4,%eax
  80087b:	89 45 14             	mov    %eax,0x14(%ebp)
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 e8 04             	sub    $0x4,%eax
  800884:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800886:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800889:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800890:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800897:	eb 1f                	jmp    8008b8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800899:	83 ec 08             	sub    $0x8,%esp
  80089c:	ff 75 e8             	pushl  -0x18(%ebp)
  80089f:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a2:	50                   	push   %eax
  8008a3:	e8 e7 fb ff ff       	call   80048f <getuint>
  8008a8:	83 c4 10             	add    $0x10,%esp
  8008ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008b1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008b8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008bf:	83 ec 04             	sub    $0x4,%esp
  8008c2:	52                   	push   %edx
  8008c3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008c6:	50                   	push   %eax
  8008c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8008cd:	ff 75 0c             	pushl  0xc(%ebp)
  8008d0:	ff 75 08             	pushl  0x8(%ebp)
  8008d3:	e8 00 fb ff ff       	call   8003d8 <printnum>
  8008d8:	83 c4 20             	add    $0x20,%esp
			break;
  8008db:	eb 34                	jmp    800911 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008dd:	83 ec 08             	sub    $0x8,%esp
  8008e0:	ff 75 0c             	pushl  0xc(%ebp)
  8008e3:	53                   	push   %ebx
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	ff d0                	call   *%eax
  8008e9:	83 c4 10             	add    $0x10,%esp
			break;
  8008ec:	eb 23                	jmp    800911 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ee:	83 ec 08             	sub    $0x8,%esp
  8008f1:	ff 75 0c             	pushl  0xc(%ebp)
  8008f4:	6a 25                	push   $0x25
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	ff d0                	call   *%eax
  8008fb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008fe:	ff 4d 10             	decl   0x10(%ebp)
  800901:	eb 03                	jmp    800906 <vprintfmt+0x3b1>
  800903:	ff 4d 10             	decl   0x10(%ebp)
  800906:	8b 45 10             	mov    0x10(%ebp),%eax
  800909:	48                   	dec    %eax
  80090a:	8a 00                	mov    (%eax),%al
  80090c:	3c 25                	cmp    $0x25,%al
  80090e:	75 f3                	jne    800903 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800910:	90                   	nop
		}
	}
  800911:	e9 47 fc ff ff       	jmp    80055d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800916:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800917:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80091a:	5b                   	pop    %ebx
  80091b:	5e                   	pop    %esi
  80091c:	5d                   	pop    %ebp
  80091d:	c3                   	ret    

0080091e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800924:	8d 45 10             	lea    0x10(%ebp),%eax
  800927:	83 c0 04             	add    $0x4,%eax
  80092a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80092d:	8b 45 10             	mov    0x10(%ebp),%eax
  800930:	ff 75 f4             	pushl  -0xc(%ebp)
  800933:	50                   	push   %eax
  800934:	ff 75 0c             	pushl  0xc(%ebp)
  800937:	ff 75 08             	pushl  0x8(%ebp)
  80093a:	e8 16 fc ff ff       	call   800555 <vprintfmt>
  80093f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800942:	90                   	nop
  800943:	c9                   	leave  
  800944:	c3                   	ret    

00800945 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800945:	55                   	push   %ebp
  800946:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800948:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094b:	8b 40 08             	mov    0x8(%eax),%eax
  80094e:	8d 50 01             	lea    0x1(%eax),%edx
  800951:	8b 45 0c             	mov    0xc(%ebp),%eax
  800954:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095a:	8b 10                	mov    (%eax),%edx
  80095c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095f:	8b 40 04             	mov    0x4(%eax),%eax
  800962:	39 c2                	cmp    %eax,%edx
  800964:	73 12                	jae    800978 <sprintputch+0x33>
		*b->buf++ = ch;
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 48 01             	lea    0x1(%eax),%ecx
  80096e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800971:	89 0a                	mov    %ecx,(%edx)
  800973:	8b 55 08             	mov    0x8(%ebp),%edx
  800976:	88 10                	mov    %dl,(%eax)
}
  800978:	90                   	nop
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    

0080097b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	01 d0                	add    %edx,%eax
  800992:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800995:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80099c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009a0:	74 06                	je     8009a8 <vsnprintf+0x2d>
  8009a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a6:	7f 07                	jg     8009af <vsnprintf+0x34>
		return -E_INVAL;
  8009a8:	b8 03 00 00 00       	mov    $0x3,%eax
  8009ad:	eb 20                	jmp    8009cf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009af:	ff 75 14             	pushl  0x14(%ebp)
  8009b2:	ff 75 10             	pushl  0x10(%ebp)
  8009b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b8:	50                   	push   %eax
  8009b9:	68 45 09 80 00       	push   $0x800945
  8009be:	e8 92 fb ff ff       	call   800555 <vprintfmt>
  8009c3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009cf:	c9                   	leave  
  8009d0:	c3                   	ret    

008009d1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009d7:	8d 45 10             	lea    0x10(%ebp),%eax
  8009da:	83 c0 04             	add    $0x4,%eax
  8009dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009e6:	50                   	push   %eax
  8009e7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ea:	ff 75 08             	pushl  0x8(%ebp)
  8009ed:	e8 89 ff ff ff       	call   80097b <vsnprintf>
  8009f2:	83 c4 10             	add    $0x10,%esp
  8009f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fb:	c9                   	leave  
  8009fc:	c3                   	ret    

008009fd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a0a:	eb 06                	jmp    800a12 <strlen+0x15>
		n++;
  800a0c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a0f:	ff 45 08             	incl   0x8(%ebp)
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	8a 00                	mov    (%eax),%al
  800a17:	84 c0                	test   %al,%al
  800a19:	75 f1                	jne    800a0c <strlen+0xf>
		n++;
	return n;
  800a1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a1e:	c9                   	leave  
  800a1f:	c3                   	ret    

00800a20 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a2d:	eb 09                	jmp    800a38 <strnlen+0x18>
		n++;
  800a2f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a32:	ff 45 08             	incl   0x8(%ebp)
  800a35:	ff 4d 0c             	decl   0xc(%ebp)
  800a38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a3c:	74 09                	je     800a47 <strnlen+0x27>
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	8a 00                	mov    (%eax),%al
  800a43:	84 c0                	test   %al,%al
  800a45:	75 e8                	jne    800a2f <strnlen+0xf>
		n++;
	return n;
  800a47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a4a:	c9                   	leave  
  800a4b:	c3                   	ret    

00800a4c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a58:	90                   	nop
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	8d 50 01             	lea    0x1(%eax),%edx
  800a5f:	89 55 08             	mov    %edx,0x8(%ebp)
  800a62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a65:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a68:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a6b:	8a 12                	mov    (%edx),%dl
  800a6d:	88 10                	mov    %dl,(%eax)
  800a6f:	8a 00                	mov    (%eax),%al
  800a71:	84 c0                	test   %al,%al
  800a73:	75 e4                	jne    800a59 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a78:	c9                   	leave  
  800a79:	c3                   	ret    

00800a7a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a8d:	eb 1f                	jmp    800aae <strncpy+0x34>
		*dst++ = *src;
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	8d 50 01             	lea    0x1(%eax),%edx
  800a95:	89 55 08             	mov    %edx,0x8(%ebp)
  800a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9b:	8a 12                	mov    (%edx),%dl
  800a9d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa2:	8a 00                	mov    (%eax),%al
  800aa4:	84 c0                	test   %al,%al
  800aa6:	74 03                	je     800aab <strncpy+0x31>
			src++;
  800aa8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aab:	ff 45 fc             	incl   -0x4(%ebp)
  800aae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ab1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ab4:	72 d9                	jb     800a8f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ab6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ab9:	c9                   	leave  
  800aba:	c3                   	ret    

00800abb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ac7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800acb:	74 30                	je     800afd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800acd:	eb 16                	jmp    800ae5 <strlcpy+0x2a>
			*dst++ = *src++;
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	8d 50 01             	lea    0x1(%eax),%edx
  800ad5:	89 55 08             	mov    %edx,0x8(%ebp)
  800ad8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ade:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ae1:	8a 12                	mov    (%edx),%dl
  800ae3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ae5:	ff 4d 10             	decl   0x10(%ebp)
  800ae8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aec:	74 09                	je     800af7 <strlcpy+0x3c>
  800aee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af1:	8a 00                	mov    (%eax),%al
  800af3:	84 c0                	test   %al,%al
  800af5:	75 d8                	jne    800acf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800afd:	8b 55 08             	mov    0x8(%ebp),%edx
  800b00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b03:	29 c2                	sub    %eax,%edx
  800b05:	89 d0                	mov    %edx,%eax
}
  800b07:	c9                   	leave  
  800b08:	c3                   	ret    

00800b09 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b0c:	eb 06                	jmp    800b14 <strcmp+0xb>
		p++, q++;
  800b0e:	ff 45 08             	incl   0x8(%ebp)
  800b11:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8a 00                	mov    (%eax),%al
  800b19:	84 c0                	test   %al,%al
  800b1b:	74 0e                	je     800b2b <strcmp+0x22>
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8a 10                	mov    (%eax),%dl
  800b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b25:	8a 00                	mov    (%eax),%al
  800b27:	38 c2                	cmp    %al,%dl
  800b29:	74 e3                	je     800b0e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8a 00                	mov    (%eax),%al
  800b30:	0f b6 d0             	movzbl %al,%edx
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	8a 00                	mov    (%eax),%al
  800b38:	0f b6 c0             	movzbl %al,%eax
  800b3b:	29 c2                	sub    %eax,%edx
  800b3d:	89 d0                	mov    %edx,%eax
}
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    

00800b41 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b44:	eb 09                	jmp    800b4f <strncmp+0xe>
		n--, p++, q++;
  800b46:	ff 4d 10             	decl   0x10(%ebp)
  800b49:	ff 45 08             	incl   0x8(%ebp)
  800b4c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b53:	74 17                	je     800b6c <strncmp+0x2b>
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	8a 00                	mov    (%eax),%al
  800b5a:	84 c0                	test   %al,%al
  800b5c:	74 0e                	je     800b6c <strncmp+0x2b>
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8a 10                	mov    (%eax),%dl
  800b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b66:	8a 00                	mov    (%eax),%al
  800b68:	38 c2                	cmp    %al,%dl
  800b6a:	74 da                	je     800b46 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b70:	75 07                	jne    800b79 <strncmp+0x38>
		return 0;
  800b72:	b8 00 00 00 00       	mov    $0x0,%eax
  800b77:	eb 14                	jmp    800b8d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	8a 00                	mov    (%eax),%al
  800b7e:	0f b6 d0             	movzbl %al,%edx
  800b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b84:	8a 00                	mov    (%eax),%al
  800b86:	0f b6 c0             	movzbl %al,%eax
  800b89:	29 c2                	sub    %eax,%edx
  800b8b:	89 d0                	mov    %edx,%eax
}
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    

00800b8f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	83 ec 04             	sub    $0x4,%esp
  800b95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b98:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b9b:	eb 12                	jmp    800baf <strchr+0x20>
		if (*s == c)
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	8a 00                	mov    (%eax),%al
  800ba2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba5:	75 05                	jne    800bac <strchr+0x1d>
			return (char *) s;
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	eb 11                	jmp    800bbd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bac:	ff 45 08             	incl   0x8(%ebp)
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8a 00                	mov    (%eax),%al
  800bb4:	84 c0                	test   %al,%al
  800bb6:	75 e5                	jne    800b9d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bbd:	c9                   	leave  
  800bbe:	c3                   	ret    

00800bbf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	83 ec 04             	sub    $0x4,%esp
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bcb:	eb 0d                	jmp    800bda <strfind+0x1b>
		if (*s == c)
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bd5:	74 0e                	je     800be5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bd7:	ff 45 08             	incl   0x8(%ebp)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8a 00                	mov    (%eax),%al
  800bdf:	84 c0                	test   %al,%al
  800be1:	75 ea                	jne    800bcd <strfind+0xe>
  800be3:	eb 01                	jmp    800be6 <strfind+0x27>
		if (*s == c)
			break;
  800be5:	90                   	nop
	return (char *) s;
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bf7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bfd:	eb 0e                	jmp    800c0d <memset+0x22>
		*p++ = c;
  800bff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c02:	8d 50 01             	lea    0x1(%eax),%edx
  800c05:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c0d:	ff 4d f8             	decl   -0x8(%ebp)
  800c10:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c14:	79 e9                	jns    800bff <memset+0x14>
		*p++ = c;

	return v;
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    

00800c1b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c2d:	eb 16                	jmp    800c45 <memcpy+0x2a>
		*d++ = *s++;
  800c2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c32:	8d 50 01             	lea    0x1(%eax),%edx
  800c35:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c38:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c3b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c3e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c41:	8a 12                	mov    (%edx),%dl
  800c43:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c45:	8b 45 10             	mov    0x10(%ebp),%eax
  800c48:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c4b:	89 55 10             	mov    %edx,0x10(%ebp)
  800c4e:	85 c0                	test   %eax,%eax
  800c50:	75 dd                	jne    800c2f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c55:	c9                   	leave  
  800c56:	c3                   	ret    

00800c57 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c6f:	73 50                	jae    800cc1 <memmove+0x6a>
  800c71:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c74:	8b 45 10             	mov    0x10(%ebp),%eax
  800c77:	01 d0                	add    %edx,%eax
  800c79:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c7c:	76 43                	jbe    800cc1 <memmove+0x6a>
		s += n;
  800c7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c81:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c84:	8b 45 10             	mov    0x10(%ebp),%eax
  800c87:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c8a:	eb 10                	jmp    800c9c <memmove+0x45>
			*--d = *--s;
  800c8c:	ff 4d f8             	decl   -0x8(%ebp)
  800c8f:	ff 4d fc             	decl   -0x4(%ebp)
  800c92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c95:	8a 10                	mov    (%eax),%dl
  800c97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c9a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca5:	85 c0                	test   %eax,%eax
  800ca7:	75 e3                	jne    800c8c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ca9:	eb 23                	jmp    800cce <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800cab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cae:	8d 50 01             	lea    0x1(%eax),%edx
  800cb1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cb4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cb7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cba:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cbd:	8a 12                	mov    (%edx),%dl
  800cbf:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800cc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc7:	89 55 10             	mov    %edx,0x10(%ebp)
  800cca:	85 c0                	test   %eax,%eax
  800ccc:	75 dd                	jne    800cab <memmove+0x54>
			*d++ = *s++;

	return dst;
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd1:	c9                   	leave  
  800cd2:	c3                   	ret    

00800cd3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ce5:	eb 2a                	jmp    800d11 <memcmp+0x3e>
		if (*s1 != *s2)
  800ce7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cea:	8a 10                	mov    (%eax),%dl
  800cec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cef:	8a 00                	mov    (%eax),%al
  800cf1:	38 c2                	cmp    %al,%dl
  800cf3:	74 16                	je     800d0b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	0f b6 d0             	movzbl %al,%edx
  800cfd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d00:	8a 00                	mov    (%eax),%al
  800d02:	0f b6 c0             	movzbl %al,%eax
  800d05:	29 c2                	sub    %eax,%edx
  800d07:	89 d0                	mov    %edx,%eax
  800d09:	eb 18                	jmp    800d23 <memcmp+0x50>
		s1++, s2++;
  800d0b:	ff 45 fc             	incl   -0x4(%ebp)
  800d0e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d11:	8b 45 10             	mov    0x10(%ebp),%eax
  800d14:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d17:	89 55 10             	mov    %edx,0x10(%ebp)
  800d1a:	85 c0                	test   %eax,%eax
  800d1c:	75 c9                	jne    800ce7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d31:	01 d0                	add    %edx,%eax
  800d33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d36:	eb 15                	jmp    800d4d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8a 00                	mov    (%eax),%al
  800d3d:	0f b6 d0             	movzbl %al,%edx
  800d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d43:	0f b6 c0             	movzbl %al,%eax
  800d46:	39 c2                	cmp    %eax,%edx
  800d48:	74 0d                	je     800d57 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d4a:	ff 45 08             	incl   0x8(%ebp)
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d53:	72 e3                	jb     800d38 <memfind+0x13>
  800d55:	eb 01                	jmp    800d58 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d57:	90                   	nop
	return (void *) s;
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d5b:	c9                   	leave  
  800d5c:	c3                   	ret    

00800d5d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
  800d60:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d63:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d6a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d71:	eb 03                	jmp    800d76 <strtol+0x19>
		s++;
  800d73:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8a 00                	mov    (%eax),%al
  800d7b:	3c 20                	cmp    $0x20,%al
  800d7d:	74 f4                	je     800d73 <strtol+0x16>
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8a 00                	mov    (%eax),%al
  800d84:	3c 09                	cmp    $0x9,%al
  800d86:	74 eb                	je     800d73 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3c 2b                	cmp    $0x2b,%al
  800d8f:	75 05                	jne    800d96 <strtol+0x39>
		s++;
  800d91:	ff 45 08             	incl   0x8(%ebp)
  800d94:	eb 13                	jmp    800da9 <strtol+0x4c>
	else if (*s == '-')
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	3c 2d                	cmp    $0x2d,%al
  800d9d:	75 0a                	jne    800da9 <strtol+0x4c>
		s++, neg = 1;
  800d9f:	ff 45 08             	incl   0x8(%ebp)
  800da2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800da9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dad:	74 06                	je     800db5 <strtol+0x58>
  800daf:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800db3:	75 20                	jne    800dd5 <strtol+0x78>
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	8a 00                	mov    (%eax),%al
  800dba:	3c 30                	cmp    $0x30,%al
  800dbc:	75 17                	jne    800dd5 <strtol+0x78>
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	40                   	inc    %eax
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	3c 78                	cmp    $0x78,%al
  800dc6:	75 0d                	jne    800dd5 <strtol+0x78>
		s += 2, base = 16;
  800dc8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dcc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dd3:	eb 28                	jmp    800dfd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dd5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd9:	75 15                	jne    800df0 <strtol+0x93>
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	8a 00                	mov    (%eax),%al
  800de0:	3c 30                	cmp    $0x30,%al
  800de2:	75 0c                	jne    800df0 <strtol+0x93>
		s++, base = 8;
  800de4:	ff 45 08             	incl   0x8(%ebp)
  800de7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dee:	eb 0d                	jmp    800dfd <strtol+0xa0>
	else if (base == 0)
  800df0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df4:	75 07                	jne    800dfd <strtol+0xa0>
		base = 10;
  800df6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8a 00                	mov    (%eax),%al
  800e02:	3c 2f                	cmp    $0x2f,%al
  800e04:	7e 19                	jle    800e1f <strtol+0xc2>
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	3c 39                	cmp    $0x39,%al
  800e0d:	7f 10                	jg     800e1f <strtol+0xc2>
			dig = *s - '0';
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	8a 00                	mov    (%eax),%al
  800e14:	0f be c0             	movsbl %al,%eax
  800e17:	83 e8 30             	sub    $0x30,%eax
  800e1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e1d:	eb 42                	jmp    800e61 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	3c 60                	cmp    $0x60,%al
  800e26:	7e 19                	jle    800e41 <strtol+0xe4>
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	3c 7a                	cmp    $0x7a,%al
  800e2f:	7f 10                	jg     800e41 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	8a 00                	mov    (%eax),%al
  800e36:	0f be c0             	movsbl %al,%eax
  800e39:	83 e8 57             	sub    $0x57,%eax
  800e3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e3f:	eb 20                	jmp    800e61 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	3c 40                	cmp    $0x40,%al
  800e48:	7e 39                	jle    800e83 <strtol+0x126>
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	3c 5a                	cmp    $0x5a,%al
  800e51:	7f 30                	jg     800e83 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	8a 00                	mov    (%eax),%al
  800e58:	0f be c0             	movsbl %al,%eax
  800e5b:	83 e8 37             	sub    $0x37,%eax
  800e5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e64:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e67:	7d 19                	jge    800e82 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e69:	ff 45 08             	incl   0x8(%ebp)
  800e6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e6f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e73:	89 c2                	mov    %eax,%edx
  800e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e78:	01 d0                	add    %edx,%eax
  800e7a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e7d:	e9 7b ff ff ff       	jmp    800dfd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e82:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e87:	74 08                	je     800e91 <strtol+0x134>
		*endptr = (char *) s;
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e91:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e95:	74 07                	je     800e9e <strtol+0x141>
  800e97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9a:	f7 d8                	neg    %eax
  800e9c:	eb 03                	jmp    800ea1 <strtol+0x144>
  800e9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ea1:	c9                   	leave  
  800ea2:	c3                   	ret    

00800ea3 <ltostr>:

void
ltostr(long value, char *str)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800ea9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800eb0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800eb7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ebb:	79 13                	jns    800ed0 <ltostr+0x2d>
	{
		neg = 1;
  800ebd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800eca:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ecd:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ed8:	99                   	cltd   
  800ed9:	f7 f9                	idiv   %ecx
  800edb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ede:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee1:	8d 50 01             	lea    0x1(%eax),%edx
  800ee4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ee7:	89 c2                	mov    %eax,%edx
  800ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eec:	01 d0                	add    %edx,%eax
  800eee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ef1:	83 c2 30             	add    $0x30,%edx
  800ef4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ef6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ef9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800efe:	f7 e9                	imul   %ecx
  800f00:	c1 fa 02             	sar    $0x2,%edx
  800f03:	89 c8                	mov    %ecx,%eax
  800f05:	c1 f8 1f             	sar    $0x1f,%eax
  800f08:	29 c2                	sub    %eax,%edx
  800f0a:	89 d0                	mov    %edx,%eax
  800f0c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800f0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f12:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f17:	f7 e9                	imul   %ecx
  800f19:	c1 fa 02             	sar    $0x2,%edx
  800f1c:	89 c8                	mov    %ecx,%eax
  800f1e:	c1 f8 1f             	sar    $0x1f,%eax
  800f21:	29 c2                	sub    %eax,%edx
  800f23:	89 d0                	mov    %edx,%eax
  800f25:	c1 e0 02             	shl    $0x2,%eax
  800f28:	01 d0                	add    %edx,%eax
  800f2a:	01 c0                	add    %eax,%eax
  800f2c:	29 c1                	sub    %eax,%ecx
  800f2e:	89 ca                	mov    %ecx,%edx
  800f30:	85 d2                	test   %edx,%edx
  800f32:	75 9c                	jne    800ed0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3e:	48                   	dec    %eax
  800f3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f42:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f46:	74 3d                	je     800f85 <ltostr+0xe2>
		start = 1 ;
  800f48:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f4f:	eb 34                	jmp    800f85 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f57:	01 d0                	add    %edx,%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f64:	01 c2                	add    %eax,%edx
  800f66:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6c:	01 c8                	add    %ecx,%eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	01 c2                	add    %eax,%edx
  800f7a:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f7d:	88 02                	mov    %al,(%edx)
		start++ ;
  800f7f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f82:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f88:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f8b:	7c c4                	jl     800f51 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f8d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	01 d0                	add    %edx,%eax
  800f95:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f98:	90                   	nop
  800f99:	c9                   	leave  
  800f9a:	c3                   	ret    

00800f9b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800fa1:	ff 75 08             	pushl  0x8(%ebp)
  800fa4:	e8 54 fa ff ff       	call   8009fd <strlen>
  800fa9:	83 c4 04             	add    $0x4,%esp
  800fac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800faf:	ff 75 0c             	pushl  0xc(%ebp)
  800fb2:	e8 46 fa ff ff       	call   8009fd <strlen>
  800fb7:	83 c4 04             	add    $0x4,%esp
  800fba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fcb:	eb 17                	jmp    800fe4 <strcconcat+0x49>
		final[s] = str1[s] ;
  800fcd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd3:	01 c2                	add    %eax,%edx
  800fd5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	01 c8                	add    %ecx,%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fe1:	ff 45 fc             	incl   -0x4(%ebp)
  800fe4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fea:	7c e1                	jl     800fcd <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ff3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ffa:	eb 1f                	jmp    80101b <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ffc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fff:	8d 50 01             	lea    0x1(%eax),%edx
  801002:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801005:	89 c2                	mov    %eax,%edx
  801007:	8b 45 10             	mov    0x10(%ebp),%eax
  80100a:	01 c2                	add    %eax,%edx
  80100c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80100f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801012:	01 c8                	add    %ecx,%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801018:	ff 45 f8             	incl   -0x8(%ebp)
  80101b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801021:	7c d9                	jl     800ffc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801023:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801026:	8b 45 10             	mov    0x10(%ebp),%eax
  801029:	01 d0                	add    %edx,%eax
  80102b:	c6 00 00             	movb   $0x0,(%eax)
}
  80102e:	90                   	nop
  80102f:	c9                   	leave  
  801030:	c3                   	ret    

00801031 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801034:	8b 45 14             	mov    0x14(%ebp),%eax
  801037:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80103d:	8b 45 14             	mov    0x14(%ebp),%eax
  801040:	8b 00                	mov    (%eax),%eax
  801042:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801049:	8b 45 10             	mov    0x10(%ebp),%eax
  80104c:	01 d0                	add    %edx,%eax
  80104e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801054:	eb 0c                	jmp    801062 <strsplit+0x31>
			*string++ = 0;
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
  801059:	8d 50 01             	lea    0x1(%eax),%edx
  80105c:	89 55 08             	mov    %edx,0x8(%ebp)
  80105f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	84 c0                	test   %al,%al
  801069:	74 18                	je     801083 <strsplit+0x52>
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	0f be c0             	movsbl %al,%eax
  801073:	50                   	push   %eax
  801074:	ff 75 0c             	pushl  0xc(%ebp)
  801077:	e8 13 fb ff ff       	call   800b8f <strchr>
  80107c:	83 c4 08             	add    $0x8,%esp
  80107f:	85 c0                	test   %eax,%eax
  801081:	75 d3                	jne    801056 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	84 c0                	test   %al,%al
  80108a:	74 5a                	je     8010e6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80108c:	8b 45 14             	mov    0x14(%ebp),%eax
  80108f:	8b 00                	mov    (%eax),%eax
  801091:	83 f8 0f             	cmp    $0xf,%eax
  801094:	75 07                	jne    80109d <strsplit+0x6c>
		{
			return 0;
  801096:	b8 00 00 00 00       	mov    $0x0,%eax
  80109b:	eb 66                	jmp    801103 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80109d:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a0:	8b 00                	mov    (%eax),%eax
  8010a2:	8d 48 01             	lea    0x1(%eax),%ecx
  8010a5:	8b 55 14             	mov    0x14(%ebp),%edx
  8010a8:	89 0a                	mov    %ecx,(%edx)
  8010aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b4:	01 c2                	add    %eax,%edx
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010bb:	eb 03                	jmp    8010c0 <strsplit+0x8f>
			string++;
  8010bd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	84 c0                	test   %al,%al
  8010c7:	74 8b                	je     801054 <strsplit+0x23>
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	0f be c0             	movsbl %al,%eax
  8010d1:	50                   	push   %eax
  8010d2:	ff 75 0c             	pushl  0xc(%ebp)
  8010d5:	e8 b5 fa ff ff       	call   800b8f <strchr>
  8010da:	83 c4 08             	add    $0x8,%esp
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	74 dc                	je     8010bd <strsplit+0x8c>
			string++;
	}
  8010e1:	e9 6e ff ff ff       	jmp    801054 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010e6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ea:	8b 00                	mov    (%eax),%eax
  8010ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f6:	01 d0                	add    %edx,%eax
  8010f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010fe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801103:	c9                   	leave  
  801104:	c3                   	ret    

00801105 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80110b:	a1 04 40 80 00       	mov    0x804004,%eax
  801110:	85 c0                	test   %eax,%eax
  801112:	74 1f                	je     801133 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801114:	e8 1d 00 00 00       	call   801136 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801119:	83 ec 0c             	sub    $0xc,%esp
  80111c:	68 30 36 80 00       	push   $0x803630
  801121:	e8 55 f2 ff ff       	call   80037b <cprintf>
  801126:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801129:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801130:	00 00 00 
	}
}
  801133:	90                   	nop
  801134:	c9                   	leave  
  801135:	c3                   	ret    

00801136 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  80113c:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801143:	00 00 00 
  801146:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80114d:	00 00 00 
  801150:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801157:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80115a:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801161:	00 00 00 
  801164:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80116b:	00 00 00 
  80116e:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801175:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801178:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80117f:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801182:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801191:	2d 00 10 00 00       	sub    $0x1000,%eax
  801196:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  80119b:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  8011a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011a5:	a1 20 41 80 00       	mov    0x804120,%eax
  8011aa:	0f af c2             	imul   %edx,%eax
  8011ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  8011b0:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8011b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011bd:	01 d0                	add    %edx,%eax
  8011bf:	48                   	dec    %eax
  8011c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8011cb:	f7 75 e8             	divl   -0x18(%ebp)
  8011ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011d1:	29 d0                	sub    %edx,%eax
  8011d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  8011d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011d9:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  8011e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8011e3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8011e9:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8011ef:	83 ec 04             	sub    $0x4,%esp
  8011f2:	6a 06                	push   $0x6
  8011f4:	50                   	push   %eax
  8011f5:	52                   	push   %edx
  8011f6:	e8 a1 05 00 00       	call   80179c <sys_allocate_chunk>
  8011fb:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011fe:	a1 20 41 80 00       	mov    0x804120,%eax
  801203:	83 ec 0c             	sub    $0xc,%esp
  801206:	50                   	push   %eax
  801207:	e8 16 0c 00 00       	call   801e22 <initialize_MemBlocksList>
  80120c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  80120f:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801214:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801217:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80121b:	75 14                	jne    801231 <initialize_dyn_block_system+0xfb>
  80121d:	83 ec 04             	sub    $0x4,%esp
  801220:	68 55 36 80 00       	push   $0x803655
  801225:	6a 2d                	push   $0x2d
  801227:	68 73 36 80 00       	push   $0x803673
  80122c:	e8 24 1b 00 00       	call   802d55 <_panic>
  801231:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801234:	8b 00                	mov    (%eax),%eax
  801236:	85 c0                	test   %eax,%eax
  801238:	74 10                	je     80124a <initialize_dyn_block_system+0x114>
  80123a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80123d:	8b 00                	mov    (%eax),%eax
  80123f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801242:	8b 52 04             	mov    0x4(%edx),%edx
  801245:	89 50 04             	mov    %edx,0x4(%eax)
  801248:	eb 0b                	jmp    801255 <initialize_dyn_block_system+0x11f>
  80124a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80124d:	8b 40 04             	mov    0x4(%eax),%eax
  801250:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801255:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801258:	8b 40 04             	mov    0x4(%eax),%eax
  80125b:	85 c0                	test   %eax,%eax
  80125d:	74 0f                	je     80126e <initialize_dyn_block_system+0x138>
  80125f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801262:	8b 40 04             	mov    0x4(%eax),%eax
  801265:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801268:	8b 12                	mov    (%edx),%edx
  80126a:	89 10                	mov    %edx,(%eax)
  80126c:	eb 0a                	jmp    801278 <initialize_dyn_block_system+0x142>
  80126e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801271:	8b 00                	mov    (%eax),%eax
  801273:	a3 48 41 80 00       	mov    %eax,0x804148
  801278:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80127b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801281:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801284:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80128b:	a1 54 41 80 00       	mov    0x804154,%eax
  801290:	48                   	dec    %eax
  801291:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801296:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801299:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  8012a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012a3:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  8012aa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012ae:	75 14                	jne    8012c4 <initialize_dyn_block_system+0x18e>
  8012b0:	83 ec 04             	sub    $0x4,%esp
  8012b3:	68 80 36 80 00       	push   $0x803680
  8012b8:	6a 30                	push   $0x30
  8012ba:	68 73 36 80 00       	push   $0x803673
  8012bf:	e8 91 1a 00 00       	call   802d55 <_panic>
  8012c4:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8012ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012cd:	89 50 04             	mov    %edx,0x4(%eax)
  8012d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012d3:	8b 40 04             	mov    0x4(%eax),%eax
  8012d6:	85 c0                	test   %eax,%eax
  8012d8:	74 0c                	je     8012e6 <initialize_dyn_block_system+0x1b0>
  8012da:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8012df:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8012e2:	89 10                	mov    %edx,(%eax)
  8012e4:	eb 08                	jmp    8012ee <initialize_dyn_block_system+0x1b8>
  8012e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012e9:	a3 38 41 80 00       	mov    %eax,0x804138
  8012ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012f1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8012f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8012ff:	a1 44 41 80 00       	mov    0x804144,%eax
  801304:	40                   	inc    %eax
  801305:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80130a:	90                   	nop
  80130b:	c9                   	leave  
  80130c:	c3                   	ret    

0080130d <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
  801310:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801313:	e8 ed fd ff ff       	call   801105 <InitializeUHeap>
	if (size == 0) return NULL ;
  801318:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80131c:	75 07                	jne    801325 <malloc+0x18>
  80131e:	b8 00 00 00 00       	mov    $0x0,%eax
  801323:	eb 67                	jmp    80138c <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801325:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80132c:	8b 55 08             	mov    0x8(%ebp),%edx
  80132f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801332:	01 d0                	add    %edx,%eax
  801334:	48                   	dec    %eax
  801335:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801338:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80133b:	ba 00 00 00 00       	mov    $0x0,%edx
  801340:	f7 75 f4             	divl   -0xc(%ebp)
  801343:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801346:	29 d0                	sub    %edx,%eax
  801348:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80134b:	e8 1a 08 00 00       	call   801b6a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801350:	85 c0                	test   %eax,%eax
  801352:	74 33                	je     801387 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801354:	83 ec 0c             	sub    $0xc,%esp
  801357:	ff 75 08             	pushl  0x8(%ebp)
  80135a:	e8 0c 0e 00 00       	call   80216b <alloc_block_FF>
  80135f:	83 c4 10             	add    $0x10,%esp
  801362:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801365:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801369:	74 1c                	je     801387 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  80136b:	83 ec 0c             	sub    $0xc,%esp
  80136e:	ff 75 ec             	pushl  -0x14(%ebp)
  801371:	e8 07 0c 00 00       	call   801f7d <insert_sorted_allocList>
  801376:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801379:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80137c:	8b 40 08             	mov    0x8(%eax),%eax
  80137f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801382:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801385:	eb 05                	jmp    80138c <malloc+0x7f>
		}
	}
	return NULL;
  801387:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80138c:	c9                   	leave  
  80138d:	c3                   	ret    

0080138e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
  801391:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801394:	8b 45 08             	mov    0x8(%ebp),%eax
  801397:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  80139a:	83 ec 08             	sub    $0x8,%esp
  80139d:	ff 75 f4             	pushl  -0xc(%ebp)
  8013a0:	68 40 40 80 00       	push   $0x804040
  8013a5:	e8 5b 0b 00 00       	call   801f05 <find_block>
  8013aa:	83 c4 10             	add    $0x10,%esp
  8013ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  8013b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8013b6:	83 ec 08             	sub    $0x8,%esp
  8013b9:	50                   	push   %eax
  8013ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8013bd:	e8 a2 03 00 00       	call   801764 <sys_free_user_mem>
  8013c2:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  8013c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013c9:	75 14                	jne    8013df <free+0x51>
  8013cb:	83 ec 04             	sub    $0x4,%esp
  8013ce:	68 55 36 80 00       	push   $0x803655
  8013d3:	6a 76                	push   $0x76
  8013d5:	68 73 36 80 00       	push   $0x803673
  8013da:	e8 76 19 00 00       	call   802d55 <_panic>
  8013df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e2:	8b 00                	mov    (%eax),%eax
  8013e4:	85 c0                	test   %eax,%eax
  8013e6:	74 10                	je     8013f8 <free+0x6a>
  8013e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013eb:	8b 00                	mov    (%eax),%eax
  8013ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013f0:	8b 52 04             	mov    0x4(%edx),%edx
  8013f3:	89 50 04             	mov    %edx,0x4(%eax)
  8013f6:	eb 0b                	jmp    801403 <free+0x75>
  8013f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013fb:	8b 40 04             	mov    0x4(%eax),%eax
  8013fe:	a3 44 40 80 00       	mov    %eax,0x804044
  801403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801406:	8b 40 04             	mov    0x4(%eax),%eax
  801409:	85 c0                	test   %eax,%eax
  80140b:	74 0f                	je     80141c <free+0x8e>
  80140d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801410:	8b 40 04             	mov    0x4(%eax),%eax
  801413:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801416:	8b 12                	mov    (%edx),%edx
  801418:	89 10                	mov    %edx,(%eax)
  80141a:	eb 0a                	jmp    801426 <free+0x98>
  80141c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141f:	8b 00                	mov    (%eax),%eax
  801421:	a3 40 40 80 00       	mov    %eax,0x804040
  801426:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801429:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80142f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801432:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801439:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80143e:	48                   	dec    %eax
  80143f:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  801444:	83 ec 0c             	sub    $0xc,%esp
  801447:	ff 75 f0             	pushl  -0x10(%ebp)
  80144a:	e8 0b 14 00 00       	call   80285a <insert_sorted_with_merge_freeList>
  80144f:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801452:	90                   	nop
  801453:	c9                   	leave  
  801454:	c3                   	ret    

00801455 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
  801458:	83 ec 28             	sub    $0x28,%esp
  80145b:	8b 45 10             	mov    0x10(%ebp),%eax
  80145e:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801461:	e8 9f fc ff ff       	call   801105 <InitializeUHeap>
	if (size == 0) return NULL ;
  801466:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80146a:	75 0a                	jne    801476 <smalloc+0x21>
  80146c:	b8 00 00 00 00       	mov    $0x0,%eax
  801471:	e9 8d 00 00 00       	jmp    801503 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801476:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80147d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801483:	01 d0                	add    %edx,%eax
  801485:	48                   	dec    %eax
  801486:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801489:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148c:	ba 00 00 00 00       	mov    $0x0,%edx
  801491:	f7 75 f4             	divl   -0xc(%ebp)
  801494:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801497:	29 d0                	sub    %edx,%eax
  801499:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80149c:	e8 c9 06 00 00       	call   801b6a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014a1:	85 c0                	test   %eax,%eax
  8014a3:	74 59                	je     8014fe <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  8014a5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  8014ac:	83 ec 0c             	sub    $0xc,%esp
  8014af:	ff 75 0c             	pushl  0xc(%ebp)
  8014b2:	e8 b4 0c 00 00       	call   80216b <alloc_block_FF>
  8014b7:	83 c4 10             	add    $0x10,%esp
  8014ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  8014bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014c1:	75 07                	jne    8014ca <smalloc+0x75>
			{
				return NULL;
  8014c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c8:	eb 39                	jmp    801503 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  8014ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014cd:	8b 40 08             	mov    0x8(%eax),%eax
  8014d0:	89 c2                	mov    %eax,%edx
  8014d2:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8014d6:	52                   	push   %edx
  8014d7:	50                   	push   %eax
  8014d8:	ff 75 0c             	pushl  0xc(%ebp)
  8014db:	ff 75 08             	pushl  0x8(%ebp)
  8014de:	e8 0c 04 00 00       	call   8018ef <sys_createSharedObject>
  8014e3:	83 c4 10             	add    $0x10,%esp
  8014e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  8014e9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8014ed:	78 08                	js     8014f7 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  8014ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014f2:	8b 40 08             	mov    0x8(%eax),%eax
  8014f5:	eb 0c                	jmp    801503 <smalloc+0xae>
				}
				else
				{
					return NULL;
  8014f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fc:	eb 05                	jmp    801503 <smalloc+0xae>
				}
			}

		}
		return NULL;
  8014fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80150b:	e8 f5 fb ff ff       	call   801105 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801510:	83 ec 08             	sub    $0x8,%esp
  801513:	ff 75 0c             	pushl  0xc(%ebp)
  801516:	ff 75 08             	pushl  0x8(%ebp)
  801519:	e8 fb 03 00 00       	call   801919 <sys_getSizeOfSharedObject>
  80151e:	83 c4 10             	add    $0x10,%esp
  801521:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801524:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801528:	75 07                	jne    801531 <sget+0x2c>
	{
		return NULL;
  80152a:	b8 00 00 00 00       	mov    $0x0,%eax
  80152f:	eb 64                	jmp    801595 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801531:	e8 34 06 00 00       	call   801b6a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801536:	85 c0                	test   %eax,%eax
  801538:	74 56                	je     801590 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  80153a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801544:	83 ec 0c             	sub    $0xc,%esp
  801547:	50                   	push   %eax
  801548:	e8 1e 0c 00 00       	call   80216b <alloc_block_FF>
  80154d:	83 c4 10             	add    $0x10,%esp
  801550:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801553:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801557:	75 07                	jne    801560 <sget+0x5b>
		{
		return NULL;
  801559:	b8 00 00 00 00       	mov    $0x0,%eax
  80155e:	eb 35                	jmp    801595 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801560:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801563:	8b 40 08             	mov    0x8(%eax),%eax
  801566:	83 ec 04             	sub    $0x4,%esp
  801569:	50                   	push   %eax
  80156a:	ff 75 0c             	pushl  0xc(%ebp)
  80156d:	ff 75 08             	pushl  0x8(%ebp)
  801570:	e8 c1 03 00 00       	call   801936 <sys_getSharedObject>
  801575:	83 c4 10             	add    $0x10,%esp
  801578:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  80157b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80157f:	78 08                	js     801589 <sget+0x84>
			{
				return (void*)v1->sva;
  801581:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801584:	8b 40 08             	mov    0x8(%eax),%eax
  801587:	eb 0c                	jmp    801595 <sget+0x90>
			}
			else
			{
				return NULL;
  801589:	b8 00 00 00 00       	mov    $0x0,%eax
  80158e:	eb 05                	jmp    801595 <sget+0x90>
			}
		}
	}
  return NULL;
  801590:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801595:	c9                   	leave  
  801596:	c3                   	ret    

00801597 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
  80159a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80159d:	e8 63 fb ff ff       	call   801105 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015a2:	83 ec 04             	sub    $0x4,%esp
  8015a5:	68 a4 36 80 00       	push   $0x8036a4
  8015aa:	68 0e 01 00 00       	push   $0x10e
  8015af:	68 73 36 80 00       	push   $0x803673
  8015b4:	e8 9c 17 00 00       	call   802d55 <_panic>

008015b9 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015bf:	83 ec 04             	sub    $0x4,%esp
  8015c2:	68 cc 36 80 00       	push   $0x8036cc
  8015c7:	68 22 01 00 00       	push   $0x122
  8015cc:	68 73 36 80 00       	push   $0x803673
  8015d1:	e8 7f 17 00 00       	call   802d55 <_panic>

008015d6 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015dc:	83 ec 04             	sub    $0x4,%esp
  8015df:	68 f0 36 80 00       	push   $0x8036f0
  8015e4:	68 2d 01 00 00       	push   $0x12d
  8015e9:	68 73 36 80 00       	push   $0x803673
  8015ee:	e8 62 17 00 00       	call   802d55 <_panic>

008015f3 <shrink>:

}
void shrink(uint32 newSize)
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
  8015f6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015f9:	83 ec 04             	sub    $0x4,%esp
  8015fc:	68 f0 36 80 00       	push   $0x8036f0
  801601:	68 32 01 00 00       	push   $0x132
  801606:	68 73 36 80 00       	push   $0x803673
  80160b:	e8 45 17 00 00       	call   802d55 <_panic>

00801610 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
  801613:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801616:	83 ec 04             	sub    $0x4,%esp
  801619:	68 f0 36 80 00       	push   $0x8036f0
  80161e:	68 37 01 00 00       	push   $0x137
  801623:	68 73 36 80 00       	push   $0x803673
  801628:	e8 28 17 00 00       	call   802d55 <_panic>

0080162d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	57                   	push   %edi
  801631:	56                   	push   %esi
  801632:	53                   	push   %ebx
  801633:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80163f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801642:	8b 7d 18             	mov    0x18(%ebp),%edi
  801645:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801648:	cd 30                	int    $0x30
  80164a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80164d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801650:	83 c4 10             	add    $0x10,%esp
  801653:	5b                   	pop    %ebx
  801654:	5e                   	pop    %esi
  801655:	5f                   	pop    %edi
  801656:	5d                   	pop    %ebp
  801657:	c3                   	ret    

00801658 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	83 ec 04             	sub    $0x4,%esp
  80165e:	8b 45 10             	mov    0x10(%ebp),%eax
  801661:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801664:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	52                   	push   %edx
  801670:	ff 75 0c             	pushl  0xc(%ebp)
  801673:	50                   	push   %eax
  801674:	6a 00                	push   $0x0
  801676:	e8 b2 ff ff ff       	call   80162d <syscall>
  80167b:	83 c4 18             	add    $0x18,%esp
}
  80167e:	90                   	nop
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <sys_cgetc>:

int
sys_cgetc(void)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 01                	push   $0x1
  801690:	e8 98 ff ff ff       	call   80162d <syscall>
  801695:	83 c4 18             	add    $0x18,%esp
}
  801698:	c9                   	leave  
  801699:	c3                   	ret    

0080169a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80169d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	52                   	push   %edx
  8016aa:	50                   	push   %eax
  8016ab:	6a 05                	push   $0x5
  8016ad:	e8 7b ff ff ff       	call   80162d <syscall>
  8016b2:	83 c4 18             	add    $0x18,%esp
}
  8016b5:	c9                   	leave  
  8016b6:	c3                   	ret    

008016b7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
  8016ba:	56                   	push   %esi
  8016bb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016bc:	8b 75 18             	mov    0x18(%ebp),%esi
  8016bf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	56                   	push   %esi
  8016cc:	53                   	push   %ebx
  8016cd:	51                   	push   %ecx
  8016ce:	52                   	push   %edx
  8016cf:	50                   	push   %eax
  8016d0:	6a 06                	push   $0x6
  8016d2:	e8 56 ff ff ff       	call   80162d <syscall>
  8016d7:	83 c4 18             	add    $0x18,%esp
}
  8016da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016dd:	5b                   	pop    %ebx
  8016de:	5e                   	pop    %esi
  8016df:	5d                   	pop    %ebp
  8016e0:	c3                   	ret    

008016e1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	52                   	push   %edx
  8016f1:	50                   	push   %eax
  8016f2:	6a 07                	push   $0x7
  8016f4:	e8 34 ff ff ff       	call   80162d <syscall>
  8016f9:	83 c4 18             	add    $0x18,%esp
}
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	ff 75 0c             	pushl  0xc(%ebp)
  80170a:	ff 75 08             	pushl  0x8(%ebp)
  80170d:	6a 08                	push   $0x8
  80170f:	e8 19 ff ff ff       	call   80162d <syscall>
  801714:	83 c4 18             	add    $0x18,%esp
}
  801717:	c9                   	leave  
  801718:	c3                   	ret    

00801719 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 09                	push   $0x9
  801728:	e8 00 ff ff ff       	call   80162d <syscall>
  80172d:	83 c4 18             	add    $0x18,%esp
}
  801730:	c9                   	leave  
  801731:	c3                   	ret    

00801732 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 0a                	push   $0xa
  801741:	e8 e7 fe ff ff       	call   80162d <syscall>
  801746:	83 c4 18             	add    $0x18,%esp
}
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 0b                	push   $0xb
  80175a:	e8 ce fe ff ff       	call   80162d <syscall>
  80175f:	83 c4 18             	add    $0x18,%esp
}
  801762:	c9                   	leave  
  801763:	c3                   	ret    

00801764 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	ff 75 0c             	pushl  0xc(%ebp)
  801770:	ff 75 08             	pushl  0x8(%ebp)
  801773:	6a 0f                	push   $0xf
  801775:	e8 b3 fe ff ff       	call   80162d <syscall>
  80177a:	83 c4 18             	add    $0x18,%esp
	return;
  80177d:	90                   	nop
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	ff 75 0c             	pushl  0xc(%ebp)
  80178c:	ff 75 08             	pushl  0x8(%ebp)
  80178f:	6a 10                	push   $0x10
  801791:	e8 97 fe ff ff       	call   80162d <syscall>
  801796:	83 c4 18             	add    $0x18,%esp
	return ;
  801799:	90                   	nop
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	ff 75 10             	pushl  0x10(%ebp)
  8017a6:	ff 75 0c             	pushl  0xc(%ebp)
  8017a9:	ff 75 08             	pushl  0x8(%ebp)
  8017ac:	6a 11                	push   $0x11
  8017ae:	e8 7a fe ff ff       	call   80162d <syscall>
  8017b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b6:	90                   	nop
}
  8017b7:	c9                   	leave  
  8017b8:	c3                   	ret    

008017b9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 0c                	push   $0xc
  8017c8:	e8 60 fe ff ff       	call   80162d <syscall>
  8017cd:	83 c4 18             	add    $0x18,%esp
}
  8017d0:	c9                   	leave  
  8017d1:	c3                   	ret    

008017d2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	ff 75 08             	pushl  0x8(%ebp)
  8017e0:	6a 0d                	push   $0xd
  8017e2:	e8 46 fe ff ff       	call   80162d <syscall>
  8017e7:	83 c4 18             	add    $0x18,%esp
}
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 0e                	push   $0xe
  8017fb:	e8 2d fe ff ff       	call   80162d <syscall>
  801800:	83 c4 18             	add    $0x18,%esp
}
  801803:	90                   	nop
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 13                	push   $0x13
  801815:	e8 13 fe ff ff       	call   80162d <syscall>
  80181a:	83 c4 18             	add    $0x18,%esp
}
  80181d:	90                   	nop
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 14                	push   $0x14
  80182f:	e8 f9 fd ff ff       	call   80162d <syscall>
  801834:	83 c4 18             	add    $0x18,%esp
}
  801837:	90                   	nop
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sys_cputc>:


void
sys_cputc(const char c)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 04             	sub    $0x4,%esp
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801846:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	50                   	push   %eax
  801853:	6a 15                	push   $0x15
  801855:	e8 d3 fd ff ff       	call   80162d <syscall>
  80185a:	83 c4 18             	add    $0x18,%esp
}
  80185d:	90                   	nop
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 16                	push   $0x16
  80186f:	e8 b9 fd ff ff       	call   80162d <syscall>
  801874:	83 c4 18             	add    $0x18,%esp
}
  801877:	90                   	nop
  801878:	c9                   	leave  
  801879:	c3                   	ret    

0080187a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80187d:	8b 45 08             	mov    0x8(%ebp),%eax
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	ff 75 0c             	pushl  0xc(%ebp)
  801889:	50                   	push   %eax
  80188a:	6a 17                	push   $0x17
  80188c:	e8 9c fd ff ff       	call   80162d <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
}
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801899:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189c:	8b 45 08             	mov    0x8(%ebp),%eax
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	52                   	push   %edx
  8018a6:	50                   	push   %eax
  8018a7:	6a 1a                	push   $0x1a
  8018a9:	e8 7f fd ff ff       	call   80162d <syscall>
  8018ae:	83 c4 18             	add    $0x18,%esp
}
  8018b1:	c9                   	leave  
  8018b2:	c3                   	ret    

008018b3 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	52                   	push   %edx
  8018c3:	50                   	push   %eax
  8018c4:	6a 18                	push   $0x18
  8018c6:	e8 62 fd ff ff       	call   80162d <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
}
  8018ce:	90                   	nop
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	52                   	push   %edx
  8018e1:	50                   	push   %eax
  8018e2:	6a 19                	push   $0x19
  8018e4:	e8 44 fd ff ff       	call   80162d <syscall>
  8018e9:	83 c4 18             	add    $0x18,%esp
}
  8018ec:	90                   	nop
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	83 ec 04             	sub    $0x4,%esp
  8018f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018fb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018fe:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801902:	8b 45 08             	mov    0x8(%ebp),%eax
  801905:	6a 00                	push   $0x0
  801907:	51                   	push   %ecx
  801908:	52                   	push   %edx
  801909:	ff 75 0c             	pushl  0xc(%ebp)
  80190c:	50                   	push   %eax
  80190d:	6a 1b                	push   $0x1b
  80190f:	e8 19 fd ff ff       	call   80162d <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
}
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80191c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191f:	8b 45 08             	mov    0x8(%ebp),%eax
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	52                   	push   %edx
  801929:	50                   	push   %eax
  80192a:	6a 1c                	push   $0x1c
  80192c:	e8 fc fc ff ff       	call   80162d <syscall>
  801931:	83 c4 18             	add    $0x18,%esp
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801939:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80193c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	51                   	push   %ecx
  801947:	52                   	push   %edx
  801948:	50                   	push   %eax
  801949:	6a 1d                	push   $0x1d
  80194b:	e8 dd fc ff ff       	call   80162d <syscall>
  801950:	83 c4 18             	add    $0x18,%esp
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801958:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195b:	8b 45 08             	mov    0x8(%ebp),%eax
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	52                   	push   %edx
  801965:	50                   	push   %eax
  801966:	6a 1e                	push   $0x1e
  801968:	e8 c0 fc ff ff       	call   80162d <syscall>
  80196d:	83 c4 18             	add    $0x18,%esp
}
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 1f                	push   $0x1f
  801981:	e8 a7 fc ff ff       	call   80162d <syscall>
  801986:	83 c4 18             	add    $0x18,%esp
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80198e:	8b 45 08             	mov    0x8(%ebp),%eax
  801991:	6a 00                	push   $0x0
  801993:	ff 75 14             	pushl  0x14(%ebp)
  801996:	ff 75 10             	pushl  0x10(%ebp)
  801999:	ff 75 0c             	pushl  0xc(%ebp)
  80199c:	50                   	push   %eax
  80199d:	6a 20                	push   $0x20
  80199f:	e8 89 fc ff ff       	call   80162d <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	50                   	push   %eax
  8019b8:	6a 21                	push   $0x21
  8019ba:	e8 6e fc ff ff       	call   80162d <syscall>
  8019bf:	83 c4 18             	add    $0x18,%esp
}
  8019c2:	90                   	nop
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	50                   	push   %eax
  8019d4:	6a 22                	push   $0x22
  8019d6:	e8 52 fc ff ff       	call   80162d <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 02                	push   $0x2
  8019ef:	e8 39 fc ff ff       	call   80162d <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
}
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 03                	push   $0x3
  801a08:	e8 20 fc ff ff       	call   80162d <syscall>
  801a0d:	83 c4 18             	add    $0x18,%esp
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 04                	push   $0x4
  801a21:	e8 07 fc ff ff       	call   80162d <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <sys_exit_env>:


void sys_exit_env(void)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 23                	push   $0x23
  801a3a:	e8 ee fb ff ff       	call   80162d <syscall>
  801a3f:	83 c4 18             	add    $0x18,%esp
}
  801a42:	90                   	nop
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
  801a48:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a4b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a4e:	8d 50 04             	lea    0x4(%eax),%edx
  801a51:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	52                   	push   %edx
  801a5b:	50                   	push   %eax
  801a5c:	6a 24                	push   $0x24
  801a5e:	e8 ca fb ff ff       	call   80162d <syscall>
  801a63:	83 c4 18             	add    $0x18,%esp
	return result;
  801a66:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a69:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a6f:	89 01                	mov    %eax,(%ecx)
  801a71:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	c9                   	leave  
  801a78:	c2 04 00             	ret    $0x4

00801a7b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	ff 75 10             	pushl  0x10(%ebp)
  801a85:	ff 75 0c             	pushl  0xc(%ebp)
  801a88:	ff 75 08             	pushl  0x8(%ebp)
  801a8b:	6a 12                	push   $0x12
  801a8d:	e8 9b fb ff ff       	call   80162d <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
	return ;
  801a95:	90                   	nop
}
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 25                	push   $0x25
  801aa7:	e8 81 fb ff ff       	call   80162d <syscall>
  801aac:	83 c4 18             	add    $0x18,%esp
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	83 ec 04             	sub    $0x4,%esp
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801abd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	50                   	push   %eax
  801aca:	6a 26                	push   $0x26
  801acc:	e8 5c fb ff ff       	call   80162d <syscall>
  801ad1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad4:	90                   	nop
}
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <rsttst>:
void rsttst()
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 28                	push   $0x28
  801ae6:	e8 42 fb ff ff       	call   80162d <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
	return ;
  801aee:	90                   	nop
}
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
  801af4:	83 ec 04             	sub    $0x4,%esp
  801af7:	8b 45 14             	mov    0x14(%ebp),%eax
  801afa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801afd:	8b 55 18             	mov    0x18(%ebp),%edx
  801b00:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b04:	52                   	push   %edx
  801b05:	50                   	push   %eax
  801b06:	ff 75 10             	pushl  0x10(%ebp)
  801b09:	ff 75 0c             	pushl  0xc(%ebp)
  801b0c:	ff 75 08             	pushl  0x8(%ebp)
  801b0f:	6a 27                	push   $0x27
  801b11:	e8 17 fb ff ff       	call   80162d <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
	return ;
  801b19:	90                   	nop
}
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <chktst>:
void chktst(uint32 n)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	ff 75 08             	pushl  0x8(%ebp)
  801b2a:	6a 29                	push   $0x29
  801b2c:	e8 fc fa ff ff       	call   80162d <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
	return ;
  801b34:	90                   	nop
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <inctst>:

void inctst()
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 2a                	push   $0x2a
  801b46:	e8 e2 fa ff ff       	call   80162d <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4e:	90                   	nop
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <gettst>:
uint32 gettst()
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 2b                	push   $0x2b
  801b60:	e8 c8 fa ff ff       	call   80162d <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
  801b6d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 2c                	push   $0x2c
  801b7c:	e8 ac fa ff ff       	call   80162d <syscall>
  801b81:	83 c4 18             	add    $0x18,%esp
  801b84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b87:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b8b:	75 07                	jne    801b94 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b8d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b92:	eb 05                	jmp    801b99 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 2c                	push   $0x2c
  801bad:	e8 7b fa ff ff       	call   80162d <syscall>
  801bb2:	83 c4 18             	add    $0x18,%esp
  801bb5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bb8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bbc:	75 07                	jne    801bc5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bbe:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc3:	eb 05                	jmp    801bca <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
  801bcf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 2c                	push   $0x2c
  801bde:	e8 4a fa ff ff       	call   80162d <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
  801be6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801be9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801bed:	75 07                	jne    801bf6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bef:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf4:	eb 05                	jmp    801bfb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bf6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
  801c00:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 2c                	push   $0x2c
  801c0f:	e8 19 fa ff ff       	call   80162d <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
  801c17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c1a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c1e:	75 07                	jne    801c27 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c20:	b8 01 00 00 00       	mov    $0x1,%eax
  801c25:	eb 05                	jmp    801c2c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    

00801c2e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	ff 75 08             	pushl  0x8(%ebp)
  801c3c:	6a 2d                	push   $0x2d
  801c3e:	e8 ea f9 ff ff       	call   80162d <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
	return ;
  801c46:	90                   	nop
}
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
  801c4c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c4d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c50:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	6a 00                	push   $0x0
  801c5b:	53                   	push   %ebx
  801c5c:	51                   	push   %ecx
  801c5d:	52                   	push   %edx
  801c5e:	50                   	push   %eax
  801c5f:	6a 2e                	push   $0x2e
  801c61:	e8 c7 f9 ff ff       	call   80162d <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
}
  801c69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	52                   	push   %edx
  801c7e:	50                   	push   %eax
  801c7f:	6a 2f                	push   $0x2f
  801c81:	e8 a7 f9 ff ff       	call   80162d <syscall>
  801c86:	83 c4 18             	add    $0x18,%esp
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801c91:	83 ec 0c             	sub    $0xc,%esp
  801c94:	68 00 37 80 00       	push   $0x803700
  801c99:	e8 dd e6 ff ff       	call   80037b <cprintf>
  801c9e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ca1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ca8:	83 ec 0c             	sub    $0xc,%esp
  801cab:	68 2c 37 80 00       	push   $0x80372c
  801cb0:	e8 c6 e6 ff ff       	call   80037b <cprintf>
  801cb5:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801cb8:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cbc:	a1 38 41 80 00       	mov    0x804138,%eax
  801cc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cc4:	eb 56                	jmp    801d1c <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801cc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cca:	74 1c                	je     801ce8 <print_mem_block_lists+0x5d>
  801ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ccf:	8b 50 08             	mov    0x8(%eax),%edx
  801cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd5:	8b 48 08             	mov    0x8(%eax),%ecx
  801cd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cdb:	8b 40 0c             	mov    0xc(%eax),%eax
  801cde:	01 c8                	add    %ecx,%eax
  801ce0:	39 c2                	cmp    %eax,%edx
  801ce2:	73 04                	jae    801ce8 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ce4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ceb:	8b 50 08             	mov    0x8(%eax),%edx
  801cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf1:	8b 40 0c             	mov    0xc(%eax),%eax
  801cf4:	01 c2                	add    %eax,%edx
  801cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf9:	8b 40 08             	mov    0x8(%eax),%eax
  801cfc:	83 ec 04             	sub    $0x4,%esp
  801cff:	52                   	push   %edx
  801d00:	50                   	push   %eax
  801d01:	68 41 37 80 00       	push   $0x803741
  801d06:	e8 70 e6 ff ff       	call   80037b <cprintf>
  801d0b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d11:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d14:	a1 40 41 80 00       	mov    0x804140,%eax
  801d19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d20:	74 07                	je     801d29 <print_mem_block_lists+0x9e>
  801d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d25:	8b 00                	mov    (%eax),%eax
  801d27:	eb 05                	jmp    801d2e <print_mem_block_lists+0xa3>
  801d29:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2e:	a3 40 41 80 00       	mov    %eax,0x804140
  801d33:	a1 40 41 80 00       	mov    0x804140,%eax
  801d38:	85 c0                	test   %eax,%eax
  801d3a:	75 8a                	jne    801cc6 <print_mem_block_lists+0x3b>
  801d3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d40:	75 84                	jne    801cc6 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d42:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d46:	75 10                	jne    801d58 <print_mem_block_lists+0xcd>
  801d48:	83 ec 0c             	sub    $0xc,%esp
  801d4b:	68 50 37 80 00       	push   $0x803750
  801d50:	e8 26 e6 ff ff       	call   80037b <cprintf>
  801d55:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d58:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d5f:	83 ec 0c             	sub    $0xc,%esp
  801d62:	68 74 37 80 00       	push   $0x803774
  801d67:	e8 0f e6 ff ff       	call   80037b <cprintf>
  801d6c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d6f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d73:	a1 40 40 80 00       	mov    0x804040,%eax
  801d78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d7b:	eb 56                	jmp    801dd3 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d81:	74 1c                	je     801d9f <print_mem_block_lists+0x114>
  801d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d86:	8b 50 08             	mov    0x8(%eax),%edx
  801d89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8c:	8b 48 08             	mov    0x8(%eax),%ecx
  801d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d92:	8b 40 0c             	mov    0xc(%eax),%eax
  801d95:	01 c8                	add    %ecx,%eax
  801d97:	39 c2                	cmp    %eax,%edx
  801d99:	73 04                	jae    801d9f <print_mem_block_lists+0x114>
			sorted = 0 ;
  801d9b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da2:	8b 50 08             	mov    0x8(%eax),%edx
  801da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da8:	8b 40 0c             	mov    0xc(%eax),%eax
  801dab:	01 c2                	add    %eax,%edx
  801dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db0:	8b 40 08             	mov    0x8(%eax),%eax
  801db3:	83 ec 04             	sub    $0x4,%esp
  801db6:	52                   	push   %edx
  801db7:	50                   	push   %eax
  801db8:	68 41 37 80 00       	push   $0x803741
  801dbd:	e8 b9 e5 ff ff       	call   80037b <cprintf>
  801dc2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801dcb:	a1 48 40 80 00       	mov    0x804048,%eax
  801dd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dd3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dd7:	74 07                	je     801de0 <print_mem_block_lists+0x155>
  801dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddc:	8b 00                	mov    (%eax),%eax
  801dde:	eb 05                	jmp    801de5 <print_mem_block_lists+0x15a>
  801de0:	b8 00 00 00 00       	mov    $0x0,%eax
  801de5:	a3 48 40 80 00       	mov    %eax,0x804048
  801dea:	a1 48 40 80 00       	mov    0x804048,%eax
  801def:	85 c0                	test   %eax,%eax
  801df1:	75 8a                	jne    801d7d <print_mem_block_lists+0xf2>
  801df3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801df7:	75 84                	jne    801d7d <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801df9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801dfd:	75 10                	jne    801e0f <print_mem_block_lists+0x184>
  801dff:	83 ec 0c             	sub    $0xc,%esp
  801e02:	68 8c 37 80 00       	push   $0x80378c
  801e07:	e8 6f e5 ff ff       	call   80037b <cprintf>
  801e0c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e0f:	83 ec 0c             	sub    $0xc,%esp
  801e12:	68 00 37 80 00       	push   $0x803700
  801e17:	e8 5f e5 ff ff       	call   80037b <cprintf>
  801e1c:	83 c4 10             	add    $0x10,%esp

}
  801e1f:	90                   	nop
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  801e28:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  801e2e:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e35:	00 00 00 
  801e38:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e3f:	00 00 00 
  801e42:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e49:	00 00 00 
	for(int i = 0; i<n;i++)
  801e4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e53:	e9 9e 00 00 00       	jmp    801ef6 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  801e58:	a1 50 40 80 00       	mov    0x804050,%eax
  801e5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e60:	c1 e2 04             	shl    $0x4,%edx
  801e63:	01 d0                	add    %edx,%eax
  801e65:	85 c0                	test   %eax,%eax
  801e67:	75 14                	jne    801e7d <initialize_MemBlocksList+0x5b>
  801e69:	83 ec 04             	sub    $0x4,%esp
  801e6c:	68 b4 37 80 00       	push   $0x8037b4
  801e71:	6a 47                	push   $0x47
  801e73:	68 d7 37 80 00       	push   $0x8037d7
  801e78:	e8 d8 0e 00 00       	call   802d55 <_panic>
  801e7d:	a1 50 40 80 00       	mov    0x804050,%eax
  801e82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e85:	c1 e2 04             	shl    $0x4,%edx
  801e88:	01 d0                	add    %edx,%eax
  801e8a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801e90:	89 10                	mov    %edx,(%eax)
  801e92:	8b 00                	mov    (%eax),%eax
  801e94:	85 c0                	test   %eax,%eax
  801e96:	74 18                	je     801eb0 <initialize_MemBlocksList+0x8e>
  801e98:	a1 48 41 80 00       	mov    0x804148,%eax
  801e9d:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801ea3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ea6:	c1 e1 04             	shl    $0x4,%ecx
  801ea9:	01 ca                	add    %ecx,%edx
  801eab:	89 50 04             	mov    %edx,0x4(%eax)
  801eae:	eb 12                	jmp    801ec2 <initialize_MemBlocksList+0xa0>
  801eb0:	a1 50 40 80 00       	mov    0x804050,%eax
  801eb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb8:	c1 e2 04             	shl    $0x4,%edx
  801ebb:	01 d0                	add    %edx,%eax
  801ebd:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801ec2:	a1 50 40 80 00       	mov    0x804050,%eax
  801ec7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eca:	c1 e2 04             	shl    $0x4,%edx
  801ecd:	01 d0                	add    %edx,%eax
  801ecf:	a3 48 41 80 00       	mov    %eax,0x804148
  801ed4:	a1 50 40 80 00       	mov    0x804050,%eax
  801ed9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801edc:	c1 e2 04             	shl    $0x4,%edx
  801edf:	01 d0                	add    %edx,%eax
  801ee1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ee8:	a1 54 41 80 00       	mov    0x804154,%eax
  801eed:	40                   	inc    %eax
  801eee:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  801ef3:	ff 45 f4             	incl   -0xc(%ebp)
  801ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801efc:	0f 82 56 ff ff ff    	jb     801e58 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  801f02:	90                   	nop
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
  801f08:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  801f0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  801f11:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  801f18:	a1 40 40 80 00       	mov    0x804040,%eax
  801f1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f20:	eb 23                	jmp    801f45 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  801f22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f25:	8b 40 08             	mov    0x8(%eax),%eax
  801f28:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801f2b:	75 09                	jne    801f36 <find_block+0x31>
		{
			found = 1;
  801f2d:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  801f34:	eb 35                	jmp    801f6b <find_block+0x66>
		}
		else
		{
			found = 0;
  801f36:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  801f3d:	a1 48 40 80 00       	mov    0x804048,%eax
  801f42:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f45:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f49:	74 07                	je     801f52 <find_block+0x4d>
  801f4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f4e:	8b 00                	mov    (%eax),%eax
  801f50:	eb 05                	jmp    801f57 <find_block+0x52>
  801f52:	b8 00 00 00 00       	mov    $0x0,%eax
  801f57:	a3 48 40 80 00       	mov    %eax,0x804048
  801f5c:	a1 48 40 80 00       	mov    0x804048,%eax
  801f61:	85 c0                	test   %eax,%eax
  801f63:	75 bd                	jne    801f22 <find_block+0x1d>
  801f65:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f69:	75 b7                	jne    801f22 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  801f6b:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  801f6f:	75 05                	jne    801f76 <find_block+0x71>
	{
		return blk;
  801f71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f74:	eb 05                	jmp    801f7b <find_block+0x76>
	}
	else
	{
		return NULL;
  801f76:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
  801f80:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  801f83:	8b 45 08             	mov    0x8(%ebp),%eax
  801f86:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  801f89:	a1 40 40 80 00       	mov    0x804040,%eax
  801f8e:	85 c0                	test   %eax,%eax
  801f90:	74 12                	je     801fa4 <insert_sorted_allocList+0x27>
  801f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f95:	8b 50 08             	mov    0x8(%eax),%edx
  801f98:	a1 40 40 80 00       	mov    0x804040,%eax
  801f9d:	8b 40 08             	mov    0x8(%eax),%eax
  801fa0:	39 c2                	cmp    %eax,%edx
  801fa2:	73 65                	jae    802009 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  801fa4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fa8:	75 14                	jne    801fbe <insert_sorted_allocList+0x41>
  801faa:	83 ec 04             	sub    $0x4,%esp
  801fad:	68 b4 37 80 00       	push   $0x8037b4
  801fb2:	6a 7b                	push   $0x7b
  801fb4:	68 d7 37 80 00       	push   $0x8037d7
  801fb9:	e8 97 0d 00 00       	call   802d55 <_panic>
  801fbe:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc7:	89 10                	mov    %edx,(%eax)
  801fc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fcc:	8b 00                	mov    (%eax),%eax
  801fce:	85 c0                	test   %eax,%eax
  801fd0:	74 0d                	je     801fdf <insert_sorted_allocList+0x62>
  801fd2:	a1 40 40 80 00       	mov    0x804040,%eax
  801fd7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fda:	89 50 04             	mov    %edx,0x4(%eax)
  801fdd:	eb 08                	jmp    801fe7 <insert_sorted_allocList+0x6a>
  801fdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe2:	a3 44 40 80 00       	mov    %eax,0x804044
  801fe7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fea:	a3 40 40 80 00       	mov    %eax,0x804040
  801fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ff9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801ffe:	40                   	inc    %eax
  801fff:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802004:	e9 5f 01 00 00       	jmp    802168 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  802009:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200c:	8b 50 08             	mov    0x8(%eax),%edx
  80200f:	a1 44 40 80 00       	mov    0x804044,%eax
  802014:	8b 40 08             	mov    0x8(%eax),%eax
  802017:	39 c2                	cmp    %eax,%edx
  802019:	76 65                	jbe    802080 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  80201b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80201f:	75 14                	jne    802035 <insert_sorted_allocList+0xb8>
  802021:	83 ec 04             	sub    $0x4,%esp
  802024:	68 f0 37 80 00       	push   $0x8037f0
  802029:	6a 7f                	push   $0x7f
  80202b:	68 d7 37 80 00       	push   $0x8037d7
  802030:	e8 20 0d 00 00       	call   802d55 <_panic>
  802035:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80203b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203e:	89 50 04             	mov    %edx,0x4(%eax)
  802041:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802044:	8b 40 04             	mov    0x4(%eax),%eax
  802047:	85 c0                	test   %eax,%eax
  802049:	74 0c                	je     802057 <insert_sorted_allocList+0xda>
  80204b:	a1 44 40 80 00       	mov    0x804044,%eax
  802050:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802053:	89 10                	mov    %edx,(%eax)
  802055:	eb 08                	jmp    80205f <insert_sorted_allocList+0xe2>
  802057:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205a:	a3 40 40 80 00       	mov    %eax,0x804040
  80205f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802062:	a3 44 40 80 00       	mov    %eax,0x804044
  802067:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80206a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802070:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802075:	40                   	inc    %eax
  802076:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80207b:	e9 e8 00 00 00       	jmp    802168 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802080:	a1 40 40 80 00       	mov    0x804040,%eax
  802085:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802088:	e9 ab 00 00 00       	jmp    802138 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  80208d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802090:	8b 00                	mov    (%eax),%eax
  802092:	85 c0                	test   %eax,%eax
  802094:	0f 84 96 00 00 00    	je     802130 <insert_sorted_allocList+0x1b3>
  80209a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209d:	8b 50 08             	mov    0x8(%eax),%edx
  8020a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a3:	8b 40 08             	mov    0x8(%eax),%eax
  8020a6:	39 c2                	cmp    %eax,%edx
  8020a8:	0f 86 82 00 00 00    	jbe    802130 <insert_sorted_allocList+0x1b3>
  8020ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b1:	8b 50 08             	mov    0x8(%eax),%edx
  8020b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b7:	8b 00                	mov    (%eax),%eax
  8020b9:	8b 40 08             	mov    0x8(%eax),%eax
  8020bc:	39 c2                	cmp    %eax,%edx
  8020be:	73 70                	jae    802130 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  8020c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c4:	74 06                	je     8020cc <insert_sorted_allocList+0x14f>
  8020c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020ca:	75 17                	jne    8020e3 <insert_sorted_allocList+0x166>
  8020cc:	83 ec 04             	sub    $0x4,%esp
  8020cf:	68 14 38 80 00       	push   $0x803814
  8020d4:	68 87 00 00 00       	push   $0x87
  8020d9:	68 d7 37 80 00       	push   $0x8037d7
  8020de:	e8 72 0c 00 00       	call   802d55 <_panic>
  8020e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e6:	8b 10                	mov    (%eax),%edx
  8020e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020eb:	89 10                	mov    %edx,(%eax)
  8020ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f0:	8b 00                	mov    (%eax),%eax
  8020f2:	85 c0                	test   %eax,%eax
  8020f4:	74 0b                	je     802101 <insert_sorted_allocList+0x184>
  8020f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f9:	8b 00                	mov    (%eax),%eax
  8020fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020fe:	89 50 04             	mov    %edx,0x4(%eax)
  802101:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802104:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802107:	89 10                	mov    %edx,(%eax)
  802109:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210f:	89 50 04             	mov    %edx,0x4(%eax)
  802112:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802115:	8b 00                	mov    (%eax),%eax
  802117:	85 c0                	test   %eax,%eax
  802119:	75 08                	jne    802123 <insert_sorted_allocList+0x1a6>
  80211b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211e:	a3 44 40 80 00       	mov    %eax,0x804044
  802123:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802128:	40                   	inc    %eax
  802129:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80212e:	eb 38                	jmp    802168 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802130:	a1 48 40 80 00       	mov    0x804048,%eax
  802135:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802138:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80213c:	74 07                	je     802145 <insert_sorted_allocList+0x1c8>
  80213e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802141:	8b 00                	mov    (%eax),%eax
  802143:	eb 05                	jmp    80214a <insert_sorted_allocList+0x1cd>
  802145:	b8 00 00 00 00       	mov    $0x0,%eax
  80214a:	a3 48 40 80 00       	mov    %eax,0x804048
  80214f:	a1 48 40 80 00       	mov    0x804048,%eax
  802154:	85 c0                	test   %eax,%eax
  802156:	0f 85 31 ff ff ff    	jne    80208d <insert_sorted_allocList+0x110>
  80215c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802160:	0f 85 27 ff ff ff    	jne    80208d <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802166:	eb 00                	jmp    802168 <insert_sorted_allocList+0x1eb>
  802168:	90                   	nop
  802169:	c9                   	leave  
  80216a:	c3                   	ret    

0080216b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80216b:	55                   	push   %ebp
  80216c:	89 e5                	mov    %esp,%ebp
  80216e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802171:	8b 45 08             	mov    0x8(%ebp),%eax
  802174:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802177:	a1 48 41 80 00       	mov    0x804148,%eax
  80217c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80217f:	a1 38 41 80 00       	mov    0x804138,%eax
  802184:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802187:	e9 77 01 00 00       	jmp    802303 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  80218c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218f:	8b 40 0c             	mov    0xc(%eax),%eax
  802192:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802195:	0f 85 8a 00 00 00    	jne    802225 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80219b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80219f:	75 17                	jne    8021b8 <alloc_block_FF+0x4d>
  8021a1:	83 ec 04             	sub    $0x4,%esp
  8021a4:	68 48 38 80 00       	push   $0x803848
  8021a9:	68 9e 00 00 00       	push   $0x9e
  8021ae:	68 d7 37 80 00       	push   $0x8037d7
  8021b3:	e8 9d 0b 00 00       	call   802d55 <_panic>
  8021b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bb:	8b 00                	mov    (%eax),%eax
  8021bd:	85 c0                	test   %eax,%eax
  8021bf:	74 10                	je     8021d1 <alloc_block_FF+0x66>
  8021c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c4:	8b 00                	mov    (%eax),%eax
  8021c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c9:	8b 52 04             	mov    0x4(%edx),%edx
  8021cc:	89 50 04             	mov    %edx,0x4(%eax)
  8021cf:	eb 0b                	jmp    8021dc <alloc_block_FF+0x71>
  8021d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d4:	8b 40 04             	mov    0x4(%eax),%eax
  8021d7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8021dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021df:	8b 40 04             	mov    0x4(%eax),%eax
  8021e2:	85 c0                	test   %eax,%eax
  8021e4:	74 0f                	je     8021f5 <alloc_block_FF+0x8a>
  8021e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e9:	8b 40 04             	mov    0x4(%eax),%eax
  8021ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ef:	8b 12                	mov    (%edx),%edx
  8021f1:	89 10                	mov    %edx,(%eax)
  8021f3:	eb 0a                	jmp    8021ff <alloc_block_FF+0x94>
  8021f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f8:	8b 00                	mov    (%eax),%eax
  8021fa:	a3 38 41 80 00       	mov    %eax,0x804138
  8021ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802202:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802212:	a1 44 41 80 00       	mov    0x804144,%eax
  802217:	48                   	dec    %eax
  802218:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  80221d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802220:	e9 11 01 00 00       	jmp    802336 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802228:	8b 40 0c             	mov    0xc(%eax),%eax
  80222b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80222e:	0f 86 c7 00 00 00    	jbe    8022fb <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802234:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802238:	75 17                	jne    802251 <alloc_block_FF+0xe6>
  80223a:	83 ec 04             	sub    $0x4,%esp
  80223d:	68 48 38 80 00       	push   $0x803848
  802242:	68 a3 00 00 00       	push   $0xa3
  802247:	68 d7 37 80 00       	push   $0x8037d7
  80224c:	e8 04 0b 00 00       	call   802d55 <_panic>
  802251:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802254:	8b 00                	mov    (%eax),%eax
  802256:	85 c0                	test   %eax,%eax
  802258:	74 10                	je     80226a <alloc_block_FF+0xff>
  80225a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80225d:	8b 00                	mov    (%eax),%eax
  80225f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802262:	8b 52 04             	mov    0x4(%edx),%edx
  802265:	89 50 04             	mov    %edx,0x4(%eax)
  802268:	eb 0b                	jmp    802275 <alloc_block_FF+0x10a>
  80226a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226d:	8b 40 04             	mov    0x4(%eax),%eax
  802270:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802278:	8b 40 04             	mov    0x4(%eax),%eax
  80227b:	85 c0                	test   %eax,%eax
  80227d:	74 0f                	je     80228e <alloc_block_FF+0x123>
  80227f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802282:	8b 40 04             	mov    0x4(%eax),%eax
  802285:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802288:	8b 12                	mov    (%edx),%edx
  80228a:	89 10                	mov    %edx,(%eax)
  80228c:	eb 0a                	jmp    802298 <alloc_block_FF+0x12d>
  80228e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802291:	8b 00                	mov    (%eax),%eax
  802293:	a3 48 41 80 00       	mov    %eax,0x804148
  802298:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80229b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022ab:	a1 54 41 80 00       	mov    0x804154,%eax
  8022b0:	48                   	dec    %eax
  8022b1:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8022b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022bc:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8022bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8022c5:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8022c8:	89 c2                	mov    %eax,%edx
  8022ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cd:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8022d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d3:	8b 40 08             	mov    0x8(%eax),%eax
  8022d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8022d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dc:	8b 50 08             	mov    0x8(%eax),%edx
  8022df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8022e5:	01 c2                	add    %eax,%edx
  8022e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ea:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8022ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022f3:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8022f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022f9:	eb 3b                	jmp    802336 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8022fb:	a1 40 41 80 00       	mov    0x804140,%eax
  802300:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802303:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802307:	74 07                	je     802310 <alloc_block_FF+0x1a5>
  802309:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230c:	8b 00                	mov    (%eax),%eax
  80230e:	eb 05                	jmp    802315 <alloc_block_FF+0x1aa>
  802310:	b8 00 00 00 00       	mov    $0x0,%eax
  802315:	a3 40 41 80 00       	mov    %eax,0x804140
  80231a:	a1 40 41 80 00       	mov    0x804140,%eax
  80231f:	85 c0                	test   %eax,%eax
  802321:	0f 85 65 fe ff ff    	jne    80218c <alloc_block_FF+0x21>
  802327:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80232b:	0f 85 5b fe ff ff    	jne    80218c <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802331:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802336:	c9                   	leave  
  802337:	c3                   	ret    

00802338 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802338:	55                   	push   %ebp
  802339:	89 e5                	mov    %esp,%ebp
  80233b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  80233e:	8b 45 08             	mov    0x8(%ebp),%eax
  802341:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802344:	a1 48 41 80 00       	mov    0x804148,%eax
  802349:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  80234c:	a1 44 41 80 00       	mov    0x804144,%eax
  802351:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802354:	a1 38 41 80 00       	mov    0x804138,%eax
  802359:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80235c:	e9 a1 00 00 00       	jmp    802402 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802364:	8b 40 0c             	mov    0xc(%eax),%eax
  802367:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80236a:	0f 85 8a 00 00 00    	jne    8023fa <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802370:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802374:	75 17                	jne    80238d <alloc_block_BF+0x55>
  802376:	83 ec 04             	sub    $0x4,%esp
  802379:	68 48 38 80 00       	push   $0x803848
  80237e:	68 c2 00 00 00       	push   $0xc2
  802383:	68 d7 37 80 00       	push   $0x8037d7
  802388:	e8 c8 09 00 00       	call   802d55 <_panic>
  80238d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802390:	8b 00                	mov    (%eax),%eax
  802392:	85 c0                	test   %eax,%eax
  802394:	74 10                	je     8023a6 <alloc_block_BF+0x6e>
  802396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802399:	8b 00                	mov    (%eax),%eax
  80239b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80239e:	8b 52 04             	mov    0x4(%edx),%edx
  8023a1:	89 50 04             	mov    %edx,0x4(%eax)
  8023a4:	eb 0b                	jmp    8023b1 <alloc_block_BF+0x79>
  8023a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a9:	8b 40 04             	mov    0x4(%eax),%eax
  8023ac:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b4:	8b 40 04             	mov    0x4(%eax),%eax
  8023b7:	85 c0                	test   %eax,%eax
  8023b9:	74 0f                	je     8023ca <alloc_block_BF+0x92>
  8023bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023be:	8b 40 04             	mov    0x4(%eax),%eax
  8023c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c4:	8b 12                	mov    (%edx),%edx
  8023c6:	89 10                	mov    %edx,(%eax)
  8023c8:	eb 0a                	jmp    8023d4 <alloc_block_BF+0x9c>
  8023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cd:	8b 00                	mov    (%eax),%eax
  8023cf:	a3 38 41 80 00       	mov    %eax,0x804138
  8023d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023e7:	a1 44 41 80 00       	mov    0x804144,%eax
  8023ec:	48                   	dec    %eax
  8023ed:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f5:	e9 11 02 00 00       	jmp    80260b <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023fa:	a1 40 41 80 00       	mov    0x804140,%eax
  8023ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802402:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802406:	74 07                	je     80240f <alloc_block_BF+0xd7>
  802408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240b:	8b 00                	mov    (%eax),%eax
  80240d:	eb 05                	jmp    802414 <alloc_block_BF+0xdc>
  80240f:	b8 00 00 00 00       	mov    $0x0,%eax
  802414:	a3 40 41 80 00       	mov    %eax,0x804140
  802419:	a1 40 41 80 00       	mov    0x804140,%eax
  80241e:	85 c0                	test   %eax,%eax
  802420:	0f 85 3b ff ff ff    	jne    802361 <alloc_block_BF+0x29>
  802426:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242a:	0f 85 31 ff ff ff    	jne    802361 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802430:	a1 38 41 80 00       	mov    0x804138,%eax
  802435:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802438:	eb 27                	jmp    802461 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  80243a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243d:	8b 40 0c             	mov    0xc(%eax),%eax
  802440:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802443:	76 14                	jbe    802459 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802448:	8b 40 0c             	mov    0xc(%eax),%eax
  80244b:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  80244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802451:	8b 40 08             	mov    0x8(%eax),%eax
  802454:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802457:	eb 2e                	jmp    802487 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802459:	a1 40 41 80 00       	mov    0x804140,%eax
  80245e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802461:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802465:	74 07                	je     80246e <alloc_block_BF+0x136>
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	8b 00                	mov    (%eax),%eax
  80246c:	eb 05                	jmp    802473 <alloc_block_BF+0x13b>
  80246e:	b8 00 00 00 00       	mov    $0x0,%eax
  802473:	a3 40 41 80 00       	mov    %eax,0x804140
  802478:	a1 40 41 80 00       	mov    0x804140,%eax
  80247d:	85 c0                	test   %eax,%eax
  80247f:	75 b9                	jne    80243a <alloc_block_BF+0x102>
  802481:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802485:	75 b3                	jne    80243a <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802487:	a1 38 41 80 00       	mov    0x804138,%eax
  80248c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80248f:	eb 30                	jmp    8024c1 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802494:	8b 40 0c             	mov    0xc(%eax),%eax
  802497:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80249a:	73 1d                	jae    8024b9 <alloc_block_BF+0x181>
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8024a5:	76 12                	jbe    8024b9 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  8024a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	8b 40 08             	mov    0x8(%eax),%eax
  8024b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024b9:	a1 40 41 80 00       	mov    0x804140,%eax
  8024be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c5:	74 07                	je     8024ce <alloc_block_BF+0x196>
  8024c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ca:	8b 00                	mov    (%eax),%eax
  8024cc:	eb 05                	jmp    8024d3 <alloc_block_BF+0x19b>
  8024ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d3:	a3 40 41 80 00       	mov    %eax,0x804140
  8024d8:	a1 40 41 80 00       	mov    0x804140,%eax
  8024dd:	85 c0                	test   %eax,%eax
  8024df:	75 b0                	jne    802491 <alloc_block_BF+0x159>
  8024e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e5:	75 aa                	jne    802491 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024e7:	a1 38 41 80 00       	mov    0x804138,%eax
  8024ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ef:	e9 e4 00 00 00       	jmp    8025d8 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8024fa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8024fd:	0f 85 cd 00 00 00    	jne    8025d0 <alloc_block_BF+0x298>
  802503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802506:	8b 40 08             	mov    0x8(%eax),%eax
  802509:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80250c:	0f 85 be 00 00 00    	jne    8025d0 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802512:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802516:	75 17                	jne    80252f <alloc_block_BF+0x1f7>
  802518:	83 ec 04             	sub    $0x4,%esp
  80251b:	68 48 38 80 00       	push   $0x803848
  802520:	68 db 00 00 00       	push   $0xdb
  802525:	68 d7 37 80 00       	push   $0x8037d7
  80252a:	e8 26 08 00 00       	call   802d55 <_panic>
  80252f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802532:	8b 00                	mov    (%eax),%eax
  802534:	85 c0                	test   %eax,%eax
  802536:	74 10                	je     802548 <alloc_block_BF+0x210>
  802538:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80253b:	8b 00                	mov    (%eax),%eax
  80253d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802540:	8b 52 04             	mov    0x4(%edx),%edx
  802543:	89 50 04             	mov    %edx,0x4(%eax)
  802546:	eb 0b                	jmp    802553 <alloc_block_BF+0x21b>
  802548:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80254b:	8b 40 04             	mov    0x4(%eax),%eax
  80254e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802553:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802556:	8b 40 04             	mov    0x4(%eax),%eax
  802559:	85 c0                	test   %eax,%eax
  80255b:	74 0f                	je     80256c <alloc_block_BF+0x234>
  80255d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802560:	8b 40 04             	mov    0x4(%eax),%eax
  802563:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802566:	8b 12                	mov    (%edx),%edx
  802568:	89 10                	mov    %edx,(%eax)
  80256a:	eb 0a                	jmp    802576 <alloc_block_BF+0x23e>
  80256c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80256f:	8b 00                	mov    (%eax),%eax
  802571:	a3 48 41 80 00       	mov    %eax,0x804148
  802576:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802579:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80257f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802582:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802589:	a1 54 41 80 00       	mov    0x804154,%eax
  80258e:	48                   	dec    %eax
  80258f:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802594:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802597:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80259a:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  80259d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025a3:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  8025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ac:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8025af:	89 c2                	mov    %eax,%edx
  8025b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b4:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	8b 50 08             	mov    0x8(%eax),%edx
  8025bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c3:	01 c2                	add    %eax,%edx
  8025c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c8:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8025cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ce:	eb 3b                	jmp    80260b <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025d0:	a1 40 41 80 00       	mov    0x804140,%eax
  8025d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025dc:	74 07                	je     8025e5 <alloc_block_BF+0x2ad>
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	8b 00                	mov    (%eax),%eax
  8025e3:	eb 05                	jmp    8025ea <alloc_block_BF+0x2b2>
  8025e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ea:	a3 40 41 80 00       	mov    %eax,0x804140
  8025ef:	a1 40 41 80 00       	mov    0x804140,%eax
  8025f4:	85 c0                	test   %eax,%eax
  8025f6:	0f 85 f8 fe ff ff    	jne    8024f4 <alloc_block_BF+0x1bc>
  8025fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802600:	0f 85 ee fe ff ff    	jne    8024f4 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802606:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80260b:	c9                   	leave  
  80260c:	c3                   	ret    

0080260d <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  80260d:	55                   	push   %ebp
  80260e:	89 e5                	mov    %esp,%ebp
  802610:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802613:	8b 45 08             	mov    0x8(%ebp),%eax
  802616:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802619:	a1 48 41 80 00       	mov    0x804148,%eax
  80261e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802621:	a1 38 41 80 00       	mov    0x804138,%eax
  802626:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802629:	e9 77 01 00 00       	jmp    8027a5 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  80262e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802631:	8b 40 0c             	mov    0xc(%eax),%eax
  802634:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802637:	0f 85 8a 00 00 00    	jne    8026c7 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80263d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802641:	75 17                	jne    80265a <alloc_block_NF+0x4d>
  802643:	83 ec 04             	sub    $0x4,%esp
  802646:	68 48 38 80 00       	push   $0x803848
  80264b:	68 f7 00 00 00       	push   $0xf7
  802650:	68 d7 37 80 00       	push   $0x8037d7
  802655:	e8 fb 06 00 00       	call   802d55 <_panic>
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	8b 00                	mov    (%eax),%eax
  80265f:	85 c0                	test   %eax,%eax
  802661:	74 10                	je     802673 <alloc_block_NF+0x66>
  802663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802666:	8b 00                	mov    (%eax),%eax
  802668:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80266b:	8b 52 04             	mov    0x4(%edx),%edx
  80266e:	89 50 04             	mov    %edx,0x4(%eax)
  802671:	eb 0b                	jmp    80267e <alloc_block_NF+0x71>
  802673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802676:	8b 40 04             	mov    0x4(%eax),%eax
  802679:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80267e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802681:	8b 40 04             	mov    0x4(%eax),%eax
  802684:	85 c0                	test   %eax,%eax
  802686:	74 0f                	je     802697 <alloc_block_NF+0x8a>
  802688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268b:	8b 40 04             	mov    0x4(%eax),%eax
  80268e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802691:	8b 12                	mov    (%edx),%edx
  802693:	89 10                	mov    %edx,(%eax)
  802695:	eb 0a                	jmp    8026a1 <alloc_block_NF+0x94>
  802697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269a:	8b 00                	mov    (%eax),%eax
  80269c:	a3 38 41 80 00       	mov    %eax,0x804138
  8026a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026b4:	a1 44 41 80 00       	mov    0x804144,%eax
  8026b9:	48                   	dec    %eax
  8026ba:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8026bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c2:	e9 11 01 00 00       	jmp    8027d8 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8026cd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026d0:	0f 86 c7 00 00 00    	jbe    80279d <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8026d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026da:	75 17                	jne    8026f3 <alloc_block_NF+0xe6>
  8026dc:	83 ec 04             	sub    $0x4,%esp
  8026df:	68 48 38 80 00       	push   $0x803848
  8026e4:	68 fc 00 00 00       	push   $0xfc
  8026e9:	68 d7 37 80 00       	push   $0x8037d7
  8026ee:	e8 62 06 00 00       	call   802d55 <_panic>
  8026f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f6:	8b 00                	mov    (%eax),%eax
  8026f8:	85 c0                	test   %eax,%eax
  8026fa:	74 10                	je     80270c <alloc_block_NF+0xff>
  8026fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ff:	8b 00                	mov    (%eax),%eax
  802701:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802704:	8b 52 04             	mov    0x4(%edx),%edx
  802707:	89 50 04             	mov    %edx,0x4(%eax)
  80270a:	eb 0b                	jmp    802717 <alloc_block_NF+0x10a>
  80270c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80270f:	8b 40 04             	mov    0x4(%eax),%eax
  802712:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802717:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271a:	8b 40 04             	mov    0x4(%eax),%eax
  80271d:	85 c0                	test   %eax,%eax
  80271f:	74 0f                	je     802730 <alloc_block_NF+0x123>
  802721:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802724:	8b 40 04             	mov    0x4(%eax),%eax
  802727:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80272a:	8b 12                	mov    (%edx),%edx
  80272c:	89 10                	mov    %edx,(%eax)
  80272e:	eb 0a                	jmp    80273a <alloc_block_NF+0x12d>
  802730:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802733:	8b 00                	mov    (%eax),%eax
  802735:	a3 48 41 80 00       	mov    %eax,0x804148
  80273a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802743:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802746:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80274d:	a1 54 41 80 00       	mov    0x804154,%eax
  802752:	48                   	dec    %eax
  802753:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802758:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80275e:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802764:	8b 40 0c             	mov    0xc(%eax),%eax
  802767:	2b 45 f0             	sub    -0x10(%ebp),%eax
  80276a:	89 c2                	mov    %eax,%edx
  80276c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276f:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	8b 40 08             	mov    0x8(%eax),%eax
  802778:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  80277b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277e:	8b 50 08             	mov    0x8(%eax),%edx
  802781:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802784:	8b 40 0c             	mov    0xc(%eax),%eax
  802787:	01 c2                	add    %eax,%edx
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  80278f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802792:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802795:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802798:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279b:	eb 3b                	jmp    8027d8 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80279d:	a1 40 41 80 00       	mov    0x804140,%eax
  8027a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a9:	74 07                	je     8027b2 <alloc_block_NF+0x1a5>
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	8b 00                	mov    (%eax),%eax
  8027b0:	eb 05                	jmp    8027b7 <alloc_block_NF+0x1aa>
  8027b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b7:	a3 40 41 80 00       	mov    %eax,0x804140
  8027bc:	a1 40 41 80 00       	mov    0x804140,%eax
  8027c1:	85 c0                	test   %eax,%eax
  8027c3:	0f 85 65 fe ff ff    	jne    80262e <alloc_block_NF+0x21>
  8027c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027cd:	0f 85 5b fe ff ff    	jne    80262e <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8027d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027d8:	c9                   	leave  
  8027d9:	c3                   	ret    

008027da <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  8027da:	55                   	push   %ebp
  8027db:	89 e5                	mov    %esp,%ebp
  8027dd:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  8027e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  8027ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ed:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  8027f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027f8:	75 17                	jne    802811 <addToAvailMemBlocksList+0x37>
  8027fa:	83 ec 04             	sub    $0x4,%esp
  8027fd:	68 f0 37 80 00       	push   $0x8037f0
  802802:	68 10 01 00 00       	push   $0x110
  802807:	68 d7 37 80 00       	push   $0x8037d7
  80280c:	e8 44 05 00 00       	call   802d55 <_panic>
  802811:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802817:	8b 45 08             	mov    0x8(%ebp),%eax
  80281a:	89 50 04             	mov    %edx,0x4(%eax)
  80281d:	8b 45 08             	mov    0x8(%ebp),%eax
  802820:	8b 40 04             	mov    0x4(%eax),%eax
  802823:	85 c0                	test   %eax,%eax
  802825:	74 0c                	je     802833 <addToAvailMemBlocksList+0x59>
  802827:	a1 4c 41 80 00       	mov    0x80414c,%eax
  80282c:	8b 55 08             	mov    0x8(%ebp),%edx
  80282f:	89 10                	mov    %edx,(%eax)
  802831:	eb 08                	jmp    80283b <addToAvailMemBlocksList+0x61>
  802833:	8b 45 08             	mov    0x8(%ebp),%eax
  802836:	a3 48 41 80 00       	mov    %eax,0x804148
  80283b:	8b 45 08             	mov    0x8(%ebp),%eax
  80283e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802843:	8b 45 08             	mov    0x8(%ebp),%eax
  802846:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80284c:	a1 54 41 80 00       	mov    0x804154,%eax
  802851:	40                   	inc    %eax
  802852:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802857:	90                   	nop
  802858:	c9                   	leave  
  802859:	c3                   	ret    

0080285a <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80285a:	55                   	push   %ebp
  80285b:	89 e5                	mov    %esp,%ebp
  80285d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802860:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802865:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802868:	a1 44 41 80 00       	mov    0x804144,%eax
  80286d:	85 c0                	test   %eax,%eax
  80286f:	75 68                	jne    8028d9 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802871:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802875:	75 17                	jne    80288e <insert_sorted_with_merge_freeList+0x34>
  802877:	83 ec 04             	sub    $0x4,%esp
  80287a:	68 b4 37 80 00       	push   $0x8037b4
  80287f:	68 1a 01 00 00       	push   $0x11a
  802884:	68 d7 37 80 00       	push   $0x8037d7
  802889:	e8 c7 04 00 00       	call   802d55 <_panic>
  80288e:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802894:	8b 45 08             	mov    0x8(%ebp),%eax
  802897:	89 10                	mov    %edx,(%eax)
  802899:	8b 45 08             	mov    0x8(%ebp),%eax
  80289c:	8b 00                	mov    (%eax),%eax
  80289e:	85 c0                	test   %eax,%eax
  8028a0:	74 0d                	je     8028af <insert_sorted_with_merge_freeList+0x55>
  8028a2:	a1 38 41 80 00       	mov    0x804138,%eax
  8028a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8028aa:	89 50 04             	mov    %edx,0x4(%eax)
  8028ad:	eb 08                	jmp    8028b7 <insert_sorted_with_merge_freeList+0x5d>
  8028af:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ba:	a3 38 41 80 00       	mov    %eax,0x804138
  8028bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c9:	a1 44 41 80 00       	mov    0x804144,%eax
  8028ce:	40                   	inc    %eax
  8028cf:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8028d4:	e9 c5 03 00 00       	jmp    802c9e <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  8028d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028dc:	8b 50 08             	mov    0x8(%eax),%edx
  8028df:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e2:	8b 40 08             	mov    0x8(%eax),%eax
  8028e5:	39 c2                	cmp    %eax,%edx
  8028e7:	0f 83 b2 00 00 00    	jae    80299f <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  8028ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f0:	8b 50 08             	mov    0x8(%eax),%edx
  8028f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f9:	01 c2                	add    %eax,%edx
  8028fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fe:	8b 40 08             	mov    0x8(%eax),%eax
  802901:	39 c2                	cmp    %eax,%edx
  802903:	75 27                	jne    80292c <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802905:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802908:	8b 50 0c             	mov    0xc(%eax),%edx
  80290b:	8b 45 08             	mov    0x8(%ebp),%eax
  80290e:	8b 40 0c             	mov    0xc(%eax),%eax
  802911:	01 c2                	add    %eax,%edx
  802913:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802916:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802919:	83 ec 0c             	sub    $0xc,%esp
  80291c:	ff 75 08             	pushl  0x8(%ebp)
  80291f:	e8 b6 fe ff ff       	call   8027da <addToAvailMemBlocksList>
  802924:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802927:	e9 72 03 00 00       	jmp    802c9e <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  80292c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802930:	74 06                	je     802938 <insert_sorted_with_merge_freeList+0xde>
  802932:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802936:	75 17                	jne    80294f <insert_sorted_with_merge_freeList+0xf5>
  802938:	83 ec 04             	sub    $0x4,%esp
  80293b:	68 14 38 80 00       	push   $0x803814
  802940:	68 24 01 00 00       	push   $0x124
  802945:	68 d7 37 80 00       	push   $0x8037d7
  80294a:	e8 06 04 00 00       	call   802d55 <_panic>
  80294f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802952:	8b 10                	mov    (%eax),%edx
  802954:	8b 45 08             	mov    0x8(%ebp),%eax
  802957:	89 10                	mov    %edx,(%eax)
  802959:	8b 45 08             	mov    0x8(%ebp),%eax
  80295c:	8b 00                	mov    (%eax),%eax
  80295e:	85 c0                	test   %eax,%eax
  802960:	74 0b                	je     80296d <insert_sorted_with_merge_freeList+0x113>
  802962:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802965:	8b 00                	mov    (%eax),%eax
  802967:	8b 55 08             	mov    0x8(%ebp),%edx
  80296a:	89 50 04             	mov    %edx,0x4(%eax)
  80296d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802970:	8b 55 08             	mov    0x8(%ebp),%edx
  802973:	89 10                	mov    %edx,(%eax)
  802975:	8b 45 08             	mov    0x8(%ebp),%eax
  802978:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80297b:	89 50 04             	mov    %edx,0x4(%eax)
  80297e:	8b 45 08             	mov    0x8(%ebp),%eax
  802981:	8b 00                	mov    (%eax),%eax
  802983:	85 c0                	test   %eax,%eax
  802985:	75 08                	jne    80298f <insert_sorted_with_merge_freeList+0x135>
  802987:	8b 45 08             	mov    0x8(%ebp),%eax
  80298a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80298f:	a1 44 41 80 00       	mov    0x804144,%eax
  802994:	40                   	inc    %eax
  802995:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80299a:	e9 ff 02 00 00       	jmp    802c9e <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  80299f:	a1 38 41 80 00       	mov    0x804138,%eax
  8029a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a7:	e9 c2 02 00 00       	jmp    802c6e <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  8029ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029af:	8b 50 08             	mov    0x8(%eax),%edx
  8029b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b5:	8b 40 08             	mov    0x8(%eax),%eax
  8029b8:	39 c2                	cmp    %eax,%edx
  8029ba:	0f 86 a6 02 00 00    	jbe    802c66 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	8b 40 04             	mov    0x4(%eax),%eax
  8029c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  8029c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029cd:	0f 85 ba 00 00 00    	jne    802a8d <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8029d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d6:	8b 50 0c             	mov    0xc(%eax),%edx
  8029d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dc:	8b 40 08             	mov    0x8(%eax),%eax
  8029df:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8029e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e4:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8029e7:	39 c2                	cmp    %eax,%edx
  8029e9:	75 33                	jne    802a1e <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  8029eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ee:	8b 50 08             	mov    0x8(%eax),%edx
  8029f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f4:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8029f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fa:	8b 50 0c             	mov    0xc(%eax),%edx
  8029fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802a00:	8b 40 0c             	mov    0xc(%eax),%eax
  802a03:	01 c2                	add    %eax,%edx
  802a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a08:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802a0b:	83 ec 0c             	sub    $0xc,%esp
  802a0e:	ff 75 08             	pushl  0x8(%ebp)
  802a11:	e8 c4 fd ff ff       	call   8027da <addToAvailMemBlocksList>
  802a16:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802a19:	e9 80 02 00 00       	jmp    802c9e <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802a1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a22:	74 06                	je     802a2a <insert_sorted_with_merge_freeList+0x1d0>
  802a24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a28:	75 17                	jne    802a41 <insert_sorted_with_merge_freeList+0x1e7>
  802a2a:	83 ec 04             	sub    $0x4,%esp
  802a2d:	68 68 38 80 00       	push   $0x803868
  802a32:	68 3a 01 00 00       	push   $0x13a
  802a37:	68 d7 37 80 00       	push   $0x8037d7
  802a3c:	e8 14 03 00 00       	call   802d55 <_panic>
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	8b 50 04             	mov    0x4(%eax),%edx
  802a47:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4a:	89 50 04             	mov    %edx,0x4(%eax)
  802a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a53:	89 10                	mov    %edx,(%eax)
  802a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a58:	8b 40 04             	mov    0x4(%eax),%eax
  802a5b:	85 c0                	test   %eax,%eax
  802a5d:	74 0d                	je     802a6c <insert_sorted_with_merge_freeList+0x212>
  802a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a62:	8b 40 04             	mov    0x4(%eax),%eax
  802a65:	8b 55 08             	mov    0x8(%ebp),%edx
  802a68:	89 10                	mov    %edx,(%eax)
  802a6a:	eb 08                	jmp    802a74 <insert_sorted_with_merge_freeList+0x21a>
  802a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6f:	a3 38 41 80 00       	mov    %eax,0x804138
  802a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a77:	8b 55 08             	mov    0x8(%ebp),%edx
  802a7a:	89 50 04             	mov    %edx,0x4(%eax)
  802a7d:	a1 44 41 80 00       	mov    0x804144,%eax
  802a82:	40                   	inc    %eax
  802a83:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802a88:	e9 11 02 00 00       	jmp    802c9e <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802a8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a90:	8b 50 08             	mov    0x8(%eax),%edx
  802a93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a96:	8b 40 0c             	mov    0xc(%eax),%eax
  802a99:	01 c2                	add    %eax,%edx
  802a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa1:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa6:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802aa9:	39 c2                	cmp    %eax,%edx
  802aab:	0f 85 bf 00 00 00    	jne    802b70 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802ab1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab4:	8b 50 0c             	mov    0xc(%eax),%edx
  802ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aba:	8b 40 0c             	mov    0xc(%eax),%eax
  802abd:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac5:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802ac7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aca:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802acd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad1:	75 17                	jne    802aea <insert_sorted_with_merge_freeList+0x290>
  802ad3:	83 ec 04             	sub    $0x4,%esp
  802ad6:	68 48 38 80 00       	push   $0x803848
  802adb:	68 43 01 00 00       	push   $0x143
  802ae0:	68 d7 37 80 00       	push   $0x8037d7
  802ae5:	e8 6b 02 00 00       	call   802d55 <_panic>
  802aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aed:	8b 00                	mov    (%eax),%eax
  802aef:	85 c0                	test   %eax,%eax
  802af1:	74 10                	je     802b03 <insert_sorted_with_merge_freeList+0x2a9>
  802af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af6:	8b 00                	mov    (%eax),%eax
  802af8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802afb:	8b 52 04             	mov    0x4(%edx),%edx
  802afe:	89 50 04             	mov    %edx,0x4(%eax)
  802b01:	eb 0b                	jmp    802b0e <insert_sorted_with_merge_freeList+0x2b4>
  802b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b06:	8b 40 04             	mov    0x4(%eax),%eax
  802b09:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b11:	8b 40 04             	mov    0x4(%eax),%eax
  802b14:	85 c0                	test   %eax,%eax
  802b16:	74 0f                	je     802b27 <insert_sorted_with_merge_freeList+0x2cd>
  802b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1b:	8b 40 04             	mov    0x4(%eax),%eax
  802b1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b21:	8b 12                	mov    (%edx),%edx
  802b23:	89 10                	mov    %edx,(%eax)
  802b25:	eb 0a                	jmp    802b31 <insert_sorted_with_merge_freeList+0x2d7>
  802b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2a:	8b 00                	mov    (%eax),%eax
  802b2c:	a3 38 41 80 00       	mov    %eax,0x804138
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b44:	a1 44 41 80 00       	mov    0x804144,%eax
  802b49:	48                   	dec    %eax
  802b4a:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802b4f:	83 ec 0c             	sub    $0xc,%esp
  802b52:	ff 75 08             	pushl  0x8(%ebp)
  802b55:	e8 80 fc ff ff       	call   8027da <addToAvailMemBlocksList>
  802b5a:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802b5d:	83 ec 0c             	sub    $0xc,%esp
  802b60:	ff 75 f4             	pushl  -0xc(%ebp)
  802b63:	e8 72 fc ff ff       	call   8027da <addToAvailMemBlocksList>
  802b68:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802b6b:	e9 2e 01 00 00       	jmp    802c9e <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802b70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b73:	8b 50 08             	mov    0x8(%eax),%edx
  802b76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b79:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7c:	01 c2                	add    %eax,%edx
  802b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b81:	8b 40 08             	mov    0x8(%eax),%eax
  802b84:	39 c2                	cmp    %eax,%edx
  802b86:	75 27                	jne    802baf <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802b88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8b:	8b 50 0c             	mov    0xc(%eax),%edx
  802b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b91:	8b 40 0c             	mov    0xc(%eax),%eax
  802b94:	01 c2                	add    %eax,%edx
  802b96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b99:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802b9c:	83 ec 0c             	sub    $0xc,%esp
  802b9f:	ff 75 08             	pushl  0x8(%ebp)
  802ba2:	e8 33 fc ff ff       	call   8027da <addToAvailMemBlocksList>
  802ba7:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802baa:	e9 ef 00 00 00       	jmp    802c9e <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802baf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb2:	8b 50 0c             	mov    0xc(%eax),%edx
  802bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb8:	8b 40 08             	mov    0x8(%eax),%eax
  802bbb:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc0:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802bc3:	39 c2                	cmp    %eax,%edx
  802bc5:	75 33                	jne    802bfa <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bca:	8b 50 08             	mov    0x8(%eax),%edx
  802bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd0:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd6:	8b 50 0c             	mov    0xc(%eax),%edx
  802bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdc:	8b 40 0c             	mov    0xc(%eax),%eax
  802bdf:	01 c2                	add    %eax,%edx
  802be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be4:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802be7:	83 ec 0c             	sub    $0xc,%esp
  802bea:	ff 75 08             	pushl  0x8(%ebp)
  802bed:	e8 e8 fb ff ff       	call   8027da <addToAvailMemBlocksList>
  802bf2:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802bf5:	e9 a4 00 00 00       	jmp    802c9e <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802bfa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bfe:	74 06                	je     802c06 <insert_sorted_with_merge_freeList+0x3ac>
  802c00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c04:	75 17                	jne    802c1d <insert_sorted_with_merge_freeList+0x3c3>
  802c06:	83 ec 04             	sub    $0x4,%esp
  802c09:	68 68 38 80 00       	push   $0x803868
  802c0e:	68 56 01 00 00       	push   $0x156
  802c13:	68 d7 37 80 00       	push   $0x8037d7
  802c18:	e8 38 01 00 00       	call   802d55 <_panic>
  802c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c20:	8b 50 04             	mov    0x4(%eax),%edx
  802c23:	8b 45 08             	mov    0x8(%ebp),%eax
  802c26:	89 50 04             	mov    %edx,0x4(%eax)
  802c29:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c2f:	89 10                	mov    %edx,(%eax)
  802c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c34:	8b 40 04             	mov    0x4(%eax),%eax
  802c37:	85 c0                	test   %eax,%eax
  802c39:	74 0d                	je     802c48 <insert_sorted_with_merge_freeList+0x3ee>
  802c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3e:	8b 40 04             	mov    0x4(%eax),%eax
  802c41:	8b 55 08             	mov    0x8(%ebp),%edx
  802c44:	89 10                	mov    %edx,(%eax)
  802c46:	eb 08                	jmp    802c50 <insert_sorted_with_merge_freeList+0x3f6>
  802c48:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4b:	a3 38 41 80 00       	mov    %eax,0x804138
  802c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c53:	8b 55 08             	mov    0x8(%ebp),%edx
  802c56:	89 50 04             	mov    %edx,0x4(%eax)
  802c59:	a1 44 41 80 00       	mov    0x804144,%eax
  802c5e:	40                   	inc    %eax
  802c5f:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802c64:	eb 38                	jmp    802c9e <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802c66:	a1 40 41 80 00       	mov    0x804140,%eax
  802c6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c72:	74 07                	je     802c7b <insert_sorted_with_merge_freeList+0x421>
  802c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c77:	8b 00                	mov    (%eax),%eax
  802c79:	eb 05                	jmp    802c80 <insert_sorted_with_merge_freeList+0x426>
  802c7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c80:	a3 40 41 80 00       	mov    %eax,0x804140
  802c85:	a1 40 41 80 00       	mov    0x804140,%eax
  802c8a:	85 c0                	test   %eax,%eax
  802c8c:	0f 85 1a fd ff ff    	jne    8029ac <insert_sorted_with_merge_freeList+0x152>
  802c92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c96:	0f 85 10 fd ff ff    	jne    8029ac <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802c9c:	eb 00                	jmp    802c9e <insert_sorted_with_merge_freeList+0x444>
  802c9e:	90                   	nop
  802c9f:	c9                   	leave  
  802ca0:	c3                   	ret    

00802ca1 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802ca1:	55                   	push   %ebp
  802ca2:	89 e5                	mov    %esp,%ebp
  802ca4:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802ca7:	8b 55 08             	mov    0x8(%ebp),%edx
  802caa:	89 d0                	mov    %edx,%eax
  802cac:	c1 e0 02             	shl    $0x2,%eax
  802caf:	01 d0                	add    %edx,%eax
  802cb1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802cb8:	01 d0                	add    %edx,%eax
  802cba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802cc1:	01 d0                	add    %edx,%eax
  802cc3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802cca:	01 d0                	add    %edx,%eax
  802ccc:	c1 e0 04             	shl    $0x4,%eax
  802ccf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802cd2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802cd9:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802cdc:	83 ec 0c             	sub    $0xc,%esp
  802cdf:	50                   	push   %eax
  802ce0:	e8 60 ed ff ff       	call   801a45 <sys_get_virtual_time>
  802ce5:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802ce8:	eb 41                	jmp    802d2b <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802cea:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802ced:	83 ec 0c             	sub    $0xc,%esp
  802cf0:	50                   	push   %eax
  802cf1:	e8 4f ed ff ff       	call   801a45 <sys_get_virtual_time>
  802cf6:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802cf9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cfc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cff:	29 c2                	sub    %eax,%edx
  802d01:	89 d0                	mov    %edx,%eax
  802d03:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802d06:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0c:	89 d1                	mov    %edx,%ecx
  802d0e:	29 c1                	sub    %eax,%ecx
  802d10:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802d13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d16:	39 c2                	cmp    %eax,%edx
  802d18:	0f 97 c0             	seta   %al
  802d1b:	0f b6 c0             	movzbl %al,%eax
  802d1e:	29 c1                	sub    %eax,%ecx
  802d20:	89 c8                	mov    %ecx,%eax
  802d22:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802d25:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d28:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d31:	72 b7                	jb     802cea <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802d33:	90                   	nop
  802d34:	c9                   	leave  
  802d35:	c3                   	ret    

00802d36 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802d36:	55                   	push   %ebp
  802d37:	89 e5                	mov    %esp,%ebp
  802d39:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802d3c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802d43:	eb 03                	jmp    802d48 <busy_wait+0x12>
  802d45:	ff 45 fc             	incl   -0x4(%ebp)
  802d48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d4b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d4e:	72 f5                	jb     802d45 <busy_wait+0xf>
	return i;
  802d50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802d53:	c9                   	leave  
  802d54:	c3                   	ret    

00802d55 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802d55:	55                   	push   %ebp
  802d56:	89 e5                	mov    %esp,%ebp
  802d58:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802d5b:	8d 45 10             	lea    0x10(%ebp),%eax
  802d5e:	83 c0 04             	add    $0x4,%eax
  802d61:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802d64:	a1 60 41 80 00       	mov    0x804160,%eax
  802d69:	85 c0                	test   %eax,%eax
  802d6b:	74 16                	je     802d83 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802d6d:	a1 60 41 80 00       	mov    0x804160,%eax
  802d72:	83 ec 08             	sub    $0x8,%esp
  802d75:	50                   	push   %eax
  802d76:	68 a0 38 80 00       	push   $0x8038a0
  802d7b:	e8 fb d5 ff ff       	call   80037b <cprintf>
  802d80:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802d83:	a1 00 40 80 00       	mov    0x804000,%eax
  802d88:	ff 75 0c             	pushl  0xc(%ebp)
  802d8b:	ff 75 08             	pushl  0x8(%ebp)
  802d8e:	50                   	push   %eax
  802d8f:	68 a5 38 80 00       	push   $0x8038a5
  802d94:	e8 e2 d5 ff ff       	call   80037b <cprintf>
  802d99:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802d9c:	8b 45 10             	mov    0x10(%ebp),%eax
  802d9f:	83 ec 08             	sub    $0x8,%esp
  802da2:	ff 75 f4             	pushl  -0xc(%ebp)
  802da5:	50                   	push   %eax
  802da6:	e8 65 d5 ff ff       	call   800310 <vcprintf>
  802dab:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802dae:	83 ec 08             	sub    $0x8,%esp
  802db1:	6a 00                	push   $0x0
  802db3:	68 c1 38 80 00       	push   $0x8038c1
  802db8:	e8 53 d5 ff ff       	call   800310 <vcprintf>
  802dbd:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802dc0:	e8 d4 d4 ff ff       	call   800299 <exit>

	// should not return here
	while (1) ;
  802dc5:	eb fe                	jmp    802dc5 <_panic+0x70>

00802dc7 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802dc7:	55                   	push   %ebp
  802dc8:	89 e5                	mov    %esp,%ebp
  802dca:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802dcd:	a1 20 40 80 00       	mov    0x804020,%eax
  802dd2:	8b 50 74             	mov    0x74(%eax),%edx
  802dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dd8:	39 c2                	cmp    %eax,%edx
  802dda:	74 14                	je     802df0 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802ddc:	83 ec 04             	sub    $0x4,%esp
  802ddf:	68 c4 38 80 00       	push   $0x8038c4
  802de4:	6a 26                	push   $0x26
  802de6:	68 10 39 80 00       	push   $0x803910
  802deb:	e8 65 ff ff ff       	call   802d55 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802df0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802df7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802dfe:	e9 c2 00 00 00       	jmp    802ec5 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  802e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e06:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e10:	01 d0                	add    %edx,%eax
  802e12:	8b 00                	mov    (%eax),%eax
  802e14:	85 c0                	test   %eax,%eax
  802e16:	75 08                	jne    802e20 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  802e18:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802e1b:	e9 a2 00 00 00       	jmp    802ec2 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  802e20:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802e27:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802e2e:	eb 69                	jmp    802e99 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802e30:	a1 20 40 80 00       	mov    0x804020,%eax
  802e35:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802e3b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e3e:	89 d0                	mov    %edx,%eax
  802e40:	01 c0                	add    %eax,%eax
  802e42:	01 d0                	add    %edx,%eax
  802e44:	c1 e0 03             	shl    $0x3,%eax
  802e47:	01 c8                	add    %ecx,%eax
  802e49:	8a 40 04             	mov    0x4(%eax),%al
  802e4c:	84 c0                	test   %al,%al
  802e4e:	75 46                	jne    802e96 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802e50:	a1 20 40 80 00       	mov    0x804020,%eax
  802e55:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802e5b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e5e:	89 d0                	mov    %edx,%eax
  802e60:	01 c0                	add    %eax,%eax
  802e62:	01 d0                	add    %edx,%eax
  802e64:	c1 e0 03             	shl    $0x3,%eax
  802e67:	01 c8                	add    %ecx,%eax
  802e69:	8b 00                	mov    (%eax),%eax
  802e6b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802e6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e71:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802e76:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802e78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802e82:	8b 45 08             	mov    0x8(%ebp),%eax
  802e85:	01 c8                	add    %ecx,%eax
  802e87:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802e89:	39 c2                	cmp    %eax,%edx
  802e8b:	75 09                	jne    802e96 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  802e8d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802e94:	eb 12                	jmp    802ea8 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802e96:	ff 45 e8             	incl   -0x18(%ebp)
  802e99:	a1 20 40 80 00       	mov    0x804020,%eax
  802e9e:	8b 50 74             	mov    0x74(%eax),%edx
  802ea1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea4:	39 c2                	cmp    %eax,%edx
  802ea6:	77 88                	ja     802e30 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802ea8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802eac:	75 14                	jne    802ec2 <CheckWSWithoutLastIndex+0xfb>
			panic(
  802eae:	83 ec 04             	sub    $0x4,%esp
  802eb1:	68 1c 39 80 00       	push   $0x80391c
  802eb6:	6a 3a                	push   $0x3a
  802eb8:	68 10 39 80 00       	push   $0x803910
  802ebd:	e8 93 fe ff ff       	call   802d55 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802ec2:	ff 45 f0             	incl   -0x10(%ebp)
  802ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ecb:	0f 8c 32 ff ff ff    	jl     802e03 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802ed1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802ed8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802edf:	eb 26                	jmp    802f07 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802ee1:	a1 20 40 80 00       	mov    0x804020,%eax
  802ee6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802eec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802eef:	89 d0                	mov    %edx,%eax
  802ef1:	01 c0                	add    %eax,%eax
  802ef3:	01 d0                	add    %edx,%eax
  802ef5:	c1 e0 03             	shl    $0x3,%eax
  802ef8:	01 c8                	add    %ecx,%eax
  802efa:	8a 40 04             	mov    0x4(%eax),%al
  802efd:	3c 01                	cmp    $0x1,%al
  802eff:	75 03                	jne    802f04 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  802f01:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802f04:	ff 45 e0             	incl   -0x20(%ebp)
  802f07:	a1 20 40 80 00       	mov    0x804020,%eax
  802f0c:	8b 50 74             	mov    0x74(%eax),%edx
  802f0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f12:	39 c2                	cmp    %eax,%edx
  802f14:	77 cb                	ja     802ee1 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f19:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f1c:	74 14                	je     802f32 <CheckWSWithoutLastIndex+0x16b>
		panic(
  802f1e:	83 ec 04             	sub    $0x4,%esp
  802f21:	68 70 39 80 00       	push   $0x803970
  802f26:	6a 44                	push   $0x44
  802f28:	68 10 39 80 00       	push   $0x803910
  802f2d:	e8 23 fe ff ff       	call   802d55 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802f32:	90                   	nop
  802f33:	c9                   	leave  
  802f34:	c3                   	ret    
  802f35:	66 90                	xchg   %ax,%ax
  802f37:	90                   	nop

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
